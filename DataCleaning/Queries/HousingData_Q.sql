select * from NashvilleHousing.dbo.NashvilleHousingData
--:Standardize Date format

select SaleDate, CONVERT(Date,SaleDate)
from NashvilleHousing.dbo.NashvilleHousingData

update NashvilleHousingData
set SaleDate = CONVERT(Date,SaleDate)

--Adding the column |SaleDateConverted|
--Altering the above table
alter table NashvilleHousingData
add SaleDateConverted Date;

update NashvilleHousingData
set SaleDateConverted = CONVERT(Date,SaleDate)

--Testing conversion and addition
select SaleDateConverted, CONVERT(Date,SaleDate)
from NashvilleHousing.dbo.NashvilleHousingData
------------------------------------------------------------------------


--:Populate property address data--

select *
from NashvilleHousing.dbo.NashvilleHousingData
--where PropertyAddress is null
order by ParcelID

--Taking the ParcelID and looking at the matched addresses. 
--If the ParcelID has no address, then populate it with the same address
/** 
This is done by using a join on the table itself to copy the ParcelID references
**/
select main.ParcelID, main.PropertyAddress, ref.ParcelID, ref.PropertyAddress, ISNULL(main.PropertyAddress, ref.PropertyAddress)
from NashvilleHousing.dbo.NashvilleHousingData main
JOIN NashvilleHousing.dbo.NashvilleHousingData ref
	on main.ParcelID = ref.ParcelID
	--UniqueID are not equal to each other
	AND main.[UniqueID ] <> ref.[UniqueID ]
where main.PropertyAddress is null

update main
set PropertyAddress = ISNULL(main.PropertyAddress, ref.PropertyAddress)
from NashvilleHousing.dbo.NashvilleHousingData main
JOIN NashvilleHousing.dbo.NashvilleHousingData ref
	on main.ParcelID = ref.ParcelID
	AND main.[UniqueID ] <> ref.[UniqueID ]
where main.PropertyAddress is null
------------------------------------------------------------------------


--:Break out address into individual columns (address, city, state)--

select PropertyAddress
from NashvilleHousing.dbo.NashvilleHousingData

-- using SUBSTRING and TRI index(character index)
--select substring(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)) as Address,
--CHARINDEX(',',PropertyAddress)
--from DataCleaning_pp.dbo.NashvilleHousingData
--^^^^ Since the above prints out a numeric value. we find the comma and remove it by adding -1(to GO BACK BEFORE THE COMMA)
select substring(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1) as Address
from NashvilleHousing.dbo.NashvilleHousingData

--Separating the Words to insert commas for new columns
select SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1) as Address
	,SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress)) as Address
from NashvilleHousing.dbo.NashvilleHousingData

--Adding COLUMNS for address and city
alter table NashvilleHousingData
add PropertySplitAddress nvarchar(255);

update NashvilleHousingData
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1)

alter table NashvilleHousingData
add PropertySplitCity nvarchar(255);

update NashvilleHousingData
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress))

select * 
from NashvilleHousing.dbo.NashvilleHousingData
------------------------------------------------------------------------

--:Change Y and N to Yes and No in |Sold as Vacant| field--

--:Remove duplicates--

--:Delete unused columns--