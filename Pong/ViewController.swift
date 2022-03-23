//
//  ViewController.swift
//  Pong
//
//  Created by hp omen on 01/03/2022.
//  Copyright © 2022 hp omen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var raquette: UIImageView!
    
    @IBOutlet weak var balle: UIImageView!
    
    var t:Timer!
    var v = CGPoint(x: 10.0,y: 10.0) // initialise la vitesse de la balle
    
    // touches = ensemble de UITouch (sorte de tableau, ensemble de touches)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        // prend moi un element aleatoire de l'ensemble
        let d = touches.randomElement()!
        // on demande les repères de la touche par rapport à la view
        let c = d.location(in: view)
        
        raquette.center.x = c.x
        
        print("L'écran a été touché en x=\(c.x) et y=\(c.y)")
        
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        // prend moi un element aleatoire de l'ensemble
        let d = touches.randomElement()!
        // on demande les repères de la touche par rapport à la view
        let c = d.location(in: view)
        
        raquette.center.x = c.x
        
        print("Le doigt a glissé en x=\(c.x) et y=\(c.y)")
        
    }
    
    
    
    
    // boucle qui se répète
    @objc func boucle (t:Timer) {
        balle.center.x += v.x
        balle.center.y += v.y
        
        if balle.center.x > view.frame.size.width || balle.center.x < 0 {
            v.x = -v.x
        }
        
        if balle.center.y > view.frame.size.height || balle.center.y < 0 {
            v.y = -v.y
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // avec le "!", pas besoin de mettre de valeur initiale (il s'agit d'un optionnal a deballage automatique)
        
        
        
        print("Le point d'ancrage de la balle se trouve en x=\(balle.frame.origin.x) et y=\(balle.frame.origin.y)")
        
        balle.center.x = view.frame.size.width / 2
        balle.center.y = view.frame.size.height / 2
        
        // définition du Timer
        t = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(boucle), userInfo: nil, repeats: true)
        
    }


}

