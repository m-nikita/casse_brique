//
//  Niveau3ViewController.swift
//  Pong
//
//  Created by hp omen on 02/04/2022.
//  Copyright © 2022 hp omen. All rights reserved.
//


import UIKit
import AVFoundation
import AVKit

protocol CanRecieve3 {
    func passDataBack(data: Int)
}

class Niveau3ViewController: UIViewController {

    @IBOutlet weak var raquette: UIImageView!
    
    @IBOutlet weak var balle: UIImageView!

    @IBOutlet var briques: [UIImageView]!
    
    @IBOutlet weak var bouton_rejouer: UIButton!
    
    @IBOutlet weak var bordure_superieure: UILabel!
    
    @IBOutlet weak var bouton_pause: UIButton!
    
    var bouton_pause_clique = false
    
    @IBOutlet weak var indicateur_nombre_briques_detruites: UILabel!
    
    @IBOutlet weak var indicateur_nombre_vies_restantes: UILabel!
    
    @IBAction func mettre_jeu_en_pause(_ sender: UIButton) {
        
        if bouton_pause_clique == false {
            bruitage_bouton_navigation!.play()
            t.invalidate()
            print("Le jeu est en pause")
            bouton_pause_clique = true
        } else {
            bruitage_bouton_navigation!.play()
            t = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(boucle), userInfo: nil, repeats: true)
            print("Le jeu n'est plus en pause")
            bouton_pause_clique = false
        }
    }
    
    @IBAction func rejouer(_ sender: Any) {
        bruitage_bouton_navigation!.play()
        if niveau_reussi == 3 {
            delegate?.passDataBack(data: niveau_reussi)
        }
        self.view.layoutIfNeeded()
    }
    
    var bruitage_vie_perdue : AVAudioPlayer?
    var bruitage_brique_touchee : AVAudioPlayer?
    var bruitage_balle_rebond : AVAudioPlayer?
    var bruitage_bouton_navigation : AVAudioPlayer?
    var bruitage_niveau_gagne : AVAudioPlayer?
    var bruitage_niveau_perdu : AVAudioPlayer?
    
    var delegate:CanRecieve3?


    // revenir au menu et arrêter la boucle en fond du timer
    @IBAction func revenir_accueil(_ sender: Any) {
        bruitage_bouton_navigation!.play()
        delegate?.passDataBack(data: niveau_reussi)
        stopTimer()
        retirer_balle()
        retirer_raquette()
    }
    
    class Brique {
        
        var x: Int
        var y: Int
        var width: Int
        var height: Int
        
        init(x: Int, y: Int, width: Int, height: Int) {
            self.x = x
            self.y = y
            self.width = width
            self.height = height
        }
    }
    
    var t:Timer!
    var v = CGPoint(x: 10.0,y: 10.0) // initialise la vitesse de la balle
    var niveau_reussi = -1
    
    // touches = ensemble de UITouch (sorte de tableau, ensemble de touches)
        
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        // prend moi un element aleatoire de l'ensemble
        let d = touches.randomElement()!
        // on demande les repères de la touche par rapport à la view
        let c = d.location(in: view)
        
        if bouton_pause_clique == false {
            
            if c.x >= raquette.frame.size.width/2 && c.x <= view.frame.size.width - (raquette.frame.size.width/2) {
                raquette.center.y = 857.0
                raquette.center.x = c.x
                //print("L'écran a été touché en x=\(c.x) et y=\(c.y)")
                //print("Le doigt a glissé en x=\(c.x) et y=\(c.y)")
            }
        }
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        // prend moi un element aleatoire de l'ensemble
        let d = touches.randomElement()!
        // on demande les repères de la touche par rapport à la view
        let c = d.location(in: view)
        
        if bouton_pause_clique == false {
            
            if c.x >= raquette.frame.size.width/2 && c.x <= view.frame.size.width - (raquette.frame.size.width/2) {
                raquette.center.x = c.x
                //print("Le doigt a glissé en x=\(c.x) et y=\(c.y)")
            }
        }
    }
    
    
    var compteur_briques_touchees = 0
    var nombre_vies = 3
    
    
    // boucle qui se répète
    @objc func boucle (t:Timer) {
        
        if nombre_vies == 0 {
            bruitage_niveau_perdu!.play()
            retirer_toutes_les_briques()
            fin_du_niveau()
            print("Vous n'avez plus de vie")
        }
        
        indicateur_nombre_briques_detruites.text = "\(compteur_briques_touchees)/\(briques.count)"
        
        indicateur_nombre_vies_restantes.text = "x\(nombre_vies)"
        
        balle.center.x += v.x
        balle.center.y += v.y
        
        if balle.center.x > (view.frame.size.width - (balle.frame.size.width/2)) || balle.center.x < (0 + (balle.frame.size.width/2)) {
            bruitage_balle_rebond!.stop()
            bruitage_balle_rebond!.currentTime = 0
            bruitage_balle_rebond!.play()
            v.x = -v.x
        }
        
        if balle.center.y < (bordure_superieure.frame.minY + (balle.frame.size.width/2)) {
            print("La balle a touché le haut de la bordure")
            bruitage_balle_rebond!.stop()
            bruitage_balle_rebond!.currentTime = 0
            bruitage_balle_rebond!.play()
            v.y = -v.y
        }
        
        if balle.center.y > view.frame.size.height {
            print("PERDU ! La balle a touché le bas de l'écran")
            bruitage_vie_perdue!.play()
            nombre_vies -= 1
            // remettre la balle au centre de la raquette du joueur
            v.y = -v.y
            balle.center.x = raquette.center.x
            balle.center.y = 828
        }
        
        if balle.center.y >= (raquette.center.y - (raquette.frame.size.height)) && balle.center.y <= (raquette.center.y + (raquette.frame.size.height)) {
            print("La balle se trouve à la même hauteur que la raquette")
            if balle.center.x >= (raquette.center.x - (raquette.frame.size.width/2)) && balle.center.x <= (raquette.center.x + (raquette.frame.size.width/2)) {
                print("La balle se trouve dans la largeur de la raquette")
                if balle.center.x >= (raquette.center.x - (raquette.frame.size.width/2)) && balle.center.x <= (raquette.center.x - (balle.frame.size.width/2)) {
                    print("La balle se trouve sur la gauche de la raquette")
                }
                if balle.center.x >= (raquette.center.x + (balle.frame.size.width/2)) && balle.center.x <= (raquette.center.x + (raquette.frame.size.width/2)) {
                    print("La balle se trouve sur la droite de la raquette")
                }
                bruitage_balle_rebond!.stop()
                bruitage_balle_rebond!.currentTime = 0
                bruitage_balle_rebond!.play()
                v.y = -v.y
            }
        }
        
        
        
        for brique in briques {
            let longeur_tableau_briques = briques.count
            
            
            let balle_haut = balle.center.y - (balle.frame.size.height/2)
            let balle_bas = balle.center.y + (balle.frame.size.height/2)
            let balle_gauche = balle.center.x - (balle.frame.size.width/2)
            let balle_droite = balle.center.x + (balle.frame.size.width/2)
            
            let brique_haut = brique.center.y - (brique.frame.size.height/2)
            let brique_bas = brique.center.y + (brique.frame.size.height/2)
            let brique_gauche = brique.center.x - (brique.frame.size.width/2)
            let brique_droite = brique.center.x + (brique.frame.size.width/2)
            
            func evenement_apres_brique_touchee() {
                print("La brique est touché par la balle")
                bruitage_brique_touchee!.stop()
                bruitage_brique_touchee!.currentTime = 0
                bruitage_brique_touchee!.play()
                
                
                brique.isHidden = true
                brique.frame = CGRect(x: 0, y: 0, width: 0, height: 0); view.addSubview(brique)
                compteur_briques_touchees += 1
                indicateur_nombre_briques_detruites.text = "\(compteur_briques_touchees)/\(briques.count)"
                print("\(compteur_briques_touchees)")
                if compteur_briques_touchees == longeur_tableau_briques {
                    bruitage_niveau_gagne!.play()
                    niveau_reussi = 4
                    print("Toutes les briques ont été touché")
                    fin_du_niveau()
                    print("Fin du niveau")
                }
            }
            
            
            if balle_haut <= brique_bas && balle_bas >= brique_haut{
                if balle_gauche <= brique_droite && balle_droite >= brique_gauche{
                    //print("Zone de la brique")
                    
                    
                    // BAS
                    if balle_haut < brique_bas && balle.center.y > brique_bas {

                        print("Brique touchée par le BAS")
                        v.y = -v.y
                        
                    // HAUT
                    }
                    else if balle_bas > brique_haut && balle.center.y < brique_haut {

                        print("Brique touchée par le HAUT")
                        v.y = -v.y
                    }
                        
                        
                        
                    // DROITE
                    else if balle_gauche < brique_droite && balle.center.x > brique_droite {
                        
                        print("Brique touchée par la DROITE")
                        v.x = -v.x
                        
                    // GAUCHE
                    }
                    else if balle_droite > brique_gauche && balle.center.x < brique_gauche {
                        
                        print("Brique touchée par la GAUCHE")
                        v.x = -v.x
                    }
                    evenement_apres_brique_touchee()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // avec le "!", pas besoin de mettre de valeur initiale (il s'agit d'un optionnal a deballage automatique)
        
        
        
        
        // BRUITAGE
        // Bundle = ensemble de fichiers
        
        // bruitage_vie_perdue
        let chemin = Bundle.main.path(forResource: "vie_perdue", ofType: "mp3")
        let url = URL(fileURLWithPath: chemin!)
        do {
            bruitage_vie_perdue = try AVAudioPlayer(contentsOf: url)
        } catch {
            print("Erreur à l'initialisation du son")
        }
        
        // bruitage_vie_perdue
        let chemin2 = Bundle.main.path(forResource: "brique_touchee", ofType: "wav")
        let url2 = URL(fileURLWithPath: chemin2!)
        do {
            bruitage_brique_touchee = try AVAudioPlayer(contentsOf: url2)
        } catch {
            print("Erreur à l'initialisation du son")
        }
        
        // bruitage_balle_rebond
        let chemin3 = Bundle.main.path(forResource: "balle_rebond", ofType: "wav")
        let url3 = URL(fileURLWithPath: chemin3!)
        do {
            bruitage_balle_rebond = try AVAudioPlayer(contentsOf: url3)
        } catch {
            print("Erreur à l'initialisation du son")
        }
        
        // bruitage_bouton_navigation
        let chemin4 = Bundle.main.path(forResource: "bouton_navigation", ofType: "wav")
        let url4 = URL(fileURLWithPath: chemin4!)
        do {
            bruitage_bouton_navigation = try AVAudioPlayer(contentsOf: url4)
        } catch {
            print("Erreur à l'initialisation du son")
        }
        
        // bruitage_niveau_gagne
        let chemin5 = Bundle.main.path(forResource: "niveau_gagne", ofType: "wav")
        let url5 = URL(fileURLWithPath: chemin5!)
        do {
            bruitage_niveau_gagne = try AVAudioPlayer(contentsOf: url5)
        } catch {
            print("Erreur à l'initialisation du son")
        }
        
        // bruitage_niveau_perdu
        let chemin6 = Bundle.main.path(forResource: "niveau_perdu", ofType: "wav")
        let url6 = URL(fileURLWithPath: chemin6!)
        do {
            bruitage_niveau_perdu = try AVAudioPlayer(contentsOf: url6)
        } catch {
            print("Erreur à l'initialisation du son")
        }
        
        
        
        
        
        
        print("Le point d'ancrage de la balle se trouve en x=\(balle.frame.origin.x) et y=\(balle.frame.origin.y)")
        
        v.y = -v.y
        balle.center.x = view.frame.size.width / 2
        balle.center.y = 828

        
        // définition du Timer
        t = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(boucle), userInfo: nil, repeats: true)
        
    }
    

    func stopTimer() {
        print("Fin du timer permettant le fonctionnement de la boucle")
        t.invalidate()
    }
    
    func retirer_balle() {
        balle.isHidden = true
        balle.frame = CGRect(x: 100, y: 100, width: 0, height: 0); view.addSubview(balle)
        print("Balle retirée de l'écran et masquée")
    }
    
    func retirer_raquette() {
        raquette.isHidden = true
        raquette.frame = CGRect(x: 0, y: 0, width: 0, height: 0); view.addSubview(balle)
        print("Raquette retirée de l'écran et masquée")
    }
    
    func retirer_toutes_les_briques() {
        for brique in briques {
            brique.isHidden = true
            brique.frame = CGRect(x: 0, y: 0, width: 0, height: 0); view.addSubview(brique)
        }
    }
    
    func fin_du_niveau() {
        bouton_pause.isHidden = true
        stopTimer()
        retirer_balle()
        retirer_raquette()
        bouton_rejouer.isHidden = false
    }
    
    
    
    
}

