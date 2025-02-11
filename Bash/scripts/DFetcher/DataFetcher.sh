#!/bin/bash

# Declaration of INSEE codes in the "code_insee" array.
code_insee=(
  "31032"
  "31056"
  "31069"
  "31088"
  "31149"
  "31150"
  "31157"
  "31291"
  "31351"
  "31417"
  "31424"
  "31526"
  "31555"
  "31557"
)

# Declaration of city names in the "city_name" array.
city_name=(
  "Aussonne"
  "Beauzelle"
  "Blagnac"
  "Brax"
  "Colomiers"
  "Cornebarrieu"
  "Cugnaux"
  "Leguevin"
  "Mondonville"
  "Pibrac"
  "Plaisance-du-Touch"
  "Salvetat-Saint-Gilles"
  "Toulouse"
  "Tournefeuille"
)

# Create the root folder "foncier_communal".
mkdir foncier_communal
# Navigate to the created root folder.
cd foncier_communal

# Loop through each array synchronously. The pairs are defined by the order of declaration.
for i in ${!code_insee[*]}; do
  # Log the correspondences in the console in parallel with the processing.
  echo "${code_insee[$i]} is ${city_name[$i]}"
  # Create each sub-folder with the city name in the root folder "foncier_communal".
  mkdir "${city_name[$i]}"
  # Navigate to the created sub-folder.
  cd "${city_name[$i]}"
  # Download the data corresponding to the INSEE code in the created sub-folder.
  wget -np "https://files.data.gouv.fr/geo-dvf/latest/csv/2024/communes/31/${code_insee[$i]}.csv"
  # Return to the root folder "foncier_communal".
  cd ..
done