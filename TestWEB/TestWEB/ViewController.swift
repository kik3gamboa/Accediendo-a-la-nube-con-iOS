//
//  ViewController.swift
//  TestWEB
//
//  Created by Telecomunicaciones Abiertas de México on 11/26/15.
//  Copyright © 2015 Telecomunicaciones Abiertas de México. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {


    @IBOutlet weak var searchTxt: UITextField!
    @IBOutlet weak var panelTxtView: UITextView!
    
    func sincrono(ISBN: String) -> NSString {
        let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:" + ISBN
        let url = NSURL(string: urls)
        let datos:NSData? = NSData(contentsOfURL: url!)
        if(datos != nil){
            let texto = NSString(data: datos!, encoding: NSUTF8StringEncoding)
            return texto!
        } else {
            return "Error: Problemas de Conexión, revisa tu conexión e intenta nuevamente";
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        searchTxt.clearButtonMode = .Always
        searchTxt.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func ocultarKbrd(sender: UITextField){
        sender.resignFirstResponder()
    }
    
    @IBAction func mm(sender: AnyObject) {
        let openLib = sincrono(String(searchTxt.text!));
        //print(openLib)
        panelTxtView.text = openLib as String
    }
    
}
