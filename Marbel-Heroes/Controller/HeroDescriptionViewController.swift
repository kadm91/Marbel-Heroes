//
//  ViewController.swift
//  MarvelHeroFinder
//
//  Created by Kevin Martinez on 3/19/22.
//

import UIKit


class HeroDescriptionViewController: UIViewController {
    
    //MARK: - IBOutles
    
    @IBOutlet weak var heroImage: UIImageView!
    @IBOutlet weak var heroDescriptionLabel: UILabel!
    
    @IBOutlet weak var characterName: UILabel!
    @IBOutlet weak var imageLoadingIndicator: UIActivityIndicatorView!
    
    
    //MARK: - Properties
    
    var info: String? = ""
    var imageUrlPath: String? = ""
    var characterNameString: String? = ""
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        characterName.text = characterNameString
        setImageviewFromUrl(url: imageUrlPath, imageView: heroImage)
        heroDescriptionLabel.text = info
    }
    
    //MARK: - Methods
    
    func setImageviewFromUrl(url: String?, imageView: UIImageView){
        
        if let urlPaht = url {
            let URLTransform = URL(string: urlPaht )
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: URLTransform!){
                    if let image = UIImage(data: data){
                        DispatchQueue.main.async {
                            imageView.image = image
                            self.imageLoadingIndicator.stopAnimating()
                            self.imageLoadingIndicator.hidesWhenStopped = true
                        }
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                imageView.image = UIImage(systemName: "person.fill.questionmark")
                self.imageLoadingIndicator.stopAnimating()
                self.imageLoadingIndicator.hidesWhenStopped = true
            }
          
        }
    }
    //MARK: - IBActions
    
    @IBAction func gotoMarvelWebSide(_ sender: UIBarButtonItem) {
        UIApplication.shared.open(URL (string:  "http://marvel.com" )! as URL, options: [:], completionHandler: nil)
    }
    
    
    //MARK: - End of HeroDescriptionViewClass
}
