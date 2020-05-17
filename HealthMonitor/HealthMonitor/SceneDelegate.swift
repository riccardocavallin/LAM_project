//
//  SceneDelegate.swift
//  HealthMonitor
//
//  Created by Riccardo Cavallin on 03/05/2020.
//  Copyright © 2020 Riccardo Cavallin. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
	private let notificationPublisher = NotificationPublisher()
	private let defaults = UserDefaults.standard

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
		UNUserNotificationCenter.current().delegate = self
        guard let _ = (scene as? UIWindowScene) else { return }
    }
	
	func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
				//print("Sto per mandare la notifica")
				completionHandler([.badge, .sound, .alert])
			}
			
			func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
				
				let storyboard = UIStoryboard(name: "Main", bundle: nil)
		
				// instantiate the view controller we want to show from storyboard
				// root view controller is tab bar controller
				// the selected tab is a navigation controller
				// then we push the new view controller to it
	
				completionHandler()
				let identifier = response.actionIdentifier

				switch identifier {

				case UNNotificationDismissActionIdentifier: // notifica cancellata
					// tolgo 1 al badge di notifica
					UIApplication.shared.applicationIconBadgeNumber -= 1
					//print("The notification was dismissed")
					completionHandler()
				case UNNotificationDefaultActionIdentifier: // notifica viene aperta
					//print("The user opened the app from the notification")
					// tolgo 1 al badge di notifica
					UIApplication.shared.applicationIconBadgeNumber -= 1
					//let formVC = storyboard.instantiateViewController(withIdentifier: "Form") as? FormViewController
					if  let vc = storyboard.instantiateViewController(withIdentifier: "Form") as? FormViewController {
//						let rootViewController = self.window!.rootViewController as! UITabBarController
//						let navController = rootViewController.selectedViewController as? UINavigationController
						
						window?.rootViewController = vc
						window?.makeKeyAndVisible()
					}
					completionHandler()
				case "posticipa": // utente ha cliccato sull'action per posticipare
					// tolgo 1 al badge di notifica
					UIApplication.shared.applicationIconBadgeNumber -= 1
					let date = Date()
					let calendar = Calendar.current
					let dayCurrent = calendar.component(.day, from: date)
					let hour = defaults.integer(forKey: "oraNotificaReport")
					let minute = defaults.integer(forKey: "minutoNotificaReport")
					// imposto una nuova notifica fra 30 minuti
					notificationPublisher.sendReportReminderNotification(title: "Report giornaliero", body: "Inserisci il tuo report odierno", badge: 1, sound: .default, day: dayCurrent , hour: hour, minute: minute + 30, id: "reportReminder", idAction: "posticipa", idTitle: "Posticipa")
					completionHandler()
					
				default:
					print("Default case")
					completionHandler()

				}
				
			}

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()

    }


}



