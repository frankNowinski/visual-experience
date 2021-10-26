## About

Visual Experience is a simple Rails app that loosely mimics Movable Ink's Visual Experiences platform.

## Getting Started

First, clone the repo to your local computer.

```
git clone https://github.com/frankNowinski/visual-experience.git
```

Then, `cd` into the `visual-experience` directory and run `bundle`.

Now you can create the `db`, run the migrations and populate the `db` with seed data:

```
bundle exec rake db:create
```

```
bundle exec rake db:migrate
```

```
bundle exec rake db:seed
```
