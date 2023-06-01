# Project conversation portal

## System dependencies

This web app is created with the following script.

```sh
> ruby --version
ruby 2.7.2p137 (2020-10-01 revision 5445e04352) [x86_64-darwin20]

> rails --version
Rails 7.0.5

> rails new project-conversation-portal --database=postgresql
```

The app uses PostgreSQL as database, which is hosted in docker container configured with docker-compose.

```sh
> docker --version
docker-compose version 1.29.2, build unknown

> docker-compose --version
Docker version 20.10.20, build 9fdeb9c
```

## Commands

### Kick start the dependent services

```sh
> docker-compose up
```

### Initial setup

```sh
> bundle install
> bin/rails db:reset
```

### Start server

Run `bundle exec rails server` to start the rails web server, and the web server will receive request at http://localhost:3000.

### Start testing

Run `bundle exec rspec` to run the test cases.

## Assumptions

Q: What kind of history do we need to show in this app?
<br>
A: Users can leave comment and change status of a project. These are the activities that users could do in a project. Maybe think of a project as a Github issue. The activities would be shown like a timeline, so the user can see who have done what and when.
<br>
<br>
Q: Do we need user authentication in this app?
<br>
A: Yes. Also, since we are displaying history of the projects and conversations, we also want to show who is doing the actions.
<br>
<br>
Q: Do we need any permission control in this app? For example, only some users can change the status of some projects?
<br>
A: It would be nice to have, but not necessary.
<br>
<br>
Q: What are the possible statues do we have for a project?
<br>
A: Pending, WIP and Done.
<br>
<br>
Q: What do we need to show for a project, besides status and comments?
<br>
A: Name and description. Also, the name of the user who created the project and when it happened.
<br>
<br>
Q: Do we allow the user update the project, besides status, and comments?
<br>
A: Users should be able to update a project name and description. And it would be nice to have for updating comments.
<br>
<br>
Q: Do we need to implement live update in this app, i.e. users can see latest update without refreshing the page?
<br>
A: It would be nice to have live update for the page which shows the conversation. And no for other pages.

## Notes

Due to time limitation, not everything has been implemented. These are the possible improvements.

- technical:
    - refactor tailwind usage and extract common views, so there could be less repetitive classes
    - fix all the rubocop warnings and errors
    - introduce service layer to better encapsulate business logic in controller, because now it is doing multiple actions in some of the controller actions
- features:
    - support pagination or infinite scroll on project activities
    - support filtering and sorting on project list and activity list
    - support live update in project activities
    - support comment update, and showing the histories
    - support soft delete on projects and comments
