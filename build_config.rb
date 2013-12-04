MRuby::Build.new do |conf|
  toolchain :gcc

  conf.gembox 'default'

  conf.gem :github => 'iij/mruby-env'
  conf.gem :github => 'mattn/mruby-http'
  conf.gem({ :github => 'take-cheeze/mruby-uv', :branch => 'compile_fix' })
end
