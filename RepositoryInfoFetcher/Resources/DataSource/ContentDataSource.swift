//
//  ContentDataSource.swift
//  RepositoryInfoFetcher
//
//  Created by CM on 12/11/2022.
//

import Foundation
import UIKit

class ContentDataSource {
    static func imageItems() -> [UIImage] {
        return [ UIImage(imageLiteralResourceName: "githubIcon"), UIImage(imageLiteralResourceName: "bitbucketIcon")]
    }
}
