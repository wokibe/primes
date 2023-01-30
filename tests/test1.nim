# This is just an example to get you started. You may wish to put all of your
# tests into a single file, or separate them into multiple `test1`, `test2`
# etc. files (better names are recommended, just make sure the name starts with
# the letter 't').
#
# To run these tests, simply execute `nimble test`.

import unittest
import primes
import bitty
import system/io, os

test "isPrime":
  check isPrime(2) == true
  check isPrime(3) == true
  check isPrime(4) == false
  check isPrime(5) == true
  check isPrime(6) == false
  check isPrime(7) == true
  check isPrime(8) == false
  check isPrime(97) == true
  expect (ValueError):
    discard isPrime(-1)

test "below":
  var firstPrimes = below(100)
  check firstPrimes.len() == 25
  check firstPrimes == @[2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53,
  59, 61, 67, 71, 73, 79, 83, 89, 97]

test "sieve":
  var primes = sieve(10)  
  check primes[2] == false 
  check primes[3] == false
  check primes[4] == true
  check primes[5] == false
  check primes[6] == true
  check primes[7] == false
  check primes[8] == true
  check primes[9] == true

test "isPrime with sieve":
  var primes = sieve(10)
  check isPrime(2, primes) == true
  check isPrime(3, primes) == true
  check isPrime(4, primes) == false
  check isPrime(5, primes) == true
  check isPrime(6, primes) == false
  check isPrime(7, primes) == true
  check isPrime(8, primes) == false
  check isPrime(9, primes) == false

test "isPrime with too small sieve":
  var primes = sieve(10)
  check isPrime(97, primes) == true
  check isPrime(98, primes) == false

test "belowPrimes":
  var primes = sieve(100)
  var firstPrimes = below(primes, 100)
  check firstPrimes.len() == 25
  check firstPrimes == @[2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53,
  59, 61, 67, 71, 73, 79, 83, 89, 97]

test "sieve with implicite save":
  var fileName = "prim1000.bits"
  if fileExists(fileName):
    removeFile(fileName)
  var primes = sieve(1000, fileName)
  check open("prim1000.bits").getFileSize() == 370
  check isPrime(97, primes) == true

test "sieve with implicit load":
  var fileName = "prim1000.bits"
  discard sieve(1000, fileName)    # now the file will exist
  var primes = sieve(1000, fileName)
  check open("prim1000.bits").getFileSize() == 370
  check isPrime(97, primes) == true

test "savePrimes":
  var primes = sieve(1000)
  primes.saveSieve("prim1000.bits")
  check open("prim1000.bits").getFileSize() == 370

test "loadPrimes":
  var primes = sieve(1000)
  primes.saveSieve("prim1000.bits")
  var back = loadSieve("prim1000.bits")
  var firstPrimes = back.below(100)
  check firstPrimes.len() == 25
  check firstPrimes == @[2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53,
  59, 61, 67, 71, 73, 79, 83, 89, 97]

test "wrong load":
  var fileName = "prim1000.bits"
  discard sieve(1000, fileName)
  var wrong = sieve(100, fileName)
  check isPrime(197, wrong) == true
