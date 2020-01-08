//
//  VideoPlayerController.swift
//  iCReP
//
//  Created by Máster Móviles on 08/01/2020.
//  Copyright © 2020 Máster Móviles. All rights reserved.
//
import UIKit
import QuartzCore

class AnimacionesViewController: UIViewController {
    
    var capaPortada: CALayer!
    @IBOutlet weak var btVenAqui: UIButton!
    
    override func viewDidLoad() {
    
            super.viewDidLoad()
            // Do any additional setup after loading the view, typically from a nib.
        
            self.capaPortada = CALayer()
            self.capaPortada.position = self.view.center
            self.capaPortada.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
            
            // TODO (a) Configurar la capa con
            // 1. Radio de esquinas 10
            self.capaPortada.cornerRadius = 10
            // 2. Grosor de borde 2
        self.capaPortada.borderWidth = 2
            // 3. Color de fondo blanco
        self.capaPortada.backgroundColor = UIColor.white.cgColor
            // 4. Color de borde gris
        self.capaPortada.borderColor = UIColor.gray.cgColor
            
            // ...
            
            self.capaPortada.contents = (UIImage(named: "resplandor.jpg")!.cgImage! as Any)
            self.capaPortada.contentsGravity = CALayerContentsGravity.resizeAspect
            
            self.view.layer.addSublayer(self.capaPortada)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func actionMoverAqui(_ sender: UIButton) {
        // TODO (b) Hacer que la capa con la imagen de la pelicula (self.capaPortada) se mueva a la posición que ocupa el botón pulsado (sender.center) de forma animada
        UIView.animate(withDuration: 5.0) {
            self.capaPortada.position.x = sender.center.x
            self.capaPortada.position.y = sender.center.y
        }
    }
    
}

