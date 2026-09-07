import UIKit

var greeting = "Hello, playground"

var isPlaying: Bool = false {
	didSet {
		print("didSet 실행됨: \(oldValue) -> \(isPlaying)")
	}
}

isPlaying = true   // 값이 바뀜
isPlaying = true   // 같은 값을 다시 대입
isPlaying = false  // 값이 바뀜
