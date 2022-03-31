//
//  MenuViewController.swift
//  Pong
//
//  Created by hp omen on 30/03/2022.
//  Copyright © 2022 hp omen. All rights reserved.
//

import UIKit

class NiveauxViewController: UIViewController,CanRecieve {
    
    func passDataBack(data: Int) {
        
        print(data)
        
        for bouton_niveau in boutons_niveaux {
            print(bouton_niveau.tag)
            if bouton_niveau.tag == data {
                bouton_niveau.isEnabled = true
            }
        }
    }
    
    
    
    @IBOutlet var boutons_niveaux: [UIButton]!
    
    @IBAction func retour_niveaux(_ sender: UIStoryboardSegue) {
     // No code needed, no need to connect the IBAction explicitely

    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.*
        
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "niveau1_to_niveaux" {
            let secondVC = segue.destination as! Niveau1ViewController
            secondVC.delegate = self
        }
    }
    

}
