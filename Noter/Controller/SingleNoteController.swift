//
//  SingleNoteController.swift
//  Noter
//
//  Created by Igor-Macbook Pro on 16/11/2018.
//  Copyright © 2018 Igor-Macbook Pro. All rights reserved.
//

import UIKit
import CoreData

class SingleNoteController : UIViewController, SingleNoteProtocol {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet var micButton: UIButton!
    @IBOutlet var noteText: UITextView!
    @IBOutlet var saveButton: UIButton!
    
    var cNote : Note?
    
    var currentNote : Note {
        get { return cNote! }
        set { cNote = newValue }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        retrieveText()
        
        micButton.layer.cornerRadius = micButton.bounds.width / 3
        saveButton.layer.cornerRadius = saveButton.bounds.width / 3
    }
    
    
    @IBAction func micButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        updateNote()
    }
    
    private func retrieveText() {
        let request : NSFetchRequest<Note> = Note.fetchRequest()
        request.predicate = NSPredicate(format: "id = \(currentNote.id)")
        
        do {
            noteText.text = try context.fetch(request)[0].text
            print(try context.fetch(request))
        }
        catch {
            print("Error with getting occured \(error)")
        }
    }
    
    private func updateNote() {
        
        let request : NSFetchRequest<Note> = Note.fetchRequest()
        request.predicate = NSPredicate(format: "id = \(currentNote.id)")
        
        var noteArr : [Note] = [Note]()
        
        do {
            noteArr = try context.fetch(request)
        }
        catch {
            print("Error with retrieving \(error)")
        }
        
        print(noteArr)
        
        noteArr[0].setValue(noteText.text!, forKey: "text")
        noteArr[0].setValue(Date.init(), forKey: "updateTime")
        
        print(noteArr)
        
        saveNote()
    }
    
    private func saveNote() {
        do {
            try context.save()
        }
        catch {
            print("Problem with updating occured \(error)")
        }
    }

}
