//
//  GameViewController.swift
//  Pong
//
//  Created by hp omen on 30/03/2022.
//  Copyright © 2022 hp omen. All rights reserved.
//


import UIKit

protocol CanRecieve {
    func passDataBack(data: Int)
}

class Niveau1ViewController: UIViewController {

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
            t.invalidate()
            print("Le jeu est en pause")
            bouton_pause_clique = true
        } else {
            t = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(boucle), userInfo: nil, repeats: true)
            print("Le jeu n'est plus en pause")
            bouton_pause_clique = false
        }
    }
    
    @IBAction func rejouer(_ sender: Any) {
        if niveau_reussi == 2 {
            delegate?.passDataBack(data: niveau_reussi)
        }
        self.view.layoutIfNeeded()
    }
    
    var delegate:CanRecieve?


    // revenir au menu et arrêter la boucle en fond du timer
    @IBAction func revenir_accueil(_ sender: Any) {
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
            retirer_toutes_les_briques()
            fin_du_niveau()
            print("Vous n'avez plus de vie")
        }
        
        indicateur_nombre_briques_detruites.text = "\(compteur_briques_touchees)/\(briques.count)"
        
        indicateur_nombre_vies_restantes.text = "x\(nombre_vies)"
        
        balle.center.x += v.x
        balle.center.y += v.y
        
        if balle.center.x > (view.frame.size.width - (balle.frame.size.width/2)) || balle.center.x < (0 + (balle.frame.size.width/2)) {
            v.x = -v.x
        }
        
        if balle.center.y < (bordure_superieure.frame.minY + (balle.frame.size.width/2)) {
            print("La balle a touché le haut de la bordure")
            v.y = -v.y
        }
        
        if balle.center.y > view.frame.size.height {
            print("PERDU ! La balle a touché le bas de l'écran")
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
                v.y = -v.y
            }
        }
        
        
        
        for brique in briques {
            let longeur_tableau_briques = briques.count
            if balle.center.x >= (brique.center.x - (brique.frame.size.width/2) - balle.frame.width/2) && balle.center.x <= (brique.center.x + (brique.frame.size.width/2) + balle.frame.width/2) {
                
                if balle.center.y >= (brique.center.y - (brique.frame.size.height/2) - balle.frame.height/2) && balle.center.y <= (brique.center.y + (brique.frame.size.height/2) + balle.frame.height/2){
                    
                    // test malus
                    //if brique.tag == 1 {
                    //    raquette.frame.size.width = 50
                    //}
                    
                    print("La brique est touché par la balle")
                    v.y = -v.y
                    brique.isHidden = true
                    brique.frame = CGRect(x: 0, y: 0, width: 0, height: 0); view.addSubview(brique)
                    compteur_briques_touchees += 1
                    indicateur_nombre_briques_detruites.text = "\(compteur_briques_touchees)/\(briques.count)"
                    print("\(compteur_briques_touchees)")
                    if compteur_briques_touchees == longeur_tableau_briques {
                        niveau_reussi = 2
                        print("Toutes les briques ont été touché")
                        fin_du_niveau()
                        print("Fin du niveau")
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // avec le "!", pas besoin de mettre de valeur initiale (il s'agit d'un optionnal a deballage automatique)
        
        
        
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






