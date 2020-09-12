select rpad('* ',level*2,'* ') k  from dual connect by level<=20;
