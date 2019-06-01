//
//  AwaitVagaViewController.swift
//  Smart Parking
//
//  Created by Gabriel Dragoni on 28/05/19.
//  Copyright © 2019 Dragoni. All rights reserved.
//

import UIKit
import MBProgressHUD

class AwaitVagaViewController: UIViewController {
    @IBOutlet var vagaLabel: UILabel!
    @IBOutlet var instructionLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    var vaga: Vaga!
    var timer: Timer!
    var time: Int = 30
    
    override func viewDidLoad() {
        
        vagaLabel.text = vaga.pos
        instructionLabel.text = "Vá para sua vaga!"
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
            self.time-=1
            self.timeLabel.text = "\(self.time)"
            self.checkVagaOcupada()
            
            if self.time == 10 {
                self.timeLabel.textColor = .red
            }
            
            if self.time == 0 {
                timer.invalidate()
                Webservice.putVaga(id: self.vaga.id, disponibilidade: .disponivel)
                self.terminateParking(msg: "Tempo acabou! Escolha outra vaga!")
            }
        })
    }
    
    @IBAction func backDidTapped() {
        timer.invalidate()
        Webservice.putVaga(id: self.vaga.id, disponibilidade: .disponivel)
        self.terminateParking(msg: "Sua reserva foi cancelada!")
    }
    
    func checkVagaOcupada() {
        Webservice.getVagas(disponibilidade: .ocupada, onSucces: { vagas in
            if vagas.contains(where: { $0.id == self.vaga.id }) {
                self.timer.invalidate()
                self.instructionLabel.text = "Você está estacionado aqui"
                self.timeLabel.text = "Chegou!"
                self.timeLabel.textColor = .green
                
                self.timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { _ in
                    self.checkVagaDisponivel()
                })
            }
        }, onError: {
            print($0)
        })
    }
    
    func checkVagaDisponivel() {
        Webservice.getVagas(disponibilidade: .disponivel, onSucces: { vagas in
            if vagas.contains(where: { $0.id == self.vaga.id }) {
                self.terminateParking(msg: "Adeus e Boa viagem!")
            }
        }, onError: {
            print($0)
        })
    }
    
    func terminateParking(msg: String) {
        let hud = MBProgressHUD.showAdded(to: navigationController!.view, animated: true)
        hud.label.text = msg
        hud.mode = .text
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            hud.hide(animated: true)
            self.navigationController?.popViewController(animated: true)
        })
    }
}
