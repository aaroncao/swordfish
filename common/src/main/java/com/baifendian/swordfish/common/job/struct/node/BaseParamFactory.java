/*
 * Copyright (C) 2017 Baifendian Corporation
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *          http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.baifendian.swordfish.common.job.struct.node;

import com.baifendian.swordfish.common.job.struct.datasource.DatasourceFactory;
import com.baifendian.swordfish.common.job.struct.node.hql.SqlParam;
import com.baifendian.swordfish.common.job.struct.node.mr.MrParam;
import com.baifendian.swordfish.common.job.struct.node.shell.ShellParam;
import com.baifendian.swordfish.common.job.struct.node.spark.SparkParam;
import com.baifendian.swordfish.dao.utils.json.JsonUtil;
import org.apache.avro.data.Json;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * 节点参数工厂
 */
public class BaseParamFactory {

  private static Logger logger = LoggerFactory.getLogger(DatasourceFactory.class.getName());

  public static BaseParam getBaseParam(String type, String parameter) {
    try {
      switch (type) {
        case "MR":
          return JsonUtil.parseObject(parameter, MrParam.class);
        case "SHELL":
          return JsonUtil.parseObject(parameter, ShellParam.class);
        case "HQL":
          return JsonUtil.parseObject(parameter, SqlParam.class);
        case "SPARK_STREAMING":
        case "SPARK":
          return JsonUtil.parseObject(parameter, SparkParam.class);
        default:
          return null;
      }
    } catch (Exception e) {
      logger.error("Get BaseParam object error", e);
      return null;
    }

  }
}