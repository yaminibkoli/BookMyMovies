//
//  ViewController.swift
//  BookMyMovies
//


import UIKit

class ViewController: UIViewController,UICollectionViewDelegateFlowLayout ,UICollectionViewDataSource,UICollectionViewDelegate,UITextFieldDelegate{
    private let spacing:CGFloat = 16.0
    @IBOutlet weak var CollectionView: UICollectionView!
    @IBOutlet weak var SortSegment: UISegmentedControl!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var txtSortBy: UITextField!
    var indexkey:String = ""
    var row:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        var listurl =  "https://api.themoviedb.org/3/trending/movie/day?api_key=a6f3c06992e5612755f1003897ee65a7&page=1"
        if(InternetCheck()) {
            Utils.showActivityIndicator(view: view, targetVC: self)
            jsonParsingFromURL(url: listurl)
            SetCollectionItem()
            CollectionView.delegate = self
            CollectionView.dataSource = self
            modalPresentationStyle = .fullScreen
            modalTransitionStyle = .crossDissolve
            SortSegment.selectedSegmentIndex = 2
            Utils.hideActivityIndicator(view: view)
        }
        txtSearch.delegate = self
        txtSearch.leftViewMode = UITextField.ViewMode.always
        txtSearch.leftViewMode = .always
        txtSearch.leftViewMode = UITextField.ViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let image = UIImage(named: "searchIcon.png")
        imageView.image = image
        txtSearch.leftView = imageView
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       if(!InternetCheck()) {
            DisplayNoInternetAlert()
       }
    }
    func InternetCheck() -> Bool {
        let hostname = "google.com"
        let hostinfo = gethostbyname2(hostname, AF_INET6)
        if hostinfo != nil {
            return true // internet available
        }
      return false
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
      if (textField.tag == 2) {
                return false;
      }
      return true;
   }
   func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       var updatedTextString : NSString = textField.text! as NSString
       updatedTextString = updatedTextString.replacingCharacters(in: range, with: string) as NSString
       var url:String
       if(InternetCheck()) {
       if(updatedTextString == "" || updatedTextString == nil )
       {
        url =  "https://api.themoviedb.org/3/trending/movie/day?api_key=a6f3c06992e5612755f1003897ee65a7&page=1"
        SortSegment.selectedSegmentIndex = 2
        }
        else{
                url = "https://api.themoviedb.org/3/search/movie?api_key=a6f3c06992e5612755f1003897ee65a7&query=" + (updatedTextString as String)
        }
        Utils.showActivityIndicator(view: view, targetVC: self)
        jsonParsingFromURL(url: url)
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func viewWillAppear(_ animated: Bool) {
        modalPresentationStyle = .fullScreen
        modalTransitionStyle = .crossDissolve
    }
    override open var shouldAutorotate: Bool {
       return false
    }
    // Specify the orientation.
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
       return .portrait
    }
   //pasring funtion to parse
    func jsonParsingFromURL (url: String) {
       let url = NSURL(string: url)
        if(url != nil){
       let request = NSURLRequest(url: url! as URL)
       NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main) {(response, data, error) in
           self.startParsing(data: data! as NSData)
            }
       }
        Utils.hideActivityIndicator(view: view)
   }
   func startParsing(data :NSData)
   {
       //fetching all data
    let dict: NSDictionary!=(try! JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? NSDictionary
       
       //fetching data which present in results
       let results = dict["results"]
    
       //fetching titles from result & bind the data to cell accordingly
        ModelData.shared.Title.removeAll()
        ModelData.shared.Image.removeAll()
        ModelData.shared.Rating.removeAll()
        ModelData.shared.ReleaseDate.removeAll()
       for i in results as! [AnyObject]{
        let title = i["original_title"] as? String
        ModelData.shared.Title.append(title  ?? "Blank")
        let imageUrl =   i["poster_path"]as? String
        ModelData.shared.Image.append(imageUrl ?? "Blank" )
        let rating = i["vote_average"]as? Double
        ModelData.shared.Rating.append(rating  ?? 0.0)
        let releasedate = i["release_date"]as? String
        ModelData.shared.ReleaseDate.append(releasedate  ?? "Blank")
        CollectionView.reloadData()
        Utils.hideActivityIndicator(view: view)
       }
   }
    func SetCollectionItem(){
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        self.CollectionView?.collectionViewLayout = layout
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow:CGFloat = 2
        let spacingBetweenCells:CGFloat = 16

        let totalSpacing = (2 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row

        if let collection = self.CollectionView{
            let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow
            return CGSize(width: width, height: width+30)
        }else{
            return CGSize(width: 0, height: 0)
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ModelData.shared.Title.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellId", for: indexPath as IndexPath)as! MoviesCollectionViewCell
        cell.lblTitle.text = ModelData.shared.Title[indexPath.row]
        if ( ModelData.shared.Image[indexPath.row] == "Blank")
        {
            ModelData.shared.Image[indexPath.row] =  "/cMYQJOBRa0u44RIMYqXkjAOWYDy.jpg"
        }
       var path = "https://image.tmdb.org/t/p/w500/" + ModelData.shared.Image[indexPath.row]
       let url = URL(string: path)
       let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        cell.ImageView.image  = UIImage(data: data!)
        cell.layer.cornerRadius = 8
        cell.contentView.layer.cornerRadius = 2.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        row = indexPath.row
        indexkey = ModelData.shared.Title[indexPath.row]
        performSegue(withIdentifier: "SegueID", sender: self)
    }
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var vc = segue.destination as! MovieDetailViewController
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        if let indexPath = self.CollectionView.indexPathsForSelectedItems {
        let controller = segue.destination as! MovieDetailViewController
        vc.Title  =  ModelData.shared.Title[row]
        vc.RatingM = ModelData.shared.Rating[row]
        vc.ReleaseDateM = ModelData.shared.ReleaseDate[row]
        vc.image =  "https://image.tmdb.org/t/p/w500/" + ModelData.shared.Image[row]
        }
    }
    func DisplayNoInternetAlert(){
        let alertController = UIAlertController(title: "BookMyMovies", message: "Please check your internet connection", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    @IBAction func SortSegment(_ sender: Any) {
        if(InternetCheck()) {
            var url1:String
            Utils.showActivityIndicator(view: view, targetVC: self)
                switch SortSegment.selectedSegmentIndex {
                case 0:
                url1 = "https://api.themoviedb.org/3/movie/popular?api_key=a6f3c06992e5612755f1003897ee65a7&language=en-US&page=2&region=US"
                jsonParsingFromURL(url: url1)
                case 1:
                url1 = "https://api.themoviedb.org/3/movie/top_rated?api_key=a6f3c06992e5612755f1003897ee65a7&language=en-US&page=1&region=US"
                jsonParsingFromURL(url: url1)
                case 2:
                url1 = "https://api.themoviedb.org/3/trending/movie/day?api_key=a6f3c06992e5612755f1003897ee65a7&page=1"
                jsonParsingFromURL(url: url1)
                default:
                break;
                }
        }
        else {
            DisplayNoInternetAlert()
        }
        
    }
}




  
