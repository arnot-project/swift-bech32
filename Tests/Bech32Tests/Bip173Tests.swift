import XCTest
@testable import Bech32

final class Bip173Tests: XCTestCase {
    
    func testEmptyArray() {
        // given
        let sut = makeSUT()
        let expectedArray: [UInt8] = []

        // when
        let groups = sut.eightToFiveBits([])

        // then
        XCTAssertEqual(groups, expectedArray)
    }
    
    func testSingleElementArraySplittedIntoTwoElements() {
        // given
        let sut = makeSUT()
        let expectedArray: [UInt8] = [
            0b0000_0000, 0b0000_0000
        ]

        // when
        let groups = sut.eightToFiveBits([0b0000_0000])

        // then
        XCTAssertEqual(groups, expectedArray)
    }
    
    func testOneEightBitElementArraySplitsIntoFiveBits() {
        // given
        let sut = makeSUT()
        let expectedArray: [UInt8] = [
            0b0000_0000, 0b0000_0100
        ]

        // when
        let groups = sut.eightToFiveBits([0b0000_0001])

        // then
        XCTAssertEqual(groups, expectedArray)
    }
    
    func testOneEightBitElementArrayAboveThirtyTwo() {
        // given
        let sut = makeSUT()
        let expectedArray: [UInt8] = [
            0b0000_0010, 0b0000_0100
        ]

        // when
        let groups = sut.eightToFiveBits([0b0001_0001])

        // then
        XCTAssertEqual(groups, expectedArray)
    }
    
    func testTwoEightBitElementArray() {
        // given
        let sut = makeSUT()
        let expectedArray: [UInt8] = [
            0b0000_0000, 0b0000_0110, 0b0000_0000, 0b0000_0000
        ]

        // when
        let groups = sut.eightToFiveBits([0b0000_0001, 0b1000_0000])

        // then
        XCTAssertEqual(groups, expectedArray)
    }
    
    func testFourEightBitElementArray() {
        // given
        let sut = makeSUT()
        let expectedArray: [UInt8] = [
            0b0001_0000, 0b0000_0110, 0b0000_0000, 0b0001_1000, 0b0000_0011, 0b0000_0000, 0b0000_1000
        ]

        // when
        let groups = sut.eightToFiveBits([0b1000_0001, 0b1000_0001, 0b1000_0001, 0b1000_0001])

        // then
        XCTAssertEqual(groups, expectedArray)
    }
    
    func testNoDataChecksum() {
        // given
        let sut = makeSUT()
        let expectedString = "A12UEL5L".lowercased()

        // when
        let groups = sut.bip173(hrp: "a", [])

        // then
        XCTAssertEqual(groups, expectedString)
    }
    
    func test0CorrectChecksum() {
        // given
        let input: [UInt8] = [
            0x00
        ]
        let sut = Bip173()
        let expectedString = "1qq3vk6tv"

        // when
        let result = sut.bip173(hrp: "", input)

        // then
        XCTAssertEqual(result, expectedString)
    }
    
    func testAddrAddress() {
        // given
        let sut = makeSUT()
        let expectedString = "addr1vpu5vlrf4xkxv2qpwngf6cjhtw542ayty80v8dyr49rf5eg0yu80w"

        // when
        let groups = sut.bip173(hrp: "addr",
            [
                0x60,
                0x79, 0x46, 0x7c, 0x69,
                0xa9, 0xac, 0x66, 0x28,
                0x01, 0x74, 0xd0, 0x9d,
                0x62, 0x57, 0x5b, 0xa9,
                0x55, 0x74, 0x8b, 0x21,
                0xde, 0xc3, 0xb4, 0x83,
                0xa9, 0x46, 0x9a, 0x65
            ]
        )

        // then
        XCTAssertEqual(groups, expectedString)
    }
    
    func testStakeAddress() {
        // given
        let sut = makeSUT()
        let expectedString = "stake1vpu5vlrf4xkxv2qpwngf6cjhtw542ayty80v8dyr49rf5egfu2p0u"

        // when
        let groups = sut.bip173(hrp: "stake",
            [
                0x60,
                0x79, 0x46, 0x7c, 0x69,
                0xa9, 0xac, 0x66, 0x28,
                0x01, 0x74, 0xd0, 0x9d,
                0x62, 0x57, 0x5b, 0xa9,
                0x55, 0x74, 0x8b, 0x21,
                0xde, 0xc3, 0xb4, 0x83,
                0xa9, 0x46, 0x9a, 0x65
            ]
        )

        // then
        XCTAssertEqual(groups, expectedString)
    }
    
    func testVerifyChecksum() {
        // given
        let sut = makeSUT()

        // when
        let result = sut.bech32_verify_checksum(hrp: "a", data: [
            10, 28, 25, 31, 20, 31
        ])

        // then
        XCTAssertTrue(result)
    }

    private func makeSUT(
    ) -> Bip173 {
        Bip173()
    }
}

