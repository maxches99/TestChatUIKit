//
//  DetailViewController.swift
//  TestChatUIKit
//
//  Created by Максим Чесников on 01.07.2022.
//

import UIKit

protocol DetailViewInput: AnyObject {}

protocol DetailViewOutput: AnyObject {
    
    func viewAppeared()
    
    func getTextOfModel() -> String
    
    func getDateOfModel() -> String
    
    func getAvatarURLOfModel() -> Data?
    
    func deleteMessage()
    
    func freeingUpMemory()
}

class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    var output: DetailViewOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    func configure() {
        navigationController?.isNavigationBarHidden = false
        
        textLabel.text = ""
        dateLabel.text = ""
        
        output?.viewAppeared()
        
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 60
        
        textLabel.layer.opacity = 0
        dateLabel.layer.opacity = 0
        imageView.layer.opacity = 0
        deleteButton.layer.opacity = 0
        
        UIView.animate(withDuration: 1) { [weak self] in
            self?.textLabel.layer.opacity = 1
            self?.dateLabel.layer.opacity = 1
            self?.imageView.layer.opacity = 1
            self?.deleteButton.layer.opacity = 1
        }
    }

    @IBAction func deleteButtonAction(_ sender: Any) {
        output?.deleteMessage()
    }
    
    deinit {
        output?.freeingUpMemory()
    }
}

extension DetailViewController: DetailViewInput {}

extension DetailViewController: DetailPresenterOutput {
    func dataLoaded() {
        textLabel.text = output?.getTextOfModel() ?? ""
        dateLabel.text = output?.getDateOfModel() ?? ""
        guard let data = output?.getAvatarURLOfModel() else { return }
        imageView.image = UIImage(data: data)
    }
    
    func loadedImage(data: Data) {
        imageView.image = UIImage(data: data)
    }
}
