#!/bin/bash

# Path to ADL executables (CreatePA, ...) must be set in $PATH

scriptpath=$(pwd)
file=ConfigFiles/ICOAX.txt
file2=DepletionVoltageRecord.txt

##############################
# DETECTOR GEOMETRY PARAMETERS
# Units = cm

# GridSize
gz=0.05

# Groove width
GW=( 0.30 )
# Groove depth
GD=( 0.30 )
# Groove inner radius
GR=( 0.8 1.0 )

# Point contact radius
#PC=( 0.8 1.0 )

# Well depth
WD=( 5.00 5.50 6.00 )
# Well radius
WR=( 0.5 )
# Inner tapering angle
TA=( 0 )

# Detector radius
DR=( 4.00 )
# Detector height
DH=( 9.00 )

# Dead layer thickness
DL=( 0.10 )

# Impurity concentration
declare -a imptop=( 1.00 ) #Full slice
declare -a impbot=( 1.50 ) #Full slice

#############################

declare -i iter
iter=0

#echo "Setting imp. cc. top"
TEXTE1=$( cat ${file} | grep "ICOAX_G_ImpTop" )
TEXTE2="ICOAX_G_ImpTop                   -${imptop[${iter}]} ! Top impurity concentration"
sed -i -e "s/${TEXTE1}/${TEXTE2}/" ${file} # change top imp. cc. value in file

#echo "Setting imp. cc. bot"
TEXTE1=$( cat ${file} | grep "ICOAX_G_ImpBot" )
TEXTE2="ICOAX_G_ImpBot                   -${impbot[${iter}]} ! Bottom impurity concentration"
sed -i -e "s/${TEXTE1}/${TEXTE2}/" ${file} # change bottom imp. cc. value in file

#echo "Setting det. height"
for dh in ${DH[@]} #Loop over groove inner radius
do
    TEXTE1=$( cat ${file} | grep "ICOAX_G_Height" )
    TEXTE2="ICOAX_G_Height                   ${dh} ! Heigth of the crystal"
    sed -i -e "s/${TEXTE1}/${TEXTE2}/" ${file} # change well radius value in file

#echo "Setting det. radius"
for dr in ${DR[@]} #Loop over groove inner radius
do
    TEXTE1=$( cat ${file} | grep "ICOAX_G_Radius" )
    TEXTE2="ICOAX_G_Radius                    ${dr} ! Radius of the crystal"
    sed -i -e "s/${TEXTE1}/${TEXTE2}/" ${file} # change well radius value in file
    
    #echo "Setting groove radius"
    for gr in ${GR[@]} #Loop over groove inner radius
    do
	TEXTE1=$( cat ${file} | grep "ICOAX_G_GrooveInnerRadius" )
	TEXTE2="ICOAX_G_GrooveInnerRadius          ${gr} ! usually = POINT_CONTACT_RADIUS"
	sed -i -e "s/${TEXTE1}/${TEXTE2}/" ${file} # change inner groove radius value in file

	#echo "Setting groove width"
	for gw in ${GW[@]} #Loop over groove width
	do
		TEXTE1=$( cat ${file} | grep "ICOAX_G_GrooveWidth" )
		TEXTE2="ICOAX_G_GrooveWidth               ${gw} ! Width of the groove"
		sed -i -e "s/${TEXTE1}/${TEXTE2}/" ${file} # change inner groove radius value in file

	#echo "Setting groove depth"
	for gd in ${GD[@]} #Loop over groove depth
	do
		TEXTE1=$( cat ${file} | grep "ICOAX_G_GrooveDepth" )
		TEXTE2="ICOAX_G_GrooveDepth               ${gd} ! Depth of the groove"
		sed -i -e "s/${TEXTE1}/${TEXTE2}/" ${file} # change inner groove radius value in file

	#echo "Setting well radius"
	for wr in ${WR[@]} #Loop over well radius
	do
		TEXTE1=$( cat ${file} | grep "ICOAX_G_WellRadius " )
		TEXTE2="ICOAX_G_WellRadius               ${wr} ! well radius"
		sed -i -e "s/${TEXTE1}/${TEXTE2}/" ${file} # change well radius value in file

	#echo "Setting tapering angle"
	for ta in ${TA[@]} #Loop over inner tapering angle
	do
		wrt=$( echo ${wd} 0.5 ${theta} | awk '{printf "%01.2f",($1-$2)*sin($3*3.14159/180)/cos($3*3.14159/180)}' )
		wrt=$( echo ${wrt} 0.5 | awk '{printf "%01.2f",$1+$2}' )

		TEXTE1=$( cat ${file} | grep "ICOAX_G_WellRadiusTop" )
		TEXTE2="ICOAX_G_WellRadiusTop             ${wrt} ! Top well radius"
		sed -i -e "s/${TEXTE1}/${TEXTE2}/" ${file} # change top well radius value in file

	#echo "Setting well depth"
	for wd in ${WD[@]} #Loop over well depth
	do
		TEXTE1=$( cat ${file} | grep "ICOAX_G_WellDepth" )
		TEXTE2="ICOAX_G_WellDepth                   ${wd} ! Well depth"
		sed -i -e "s/${TEXTE1}/${TEXTE2}/" ${file} # change well depth value in file

	#echo "Setting point contact"
