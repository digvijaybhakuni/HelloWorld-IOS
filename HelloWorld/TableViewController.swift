//
//  TableViewController.swift
//  HelloWorld
//
//  Created by Digvijay Bhakuni on 18/09/18.
//  Copyright © 2018 Digvijay Bhakuni. All rights reserved.
//

import UIKit

struct Employee: Decodable{
    let id: Int
    let email: String
    let name: String
    let createOn: Date
    let owner: Int
    
    init(json: [String: Any]){
        id = json["id"] as? Int ?? -1
        email = json["email"] as? String ?? ""
        name = json["name"] as? String ?? ""
        // createOn = json["createOn"] as? String ?? ""
        createOn = json["createOn"] as? Date ?? Date()
        owner = json["owner"] as? Int ?? -1
    }
}

extension Formatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter
    }()
}

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
        
        // self.callApi()
        self.callApiUsingDecoder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func callApi(){
        let empApiUrl = "http://localhost:8000/api/v1/employees/1/"
        let url = URL(string: empApiUrl)
        var urlRequest = URLRequest(url: url!)
        urlRequest.addValue("Token eff98b75e5f81ef1a7d756b4d9270133759d7934", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: urlRequest) { (data, response, err) in
            // Check Error
            // Check Response
            print("call Api ")
            //print(err)
            // Binary to String
            guard let data = data else { return }
            //let dataAsStr = String(data: data, encoding: .utf8)
            
            // Binary to Json
            do{
                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else { return }
                print(json)
                
                let emp1 = Employee(json: json)
                
                print(emp1)
                
                // Directly Decode Response Data to Object Employee
                let emp1Json = try JSONDecoder().decode(Employee.self, from: data)
                
                print(emp1Json.name)
                
                let t1 = TestEntity(context: self.context)
                t1.name = emp1.name
                // t1.dob = emp1.createOn
                t1.textData = emp1.email
                self.entities.append(t1)
                
            }catch let jsonErr {
                print("error json error")
                print(jsonErr.localizedDescription)
            }
            
        }.resume()
    }

    func callApiUsingDecoder(){
        let url = URL(string: "http://localhost:8000/api/v1/employees/")
        var urlRequest = URLRequest(url: url!)
        urlRequest.addValue("Token eff98b75e5f81ef1a7d756b4d9270133759d7934", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: urlRequest) { (data, response, err) in
            do {
                guard let data = data else { return }
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(Formatter.iso8601)
                // For Single Object try decoder.decode(Employee.self, from: data)
                let emp1Json = try decoder.decode([Employee].self, from: data)
                print(emp1Json.first?.email ?? " nil email")
                print(emp1Json)
            }catch let errJson {
                print("Error ... Catch ")
                print(errJson)
            }
        }.resume()
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
