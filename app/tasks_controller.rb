class TasksController < UITableViewController
  attr_accessor :manager, :account, :store

  def viewDidLoad
    self.title = 'Tasks'
    navigationItem.leftBarButtonItem = UIBarButtonItemPlain.withTitle('Link', target:self, action:'linkToDropbox')
    navigationItem.rightBarButtonItem = UIBarButtonItemAdd.withTarget(self, action:'addTask')
    self.contentSizeForViewInPopover = CGSizeMake(310.0, view.rowHeight*10)
    tableView.dataSource = tableView.delegate = self
  end

  def viewWillAppear(animated)
    # used in the demo app, looks like an overkill
    self.manager.addObserver(self, block:lambda do |account|
      reload
    end)
    reload
  end

  def viewWillDisappear(animated)
    # used in the demo app, also looks like an overkill
    self.manager.removeObserver(self)
    self.store.removeObserver(self) if @store
    self.store = nil
  end

  def reload
    navigationItem.leftBarButtonItem.title = if self.account then 'Unlink' else 'Link' end
    navigationItem.rightBarButtonItem.enabled = (self.account != nil)
    self.store.sync(nil) if @store
    tableView.reloadData
  end

  def manager
    DBAccountManager.sharedManager
  end

  def account
    DBAccountManager.sharedManager.linkedAccount
  end

  def store
    @store ||= DBDatastore.openDefaultStoreForAccount(self.account, error:nil).tap do |s|
      s.addObserver(self, block:lambda do
        if self.store.status & (DBDatastoreIncoming | DBDatastoreOutgoing) then
          reload
        end
      end)
    end
  end

  def linkToDropbox
    if self.account then
      self.account.unlink
      self.store = nil
      reload
    else
      self.manager.linkFromController(self)
    end
  end

  def addTask
    if self.account then
      tasksTable = self.store.getTable('tasks')
      newTask = tasksTable.insert({'taskname' => "Buy milk #{rand(100)}", 'completed' => false })
      reload
    end
  end
  
  def numberOfSectionsInTableView(tableView)
    1
  end
  
  def tableView(tableView, numberOfRowsInSection:section)
    if self.account then
      tasksTable = self.store.getTable('tasks')
      tasksTable.query(nil, error:nil).count
    else
      0
    end
  end

  CellID = 'CellIdentifier'
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier(CellID) || UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:CellID)    
    tasksTable = self.store.getTable('tasks')
    task = tasksTable.query(nil, error:nil)[indexPath.row]
    cell.textLabel.text = task['taskname']
    cell
  end

  def tableView(tableView, commitEditingStyle:editingStyle, forRowAtIndexPath:indexPath)
    tasksTable = self.store.getTable('tasks')
    task = tasksTable.query(nil, error:nil)[indexPath.row]
    task.deleteRecord
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation:UITableViewRowAnimationFade) 
    reload
  end
  
  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    tableView.deselectRowAtIndexPath(indexPath, animated:true)
  end
end

