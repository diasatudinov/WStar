//
//  CPSettingsViewModel.swift
//  WStar
//
//


import SwiftUI

class CPSettingsViewModel: ObservableObject {
    @AppStorage("musicEnabled") var musicEnabled: Bool = true
    @AppStorage("soundEnabled") var soundEnabled: Bool = true
    @AppStorage("vibroEnabled") var vibroEnabled: Bool = true
}
