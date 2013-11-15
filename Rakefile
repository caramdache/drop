# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'drop'

  app.frameworks += ['CoreData', 'CFNetwork', 'Security', 'SystemConfiguration', 'QuartzCore', 'libc++.dylib']
  app.vendor_project 'vendor/Dropbox.framework', :static, :products => ['Dropbox'], :headers_dir => 'Headers'

  app.files += Dir.glob(File.join(app.project_dir, 'app/lib/**/*.rb')) |
               Dir.glob(File.join(app.project_dir, 'app/**/*.rb'))

  app.info_plist['CFBundleURLTypes'] = [
    { 'CFBundleTypeRole'   => 'Editor',
      'CFBundleURLName'    => 'Dropbox',
      'CFBundleURLSchemes' => ['db-xoit9j3uwj9vmdv'] }
  ]
end
