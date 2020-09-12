select 
case when a+b <= c or a+c <= b or c+b <=a then 'Not A Triangle'
when a=b and b=c and c=a then 'Equilateral'
when a <> b and b <> c and c <> a then 'Scalene'
when a=b or b=c or c=a then 'Isosceles'
end 
from triangles;