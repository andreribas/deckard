# Deckard

> "Stay awhile and listen!!" - Deckard Cain
>
> ![deckard-cain](https://user-images.githubusercontent.com/605008/67953228-761d2600-fbcd-11e9-8f77-67d52401e377.png)

Tool that helps to automate scrum reporting

## Usage

Copy the file `config.secret.sample.exs` to `config.secret.exs` and fill the github and trello credentials.

Github token: https://github.com/settings/tokens
The token must have all `repo` permissions

Trello: https://trello.com/app-key
Copy the key and then click in `manually generate a Token`

edit dates in `lib/main.ex`


```./run.sh```

```Deckard.Main.execute("2019-11-04", "2019-11-08")```
