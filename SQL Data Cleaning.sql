
--Cleaning Data In SQL Queries


select *
from portfolioproject.dbo.nashvillehousing

-----------------------------------------------------------------

--Standarize Date Format

select saledate,convert(Date,saledate)
from portfolioproject.dbo.nashvillehousing

update nashvillehousing 
set saledate=convert(Date,saledate)


-------------------------------------------------------------

--Populated Property Address Data

select *
from portfolioproject.dbo.nashvillehousing
--where propertyAddress is null
order by parcelid

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
from portfolioproject.dbo.nashvillehousing a
join portfolioproject.dbo.nashvillehousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null



update a 
set PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
from portfolioproject.dbo.nashvillehousing a
join portfolioproject.dbo.nashvillehousing b
on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

-------------------------------------------------------------------

--Breaking Out Address into individual Coulmns(Address,City,State)


select PropertyAddress
from portfolioproject.dbo.nashvillehousing
--where propertyAddress is null
--order by parcelid

select 
substring(PropertyAddress,1,charindex(',', PropertyAddress)-1) as Address
,SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress)) as Address2
from portfolioproject.dbo.nashvillehousing

Alter Table nashvillehousing
Add PropertySplitAddress Nvarchar(255);

update nashvillehousing
set PropertySplitAddress=substring(PropertyAddress,1,charindex(',', PropertyAddress)-1)

Alter Table nashvillehousing
Add PropertySplitcity Nvarchar(255);


update nashvillehousing
set PropertySplitcity=SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress))

select *
from PortfolioProject.dbo.NashvilleHousing

select OwnerAddress
from PortfolioProject.dbo.NashvilleHousing

select
PARSENAME(Replace(OwnerAddress,',','.'),3),
PARSENAME(Replace(OwnerAddress,',','.'),2),
PARSENAME(Replace(OwnerAddress,',','.'),1)
from PortfolioProject.dbo.NashvilleHousing


Alter Table nashvillehousing
Add OwnerSplitAddress Nvarchar(255);


update nashvillehousing
set OwnerSplitAddress=PARSENAME(Replace(OwnerAddress,',','.'),3)


Alter Table nashvillehousing
Add OwnerSplitCity Nvarchar(255);


update nashvillehousing
set OwnerSplitCity=PARSENAME(Replace(OwnerAddress,',','.'),2)


Alter Table nashvillehousing
Add OwnerSplitState Nvarchar(255);


update nashvillehousing
set OwnerSplitState=PARSENAME(Replace(OwnerAddress,',','.'),1)

select *
from PortfolioProject.dbo.NashvilleHousing


-----------------------------------------------------------------------------------------------

--Change Y and N to Yes and No in "Sold As Vacant" Field

select Distinct(SoldAsVacant),count(SoldAsVacant)
from PortfolioProject.dbo.NashvilleHousing
group by SoldAsVacant
order by 2

select SoldAsVacant
,case When SoldAsVacant ='N' Then 'No'
      When SoldAsVacant ='Y' Then 'Yes'
	  Else SoldAsVacant
	  End
from PortfolioProject.dbo.NashvilleHousing 

update NashvilleHousing
set SoldAsVacant=case When SoldAsVacant ='N' Then 'No'
      When SoldAsVacant ='Y' Then 'Yes'
	  Else SoldAsVacant
	  End

----------------------------------------------------------------------------------------------------









