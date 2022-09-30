//
//  OpeningView.swift
//  Gratitude
//
//  Created by sukidhar on 30/09/22.
//

import SwiftUI

struct OnboardingOpeningView: View {
    var body: some View {
        VStack{
            Spacer()
            VStack(alignment: .center){
                Image("Logo")
                    .padding(14)
                Text("Gratitude")
                    .font(Font.custom("Inter-Bold", size: 24))
                    .padding(3)
                Text("Manifest your dream life")
                    .font(Font.custom("Inter-Medium", size: 14))
                    .foregroundColor(.secondary)
            }
            Spacer()
            Button {
                
            } label: {
                HStack{
                    Text("BUILD A VISION BOARD ") + Text(Image(systemName: "arrow.right"))
                }
                .font(Font.custom("Inter-Bold", size: 14))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background {
                    Color("PrimaryColor")
                }
                .cornerRadius(8)
            }
        }.frame(maxWidth: .infinity)
        .padding(.horizontal, 24)
    }
}

struct OpeningView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingOpeningView()
    }
}

