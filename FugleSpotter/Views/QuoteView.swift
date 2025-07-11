//
//  QuoteView.swift
//  FugleSpotter
//
//  Created by Lucas Holm on 10/12/2024.
//
import SwiftUI

struct QuoteView: View {
    @State private var quoteManager = QuoteManager()
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(spacing: 24) {
            if quoteManager.isLoading {
                ProgressView()
                    .scaleEffect(1.5)
            } else if let quote = quoteManager.currentQuote {
                Spacer()
                
                VStack(spacing: 16) {
                    Text(quote.quote)
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Text("- \(quote.author)")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                HStack(spacing: 20) {
                    Button(action: {
                        quoteManager.fetchNewQuote()
                    }) {
                        Text("New Quote")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 150)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        isPresented = false
                    }) {
                        Text("Cool Bro!")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 150)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                }
            }
        }.onAppear {
            quoteManager.fetchNewQuote()
        }
    }
}
