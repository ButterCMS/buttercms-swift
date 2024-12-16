//
//  Page.swift
//  ButterCMSSDK
//
//  Created by Martin Srb on 16.08.2021.
//

import Foundation

public enum PageStatus: String, Codable {
    case DRAFT = "draft"
    case PUBLISHED = "published"
    case SCHEDULED = "scheduled"
}

public struct Page<T:Codable>: Codable {
    public var slug: String
    public var name: String
    public var published: Date?
    public var updated: Date?
    public var pageType: String?
    public var fields: T
    public var status: PageStatus?
    public var scheduled: Date?
}

public struct PageResponse<T:Codable>: Codable {
    public var data: Page<T>
}

public struct PagesResponse<T:Codable>: Codable {
    public var meta: PaginationMeta
    public var data: [Page<T>]
}

