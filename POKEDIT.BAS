DECLARE FUNCTION longadd& (addend1 AS STRING, addend2 AS STRING)
' Third Try
DEFINT A-Z
DIM pokedata AS STRING * 100
DIM dataptr AS LONG
DIM enkey AS STRING * 4
DIM long1 AS LONG, long2 AS LONG
DIM checksum AS LONG
DIM checksum0 AS LONG
DIM signature AS STRING * 8

DIM byte AS INTEGER
DIM word AS STRING * 2
DIM dword AS STRING * 4
DIM qword AS STRING * 8

DIM ax(3) AS INTEGER, ay(3) AS INTEGER

DIM dp AS LONG, ep AS LONG

DEF SEG = VARSEG(pokedata)
dp = VARPTR(pokedata)
ep = VARPTR(enkey)



CLS : CLOSE
RANDOMIZE TIMER
PRINT INT(RND * 1000000 + 1)
         
PRINT longadd&("50", "50")
SLEEP
SLEEP


'GOSUB finddata ' doesn't work
'GOSUB loaddata
'GOSUB computesum
'GOSUB xorfun
'GOSUB computesum
'GOSUB writedata
'GOSUB swapdataq ' doesn't work


STOP

finddata:


RETURN

loaddata:

  OPEN "data\input" FOR BINARY AS #1
  GET #1, 1, pokedata
  CLOSE #1

RETURN

xorfun:

  PRINT "xorfun"

  FOR i = 0 TO 3
    POKE ep + i, PEEK(dp + i) XOR PEEK(dp + 4 + i)
  NEXT i

  FOR i = 0 TO 47
    byte = PEEK(ep + i MOD 4) XOR PEEK(dp + 32 + i)
    POKE dp + 32 + i, byte
    'checksum = checksum + byte * 256 ^ i MOD 4
  NEXT i

  PRINT "Key is:"
  PRINT HEX$(PEEK(ep));
  PRINT HEX$(PEEK(ep + 1));
  PRINT HEX$(PEEK(ep + 2));
  PRINT HEX$(PEEK(ep + 3))
RETURN

writedata:

  OPEN "data\output" FOR BINARY AS #1
  PUT #1, 1, pokedata
  CLOSE #1

RETURN

computesum:

  'checksum0 = PEEK(dp + 28) + PEEK(dp + 29) * 256

  FOR i = 0 TO 47

    byte = PEEK(dp + 32 + i)
    long1 = byte * 256 ^ (i MOD 2)
    IF checksum < long1 THEN
      checksum = 65536 - long1 + checksum
    ELSE
      checksum = checksum - long1
    END IF

  NEXT i

  checksum = 65536 - checksum

  PRINT HEX$(checksum)
  PRINT
  PRINT HEX$(checksum0)
  SLEEP

RETURN

swapdataq:
      
long1 = 8 * ((3 - (PEEK(dp) + PEEK(dp + 1) * 256) MOD 3) MOD 3)
long2 = (PEEK(dp + 2) + PEEK(dp + 3) * 256) MOD 24
x(0) = (long1 + long2) MOD 24
99999999999999999999999999999999999999
FOR i = 0 TO 3

  x(i + 1) = x(i) MOD (2 * (3 - i)) + 1
  y(i) = (x(i) - 1) \ (2 * (3 - i)) + 1
  FOR i2 = 0 TO i
    DO WHILE y(i) = y(i2): y(i) = y(i) MOD (2 * (3 - i)) + 1: LOOP
  NEXT i2

NEXT i

RETURN

FUNCTION longadd& (addend1 AS STRING, addend2 AS STRING)
DIM sum AS STRING
DIM add AS STRING
DIM carry AS INTEGER

carry = 0

IF addend1 < addend2 THEN u = LEN(addend1) ELSE u = LEN(addend2)

FOR i = u TO 0 STEP -1

  a = VAL(MID$(addend1, u, 1)) + VAL(MID$(addend2, u, 1)) + carry
  add = STR$(a MOD 10)
  carry = a \ 10
  sum = add + sum

NEXT i

IF carry <> 0 THEN sum = sum + STR$(carry)

longadd& = VAL(sum)

END FUNCTION

