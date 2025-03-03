//
//  RestaurantTableViewController.swift
//  MealMemo
//
//  Created by Vincent Hunter on 2/22/25.
//

import UIKit

class RestaurantTableViewController: UITableViewController {
    
    
    var restaurants : [Restaurant] = [
        Restaurant(name: "Cafe Deadend", type: "Coffee & Tea Shop", location:
        "Hong Kong", image: "cafedeadend", isFavorite: false),
        Restaurant(name: "Homei", type: "Cafe", location: "Hong Kong", image:
        "homei", isFavorite: false),
        Restaurant(name: "Teakha", type: "Tea House", location: "Hong Kong", image: "teakha", isFavorite: false),
        Restaurant(name: "Cafe loisl", type: "Austrian / Causual Drink", location: "Hong Kong", image: "cafeloisl", isFavorite: false),
        Restaurant(name: "Petite Oyster", type: "French", location: "Hong Kong", image: "petiteoyster", isFavorite: false),
        Restaurant(name: "For Kee Restaurant", type: "Bakery", location: "Hong Kong", image: "forkee", isFavorite: false),
        Restaurant(name: "Po's Atelier", type: "Bakery", location: "Hong Kong", image: "posatelier", isFavorite: false),
        Restaurant(name: "Bourke Street Backery", type: "Chocolate", location:"Sydney", image: "bourkestreetbakery", isFavorite: false),
        Restaurant(name: "Haigh's Chocolate", type: "Cafe", location: "Sydney", image: "haigh", isFavorite: false), Restaurant(name: "Palomino Espresso", type: "American / Seafood", location: "Sydney", image: "palomino", isFavorite: false),Restaurant(name: "Upstate", type: "American", location: "New York", image: "upstate", isFavorite: false),
        Restaurant(name: "Traif", type: "American", location: "New York", image: "traif", isFavorite: false),
        Restaurant(name: "Graham Avenue Meats", type: "Breakfast & Brunch", location: "New York", image: "graham", isFavorite: false),Restaurant(name: "Waffle & Wolf", type: "Coffee & Tea", location: "New York", image: "waffleandwolf", isFavorite: false),
        Restaurant(name: "Five Leaves", type: "Coffee & Tea", location: "New York", image: "fiveleaves", isFavorite: false),
        Restaurant(name: "Cafe Lore", type: "Latin American", location: "New York", image: "cafelore", isFavorite: false),
        Restaurant(name: "Confessional", type: "Spanish", location: "New York", image: "confessional", isFavorite: false),
        Restaurant(name: "Barrafina", type: "Spanish", location: "London", image: "barrafina", isFavorite: false),
    Restaurant(name: "Donostia", type: "Spanish", location: "London", image: "donostia", isFavorite: false),
        Restaurant(name: "Royal Oak", type: "British", location: "London", image: "royaloak", isFavorite: false),
        Restaurant(name: "CASK Pub and Kitchen", type: "Thai", location: "London", image: "cask", isFavorite: false)
    ]
    
    var restaurantIsFavorites = Array(repeating: false, count: 21)
    
    
    lazy var dataSource = configureDataSource()
    
    //MARK: - View Controller LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = dataSource
        tableView.separatorStyle = .none
        tableView.cellLayoutMarginsFollowReadableWidth = true
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Restaurant>()
        snapshot.appendSections([.all])
        snapshot.appendItems(restaurants, toSection: .all)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    
    // MARK: - UITableView Diffable Data Source
    
    func configureDataSource() -> RestaurantDiffableDataSource {
        
        let cellIdentifier = "datacell"
        
        let dataSource = RestaurantDiffableDataSource(tableView: tableView, cellProvider: {
            tableView, indexPath, restaurant in
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RestaurantTableViewCell
            
            //Configures the cell
            cell.nameLabel.text = restaurant.name
            cell.thumbnailImageView.image = UIImage(named: restaurant.image)
            cell.locationLabel.text = restaurant.location
            cell.typeLabel.text = restaurant.type
            
            cell.favoriteImageView.isHidden = restaurant.isFavorite ? false : true
            
            //Adds a checkmark if the restaurant is favorited
            //cell.accessoryType = self.restaurantIsFavorites[indexPath.row] ? .checkmark : .none

            return cell
        }
    )
       return dataSource
        }
    
