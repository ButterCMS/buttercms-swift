//
//  Post.swift
//  ButterCMSSDK
//
//  Created by Martin Srb on 29.07.2021.
//

import Foundation
public struct Post: Codable {
    public var status: Status?
    public var created: Date?
    public var updated: Date?
    public var published: Date?
    public var scheduled: Date?
    public var title: String
    public var slug: String
    public var body: String?
    public var summary: String?
    public var seoTitle: String?
    public var metaDescription: String?
    public var featuredImage: String?
    public var featuredImageAlt: String?
    public var url: String?
    public var author: Author?
    public var tags: [Tag]?
    public var categories: [Category]?
}

public struct PostMeta: Codable {
    public var previousPost: PostSummary?
    public var nextPost: PostSummary?
}

public struct PostSummary: Codable {
    public var slug: String
    public var title: String
    public var featuredImage: String?
}

public enum Status: String, Codable {
    case DRAFT = "draft"
    case PUBLISHED = "published"
    case SCHEDULED = "scheduled"
}

public struct PostResponse: Codable {
    public var meta: PostMeta
    public var data: Post
}

public struct PostsResponse: Codable {
    public var meta: PaginationMeta
    public var data: [Post]
}

