-- Cleaning Data in SQL Queries

Select * 
From [PortfolioProject ]..NashvilleHousing

--Standardlize Date Format

Select SaleDate, SaleDateConverted
From [PortfolioProject ]..NashvilleHousing

update NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted DATE

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)

-- Populate Property Address Dât
Select PropertyAddress
From [PortfolioProject ]..NashvilleHousing
group by PropertyAddress

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From [PortfolioProject ]..NashvilleHousing a
join [PortfolioProject ]..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
	where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from [PortfolioProject ]..NashvilleHousing a
join [PortfolioProject ]..NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
	where a.PropertyAddress is null

-- Breaking out Address into Individual Columns (Address, City, State)

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
ADD PropertySplitCity nvarchar(255);

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

select PropertySplitAddress, PropertySplitCity
from [PortfolioProject ]..NashvilleHousing

select OwnerAddress
from [PortfolioProject ]..NashvilleHousing

select PARSENAME(REPLACE (OwnerAddress,',','.'), 3)
,PARSENAME(REPLACE (OwnerAddress,',','.'), 2)
,PARSENAME(REPLACE (OwnerAddress,',','.'), 1)
from [PortfolioProject ]..NashvilleHousing

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE (OwnerAddress,',','.'), 3)

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE (OwnerAddress,',','.'), 2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE (OwnerAddress,',','.'), 1)


-- Change Y and N to Yes and No in "Sold as Vacant" field
Select *
from [PortfolioProject ]..NashvilleHousing

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2

select SoldAsVacant, 
case 
when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end
from [PortfolioProject ]..NashvilleHousing

update NashvilleHousing
set SoldAsVacant = case 
when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end

-- remove duplicates
select *
from [PortfolioProject ]..NashvilleHousing

with RowNumCTE as(
select *, 
	ROW_NUMBER() over (
	partition by ParcelID,
	PropertyAddress, 
	SalePrice,
	SaleDate,
	LegalReference
	ORDER  BY	
		UniqueID
		) row_num
from [PortfolioProject ]..NashvilleHousing
)
select * 
from RowNumCTE
where row_num > 1
order by PropertyAddress

-- Delete Unused Columns
select *
from [PortfolioProject ]..NashvilleHousing

ALTER TABLE [PortfolioProject ]..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate