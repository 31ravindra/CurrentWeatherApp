//
//  CoreDataManager.swift
//  WeatherApp
//
//  Created by Ravindra Patidar on 11/07/21.
//

import Foundation
import CoreData

class CoreDataManager {
    
    let persistentContainer: NSPersistentContainer!
    // Creating a background context in case of slow work to free up and untie the main queue
    // Both main queue and private queue contexts with their merge policy are created, so any further development could be built upon this Core Data Stack
    var backgroundContext: NSManagedObjectContext!
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init (modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            completion?()
        }
    }
    
    func getLastUpdatedData() -> Weather? {
        
        let fetchRequest:NSFetchRequest<Weather> = Weather.fetchRequest()
        
        var wea:[Weather]? = nil
        let wData = Weather(context: viewContext)
        let timeSort = NSSortDescriptor(key:"lastUpdated", ascending:false)
        
        fetchRequest.sortDescriptors = [timeSort]
        do {
            wea = try viewContext.fetch(fetchRequest)
            
            if wea?.count ?? 0 > 0 {
                return wea?[0]
            } else {
                return wData
            }
            
        } catch {
            if wea?.count ?? 0 > 0 {
                return wea?[0]
            } else {
                return wData
            }
            
        }
    }
    
    func save(weaData: CoreDataModel, useEntity nameOfEntity: String, completion: @escaping (_ success:Bool) -> Void) {
        
        let wData = Weather(context: viewContext)
        wData.city = weaData.city
        wData.desc = weaData.desc
        wData.icon = weaData.icon
        wData.maxtemp = weaData.maxtemp ?? 0.0
        wData.mintemp = weaData.mintemp ?? 0.0
        wData.temp = weaData.temp ?? 0.0
        wData.lastUpdated = weaData.lastUpdated
        wData.isFav = weaData.isFav
        do { //Save context and add to array
            try viewContext.save()
            //entityArray.append(wData)
            completion(true)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            completion(false)
        }
    }
    
    func updateData(cityName: String, updateValueTo updatedValue: CoreDataModel, completion: @escaping (_ success:Bool) -> Void) {
        
        var wea: Weather!
        
        do {
            //Update value
            let fetchUser: NSFetchRequest<Weather> = Weather.fetchRequest()
            fetchUser.predicate = NSPredicate(format: "city == %@", cityName )
            
            let results = try? viewContext.fetch(fetchUser)
            
            if results?.count == 0 {
                // here you are inserting
                wea = Weather(context: viewContext)
            } else {
                // here you are updating
                wea = results?.first
            }
            
            wea.city = updatedValue.city
            wea.desc = updatedValue.desc
            wea.mintemp = updatedValue.mintemp ?? 0.0
            wea.maxtemp = updatedValue.maxtemp ?? 0.0
            wea.temp = updatedValue.temp ?? 0.0
            wea.humidity = updatedValue.humidity ?? 0.0
            wea.lastUpdated = updatedValue.lastUpdated
            
            do { //Save context
                try viewContext.save()
                completion(true)
            }
            catch {
                print(error)
                completion(false)
            }
        }
    }
    
    
    func checkCityAlreadyInDataBase(cityName: String) -> Bool {
        
        do {
            //Update value
            let fetchUser: NSFetchRequest<Weather> = Weather.fetchRequest()
            fetchUser.predicate = NSPredicate(format: "city == %@", cityName )
            
            let results = try? viewContext.fetch(fetchUser)
            
            if results?.count == 0 {
                return false
                
            } else {
                return true
            }
        }
    }
    
}

