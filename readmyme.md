

docker run --rm -it -p 8000:8000 -v D:\WorkSpace\Exercise\DjangoBlog:/home/blog-server -w /home/blog-server zouweidong73/blog-run-py:prod bash

python manage.py makemigrations
python manage.py migrate

python manage.py runserver 0.0.0.0:8000