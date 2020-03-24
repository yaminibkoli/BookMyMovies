//
//  MovieDetailViewController.swift
//  BookMyMovies
//


import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var ViewModelDetail: UIView!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var ViewModelDetails: UIView!
    @IBOutlet weak var lblReleaseDate: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var ImageView: UIImageView!
    var image:String?
    var Title:String?
    var RatingM: Double?
    var ReleaseDateM: String?
    override func viewDidLoad() {
        super.viewDidLoad()
         setupUI()
    }
    func setupUI(){
        ViewModelDetails.layer.shadowColor = UIColor.lightGray.cgColor
        ViewModelDetails.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        ViewModelDetails.layer.shadowPath = UIBezierPath(rect: ViewModelDetails.bounds).cgPath
        ViewModelDetails.layer.shadowRadius = 1
        ViewModelDetails.layer.shadowOffset = .zero
        ViewModelDetails.layer.shadowOpacity = 0.5
        ViewModelDetails.layer.cornerRadius = 10.0
        ViewModelDetails.layer.borderColor = UIColor.gray.cgColor
        ViewModelDetails.layer.borderWidth = 0.5
        ViewModelDetails.clipsToBounds = true
    }
    override func viewWillAppear(_ animated: Bool) {
        lblTitle.text = Title
        lblRating.text =  "\(RatingM!)"
        lblReleaseDate.text = ReleaseDateM
        var path = image
        let url = URL(string: path!)
        let data = try? Data(contentsOf: url!)
        ImageView.image  = UIImage(data: data!)
    }
    override open var shouldAutorotate: Bool {
       return false
    }

    // Specify the orientation.
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
       return .portrait
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
