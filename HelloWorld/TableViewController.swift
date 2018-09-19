//
//  TableViewController.swift
//  HelloWorld
//
//  Created by Digvijay Bhakuni on 18/09/18.
//  Copyright © 2018 Digvijay Bhakuni. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var entities : [TestEntity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            entities = try context.fetch(TestEntity.fetchRequest())
        } catch {
            print("Couldn't Fetch Data")
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.entities.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as UITableViewCell
        let selected = self.entities[indexPath.row]
        cell.textLabel?.text = selected.name
        cell.detailTextLabel?.text = selected.textData
        if let imageView = cell.imageView{
            let image = indexPath.row % 2 == 0 ? UIImage(named: "dog-pic") : UIImage(named: "android-contacts")
            print("width ---")
            print(image?.size.width)
            print(imageView.frame.width)
            imageView.image = image
            imageView.layer.cornerRadius = 20
            imageView.layer.borderColor = UIColor.black.cgColor
            imageView.layer.borderWidth = 2
            imageView.clipsToBounds = true
            imageView.layer.masksToBounds = true
            //imageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            imageView.frame.size.height -= 10
            imageView.frame.size.width -= 10
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(self.entities[indexPath.row].name!)
        let selected = self.entities[indexPath.row];
        performSegue(withIdentifier: "segueEditInfo", sender: selected)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueEditInfo" {
            if let editViewer = segue.destination as? EditViewController{
                
                if let entity = sender as? TestEntity{
                    // editViewer.selectedEntity = entity
                    editViewer.value(val: entity)
                }
            }
        }
    }


    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }


    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
