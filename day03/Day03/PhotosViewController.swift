//
//  PhotosViewController.swift
//  Day03
//
//  Created by Simon GAUDIN on 1/11/18.
//  Copyright © 2018 Simon GAUDIN. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collView: UICollectionView!
    
    let urlTab: [URL] =
    [
        URL(string: "https://apod.nasa.gov/apod/image/1801/RCW114_FBcambell.jpg")!,
        URL(string: "https://apod.nasa.gov/apod/image/1801/c2016_r2_2018_01_07dpjjc.jpg")!,
        URL(string: "https://apod.nasa.gov/apod/image/1801/Arp243_Hubble_3978.jpg")!,
        URL(string: "https://apod.nasa.gov/apod/image/1801/NGC7027_HubbleSchmidt_960.jpg")!,
    ]
    
    var errorTab: [String] = []
    
    var selectedImg: UIImage?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.collView.delegate = self
        self.collView.dataSource = self
        loadedPictures = 0
        UIApplication.shared.isNetworkActivityIndicatorVisible = true;
        
        DispatchQueue.global().async
        {
            while (true)
            {
                if loadedPictures == self.urlTab.count
                {
                    DispatchQueue.main.async
                    {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false;
                        if self.errorTab.count != 0
                        {
                            var strError = "\(self.errorTab.count) errors were encountered :\n\n"
                            
                            for err in self.errorTab
                            {
                                strError.append("\(err)\n\n")
                            }
                            self.showAlert(errorMsg: strError)
                        }
                    }
                    break
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    func showAlert(errorMsg: String)
    {
        let alertController = UIAlertController(title: "Error", message: errorMsg, preferredStyle: UIAlertControllerStyle.alert)
        let dismissAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        
        alertController.addAction(dismissAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urlTab.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collView.dequeueReusableCell(withReuseIdentifier: "picCell", for: indexPath) as! CollectionViewCell
        
        cell.activityIndicator.startAnimating()
        
        let urlImg = self.urlTab[indexPath.row]
        
        DispatchQueue.global(qos: .utility).async
        {
            let session = URLSession(configuration: .default)
            
            let dlPicTask = session.dataTask(with: urlImg) { (data, response, error) in
                
                if let _ = error
                {
                    self.errorTab.append("Download impossible for image \(urlImg)\nCheck for the URL's validity");
                    cell.dlError = true
                    
                }
                else
                {
                    if let _ = response as? HTTPURLResponse
                    {
                        if let imgData = data
                        {
                            if let _ = UIImage(data: imgData)
                            {
                                cell.img = UIImage(data: imgData)!
                            }
                            else { self.errorTab.append("No image found at URL \(urlImg)"); cell.dlError = true }
                        }
                        else { self.errorTab.append("No image found at URL \(urlImg)"); cell.dlError = true }
                    }
                    else { self.errorTab.append("No response received from URL \(urlImg)"); cell.dlError = true }
                }
            }
            
            dlPicTask.resume()
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "zoomSegue"
        {
            if let cell = sender as! CollectionViewCell?
            {
                let zoomVC = segue.destination as! ZoomViewController
            
                zoomVC.img = cell.img
            }
        }
    }
    
}
