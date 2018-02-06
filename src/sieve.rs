extern crate rug;

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn small_primes(){
        let primes = vec![2,3,5,7,11];
        let found = erasthotenes(1, 12);
        assert!(primes == found);
    }
}

fn erasthotenes<'a, T: From<i32>>(lower: T, upper: T) -> &'a [T] {
    // This is an implementation of the Sieve of Erasthotenes
    let hits: Vec<T> = [1, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 49, 53, 59].iter().map(|&x| T::from(x)).collect();
    
    unimplemented!()
}
