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
package com.baifendian.swordfish.execserver.adhoc;

import com.google.common.util.concurrent.ThreadFactoryBuilder;

import com.baifendian.swordfish.dao.enums.AdHocStatus;
import com.baifendian.swordfish.dao.model.AdHoc;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Date;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.ThreadFactory;

public class AdHocRunnerManager {
  private static final Logger LOGGER = LoggerFactory.getLogger(AdHocRunnerManager.class);

  private final ExecutorService adHocExecutorService;

  public AdHocRunnerManager(){
    ThreadFactory flowThreadFactory = new ThreadFactoryBuilder().setNameFormat("Exec-Worker-FlowRunner").build();
    adHocExecutorService = Executors.newCachedThreadPool(flowThreadFactory);
  }

  public void submitAdHoc(AdHoc adHoc){
    String jobId = "ADHOC_" + adHoc.getId();
    adHoc.setStartTime(new Date());
    adHoc.setStatus(AdHocStatus.RUNNING);
    adHoc.setJobId(jobId);

    AdHocRunner adHocRunner = new AdHocRunner(adHoc);
    adHocExecutorService.submit(adHocRunner);
  }
}