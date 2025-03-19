//
//  RestaurantDetailViewController.swift
//  MealMemo
//
//  Created by Vincent Hunter on 3/4/25.
//

import UIKit

class RestaurantDetailViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var headerView: RestaurantDetailHeaderView!
    
    
    @IBAction func close(segue: UIStoryboardSegue) {
        dismiss(animated: true , completion: nil)
    }
    
    @IBAction func rateRestaurant(segue: UIStoryboardSegue) {
        guard let identifier = segue.identifier else { return }
        
//        if let rating = Restaurant.Rating(rawValue: identifier) {
//            self.restaurant.rating = rating
//            self.headerView.ratingImageVIew.image = UIImage(named: rating.image)
//        }
        
        dismiss(animated: true , completion: {
            
            if let rating = Restaurant.Rating(rawValue: identifier) {
                self.restaurant.rating = rating
                self.headerView.ratingImageView.image = UIImage(named: rating.image)
            }
            
            let scaleTransform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
            self.headerView.ratingImageView.transform = scaleTransform
            self.headerView.ratingImageView.alpha = 0
            
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.7, options: [], animations: {
                self.headerView.ratingImageView.transform = .identity
                self.headerView.ratingImageView.alpha = 1
            }, completion: nil)
        })
    }
    
    var restaurant: Restaurant = Restaurant()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.hidesBarsOnSwipe = true
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //Configure HeaderView
        headerView.nameLabel.text = restaurant.name
        headerView.typeLabel.text = restaurant.type
        headerView.headerImageView.image = UIImage(named: restaurant.image)
        
        let heartImage = restaurant.isFavorite ? "heart.fill" : "heart"
        headerView.heartButton.tintColor = restaurant.isFavorite ? .systemYellow: .white
        headerView.heartButton.setImage(UIImage(systemName: heartImage), for: .normal)
        
        //Remove tableView Seperator
        tableView.separatorStyle = .none
        
        //Shifts tableView towards top of the screen
        tableView.contentInsetAdjustmentBehavior = .never
        
        //Makes the back bar on Navigation Item empty
        navigationItem.backButtonTitle = ""
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    //Gets the selected restaurant and passes it to the destination viewcontroller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showMap":
            let destinationVC = segue.destination as! MapViewController
            destinationVC.restaurant = restaurant
            
        case "showReview":
            let destinationVC = segue.destination as! ReviewViewController
            destinationVC.restaurant = restaurant
            
        default:
            break
        }
        
    }
    


}

extension RestaurantDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailTextCell.self), for: indexPath) as! RestaurantDetailTextCell
            
            cell.descriptionLabel.text = restaurant.description
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailTwoColumnCell.self), for: indexPath) as! RestaurantDetailTwoColumnCell
            
            cell.column1TitleLabel.text = "Address"
            cell.column1TextLabel.text = restaurant.location
            cell.column2TitleLabel.text = "Phone"
            cell.column2TextLabel.text = restaurant.phone
            
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailMapCell.self), for: indexPath) as! RestaurantDetailMapCell
            
            //Calls the configure method with the restaurants location
            cell.configure(location: restaurant.location)
            cell.selectionStyle = .none
                
            return cell
            
            
        default:
            fatalError("Failed to instantiate table view cell for detail view controller")
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
