/*
Cleaning Data in SQL Queries
*/


Select *
From PortfolioProject.dbo.NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

Select  SaleDateConverted, CONVERT(Date,SaleDate)
From PortfolioProject.dbo.NashvilleHousing


Update PortfolioProject.dbo. NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)



 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelID

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL( a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
join  PortfolioProject.dbo.NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ]<>b.[UniqueID ]
Where a.PropertyAddress is null


Update a
Set PropertyAddress = ISNULL ( a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
join  PortfolioProject.dbo.NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ]<>b.[UniqueID ]
Where a.PropertyAddress is null


--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress IS NULL 
--ORDER BY ParcelID


SELECT
SUBSTRING(PropertyAddress, 1, Charindex(',', PropertyAddress )-1) as Address,
SUBSTRING(PropertyAddress,  Charindex(',', PropertyAddress ) +1 ,LEN(PropertyAddress)) as Address

From PortfolioProject.dBO.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, Charindex(',', PropertyAddress )-1)

ALTER TABLE
PortfolioProject.dbo.NashvilleHousing
Add PropertySplitCity  Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress,  Charindex(',', PropertyAddress ) +1 ,LEN(PropertyAddress)) 



Select * 
From PortfolioProject.dbo.NashvilleHousing 



Select OwnerAddress
From PortfolioProject.dbo.NashvilleHousing 

Select
PARSENAME(replace(OwnerAddress, ',','.'), 3),
PARSENAME(replace(OwnerAddress, ',','.'), 2),
PARSENAME(replace(OwnerAddress, ',','.'), 1)
From PortFolioProject.dbo.NashvilleHousing


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(replace(OwnerAddress, ',','.'), 3)

ALTER TABLE
PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitCity  Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitcity =PARSENAME(replace(OwnerAddress, ',','.'), 2)


ALTER TABLE
PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitState  Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitState =PARSENAME(replace(OwnerAddress, ',','.'), 1)


Select *
From PortfolioProject.dbo.NashvilleHousing



--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct (SoldAsVacant), COUNT(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group By SoldAsVacant
order by 2


Select SoldAsVacant ,
 Case WHEN SoldAsVacant = 'Y' THEN 'YES'
      WHEN SoldAsVacant = 'N' THEN 'NO'
	  ELSE SoldAsVacant
	  END
From PortfolioProject.dbo.NashvilleHousing

Update PortfolioProject.dbo.NashvilleHousing
SET SoldAsVacant = Case WHEN SoldAsVacant = 'Y' THEN 'YES'
      WHEN SoldAsVacant = 'N' THEN 'NO'
	  ELSE SoldAsVacant
	  END




-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
Select * ,
	ROW_NUMBER () OVER (
	PARTITION BY ParcelID,
				PropertyAddress,
				SaleDate,
				SalePrice,
				LegalReference
				Order By 
				 UniqueID
				 ) row_num
	 
From PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)

--Delete
Select * 
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From PortfolioProject.dbo.NashvilleHousing

Alter Table PortFolioProject.dbo.NashvilleHousing
Drop COLUMN OwnerAddress, TaXDistrict, PropertyAddress 

Alter Table PortFolioProject.dbo.NashvilleHousing
DROP column SaleDate














-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------