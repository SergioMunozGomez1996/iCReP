//
//  ProcesamientoImagenesController.swift
//  iCReP
//
//  Created by Máster Móviles on 08/01/2020.
//  Copyright © 2020 Máster Móviles. All rights reserved.
//


import UIKit
import GLKit
import CoreImage

class ProcesamientoImagenesController: UIViewController, GLKViewDelegate {

    var contextGPU : CIContext?
    var contextCPU : CIContext?
    
    var imagenOriginal : CIImage?
    var imagenFiltrada : CIImage?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var glkView: GLKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.imagenOriginal = CIImage(contentsOf: Bundle.main.url(forResource: "foto", withExtension: "jpg")!)
        
        let api: EAGLRenderingAPI = EAGLRenderingAPI.openGLES2
        let glContext = EAGLContext(api: api)
        
        self.glkView.context = glContext!;
        self.glkView.delegate = self;

        self.contextGPU = CIContext(eaglContext: glContext!)
        self.contextCPU = CIContext(options: nil)
    }

    func glkView(_ view: GLKView, drawIn rect: CGRect) {
        let dest = CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.width * view.contentScaleFactor, height: rect.size.height * view.contentScaleFactor)
        self.contextGPU?.draw(self.imagenFiltrada!, in: dest, from: (self.imagenFiltrada?.extent)!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if !(self.imagenFiltrada != nil){
            self.imagenFiltrada = self.imagenOriginal
        }
        self.glkView.display()
    }

    @IBAction func sliderCpuCambia(_ sender: UISlider) {
    
        // TODO (a) Realizar el filtrado utilizando el contexto CPU
        // 1. Crear filtro CISepiaTone con intensidad sender.value, y aplicarlo a self.imagenOriginal
        let filter = CIFilter(name: "CISepiaTone")
        filter?.setValue(sender.value, forKey: kCIInputIntensityKey)
        filter?.setValue(self.imagenOriginal, forKey: kCIInputImageKey)
        // 2. Obtener salida del filtro
        let outputImage = UIImage(ciImage: (filter?.outputImage)!)
        // 3. Obtener CGImageRef a partir de la imagen de salida del filtro, utilizando self.contextCPU
        let cgiimg = self.contextCPU?.createCGImage((filter?.outputImage)!, from:(filter?.outputImage?.extent)!)
        // 4. Mostrar la imagen resultante el self.imageView (construir UIImage a partir de CGImageRef)
        self.imageView.image = UIImage(cgImage: cgiimg!)
        
    }
    
    @IBAction func sliderGpuCambia(_ sender: UISlider) {
        
        // TODO (b) Realizar el filtrado utilizando el contexto GPU
        // 1. Crear filtro CISepiaTone con intensidad sender.value, y aplicarlo a self.imagenOriginal
        let filter = CIFilter(name: "CISepiaTone")
        filter?.setValue(sender.value, forKey: kCIInputIntensityKey)
        filter?.setValue(self.imagenOriginal, forKey: kCIInputImageKey)
        // 2. Obtener salida del filtro
        let outputImage = UIImage(ciImage: (filter?.outputImage)!)
        // 3. Guardar la salida del filtro en self.imagenFiltrada
        let cgiimg = self.contextGPU?.createCGImage((filter?.outputImage)!, from:(filter?.outputImage?.extent)!)
        self.imagenFiltrada = CIImage(cgImage: cgiimg!)

        
        self.glkView.display()


    }
    @IBAction func agregarFoto(_ sender: UIButton) {
        UIImageWriteToSavedPhotosAlbum(self.imageView.image!, self, #selector(guardaimage(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    
    @objc func guardaimage(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {

        if let error = error {

            // we got back an error!

            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)

            ac.addAction(UIAlertAction(title: "OK", style: .default))

            present(ac, animated: true)

        } else {

            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)

            ac.addAction(UIAlertAction(title: "OK", style: .default))

            present(ac, animated: true)

        }

    }
}

