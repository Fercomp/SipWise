# SipWise

SipWise is an app designed to support **harm reduction while drinking**.
It allows users to track their alcohol intake by estimating the total grams of alcohol consumed over time.

## How the calculation works

The app uses a simplified model based on alcohol by volume (ABV):

* Beer is considered to have **5% ABV**
* Spirits (shots) are considered to have **40% ABV**

To estimate the amount of pure alcohol in a drink, we use:

grams of alcohol = volume (ml) × ABV × 0.789

Where:

* **ABV** is the alcohol percentage (e.g., 0.05 for beer, 0.40 for spirits)
* **0.789 g/ml** is the density of ethanol

This calculation provides an estimate of the **grams of alcohol consumed**, which can be used to track intake and support safer drinking habits.

## Thresholds (Guideline Ranges)

SipWise uses general reference ranges to help users understand their consumption level. These are based on common public health guidelines:

* 🟢 **Low**: up to ~20 g
* 🟡 **Moderate**: 20–40 g
* 🟠 **High**: 40–60 g
* 🔴 **Very High (Binge range)**: 60 g+

These ranges are not strict limits, but **approximate guidelines** to provide context about alcohol intake.

## Disclaimer

This app should not be used to determine fitness to drive or make safety-critical decisions.
Alcohol effects vary between individuals based on factors such as body weight, metabolism, and food intake.
