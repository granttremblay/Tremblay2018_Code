#!/bin/sh

# I am only including this as an example. This download script is based upon an 
# ESO archive request that I made under my ESO User Portal Account, and will probably 
# not work for you. 

# To download the MUSE data, you should instead go to archive.eso.org --> Raw Data --> 
# search "Abell 2597" with "MUSE" selected under "Instruments". You should make sure 
# to select "Associated raw calibration files" when you're setting up your download. 

usage () {
    cat <<__EOF__
usage: $(basename $0) [-hlp] [-u user] [-X args] [-d args]
  -h        print this help text
  -l        print list of files to download
  -p        prompt for password
  -u user   download as a different user
  -X args   extra arguments to pass to xargs
  -d args   extra arguments to pass to the download program

__EOF__
}

username=gtremblay
xargsopts=
prompt=
list=
while getopts hlpu:xX:d: option
do
    case $option in
    h)  usage; exit ;;
    l)  list=yes ;;
    p)  prompt=yes ;;
    u)  prompt=yes; username="$OPTARG" ;;
    X)  xargsopts="$OPTARG" ;;
    d)  download_opts="$OPTARG";;
    ?)  usage; exit 2 ;;
    esac
done

if test -z "$xargsopts"
then
   #no xargs option speficied, we ensure that only one url
   #after the other will be used
   xargsopts='-L 1'
fi

if [ "$prompt" != "yes" ]; then
   # take password (and user) from netrc if no -p option
   if test -f "$HOME/.netrc" -a -r "$HOME/.netrc"
   then
      grep -ir "dataportal.eso.org" "$HOME/.netrc" > /dev/null
      if [ $? -ne 0 ]; then
         #no entry for dataportal.eso.org, user is prompted for password
         echo "A .netrc is available but there is no entry for dataportal.eso.org, add an entry as follows if you want to use it:"
         echo "machine dataportal.eso.org login gtremblay password _yourpassword_"
         prompt="yes"
      fi
   else
      prompt="yes"
   fi
fi

if test -n "$prompt" -a -z "$list"
then
    trap 'stty echo 2>/dev/null; echo "Cancelled."; exit 1' INT HUP TERM
    stty -echo 2>/dev/null
    printf 'Password: '
    read password
    echo ''
    stty echo 2>/dev/null
fi

# use a tempfile to which only user has access 
tempfile=`mktemp /tmp/dl.XXXXXXXX 2>/dev/null`
test "$tempfile" -a -f $tempfile || {
    tempfile=/tmp/dl.$$
    ( umask 077 && : >$tempfile )
}
trap 'rm -f $tempfile' EXIT INT HUP TERM

echo "auth_no_challenge=on" > $tempfile
# older OSs do not seem to include the required CA certificates for ESO
echo "check-certificate=off"  >> $tempfile
if [ -n "$prompt" ]; then
   echo "--http-user=$username" >> $tempfile
   echo "--http-password=$password" >> $tempfile

fi
WGETRC=$tempfile; export WGETRC

unset password

