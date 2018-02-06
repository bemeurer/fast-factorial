# This file is part of OLMS (Open Library of Mathematical Sequences).
# Copyright (c) 2017: Peter Luschny. License is MIT.

using Primes   # The module Primes provides
# a function primes(a, b) which returns
# the primes p with a <= p <= b as an array of integers.

doc"""
Returns the accumulated product of an array.
"""
function ∏(A)  # Call this function Product, it takes an array of integers
    # and returns the product of the members of A.
    # For the efficiency of the algorithm it is essential
    # to implement it as a shown, using binary subdivisions!
    function prod(a::Int, b::Int)
        n = b - a
        if n < 24
            p = BigInt(1)  # BigInt(1) means 1 but of the type Big Integer
            for k in a:b   # a:b from a to b
                p *= A[k]
            end
            return p
        end
        m = div(a + b, 2)  # div(a,b) = a/b as an integer division, returns integer
        prod(a, m) * prod(m + 1, b)
    end
    prod(1, length(A))  # length(A) the length of the array A
end

const SwingOddpart = [1,1,1,3,3,15,5,35,35, 315, 63, 693, 231, # Array of 'normal' integers
3003, 429, 6435, 6435, 109395,12155,230945,46189,969969,
88179,2028117, 676039,16900975,1300075,35102025,5014575,
145422675,9694845,300540195,300540195]

doc"""
Computes the odd part of the swinging factorial ``n≀``. Cf. A163590.
"""
function swing_oddpart(n::Int)
    n < 33 && return BigInt(SwingOddpart[n + 1])
# If n < 33 then return SwingOddpart[n+1] converted to the type BigInteger

    sqrtn = isqrt(n)                     # integer sqrt = floor(sqrt(n))
    factors = primes(div(n, 2) + 1, n)    # div(n,2) = n/2 by integer division
    r = primes(sqrtn + 1, div(n, 3))     # from Module Primes, see above
    s = filter(x -> isodd(div(n, x)), r)  # 'filter', I am sure Rust has a similar function.
                          # Means select those primes p in the array r
                          # such that div(n,p) is odd.
    append!(factors, s)                  # append the array s to the array factors

# The C# implementation of the above filter/append looks like this
#    foreach (int prime in bPrimes)
#    {
#        if (((n / prime) & 1) == 1)
#        {
#            primeList[count++] = prime;
#        }
#    }
# Similar also the next loop:

    for prime in primes(3, sqrtn)
        p, q = 1, n
        while true
            q = div(q, prime)
            q == 0 && break            # if q = 0 then break
            isodd(q) && (p *= prime)   # if q is odd then p = p * prime
        end
        p > 1 && push!(factors, p)     # if p > 1 then append p to the array factors
    end
    return ∏(factors)                  # The function Product from above
end

doc"""
Computes the swinging factorial (a.k.a. swing numbers n≀). Cf. A056040.
"""
function swing(n::Int)
    sh = count_ones(div(n, 2))  # the function count_ones gives the number of 1's
                # in the binary representation of its argument.
    swing_oddpart(n) << sh     # The C# version looks like this:
                # int exp2 = XMath.BitCount(n);
                # return OddSwing(n) << exp2;
                # In Julia the last expression is returned,
                # no need to write return
end

const FactorialOddPart = [1, 1, 1, 3, 3, 15, 45, 315, 315, 2835, 14175, 155925,
467775, 6081075, 42567525, 638512875, 638512875, 10854718875, 97692469875,
1856156927625, 9280784638125, 194896477400625, 2143861251406875,
49308808782358125, 147926426347074375, 3698160658676859375]

doc"""
Return the largest odd divisor of ``n!``. Cf. A049606.
"""
function factorial_oddpart(n::Int)
    n < length(FactorialOddPart) && return BigInt(FactorialOddPart[n + 1])
# Should be clear by now: a && b means if a then b
    swing_oddpart(n) * (factorial_oddpart(div(n, 2))^2) # recurse on factorial_oddpart
end

doc"""
Return the factorial ``n! = 1*2*...*n``, which is the order of the
symmetric group S_n or the number of permutations of n letters. Cf. A000142.
"""
function factorial(n::Int)
    n < 0 && ArgumentError("Argument must be ≥ 0")
    sh = n - count_ones(n)        # see the comment above in 'swing'
    factorial_oddpart(n) << sh
end

for n in 0:90
    println(factorial(n)) # Voila!
end