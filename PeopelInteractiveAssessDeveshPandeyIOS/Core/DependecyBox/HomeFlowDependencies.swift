//
//  HomeFlowDependencies.swift
//  PeopelInteractiveAssessDeveshPandeyIOS
//
//  Created by Devesh Pandey on 12/06/26.
//


protocol HomeFlowDependencies {
    func makeHomeNetworkManager() -> HomeNetworkServicing // Assuming you use protocols for your managers
    func makeHomeListManager() -> HomeListManageable
}
