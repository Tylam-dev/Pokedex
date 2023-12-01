//
//  PokemonCell.swift
//  Pokedex
//
//  Created by Tyrone Vera on 29/11/23.
//

import UIKit

class PokemonCell: UITableViewCell {
    
    @IBOutlet weak var nombrePokemon: UILabel!
    
    @IBOutlet weak var tipo1: UILabel!
    
    @IBOutlet weak var tipo2: UILabel!
    
    @IBOutlet weak var fotoPokemon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    /*func tiposPokemon( type1: String?, type2: String?) {
        if let firstType = type1 {
            switch firstType {
            case "azul":
                DispatchQueue.main.async {
                    self.tipo1.backgroundColor = UIColor(red: 4, green: 2, blue: 6, alpha: 100)
                }
            }
        }
    }*/
}
