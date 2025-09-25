//
//  CPSettingsViewModel.swift
//  WStar
//
//  Created by Dias Atudinov on 25.09.2025.
//


import SwiftUI

class CPSettingsViewModel: ObservableObject {
    @AppStorage("musicEnabled") var musicEnabled: Bool = true
    @AppStorage("soundEnabled") var soundEnabled: Bool = true
    @AppStorage("vibroEnabled") var vibroEnabled: Bool = true
}
