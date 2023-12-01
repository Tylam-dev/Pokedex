//
//  PokemonDescripController.swift
//  Pokedex
//
//  Created by Tyrone Vera on 29/11/23.
//

import UIKit
import Alamofire
import Kingfisher

class PokemonDescripController: UIViewController {
    @IBOutlet weak var pokeImg: UIImageView!
    var pokemonShow = 0
    @IBOutlet weak var type1: UILabel!
    @IBOutlet weak var type2: UILabel!
    @IBOutlet weak var pokemonName: UILabel!
    
    @IBOutlet weak var switchShiny: UISwitch!
    @IBOutlet weak var switchMale: UIButton!
    @IBOutlet weak var switchFemale: UIButton!
    var pokeView: (face: String, genre: String) = ("front","male")
    
    var pokemonImgDic: [String: URL?] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPokemon(pokemonShow)
        switchMale.layer.masksToBounds = true
        switchMale.layer.cornerRadius = 10
        switchMale.layer.borderWidth = 5
        switchMale.layer.borderColor = CGColor(red: 0, green: 0.80, blue: 0, alpha: 1)
        switchFemale.layer.masksToBounds = true
        switchFemale.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }
    func setType (_ tipo: String, _ label: UILabel){
            DispatchQueue.main.async{
                label.text = tipo.capitalized
                label.layer.masksToBounds = true
                label.layer.cornerRadius = 10
                self.setColorType(tipo, label)
            }
    }
    func fetchPokemon(_ num: Int){
        AF.request("https://pokeapi.co/api/v2/pokemon/\(String(num))")
            .responseDecodable(of: PokemonData.self){ response in
                switch response.result{
                case .success(let value):
                    // MARK: - Set Image
                    if let image = value.sprites?.frontDefault {
                        if let imageUrl = URL(string: image){
                            DispatchQueue.main.async{
                                self.pokeImg.kf.setImage(with: imageUrl)
                            }
                        }
                    }
                    // MARK: - Set Type1
                    if let tipo1 = value.types?[0].type?.name {
                        self.setType(tipo1, self.type1)
                    }
                    // MARK: - Set Type2
                    if let tipos = value.types {
                        if tipos.count == 2{
                            if let secondType = value.types?[1].type?.name{
                                self.setType(secondType, self.type2)
                            }
                        }else {
                            self.type2.isHidden = true
                        }
                    }
                    //MARK: - Set Name
                    if let name = value.name, let id = value.id {
                        DispatchQueue.main.async {
                            self.pokemonName.text = "\(name.capitalized) #\(id)"
                        }
                    }
                    //MARK: - Images extarction
                    if let imgFrontM = value.sprites?.frontDefault{
                        self.pokemonImgDic["imgFrontM"] = URL(string: imgFrontM)
                    }
                    if let imgBackM = value.sprites?.backFemale{
                        self.pokemonImgDic["imgBackM"] = URL(string: imgBackM)
                    }
                    if let frontSM = value.sprites?.frontShiny{
                        self.pokemonImgDic["frontSM"] = URL(string: frontSM)
                    }
                    if let frontSF = value.sprites?.frontShinyFemale{
                        self.pokemonImgDic["frontSF"] = URL(string: frontSF)
                    }
                    if let imgFrontF = value.sprites?.frontFemale{
                        self.pokemonImgDic["imgFrontF"] = URL(string: imgFrontF)
                    }
                    if let imgBackF = value.sprites?.backFemale{
                        self.pokemonImgDic["imgBackF"] = URL(string: imgBackF)
                    }
                    if let backSM = value.sprites?.backShiny{
                        self.pokemonImgDic["backSM"] = URL(string: backSM)
                    }
                    if let backSF = value.sprites?.backShinyFemale{
                        self.pokemonImgDic["backSF"] = URL(string: backSF)
                    }
                    if let img3d = value.sprites?.other?.home?.frontDefault{
                        self.pokemonImgDic["img3d"] = URL(string: img3d)
                    }
                    if let img3dS = value.sprites?.other?.home?.frontShiny{
                        self.pokemonImgDic["img3dS"] = URL(string: img3dS)
                    }
                case .failure(let failure):
                    print(failure)
                }
            }
        
    }
    
    @IBAction func SwitchToMale() {
        if switchShiny.isOn{
            if let maleImgS = pokemonImgDic["frontSM"]{
                pokeImg.kf.setImage(with: maleImgS)
            }
            self.pokeView.genre = "male"
            switchMale.layer.borderWidth = 5
            switchMale.layer.borderColor = CGColor(red: 0, green: 0.80, blue: 0, alpha: 1)
        }else{
            if let maleImg = pokemonImgDic["imgFrontM"]{
                pokeImg.kf.setImage(with: maleImg)
            }
            self.pokeView.genre = "male"
            switchMale.layer.borderWidth = 5
            switchMale.layer.borderColor = CGColor(red: 0, green: 0.80, blue: 0, alpha: 1)
        }
        switchFemale.layer.borderWidth = 0
    }
    
    @IBAction func SwitchToFemale() {
        guard let _ = pokemonImgDic["imgFrontF"]else{
            switchMale.layer.borderWidth = 0
            switchFemale.layer.borderWidth = 5
            switchFemale.layer.borderColor = CGColor(red: 0, green: 0.80, blue: 0, alpha: 1)
            return
        }
        if switchShiny.isOn{
            if let femaleImgS = pokemonImgDic["frontSF"]{
                pokeImg.kf.setImage(with: femaleImgS)
            }
            self.pokeView.genre = "female"
            switchFemale.layer.borderWidth = 5
            switchFemale.layer.borderColor = CGColor(red: 0, green: 0.80, blue: 0, alpha: 1)
        }else{
            if let femaleImg = pokemonImgDic["imgFrontF"]{
                pokeImg.kf.setImage(with: femaleImg)
            }
            self.pokeView.genre = "female"
            switchFemale.layer.borderWidth = 5
            switchFemale.layer.borderColor = CGColor(red: 0, green: 0.80, blue: 0, alpha: 1)
        }
        switchMale.layer.borderWidth = 0
    }
    @IBAction func switchShinyAction(_ sender: UISwitch) {
        if sender.isOn {
            switch pokeView {
            case ("front", "male"):
                if let maleImgS = pokemonImgDic["frontSM"]{
                    pokeImg.kf.setImage(with: maleImgS)
                }
            case ("front", "female"):
                if let femaleImgS = pokemonImgDic["frontSF"]{
                    pokeImg.kf.setImage(with: femaleImgS)
                }
            case (_,_):
                return
            }
        }else{
            switch pokeView {
            case ("front", "male"):
                if let DefaultImg = self.pokemonImgDic["imgFrontM"]{
                    self.pokeImg.kf.setImage(with: DefaultImg)}
            case ("front", "female"):
                if let femaleImg = self.pokemonImgDic["imgFrontF"]{
                    self.pokeImg.kf.setImage(with: femaleImg)}
            case (_,_):
                return
            }
        }
    }
    //MARK: - Color Type
    func setColorType(_ type:String, _ uiLabel: UILabel){
        switch type {
        case "grass":
            uiLabel.backgroundColor = UIColor(red: 0, green: 0.45, blue: 0, alpha: 1)
        case "poison":
            uiLabel.backgroundColor = UIColor(red: 0.5, green: 0, blue: 1, alpha: 1)
        case "flying":
            uiLabel.backgroundColor = UIColor(red: 0.38, green: 0.44, blue: 0.81, alpha: 1)
        case "bug":
            uiLabel.backgroundColor = UIColor(red: 0.58, green: 0.62, blue: 0.20, alpha: 1)
        case "dark":
            uiLabel.backgroundColor = UIColor(red: 0.21, green: 0.18, blue: 0.13, alpha: 1)
        case "dragon":
            uiLabel.backgroundColor = UIColor(red: 0.43, green: 0.36, blue: 0.84, alpha: 1)
        case "electric":
            uiLabel.backgroundColor = UIColor(red: 0.93, green: 0.73, blue: 0.27, alpha: 1)
        case "fairy":
            uiLabel.backgroundColor = UIColor(red: 0.81, green: 0.58, blue: 0.84, alpha: 1)
        case "fighting":
            uiLabel.backgroundColor = UIColor(red: 0.45, green: 0.21, blue: 0.12, alpha: 1)
        case "fire":
            uiLabel.backgroundColor = UIColor(red: 0.85, green: 0.30, blue: 0, alpha: 1)
        case "ghost":
            uiLabel.backgroundColor = UIColor(red: 0.38, green: 0.37, blue: 0.67, alpha: 1)
        case "ground":
            uiLabel.backgroundColor = UIColor(red: 0.79, green: 0.68, blue: 0.39, alpha: 1)
        case "ice":
            uiLabel.backgroundColor = UIColor(red: 0.65, green: 0.87, blue: 0.97, alpha: 1)
        case "normal":
            uiLabel.backgroundColor = UIColor(red: 0.77, green: 0.74, blue: 0.71, alpha: 1)
        case "psychic":
            uiLabel.backgroundColor = UIColor(red: 0.83, green: 0.32, blue: 0.48, alpha: 1)
        case "rock":
            uiLabel.backgroundColor = UIColor(red: 0.60, green: 0.52, blue: 0.28, alpha: 1)
        case "steel":
            uiLabel.backgroundColor = UIColor(red: 0.69, green: 0.69, blue: 0.75, alpha: 1)
        case "water":
            uiLabel.backgroundColor = UIColor(red: 0.26, green: 0.52, blue: 0.90, alpha: 1)
        default:
            return
        }
    }
}
