/*
 * Copyright 2014 NAVER Corp.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.navercorp.pinpoint.web.alarm;

import com.navercorp.pinpoint.web.alarm.checker.AlarmChecker;
import com.navercorp.pinpoint.web.alarm.vo.CheckerResult;
import com.navercorp.pinpoint.web.service.AlarmService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.batch.item.ItemWriter;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;
import java.util.Map;

/**
 * @author minwoo.jung
 */
public class AlarmWriter implements ItemWriter<AlarmChecker> {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired(required=false)
    private AlarmMessageSender alarmMessageSender = new AlarmMessageSenderImple();


    @Autowired
    private AlarmService alarmService;
    
    @Override
    public void write(List<? extends AlarmChecker> checkers) throws Exception {
        Map<String, CheckerResult> beforeCheckerResults = alarmService.selectBeforeCheckerResults(checkers.get(0).getRule().getApplicationId());

        for(AlarmChecker checker : checkers) {
            CheckerResult beforeCheckerResult = beforeCheckerResults.get(checker.getRule().getCheckerName());
            
            if (beforeCheckerResult == null) {
                beforeCheckerResult = new CheckerResult(checker.getRule().getApplicationId(), checker.getRule().getCheckerName(), false, 0 , 1);
            }
            
            if (checker.isDetected()) {
                    sendAlarmMessage(beforeCheckerResult, checker);
            }

            alarmService.updateBeforeCheckerResult(beforeCheckerResult, checker);
        }
    }

    private void sendAlarmMessage(CheckerResult beforeCheckerResult, AlarmChecker checker) {
        logger.info("发送短信的标识{},发送邮件的标识{}",checker.isSMSSend(),checker.isEmailSend());
        if (isTurnToSendAlarm(beforeCheckerResult)) {
            if (checker.isSMSSend()) {
                logger.info("===发送短信");
                alarmMessageSender.sendSms(checker, beforeCheckerResult.getSequenceCount() + 1);
            }
            if (checker.isEmailSend()) {
                logger.info("===发送邮件");
                alarmMessageSender.sendEmail(checker, beforeCheckerResult.getSequenceCount() + 1);
            }
        }
        
    }

    private boolean isTurnToSendAlarm(CheckerResult beforeCheckerResult) {
        if(!beforeCheckerResult.isDetected()) {
            return true;
        }
        
        int sequenceCount = beforeCheckerResult.getSequenceCount() + 1;
        
        if (sequenceCount == beforeCheckerResult.getTimingCount()) {
                return true;
        }
        
        return false;
    }
}
