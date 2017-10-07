//
//  EventDetailViewController.swift
//  Tchelinux
//
//  Created by Rafael Jeffman on 21/09/17.
//  Copyright © 2017 Rafael Jeffman. All rights reserved.
//

import UIKit

class EventDetailViewController: UITableViewController {

    var event: Event? {
        didSet { updateUI() }
    }

    private func updateUI() {
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    // MARK: - Table view data source

    private let sections = [nil,"@enrollment","Localização"]
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title = sections[section]
        if title == "@enrollment" {
            title = "Chamada de Trabalhos"
            if let callForPapers = event?.callForPapers,
                let date = callForPapers.deadline, date < (Date() as NSDate)
            {
                title = "Inscrições"
            }
            if let date = event?.date, date < (Date() as NSDate)
            {
                title = "Certificados"
            }
        }
        return title
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // go away! change the sections title list!
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // go away! 
        return 1
    }

    private func renderInstitution(cell: EventInstitutionCell) {
        if let evt = event {
            cell.addressLabel?.text = (evt.institution?.address ?? " ").replacingOccurrences(of: "<br/>", with: "\n")
            
            if let lat = evt.institution?.latitude,
                let long = evt.institution?.longitude
            {
                cell.setMapLocation(latitude: lat, longitude: long)
            }
            /*
             if let site = evt.institution?.url {
             cell.url = URL(string: site)
             }
             */
        }
    }

    private func renderEnrollment(cell: EventEnrollmentCell) {
        if let evt = event {
            let today = Date()
            let text: NSMutableAttributedString = NSMutableAttributedString()
            var url = "http://\(evt.codename ?? "www").tchelinux.org"
            
            if let cfp = evt.callForPapers?.deadline,
                today <= (cfp as Date)
            {
                text.normal("A ").bold("Chamada de Trabalhos")
                    .normal(" está aberta, e disponível até o dia ")
                    .bold("\((cfp as Date).inPortuguese)")
                url = evt.callForPapers?.url ?? url
                cell.webButton?.setTitle("Envie sua Proposta" , for: .normal)
            }
            else if let enroll = evt.enrollment?.deadline,
                today <= (enroll as Date)
            {
                text.normal("As inscrições para o evento estão abertas, e disponíveis até o dia ")
                    .bold("\((enroll as Date).inPortuguese)")
                url = evt.enrollment?.url ?? url
                cell.webButton?.setTitle("Faça sua Inscrição" , for: .normal)
            }
            else if let saturday = evt.date {
                if (saturday as Date) == today {
                    text.normal("O evento está ocorrendo hoje! Inscreva-se no local!")
                } else if (saturday as Date) < today {
                    text.normal("Os certificados são normalmente disponilizados ")
                        .bold("15 dias")
                        .normal(" após o evento.")
                    url = "http://certificados.tchelinux.org"
                    cell.webButton?.setTitle("Acesse seu Certificado" , for: .normal)
                }
            }
            
            cell.enrollmentLabel?.attributedText = text
            cell.url = URL(string: url)
        }
    }
    
    private func renderHeading(cell: EventHeadingCell) {
        if let evt = event {
            cell.institutionLabel?.text = evt.institution?.name
            cell.cityLabel?.text = evt.city
            cell.dateLabel?.text = (evt.date! as Date).inPortuguese
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "heading", for: indexPath) as! EventHeadingCell
            renderHeading(cell: cell)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "enrollment", for: indexPath) as! EventEnrollmentCell
            renderEnrollment(cell: cell)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "institution", for: indexPath) as! EventInstitutionCell
            renderInstitution(cell: cell)
            return cell
        default:
            // we should never get here...
            let cell = tableView.dequeueReusableCell(withIdentifier: "heading", for: indexPath) as! EventHeadingCell
            cell.institutionLabel?.text = ""
            cell.cityLabel?.text = ""
            cell.dateLabel?.text = ""
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

}
