//
//  RefreshableScrollView.swift
//  PullToRefresh
//
//  Created by Sang bo Hong on 2021/05/28.
//

import SwiftUI

public struct RefreshableScrollView<Content : View>: View {
	
	struct Refresh {
		var startOffset: CGFloat = 0
		var offset: CGFloat = 0
	}

	@State private var refresh: RefreshableScrollView.Refresh = .init()
	@Binding var isRefresh: Bool
	var content: () -> Content
	
	public init(isRefresh: Binding<Bool>, content: @escaping () -> Content) {
		_isRefresh = isRefresh
		self.content = content
	}
	
	public var body: some View {
		ScrollView {
			GeometryReader { geometry -> AnyView in
				DispatchQueue.main.async {
					if refresh.startOffset == 0 {
						refresh.startOffset = geometry.frame(in: .global).minY
					}
					refresh.offset = geometry.frame(in: .global).minY
					if refresh.offset - refresh.startOffset > 100 && !isRefresh {
						let generator = UINotificationFeedbackGenerator()
						generator.notificationOccurred(.success)
						withAnimation { isRefresh = true }
					}
				}
				return AnyView(Color.white.frame(width: 0, height: 0))
			}
			.frame(width: 0, height: 0)
			ZStack(alignment: .top) {
				if isRefresh { ProgressView() }
				content()
				.offset(y: isRefresh ? 30 : -8)
			}
		}
    }
}
