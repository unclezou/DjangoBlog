
mkdir -p /home/dataset/notebook && \
    rm -rf /home/app/blog-server/notebook && \
    ln -sf /home/dataset/notebook /home/app/blog-server/ && \
    # cp -f /home/src/notebook/*.py /home/app/nlp/notebook/ && \
    # false | cp -i /home/src/notebook/*.ipynb /home/app/nlp/notebook/ > /dev/null 2>&1 && \
    echo "re-linked notebook"

jupyter notebook --ip=0.0.0.0 --allow-root > /home/jupyter.log 2>&1 &

exec "bash"