//
//  ViewController.swift
//  its a zoo
//
//  Created by Ryan Zhou on 1/15/24.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet var label: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    
    var animals: [Animal] = []
    var audioPlayer: AVAudioPlayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        // Do any additional setup after loading the view.
        
        let animal1 = Animal(name: "Atom", species: "Dog", age: 2, image: UIImage(named: "atom")!, soundPath: "dog_sound")
        let animal2 = Animal(name: "Miumiu", species: "Cat", age: 4, image: UIImage(named: "miumiu")!, soundPath: "cat_sound")
        let animal3 = Animal(name: "Jack", species: "Rooster", age: 5, image: UIImage(named: "rooster")!, soundPath: "rooster_sound")
                
        animals.append(contentsOf: [animal1, animal2, animal3])
        
        animals.shuffle()
        
        label.text = animals[0].species
        
        animals.forEach { animal in
            print(animal.name)
        }
        
        scrollView.contentSize = CGSize(width: 1179, height: 600)
        scrollView.isPagingEnabled = true
        
        let buttonWidth: CGFloat = 100 // The width of the buttons
        let buttonHeight: CGFloat = 50 // The height of the buttons
        let scrollViewWidth = scrollView.frame.size.width
        
        for (i, animal) in animals.enumerated() {
            let buttonX = scrollViewWidth * CGFloat(i) + scrollViewWidth / 2 - buttonWidth / 2
            let buttonFrame = CGRect(x: buttonX, y: 0, width: buttonWidth, height: buttonHeight)
            
            let button = UIButton(frame: buttonFrame)
            
            button.setTitle(animal.name, for: .normal)
            button.backgroundColor = .gray
            button.tag = i
            
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            
            scrollView.addSubview(button)
        }
        
        let imageY: CGFloat = buttonHeight + 20
        let imageHeight: CGFloat = scrollView.frame.size.height - buttonHeight - 20
        
        for (i, animal) in animals.enumerated() {
            let imageX = scrollViewWidth * CGFloat(i)
            let imageFrame = CGRect(x: imageX, y: imageY, width: scrollViewWidth, height: imageHeight)
            let imageView = UIImageView(frame: imageFrame)
            
            imageView.contentMode = .scaleAspectFit
            imageView.image = animal.image
            
            scrollView.addSubview(imageView)
        }
    }
    
    // https://www.tutorialspoint.com/how-to-play-a-sound-using-swift
    @objc func buttonTapped(_ button: UIButton) {
        let animalIndex = button.tag
        
        let animal = animals[animalIndex]
        
        let alertController = UIAlertController(title: animal.name, message: "This \(animal.species) is \(animal.age) years old.", preferredStyle: .alert)
        
        let playSoundAction = UIAlertAction(title: "Play Sound", style: .default) { [weak self] _ in
            self?.playSound(for: animal)
            print(animal.description)
        }
        alertController.addAction(playSoundAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    // https://www.youtube.com/watch?v=sih5_9c_NVw
    func playSound(for animal: Animal) {
        guard let soundURL = Bundle.main.url(forResource: animal.soundPath, withExtension: "wav") else {
            print("Sound file not found")
            print(animal.soundPath)
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.play()
        } catch let error {
            print("Error playing sound. \(error.localizedDescription)")
        }
    }
    
}

// https://stackoverflow.com/questions/35385856/how-to-make-a-label-fade-in-or-out-in-swift
extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth: CGFloat = 393
        let currentPage: Int = Int(scrollView.contentOffset.x / pageWidth)
        print(scrollView.contentOffset.x)
        label.text = animals[currentPage].species
        
        let alphaValue = 1 - (abs(scrollView.contentOffset.x - CGFloat(currentPage) * pageWidth) / pageWidth)
        label.alpha = alphaValue
    }
}

