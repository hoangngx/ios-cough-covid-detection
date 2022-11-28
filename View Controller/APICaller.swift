//
//  APICaller.swift
//  CustomLoginDemo
//
//  Created by Hoang Nguyen  on 30/10/2022.
//  Copyright © 2022 Christopher Ching. All rights reserved.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    struct Constants {
        static let topHeadlinesURL = URL(string:  "https://newsapi.org/v2/top-headlines?country=us&category=health&apiKey=a16799a4babb4f9bbfe1222af9ef5ee3")
        static let searchUrlString = "https://newsapi.org/v2/top-headlines?country=us&category=health&apiKey=a16799a4babb4f9bbfe1222af9ef5ee3&q="
    }
    
    private init() {
        
    }
    
    public func getTopStories(completion: @escaping(Result<[Article], Error>) -> Void){
        guard let url = Constants.topHeadlinesURL else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data{
                do{
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    
                    print("Articles: \(result.articles.count)")
                    completion(.success(result.articles))
                }
                catch{
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
    
    public func search(with query: String, completion: @escaping(Result<[Article], Error>) -> Void){
        
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else{
            return
        }
        let urlString = Constants.searchUrlString + query
        guard let url = URL(string: urlString) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data{
                do{
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    
                    print("Articles: \(result.articles.count)")
                    completion(.success(result.articles))
                }
                catch{
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
}

// Models

struct APIResponse: Codable{
    let articles: [Article]
}

struct Article: Codable{
    let source: Source
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String
    
}

struct Source: Codable{
    let name: String
}
