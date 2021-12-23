//
//  ViewController.swift
//  Twitter
//
//  Created by Nordine Sayah on 27/09/2018.
//  Copyright © 2018 Nordine Sayah. All rights reserved.
//

import UIKit

protocol APITwitterDelegate: AnyObject {
    func treatTweet(tweets: [Tweet])
    func errorCase(error: NSError)
}

class ViewController: UIViewController, UITableViewDataSource, UITextFieldDelegate, APITwitterDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    
    var Tweets : [Tweet] = []
    var TwitterCtrl : APIController?
    var content = "ecole 42"
    let url = URL(string: "https://api.twitter.com/oauth2/token")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorInset = .zero
        
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("Basic " + Access.BEARER, forHTTPHeaderField: "Authorization")
        request.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = "grant_type=client_credentials".data(using: String.Encoding.utf8)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            print(response ?? "RESPONSE IS NIL")
            if let err = error {
                print(err)
            } else if let d = data {
                do {
                    if let dic : NSDictionary = try JSONSerialization.jsonObject(with: d, options: []) as? NSDictionary{
                        self.retrieveToken(myDic :dic)
                        self.TwitterCtrl = APIController(delegate: self, token: Access.accessToken)
                        self.TwitterCtrl?.requesTwitter(content: self.content)
                    }
                }
                catch (let err) {
                    print(err)
                }
            }
        }
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func treatTweet(tweets: [Tweet]) {
        self.Tweets = tweets
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func errorCase(error: NSError) {
        print("An error has occured : \(error)")
        let alert = UIAlertController(title: "Error", message: "No match for this request", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    
    func retrieveToken(myDic: NSDictionary) {
        Access.accessToken = myDic.value(forKey: "access_token") as! String
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "goFetchTweet"), object: nil)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        content = textField.text!
        textField.resignFirstResponder()
        self.TwitterCtrl?.requesTwitter(content: self.content)
        tableView.reloadData()
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : TableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "tweetCell") as! TableViewCell
        cell.userName.text = self.Tweets[indexPath.row].name
        cell.date.text = self.Tweets[indexPath.row].date
        cell.tweet.text = self.Tweets[indexPath.row].text
        
        return cell
    }
    
    func tableView(tableView: UITableView,heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return UITableView.automaticDimension
    }
}