if test -n "$list"
then cat
else xargs $xargsopts wget $download_opts 
fi <<'__EOF__'
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-11T10:12:26.254/MUSE.2014-10-11T10:12:26.254.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-11T10:14:32.277/MUSE.2014-10-11T10:14:32.277.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-08T09:04:03.151/MUSE.2014-10-08T09:04:03.151.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-08T09:11:28.152/MUSE.2014-10-08T09:11:28.152.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-08T08:47:30.196/MUSE.2014-10-08T08:47:30.196.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-11T06:46:32.304/MUSE.2014-10-11T06:46:32.304.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-11T10:06:56.281/MUSE.2014-10-11T10:06:56.281.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-11T04:20:56.824/MUSE.2014-10-11T04:20:56.824.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-07T22:22:32.703/MUSE.2014-10-07T22:22:32.703.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-11T10:08:17.279/MUSE.2014-10-11T10:08:17.279.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/M.MUSE.2014-12-08T12:55:43.846/M.MUSE.2014-12-08T12:55:43.846.fits" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-11T09:28:20.007/MUSE.2014-10-11T09:28:20.007.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-08T08:53:36.152/MUSE.2014-10-08T08:53:36.152.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-11T03:03:26.659.NL/MUSE.2014-10-11T03:03:26.659.NL.txt" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-08T08:56:44.151/MUSE.2014-10-08T08:56:44.151.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-11T06:45:35.145/MUSE.2014-10-11T06:45:35.145.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-28T09:22:19.951/MUSE.2014-10-28T09:22:19.951.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-11T09:25:29.032/MUSE.2014-10-11T09:25:29.032.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/M.MUSE.2014-06-13T10:14:20.005/M.MUSE.2014-06-13T10:14:20.005.fits" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/STAGING/MUSE.2014-10-11T02:46:56.044.AT/MUSE.2014-10-11T02:46:56.044.xml" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-08T09:24:45.730/MUSE.2014-10-08T09:24:45.730.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/M.MUSE.2014-08-27T12:50:13.527/M.MUSE.2014-08-27T12:50:13.527.fits" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-11T02:46:56.044.NL/MUSE.2014-10-11T02:46:56.044.NL.txt" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-28T09:28:01.498/MUSE.2014-10-28T09:28:01.498.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-11T09:33:05.371/MUSE.2014-10-11T09:33:05.371.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-07T22:27:51.295/MUSE.2014-10-07T22:27:51.295.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-28T16:50:17.494/MUSE.2014-10-28T16:50:17.494.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/M.MUSE.2014-09-23T09:57:52.696/M.MUSE.2014-09-23T09:57:52.696.fits" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-11T10:15:35.279/MUSE.2014-10-11T10:15:35.279.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-11T09:30:14.207/MUSE.2014-10-11T09:30:14.207.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-11T02:28:44.629.NL/MUSE.2014-10-11T02:28:44.629.NL.txt" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-28T15:48:23.315/MUSE.2014-10-28T15:48:23.315.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-11T10:10:59.479/MUSE.2014-10-11T10:10:59.479.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-08T09:22:39.948/MUSE.2014-10-08T09:22:39.948.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/M.MUSE.2014-12-02T10:49:18.173/M.MUSE.2014-12-02T10:49:18.173.fits" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-28T09:28:58.281/MUSE.2014-10-28T09:28:58.281.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-08T08:40:51.602/MUSE.2014-10-08T08:40:51.602.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-08T09:20:34.153/MUSE.2014-10-08T09:20:34.153.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-11T03:03:26.659/MUSE.2014-10-11T03:03:26.659.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-08T08:41:48.575/MUSE.2014-10-08T08:41:48.575.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-08T08:39:54.796/MUSE.2014-10-08T08:39:54.796.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-08T09:10:25.091/MUSE.2014-10-08T09:10:25.091.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-08T09:19:05.387/MUSE.2014-10-08T09:19:05.387.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-08T08:44:39.265/MUSE.2014-10-08T08:44:39.265.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-11T10:03:25.279/MUSE.2014-10-11T10:03:25.279.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-11T09:54:59.164/MUSE.2014-10-11T09:54:59.164.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-28T09:23:16.742/MUSE.2014-10-28T09:23:16.742.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-28T09:24:13.742/MUSE.2014-10-28T09:24:13.742.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-11T10:16:38.437/MUSE.2014-10-11T10:16:38.437.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-11T06:51:17.400/MUSE.2014-10-11T06:51:17.400.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/STAGING/MUSE.2014-10-11T03:03:26.659.AT/MUSE.2014-10-11T03:03:26.659.xml" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-28T09:29:55.052/MUSE.2014-10-28T09:29:55.052.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-11T02:46:56.044/MUSE.2014-10-11T02:46:56.044.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-11T09:51:51.953/MUSE.2014-10-11T09:51:51.953.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-28T17:21:14.867/MUSE.2014-10-28T17:21:14.867.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-08T09:23:42.895/MUSE.2014-10-08T09:23:42.895.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-08T09:13:41.324/MUSE.2014-10-08T09:13:41.324.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-07T21:29:34.827/MUSE.2014-10-07T21:29:34.827.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-08T09:03:00.106/MUSE.2014-10-08T09:03:00.106.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-11T09:46:39.428/MUSE.2014-10-11T09:46:39.428.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/STAGING/MUSE.2014-10-11T02:30:24.496.AT/MUSE.2014-10-11T02:30:24.496.xml" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/M.MUSE.2014-12-08T12:55:33.180/M.MUSE.2014-12-08T12:55:33.180.fits" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-28T16:19:20.480/MUSE.2014-10-28T16:19:20.480.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/M.MUSE.2014-06-13T10:14:59.795/M.MUSE.2014-06-13T10:14:59.795.fits" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-11T10:09:38.454/MUSE.2014-10-11T10:09:38.454.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-08T08:42:45.372/MUSE.2014-10-08T08:42:45.372.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-08T09:16:23.390/MUSE.2014-10-08T09:16:23.390.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-11T09:29:17.130/MUSE.2014-10-11T09:29:17.130.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-28T09:27:04.566/MUSE.2014-10-28T09:27:04.566.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-08T08:43:42.178/MUSE.2014-10-08T08:43:42.178.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-08T09:21:36.954/MUSE.2014-10-08T09:21:36.954.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-07T22:25:43.961/MUSE.2014-10-07T22:25:43.961.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-08T08:45:36.398/MUSE.2014-10-08T08:45:36.398.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-08T08:59:52.094/MUSE.2014-10-08T08:59:52.094.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-07T22:24:40.473/MUSE.2014-10-07T22:24:40.473.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-11T09:26:26.131/MUSE.2014-10-11T09:26:26.131.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-08T08:48:27.038/MUSE.2014-10-08T08:48:27.038.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-11T10:02:22.529/MUSE.2014-10-11T10:02:22.529.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-11T09:53:56.850/MUSE.2014-10-11T09:53:56.850.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-11T06:52:14.684/MUSE.2014-10-11T06:52:14.684.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-11T09:27:22.917/MUSE.2014-10-11T09:27:22.917.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/STAGING/MUSE.2014-10-11T02:28:44.629.AT/MUSE.2014-10-11T02:28:44.629.xml" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-11T06:49:23.186/MUSE.2014-10-11T06:49:23.186.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-08T08:46:33.296/MUSE.2014-10-08T08:46:33.296.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-11T06:47:29.296/MUSE.2014-10-11T06:47:29.296.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-11T09:34:02.023/MUSE.2014-10-11T09:34:02.023.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-08T09:17:44.384/MUSE.2014-10-08T09:17:44.384.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-11T10:05:35.281/MUSE.2014-10-11T10:05:35.281.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-08T08:38:57.855/MUSE.2014-10-08T08:38:57.855.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-08T09:09:22.308/MUSE.2014-10-08T09:09:22.308.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-07T22:23:36.727/MUSE.2014-10-07T22:23:36.727.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/M.MUSE.2014-10-24T09:30:19.546/M.MUSE.2014-10-24T09:30:19.546.fits" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-08T08:54:38.896/MUSE.2014-10-08T08:54:38.896.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-11T06:48:26.106/MUSE.2014-10-11T06:48:26.106.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-11T09:31:11.205/MUSE.2014-10-11T09:31:11.205.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-11T09:50:49.705/MUSE.2014-10-11T09:50:49.705.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/M.MUSE.2016-10-21T12:14:54.596/M.MUSE.2016-10-21T12:14:54.596.fits" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-28T09:26:07.842/MUSE.2014-10-28T09:26:07.842.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/M.MUSE.2014-12-08T12:30:51.293/M.MUSE.2014-12-08T12:30:51.293.fits" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-11T06:50:20.295/MUSE.2014-10-11T06:50:20.295.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-08T08:57:46.683/MUSE.2014-10-08T08:57:46.683.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-08T09:12:30.927/MUSE.2014-10-08T09:12:30.927.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-28T09:20:26.255/MUSE.2014-10-28T09:20:26.255.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-08T09:00:54.950/MUSE.2014-10-08T09:00:54.950.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/M.MUSE.2014-06-13T10:15:21.400/M.MUSE.2014-06-13T10:15:21.400.fits" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-11T06:44:37.995/MUSE.2014-10-11T06:44:37.995.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-11T09:49:47.085/MUSE.2014-10-11T09:49:47.085.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-11T09:56:01.455/MUSE.2014-10-11T09:56:01.455.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-08T09:08:19.654/MUSE.2014-10-08T09:08:19.654.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-11T09:24:32.006/MUSE.2014-10-11T09:24:32.006.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-07T22:28:55.080/MUSE.2014-10-07T22:28:55.080.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/M.MUSE.2014-09-23T09:50:01.446/M.MUSE.2014-09-23T09:50:01.446.fits" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-07T22:29:58.832/MUSE.2014-10-07T22:29:58.832.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-28T15:17:26.021/MUSE.2014-10-28T15:17:26.021.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-07T22:26:47.495/MUSE.2014-10-07T22:26:47.495.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-08T09:15:02.152/MUSE.2014-10-08T09:15:02.152.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-28T09:25:10.492/MUSE.2014-10-28T09:25:10.492.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-11T10:04:27.960/MUSE.2014-10-11T10:04:27.960.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-28T09:21:23.117/MUSE.2014-10-28T09:21:23.117.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-08T09:01:57.561/MUSE.2014-10-08T09:01:57.561.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-11T02:30:24.496.NL/MUSE.2014-10-11T02:30:24.496.NL.txt" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-11T06:42:44.012/MUSE.2014-10-11T06:42:44.012.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-11T06:43:40.985/MUSE.2014-10-11T06:43:40.985.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-08T08:58:49.381/MUSE.2014-10-08T08:58:49.381.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-11T04:23:03.488/MUSE.2014-10-11T04:23:03.488.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-11T09:48:44.694/MUSE.2014-10-11T09:48:44.694.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-11T09:32:08.201/MUSE.2014-10-11T09:32:08.201.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-11T10:13:29.183/MUSE.2014-10-11T10:13:29.183.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-11T09:45:36.744/MUSE.2014-10-11T09:45:36.744.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-11T02:30:24.496/MUSE.2014-10-11T02:30:24.496.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-11T10:01:19.735/MUSE.2014-10-11T10:01:19.735.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-11T02:28:44.629/MUSE.2014-10-11T02:28:44.629.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-11T09:47:42.249/MUSE.2014-10-11T09:47:42.249.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-08T08:55:41.591/MUSE.2014-10-08T08:55:41.591.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-11T09:52:54.280/MUSE.2014-10-11T09:52:54.280.fits.fz" -P data_with_raw_calibs
"https://dataportal.eso.org/dataPortal/api/requests/gtremblay/346991/SAF/MUSE.2014-10-11T10:00:16.673/MUSE.2014-10-11T10:00:16.673.fits.fz" -P data_with_raw_calibs

__EOF__
