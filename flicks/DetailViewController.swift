//
//  DetailViewController.swift
//  flicks
//
//  Created by Deep S Randhawa on 2/11/17.
//  Copyright © 2017 Deep S Randhawa. All rights reserved.
//

import UIKit


class DetailViewController: UIViewController {

    // OUTLETS
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    // GLOBAL VARS
    var movie: NSDictionary!
    let baseURL = "http://image.tmdb.org/t/p/w500"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        
        titleLabel.text = movie["title"] as? String
        overviewLabel.text = movie["overview"] as? String
        
        overviewLabel.sizeToFit()

        if let posterPath = movie["poster_path"] as? String {
            let imageURL = URL(string: baseURL + posterPath)
            posterImageView.setImageWith(imageURL!)
        }
        
        // Do any additional setup after loading the view.
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
