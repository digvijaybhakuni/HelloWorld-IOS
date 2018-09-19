//
//  EditViewController.swift
//  HelloWorld
//
//  Created by Digvijay Bhakuni on 19/09/18.
//  Copyright © 2018 Digvijay Bhakuni. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {

    @IBOutlet weak var namelbl: UILabel!
    var selectedEntity: TestEntity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let selected = self.selectedEntity {
            namelbl.text = selected.name
        }
        print("viewDidLoad")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension EditViewController: TestEntityDelegate{
    func value(val: TestEntity) {
        print("TestEntityDelegate")
        self.selectedEntity = val
//        if let selected = self.selectedEntity {
//            namelbl.text = selected.name
//        }
    }
}
