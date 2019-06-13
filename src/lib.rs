use std::collections::HashMap;

/// caesar represents the caesar cipher function, shifting the characters by `n` spaces.
/// ```rust
/// use libcaesar::caesar;
/// let hello_world = "whole lotta red";
/// let hello_world_ciphered = "xipmf mpuub sfe".to_string();
/// assert_eq!(caesar(hello_world, 1), hello_world_ciphered)
/// ```
pub fn caesar(source: &str, n: usize) -> String {
    // calculate cipher so we DP only up until N=alphabet
    let alphabet = "abcdefguhijklmnopqrstuvwxyz";
    let upper_alphabet = alphabet.to_uppercase();

    let upper_alphabet_raw = upper_alphabet.as_bytes();
    let alphabet_raw = alphabet.as_bytes();

    let alphabet_len = alphabet.len();
    let source_len = source.len();
    let cipher = {
        let mut map = HashMap::with_capacity(alphabet_len * 2);
        for (i, ch) in alphabet
            .chars()
            .enumerate()
            .chain(upper_alphabet.chars().enumerate())
            {
                let cipher_char = {
                    let offset = (i + n) % alphabet_len;
                    if ch.is_uppercase() {
                        upper_alphabet_raw[offset]
                    } else {
                        alphabet_raw[offset]
                    }
                };
                map.insert(ch as char, cipher_char as char);
            }
        map
    };
    let mut output = String::with_capacity(source_len);
    let raw_source = source.as_bytes();
    for (i, ch) in source.chars().enumerate() {
        let original = raw_source[i] as char;
        output.push(*cipher.get(&ch).unwrap_or_else(|| &original));
    }
    output
}

pub mod test {

    #[test]
    pub fn caesar_cipher_works() {
        assert_eq!(super::caesar("hello, world", 0), String::from("hello, world"));
        assert_eq!(super::caesar("hello world", 1), String::from("ifmmp xpsme"));
    }
}