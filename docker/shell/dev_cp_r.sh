cp_r.sh /home/src /link-src

# notebook目录.py文件覆盖, .ipynb不覆盖
mkdir -p /home/dataset/notebook && \
rm -rf /link-src/notebook && \
ln -sf /home/dataset/notebook /link-src/ && \
cp -f /home/src/notebook/*.py /link-src/notebook/ && \
false | cp -i /home/src/notebook/*.ipynb /link-src/notebook/ > /dev/null 2>&1 && \
echo "re-linked notebook"