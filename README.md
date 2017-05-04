# README
## How to create droplet on DIGITALOCEAN UBUNTU 16.04 with NGINX,
## PASSENGER, RUBY, POSTGRESQL and deploy with CAPISTRANO

1.  Создаем минимальный дроплет на digitalocean.com. /// Minimal Droplet creating

    1.1. Если не создавать ключ, то дроплет создается с паролем для `root`, который приходит на почту./// If you do not create a key, the droplet is created with a password for 'root', which comes to the e-mail

    1.2. Заходим по SSH с консоли локальной машины рутом. /// Enter by SSH from the console of the local machine as root.


```
    $ ssh root@droplet's_IP_address  # Подтверждаем пароль и меняем его на свой
                                     # Confirm the password and change it to your

    $ ssh-keygen  # Если нет ssh-ключа на локальной машине, то создаем его
                  # If there is no ssh-key on the local machine, then we create it

    $ls ~/.ssh/   # Появляются два файла в директории
                  # Two files appear in the directory
    id_rsa id_rsa.pub  # Содержание второго файла копируем на сервер при создании дроплета
                        # The content of the second file we copy to the server when creating the droplet
```
2. Создаем Линукс-пользователя и передаем ему права судо. /// Create a Linux-user and give it the rights of the sudo.

     2.1.
```
     ssh root@droplet's_IP_address

     $ dpkg-reconfigure locales # Для установки дополнительных языковых кодировок при необходимости
                                # To install additional language encodings if necessary
     ru-utf8                    # Space, Enter, Enter

```

    2.2. Создаем пользователя deploy. /// User deploy creating.

```
     $ adduser deploy
     $ adduser deploy sudo

```
     2.3. Hа локальной машине. /// On local.

```
     $ ssh-copy-id deploy@droplet's_IP_address
```


     2.4. Заходим под юзером deploy и все остальное делаем под ним
          Enter as deploy and do everything else under it

```
          $ ssh deploy@droplet's_IP_address
```

3. Установка rbenv и Ruby. /// Installing rbenv and Ruby.

    https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-with-rbenv-on-ubuntu-16-04)


    3.1. Обновляем пакеты и устанавливаем зависимости для rbenv и Ruby. /// Update the packages and install dependencies for rbenv and Ruby.

```
    $ sudo apt-get update
    $ sudo apt-get install autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev

```

    3.2. Устанавливаем rbenv. /// Installing rbenv.

```
    $ git clone https://github.com/rbenv/rbenv.git ~/.rbenv
    $ echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
    $ echo 'eval "$(rbenv init -)"' >> ~/.bashrc
    $ source ~/.bashrc
    $ type rbenv   # Проверяем наличие и вид установленного rbenv. Должны получить нижеследующий код:
                   # Check the presence and appearance of the installed rbenv. Should get the following code:

          rbenv is a function
      rbenv ()
      {
          local command;
          command="$1";
          if [ "$#" -gt 0 ]; then
              shift;
          fi;
          case "$command" in
              rehash | shell)
                  eval "$(rbenv "sh-$command" "$@")"
              ;;
              *)
                  command rbenv "$command" "$@"
              ;;
          esac
      }


     $ git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
                      # Установит плагин руби-билд для rbenv
                      # Install the Ruby build plug-in for rbenv

```


  3.3. Устанавливаем Ruby. /// Installing Ruby.

```
     $ rbenv install 2.3.3
     $ rbenv global 2.3.3  # Назначаем главной версией
                           # Assign the main version
     $ ruby -v  # Проверяем версию текущего Руби
                # Check the current version
     $ which ruby #Показывает директорию устаноленного Руби
     # Show the directory installed Ruby
       /home/deploy/.rbenv/shims/ruby
```

  3.4. Устанавливаем самый первый гем - gem bundle.
       Installing first gem - gem bundle.
```
     $ echo "gem: --no-document" > ~/.gemrc
     $ gem install bundler
```

4. Nginx and Passenger

   https://nginx.org/ru/

   https://www.phusionpassenger.com/

   https://www.phusionpassenger.com/library/install/nginx/install/oss/xenial/ - пошаговая установка Nginx-Passenger (Nginx-Passenger step-by-step installation)

4.1. Установка. /// Installing Passenger + Nginx

```
        # Install our PGP key and add HTTPS support for APT
        $ sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
        $ sudo apt-get install -y apt-transport-https ca-certificates

        # Add our APT repository
        $ sudo sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger xenial main > /etc/apt/sources.list.d/passenger.list'
        $ sudo apt-get update

        # Install Passenger + Nginx
        $ sudo apt-get install -y nginx-extras passenger

```

4.2. Редактируем файл. /// Change the file.  /etc/nginx/nginx.conf


```
         $ sudo vi /etc/nginx/nginx.conf

         include /etc/nginx/passenger.conf;  # Найти и раскоментировать эту строку
                                             # Find end uncomment this line
                                             # Если такой строки нет, то надо вписать ее самостоятельно.
                                             # If there is no such line, then you must enter it yourself.
```


4.2.1. Если вы собираетесь загружать файлы (картинки, видео), то необходимо прописать максимальную
величину загружаемого файла в том же файле. /// If you are going to upload files (pictures, video),
you need to set the maximum value of the downloaded file in the same file /etc/nginx/nginx.conf

```
          $ sudo vi /etc/nginx/nginx.conf
              http{...
                 client_max_body_size 8M;
              ....}

```

 4.3. Редактируем файл. /// Change the file  /etc/nginx/passenger.conf

