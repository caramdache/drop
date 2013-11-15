class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    mgr = DBAccountManager.alloc.initWithAppKey("xoit9j3uwj9vmdv", secret:"dkc3edahiij64jl")
    DBAccountManager.setSharedManager(mgr)

    @tasksController = TasksController.alloc.init
    tasksNav = UINavigationController.alloc.initWithRootViewController(@tasksController)    

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = tasksNav
    @window.makeKeyAndVisible
    true
  end

  def application(application, openURL:url, sourceApplication:sourceApplication, annotation:annotation)
    if DBAccountManager.sharedManager.handleOpenURL(url) then
      @tasksController.reload
      true
    end

    false
  end
end
