
# suitup-rails-test
# suitup-rt
##################################################################################

function suitup-rails-test-some {
  time ruby -I test/ "$1"
}

function suitup-rails-test-units {
  suitup-rails-db-reset-test
  time rake test:units RAILS_ENV=test
}

function suitup-rails-test-functionals {
  suitup-rails-db-reset-test
  time rake test:functionals RAILS_ENV=test
}

function suitup-rails-test-integration {
  suitup-rails-db-reset-test
  time rake test:integration RAILS_ENV=test
}

function suitup-rails-test-all {
  suitup-rails-db-reset-test
  time rake test RAILS_ENV=test
}

alias suitup-rt-some='suitup-rails-test'
alias suitup-rt-units='suitup-rails-test-units'
alias suitup-rt-functionals='suitup-rails-test-functionals'
alias suitup-rt-integration='suitup-rails-test-integration'
alias suitup-rt-all='suitup-rails-test-all'

# suitup-rails-test-multi
# suitup-rtm
##################################################################################
# suitup-rtm-prepare
# suitup-rtm-add test/functional/day_sale_reports_controller_test.rb
# suitup-rtm-add test/functional/month_sale_reports_controller_test.rb
# suitup-rtm-run

RUBY_MULTI_TEST="/tmp/ruby_multi_test.rb"

function suitup-rails-test-multi-prepare {
  sudo rm $RUBY_MULTI_TEST 2> /dev/null
}

function suitup-rails-test-multi-add {
  WORK_FOLDER=`pwd`
  echo "require '$WORK_FOLDER/$1' " >> $RUBY_MULTI_TEST
}

function suitup-rails-test-multi-status {
  cat $RUBY_MULTI_TEST 2> /dev/null
}

function suitup-rails-test-multi-run {
  suitup-rails-test-multi-status
  ruby -I test/ $RUBY_MULTI_TEST
}

alias suitup-rtm-prepare='suitup-rails-test-multi-prepare'
alias suitup-rtm-add='suitup-rails-test-multi-add'
alias suitup-rtm-status='suitup-rails-test-multi-status'
alias suitup-rtm-run='suitup-rails-test-multi-run'