```
         $ sudo vi /etc/nginx/passenger.conf  # Во второй строчке прписываем путь к установленному руби
                                              # (узнать путь можно командой $ which ruby)
                                              # In the second line, we write the path to the established ruby
                                              # (you can find out the path by the $ which ruby command)


           passenger_root /usr/lib/ruby/vendor_ruby/phusion_passenger/locations.ini;
           passenger_ruby /home/deploy/.rbenv/shims/ruby;

```

 4.5. Настраиваем порт 80 nginx для нашего сайта. /// Configure port 80 nginx for our site

            Создаем и заходим в файл: /// Create and enter the file:
```
         $ sudo vi /etc/nginx/sites-available/my-site  # Копируем, заменяя pet-movie на название своего приложения
                                                       # Copy by replacing the 'pet-movie' with the name of your application


                    server {
            listen 80 default_server;
            listen [::]:80 default_server ipv6only=on;

            server_name  my_domain.com;

            access_log  /var/log/nginx/my-site.access.log;
            error_log   /var/log/nginx/my-site.error.log;

            passenger_enabled on;
            rails_env production;
            root /home/deploy/pet-movie/current/public;
          }

```

4.6. Создаем символьную ссылку с этого файла на файл /etc/nginx/sites-enabled/my-site. /// Create a symlink from this file to the file /etc/nginx/sites-enabled/my-site


```
           $ sudo ln -s /etc/nginx/sites-available/my-site  /etc/nginx/sites-enabled/my-site

```

4.7. Удаляем файл./// Remove file /etc/nginx/sites-enabled/default.

4.8. Создаем директорию: /// Create directory:

```
       $ mkdir -p pet-movie/current/public  # Перед первым деплоем с Капистрано эту папку надо будет удалить!!!
                                                    # Before your first deploy with Capistrano this folder will have to be deleted!

```

            Создаем файл: /// Create file:

```
               $ echo 'Helo World!' > pet-movie/current/public/index.html

```

4.9. Перезагружаем сервер. /// Restart server.

```
           $ sudo service nginx restart

```

## Hello World!



5. Postgresql install

```
    $ sudo apt-get install postgresql postgresql-contrib libpq-dev
    $ sudo su - postgres
    $ createuser --pwprompt deploy
    $ createdb -O deploy pet-movie_production
    $\q

```


6. Капистрано и деплой на сервер. /// Capistrano and deploy on server.


6.1. Gemfile

```
    group :development do
        gem 'capistrano', '~> 3.7', '>= 3.7.1'
        gem 'capistrano-rails', '~> 1.2'
        gem 'capistrano-passenger', '~> 0.2.0'

        # Add this if you're using rbenv
        # gem 'capistrano-rbenv', '~> 2.1'
    end


        $ bundle install
        $ bundle --binstubs
        $ cap install STAGES=production
```

6.2.  Capfile

```
    require 'capistrano/rails'
    require 'capistrano/passenger'

    # If you are using rbenv add these lines:
    # require 'capistrano/rbenv'
    # set :rbenv_type, :user
    # set :rbenv_ruby, '2.4.0'

    # If you are using rvm add these lines:
    # require 'capistrano/rvm'
    # set :rvm_type, :user
    # set :rvm_ruby_version, '2.4.0'

```

6.3 In config/deploy.rb

```
    set :application, "pet-movie" # Название своего приложения
                                  # Your application name
    set :repo_url, "git@bitbucket.org:AllaJohnson/pet-movie.git" # Адрес своего репо
                                                                  #Your repo url
    # Default value for :linked_files is []
    append :linked_files, "config/database.yml", "config/secrets.yml", "config/aws.yml"

    # Default value for linked_dirs is []
    append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

```

6.4 In config/deploy/production.rb

```
    set :stage, :production
    # Replace 'droplet's_IP_address' with your server's IP address!
    server 'droplet's_IP_address', user: 'deploy', roles: %w{app db web}

```


7. Первый деплой провалиться, так как нет файлов  database.yml, secrets.yml. /// The first deploy will be failed, because there are no files database.yml, secrets.yml on your production app

    Создаем файлы /// Create files on production:

```
    /home/deploy/pet-movie/shims/config/database.yml,
    /home/deploy/pet-movie/shims/config/secrets.yml.

```

7.1    database.yml

```
            production:
               adapter: postegresql
               database: my_DB_name
               username: deploy
               password: password

```
7.2 secrets.yml

```
        $ rake secret # Генерируем секретный ключ на локальной машине копируем и вставляем в этот файл
                      # Generate the secret key on the local machine copy and paste into  secrets.yml:


        production:
          secret_key_base: 12325467tugjbmn.m;jhjhvfgdfdxfc vb..........................

```

    Если иcпользуем AWS S3 как хранилище (If you use AWS S3 as a storage)

```
    /home/deploy/pet-movie/shims/config/aws.yml

```
7.3 aws.yml

```
        development:
          bucket: 'your_S3_bucket'
          access_key_id: 'your access_key__id on S3'
          secret_access_key: 'your secret_access_key on S3'
          s3_region: 'your region' (strong required for last version Paperclip only)

        production:
          bucket: 'your_S3_bucket'
          access_key_id: 'your access_key__id on S3'
          secret_access_key: 'your secret_access_key on S3'
          s3_region: 'your region' (strong required for last version Paperclip only)

```

  8. Additional soft install on VPS DO:
     - NodeJs
     - ImageMagik

     additional gems in Gemfile

```
     gem 'paperclip'
     gem 'paperclip-av-transcoder'
     gem 'will_paginate', '~> 3.1', '>= 3.1.5'
     gem 'aws-sdk', "> 2"

```
