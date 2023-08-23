# 14/08/2023
# 1

script() { 
if [ $# != 2 ]; then
  echo Error
fi

if [ $# = 2 ]; then
  echo $(( $1 + $2 ))
fi 
}

# 2

script() {
egrep "systemd-logind\[[0-9]+\]" myauth.log | grep user | cut -d " " -f 11 | cut -d "." -f 1 | sort | uniq
}

# 3

script() { 
cat words.txt | sed -e "s/^\(.*\)_\(.*\)\$/\2_\1/g" | sed "y/abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ/ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz/"
}

# 4

script() { 
# Solution 1
sed -n '/FROM/,/TO/p' input.txt | sed '/FROM/d' | sed '/TO/d'
# Solution 2
# sed -n '/FROM/,/TO/{//!p;}' input.txt
# Solution 3
# sed -n '/FROM/,/TO/{/FROM/d;/TO/d;p;}'
}

# 5
script() { awk '
BEGIN {
  prev="";
  
}

{
  $0=tolower($0);
  #gsub(/[^A-Za-z0-9 \t]/, "");
  for (i = 1; i <= NF; i++) {
    if ($i == prev) {
      print $i
                
    }
    prev = $i;
  }
}

' myfile.txt
}

# 6

script () { echo '
BEGIN{
  FS = ","
}

{
  if (NR == 1){
    l1997 = 0; c1997 = 0; av1997 = 0;
    l1998 = 0; c1998 = 0; av1998 = 0;
    l1999 = 0; c1999 = 0; av1999 = 0;
    l2000 = 0; c2000 = 0; av2000 = 0;
  }
  EID = $1;
  leave = int($3);
  # to obtain year from employee ID
  year = int(substr(EID, 2, 4));
  if (year == 1997)
  {
    l1997 = l1997 + leave; c1997++;}
  else if (year == 1998)
  {
    l1998 = l1998 + leave; c1998++;}
  else if (year == 1999)
  {
    l1999 = l1999 + leave; c1999++;}
  else if (year == 2000)
  {
    l2000 = l2000 + leave; c2000++;}
}

END{
  if (c1997 != 0)
    {av1997 = l1997/c1997;}
  if (c1998 != 0)
    {av1998 = l1998/c1998;}
  if (c1999 != 0)
    {av1999 = l1999/c1999;}
  if (c2000 != 0)
    {av2000 = l2000/c2000;}
  print (int(av1997))
  print (int(av1998))
  print (int(av1999))
  print (int(av2000))
}
' >yourScript.awk
awk -f yourScript.awk EmployeeDetails.csv
}


# 15/08/2023
# 1

script() {
if [[ $(ls -l $1 | grep -e "^-r--------.*") ]] ; then
    echo "Yes"
fi
}

# 2

script() {
grep "\bsession opened for user guest\b" myauth.log | tail -1 | cut -d " " -f 1-3
}

# 3

script() { echo '
filename=${@: -1}

while getopts "wlns:" options; do
  case "${options}" in
    s)
      str=${OPTARG}
      sed "s/ /\n/g" $filename | sed -ne "/$str/ p" | sed -n "\$="
      ;;
    w)
      sed "s/ /\n/g" $filename | sed -ne "/^\$/! p" | sed -n "\$="
      ;;
    l)
      sed -n "\$=" $filename 
      ;;
    n)
      sed -ne "/^[[:digit:]][[:digit:]]*$/ p" $filename | sed -n "\$="
      ;;
    *)
      echo "ERROR"
      ;;
  esac
done
'
}

# 4

script() { 
sed -ne "/^[[:digit:]]/p" input.txt | sed -n "\$="
}

# 5

script() { awk '
BEGIN {
  getline n < "-";  
  sumodd=0;   
  sumeven=0;
  for(i=1;i<=n;i++) {
    if (i%2 == 1) {
      sumodd = sumodd + i;
    }
    else {
      sumeven = sumeven + i;
    }
  } 
  print sumodd;
  print sumeven;
}
' 
}

# 6

script() { echo '

BEGIN {
 FS = ",";
}
{
  a = $2
  b = $3
  if (a ~ item) {
    ans = b*n;
    print ans;
    exit;
  }
}

' > yourScript.awk
awk -v item=$1 -v n=$2 -f yourScript.awk groceries.csv
}

# 16/08/2023
# 1

script() {
read n
num="^-?[0-9]*\.?[0-9]*$"
neg="^-"
if [[ $n =~ $num ]]; then
  [[ $n =~ $neg ]] && echo NNUM || echo PNUM
else
  echo STRING
fi

}

