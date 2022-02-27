public struct Bip173 {
    
    public init() {}
    
    public func bip173(hrp: String, _ input: [UInt8]) -> String {
        let table: [Character] = Array("qpzry9x8gf2tvdw0s3jn54khce6mua7l")
        let bits = eightToFiveBits(input)
        let check_sum = checksum(hrp: hrp, data: bits)
        let separator = "1"
        return "\(hrp)" + separator + String((bits + check_sum).map { table[Int($0)] })
    }
    
    func eightToFiveBits(_ input: [UInt8]) -> [UInt8] {
        guard !input.isEmpty else { return [] }
        
        var outputSize = (input.count * 8) / 5
        if ((input.count * 8) % 5) != 0 {
            outputSize += 1
        }
        var outputArray: [UInt8] = []
        for i in (0..<outputSize) {
            let devision = (i * 5) / 8
            let reminder = (i * 5) % 8
            var element = input[devision] << reminder
            element >>= 3
            
            if (reminder > 3) && (i + 1 < outputSize) {
                element = element | (input[devision + 1] >> (8 - reminder + 3))
            }
            
            outputArray.append(element)
        }
        
        return outputArray
    }
    
    func checksum(hrp: String, data: [UInt8]) -> [UInt8] {
        let values = bech32_hrp_expand(hrp) + data
        let polymod = bech32_polymod(values + [0,0,0,0,0,0]) ^ 1
        var result: [UInt] = []
        for i in (0..<6) {
            result.append((polymod >> (5 * (5 - UInt(i)))) & 31)
        }
        return result.map { UInt8($0) }
    }
    
    func bech32_hrp_expand(_ s: String) -> [UInt8] {
        var left: [UInt8] = []
        var right: [UInt8] = []
        for x in Array(s) {
            let scalars = String(x).unicodeScalars
            left.append(UInt8(scalars[scalars.startIndex].value) >> 5)
            right.append(UInt8(scalars[scalars.startIndex].value) & 31)
        }
        return left + [0] + right
    }
    
    func bech32_polymod(_ values: [UInt8]) -> UInt {
        let GEN: [UInt] = [0x3b6a57b2, 0x26508e6d, 0x1ea119fa, 0x3d4233dd, 0x2a1462b3]
        var chk: UInt = 1
        for v in values {
            let b = (chk >> 25)
            chk = (chk & 0x1ffffff) << 5 ^ UInt(v)
            for i in (0..<5) {
                if (((b >> i) & 1) != 0) {
                    chk ^= GEN[i]
                }
            }
        }
        return chk
    }
    
    func bech32_verify_checksum(hrp: String, data: [UInt8]) -> Bool {
        bech32_polymod(bech32_hrp_expand(hrp) + data) == 1
    }
}
