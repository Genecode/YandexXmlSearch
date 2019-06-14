## Описание
Тестовая программа, которая отправляет запрос на поиск  по ключевому слову  на yandex.ru (через xmlproxy.ru). Далее из полученного XML выбираются топ 10 URL, по которым собирается Alexa Global Rank. Полученный результат, отсортированный по убыванию значения Rank,  сохраняется в файле output.csv

Версия 0.0.1 

### Ruby 
```
ruby 2.5
```

### Подготовка
```
gem install bundler
bundle install
```

Далее создайте файл config.yml с аутентификационными данными aws, xmlproxy.ru
```yaml
:alexa:
  :access_key_id: "тыц"
  :secret_access_key: "тыц"
:xmlproxy:
  :user: "тыц"
  :key: "тыц"

```
### Запуск
```
ruby main.rb
```