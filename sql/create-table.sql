-- `user` table
DROP TABLE If Exists `user`;
CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'user id',
  `name` varchar(64) NOT NULL COMMENT 'user name',
  `email` varchar(64) NOT NULL COMMENT 'user email',
  `desc` varchar(256) DEFAULT NULL COMMENT 'description information of user',
  `phone` varchar(20) DEFAULT NULL COMMENT 'user phone number',
  `password` varchar(32) NOT NULL COMMENT 'user password for login, md5-value',
  `role` tinyint(4) NOT NULL COMMENT '0 means administrator, others means normal user',
  `proxy_users` text DEFAULT NULL COMMENT 'allow proxy user list',
  `create_time` datetime NOT NULL COMMENT 'create time of user',
  `modify_time` datetime NOT NULL COMMENT 'last modify time of user information',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Create a admin user, password is '123456'
INSERT INTO `user`(`name`, `email`, `desc`, `phone`, `password`, `role`, `create_time`, `modify_time`) VALUES('admin', 'dw_alert@baifendian.com', 'administrator user', null, 'e10adc3949ba59abbe56e057f20f883e', 0, now(),now());

-- Create a udp user, password is '123123', not necessary for swordfish project
INSERT INTO `user`(`name`, `email`, `desc`, `phone`, `password`, `role`, `proxy_users`, `create_time`, `modify_time`) VALUES('udp', 'bdms-group@baifendian.com', 'udp user', null, '4297f44b13955235245b2497399d7a93', 1, '["*"]', now(),now());

-- `project` table
DROP TABLE If Exists `project`;
CREATE TABLE `project` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'project id',
  `name` varchar(64) NOT NULL COMMENT 'project name',
  `desc` varchar(256) DEFAULT NULL COMMENT 'project description',
  `owner` int(11) NOT NULL COMMENT 'owner of the project',
  `create_time` datetime NOT NULL COMMENT 'create time of the project',
  `modify_time` datetime NOT NULL COMMENT 'last modify time of the project',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  FOREIGN KEY (`owner`) REFERENCES `user`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- `project_user` table
