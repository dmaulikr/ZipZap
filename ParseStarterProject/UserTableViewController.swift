//
//  UserTableViewController.swift
//  ZipZap
//
//  Created by Pedro Neves Alvarez on 6/4/17.
//  Copyright © 2017 Parse. All rights reserved.
//

import UIKit
import Parse

class UserTableViewController: UITableViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private var activityIndicator = UIActivityIndicatorView()
    private var users = [String]()
    //private var currentImage: UIImage
    private var recipientUser = ""
    private var timer = Timer()
    
    private func createAlert(title: String, message: String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
 
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            
            self.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func checkforMessages(){
        
        
        let query = PFQuery(className: "Image")
        
        query.whereKey("recipient", equalTo: (PFUser.current()?.username) as Any)
        
        do {
            
            let images = try query.findObjects()
            
            if images.count > 0 {
                
                var senderUsername = "Unknown User"
                
                if let username = images[0]["sender"] as? String {
                    
                    senderUsername = username
                    
                }
                
                if let pfFile = images[0]["imageFile"] as? PFFile {
                    
                    pfFile.getDataInBackground(block: { (data, error) in
                        
                        if let imageData = data {
                            
                            images[0].deleteInBackground()
                            
                            self.timer.invalidate()
                            
                            if let imageToDisplay = UIImage(data: imageData) {
                                
                                let alertController = UIAlertController(title: "You have a message", message: "Message from " + senderUsername, preferredStyle: .alert)
                                
                                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                                    
                                    let backgroundImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
                                    
                                    backgroundImageView.backgroundColor = UIColor.black // UIColor.black() is now UIColor.black
                                    
                                    backgroundImageView.alpha = 0.8
                                    
                                    backgroundImageView.tag = 10
                                    
                                    self.view.addSubview(backgroundImageView)
                                    
                                    
                                    let displayedImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
                                    
                                    displayedImageView.image = imageToDisplay
                                    
                                    displayedImageView.tag = 10
                                    
                                    displayedImageView.contentMode = UIViewContentMode.scaleAspectFit
                                    
                                    self.view.addSubview(displayedImageView)
                                    
                                    _ = Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: { (timer) in
                                        
                                        self.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(UserTableViewController.checkforMessages), userInfo: nil, repeats: true)
                                        
                                        for subview in self.view.subviews {
                                            
                                            if subview.tag == 10 {
                                                
                                                subview.removeFromSuperview()
                                                
                                            }
                                            
                                        }
                                        
                                    })
                                    
                                    
                                }))
                                
                                self.present(alertController, animated: true, completion: nil)
                                
                            }
                            
                            
                        }
                        
                        
                    })
                    
                    
                    
                    
                    
                }
                
            }
            
        } catch {
            
            print("Could not get images")
            
        }

        /*let query = PFQuery(className: "Image")
        
        query.whereKey("recipient", equalTo: (PFUser.current()?.username) as Any)
        
        do{
         
            let images = try query.findObjects()
         
            if images.count > 0{
         
         
                    
                    var senderUser = "Unknown User"
                    
                    if let user = images[0]["sender"] as? String{
                        
                        senderUser = user
                    }
                    
                    if let pffile = images[0]["imageFile"] as? PFFile{
                        
                        
                        pffile.getDataInBackground(block: { (data, error) in
                            
                            if let imagedata = data{
                                
                                images[0].deleteInBackground()
                                self.timer.invalidate()
                                
                                if let imageTodisplay = UIImage(data: imagedata){
                                    
                                    let alertcontroller = UIAlertController(title: "You have a message", message: "Message from" + senderUser, preferredStyle: UIAlertControllerStyle.alert)
                                    alertcontroller.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                                        
                                        (action) in
                                        
                                        let backgroundImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
                                        backgroundImageView.backgroundColor = UIColor.black
                                        backgroundImageView.alpha = 0.8
                                        backgroundImageView.tag = 10
                                        self.view.addSubview(backgroundImageView)
                                        let displayedImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
                                        
                                        displayedImageView.image = imageTodisplay
                                        displayedImageView.tag = 10
                                        displayedImageView.contentMode = UIViewContentMode.scaleAspectFit
                                        self.view.addSubview(displayedImageView)
                                        
                                        _ = Timer(timeInterval: 5, repeats: false, block: {
                                            
                                            (timer) in
                                            
                                            print("entered this scope")
                                            
                                            self.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(UserTableViewController.checkforMessages), userInfo: nil, repeats: true)
                                            
                                            for subview in self.view.subviews{
                                                
                                                if subview.tag == 10{
                                                    
                                                    subview.removeFromSuperview()
                                                    
                                                }
                                                
                                            }
                                            
                                        })
                                        
                                    }))
                                    
                                    self.present(alertcontroller, animated: true, completion: nil)
                                }
                            }
                        })
                    
                    
                    
             }
        }
        }catch{
            
            print("Unable to find image")
            
        }*/
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = false
        
         timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(UserTableViewController.checkforMessages), userInfo: nil, repeats: true)
        
        
        let query = PFUser.query()
        
        query?.whereKey("username", notEqualTo: (PFUser.current()?.username)!)
        
        do{
        let foundUsers =  try query?.findObjects()
            
            if let foundUsers = foundUsers as? [PFUser] {
                
                for foundUser in foundUsers{
                    
                     self.users.append(foundUser.username!)
                }
                tableView.reloadData()
            }
        }
        catch{
            
            print("Could not get users")
        }
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
        return users.count
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "logout"{
            
            PFUser.logOut()
            self.navigationController?.navigationBar.isHidden = true
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = users[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(users[indexPath.row])
        
        recipientUser = users[indexPath.row]
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            
            print("Got image")
            
            activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0,y: 0, width: 50, height: 50 ))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            
            self.view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            let imageSent = PFObject(className: "Image")
            imageSent["sender"] = PFUser.current()?.username
            imageSent["recipient"] = recipientUser
            
            let PNGimage = UIImagePNGRepresentation(image)
            let imageFile = PFFile(name: "image.png", data: PNGimage!)
            imageSent["imageFile"] = imageFile
            
            imageSent.saveInBackground(block: { (success, error) in
                
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                
                if error != nil{
                    
                    self.createAlert(title: "Could not send image", message: "it failed")
                    
                }else{
                    
                    self.createAlert(title: "Sent image", message: "Wait for an answer")
                    
                }
                
            })
            
            self.dismiss(animated: true, completion: nil)
        }
        
       
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
