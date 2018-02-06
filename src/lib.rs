extern crate rug;
#[macro_use]
extern crate lazy_static;

mod sieve;

use rug::{Integer, Assign};

macro_rules! ivec { ($($elem:expr),* $(,)*) => { vec![$(Integer::from($elem)),*] } }

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn small_prod() {
        let iter = vec![Integer::from(2), Integer::from(5)];
        assert_eq!(prod(&iter), 10);
    }
    #[test]
    fn large_prod() {
        let iter: Vec<Integer> = vec![Integer::from(2); 25];
        assert_eq!(prod(&iter), 33554432);

    }
}

lazy_static! {
    static ref ODD_VALUES: Vec<Integer> = ivec![1,1,1,3,3,15,5,35,35, 315, 63, 693, 231, 3003, 429, 6435, 6435, 109395,12155,230945,46189,969969, 88179,2028117, 676039,16900975,1300075, 35102025,5014575, 145422675,9694845,300540195,300540195];
}

/// Computes the accumulated product of an Integer slice
fn prod(set: &[Integer]) -> Integer{
    if set.len() < 24 {
        return set.iter().product();
    }
    let m = set.len() / 2;
    prod(&set[0..m]) * prod(&set[m..set.len()])
}

fn odd_swing(i: Integer) -> Integer {
    if i < 33 {
        let idx = (i.to_u32_wrapping() + 1) as usize;
        return ODD_VALUES[idx].clone();
    }

    !unimplemented!()
}

