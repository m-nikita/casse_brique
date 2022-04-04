//
//  MenuViewController.swift
//  Pong
//
//  Created by hp omen on 30/03/2022.
//  Copyright © 2022 hp omen. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class NiveauxViewController: UIViewController,CanRecieve, CanRecieve2, CanRecieve3 {
    
    var bruitage_bouton_navigation : AVAudioPlayer?
    var bruitage_musique_fond : AVAudioPlayer?
    
    func passDataBack(data: Int) {
        
        print(data)
        
        for bouton_niveau in boutons_niveaux {
            print(bouton_niveau.tag)
            if bouton_niveau.tag <= data {
                bouton_niveau.setTitle("Niveau \(bouton_niveau.tag)", for: .normal)
                bouton_niveau.isEnabled = true
            }
        }
    }
    
    
    
    @IBOutlet var boutons_niveaux: [UIButton]!
    
    
    @IBAction func boutons_niveaux_cliques(_ sender: Any) {
        bruitage_bouton_navigation!.play()
        bruitage_musique_fond!.stop()
    }
    
    @IBAction func retour_niveaux(_ sender: UIStoryboardSegue) {
     // No code needed, no need to connect the IBAction explicitely
        bruitage_musique_fond!.currentTime = 0
        bruitage_musique_fond!.play()

    }
    
    @IBAction func bruitage_bouton_informations(_ sender: Any) {
        bruitage_bouton_navigation!.play()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.*
        
        // bruitage_bouton_navigation
        let chemin4 = Bundle.main.path(forResource: "bouton_navigation", ofType: "wav")
        let url4 = URL(fileURLWithPath: chemin4!)
        do {
            bruitage_bouton_navigation = try AVAudioPlayer(contentsOf: url4)
        } catch {
            print("Erreur à l'initialisation du son")
        }
        
        // bruitage_musique_fond
        let chemin = Bundle.main.path(forResource: "musique_fond", ofType: "wav")
        let url = URL(fileURLWithPath: chemin!)
        do {
            bruitage_musique_fond = try AVAudioPlayer(contentsOf: url)
        } catch {
            print("Erreur à l'initialisation du son")
        }
        
        bruitage_musique_fond!.numberOfLoops = -1
        bruitage_musique_fond!.play()
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "niveau1_to_niveaux" {
            let secondVC = segue.destination as! Niveau1ViewController
            secondVC.delegate = self
        }
        if segue.identifier == "niveau2_to_niveaux" {
            let secondVC = segue.destination as! Niveau2ViewController
            secondVC.delegate = self
        }
        if segue.identifier == "niveau3_to_niveaux" {
            let secondVC = segue.destination as! Niveau3ViewController
            secondVC.delegate = self
        }
    }
    

}