#	for pc in ${PC[@]} #Loop over loop over point radius
#	do
		TEXTE1=$( cat ${file} | grep "ICOAX_G_PointContactRadius" )
		TEXTE2="ICOAX_G_PointContactRadius          ${gr} ! Point contact radius <= Groove radius"
		sed -i -e "s/${TEXTE1}/${TEXTE2}/" ${file} # change point contact value in file


		# Tranform 'cm' to 'mm' for keeping precision in file name extension
		Radius=$( echo 10 ${dr}  | awk '{printf "%02.0f",$1*$2}' )
		Height=$( echo 10 ${dh}  | awk '{printf "%02.0f",$1*$2}' )

		GrooveR=$( echo 10 ${gr}  | awk '{printf "%02.0f",$1*$2}' )
		GrooveD=$( echo 10 ${gd}  | awk '{printf "%02.0f",$1*$2}' )
		GrooveW=$( echo 10 ${gw}  | awk '{printf "%02.0f",$1*$2}' )

		WellR=$(   echo 10 ${wr}  | awk '{printf "%02.0f",$1*$2}' )
		WellRT=$(  echo 10 ${wrt} | awk '{printf "%02.0f",$1*$2}' )
		WellD=$(   echo 10 ${wd}  | awk '{printf "%02.0f",$1*$2}' )

		PointC=$(  echo 10 ${gr}  | awk '{printf "%02.0f",$1*$2}' )

		if [ $1 == "DV" ];
		then
		    mv ./ICOAX_Stru_*_${Radius}_${Height}_${GrooveR}_${GrooveD}_${GrooveW}_${WellR}_${WellRT}_${WellD}_${PointC}.pa ICOAX_Stru.pa
       		    mv ./ICOAX_Epot_*_${Radius}_${Height}_${GrooveR}_${GrooveD}_${GrooveW}_${WellR}_${WellRT}_${WellD}_${PointC}.pa ICOAX_Epot.pa
		    mv ./ICOAX_Wpot_*_${Radius}_${Height}_${GrooveR}_${GrooveD}_${GrooveW}_${WellR}_${WellRT}_${WellD}_${PointC}.pa ICOAX_Wpot.pa

		    DepletionVoltage ${file} ${Radius} ${Height} ${GrooveR} ${GrooveD} ${GrooveW} ${WellR} ${WellRT} ${WellD} ${PointC}  # Display depletion voltage
		else
       		    if [ $1 == 1 ]
       		    then
       			VOLT=$( cat ${file2} | grep "${GrooveR}_${GrooveD}_${GrooveW}_${WellR}_${WellRT}_${WellD}_${PointC}" )
       			volt=$(echo "${VOLT#* }")
       	  		volt=$( echo 500 ${volt} | awk '{printf "%05.0f",$1+$2}' )

			TEXTE1=$( cat ${file} | grep "SIMION_G_GridSize" )
			TEXTE2="SIMION_G_GridSize                 ${gz} ! High voltage"

			sed -i -e "s/${TEXTE1}/${TEXTE2}/" ${file} # change bottom imp. cc. value in file

		    elif [ $1 == 2 ];
		    then
			VOLT=$( cat ${file2} | grep "${Radius}_${Height}_${GrooveR}_${GrooveD}_${GrooveW}_${WellR}_${WellRT}_${WellD}_${PointC}" )
			volt=$(echo "${VOLT#* }")
			volt=$( echo 1000 ${volt} | awk '{printf "%05.0f",$1+$2}' )

			TEXTE1=$( cat ${file} | grep "SIMION_G_GridSize" )
			TEXTE2="SIMION_G_GridSize                 ${gz} ! High voltage"

			sed -i -e "s/${TEXTE1}/${TEXTE2}/" ${file} # change bottom imp. cc. value in file
		    elif [ $1 == 3 ];
		    then
			VOLT=$( cat ${file2} | grep "${Radius}_${Height}_${GrooveR}_${GrooveD}_${GrooveW}_${WellR}_${WellRT}_${WellD}_${PointC}" )
			volt=$(echo "${VOLT#* }")
			volt=$( echo 1500 ${volt} | awk '{printf "%05.0f",$1+$2}' )

			TEXTE1=$( cat ${file} | grep "SIMION_G_GridSize" )
			TEXTE2="SIMION_G_GridSize                 ${gz} ! High voltage"

			sed -i -e "s/${TEXTE1}/${TEXTE2}/" ${file} # change bottom imp. cc. value in file
		    else
       			volt=1

       			TEXTE1=$( cat ${file} | grep "SIMION_G_GridSize" )
			TEXTE2="SIMION_G_GridSize                 ${gz} ! High voltage"

			sed -i -e "s/${TEXTE1}/${TEXTE2}/" ${file} # change bottom imp. cc. value in file
       		    fi

		    echo ${volt} ${dr} ${dh} ${gr} ${gw} ${gd} ${wr} ${wrt} ${wd} ${pc}

		    TEXTE1=$( cat ${file} | grep "SIMION_G_Voltage" )
       		    TEXTE2="SIMION_G_Voltage                 ${volt} ! High voltage"

       		    sed -i -e "s/${TEXTE1}/${TEXTE2}/" ${file} # change bottom imp. cc. value in file

		    CreatePA ${file} ${volt} ${Radius} ${Height} ${GrooveR} ${GrooveD} ${GrooveW} ${WellR} ${WellRT} ${WellD} ${PointC} # Create Stru/Wpot/Epot PA files
		fi
#	done
	done
	done
	done
	done
	done
    done
done
done