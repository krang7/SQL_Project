use data_projects;

select * from housing_data ;

# Breaking out Address into individual columns (Address, city , state)

select PropertyAddress from housing_data;

select substring_index(PropertyAddress,',',1) as Address ,
substring_index(PropertyAddress,',',-1) as Address
from housing_data;

alter table housing_data
add propertylocation varchar(255) ;

update housing_data
set propertylocation = substring_index(PropertyAddress,',',1);

alter table housing_data
add propertycity varchar(255) ;

update housing_data
set propertycity = substring_index(PropertyAddress,',',-1);


update housing_data set propertycity = substring_index(PropertyAddress,',',-1)

# change Y and N to yes and no in "soled and vacant" feild

select distinct(SoldAsVacant) , count(SoldAsVacant)
from housing_data
group by SoldAsVacant
order by 2;

select distinct(SoldAsVacant) , count(SoldAsVacant) ,
case when SoldAsVacant = 'Y' then 'YES'
     when  SoldAsVacant = 'N' then 'NO'
     else  SoldAsVacant
     end
from housing_data
group by SoldAsVacant
order by 2;

update housing_data
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'YES'
     when  SoldAsVacant = 'N' then 'NO'
     else  SoldAsVacant
     end;
#remove duplicates
select * from housing_data

with Rownum as (
select *,
row_number() over(
partition by ParcelID,PropertyAddress,SalePrice,SaleDate,LegalReference Order by UniqueID) row_num
from housing_data)
select *from Rownum
where row_num 1;
     