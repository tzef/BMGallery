//
//  BMGalleryTransitioningDestination.swift
//  BMGallery
//
//  Created by LEE ZHE YU on 2019/6/23.
//

public protocol BMGalleryTransitioningDestination where Self: UIViewController {
    var sourceBMGallery: BMGallery? { get }
}
