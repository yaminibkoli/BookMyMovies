//
//  Utils.swift
//  BookMyMovies
//

import UIKit

class Utils: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    static func showActivityIndicator(view: UIView, targetVC: UIViewController) {

        var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        activityIndicator.backgroundColor = UIColor(red:0.16, green:0.17, blue:0.21, alpha:1)
        activityIndicator.layer.cornerRadius = 6
        activityIndicator.center = targetVC.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        activityIndicator.tag = 1
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }

    static func hideActivityIndicator(view: UIView) {
        let activityIndicator = view.viewWithTag(1) as? UIActivityIndicatorView
        activityIndicator?.stopAnimating()
        activityIndicator?.removeFromSuperview()
        UIApplication.shared.endIgnoringInteractionEvents()
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
