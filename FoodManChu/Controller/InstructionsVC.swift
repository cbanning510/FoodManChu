//
//  InstructionsVC.swift
//  FoodManChu
//
//  Created by chris on 12/8/20.
//

import UIKit
import CoreData

class InstructionsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var instructions: [Instruction]?
    var selectedInstructions = [Instruction]()
    var tempInstructions = [Instruction]()
    var recipeToEdit: Recipe?
    var AddEditVC: AddEditTableVC?
    weak var recipeDetailsVC: RecipeDetailsVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        navigationController?.delegate = self
        attemptInstructionFetch()
        createTempInstructions()       
    }
    
    func createTempInstructions() {
        for i in selectedInstructions {
            let instructionCopy = Instruction(context: Constants.context)
            instructionCopy.summary = i.summary
            tempInstructions.append(instructionCopy)
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Instruction", message: "Add Instruction", preferredStyle: .alert)
        alert.addTextField()
        
        let submitButton = UIAlertAction(title: "Add", style: .default) { (action) in
            let textField = alert.textFields![0]
            let newInstruction = Instruction(context: Constants.context)
            newInstruction.summary = textField.text
            self.tempInstructions.append(newInstruction)
            self.tableView.reloadData()
        }
        alert.addAction(submitButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    func attemptInstructionFetch() {
        let fetchRequest: NSFetchRequest<Instruction> = Instruction.fetchRequest()
        let summarySort = NSSortDescriptor(key: "summary", ascending: true)
        fetchRequest.sortDescriptors = [summarySort]

        do {
            self.instructions = try Constants.context.fetch(fetchRequest)
            tableView.reloadData()
            print("instructions are: \n\(instructions!)")
        } catch let err {
            print(err)
        }
    }
}

extension InstructionsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempInstructions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "InstructionCell", for: indexPath) as? InstructionCell else {
            return UITableViewCell()
        }
        let instruction = tempInstructions[indexPath.row]
        cell.configCell(instruction)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            let instructionToRemove = self.tempInstructions[indexPath.row]
                for (index, element) in self.tempInstructions.enumerated() {
                    if element.summary == instructionToRemove.summary {
                        self.tempInstructions.remove(at: index)
                    }
                }
            tableView.reloadData()
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, completionHandler) in
            let instructionToEdit = self.tempInstructions[indexPath.row]
            
            let alert = UIAlertController(title: "Edit Instruction", message: "Edit Instruction:", preferredStyle: .alert)
            alert.addTextField()
            let textField = alert.textFields![0]
            textField.text = instructionToEdit.summary
            
            let saveButton = UIAlertAction(title: "Save", style: .default) { (action) in
                let textfield = alert.textFields![0]
                instructionToEdit.summary = textfield.text
                tableView.reloadData()
            }
            alert.addAction(saveButton)
            self.present(alert, animated: true, completion: nil)
        }
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}

extension InstructionsVC: UINavigationControllerDelegate {   
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {        
        if viewController.isKind(of: AddEditTableVC.self) {
            print("back!!! \(tempInstructions)")
            (viewController as? AddEditTableVC)?.tempInstructions = tempInstructions
        }
    }
}
