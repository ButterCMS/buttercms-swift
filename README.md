# ButterCMSSDK
SDK for ButterCMS API.

## Documentation

For a comprehensive list of examples, check out the [API documentation](https://buttercms.com/docs/api/).

## Installation

### Swift Package Manager: 
1) open XCode->File->Add Package
2) search buttercms-swift
3) amend dependency if required 
4) click Add package 
    
### CocoaPods
1) Install CocoaPods if not installed already
```
$ brew install cocoapods
``` 

2) Create a Podfile in the root directory of your project
```
$ pod init
```
3) Open generated Podfile, for example
```
$ open -a Xcode Podfile
```
4) Update podfile
```
target 'YourAppName' do
  use_frameworks!
pod 'ButterCMSSDK', '1.0.7'
end
```
5) Install ButterCMS pod
```
$ pod install
```

## Usage
To get started with the Butter API, instantiate the ButterCMSClient with the API key found in the [Butter Admin Settings](https://buttercms.com/settings/). 
 
```
import ButterCMSSDK
var butter = ButterCMSClient(apiKey: "YOUR_API_KEY")
```

Given the client is based on URLSession - meaning, in case you need more custom setting for URLSession you can pass one into constructor:

```
import ButterCMSSDK
var butter = ButterCMSClient(apiKey: "YOUR_API_KEY", urlSession: yourURLSession)
```

Since version 1.0.9 the SDK allows to switch ON/OFF the preview mode globaly. If sent ON all APIs which are using the .preview 
parameter will inherently have ti set to .preview(value: 1) by default. 

```
import ButterCMSSDK
var butter = ButterCMSClient(apiKey: "YOUR_API_KEY", previewMode=true)
```
  
On particular API level (e.g. getPosts) this global setting can be overwritten following way:

```
butter.getPosts(parameters: [ .preview(value: 0)]) { result in 
   .... 
}
```

In can be also changed later on the butter instance level:
```
butter.previewMode = false 
```
 

## APIs

All APIs are asynchronous and expects a completion() as a parameter. The completion() is called when the asynchronous call is finished. The completion() takes respective Response or Error encapsulated in the Result object as a parameter.

API may take additional array of parameters which specify either what data shall be returned or how they shall be returned. Check [Butter API doc](https://buttercms.com/docs/api/) for additional details. Every API parameters has its respective Enum listing allowed parameters and their value types. For example: 

```
public enum PostsParameters: Parameters {
    case preview(value: Int)
    case page(value: Int)
    case pageSize(value: Int)
    case excludeBody
    case authorSlug(value: String)
    case categorySlug(value: String)
    case tagSlug(value: String)
}
```
XCode can then suggest appropriate parameters as you type your code.

Typical way how to call an API is as follows:
```
import ButterCMSSDK
var butter = ButterCMSClient(apiKey: "YOUR_API_KEY")
butter.getPosts(parameters: [
        .preview(value: 1),
        .excludeBody,
        .page(value: 1),
        .pageSize(value: 10)
            ]) { result in
        switch result {
        case .success(let posts):
            //Do something on success
            print("Count: \(posts.meta.count)")
            posts.data.compactMap() { print("Post: \($0.title)") }
        case .failure(let error):
            //Do something on failure
            print("getPost failed with Error: \(error)")
        }
}
```

### Blog Post APIs
#### Posts
```
getPost(slug: String, completion: @escaping (Result<PostResponse, Error>) -> Void)
```
```
getPosts(parameters: [PostsParameters] = [], completion: @escaping (Result<PostsResponse, Error>) -> Void)
```
```
searchPosts(parameters: [PostSearchParameters] = [], completion: @escaping (Result<PostsResponse, Error>) -> Void)
```
#### Authors
```
getAuthor(slug: String, parameters: [AuthorParameters] = [], completion: @escaping (Result<AuthorResponse, Error>) -> Void)
```
```
getAuthors(parameters: [AuthorParameters] = [], completion: @escaping (Result<AuthorsResponse, Error>) -> Void)
```

#### Categories
```
getCategory(slug: String, parameters: [CategoryParameters] = [], completion: @escaping (Result<CategoryResponse, Error>)
```
```
getCategories(parameters: [CategoryParameters] = [], completion: @escaping (Result<CategoriesResponse, Error>) -> Void)
```

#### Tags
```
getTag(slug: String, parameters: [TagParameters] = [], completion: @escaping (Result<TagResponse, Error>) -> Void)
```
```
getTags(parameters: [TagParameters] = [], completion: @escaping (Result<TagsResponse, Error>) -> Void)
```

#### Feeds
```
getFeeds(name: String, parameters: [FeedsParameters] = [], completion: @escaping (Result<FeedResponse, Error>) -> Void)
```

### Pages API
The Pages in Butter CMS has configurable schema. See [ButterCMS doc](https://buttercms.com/kb/creating-editing-and-deleting-pages-and-page-types#creatingapage) for details how to create page. The schema defines fileds which can exist on the page. Individual fields can be of basic types like Strings as well as custom Structs or Classes. The SDK requires you to model the Page shema as a Codable Struct and pass it to getPages API. This allows the SDK to deserialize the page data for you. 

ButerCMS also provides a concept of Page types and you can get all pages of the same type by getPages() API. To read more about the Page types refer to [ButterCMS doc](https://buttercms.com/kb/creating-editing-and-deleting-pages-and-page-types#creatingapagetype).

The API page methods has following prescription:
```
getPage<T: Decodable>(slug: String, parameters: [PageParameters] = [], pageTypeSlug: String, type: T.Type, completion: @escaping (Result<PageResponse<T>, Error>) -> Void)
```
```
public func searchPages<T: Decodable>(parameters: [PageSearchParameters], type: T.Type, completion: @escaping (Result<PagesResponse<T>, Error>) -> Void)
```
```
getPages<T: Decodable>(parameters: [PagesParameters] = [], pageTypeSlug: String, type: T.Type, completion: @escaping (Result<PagesResponse<T>, Error>) -> Void)
```

The ButterCMS account came equiped with the Case Study page type which can be modeled following way:
```
private struct CaseStudyPageFields: Codable {
    var title: String
    var content: String
    var industry: String
    var subindustry: String
    var featuredImage: String
    var reviewer: String
    var studyDate: Date
}
```

And here is how it can be used to get pages with method searchPages:
```
butter.searchPages(parameters: [
                            .query(value: "Automotive"),
                            .pageType(value: "case_studies"),
                            .locale(value: "en"),
                            .page(value: 1),
                            .pageSize(value: 10)
                            ], type: CaseStudyPageFields.self) { result in
                                    switch result {
                                    case .success(let pages):
                                        .....
                                    case .failure(let error):
                                        .....
                                    }
}
```

### Collection API
Similar as Pages the Collections has also configurable schema. See [ButterCMS doc](https://buttercms.com/kb/creating-editing-and-deleting-collections#creatingacollection) for  more details. The schema again define fields which composes the collection item. The SDK requires you to model the collection item as a class an provide it as a parameter to the API.  The collection item class must implement the CollectionItem protocol.  

```
private class FaqItem: CollectionItem {
    var meta: CollectionItemMeta
    var question: String = ""
    var answer: String = ""
}

butter.getCollection(slug: "faq", type: FaqItem.self) { result in
    // do something with the result
}
```

## iOS Sample application
 Here you can download the sample application:
 https://github.com/ButterCMS/buttercms-ios.git 
 git@github.com:ButterCMS/buttercms-ios.git
 

