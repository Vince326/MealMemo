//
//  AboutTableViewController.swift
//  MealMemo
//
//  Created by Vincent Hunter on 4/8/25.
//

import UIKit

class AboutTableViewController: UITableViewController {
    
    enum Sections {
        case feedback
        case followus
    }
    
    struct LinkItem: Hashable {
        var text: String
        var link: String
        var image: String
    }
    
    var sectionContent = [ [LinkItem(text: "Rate us on App Store", link: "https://www.apple.com/ios/app-store/", image: "store"),  LinkItem(text: "Tell us your feedback", link: "https://appcoda.com/contact", image: "chat")
                           ], [LinkItem(text: "Twitter", link: "https://twitter.com/appcodamobile", image: "twitter"),
                           LinkItem(text: "Facebook", link: "https://facebook.com/appcodamobile", image: "facebook"),
                               LinkItem(text: "Instaram", link: "https://instagram.com/appcodamobile", image: "instagram")]
       
                          
    ]
    
    lazy var dataSource = configureDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = dataSource
        updateSnapshot()
    }

    // MARK: - Table view data source

    func configureDataSource() -> UITableViewDiffableDataSource<Section, LinkItem> {
        let cellIdentifier = "aboutcell"
        
        let dataSource = UITableViewDiffableDataSource<Section, LinkItem>(tableView: tableView) { (tableView, indexPath, linkItem) -> UITableViewCell? in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            
            cell.textLabel?.text = linkItem.text
            cell.imageView?.image = UIImage(named: linkItem.image)
            
            return cell
        }
        return dataSource
    }
    

    func updateSnapshot() {
        
        //Creates snapshot and populates data
        var snapshot = NSDiffableDataSourceSnapshot<Section, LinkItem>()
        snapshot.appendSections([.feedback, .followus])
        snapshot.appendItems(sectionContent[0], toSection: .feedback)
        snapshot.appendItems(sectionContent[1], toSection: .followus)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
