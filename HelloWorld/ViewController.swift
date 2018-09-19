//
//  ViewController.swift
//  HelloWorld
//
//  Created by Digvijay Bhakuni on 24/11/17.
//  Copyright © 2017 Digvijay Bhakuni. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var selectedImageTag = 0
    
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var dob: UIDatePicker!
    
    @IBOutlet weak var textData: UITextField!
    
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var sampleLbl: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var entities : [TestEntity] = []
    var selectedEntity: TestEntity!
    
    @IBAction func importImageBtnAction(_ sender: UIButton) {
        
        doImageSection();
        
    }
    
    
    func doImageSection(){
        let image = UIImagePickerController();
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary;
        image.allowsEditing = false
        
        self.present(image, animated: true){
            //After It is Complate
             print("Present Event Done")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            topImageView.image = image;
        }else{
            //Error message
            print("Not a Image Picked")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func swipeAction(_ sender: Any) {
        print("Swip Invoked")
        doImageSection();
        
    }
    
    @IBAction func tapActionImgView(_ sender: UITapGestureRecognizer) {
        
        doImageSection();
        
    }
    
    
    // This is Life Cycle hook method.
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .cyan
        // Do any additional setup after loading the view, typically from a nib.
        
        addTabGestures()
        do {
            entities = try context.fetch(TestEntity.fetchRequest())
            print(entities)
            
            for en in entities{
                print(en.name!)
                print(en.dob!)
            }
            
            self.selectedEntity = entities.last
            
        } catch {
            print("Couldn't Fetch Data")
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let selectedEntity = self.selectedEntity{
            self.name.text = selectedEntity.name
            if let dob = selectedEntity.dob {
                self.dob.date = dob
            }
            self.textData.text = self.selectedEntity?.textData
        }
        
        
    }

    @IBAction func save(_ sender: UIButton) {
        print("try to save")
        guard let ename = self.name?.text else { return }
        guard let edob = self.dob?.date else { return }
        guard let etxtdata = self.textData.text else { return }
    
        let eTest = TestEntity(context: self.context)
        eTest.name = ename
        eTest.dob = edob
        eTest.textData = etxtdata
        do {
            try self.context.save()
            print("saved")
        } catch  {
            let nserror = error as NSError
            fatalError("Unresolved error,\(nserror) \((nserror).userInfo)")
        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("This method is viewWillDisappear", animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("This method is viewDidDisappear", animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addTabGestures(){
        let tapGR0 = UITapGestureRecognizer(target: self, action: #selector(ViewController.lblTabed(rec:)))
        tapGR0.numberOfTapsRequired = 1
        sampleLbl.addGestureRecognizer(tapGR0)
        sampleLbl.isUserInteractionEnabled = true
    }
    

    @objc func lblTabed(rec: UITapGestureRecognizer){
        print("Just Tabbed")
    }
    
    @IBAction func showMessage(sender: UIButton) {
        let alertController = UIAlertController(title: "Welcome to My First App", message: "Hello World", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    @IBAction func showMessageEmoji(sender: UIButton) {
        let selectButton = sender
        var emojiDict = ["🐶": "Dog", "🇮🇳": "Indian National Flag", "🤓": "Nerd", "☃️": "Snowman"]
        if let wordToLookup = selectButton.titleLabel?.text{
            let meaning = emojiDict[wordToLookup] ?? "N/A"
            let alertController = UIAlertController(title: "Meaning ".appending(wordToLookup), message: "Is : ".appending(meaning), preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
        }
    }

}
