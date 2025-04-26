//
//  HomeRootViewController.swift
//  PayMob-Task
//
//  Created by Mostafa on 26/04/2025.
//

import UIKit
import AppUIKit
import CoreKit
import Combine
import CombineCocoa

public class HomeRootViewController: NiblessViewController {

    // MARK: - Properties
    
    private let viewModel: HomeRootViewModel
    private let customView: HomeRootView
    // DataSource & DataSourceSnapShot TypeAlias
    var list: [MovieListPresentable] = []
    typealias DataSource = UITableViewDiffableDataSource<String, MovieListPresentable>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<String, MovieListPresentable>
        
    // DataSource & DataSourceSnapShot
    private lazy var datasource = makeDataSource()
    private var datasourceSnapShot = DataSourceSnapshot()

    // State
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Methods
    init(view: HomeRootView, viewModel: HomeRootViewModel) {
        self.viewModel = viewModel
        self.customView = view
        super.init()
    }

    override public func loadView() {
        view = customView
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        observeErrorMessages()
        bindViewModel()
        customView.tableView.didSelectRowPublisher.receive(subscriber: viewModel.selectedItemSubscriber)
        customView.tableView.willDisplayCellPublisher
            .sink { [weak self] cell, indexPath in
                self?.viewModel.currentDisplayedItemSubject.send(indexPath.row)
            }
            .store(in: &cancellables)
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Appeared")
        
    }
    
    private func bindViewModel() {
        viewModel.list
            .receive(on: DispatchQueue.main)
            .sink { [weak self] movieSections in
                guard let self = self else { return }
                self.list = movieSections
                self.updateSnapshot(with: movieSections)
            }
            .store(in: &cancellables)
    }
    
    private func observeErrorMessages() {
        viewModel.errorMessagesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self = self else { return }
                self.present(
                    errorMessage: $0,
                    withPresentationState: self.viewModel.errorPresentation
                )
            }
            .store(in: &cancellables)
    }
}

// MARK: - Data Source Management
extension HomeRootViewController {
    private func makeDataSource() -> DataSource {
        return UITableViewDiffableDataSource(tableView: customView.tableView) { tableView, indexPath, movie in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as? MovieCell else {
                return UITableViewCell()
            }
            cell.configure(with: movie)
            return cell
        }
    }
    
    private func updateSnapshot(with movies: [MovieListPresentable]) {
        var snapshot = DataSourceSnapshot()
        snapshot.appendSections(["Main"])
        snapshot.appendItems(movies, toSection: "Main")
        datasource.apply(snapshot, animatingDifferences: true)
    }
}


