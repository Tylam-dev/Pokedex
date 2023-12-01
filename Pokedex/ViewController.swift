//
//  ViewController.swift
//  Pokedex
//
//  Created by Tyrone Vera on 29/11/23.
//

import UIKit
import Alamofire
import Kingfisher
class ViewController: UIViewController {

    @IBOutlet weak var pokemonList: UITableView!
    var pokemonsName: [(String,String)] = []
    var pokemonView = 1
    @IBOutlet weak var findPokeFrom: UITextField!
    @IBOutlet weak var findPokeTo: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        pokemonList.delegate = self
        pokemonList.dataSource = self
        pokemonList.register(UINib(nibName:"PokemonNameCell", bundle: nil), forCellReuseIdentifier: "PokemonNameCell")
        fetchPokemons()
    }
    
    func fetchPokemons(_ from: String = "0", _ to: String = "100"){
        AF.request("https://pokeapi.co/api/v2/pokemon?limit=\(to)&offset=\(from)")
            .responseDecodable(of: PokemonListData.self) { response in
                switch response.result {
                case .success(let value):
                    self.pokemonsName = value.results?.map{
                        var idApi = ""
                        if let lastPathComponent = URL(string: $0.url ?? "") {
                            let number = String(lastPathComponent.lastPathComponent)
                            idApi = number
                        }
                        let pokeName = $0.name
                        return (idApi,pokeName)
                    } as! [(String, String)]
                    self.pokemonList.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokemonDescription" {
            let destination = segue.destination as! PokemonDescripController
            destination.pokemonShow = pokemonView
        }
    }

    @IBAction func findPokes(_ sender: UIButton) {
        guard let fromNum = Int(findPokeFrom.text ?? ""), let toNum = Int(findPokeTo.text ?? "")else{
            return
        }
        fetchPokemons(String(fromNum - 1), String((toNum - fromNum) + 1))
        self.view.endEditing(true)
    }
    
    
}

extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         if let pokeId = Int(pokemonsName[indexPath.row].0){
             self.pokemonView = pokeId
        }
        performSegue(withIdentifier: "PokemonDescription", sender: nil)
    }
}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonsName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = pokemonList.dequeueReusableCell(withIdentifier: "PokemonNameCell", for: indexPath)
        
        (cell as? PokemonNameCell)?.setupCell(pokemonsName[indexPath.row].1, pokemonsName[indexPath.row].0)
        return cell
    }
    
}
