if [ -d /.old_folder ]
then
    echo '/.old_folder exists, maybe another thread is running.'
    exit 1
fi

echo "Start copy replace "`date`
mkdir -p /.old_folder

mv $2/* /.old_folder/ -f

cp $1/* $2/ -rf

rm -rf /.old_folder
echo "End copy replace "`date`