//
//  WalkthroughViewController.swift
//  MealMemo
//
//  Created by Vincent Hunter on 3/30/25.
//

import UIKit

class WalkthroughViewController: UIViewController, WalkthroughPageViewController.WalkthroughPageViewControllerDelegate {
    
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var nextButton: UIButton! {
            didSet {
                nextButton.layer.cornerRadius = 25.0
                nextButton.layer.masksToBounds = true
            }
        }
    
    @IBOutlet var skipButton: UIButton!
    
    var walkthroughPageViewController: WalkthroughPageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func skipButtonTapped(sender: UIButton) {
        UserDefaults.standard.set(true, forKey: "hasSeenWalkthrough")
        dismiss(animated: true, completion: nil)
    }

    
    @IBAction func nextButtonTapped(sender: UIButton) {
        if let index = walkthroughPageViewController?.currentIndex {
            switch index {
            case 0...1:
                walkthroughPageViewController?.forwardPage()
                
            case 2:
                
                UserDefaults.standard.set(true, forKey: "hasSeenWalkthrough")
                dismiss(animated: true, completion: nil)
                
            default:
                break
            }
        }
        
        updateUI()
    }
    
    
    //Controls the title of the button and determines if the skip buttons sould be hidden
    func updateUI() {
        if let index = walkthroughPageViewController?.currentIndex {
            switch index {
            case 0...1:
                nextButton.setTitle("NEXT", for: .normal)
                skipButton.isHidden = false
            case 2:
                nextButton.setTitle("GET STARTED", for: .normal)
                skipButton.isHidden = true
            default: break
                
            }
            
            pageControl.currentPage = index
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let destination = segue.destination
        if let pageViewController = destination as? WalkthroughPageViewController {
            walkthroughPageViewController = pageViewController
            walkthroughPageViewController?.walkthroughDelegate = self
            
        }
    }
}

extension WalkthroughViewController {
    
    func didUpdatePageIndex(currentIndex: Int) {
        updateUI()
    }
}