    // MARK: - UITableViewDelegate Protocol
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Creates an option menu as a sheet
        
        let optionMenu = UIAlertController(title: nil, message: "What do you want to do?", preferredStyle: .actionSheet)
        
        //Add actions to the menu
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        optionMenu.addAction(cancelAction)
        
        //Add Reserve Table Action
        let reserveActionHandler = { (action: UIAlertAction) -> Void in
            
            let alertMessage = UIAlertController(title: "Not available yet", message: "Sorry, this feature isn't available yet", preferredStyle: .alert)
            alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertMessage, animated: true, completion: nil)
        }
        
        let reserveAction = UIAlertAction(title: "Reserve Table", style: .default, handler: reserveActionHandler)
        optionMenu.addAction(reserveAction)
        
        if let popoverController = optionMenu.popoverPresentationController {
            if let cell = tableView.cellForRow(at: indexPath) {
                popoverController.sourceView = cell
                popoverController.sourceRect = cell.bounds
            }
        }
        
        
        //Mark as favorite action
        
        //Title that switches whether or not the restaurant is favorited. 
        let favoriteActionTitle = self.restaurants[indexPath.row].isFavorite ? "Remove from favorites" : "Mark as favorite"
        
        let favoriteAction = UIAlertAction(title: favoriteActionTitle, style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            
            let cell = tableView.cellForRow(at: indexPath) as! RestaurantTableViewCell
            
            
            //Hides the Image if the restaurant is not favorited
            cell.favoriteImageView.isHidden = self.restaurants[indexPath.row].isFavorite
            
            //Toggles Restaurant as favorite, which shows the image
            self.restaurants[indexPath.row].isFavorite = self.restaurants[indexPath.row].isFavorite ? false: true
            //self.restaurants[indexPath.row].isFavorite.toggle()
        })
        optionMenu.addAction(favoriteAction)
        
        //Display Action Menu
        present(optionMenu, animated: true, completion: nil)
        
        //Deselect the row
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //Implement Delete Swipe Function on the TableView
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        //Get the Selected Restaurant
        guard let restaurant = self.dataSource.itemIdentifier(for: indexPath) else {
            return UISwipeActionsConfiguration()
        }
        
        //Delete Action
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {
            (action, sourceView, completionHandler) in
            
            var snapshot = self.dataSource.snapshot()
            snapshot.deleteItems([restaurant])
            self.dataSource.apply(snapshot, animatingDifferences: true)
            
            //Calls Completion Handler to Dismiss the action button
            completionHandler(true)
        }
        
        //Share Action
        let shareAction = UIContextualAction(style: .normal, title: "Share") {
            (action, sourceView, completionHandler) in
            let defaultText = "Just checking in at " + restaurant.name
            let activityController: UIActivityViewController
            
            if let imageToShare = UIImage(named: restaurant.image) {
                activityController = UIActivityViewController(activityItems: [defaultText, imageToShare], applicationActivities: nil)
            } else {
                activityController = UIActivityViewController(activityItems: [defaultText], applicationActivities: nil)
            }
            
            if let popoverController = activityController.popoverPresentationController {
                if let cell = tableView.cellForRow(at: indexPath) {
                    popoverController.sourceView = cell
                    popoverController.sourceRect = cell.bounds
                }
            }
            
            self.present(activityController, animated: true, completion: nil)
            completionHandler(true)
            
        }
        
        deleteAction.backgroundColor = .red
        deleteAction.image = UIImage(systemName: "trash")
        
        shareAction.backgroundColor = .systemOrange
        shareAction.image = UIImage(systemName: "square.and.arrow.up")
        
        
        //Configure Both Actions as a swipe action
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
        
        return swipeConfiguration
    }
    
    //Implement Check-In Swipe Function on TableView
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        guard let restaurant = self.dataSource.itemIdentifier(for: indexPath) else {
            return UISwipeActionsConfiguration()
        }
        
        
        let checkInAction = UIContextualAction(style: .normal, title: "Check-In") { (action, view, completionHandler) in
            
            
            
            completionHandler(true)
        }
        checkInAction.backgroundColor = .blue
        checkInAction.image = UIImage(systemName: "heart.fill")
        
        
        
        return UISwipeActionsConfiguration(actions: [checkInAction])
    }
    
    
    
}
    
