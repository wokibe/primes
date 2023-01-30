# tools for prime numbers
# kittekat jan/2023

import bitty, math, streams, marshal, strformat, os

proc error() =
  raise newException(ValueError, 
    "primes are not defined for negative numbers")

func isPrime*(n: int): bool =
  # compute proof on the fly
  if n < 0:
    error()
  if n <= 1:
    return false
  if n <= 3:
    return true
  let limit = int(sqrt(float(n)))
  for i in 2 .. limit + 1:
    if n mod i == 0:
      return false
  return true

func below*(n: int): seq[int] =
  # return a seq[int] with all primes below n
  for i in 2 ..< n:
    if isPrime(i):
      result.add(i)

func sieve*(n: int): BitArray =
  # sieve of Eratosthenes
  # generate a packed seq[bool] for all numbers < n
  # with inverted logic: like the joke "true means false"
  # newBitArray fills initially with false
  # loop over all n
  #   a false indicates a prime
  #   set all multiples to true
  if n < 0:
    error()
  result = newBitArray(n + 1)
  result[0] = true                  # 0 is not a prime
  result[1] = true                  # 1 is not a prime
  let limit = int(sqrt(float(n)))
  for i in 2 .. limit:
    if result[i] == false:          # found a prime
      for j in countup(i*i, n, i):
        result[j] = true            # clear all multiples

func isPrime*(n: int, primes: BitArray): bool =
  # use precomputed sieve if possible
  if n >= 0 and n < primes.len:
    result = not primes[n]
  else:
    result = isPrime(n)

proc below*(primes: BitArray, n: int): seq[int] =
  # return a seq[int] witth all primes below n with help of sieve
  for k, v in primes:
    if not v:
      if k < n:
        result.add(k)

proc saveSieve*(primes: BitArray, fileName: string) =
  # save the seq[bool] to a file
  var strm = newFileStream(fileName, fmWrite)
  var serial = $$primes
  strm.write(serial)
  strm.close()

proc loadSieve*(fileName: string): BitArray =
  # load the seq[bool] from a previous created file 
  var strm = newFileStream(fileName, fmRead)
  var serial = ""
  discard strm.readLine(serial)
  strm.close()
  result = to[BitArray](serial)

proc sieve*(n: int, fileName: string): BitArray =
  # if a precomputed sieve file exists: load it
  # else compute it now and save it for later
  if fileExists(fileName):
    result = loadSieve(fileName)
    if result.len - 1 != n:
      echo fmt(
        "Warning: loaded sieve computed for different limit {result.len - 1}/{n}")
  else:
    result = sieve(n)
    result.saveSieve(fileName)
   