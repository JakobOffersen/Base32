//
//  Base32Tests.swift
//  Base32
//

import XCTest
import Base32

final class Base32Tests: XCTestCase {

    func testLoremAgainstNodeImplementation() {
        let input = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.".utf8
        let expected = "bjrr6tdf636r2wvpfni8kwt2gfnquw5eh6i8axdffpwk2x57h3u42vv863u8itb2g3t8kvmnf7r8ga53ftk42x5tg3kr8tdngjnqwtt2f7r8axdmgjt9kdj2bjrr6tdf636r2wvpfni8isdm63j8ctdg63u8itb2f7r8axdmgjt9kbvm63trasdgejir6t32ejuquvdt63u8cy5n63kretdk63tqkvm5eni9au5762smce3igeq42xvaepr42sdg63uqwuvgfxvqwa5igbnqwx57gai9avvhfei84a59e7q8stdt63rqea5nh7s8ca53ftk42wv5gbiqusmeepk42udn63u8ya5fe7pqca5363u9kw5763tr2td5f7qqcvj2ebrqyutg636raa5ae7tk2wvpgbv8kxm7eii8wvvn63rqwv5t63m8kxm763jqcvmngpt8ktdm7ii86xdn63iqswvh63u8itb2fjkq4w32f7r9avt2epq8csvngbrqwud563u9kw57gfkrax5bftmksa5kepqq4udgf7r8ga57gftqcvmnf7iqsv5t63uqwsvae7r8gtd67si6kx32gxir8a5ifxs9cv53gbnr8td663nqwa5nf3kk2ebt8ss98a5rf7u8ia5nf3kk2wm7fjkq4wv763rqea4eepu96sdmepu42wvaepkrawt2efrqwx53f7r8kvm96388ywm7fni6kw5mgpqk2w53gftq4tv7geq42sdgeii8uvvkeni96td5epr9av5t63vqkx5a63k8cwvdgjrr2a5igpj8sudmf3nqwtt2gfrqex5re7t8ca5ef7pqca43fjk9cwt2c3iqgtcfe7pqcwj2f7r88v5pejnqwtt2gtkr6wvbfxr98a5hesi6svvkepqk2kdigfuqudi"
        var encoder = Base32Encoder()
        encoder.encode(input)
        let output = encoder.finalize()

        XCTAssert(expected == output.lowercased())
    }
	
	func testEncodingPerformance_Single() {
		let string = [String](repeating: "lowercase UPPERCASE 1234567 !@#$%^&*", count: 10_000)
			.flatMap { $0 }
		let input = String(string).utf8
		
		var encoder = Base32Encoder()
		measure {
			encoder.encode(input)
		}
	}
	
	func testEncodingPerformance_Multiple() {
		let strings = [String](repeating: "lowercase UPPERCASE 1234567 !@#$%^&*", count: 10_000)
		let inputs = strings.map { $0.utf8 }
		
		var encoder = Base32Encoder()
		measure {
			for input in inputs {
				encoder.encode(input)
			}
		}
	}
	
	func testDecodingPerformance_Single() {
		let string = [String](repeating: "lowercase UPPERCASE 1234567 !@#$%^&*", count: 10_000)
			.flatMap { $0 }
		let input = Base32.encode(String(string).utf8)
		
		var decoder = Base32Decoder()
		measure {
			decoder.decode(input)
		}
	}
	
	func testDecodingPerformance_Multiple() {
		let strings = [String](repeating: "lowercase UPPERCASE 1234567 !@#$%^&*", count: 10_000)
		let inputs = strings.map { Base32.encode($0.utf8) }
		
		var decoder = Base32Decoder()
		measure {
			for input in inputs {
				decoder.decode(input)
			}
		}
	}
}
