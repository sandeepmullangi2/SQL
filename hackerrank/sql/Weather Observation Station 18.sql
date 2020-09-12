select cast(abs(max(lat_n) - min(lat_n)) + abs(max(long_w)-min(long_w)) as decimal(10,4)) from station;
