-- Keep a log of any SQL queries you execute as you solve the mystery.

-- Look at crime reports at the time of crime
SELECT * FROM crime_scene_reports WHERE year = 2021 AND month = 7 AND day = 28;
-- Found hint 3 witnesses conducted interviews on same day of crime TIME: 10:15 AM
SELECT * FROM interviews WHERE year = 2021 AND month = 7 AND day = 28 AND transcript LIKE "%bakery%";
-- Witness names Ruth, Eugene, and Raymond  Bakery owner name Emma.
-- 10 mins after theft theif got in a car in bakery parking lot (CARS THAT LEFT 10min after theft)
--at morning of crime Eugene saw theif at ATM on Leggett Street withdrawing money
-- after theft as theif leaving theif called someone and less then min in the call they got a flight out of FIFtyVIll day after crime
-- possible theif or helper on the phone for about 30 mins  day of

--potential license_plates
SELECT license_plate FROM bakery_security_logs WHERE year = 2021 AND month = 7 AND day = 28 AND hour = 10 AND minute > 15 AND minute <25 AND activity LIKE "exit";

--potential bank account number linked to theif
SELECT account_number FROM atm_transactions WHERE year = 2021 AND month = 7 AND day = 28 AND atm_location LIKE "Leggett Street" AND transaction_type LIKE "withdraw";
--potential theif
SELECT person_id FROM bank_accounts WHERE account_number IN (SELECT account_number FROM atm_transactions WHERE year = 2021 AND month = 7 AND day = 28 AND atm_location LIKE "Leggett Street" AND transaction_type LIKE "withdraw");

-- not sure how this one helps cant tell what durations = if seconds i need something btween 1600 - 2000 but min max time seems too unreasonable who is ever on the phone for 300+ min at a time
-- caller at that time is potential theif less then min in info given but doesnt say how long call duration was...

--possible caller number
SELECT caller FROM phone_calls WHERE year = 2021 AND month = 7 and day = 28 AND duration < 60;

-- airpots in fiftyvill
SELECT * FROM airports WHERE city LIKE "Fiftyville";
-- POSSIBLE FLIGHTS THEIF TOOK
SELECT id FROM flights WHERE origin_airport_id  IN(SELECT id FROM airports WHERE city LIKE "Fiftyville") AND year = 2021 AND month = 7 AND day = 29 ORDER BY hour, minute LIMIT 1;
--possible THEIF FROM FLIGHT
SELECT passport_number FROM passengers WHERE flight_id IN (SELECT id FROM flights WHERE origin_airport_id  IN(SELECT id FROM airports WHERE city LIKE "Fiftyville") AND year = 2021 AND month = 7 AND day = 29 ORDER BY hour, minute LIMIT 1);


--Theif
SELECT name FROM people WHERE
id IN (SELECT person_id FROM bank_accounts WHERE account_number IN (SELECT account_number FROM atm_transactions WHERE year = 2021 AND month = 7 AND day = 28 AND atm_location LIKE "Leggett Street" AND transaction_type LIKE "withdraw")) AND
phone_number IN (SELECT caller FROM phone_calls WHERE year = 2021 AND month = 7 and day = 28 AND duration < 60) AND
passport_number IN (SELECT passport_number FROM passengers WHERE flight_id IN (SELECT id FROM flights WHERE origin_airport_id  IN(SELECT id FROM airports WHERE city LIKE "Fiftyville") AND year = 2021 AND month = 7 AND day = 29 ORDER BY hour, minute LIMIT 1)) AND
license_plate IN (SELECT license_plate FROM bakery_security_logs WHERE year = 2021 AND month = 7 AND day = 28 AND hour = 10 AND minute > 15 AND minute <25 AND activity LIKE "exit");

-- FINDING helper

SELECT phone_number FROM people WHERE id = 686048;

SELECT receiver FROM phone_calls WHERE year = 2021 AND month = 7 and day = 28 AND duration < 60 AND caller IN (SELECT phone_number FROM people WHERE id = 686048);
--Helper
SELECT name FROM people WHERE phone_number IN (SELECT receiver FROM phone_calls WHERE year = 2021 AND month = 7 and day = 28 AND duration < 60 AND caller IN (SELECT phone_number FROM people WHERE id = 686048));

-- Where they go
SELECT passport_number FROM people WHERE id = 686048;

SELECT * FROM flights WHERE origin_airport_id  IN(SELECT id FROM airports WHERE city LIKE "Fiftyville") AND year = 2021 AND month = 7 AND day = 29 ORDER BY hour, minute LIMIT 1;

-- flight_id = 18
SELECT destination_airport_id FROM flights WHERE id = 36;
-- where
SELECT city FROM airports WHERE id = (SELECT destination_airport_id FROM flights WHERE id = 36);