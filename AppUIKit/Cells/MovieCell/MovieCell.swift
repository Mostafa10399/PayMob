//
//  MovieCell.swift
//  PayMob-Task
//
//  Created by Mostafa on 26/04/2025.
//


import UIKit
import CoreKit
import Kingfisher

final public class MovieCell: UITableViewCell, Reusable {
    
    @IBOutlet weak var releaseYearLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet private(set) public weak var thumbnailImage: UIImageView!
    @IBOutlet private(set) public weak var titleLabel: UILabel! {
        didSet {
            titleLabel.numberOfLines = 0
        }
    }
    @IBOutlet private(set) public weak var watchlistIcon: UIImageView! {
        didSet {
            watchlistIcon.image = nil
        }
    }
    
    private(set) public var movieId: Int?
    
    public func configure(with item: MovieListPresentable) {
        self.movieId = item.id
        thumbnailImage.kf.setImage(with: item.thumbnail.isEmpty ? nil : URL(string: item.thumbnail), placeholder: UIImage(resource: .moviePoster))
        titleLabel.text = item.title
        watchlistIcon.image = item.isInWatchlist ? UIImage(resource: .bookmarkActive) : UIImage(resource: .bookmark)
        releaseYearLabel.text = "\(item.year)"
        rateLabel.text = item.movieRate
    }
    
}
