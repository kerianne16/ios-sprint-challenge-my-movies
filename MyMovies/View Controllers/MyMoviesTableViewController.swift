//
//  MyMoviesTableViewController.swift
//  MyMovies
//
//  Created by Spencer Curtis on 8/17/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit
import CoreData

class MyMoviesTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    let myMoviesController = MyMoviesController.shared
  

    override func viewDidLoad() {
        super.viewDidLoad()

       NotificationCenter.default.addObserver(self, selector: #selector(shouldShowMovieAdded(_:)), name: .shouldShowMovieAdded, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        tableView.reloadData()
    }
    // MARK: - Notifications
      @objc func shouldShowMovieAdded(_ notification: Notification) {
          tableView.reloadData()
      }
      
      lazy var fetchedResultsController: NSFetchedResultsController<Movie> = {
          
          let frc = CoreDataStack.shared.makeNewFetchedResultsController()
          frc.delegate = self
          try? frc.performFetch()
          return frc
      }()

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

      override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         guard let cell = tableView.dequeueReusableCell(withIdentifier: MyMoviesTableViewCell.reuseIdentifier, for: indexPath) as? MyMoviesTableViewCell else {
             fatalError("Could not dequeue cell")
        }
            cell.movie = fetchedResultsController.object(at: indexPath)
            return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
                
        let movie = fetchedResultsController.object(at: indexPath)
        
        myMoviesController.deleteMovie(movie: movie)
    }
}
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            
    if section == 0 {
        return "Not Watched"
    } else {
        return "Watched"
    }
}
        
        override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
            guard let header = view as? UITableViewHeaderFooterView else { return }
            header.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            view.tintColor = #colorLiteral(red: 0.8808686818, green: 0.9638480253, blue: 1, alpha: 1)
        }
    
        // MARK: - NSFetchedResultsControllerDelegate Methods
        
        func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            tableView.beginUpdates()
        }
        
        // Get the fetched results change type
        func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
            
            switch type {
            case .insert:
                guard let indexPath = newIndexPath else { return }
                // tell the table view to insert rows at this index path
                tableView.insertRows(at: [indexPath], with: .automatic)
            case .delete:
                // Make sure we have an index path
                guard let indexPath = indexPath else { return }
                // delete the row at that index path
                tableView.deleteRows(at: [indexPath], with: .automatic)
            case .move:
                guard let oldIndexPath = indexPath else { return }
                guard let newIndexPath = newIndexPath else { return }
                tableView.moveRow(at: oldIndexPath, to: newIndexPath)
            case .update:
                guard let indexPath = indexPath else { return }
                tableView.reloadRows(at: [indexPath], with: .automatic)
            @unknown default:
                break
            }
        }
        
        func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
            
            switch type {
            case .insert:
                tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
            case .delete:
                tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
            default: break
            }
        }
        
        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            tableView.endUpdates()
        }
    }



 
