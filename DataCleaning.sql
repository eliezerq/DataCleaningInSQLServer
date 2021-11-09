  
/************************************************
Cleaning Data in SQL Queries
*************************************************/

/*SELECT ALL Data from NashvilleHousing*/
SELECT 
	*
FROM
	PortfolioProjects.dbo.NashvilleHousing


/************************************************
-- Standardize Date Format
*************************************************/
/*Convert the datettime to only date*/
SELECT 
	saleDate, CONVERT(Date,  SaleDate) AS SaleDateConverted
FROM 
	PortfolioProjects.dbo.NashvilleHousing

/*Create nuw column in the table table PortfolioProjects.dbo.NashvilleHousing*/
ALTER table 
	PortfolioProjects.dbo.NashvilleHousing
ADD
	SaleDateConverted date

/*Set only the date from SaleDate on the new column SaleDateConverted*/
UPDATE PortfolioProjects.dbo.NashvilleHousing
SET SaleDateConverted = CONVERT(Date,  SaleDate)

/*Select only saleDate, SaleDateConverted*/
SELECT 
	saleDate, SaleDateConverted
FROM 
	PortfolioProjects.dbo.NashvilleHousing
--------------------------------------------------------------------------------------------------------------------------

/********************************************************
-- Eliminate NULL - Populate Property Address data
*********************************************************/

/*Select ParcelID*/
SELECT
	ParcelID
FROM 
	PortfolioProjects.dbo.NashvilleHousing
WHERE
	PropertyAddress IS NULL

/*Select the ParcelID, PropertyAddress from a subselect, the gola was to know if the ParcelID with PropertyAddress null values
have a not null value in another register*/
SELECT ParcelID, PropertyAddress
FROM PortfolioProjects.dbo.NashvilleHousing
WHERE ParcelID IN (
SELECT
	ParcelID
FROM 
	PortfolioProjects.dbo.NashvilleHousing
WHERE
	PropertyAddress IS NULL) 

/* The next queries replace the null values in PropertyAddress with a PropertyAddress valid in another register*/
SELECT a.UniqueID,  a.PropertyAddress, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress) AS temp
FROM
	PortfolioProjects.dbo.NashvilleHousing AS a INNER JOIN
	PortfolioProjects.dbo.NashvilleHousing AS b ON a.ParcelID = b.ParcelID AND a.UniqueID <> b.UniqueID
WHERE
	a.PropertyAddress IS NULL

UPDATE a
	SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM
	PortfolioProjects.dbo.NashvilleHousing AS a INNER JOIN
	PortfolioProjects.dbo.NashvilleHousing AS b ON a.ParcelID = b.ParcelID AND a.UniqueID <> b.UniqueID
WHERE
	a.PropertyAddress IS NULL

	------************************************************
	

SELECT
	*
FROM
	PortfolioProjects.dbo.NashvilleHousing
--Where PropertyAddress is null
ORDER BY
	ParcelID



SELECT 
	a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM
	PortfolioProjects.dbo.NashvilleHousing a
	JOIN PortfolioProjects.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID 	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE
	a.PropertyAddress is null


UPDATE
	a
SET
	PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From 
	PortfolioProject.dbo.NashvilleHousing a JOIN 
	PortfolioProject.dbo.NashvilleHousing b ON a.ParcelID = b.ParcelID 	AND a.[UniqueID ] <> b.[UniqueID ]
WHERE
	a.PropertyAddress is null




--------------------------------------------------------------------------------------------------------------------------
/*************************************************************************
-- Breaking out Address into Individual Columns (Address, City, State)
*************************************************************************/


SELECT
	PropertyAddress
From
	PortfolioProjects.dbo.NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID

/*SELECT the position where the ',' is founded in the PropertyAddress column*/
SELECT 
	CHARINDEX(',', PropertyAddress)
FROM
	PortfolioProjects.dbo.NashvilleHousing

/*Separete in two colums the colum PropertyAddress*/
SELECT
	SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address1
	, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address2
From 
	PortfolioProjects.dbo.NashvilleHousing



/* Create a new colum where is goint to store the adrress split*/
ALTER TABLE 
	PortfolioProjects.dbo.NashvilleHousing
Add
	PropertySplitAddress Nvarchar(255);

/*Save the split adreess in the new column*/
UPDATE
	PortfolioProjects.dbo.NashvilleHousing
SET
	PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

SELECT PropertyAddress, PropertySplitAddress
from PortfolioProjects.dbo.NashvilleHousing

