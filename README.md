## Utilities for prime numbers

With this module you can proof, if an integer is a prime. 
Or you can generate a seq[int] with all primes below an integer.
The proof happens on the fly, or can be precomputed (sieve of Eratosthenes) when many calls are expected.

### Installation


        nimble install primes


### Sample usage


        echo isPrime(97)      # returns: true
        echo below(100).len() # returns: 25

Further examples can be found in the tests directory

### API Documentation
+ compute proof on the fly

        func isPrime*(n: int, primes: BitArray): bool =

+ return a seq[int] with all primes below n

        func below*(n: int): seq[int] =

+ generate a packed seq[bool] for all numbers < n

        func sieve*(n: int): BitArray =

+ use precomputed sieve (if possible)

        func isPrime*(n: int, primes: BitArray): bool =

+ return a seq[int] witth all primes below n with help of sieve   

        proc below*(primes: BitArray, n: int): seq[int] =

+ save the seq[bool] to a file

        proc saveSieve*(primes: BitArray, fileName: string) =

+ load the seq[bool] from a previous created file

          proc loadSieve*(fileName: string): BitArray =

+ load sieve if exits, or precompute sieve and save it
          
          proc sieve*(n: int, fileName: string): BitArray =
