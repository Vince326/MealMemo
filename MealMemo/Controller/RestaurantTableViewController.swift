//
//  RestaurantTableViewController.swift
//  MealMemo
//
//  Created by Vincent Hunter on 2/22/25.
//

import UIKit
import SwiftData

class RestaurantTableViewController: UITableViewController, RestaurantDataStore {
    
    protocol RestaurantDataStore {
        func fetchRestaurantData()
    }
    
    @IBOutlet var emptyRestaurantView: UIView!
    
    // Dimisses View Controller back to Restaurant Table VC
    @IBAction func unwindTohome(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
    
    var restaurants:[Restaurant] = []
    var container : ModelContainer?
   
    
    
    lazy var dataSource = configureDataSource()
    
    //MARK: - View Controller LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = dataSource
        tableView.separatorStyle = .none
        tableView.cellLayoutMarginsFollowReadableWidth = true
        
        //Enables Large Title in the Navigation Bar
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //Makes the back bar on Navigation Item empty
        navigationItem.backButtonTitle = ""
        
        
        //let color = UIColor(named: "NavigationBarTitle")!
        
        //Customize Navigation Bar
        if let appearance = navigationController?.navigationBar.standardAppearance {
            
            //Configures the nav bar's background to be transparaent
            appearance.configureWithTransparentBackground()
            
            if let customFont = UIFont(name: "Nunito-Bold", size: 45.0)
                {
                appearance.titleTextAttributes = [.foregroundColor: UIColor(named: "NavigationBarTitle")!]
                appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "NavigationBarTitle")!, .font: customFont]
            }
            
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance
        }
        // Hides the bars of the navigation Controller when swiping
        navigationController?.hidesBarsOnSwipe = true
        
        
        //Prepares the empty view to display if there's no restaurants
        tableView.backgroundView = emptyRestaurantView
        
        //Displays the empty view if there are no restaurants
        tableView.backgroundView?.isHidden = restaurants.count == 0 ? false : true
        
        //Creates the container
        container = try? ModelContainer(for: Restaurant.self)
        
        fetchRestaurantDatata()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = true
        navigationController?.navigationBar.prefersLargeTitles = true
        
       
    }
    
    
    // MARK: - UITableView Diffable Data Source
    
    func configureDataSource() -> RestaurantDiffableDataSource {
        
        let cellIdentifier = "datacell"
        
        let dataSource = RestaurantDiffableDataSource(tableView: tableView, cellProvider: {
            tableView, indexPath, restaurant in
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RestaurantTableViewCell
            
            //Configures the cell
            cell.nameLabel.text = restaurant.name
            cell.thumbnailImageView.image = restaurant.image
            cell.locationLabel.text = restaurant.location
            cell.typeLabel.text = restaurant.type
            
            cell.favoriteImageView.isHidden = restaurant.isFavorite ? false : true
            
            //Adds a checkmark if the restaurant is favorited
            //cell.accessoryType = self.restaurantIsFavorites[indexPath.row] ? .checkmark : .none
            
            return cell
        })
        return dataSource
    }
    
    

    
    
    
    //MARK: - Implement Delete / Share Swipe Function on the TableView
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        //Get the Selected Restaurant
        guard let restaurant = self.dataSource.itemIdentifier(for: indexPath) else {
            return UISwipeActionsConfiguration()
        }
        
        //Delete Action (Restaurant Records)
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {
            (action, sourceView, completionHandler) in
            
            var snapshot = self.dataSource.snapshot()
            snapshot.deleteItems([restaurant])
            self.dataSource.apply(snapshot, animatingDifferences: true)
            
            self.container?.mainContext.delete(restaurant)
            
            do {
                try self.container?.mainContext.save()
            } catch {
                print(error)
            }
            
            //Calls Completion Handler to Dismiss the action button
            completionHandler(true)
        }
        
        //MARK: - Implement Share Action
        
        //Share Action
        let shareAction = UIContextualAction(style: .normal, title: "Share") {
            (action, sourceView, completionHandler) in
            let defaultText = "Just checking in at " + restaurant.name
            let activityController: UIActivityViewController
            
            //Initalizes the image object through the data parameter
            activityController = UIActivityViewController(activityItems: [defaultText, restaurant.image], applicationActivities: nil)
            
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
    
    //Implement Favorites Swipe Function on TableView
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let favoriteAction = UIContextualAction(style: .destructive, title: "") { (action, sourceView, completionHandler) in
            
            let cell = self.tableView.cellForRow(at: indexPath) as! RestaurantTableViewCell
            
            //Hides the Image if the restaurant is not favorited
            cell.favoriteImageView.isHidden = self.restaurants[indexPath.row].isFavorite
            
            //Toggles Restaurant as favorite, which shows the image
            self.restaurants[indexPath.row].isFavorite = self.restaurants[indexPath.row].isFavorite ? false: true
            
            //Calls CompletionHandler to Dismiss the Action Button
            completionHandler(true)
        }
        
        //Configure Swipe Action
        favoriteAction.backgroundColor = .systemYellow
        favoriteAction.image = UIImage(systemName: self.restaurants[indexPath.row].isFavorite ? "heart.slash.fill" : "heart.fill")
        
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [favoriteAction])
        return swipeConfiguration
    }
    
    // MARK: - Navigation to RestaurantDetailVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRestaurantDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! RestaurantDetailViewController
                destinationController.restaurant = self.restaurants[indexPath.row]
            }
            // Handles the add Restaurant segue and transition to NewRestaurantController
        } else if segue.identifier == "addRestaurant" {
            if let navController = segue.destination as? UINavigationController,
               let destinationController = navController.topViewController as? NewRestaurantController {
                destinationController.dataStore = self
            }
            
        }
    }
    
    //Instructs SwiftData to retrieve all restaurant records from database
    func fetchRestaurantDatata() {
        let descriptor = FetchDescriptor<Restaurant>()
        restaurants = (try? container?.mainContext.fetch(descriptor)) ?? []
        updateSnapshot()
    }
    
    func updateSnapshot(animatingChange: Bool = false) {
        //Create a snapshot and populate the data
        var snapshot = NSDiffableDataSourceSnapshot<Section, Restaurant>()
        snapshot.appendSections([.all])
        snapshot.appendItems(restaurants, toSection: .all)
        
        dataSource.apply(snapshot, animatingDifferences: animatingChange)
        
        tableView.backgroundView?.isHidden = restaurants.count == 0 ? false : true
    }
    
   
}
    