/*Add a new colum to save only the citty address*/
ALTER TABLE 
	PortfolioProjects.dbo.NashvilleHousing
Add
	PropertySplitCity Nvarchar(255);

/*Save the city adress in the new colum*/
Update 	PortfolioProjects.dbo.NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))


SELECT PropertyAddress, PropertySplitAddress, PropertySplitCity
from PortfolioProjects.dbo.NashvilleHousing


Select *
From PortfolioProjects.dbo.NashvilleHousing





Select OwnerAddress
From PortfolioProjects.dbo.NashvilleHousing

/*Examples of how to use parsename and replace functions*/
SELECT PARSENAME('ServerName.DatabaseName.                    SchemaName.ObjectName', 2)
SELECT REPLACE('ServerName.DatabaseName.                    SchemaName.ObjectName.', '.', '*')

SELECT OwnerAddress, PARSENAME(OwnerAddress, 1)
From PortfolioProjects.dbo.NashvilleHousing

/*parse the OwnerAddress*/
Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PortfolioProjects.dbo.NashvilleHousing


/*Add a nuew colum call it OwnerSplitAddress to save the new split ownerAddress*/
ALTER TABLE PortfolioProjects.dbo.NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

/*save in the new table the split oner address*/
Update PortfolioProjects.dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

/*Add a new colum call it OwnerSplitAddress to save the new split ownerAddress*/
ALTER TABLE PortfolioProjects.dbo.NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

/*save in the new table the split oner address*/
Update PortfolioProjects.dbo.NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

/*Add a new colum call it OwnerSplitAddress to save the new split ownerAddress*/
ALTER TABLE PortfolioProjects.dbo.NashvilleHousing
Add OwnerSplitState Nvarchar(255);

/*save in the new table the split oner address*/
Update PortfolioProjects.dbo.NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From PortfolioProjects.dbo.NashvilleHousing




--------------------------------------------------------------------------------------------------------------------------

/************************************************************************
-- Change Y and N to Yes and No in "Sold as Vacant" field
*************************************************************************/


Select DISTINCT(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProjects.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From PortfolioProjects.dbo.NashvilleHousing

/*Update the SoldAsVacant value with only Yes and No*/
Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END






-----------------------------------------------------------------------------------------------------------------------------------------------------------
/*****************************************************
-- Remove Duplicates
******************************************************/

WITH RowNumCTE AS(
	Select *,
		ROW_NUMBER() OVER (
		PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
				 ORDER BY UniqueID ) row_num

	From PortfolioProjects.dbo.NashvilleHousing
	--order by ParcelID
	)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

----------------DELETE ROWS
/*WITH RowNumCTE AS(
	Select *,
		ROW_NUMBER() OVER (
		PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
				 ORDER BY UniqueID ) row_num

	From PortfolioProjects.dbo.NashvilleHousing
	--order by ParcelID
	)
DELETE
From RowNumCTE
Where row_num > 1*/




Select *
From PortfolioProjects.dbo.NashvilleHousing




---------------------------------------------------------------------------------------------------------
/************************************************
-- Delete Unused Columns
*************************************************/


Select *
From PortfolioProjects.dbo.NashvilleHousing


ALTER TABLE PortfolioProjects.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate















-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

--- Importing Data using OPENROWSET and BULK INSERT	

--  More advanced and looks cooler, but have to configure server appropriately to do correctly
--  Wanted to provide this in case you wanted to try it


--sp_configure 'show advanced options', 1;
--RECONFIGURE;
--GO
--sp_configure 'Ad Hoc Distributed Queries', 1;
--RECONFIGURE;
--GO


--USE PortfolioProject 

--GO 

--EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'AllowInProcess', 1 

--GO 

--EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'DynamicParameters', 1 

--GO 


---- Using BULK INSERT

--USE PortfolioProject;
--GO
--BULK INSERT nashvilleHousing FROM 'C:\Temp\SQL Server Management Studio\Nashville Housing Data for Data Cleaning Project.csv'
--   WITH (
--      FIELDTERMINATOR = ',',
--      ROWTERMINATOR = '\n'
--);
--GO


---- Using OPENROWSET
--USE PortfolioProject;
--GO
--SELECT * INTO nashvilleHousing
--FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0',
--    'Excel 12.0; Database=C:\Users\alexf\OneDrive\Documents\SQL Server Management Studio\Nashville Housing Data for Data Cleaning Project.csv', [Sheet1$]);
--GO



