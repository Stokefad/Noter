//
//  NoteCollectionController.swift
//  Noter
//
//  Created by Igor-Macbook Pro on 16/11/2018.
//  Copyright © 2018 Igor-Macbook Pro. All rights reserved.
//

import UIKit
import CoreData

class NoteCollectionController : UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var noteArray : [Note] = [Note]()
    
    var counter : Int16 = 0
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noteArray = getNote()
        
        // Initizialize var for ids here
        if noteArray.count > 0 {
            counter = noteArray[noteArray.count - 1].id + 1
        }
        
        saveNote()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UINib.init(nibName: "CollectionCell", bundle: nil), forCellWithReuseIdentifier: "CustomItem")
        
    }
    
    
    
    // MARK: - READ
    
    private func getNote() -> [Note] {
        let request : NSFetchRequest<Note> = Note.fetchRequest()
        
        var noteArr : [Note] = [Note]()
        
        do {
            noteArr = try context.fetch(request)
        }
        catch {
            print("Error with retrieving occured \(error)")
        }
        
        return noteArr
    }
    
    // MARK: - SAVE
    
    private func saveNote() {
        do {
            try context.save()
        }
        catch {
            print("Error with saving occured \(error)")
        }
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "goToNoteFirstTime", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationVC = segue.destination as! SingleNoteProtocol
        
        if segue.identifier == "goToNote" {
            let indexPaths : NSArray = collectionView!.indexPathsForSelectedItems! as NSArray
            let indexPath : NSIndexPath = (indexPaths[0] as! NSIndexPath)
            
            destinationVC.currentNote = noteArray[indexPath.row]
        }
        
        if segue.identifier == "goToNoteFirstTime" {
            let note : Note = Note(context: context)
            note.text = " "
            note.updateTime = Date.init()
            note.id = counter
            noteArray.append(note)
            
            counter += 1
            
            collectionView.reloadData()
            
            saveNote()
            
            destinationVC.currentNote = note
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToNote", sender: self)
    }
    
    let colorArray : [UIColor] = [UIColor](arrayLiteral: UIColor.green, UIColor.red, UIColor.yellow, UIColor.purple)
    
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomItem", for: indexPath) as! CollectionViewCell
        
        item.layer.cornerRadius = 10
        item.backgroundColor = colorArray[indexPath.row % 4]
        
        item.configure(with: noteArray[indexPath.row])
        
        saveNote()
        
        return item
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return noteArray.count
    }
}

extension NoteCollectionController {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenWidth * 0.85, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: screenWidth, height: 25)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 25
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: screenWidth, height: 15)
    }
    
    // MARK - made for reseting
    
 /*  func resetAllRecords(in entity : String) // entity = Your_Entity_Name
    {
        
        let context = ( UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do
        {
            try context.execute(deleteRequest)
            try context.save()
        }
        catch
        {
            print ("There was an error")
        }
    } */
}


extension String {
    
    var length: Int {
        return count
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
}
