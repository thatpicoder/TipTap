//
//  ContentView.swift
//  TipTap
//
//  Created by dylan on 5/23/26.
//

import SwiftUI
import UIKit

struct ContentView: View {
    @State private var billAmount = ""
    @State private var tipPercentage = 15.0
    @State private var peopleCount = 1
    @State private var selectedState = "Choose State"
    @State private var roundUpEnabled = false

    let haptic = UIImpactFeedbackGenerator(style: .light)

    let stateTaxes: [String: Double] = [
        "Choose State": 0.0,
        "Alabama": 4.0,
        "Alaska": 0.0,
        "Arizona": 5.6,
        "Arkansas": 6.5,
        "California": 7.25,
        "Colorado": 2.9,
        "Connecticut": 6.35,
        "Delaware": 0.0,
        "District of Columbia": 6.0,
        "Florida": 6.0,
        "Georgia": 4.0,
        "Hawaii": 4.0,
        "Idaho": 6.0,
        "Illinois": 6.25,
        "Indiana": 7.0,
        "Iowa": 6.0,
        "Kansas": 6.5,
        "Kentucky": 6.0,
        "Louisiana": 4.45,
        "Maine": 5.5,
        "Maryland": 6.0,
        "Massachusetts": 6.25,
        "Michigan": 6.0,
        "Minnesota": 6.875,
        "Mississippi": 7.0,
        "Missouri": 4.225,
        "Montana": 0.0,
        "Nebraska": 5.5,
        "Nevada": 6.85,
        "New Hampshire": 0.0,
        "New Jersey": 6.625,
        "New Mexico": 5.125,
        "New York": 4.0,
        "North Carolina": 4.75,
        "North Dakota": 5.0,
        "Ohio": 5.75,
        "Oklahoma": 4.5,
        "Oregon": 0.0,
        "Pennsylvania": 6.0,
        "Rhode Island": 7.0,
        "South Carolina": 6.0,
        "South Dakota": 4.2,
        "Tennessee": 7.0,
        "Texas": 6.25,
        "Utah": 6.1,
        "Vermont": 6.0,
        "Virginia": 5.3,
        "Washington": 6.5,
        "West Virginia": 6.0,
        "Wisconsin": 5.0,
        "Wyoming": 4.0
    ]

    var billValue: Double {
        Double(billAmount) ?? 0
    }

    var taxAmount: Double {
        let taxRate = stateTaxes[selectedState] ?? 0
        return billValue * (taxRate / 100)
    }

    var tipAmount: Double {
        billValue * (tipPercentage / 100)
    }

    var rawTotalAmount: Double {
        billValue + taxAmount + tipAmount
    }

    var totalAmount: Double {
        roundUpEnabled ? ceil(rawTotalAmount) : rawTotalAmount
    }

    var amountPerPerson: Double {
        totalAmount / Double(peopleCount)
    }

    func tapHaptic() {
        haptic.impactOccurred()
    }

    var body: some View {
        NavigationView {
            Form {

                Section(header: Text("Bill")) {
                    HStack {
                        Text("$")
                            .font(.headline)

                        TextField("0.00", text: $billAmount)
                            .keyboardType(.decimalPad)
                    }
                }

                Section(header: Text("State Tax")) {
                    Picker("State", selection: $selectedState) {
                        ForEach(stateTaxes.keys.sorted(), id: \.self) { state in
                            Text(state)
                        }
                    }
                    .onChange(of: selectedState) { _ in
                        tapHaptic()
                    }
                }

                Section(header: Text("Tip")) {

                    VStack {
                        Slider(
                            value: $tipPercentage,
                            in: 0...100,
                            step: 1,
                            onEditingChanged: { _ in
                                tapHaptic()
                            }
                        )

                        Text("\(Int(tipPercentage))% Tip")
                            .font(.headline)
                    }
                }
                Section(header: Text("Split")) {
                    Stepper(
                        "People: \(peopleCount)",
                        value: $peopleCount,
                        in: 1...20,
                        onEditingChanged: { _ in
                            tapHaptic()
                        }
                    )
                }

                    Section(header: Text("Results")) {
                        HStack {
                            Text("Tax")
                            Spacer()
                            Text("$\(taxAmount, specifier: "%.2f")")
                                .foregroundColor(.green)
                        }

                        HStack {
                            Text("Tip Amount")
                            Spacer()
                            Text("$\(tipAmount, specifier: "%.2f")")
                                .foregroundColor(.green)
                        }

                        HStack {
                            Text("Total")
                            Spacer()
                            Text("$\(totalAmount, specifier: "%.2f")")
                                .foregroundColor(.green)
                                .fontWeight(.bold)
                        }

                        HStack {
                            Text("Per Person")
                            Spacer()
                            Text("$\(amountPerPerson, specifier: "%.2f")")
                                .foregroundColor(.green)
                        }

                        Toggle("Round Up Total", isOn: $roundUpEnabled)
                            .onChange(of: roundUpEnabled) { _ in
                                tapHaptic()
                            }
                        if tipPercentage == 100 {
                            Text("you'll be loved by the staff")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
            .navigationBarTitle("TipTap")
            .onAppear {
                haptic.prepare()
            }
        }
    }
        
        Section {
            HStack {
                Spacer()
                Text("bitetheapple")
                    .font(.caption2)
                    .foregroundColor(.gray)
                Spacer()
            }
        }
}
    

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
}
