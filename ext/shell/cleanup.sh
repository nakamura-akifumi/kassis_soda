#!/bin/bash

rake tmp:clear
rake db:drop
rake db:create
rake db:migrate
rake db:seed