DROP TABLE If Exists `project_user`;
CREATE TABLE `project_user` (
  `project_id` int(11) NOT NULL COMMENT 'project id',
  `user_id` int(11) NOT NULL COMMENT 'user id',
  `perm` int(11) NOT NULL COMMENT 'permission, w/r/x, 0x04-w, 0x02-r, 0x01-x',
  `create_time` datetime NOT NULL COMMENT 'create time',
  `modify_time` datetime NOT NULL COMMENT 'last modify time',
  UNIQUE KEY `project_user` (`project_id`, `user_id`),
  FOREIGN KEY (`project_id`) REFERENCES `project`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- `session` table
DROP TABLE If Exists `session`;
CREATE TABLE `session` (
  `id` varchar(64) NOT NULL COMMENT 'session id',
  `user_id` int(11) NOT NULL COMMENT 'user id',
  `ip` varchar(32) NOT NULL COMMENT 'ip address of login on',
  `last_login_time` datetime NOT NULL COMMENT 'last login time',
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_ip` (`user_id`, `ip`),
  FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- `resources` table
DROP TABLE If Exists `resources`;
CREATE TABLE `resources` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'resource id',
  `name` varchar(64) NOT NULL COMMENT 'resources name',
  `origin_filename` varchar(64) NOT NULL COMMENT 'file name of the orgin file',
  `desc` varchar(256) DEFAULT NULL COMMENT 'resources description',
  `owner` int(11) NOT NULL COMMENT 'owner id of the resource',
  `project_id` int(11) NOT NULL COMMENT 'project id of this resource',
  `create_time` datetime NOT NULL COMMENT 'resource create time',
  `modify_time` datetime NOT NULL COMMENT 'resource last modify time',
  PRIMARY KEY (`id`),
  UNIQUE KEY `project_resname` (`project_id`, `name`),
  FOREIGN KEY (`project_id`) REFERENCES `project`(`id`)  ON DELETE CASCADE,
  FOREIGN KEY (`owner`) REFERENCES `user`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- `datasource` table
DROP TABLE If Exists `datasource`;
CREATE TABLE `datasource` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'datasource id',
  `name` varchar(64) NOT NULL COMMENT 'datasource name',
  `desc` varchar(256) DEFAULT NULL COMMENT 'datasource description',
  `type` tinyint(4) NOT NULL COMMENT 'datasource type',
  `owner` int(11) NOT NULL COMMENT 'owner id of the datasource.',
  `project_id` int(11) NOT NULL COMMENT 'project id of the datasource.',
  `parameter` text NOT NULL COMMENT 'datasource parameter',
  `create_time` datetime NOT NULL COMMENT 'create time of the datasource',
  `modify_time` datetime NOT NULL COMMENT 'modify time of the datasource',
  PRIMARY KEY (`id`),
  UNIQUE KEY `project_dsname` (`project_id`, `name`),
  FOREIGN KEY (`project_id`) REFERENCES `project`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`owner`) REFERENCES `user`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- `project_flows` table
DROP TABLE If Exists `project_flows`;
CREATE TABLE `project_flows` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'project flows id',
  `name` varchar(64) NOT NULL COMMENT 'project flows name',
  `desc` varchar(256) DEFAULT NULL COMMENT 'project flows description',
  `project_id` int(11) NOT NULL COMMENT 'project id of the project flows',
  `create_time` datetime NOT NULL COMMENT 'create time of the project flows',
  `modify_time` datetime NOT NULL COMMENT 'modify time of the project flows',
  `owner` int(11) NOT NULL COMMENT 'owner id of the project flows.',
  `proxy_user` varchar(32) NOT NULL COMMENT 'proxy user of the project flows.',
  `user_defined_params` text DEFAULT NULL COMMENT 'user defined parameter of the project flows.',
  `extras` LONGTEXT DEFAULT NULL COMMENT 'extends of the project flows',
  `queue` varchar(64) DEFAULT NULL COMMENT 'queue of the project flows',
  `flag` tinyint(4) DEFAULT NULL COMMENT 'flow flag, 1 means a tmp flow, will be delete.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `project_flowname` (`project_id`, `name`),
  FOREIGN KEY (`project_id`) REFERENCES `project`(`id`),
  FOREIGN KEY (`owner`) REFERENCES `user`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- `flows_nodes` table
DROP TABLE If Exists `flows_nodes`;
CREATE TABLE `flows_nodes` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'flow nodes id',
  `name` varchar(64) NOT NULL COMMENT 'flow nodes name',
  `flow_id` int(11) NOT NULL COMMENT 'project flow id of the flow nodes',
  `desc` VARCHAR(256) DEFAULT NULL COMMENT 'create time of the flow nodes',
  `type` varchar(32) NOT NULL COMMENT 'type of the flow nodes, string type',
  `parameter` LONGTEXT DEFAULT NULL COMMENT 'parameter of the flow nodes.',
  `extras` LONGTEXT DEFAULT NULL COMMENT 'extends of the flow nodes',
  `dep` text DEFAULT NULL COMMENT 'dep of the flow nodes, is a json array, array element is a node name',
  PRIMARY KEY (`id`),
  UNIQUE KEY `flows_nodename` (`flow_id`, `name`),
  FOREIGN KEY (`flow_id`) REFERENCES `project_flows`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- `schedules` table
DROP TABLE IF EXISTS `schedules`;
CREATE TABLE `schedules` (
  `flow_id` int(11) NOT NULL COMMENT 'flow id',
  `start_date` datetime NOT NULL COMMENT 'start date of the scheduler',
  `end_date` datetime NOT NULL COMMENT 'end date of the scheduler',
  `crontab` varchar(256) NOT NULL COMMENT 'cron tab str',
  `dep_workflows` text DEFAULT NULL COMMENT 'dep workflows, is a json array, array element is a flow id',
  `dep_policy` tinyint(4) NOT NULL COMMENT 'dep policy',
  `failure_policy` tinyint(4) NOT NULL COMMENT 'failure policy',
  `max_try_times` tinyint(4) NOT NULL COMMENT 'max try times',
  `notify_type` tinyint(4) NOT NULL COMMENT 'notify type',
  `notify_mails` text DEFAULT NULL COMMENT 'notify emails',
  `timeout` int(11) NOT NULL COMMENT 'timeout, unit: seconds',
  `create_time` datetime NOT NULL COMMENT 'create time of this records',
  `modify_time` datetime NOT NULL COMMENT 'modify time of this records',
  `owner` int(11) NOT NULL COMMENT 'owner id of the schedule',
  `schedule_status` tinyint(4) NOT NULL COMMENT 'status, offline/online 0 means offline, 1 means online',
  PRIMARY KEY (`flow_id`),
  FOREIGN KEY (`flow_id`) REFERENCES `project_flows`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`owner`) REFERENCES `user`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- `execution_flows` table
DROP TABLE IF EXISTS `execution_flows`;
CREATE TABLE `execution_flows` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'exec id',
  `flow_id` int(11) NOT NULL COMMENT 'flow id of this exec',
  `worker` varchar(64) DEFAULT NULL COMMENT 'exec work information, host:port',
  `submit_user` int(11) NOT NULL COMMENT 'submit user',
  `submit_time` datetime NOT NULL COMMENT 'submit time',
  `queue` varchar(64) NOT NULL COMMENT 'queue of this exec',
  `proxy_user` varchar(32) NOT NULL COMMENT 'proxy user of this exec',
  `schedule_time` datetime DEFAULT NULL COMMENT 'real schedule time of this exec',
  `start_time` datetime NOT NULL COMMENT 'real start time of this exec',
  `end_time` datetime DEFAULT NULL COMMENT 'end time of this exec',
  `workflow_data` LONGTEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'short desc of the workflow, contain keys: edges, nodes, extras; [{edges: [{"startNode": "xxx", "endNode": "xxx"}, ...], nodes: [{"name": "shelljob1", "desc":"shell", "type":"VIRTUAL", "param": {"script": "echo shelljob1"}, dep: [], "extras": {...}}, ...]',
  `workflow_data_sub` LONGTEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'substitute of workflow_data field',
  `user_defined_params` LONGTEXT DEFAULT NULL COMMENT 'user defined parameter of the flows.',
  `type` tinyint(4) NOT NULL COMMENT 'exec ways, schedule, add data or run ad-hoc.',
  `failure_policy` tinyint(4) NOT NULL COMMENT 'failure policy',
  `max_try_times` tinyint(4) DEFAULT NULL COMMENT 'max try times of the exec',
  `notify_type` tinyint(4) DEFAULT NULL COMMENT 'notify type',
  `notify_mails` text DEFAULT NULL COMMENT 'notify emails',
  `timeout` int(11) NOT NULL COMMENT 'timeout, unit: seconds',
  `status` tinyint(4) NOT NULL COMMENT 'exec status',
  `extras` text DEFAULT NULL COMMENT 'extra information of the flows',
  PRIMARY KEY (`id`),
  FOREIGN KEY (`flow_id`) REFERENCES `project_flows`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE INDEX proxy_user_index ON `execution_flows`(`proxy_user`);

-- `execution_nodes` table
DROP TABLE IF EXISTS `execution_nodes`;
CREATE TABLE `execution_nodes` (
  `exec_id` int(11) NOT NULL COMMENT 'exec id',
  `name` varchar(64) NOT NULL COMMENT 'node name for exec',
  `start_time` datetime NOT NULL COMMENT 'the start time of the node exec',
  `end_time` datetime DEFAULT NULL COMMENT 'the end time of the node exec',
  `attempt` tinyint(4) NOT NULL COMMENT 'attempt exec times',
  `app_links` text DEFAULT NULL COMMENT 'application links, is a json array, element is a string, used for track the application',
  `job_links` text DEFAULT NULL COMMENT 'job links, is a json array, element is a string, used for track the job',
  `job_id` varchar(64) NOT NULL COMMENT 'job id',
  `status` tinyint(4) NOT NULL COMMENT 'status',
  PRIMARY KEY (`exec_id`, `name`),
  FOREIGN KEY (`exec_id`) REFERENCES `execution_flows`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- `ad_hocs` table
DROP TABLE If Exists `ad_hocs`;
CREATE TABLE `ad_hocs` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'exec id of ad hoc query',
  `project_id` int(11) NOT NULL COMMENT 'project id of the ad hoc',
  `name` varchar(64) NOT NULL COMMENT 'name of ad hoc query',
  `owner` int(11) NOT NULL COMMENT 'owner id of the ad hoc',
  `parameter` text NOT NULL COMMENT 'parameter is a object, contains keys: stms, limit, udfs',
  `proxy_user` varchar(32) NOT NULL COMMENT 'proxy user name',
  `queue` varchar(64) NOT NULL COMMENT 'queue name',
  `type` tinyint(4) NOT NULL COMMENT 'ad hoc type',
  `status` tinyint(4) NOT NULL COMMENT 'status, refer https://github.com/baifendian/swordfish/wiki/workflow-exec%26maintain',
  `job_id` varchar(64) DEFAULT NULL COMMENT 'job id of this exec',
  `timeout` int(11) NOT NULL COMMENT 'timeout, unit: seconds',
  `create_time` datetime NOT NULL COMMENT 'create time of the ad hoc query',
  `start_time` datetime DEFAULT NULL COMMENT 'start time of this exec',
  `end_time` datetime DEFAULT NULL COMMENT 'end time of this exec',
  PRIMARY KEY (`id`),
  FOREIGN KEY (`project_id`) REFERENCES `project`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`owner`) REFERENCES `user`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- `ad_hoc_results` table
DROP TABLE If Exists `ad_hoc_results`;
CREATE TABLE `ad_hoc_results` (
  `exec_id` int(11) NOT NULL COMMENT 'exec id of ad hoc query',
  `index` int(11) NOT NULL COMMENT 'index of the stm',
  `stm` LONGTEXT NOT NULL COMMENT 'sql clause',
  `result` LONGTEXT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'result of this exec',
  `status` tinyint(4) NOT NULL COMMENT 'status of this exec',
  `create_time` datetime NOT NULL COMMENT 'create time of the records',
  `start_time` datetime DEFAULT NULL COMMENT 'start time of this exec',
  `end_time` datetime DEFAULT NULL COMMENT 'end time of this exec',
  PRIMARY KEY (`exec_id`,`index`),
  FOREIGN KEY (`exec_id`) REFERENCES `ad_hocs`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- `master_server` table
DROP TABLE If Exists `master_server`;
CREATE TABLE `master_server` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'jobExecManager id',
  `host` varchar(20) NOT NULL COMMENT 'ip address of the jobExecManager',
  `port` int(11) NOT NULL COMMENT 'port of the jobExecManager',
  `create_time` datetime NOT NULL COMMENT 'create time of the records',
  `modify_time` datetime NOT NULL COMMENT 'last modify time of the records',
  PRIMARY KEY (`id`),
  UNIQUE KEY `host_port` (`host`, `port`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- `streaming job` table
DROP TABLE If Exists `streaming_job`;
CREATE TABLE `streaming_job` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'streaming job id, also a exec id',
  `name` varchar(64) NOT NULL COMMENT 'streaming job name',
  `desc` varchar(256) DEFAULT NULL COMMENT 'streaming job description',
  `project_id` int(11) NOT NULL COMMENT 'project id of the streaming job',
  `create_time` datetime NOT NULL COMMENT 'create time of the streaming job',
  `modify_time` datetime NOT NULL COMMENT 'modify time of the streaming job',
  `owner` int(11) NOT NULL COMMENT 'owner id of the streaming job',
  `type` varchar(64) NOT NULL COMMENT 'job type',
  `parameter` text NOT NULL COMMENT 'job parameter information',
  `user_defined_params` text DEFAULT NULL COMMENT 'user defined parameter of the streaming job',
  `notify_type` tinyint(4) DEFAULT NULL COMMENT 'notify type',
  `notify_mails` text DEFAULT NULL COMMENT 'notify emails',
  PRIMARY KEY (`id`),
  UNIQUE KEY `project_streaming_name` (`project_id`, `name`),
  FOREIGN KEY (`project_id`) REFERENCES `project`(`id`),
  FOREIGN KEY (`owner`) REFERENCES `user`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- `streaming result` table
DROP TABLE If Exists `streaming_result`;
CREATE TABLE `streaming_result` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'exec id',
  `worker` varchar(64) DEFAULT NULL COMMENT 'exec work information, host:port',
  `streaming_id` int(11) NOT NULL COMMENT 'streaming job id, also a exec id',
  `parameter` text NOT NULL COMMENT 'parameter information of this exec',
  `user_defined_params` text DEFAULT NULL COMMENT 'user defined parameter of this exec',
  `submit_user` int(11) NOT NULL COMMENT 'submit user',
  `submit_time` datetime NOT NULL COMMENT 'submit time',
  `queue` varchar(64) NOT NULL COMMENT 'queue of this exec',
  `proxy_user` varchar(32) NOT NULL COMMENT 'proxy user of this exec',
  `schedule_time` datetime NOT NULL COMMENT 'real schedule time of this exec',
  `start_time` datetime DEFAULT NULL COMMENT 'real start time of this exec',
  `end_time` datetime DEFAULT NULL COMMENT 'end time of this exec, not exactly',
  `status` tinyint(4) NOT NULL COMMENT 'exec status',
  `app_links` text DEFAULT NULL COMMENT 'application links, is a json array, element is a string, used for track the application',
  `job_links` text DEFAULT NULL COMMENT 'job links, is a json array, element is a string, used for track the job',
  `job_id` varchar(64) DEFAULT NULL COMMENT 'job id',
  PRIMARY KEY (`id`),
  FOREIGN KEY (`streaming_id`) REFERENCES `streaming_job`(`id`) ON DELETE CASCADE,
  FOREIGN KEY (`submit_user`) REFERENCES `user`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
