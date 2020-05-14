//
//  AppDelegate.swift
//  HealthMonitor
//
//  Created by Riccardo Cavallin on 03/05/2020.
//  Copyright © 2020 Riccardo Cavallin. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
	
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// tastiera che si adatta alla view
		IQKeyboardManager.shared.enable = true
		IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Fine"
		UNUserNotificationCenter.current().delegate = self
		// richiesta permesso di notifica
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in }
        return true
    }
	
	func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            print("Sto per mandare la notifica")
            completionHandler([.badge, .sound, .alert])
        }
        
        func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
            // instantiate the view controller we want to show from storyboard
            // root view controller is tab bar controller
            // the selected tab is a navigation controller
            // then we push the new view controller to it
//			if  let conversationVC = storyboard.instantiateViewController(withIdentifier: "Form") as? FormViewController {
//				print("ciao")
//				let rootViewController = self.window!.rootViewController as! UITabBarController
//				print("ciao0")
//				let navController = rootViewController.selectedViewController as? UINavigationController
//				print("cia1")
//				navController!.pushViewController(conversationVC, animated: true)
//				print("ciao2")
//            }
            completionHandler()
            let identifier = response.actionIdentifier

            switch identifier {

            case UNNotificationDismissActionIdentifier:
                print("The notification was dismissed")
                completionHandler()
            case UNNotificationDefaultActionIdentifier:
                print("The user opened the app from the notification")
                completionHandler()
            default:
                print("Default case")
                completionHandler()

            }
            
        }

	

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "HealthMonitor")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // shotcuts per accedere alle variabili
    
    static var persistentContainer: NSPersistentContainer {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    }
    
    static var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

}


