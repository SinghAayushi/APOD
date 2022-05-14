//
//  ViewController.swift - The class is responsible for UI updates
//  AstronomyPicOfTheDay
//
//  Created by Aayushi Singh on 13/05/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var headingTextField: UITextField!
    @IBOutlet var podImageView: UIImageView!
    @IBOutlet var titleTextView: UILabel!
    @IBOutlet var descriptionTextView: UILabel!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    
    
    //view model initialization
    var viewModel = DefaultApodViewModel(data: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print ("view did load ")
        loadingIndicator.startAnimating()
        
        //Data binding
        viewModel.apodObservableData.bind { [weak self] data in
            DispatchQueue.main.async {
                self?.updateUI(data: data ?? nil)
            }
        }
        
        fetchDataAndUpdateUI()

    }
    
}

extension ViewController {
    func fetchDataAndUpdateUI() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        //Internet error handling
        viewModel.fetchApodData(requestedDate: dateFormatter.string(from: Date.now)){[weak self] error in
            if error != nil {
                DispatchQueue.main.async {
                    self?.showAlertDialog(title: "Internet error!", message: "Showing you the last image we have.")
                }
                
            }
        }
    }
    
    //Internet error dialog
    func showAlertDialog(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //Update UI on viewmodel load
    func updateUI(data: ApodViewModel?) {
        self.podImageView.image = data?.image
        self.titleTextView.text = data?.title
        self.descriptionTextView.text = data?.description
        self.loadingIndicator.isHidden = true
    }

}

