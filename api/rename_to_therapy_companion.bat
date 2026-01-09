@echo off
echo ===============================
echo Renaming remaining Hotel Booking files
echo ===============================

REM ---- Solution file ----
if exist "Hotel_Booking.sln" (
    ren "Hotel_Booking.sln" "Therapy_Companion.sln"
)

REM ---- Postman collections ----
if exist "Hotel Booking API.postman_collection.json" (
    ren "Hotel Booking API.postman_collection.json" "Therapy_Companion_API.postman_collection.json"
)

if exist "Hotel_Booking_Stripe.postman_collection.json" (
    ren "Hotel_Booking_Stripe.postman_collection.json" "Therapy_Companion_Stripe.postman_collection.json"
)

echo ===============================
echo Remaining files renamed
echo ===============================
pause
