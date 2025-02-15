# Cleaning Data in SQL

-- Selecting the database to use
use project;
SET SQL_SAFE_UPDATES = 0;

-- Checking the data
select * 
from housing;

-- Standardizing date format
select SaleDate
from housing;

SELECT SaleDate, STR_TO_DATE(SaleDate, '%M %e, %Y') AS ConvertedSaleDate
FROM housing;

ALTER TABLE housing
ADD SaleDateConverted Date;

UPDATE housing
SET SaleDateConverted = STR_TO_DATE(SaleDate, '%M %e, %Y');

SELECT SaleDateConverted
FROM housing;

-- Populate Property Address Data

# Checking Null Values
SELECT PropertyAddress
FROM housing
WHERE PropertyAddress = null;

# Checking if empty values exist instead of null
SELECT PropertyAddress
FROM housing
WHERE PropertyAddress = "";

# Checking if Propert Address exists for Same Parcel ID
SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
FROM housing a
JOIN housing b
	on a.ParcelID = b.ParcelID
	AND a.UniqueID != b.UniqueID
WHERE a.PropertyAddress = "";

# Self JOIN for Populating Data
UPDATE housing a
JOIN housing b 
    ON a.ParcelID = b.ParcelID 
    AND a.UniqueID <> b.UniqueID
SET a.PropertyAddress = CASE WHEN a.PropertyAddress = "" THEN b.PropertyAddress ELSE a.PropertyAddress 
END
WHERE a.PropertyAddress = "";

-- Breaking out Property Address into Individual Columns (Address, City)
# Checking Pattern
SELECT PropertyAddress
FROM housing;

# Testing for updating Address
SELECT 
SUBSTRING(PropertyAddress, 1, LOCATE(',', PropertyAddress) -1) as PropertySplitAddress ,
SUBSTRING(PropertyAddress, LOCATE(',', PropertyAddress) +1, length(PropertyAddress)) as PropertySplitCity 
FROM housing;

# Creating New Columns
ALTER TABLE housing
ADD PropertySplitAddress varchar(255),
ADD PropertySplitCity varchar(255);

# Updating Data
UPDATE housing
SET PropertySplitCity = SUBSTRING(PropertyAddress, LOCATE(',', PropertyAddress) +1, length(PropertyAddress)),
	PropertySplitAddress = SUBSTRING(PropertyAddress, 1, LOCATE(',', PropertyAddress) -1);

-- Breaking out Owner Address into Individual Columns (Address, City, State)
# Checking Address
SELECT OwnerAddress
FROM housing;

# Checking Spliting Pattern
SELECT 
    TRIM(SUBSTRING_INDEX(OwnerAddress, ',', 1)) AS OwnerSplitAddress,
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ',', -1)) AS OwnerSplitCity,
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 3), ',', -1)) AS OwnerSplitState
FROM housing;

# Adding Columns in Table
ALTER TABLE housing
ADD OwnerSplitAddress varchar(255),
ADD OwnerSplitCity varchar(255),
ADD OwnerSplitState varchar(255);

# Updating Table
UPDATE housing
SET OwnerSplitAddress = TRIM(SUBSTRING_INDEX(OwnerAddress, ',', 1)),
	OwnerSplitCity =  TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ',', -1)),
    OwnerSplitState = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 3), ',', -1));

-- Change Y and N to Yes and No in "Sold in Vacant" field

SELECT DISTINCT(SoldasVacant), COUNT(SoldasVacant) as counts
FROM housing
GROUP BY SoldasVacant;

SELECT SoldasVacant,
CASE WHEN SoldasVacant = 'Y' THEN 'Yes'
	WHEN SoldasVacant = 'N' THEN 'No'
    ELSE SoldasVacant
END
From housing;

UPDATE housing
SET SoldasVacant = CASE WHEN SoldasVacant = 'Y' THEN 'Yes'
	WHEN SoldasVacant = 'N' THEN 'No'
    ELSE SoldasVacant
END;

-- Remove Duplicates

# Checking number of Duplicates
WITH RowNumCTE AS (
SELECT *,
	ROW_NUMBER() OVER (
    PARTITION BY ParcelID,
				PropertyAddress,
                SalePrice,
                SaleDate,
                LegalReference
                ORDER BY
					UniqueID) row_num
FROM housing
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress;

# Removing Duplicates
WITH RowNumCTE AS (
SELECT *,
	ROW_NUMBER() OVER (
    PARTITION BY ParcelID,
				PropertyAddress,
                SalePrice,
                SaleDate,
                LegalReference
                ORDER BY
					UniqueID) row_num
FROM housing
)
DELETE h 
FROM housing h
JOIN RowNumCTE cte 
    ON h.UniqueID = cte.UniqueID
WHERE cte.row_num > 1;

-- Delete unused Columns

# Checking the Data
SELECT *
FROM housing;

# Deleting Columns
ALTER TABLE housing
DROP COLUMN PropertyAddress,
DROP COLUMN SaleDate,
DROP COLUMN OwnerAddress,
DROP COLUMN TaxDistrict;