//
//  TrailerViewController.swift
//  W1A-Flix
//
//  Created by Melissa Phuong Nguyen on 2/7/18.
//  Copyright © 2018 Melissa Phuong Nguyen. All rights reserved.
//

import UIKit
import WebKit

class TrailerViewController: UIViewController, WKUIDelegate {

    
    @IBOutlet weak var trailerView: WKWebView!
    
    var movie: [[String: Any]] = []
    var movieVid: [[String: Any]] = []
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        trailerView = WKWebView(frame: .zero, configuration: webConfiguration)
        trailerView.uiDelegate = self
        view = trailerView
    }
    
    override func viewDidLoad() {
        
//        print("trailer Movie", self.movie)
        super.viewDidLoad()
        
        fetchMovie()
        
        
    }

    
    func fetchMovie(){
//        activityIndicator.startAnimating()
        print("fetching movie")
        let urlBaseStart = "https://api.themoviedb.org/3/movie/"
        let urlBaseEnd = "/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US"
        print ("fetching movie" , self.movie)
        if  let currentMovie = self.movie as? [[String: Any]]  {
            let movieID = currentMovie[0]["id"]!
            let movieIDString: String = "\(movieID)"
            print("sucessfully get movieID back", movieID)
            let trailerURL = urlBaseStart + movieIDString + urlBaseEnd
            print("trailerURL", trailerURL )
            let url = URL(string: trailerURL)!
            let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
            let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
            let task = session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error", error.localizedDescription)
                    //                self.present(self.alertController, animated: true)
                } else if let data = data {
                    print("getting data")
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    print("dataDictionary", dataDictionary)
                    let movie = dataDictionary["results"] as! [[String: Any]]
                    let trailerbaseURL = "https://www.youtube.com/watch?v="
                    let movieKey = movie[0]["key"]!
                    let movieKeyString: String = "\(movieKey)"
                    let vidURL = trailerbaseURL + movieKeyString
                    print("vidURL", vidURL)
                    let myURL = URL(string: vidURL)
                    let myRequest = URLRequest(url: myURL!)
                    self.trailerView.load(myRequest)
                    self.trailerView.reload()
                    //                self.refreshControl.endRefreshing()
                    //                self.activityIndicator.stopAnimating()
                }
            }
            task.resume()
        }
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
