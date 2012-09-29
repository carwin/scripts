#!/usr/bin/ruby
require 'gir_ffi'
GirFFI.setup :Notify
Notify.init("Hello world")
Hello = Notify::Notification.new("Hello world!", "This is an example.", "dialog-information")
Hello.show
