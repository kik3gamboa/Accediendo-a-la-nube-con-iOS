//
//  TableController.swift
//  clima3
//
//  Created by Telecomunicaciones Abiertas de México on 1/27/16.
//  Copyright © 2016 Telecomunicaciones Abiertas de México. All rights reserved.
//

import UIKit

struct Seccion {
   var ciudades : Array<Array<String>> = Array<Array<String>>()
    
    init(ciudades: Array<Array<String>>){
        self.ciudades = ciudades
    }
}

class TableController: UITableViewController {

    private var ciudades : Array<Array<String>> = Array<Array<String>>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        self.navigationItem.rightBarButtonItem = addButton
        
        
        self.ciudades.append(["East to Barryvale","0263058980"])
        self.ciudades.append(["Dissociative identity disorder","1568213808"])
        
        //self.ciudades.append(["Caracas","VEXX0008"])
        //self.ciudades.append(["Paris","FRXX0076"])


        self.title = "Lista de Libros"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    func insertNewObject(sender: AnyObject) {
        
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Agregar Libro", message: "NSBN:", preferredStyle: .Alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.placeholder = "1-56619-909-3"
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action) -> Void in
            print("Salir")
        }))
        
        //3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            print("Text field: \(textField.text)")
            let result_ISBN = textField.text!
            
            var alert2 = UIAlertController(title: "Libros", message: "No se encontro el NSBN en la base de datos", preferredStyle: .Alert)
            
            let openLib = self.sincrono(result_ISBN);
            
            if (openLib.error == 0){
                
                print("si si ahuevo")
                alert2 = UIAlertController(title: "Libros", message: "NSBN Encontrado y agregado correctamente", preferredStyle: .Alert)
                self.ciudades.append(["\(openLib.title) (\(openLib.autor))","\(result_ISBN)"])
                //"FRXX0153"])
                
                
            }
            
            alert2.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action) in
                print("Ok")
                self.tableView!.reloadData()
            }))
            
            self.presentViewController(alert2, animated: true, completion: nil)
            
        }))
        
        // 4. Present the alert.
        self.presentViewController(alert, animated: true, completion: nil)

        
    }
    
    func sincrono(ISBN: String) -> (error: Int, errorCode: String, title: String, autor: String, img: String) {
        
        let newString = ISBN.stringByReplacingOccurrencesOfString(" ", withString: "")
        
        let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:" + newString
        
        print(urls)
        let url = NSURL(string: urls)
        
        let datos = NSData(contentsOfURL: url!)
        var tituloBook: String = ""
        var autorBook: String = ""
        var coverBook: String = ""
        var errorBook: Int = 0
        var errorCode: String = ""
        
        if(datos != nil){
            
            
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(datos!,
                    options:  NSJSONReadingOptions.MutableLeaves)
                
                let dico1 = json as! NSDictionary
                
                //print(dico1)
                
                let ISBN_no: String = "ISBN:" + ISBN
                if( dico1[ISBN_no] == nil ){
                    
                    print("JSON no data")
                    errorBook = 1
                    errorCode = "No hay datos de este ISBN"
                    
                } else {
                    
                    let dico2 = dico1[ISBN_no] as!  NSDictionary
                    tituloBook = dico2["title"] as! NSString as String
                    
                    
                    if( dico2["authors"] == nil ){
                        autorBook = "Sin Autor"
                    } else {
                        let dico3 = dico2["authors"] as!  NSArray as Array
                        let a = dico3.count
                        var b = 0
                        for (nameISBN) in dico3 {
                            b += 1
                            let dico4 = nameISBN["name"] as!  NSString as String
                            autorBook += "\(dico4)";
                            autorBook += (b < a ? ", " : "")
                        }
                        
                    }
                    
                    if( dico2["cover"] == nil ){
                        coverBook = "http://vignette2.wikia.nocookie.net/thewalkingdead/images/d/d1/Sin_foto.png/revision/latest?cb=20141021181525&path-prefix=es"
                    } else {
                        let dico5 = dico2["cover"] as!  NSDictionary
                        coverBook = dico5["medium"] as!  NSString as String
                    }
                    
                    //let dico3 = dico2["authors"] as! NSArray as Array
                    
                    print(dico1)
                    
                }
                
                
                
                
                /*
                if(dico3){
                noAutorsBook = dico3.count
                print(dico3.count)
                } else {
                print("No Contiene Autores")
                }
                */
                //let dico4 = dico2["cover"] as! NSDictionary
                //coverBook = dico4["medium"] as! NSString as String
            }
                
            catch _ {
                
            }
            
            print(" \(errorBook) - \(errorCode) - \(tituloBook) - \(autorBook) - \(coverBook)")
            return (errorBook, errorCode, tituloBook, autorBook, coverBook)
            
            
            
        } else {
            return (1, "Problemas de Conexión, revisa tu conexión e intenta nuevamente",tituloBook, autorBook, coverBook)
        }
        
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.ciudades.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("celda", forIndexPath: indexPath)

        // Configure the cell...
        cell.textLabel?.text = self.ciudades[indexPath.row][0]

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let ccd = segue.destinationViewController as! ClimasController
        
        let indexPath_ = self.tableView.indexPathForSelectedRow
        
        ccd.codigo = self.ciudades[indexPath_!.row][1]
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
