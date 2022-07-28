//
//  HeroesCollectionViewController.swift
//  MarvelHeroFinder
//
//  Created by Kevin Martinez on 3/22/22.
//

import UIKit



private let reuseIdentifier = K.CollectionreusableViewIdentifierFor.heroes
var heroResults: [results] = []
var dataLoaded = false

class HeroesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var heroManager = HeroesManager()
   let searchControll = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchControll.searchResultsUpdater = self
        searchControll.searchBar.delegate = self
        heroManager.delegate = self
        
        // add searchBar to NavegationView
        navigationItem.searchController = searchControll
        
                
        searchControll.searchBar.barStyle = .default
        searchControll.searchBar.autocapitalizationType = .words
        
            
        // Register cell classes
        self.collectionView!.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        // using this to set the text color of the 'Cancel' button since the search bar ignores the global tint color property for some reason
        UISearchBar.appearance().tintColor = UIColor.systemGray5

              //Search bar placeholder text color
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])

            //  Search bar text color
        let textFieldInsideSearchBar = searchControll.searchBar.value(forKey: "searchField") as? UITextField

        textFieldInsideSearchBar?.textColor = UIColor.darkGray
        
        //   Insertion cursor color
        textFieldInsideSearchBar?.tintColor = UIColor.darkGray
        
        textFieldInsideSearchBar?.backgroundColor = UIColor.systemGray5
        

//        // Search bar clear icon
//        UISearchBar.appearance().setImage(UIImage(systemName: "magnifyingglass"), for: .search, state: .normal)
    
    }
    
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        
        if dataLoaded == false {
            heroManager.performRequest()
            dataLoaded = true
        }
    }

    // MARK: - UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
       
        return heroResults.count
        }


    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
    
        cell.heroNameLabel.text = heroResults[indexPath.item].name
        thumnailImageProcesor(indexpath: indexPath.item, imageView: cell.heroImageView)
        
  
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.segueIndentifiesFor.fromHomeScreenToDetailScreen, sender: self)

    }

    
    
    //MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ( view.frame.size.width - (3 * 64) ) / 2
        return CGSize(width: width , height: width + 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10
                            ,left: 20
                            ,bottom: 10
                            ,right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

    //MARK: - prepareForSegue

        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == K.segueIndentifiesFor.fromHomeScreenToDetailScreen {
               
                    
                    let destinationVC = segue.destination as! HeroDescriptionViewController
                    
                    guard let indexpaths = self.collectionView.indexPathsForSelectedItems else {return}
                
                    let indexpath = indexpaths[0].item
                        
                        let SelectedHero = heroResults[indexpath]
                
                destinationVC.characterNameString = SelectedHero.name
                
                if SelectedHero.description == "" {
                    destinationVC.info = "Sorry! no description available for this character"
                }else {
                    destinationVC.info = SelectedHero.description
                }
                
                destinationVC.imageUrlPath = descriptionImagePath(indexpath: indexpath, imageQuality: ImageQualityOpt.fullSizeImages.detail)
            }
        }
        

//MARK: - thumnailImageProcesor method

func thumnailImageProcesor(indexpath: Int, imageView: UIImageView, imageQuality: String = ImageQualityOpt.portraitAspectRatio.incredible) {
    var imageHttp = heroResults[indexpath].thumbnail.path
    let character: Character = "s"
    let addHttps = imageHttp.index(imageHttp.startIndex,offsetBy: 4)
    imageHttp.insert(character, at: addHttps)
    
    
    let finalString =  imageHttp + "/" + imageQuality + "." + heroResults[indexpath].thumbnail.`extension`
    
    
    let URLTransform = URL(string: finalString)!
    DispatchQueue.global().async {
        if let data = try? Data(contentsOf: URLTransform){
            if let image = UIImage(data: data){
                DispatchQueue.main.async {
                   imageView.image = image
                }
            }
        }
    }
}

func descriptionImagePath(indexpath: Int, imageQuality: String = ImageQualityOpt.portraitAspectRatio.incredible) -> String {
    var imageHttp = heroResults[indexpath].thumbnail.path
    let character: Character = "s"
    let addHttps = imageHttp.index(imageHttp.startIndex,offsetBy: 4)
    imageHttp.insert(character, at: addHttps)
    let finalString =  imageHttp + "/" + imageQuality + "." + heroResults[indexpath].thumbnail.`extension`
    return finalString
}
    
    //MARK: - IBActions
    
    @IBAction func goToMarvelWebPage(_ sender: UIBarButtonItem) {
        UIApplication.shared.open(URL (string:  "http://marvel.com" )! as URL, options: [:], completionHandler: nil)
        
    }
    
    
    
    
}

//MARK: - HeroManagerDelegate Extention

extension HeroesCollectionViewController: HeroManagerDelegate {
    func didUpdateHero(_ heroManager: HeroesManager, hero: HeroModel) {
        DispatchQueue.main.async {
            self.loadingIndicator.stopAnimating()
            self.loadingIndicator.hidesWhenStopped = true
              self.collectionView?.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print("error = \(error.localizedDescription)")
    }
}
//MARK: - UISearchResultsUpdating Extention

extension HeroesCollectionViewController:  UISearchResultsUpdating, UISearchBarDelegate{
    
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if var text = searchBar.text {
            heroResults = []
            if text == "Spider Man"{
                text = "Spider-Man"
            }
             heroManager.fetchHero(name: text, limit: 100)
        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        heroResults = []
        heroManager.performRequest(offeset: Int.random(in: 1...1560))
    }
}

