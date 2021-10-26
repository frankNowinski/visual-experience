## About

Visual Experience is a simple Rails app that loosely mimics Movable Ink's Visual Experiences platform. There is only one available view for this app, `campaigns#show`. Here, you can view a Campaign along with it's associated assets and criteria as well as duplicate a Campaign. 

## Getting Started

First, clone the repo to your local computer

```
git clone https://github.com/frankNowinski/visual-experience.git
```

Then, `cd` into the `visual-experience` directory and run `bundle`

Now you can create the `db`

```
bundle exec rake db:create
```
Run the migrations
```
bundle exec rake db:migrate
```
And populate the `db` with seed data
```
bundle exec rake db:seed
```

You're all set! Now you should be able to navigate to `/campaings/:id` to view a Campaign.
