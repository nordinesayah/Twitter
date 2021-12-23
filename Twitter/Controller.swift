//
//  Controller.swift
//  Twitter
//
//  Created by Nordine Sayah on 27/09/2018.
//  Copyright © 2018 Nordine Sayah. All rights reserved.
//

import Foundation

class APIController {
    
    weak var delegate: APITwitterDelegate?
    let token: String = ""
    
    init(delegate: APITwitterDelegate?, token: String) {
        self.delegate = delegate
    }
    
    func requesTwitter(content: String) {
        let q = content.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        let url = URL(string: "https://api.twitter.com/1.1/search/tweets.json?q=\(q)&count=100&lang=fr&result_type=recent")
        
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "GET"
        request.setValue("Bearer " + Access.accessToken, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            (data, response, error) in
            print(response ?? "RESPONSE IS NIL")
            if let err = error {
                print(err)
            } else if let d = data {
                do{
                    if let dic : NSDictionary = try JSONSerialization.jsonObject(with: d, options: []) as? NSDictionary{
                        self.processResult(dic: dic)
                    }
                }
                catch (let err){
                    self.delegate?.errorCase(error: err as NSError)
                    print(err)
                }
            }
        }
        task.resume()
    }
    
    func processResult(dic: NSDictionary){
        var tweets: [Tweet] = []
        var nameT = String()
        var textT = String()
        var dateT = String()
        
        if let tweetsD: [NSDictionary] = dic["statuses"] as? [NSDictionary] {
            for tweet in tweetsD {
                if let date : String = tweet["created_at"] as? String{
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "E MMM dd HH:mm:ss Z yyyy"
                    if let date = dateFormatter.date(from: date) {
                        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
                        let newDate = dateFormatter.string(from: date)
                        dateT = newDate
                    }
                }
                if let text : String = tweet["text"] as? String{
                    textT = text
                }
                if let user : [String : Any] = tweet["user"] as? [String : Any] {
                    if let name : String = user["name"] as? String{
                        nameT = name
                    }
                }
                tweets.append(Tweet(name: nameT, text: textT, date: dateT))
            }
        }
        self.delegate?.treatTweet(tweets: tweets)
    }
}
