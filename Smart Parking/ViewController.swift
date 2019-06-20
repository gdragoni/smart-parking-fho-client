//
//  ViewController.swift
//  Smart Parking
//
//  Created by Gabriel Dragoni on 14/05/19.
//  Copyright © 2019 Dragoni. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    
    var vagas: Vagas! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        reloadVagas()
        initReloadTimer()
    }
    
    func initReloadTimer() {
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { _ in
            self.reloadVagas()
        })
    }

    func reloadVagas() {
        Webservice.getVagas(disponibilidade: .disponivel, onSucces: {
            self.vagas = $0.sorted(by: { $0.pos < $1.pos })
            self.collectionView.reloadData()
        }, onError: {
            print($0)
        })
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vagas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VagaCell", for: indexPath) as! VagaCell
        let vaga = vagas[indexPath.row]
        cell.label.text = vaga.pos
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/3, height: collectionView.frame.width/3*2)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vaga = vagas[indexPath.row]
        
        Webservice.putVaga(id: vaga.id, disponibilidade: .reservada)
        performSegue(withIdentifier: "toAwaitVaga", sender: vaga)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  let vaga = sender as? Vaga,
            let destinationViewController = segue.destination as? AwaitVagaViewController {
            destinationViewController.vaga = vaga
        }
    }
}

