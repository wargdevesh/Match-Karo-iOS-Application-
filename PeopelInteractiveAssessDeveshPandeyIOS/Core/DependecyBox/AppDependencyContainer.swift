//
//  AppDependencyContainer.swift
//  PeopelInteractiveAssessDeveshPandeyIOS
//
//  Created by Devesh Pandey on 12/06/26.
//


final class AppDependencyContainer: HomeFlowDependencies {
    
    private let sharedNetworkManager = HomeNetworkManager()
    
    
    func makeHomeNetworkManager() -> any HomeNetworkServicing {
        return sharedNetworkManager
    }
    
    func makeHomeListManager() -> any HomeListManageable {
        HomeListManager()
    }
    
   

    
   
}
