//
//  VideoPlayerController.swift
//  iCReP
//
//  Created by Máster Móviles on 08/01/2020.
//  Copyright © 2020 Máster Móviles. All rights reserved.
//
import UIKit
import AVFoundation
import AVKit
import MediaPlayer

class VideoPlayerController: UIViewController {

    var moviePlayer : AVPlayerLayer?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
       super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { (context) in
        }) { (context) in
            // TODO (b.3) Hacer que el tamaño del reproductor de AVPlayerLayer para que se ajuste al girar la pantalla.
            self.view.frame.size = size
            self.moviePlayer?.frame.size = size
           
        }
    }

    @objc func videoPlaybackDidFinish(_ notification: Notification) {
        self.moviePlayer?.removeFromSuperlayer()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        self.moviePlayer=nil
        
    }
    @IBAction func playVideo(_ sender: Any) {
        let videoURL = Bundle.main.url(forResource: "video", withExtension: "m4v")

        // 4. Comenzar la reproducción
                let player = AVPlayer(url: videoURL! as URL)
                let playerLayer = AVPlayerLayer(player: player)
                self.moviePlayer = playerLayer
                self.moviePlayer?.frame = self.view.bounds
                self.view.layer.addSublayer(playerLayer)
                player.play()
                
                // TODO (b.2) Escucha notificación de finalizacion de la reproduccion (NotificationCenter.default.addObserver) y llamar en ese caso a videoPlaybackDidFinish: para cerrar el reproductor
                NotificationCenter.default.addObserver(self,
                                                       selector: #selector(videoPlaybackDidFinish(_:)),
                name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                object: nil)
                
                // TODO (b.3) Hacer que el tamaño del reproductor de AVPlayerLayer para que se ajuste al girar la pantalla. Para ello deberemos sobreescribir el método viewWillTransition. (el código irá en el método con ese nombre)
                         
                // TODO (b.4) Personalizar el reproductor para que tenga como fondo un color lightGray. Deberemos manipular las propiedades del AVPlayerLayer
                self.moviePlayer?.backgroundColor = UIColor.gray.cgColor
    }
    
}
