//
//  PokemonNameCell.swift
//  Pokedex
//
//  Created by Tyrone Vera on 29/11/23.
//

import UIKit

class PokemonNameCell: UITableViewCell {
    @IBOutlet weak var nombrePoke: UILabel!
    
    @IBOutlet weak var numPoke: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setupCell( _ nombre: String, _ num: String){
        nombrePoke.text = nombre.capitalized
        numPoke.text = "#\(num)"
    }
}