# 2

script() {
egrep "\bFAILED LOGIN\b" myauth.log | wc -l
}

# 3

script() { 
sed -e '/^[[:digit:]]/s/delta/gamma/' input.txt
}

# 4

script() {
echo '
BEGIN {
  FS="," 
}
{
  if ($4 > max[$1]) {
    max[$1] = $4
    max_student[$1] = $2
  }
} 
END { 
  for (i in max_student) {
    print max_student[i]
  }
}
' > yourscript.awk
awk -f yourscript.awk data | sort
}

# 5

script() { awk '
{ 
  if(max < FNR) { 
    max=FNR; 
    f=FILENAME; 
  } 
}
END { print f; }
' file*.txt
}

# 6

script() { echo '
BEGIN{
  FS = ",";
}
{
  if (NR == 1)
  {
    lowc=int($3);
    count =0;
    name[count] = $2;
    next;
  }
  Name = $1;
  leave = $3;
  if (leave < lowc)
  {
    lowc = leave;
    delete name;
    count = 0;
    name[count] = $2;
  }
  else if (leave == lowc)
  {
    count++; name[count] = $2
  }
}

END{
  for (i=0; i<=count; i++)
  {
    print name[i];
  }
}
' > yourScript.awk
awk -f yourScript.awk EmployeeDetails.csv
}

# 17/08/2023
# 1

script() {
max=$1
min=$1

for i in "$@"; do
	if [ $i -ge $max ]; then
		max=$i
	fi
	if [ $i -le $min ]; then
		min=$i
	fi
done;

echo "Maximum: $max | Minimum: $min"
}

# 2

script() {
egrep "\bsu\b" myauth.log | grep -v FAILED | egrep "\(to .*\)" -o | egrep "\b\w*\b" -o | grep -v to 
}

# 3

script() { 
sed -e "/[[:alnum:]+](.*)[[:space:]]*{/i # START FUNCTION" \
    -e "/^[[:space:]]*}/a # END FUNCTION" functions.sh
}

# 4

dir=$RANDOM
while [ -a $dir ]; do dir=$RANDOM; done
mkdir $dir
cd $dir

cat >input.txt
sed '
s/^\([^:]*\):\([^:]*\)/\2:\1/
s/?$/!/
' input.txt 2>&1

# 5

script() {
awk -F, '{print $1}' marks.csv
}

# 6

eof="EOF"
while read file; do
  if [[ $file =~ $eof ]]; then
    break
  fi
  while read line; do
    if [[ $line =~ $eof ]]; then 
      break
    fi
    echo $line >>$file
  done
done
######### Driver code ends here

######### Script starts here
for file in *.c; do
  awk '


    BEGIN {
      flag=0;
    }

    {
      if (length($0)>50) flag=1;
    }

    END {
      if (flag==1) print FILENAME;
    }
  ' $file
done

# 18/08/2023
# 1

script() {
flag=0
number=$1
check=`echo "sqrt($number)" | bc`
for (( i=2; i<=check; i++ )); do
	if [ $((number%i)) -eq 0 ]; then
		flag=1
	fi
done
if [ $flag -eq 0 ]; then
	echo Yes
else
   echo No
fi
}

# 2

script() {
egrep "systemd-logind\[[0-9]+\]" myauth.log | grep user | cut -d " " -f 11 | cut -d "." -f 1 | sort | uniq
}

# 3

echo '
#!/usr/bin/sed -f
1 i\# Copyright IITM 2022
$ a\# Copyright IITM 2022
/[[:alnum:]+](.*)[[:space:]]*{/i\# START FUNCTION
/^[[:space:]]*}/a\# END FUNCTION
s/background_sleep/inactive_sleep/g
/\bactive_sleep/ i\# TODO:DEPRECATED
10~9 i\####
' | col > myscript.sed



# 4

dir=$RANDOM
while [ -a $dir ]; do dir=$RANDOM; done
mkdir $dir
cd $dir

cat >input.txt
sed '
s/sun/1/gI
s/mon/2/gI
s/tue/3/gI
s/wed/4/gI
s/thu/5/gI
s/fri/6/gI
s/sat/7/gI
s/!/./1
s/!/./2
' input.txt 2>&1

# 5

script() {
awk -F, 'length($0)>20{print $1}' marks.csv
}

# 6

script(){ echo '
BEGIN{  
	FS = ","
} 

{
	EID = $1
	Gender= $4
	if (Gender ~ /Female/) {
		print EID"@xyz.com"
        }
}
' >yourScript.awk
awk -f yourScript.awk EmployeeDetails.csv
}


