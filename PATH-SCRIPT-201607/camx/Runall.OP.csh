#!/bin/csh -f

set BEG_GTIME = $argv[1]
set END_GTIME = $argv[2]
set YYYY = `echo $BEG_GTIME | cut -c 1-4`
set MM   = `echo $BEG_GTIME | cut -c 5-6`
set DD   = `echo $BEG_GTIME | cut -c 7-8`
setenv HH  `echo $BEG_GTIME | cut -c 9-10`
set YYYY1 = `echo $END_GTIME | cut -c 1-4`
set MM1   = `echo $END_GTIME |cut -c 5-6`
set DD1   = `echo $END_GTIME |cut -c 7-8`

source setcase.whole.${HH}z.txt
source ../domains_def.config

set BEG_JDATE = `$CAMx_HOME/datelib/g2j $YYYY $MM $DD`
set END_JDATE = `$CAMx_HOME/datelib/g2j $YYYY1 $MM1 $DD1`
echo $BEG_JDATE $END_JDATE

##### Step 1 Prepare anthro emission for CAMx  ######
##### Run the convert program #####
###### Prepare icbc for CAMx #####
## Convert form CMAQ ###
#  cd $CMAQ2CAMx/work
#    csh -f conv_bcon_op.job $BEG_JDATE $END_JDATE
#    if ( $status != 0) then
#      echo "ERROR: Run conv_bcon_op.job failed"
#      echo "ERROR in step 1.2 CMAQBC2CAMx "
#      goto error
#    else
#      echo "end step 1.2 CMAQBC2CAMx"
#    endif
#    csh -f conv_icon_op.job $BEG_JDATE 
#    if ( $status != 0) then
#      echo "ERROR: Run conv_icon_op.job failed"
#      echo "ERROR in step 1.3 CMAQIC2CAMx "
#      goto error
#    else
#      echo "end step 1.3 CMAQIC2CAMx"
#    endif
#
###### Step 2 Prepare ahomap file for CAMx #########
#  cd $AHOMAP/work
#  set DOMAINS_GRID = 1
#  foreach DOMAINS_RES ($G_DOMAINS_RES)
#    csh -f $AHOMAP/work/ahomap.hk${HH}z.job $BEG_JDATE $END_JDATE $DOMAINS_GRID $DOMAINS_RES
#    @ DOMAINS_GRID ++
#  end
#  if ( $status != 0) then
#    echo "ERROR: Run ahomap.hk${HH}z.*.job failed"
#    echo "ERROR in step 3 AHOMAP"
#    goto error
#  else
#    echo "end step 3 AHOMAP"
#  endif
##
###### Step 3 Prepare tuv file for CAMx ############
#
#  cd $TUV
#  foreach DOMAINS_RES ($G_DOMAINS_RES)
#    csh -f tuv4.0_1.hkpath.job   $BEG_JDATE $END_JDATE $DOMAINS_RES
#  end
#  if ( $status != 0) then
#    echo "ERROR: Run tuv4.0_1.hkpath.*.job failed"
#    echo "ERROR in step 4 TUV"
#    goto error
#  else
#    echo "end step 4 TUV"
#  endif
## Step 4 Run CAMx of 27km ##################
  cd $CAMx_HOME/runfiles
    csh -f Runall.CAMx_v5.40.hkpath.MPI.csh $BEG_JDATE $END_JDATE
    if ( $status != 0) then
      echo "ERROR: Run Runall.CAMx_v5.40.hkpath.MPI.csh failed"
      echo "ERROR in step 5 CAMx"
      goto error
    else
      echo "end step 5 CAMx"
    endif

############
  echo "--------------> Successfully Finished <---------------"
  exit 0   

###=================Label to abort the script==================
   error:
     echo "$0 exit with ERROR"
     exit 1 
