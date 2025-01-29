APP.pluginsCategories = [
  {
    "title": "All plugins",
    "categoryId": "all",
    "class": "active"
  },
  {
    "title": "Miscellaneous",
    "categoryId": "miscellaneous"
  },
  {
    "title": "Management",
    "categoryId": "management"
  },
  {
    "title": "Power tools",
    "categoryId": "power_tools"
  }
]


APP.plugins = {
  "taskcopy": {
    "name": "Task Copy",
    "description": "Copy a set of tasks",
    "full_description": """
      With this extension you can create Templates in JustDo and/or copy a set of tasks.<br><br>
      In many cases, there are certain workflows that occur regularly, during the day to day operation of an organization. A few examples of such workflows include order processing, legal documents drafting, approval & execution, events, customer service requests, etc.  These workflows are usually based on a number of predefined action items (tasks), that should be executed.<br><br>
      Now, rather than manually entering the same list of tasks every time the workflow has to be accomplished, you can copy an entire section of JustDo (a subtree) and use it as a template for your workflow.<br><br>
      This saves time, allows the sharing of best practice, and is a good method to makes sure colleagues follow the same workflow and steps when carrying out certain activities.<br><br>
      See <a href="https://www.youtube.com/watch?v=gIty__rKWOc&feature=youtu.be" target="_blank">this video</a> to learn how to enable and use this feature.
    """,
    "imageUrl": "/layout/plugins/plugin-task-copy.png",
    "price": "Free",
    "developer": "JustDo",
    "developerUrl": "www.justdo.com"
    "pluginUrl": "taskcopy",
    "category": {
      "title": "Miscellaneous",
      "class": "miscellaneous"
    },
    "version": "1.0",
    "developer": "JustDo Inc.",
    "developer_www": "www.justdo.com"
  },
  "workloadplanner": {
    "name": "Workload Planner",
    "description": "Manage tasks by terms",
    "full_description": """
      With the Workload Planner enabled, you can mark tasks that are set to be accomplished in the Short-Term, Mid-Term or Long-Term. So for example, from a backlog of tasks, you can choose which ones should be executed ‘soon’ (whatever ‘soon’ means for you - few days, a couple of weeks or more), and mark those tasks as ‘Short-Term’. Once you categorize tasks this way, a Plan by Term view can be selected, grouping tasks by members and terms, and you will be able to see what’s planned for the short term, mid-term, long term or unassigned).<br><br>
      In conjunction with the Resource Management extension, you will also be able to see how much time is planned and how much of the work was already executed per member.<br><br>
      Once the information is presented, you can verify if every team member has the right amount of work on his plate - not too little and not to much - and set him/her up for success. If needed, you’ll be able to move tasks around and transfer them between JustDo members. If you identify that too much work is set for the term, you can reassign tasks from short-term to mid-term (for example) or vice versa.<br><br>
      See <a href="https://drive.google.com/file/d/1MAxA4QaoaTNHSuGw_NTb1NkE6F8Qi96w/view" target="_blank">this video</a> to learn how to enable and use this feature, and <a href="https://drive.google.com/file/d/1JzPnIVWUoBi8BGmpgFRJLLzFV-nRIDLy/view" target="_blank">this video</a> to see how the workload planner is working in conjunction with the resource management module.
    """,
    "imageUrl": "/layout/plugins/plugin-workloadplanner.png",
    "price": "Free",
    "developer": "JustDo",
    "developerUrl": "www.justdo.com"
    "pluginUrl": "workloadplanner",
    "category": {
      "title": "Management",
      "class": "management"
    },
    "version": "1.0",
    "developer": "JustDo Inc.",
    "developer_www": "www.justdo.com"
  },
  "justdoactivity": {
    "name": "JustDo Activity",
    "description": "Real time updates about members activities",
    "full_description": """
      Enable this extension to see in real time what people are doing within JustDo. You will be able to choose between monitoring all updates to JustDo or filter for status changes only. Use this extension to stay on top of things on a day by day basis, or catch up and see what has been done after being away from the system. Think of it as a systems monitoring tool, but for our human colleagues rather than systems and servers.
    """,
    "imageUrl": "/layout/plugins/plugin-justdo-activity.png",
    "price": "Free",
    "developer": "JustDo",
    "developerUrl": "www.justdo.com"
    "pluginUrl": "justdoactivity",
    "category": {
      "title": "Miscellaneous, Management",
      "class": "miscellaneous management"
    },
    "version": "1.0",
    "developer": "JustDo Inc.",
    "developer_www": "www.justdo.com"
  },
  "rowsstyling": {
    "name": "Rows Styling",
    "description": "Style JustDo rows",
    "full_description": """
      This simple and small but useful extension lets you select different text formats for different tasks - bold, italic, underline or any combination. Use it to highlight specific tasks on your JustDo.
    """,
    "imageUrl": "/layout/plugins/plugin-tasks-rows-styling.png",
    "price": "Free",
    "developer": "JustDo",
    "developerUrl": "www.justdo.com"
    "pluginUrl": "rowsstyling",
    "category": {
      "title": "Miscellaneous",
      "class": "miscellaneous"
    },
    "version": "1.0",
    "developer": "JustDo Inc.",
    "developer_www": "www.justdo.com"
  },
  "meetings": {
    "name": "Meetings",
    "description": "Plan and manage meetings",
    "full_description": """
      In many organizations one of the biggest challenges is handling meetings. Starting with collecting and disseminating meeting notes and all the way to following on action items decided in a meeting.<br><br>
      With JustDo’s Meetings extension:<br><br>
      <ul>
        <li>Every meeting starts with setting up a specific agenda and discussion topics from the list of Tasks in your JustDo.</li>
        <li>Once the agenda is set and published, every meeting participant can prepare for the meeting, take private notes as reminders to bring up during the meeting and add action items that are associated to specific agenda points. All action items are automatically added as JustDo tasks.</li>
        <li>During the meeting, meeting notes can be captured and associated with agenda items. Here you can record what was decided, who said what etc. At the same time, if action items are identified you can easily spawn new tasks to reflect them. These tasks will be internally associated with the meeting information.</li>
        <li>Once the meeting is concluded, you can share the meeting notes by email, hardcopy or any other way with the meeting participants and other stakeholders.</li>
      </ul>
      Later on:<br><br>
      <ul>
        <li>You will be able get back to any meeting to see what was discussed there.</li>
        <li>All the action items that were identified before or during the meetings will be part of JustDo and will benefit from all other features of the system.</li>
        <li>For every task that was part of one or more meetings agenda - you will be able to quickly tap into the relevant meeting notes information.</li>
      </ul><br>
      See <a href="#" target="_blank">this video</a> for further explanation about this feature.
    """,
    "imageUrl": "/layout/plugins/plugin-meetings.png",
    "price": "Free",
    "developer": "JustDo",
    "developerUrl": "www.justdo.com"
    "pluginUrl": "meetings",
    "category": {
      "title": "Management",
      "class": "management"
    },
    "version": "1.0",
    "developer": "JustDo Inc.",
    "developer_www": "www.justdo.com"
  },
  "resourcemanagement": {
    "name": "Resource Management",
    "description": "Allocate and track resources for tasks",
    "full_description": """
      JustDo’s Resource Management is a complementary extension that lets you:<br><br>
      <ul>
        <li>Estimate the labor and budget required when planning a project.  Map the time that each team member needs to contribute in order to complete any specific task.  See how it accumulates over different tasks and see the consolidated data in the project’s parent task.</li>
        <li>Know how many hours and how much money was actually spent on any given project or task. Team members can easily log the time and money spent on a task whilst they are working on it. This information is collected, aggregated, and presented in a way that shows the total and breakdown of the hours and money spent. You can see your team members individual and overall contributions.</li>
        <li>Know how close you are to completing any project or task. Once you know how many hours are needed to accomplish your goals and how many hours were already spent, you can estimate how much of the project has been completed and how much more is left to do.</li>
        <li>Update and fine-tune your plans over time. As you understand the project better and adjust the resource estimation to accommodate real-life demands, changes, updates and other events, you can update the amounts planned for every task. The system will immediately reflect those changes and will show how they affect the amounts left to do in order to complete the project.</li>
      </ul><br>
      See <a href="#" target="_blank">this video</a> to see this extension in action
    """,
    "imageUrl": "/layout/plugins/plugin-resourcemanagement.png",
    "price": "Free",
    "developer": "JustDo",
    "developerUrl": "www.justdo.com"
    "pluginUrl": "resourcemanagement",
    "category": {
      "title": "Management, Power tools",
      "class": "management power_tools"
    },
    "version": "1.0",
    "developer": "JustDo Inc.",
    "developer_www": "www.justdo.com"
  },
  "calculatedduedates": {
    "name": "Calculated due dates",
    "description": "Create auto-updating dependencies for due dates",
    "full_description": """
      The Calculated Due Dates extension allows you to associate and set dependencies of different tasks’ due-dates. With this extension you will be able to automatically set a due date of a certain task:<br><br>
      <ul>
        <li>As the highest due date of its direct child-tasks.</li>
        <li>As the highest due date of all of its child-tasks.</li>
        <li>As the highest of specific list of other tasks.</li>
        <li>As an offset from some other task (e.g. Task #7 Due date is 3 days after Task #6 due date).</li>
      </ul><br>
      Hence with a task with multiple child tasks, and stages of work, you could set the calculated due date based upon the highest due date of all the parent’s task’s, child tasks. This in turn would mean that if one task is running behind, the parent’s task due date would automatically be updated to reflect this new reality.<br><br>
      See <a href="#" target="_blank">this video</a> for more information.
    """,
    "imageUrl": "/layout/plugins/plugin-calculatedduedates.png",
    "price": "Free",
    "developer": "JustDo",
    "developerUrl": "www.justdo.com"
    "pluginUrl": "calculatedduedates",
    "category": {
      "title": "Miscellaneous",
      "class": "miscellaneous"
    },
    "version": "1.0",
    "developer": "JustDo Inc.",
    "developer_www": "www.justdo.com"
  },
  "maildo": {
    "name": "MailDo",
    "description": "Send emails to JustDo to create/update tasks",
    "full_description": """
      MailDo is one of our most popular extensions. With MailDo, you, your team members, clients or vendors can send or forward emails straight into any task in JustDo. At your choice such emails can be attached to the task for further and future reference, or if selected so, to spawn new task(s). Sounds like magic? <a href="#" target="_blank">Check our tutorial video</a>.<br><br>
      Some popular usages of MailDo are:<br>
      <ul>
        <li>In HR department advertise an email address for candidates to send their CVs to. With any new candidate a new task is created, emails attachments (such as CVs) become file attachments in JustDo.</li>
        <li>In CRM systems - advertise a ‘complaints’ email address to your clients. Each email sent to this address will spawn a task for your team to respond to.</li>
        <li>When sending critical business communications to clients or vendors (quotes, orders, etc), CC (or BCC) the relevant task to keep a record of the email that was sent.</li>
      </ul>
    """,
    "imageUrl": "/layout/plugins/plugin-maildo.png",
    "price": "Free",
    "developer": "JustDo",
    "developerUrl": "www.justdo.com"
    "pluginUrl": "maildo",
    "category": {
        "title": "Miscellaneous, Management, Power tools",
        "class": "miscellaneous, management power_tools"
    },
    "version": "1.0",
    "developer": "JustDo Inc.",
    "developer_www": "www.justdo.com"
  }
}
