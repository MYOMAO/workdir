#Only restart the QC when you see the GUI not updating for more than 10 minutes

QCdir=/home/its/QC/workdir
Nowdir=$PWD


echo "WE are going to restart the QC now"


pkill qcRunSimple

#killalliamsureiknowwhatiamdoingandthatthereareotherusersonthispc -9 qcRunSimple


Run=$(echo `ls  $QCdir/infiles/ -Art | tail -n 1`)



if [ "$Run" != "" ];then
echo "Remove Run " $Run

rm -rf  $QCdir/infiles/$Run
fi


RunNum=$(echo `ls  $QCdir/ -Art | tail -n 1` | tr -dc '0-9')

RunNum=$((${RunNum}+1))


cd $QCdir

cd .. 

export ALIBUILD_WORK_DIR="$PWD/sw"

#alienv enter QualityControl/latest 

eval $(alienv load QualityControl/latest 2> /dev/null)

echo "New Run Number is " $RunNum

cd $QCdir

qcRunSimple > NewDay${RunNum}.log&

#exit

#cd /home/its/L0_shifters/ib-commissioning-tools/

cd $Nowdir

echo "QC has been restarted!!! Now reinject " $Run


