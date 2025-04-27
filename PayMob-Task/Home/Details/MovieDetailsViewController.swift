//
//  MovieDetailsViewController.swift
//  PayMob-Task
//
//  Created by Mostafa on 26/04/2025.
//

import Combine
import UIKit
import CombineCocoa
import AppUIKit
import CoreKit

public class MovieDetailsViewController: NiblessViewController {
    
    // MARK: - Properties
    
    private let viewModel: MovieDetailsViewModel
    private let customView: MovieDetailsView
    
    // DataSource & DataSourceSnapShot TypeAlias
    typealias DataSource = UITableViewDiffableDataSource<String, MovieDetailsPresentable>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<String, MovieDetailsPresentable>
    
    // DataSource & DataSourceSnapShot
    private lazy var datasource = makeDataSource()
    private var datasourceSnapShot = DataSourceSnapshot()
    
    // State
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Methods
    init(view: MovieDetailsView, viewModel: MovieDetailsViewModel) {
        self.viewModel = viewModel
        self.customView = view
        super.init()
    }
    
    override public func loadView() {
        view = customView
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        title = "Movie Details"
        observeErrorMessages()
        bindViewModel()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.getData()
    }
    
    private func bindViewModel() {
        viewModel.list
            .receive(on: DispatchQueue.main)
            .sink { [weak self] movieDetails in
                guard let strongSelf = self, let movie = movieDetails else { return }
                strongSelf.updateSnapshot(with: movie)
            }
            .store(in: &cancellables)
    }
    
    private func updateSnapshot(with movieDetails: MovieDetailsPresentable) {
        var snapshot = DataSourceSnapshot()
        snapshot.appendSections(["Main"])
        snapshot.appendItems([movieDetails], toSection: "Main")
        datasource.apply(snapshot, animatingDifferences: false)
    }
    
    private func observeErrorMessages() {
        viewModel
            .errorMessagesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.present(
                    errorMessage: $0,
                    withPresentationState: self?.viewModel.errorPresentation
                )
            }
            .store(in: &cancellables)
    }
}

extension MovieDetailsViewController {
    // MARK: - Data Source
    private func makeDataSource() -> DataSource {
        return DataSource(tableView: customView.tableView) {
            tableView,
            indexPath,
            movie in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieDetailsCell", for: indexPath) as? MovieDetailsCell else {
                return UITableViewCell()
            }
            cell.configure(with: movie)
            cell.watchlistButton.addTarget(
                self.viewModel,
                action: #selector(MovieDetailsViewModel.toggleWatchlist),
                for: .touchUpInside
            )
            return cell
        }
    }
}
