//
//  AccountViewController.swift
//  CustomLoginDemo
//
//  Created by Hoang Nguyen  on 29/10/2022.
//  Copyright © 2022 Christopher Ching. All rights reserved.
//

import UIKit
import FirebaseAuth

class Section {
    var title = NSAttributedString()
    let options: [String]
    var isOpened: Bool = false
    
    init(title: NSAttributedString,
         options: [String],
         isOpened: Bool = false
    ){
        self.title = title
        self.options = options
        self.isOpened = isOpened
    }
}

class AccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var signOutBuuton: UIBarButtonItem!
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // self-sizing table view cells
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 1500
        return tableView
    }()

    private var sections = [Section]()
    
    // Style the section header
    let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up models
        sections = [
            Section(title: NSAttributedString(string: "ABOUT COVID-19", attributes: attributes), options: ["COVID-19 is a disease caused by a virus named SARS-CoV-2 and was discovered in December 2019 in Wuhan, China. It is very contagious and has quickly spread around the world. \nCOVID-19 most often causes respiratory symptoms that can feel much like a cold, a flu, or pneumonia. COVID-19 may attack more than your lungs and respiratory system. Other parts of your body may also be affected by the disease. \n  \u{2022} Most people with COVID-19 have mild symptoms, but some people become severely ill. \n\u{2022} Some people including those with minor or no symptoms may suffer from post-COVID conditions - or “long COVID”. \n  \u{2022} Older adults and people who have certain underlying medical conditions are at increased risk of severe illness from COVID-19. \n  \u{2022} Vaccines against COVID-19 are safe and effective. Vaccines teach our immune system to fight the virus that causes COVID-19."] ),
            Section(title: NSAttributedString(string: "SYMTOMPS", attributes: attributes), options: ["People with COVID-19 have had a wide range of symptoms reported - ranging from mild symptoms to severe illness. Symptoms may appear 2-14 days after exposure to the virus. Anyone can have mild to severe symptoms. \nPossible symptoms include: \n\u{2022} Fever or chills \n\u{2022} Cough Shortness of breath or difficulty breathing \n\u{2022} Fatigue \n\u{2022} Muscle or body aches \n\u{2022} Headache \n\u{2022} New loss of taste or smell \n\u{2022} Sore throat \n\u{2022} Congestion or runny nose \n\u{2022} Nausea or vomiting \n\u{2022} Diarrhea \nThis list does not include all possible symptoms. Symptoms may change with new COVID-19 variants and can vary depending on vaccination status"]),
            Section(title: NSAttributedString(string: "TESTING", attributes: attributes), options: ["Key times to get tested: \n\u{2022} If you have symptoms, test immediately. \n\u{2022} If you were exposed to COVID-19 and do not have symptoms, wait at least 5 full days after your exposure before testing. If you test too early, you may be more likely to get an inaccurate result. \n\u{2022} If you are in certain high-risk settings, you may need to test as part of a screening testing program. \n\u{2022} Consider testing before contact with someone at high risk for severe COVID-19, especially if you are in an area with a medium or high COVID-19 Community Level."]),
            Section(title: NSAttributedString(string: "IF YOU WERE EXPOSED", attributes: attributes), options: [""]),
            Section(title: NSAttributedString(string: "IF YOU ARE SICK", attributes: attributes), options: [""]),
            Section(title: NSAttributedString(string: "LONG COVID", attributes: attributes), options: [""]),
            Section(title: NSAttributedString(string: "LONG COVID SYMTOMPS", attributes: attributes), options: [""]),
            Section(title: NSAttributedString(string: "TRAVEL", attributes: attributes), options: [""]),
        ]
        
        
        view.addSubview(tableView)
        view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.frame = view.bounds
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        
        if section.isOpened {
            return section.options.count + 1
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.attributedText = sections[indexPath.section].title
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = sections[indexPath.section].options[indexPath.row - 1]
            cell.textLabel?.numberOfLines = 50
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        sections[indexPath.section].isOpened = !sections[indexPath.section].isOpened
        tableView.reloadSections([indexPath.section], with: .automatic)
        
    }
    
    @IBAction func signOutTapped(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            
            // Transition to Log In Screen
            transitionToWelcomeScreen()
            
        } catch let err{
            print("Error Signing Out", err)
        }
    }

    func transitionToWelcomeScreen() {
        
        let welcomeViewController = self.storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.welcomeViewController)
        
        if let scenceDelegate = view.window?.windowScene?.delegate as? SceneDelegate,
           let window = scenceDelegate.window{
            window.rootViewController = welcomeViewController
            
            UIView.transition(with: window, duration: 0.25, options: .transitionCrossDissolve, animations: nil, completion: nil)
        }
    }

}

extension String {
func withBoldText(text: String, font: UIFont? = nil) -> NSAttributedString {
  let _font = font ?? UIFont.systemFont(ofSize: 14, weight: .regular)
  let fullString = NSMutableAttributedString(string: self, attributes: [NSAttributedString.Key.font: _font])
  let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: _font.pointSize)]
  let range = (self as NSString).range(of: text)
  fullString.addAttributes(boldFontAttribute, range: range)
  return fullString
}}
