//
//  ContactDetailViewController.swift
//  Contacs
//
//  Created by Baran on 11.01.2026.
//

import UIKit

protocol ContactDetailViewControllerDelegate {
    func markAsFavoriteContact(contact: Contact)
}

class ContactDetailViewController: UITableViewController {
    @IBOutlet weak var btnMarkAsFavorite: UIButton!
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    
    @IBOutlet weak var lblEmail: UILabel!
    
    @IBOutlet weak var lblStreet: UILabel!
    
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblState: UILabel!
    
    @IBOutlet weak var lblZipCode: UILabel!
    
    @IBOutlet weak var lblName: UILabel!
    
    var delegate : ContactDetailViewControllerDelegate?
    
    var contact: Contact?
    override func viewDidLoad() {
        super.viewDidLoad()

        applyView()
    }
    
    func applyView(){
        
        guard let contact = contact else { return }
        
        lblPhoneNumber.text = contact.phone
        lblEmail.text = contact.email
        lblCity.text = contact.city
        lblState.text = contact.state
        lblStreet.text = contact.street
        lblZipCode.text = contact.zip
        
        imgProfile.image = contact.image
        lblName.text = "\(contact.firstName) \(contact.lastName)"
        
        if contact.favorite {
            btnMarkAsFavorite.setTitle("Remove From Favorites", for: UIControl.State.normal)
        } else{
            btnMarkAsFavorite.setTitle("Mark As Favorite", for: UIControl.State.normal)
        }
        
    }

    @IBAction func btnMarkFavoriteClick(_ sender: UIButton) {
        
        guard let contact = contact else { return }
        self.contact?.favorite = true
        if (self.contact?.favorite)!{
            btnMarkAsFavorite.setTitle("Remove From Favorites", for: .normal)
        } else{
            btnMarkAsFavorite.setTitle("Mark As Favorite Contact", for: .normal)
        }
        
        
        
        delegate?.markAsFavoriteContact(contact: self.contact!)
        
    }
    
}
