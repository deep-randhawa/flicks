//
//  MoviesViewController.swift
//  flicks
//
//  Created by Deep S Randhawa on 1/30/17.
//  Copyright © 2017 Deep S Randhawa. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // OUTLETS
    @IBOutlet weak var tableView: UITableView!
    
    // GLOBAL VARS
    var movies: [NSDictionary]?
    var endpoint = "now_playing"
    let baseURL = "http://image.tmdb.org/t/p/w500"
    let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.

        let refreshControl = UIRefreshControl()
        
        // Network Request to pull movies
        MBProgressHUD.showAdded(to: self.view, animated: true)
        moviesNetworkRequest(refreshControl)
        
        // setup refreshControl
        refreshControl.addTarget(self, action: #selector(moviesNetworkRequest(_:)), for: UIControlEvents.valueChanged)
        self.tableView.insertSubview(refreshControl, at: 0)
    }
    
    func moviesNetworkRequest(_ refreshControl: UIRefreshControl) {
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    self.movies = dataDictionary["results"] as? [NSDictionary]
                    self.tableView.reloadData()
                    refreshControl.endRefreshing()
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            }
        }
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = self.movies {
            return movies.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        let movie = self.movies![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        if let posterPath = movie["poster_path"] as? String {
            let imageURL = URL(string: baseURL + posterPath)
            cell.imageView?.setImageWith(imageURL!)
            // TODO: Auto-update imageView when image is downloaded
        }
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        
        cell.selectionStyle = .blue
        
        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let senderCell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: senderCell)
        let movie = movies![indexPath!.row]
        
        let detailViewController = segue.destination as! DetailViewController
        detailViewController.movie = movie
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

}
