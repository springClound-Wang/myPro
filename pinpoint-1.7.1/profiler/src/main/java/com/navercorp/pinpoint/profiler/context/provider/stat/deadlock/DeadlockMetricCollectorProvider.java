/*
 * Copyright 2017 NAVER Corp.
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

package com.navercorp.pinpoint.profiler.context.provider.stat.deadlock;

import com.google.inject.Inject;
import com.google.inject.Provider;
import com.navercorp.pinpoint.profiler.monitor.collector.deadlock.DeadlockMetricCollector;
import com.navercorp.pinpoint.profiler.monitor.collector.deadlock.DefaultDeadlockMetricCollector;
import com.navercorp.pinpoint.profiler.monitor.collector.deadlock.UnsupportedDeadlockMetricCollector;
import com.navercorp.pinpoint.profiler.monitor.metric.deadlock.DeadlockMetric;

/**
 * @author Taejin Koo
 */
public class DeadlockMetricCollectorProvider implements Provider<DeadlockMetricCollector> {

    private final DeadlockMetric deadlockMetric;

    @Inject
    public DeadlockMetricCollectorProvider(DeadlockMetric deadlockMetric) {
        if (deadlockMetric == null) {
            throw new NullPointerException("deadlockMetric must not be null");
        }
        this.deadlockMetric = deadlockMetric;
    }

    @Override
    public DeadlockMetricCollector get() {
        if (deadlockMetric == DeadlockMetric.UNSUPPORTED_DEADLOCK_SOURCE_METRIC) {
            return new UnsupportedDeadlockMetricCollector();
        }
        return new DefaultDeadlockMetricCollector(deadlockMetric);
    }

}
