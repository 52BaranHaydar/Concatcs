//
//  ContactListViewController.swift
//  Contacs
//
//  Created by Baran on 11.01.2026.
//

import UIKit



class ContactListViewController: UITableViewController {

    // var contacts : [Contact] = ContactSource.contacs
    
    var sectionContext : [[Contact]] = ContactSource.sectionContacs
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionContext.count
    }
    
    
    //  Hangi sectiopn kaç tane section olucak
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionContext[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "contentCell", for: indexPath)
        
        // let contact = contacts[indexPath.row]
        let contact = sectionContext[indexPath.section][indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "contentCell", for: indexPath) as? contactCell else{fatalError("contact error")}
        
        cell.lblName.text = "\(contact.firstName) \(contact.lastName)"
        cell.lblCity.text = contact.city
        cell.imgProfile.image = contact.image
        cell.imgFavorite.isHidden = !contact.favorite
        
        
        
        
        //cell.textLabel?.text = "\(contact.firstName) \(contact.lastName)"
        //cell.imageView?.image = contact.image
        //cell.detailTextLabel?.text = contact.email
        return cell
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // 1. Storyboard'daki ok isminin "showContact" olup olmadığını kontrol ediyoruz.
        if segue.identifier == "showDetail" {
            
            // 2. Hangi satıra tıklandığını buluyoruz.
            if let indexPath = tableView.indexPathForSelectedRow {
                let selectedContact = sectionContext[indexPath.section][indexPath.row]
                
                // 3. Veriyi karşıya (Detay sayfasına) gönderiyoruz.
                // Split View kullandığın için detay sayfası bir NavigationController içinde olabilir:
                if let nav = segue.destination as? UINavigationController,
                   let detailVC = nav.topViewController as? ContactDetailViewController {
                    
                    detailVC.contact = selectedContact
                    
                } else if let detailVC = segue.destination as? ContactDetailViewController {
                    // Eğer direkt bağlıysa burası çalışır
                    detailVC.contact = selectedContact
                    detailVC.delegate = self
                    
                }
            }
           
            
        }
        
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ContactSource.uniqueFirstLetters[section]
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return ContactSource.uniqueFirstLetters
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    

}
extension Contact: Equatable{
    static func == (lContact : Contact, rContact: Contact) -> Bool{
        return lContact.firstName == rContact.firstName && lContact.lastName == rContact.lastName && lContact.street == rContact.street && lContact.city == rContact.city && lContact.state == rContact.state && lContact.zip == rContact.zip && lContact.phone == rContact.phone && lContact.email == rContact.email
    }
}



extension ContactListViewController : ContactDetailViewControllerDelegate{
    func markAsFavoriteContact(contact: Contact) {
        var sectionIndex : Int? = nil
        var contactIndex : Int? = nil
        
        
        for (index, context) in sectionContext.enumerated(){
            if let indexOfContacts = context.index(of: contact){
                sectionIndex = index
                contactIndex = indexOfContacts
                break
            }
        }
        
        if let sectionIndex = sectionIndex, let contactIndex = contactIndex{
            sectionContext[sectionIndex][contactIndex].favorite = contact.favorite
            tableView.reloadData()
        }
        
    }
}


extension Contact{
    
    var firstLetter : String {
        return String(firstName.prefix(1))
    }
}

extension ContactSource{
    static var uniqueFirstLetters : [String] {
        
        let firstLetters = contacs.map { $0.firstLetter}
        let uniqueLetters = Set(firstLetters)
        return Array(uniqueLetters).sorted()
        
    }
    
    static var sectionContacs : [[Contact]]{
        
        return uniqueFirstLetters.map{ firstLetter in
            let filteredContacs = contacs.filter{
                $0.firstLetter  == firstLetter
            }
            return filteredContacs.sorted(
                by:{ $0.firstName < $1.firstName }
            )
            
        }
        
    }
}
