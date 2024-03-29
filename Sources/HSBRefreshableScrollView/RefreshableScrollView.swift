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
    
    fileprivate let refreshHeight: CGFloat
    @State fileprivate var prepareRefresh: Bool = false
	@State fileprivate var refresh: RefreshableScrollView.Refresh = .init()
	@State fileprivate var progressHeight: CGFloat = 0
	@Binding var isRefresh: Bool
	var content: () -> Content
	var progress: (() -> AnyView)?
	
	public init(refreshHeight: CGFloat = 120, isRefresh: Binding<Bool>, content: @escaping () -> Content) {
        self.refreshHeight = refreshHeight
		_isRefresh = isRefresh
		self.content = content
	}
	
	public init<Progress: View>(refreshHeight: CGFloat = 120, isRefresh: Binding<Bool>, progress: @escaping () -> Progress, content: @escaping () -> Content) {
		self.refreshHeight = refreshHeight
		_isRefresh = isRefresh
		self.content = content
		self.progress = { AnyView(progress()) }
	}
	
	public var body: some View {
		ScrollView {
			GeometryReader { geometry -> AnyView in
				DispatchQueue.main.async {
					if refresh.startOffset == 0 {
						refresh.startOffset = geometry.frame(in: .global).minY
					}
					refresh.offset = geometry.frame(in: .global).minY
					if refresh.offset - refresh.startOffset > refreshHeight && !prepareRefresh {
						let generator = UINotificationFeedbackGenerator()
						generator.notificationOccurred(.success)
						withAnimation { prepareRefresh = true }
					}
                    
                    if prepareRefresh && !isRefresh && refresh.offset - refresh.startOffset < refreshHeight {
                        prepareRefresh = false
                        isRefresh = true
                    }
				}
				return AnyView(Color.white.frame(width: 0, height: 0))
			}
			.frame(width: 0, height: 0)
			VStack(spacing: 0) {
				if prepareRefresh || isRefresh {
					if let progress = progress {
						progress()
					} else {
						ProgressView().padding()
					}
				}
				content()
			}
            .onChange(of: isRefresh) { value in
                guard !isRefresh else { return }
                prepareRefresh = false
            }
		}
    }
}
