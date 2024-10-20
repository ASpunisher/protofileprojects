use datacleaning

-- standardize Data format 

select SaleDate , convert(Date,SaleDate) as SaleDateAfterModifications from nashville 


alter table nashville 
add SaleDateConverted  Date

update nashville
set SaleDateConverted =  convert(Date,SaleDate)


select SaleDateConverted from nashville


-- populate property Address date 

--selfjoin

select a.ParcelID , a.PropertyAddress ,b.ParcelID, b.PropertyAddress,isnull(a.PropertyAddress,b.PropertyAddress)
from nashville a join nashville b 
on a.ParcelID= b.ParcelID 
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null




update a
set  PropertyAddress =isnull(a.PropertyAddress,b.PropertyAddress)
from nashville a join nashville b 
on a.ParcelID= b.ParcelID 
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

-- Breaking out Address into individual columns(Address,city,state)

select SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1) as Address  
, substring(PropertyAddress,charindex(',', PropertyAddress) + 1,len(propertyAddress))
from nashville

alter table nashville 
add PropertySplitAddress nvarchar(255) 

update nashville
set PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1) 

alter table nashville 
add PropertySplitCity nvarchar(255)
update nashville 
set PropertySplitCity = substring(PropertyAddress,charindex(',', PropertyAddress) + 1,len(propertyAddress))
select * from nashville



-- using parsename
select Parsename(REPLACE(owneraddress,',','.'),3 ),Parsename(REPLACE(owneraddress,',','.'),2 ),
Parsename(REPLACE(owneraddress,',','.'),1 )


from nashville

alter table nashville 
add OwnerSplitAddress nvarchar(255)


update nashville
set OwnerSplitAddress = Parsename(REPLACE(owneraddress,',','.'),3 )

alter table nashville 
add OwnerSplitCity nvarchar(255)
update nashville 
set OwnerSplitCity = Parsename(REPLACE(owneraddress,',','.'),2 )

alter table nashville 
add OwnerSplitState nvarchar(255)

update nashville 
set OwnerSplitState =Parsename(REPLACE(owneraddress,',','.'),1 )


-- change Y and N to yes and no in soldasvacant feild

select SoldAsVacant , case
when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end
from nashville

update nashville 
set SoldAsVacant = case
when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end

-- remove duplicates 

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From nashville
--order by ParcelID
)
delete 
From RowNumCTE
Where row_num > 1



-- Delete Unused Columns



Select *
From nashville

ALTER TABLE nashville
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate



