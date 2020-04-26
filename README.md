# WCP-Bookers_App_1

```
アプリケーションを作成してみよう：応用編
```

## バージョン
- Ruby version
    - 2.5.7
- Ruby on Rails version
    - 5.2.4.1

## 環境構築
- Vagrant(Mac) + VirtualBox(6.0.14)

- 「vagrant-vbguest」プラグインをインストール  
`$ vagrant plugin install vagrant-vbguest`

- Vagrantfileを設置

- Vagrantを起動  
`$ vagrant up`

- Vagrantを停止  
`$ vagrant halt`

※ マウントできないエラーが発生した場合  

```
「/sbin/mount.vboxsf: mounting failed with the error: No such device」
```

- 「kernel」のバージョンを確認  
`$ rpm -qa kernel\* | sort`

- バージョンが不一致であれば、下記コマンドを実行  

```
$ vagrant ssh
$ sudo yum -y update kernel
$ sudo yum -y install kernel-devel kernel-headers kernel-tools kernel-tools-libs
$ vagrant reload
```

- railsサーバー起動  
`$ rails s -b 0.0.0.0`

- 動作確認URL  
    - http://localhost:3000

## Scaffoldによる雛形作成手順

```
$ rails g scaffold Book title:string body:text
$ rake db:migrate
```

## deviseを使用したログイン機能作成
- Gemfileを更新  
```
[Gemfile]
gem 'devise'
gem 'refile', require: 'refile/rails', github: 'manfe/refile'
gem "refile-mini_magick"

$bundle install
```

- deviseインストール&Userモデル作成  

```
$ rails g devise:install
$ rails g devise User name:string introduction:text profile_image_id:text
$ rails g devise:views
※ ログイン以外の機能・画面を作成する場合
$ rails g controller users
```  

- devise設定ファイル修正  
    - 下記を追加  
    ```
    [application_controller.rb]

    protect_from_forgery with: :exception
    before_action :configure_permitted_parameters, if: :devise_controller?

    protected

    def configure_permitted_parameters
        added_attrs = [:email, :name, :password, :password_confirmation ]
        devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
        devise_parameter_sanitizer.permit :account_update, keys: added_attrs
        devise_parameter_sanitizer.permit :sign_in, keys: added_attrs
    end
    ```
    - 下記を修正  
    ```
    [devise.rb]
    # config.scoped_views = false [変更前]
    config.scoped_views = true　[変更後]
    ```

-  アクセス制限  
    - 対象ページのコンローラーに下記を追加  
    `before_action :authenticate_user!`

- 特定のカラムを指定したログイン設定  

```
[devise.rb]
config.authentication_keys = [:カラム名]
```

- ローカルサーバーを再起動  

## Refile

```
[application_controller_renderer.rb]
Refile.secret_key = 'xxxxxxx.....'
```

## Rspec

- テスト実行  
`$ bundle exec rspec spec/ --format documentation`
