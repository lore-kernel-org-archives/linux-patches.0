Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050025;
	b=fvIHzklPlawFItkccpeaBmpKYwEDjco3iMa0E/tAi2F341/gNMvk31ZBXrNI3PXzmeYh
	 t9QwoJQnjv4ZqDugGM2dwqZs8/Pmy/qXgRLFmXVjB58U2PUS2b0s5qkh/iZmcFN+uuKM5
	 1C07GFu0epikofB6BlhwNI1bq8ifxuC6eT8rJfet8lo4381ZL21M2JvdYJfOL4bxyoMtD
	 Hq3V1Vse7TvFO5WqC/vo0nZAKC75IUBFiHfW/FtyCfIXhNPJHCIblUHK4lGebG3uk498t
	 Shy3YU++MnVSpeXEyCK5hnVI7dBb5LY8BXHlyLuR/zZFZIOe9SOyNTXs2QwSGxA3/nQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050025;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mQNuF9X7Dk1ay49qRlLxnM1ECbtGtMCyiI7geJb00tU=;
	b=CfRAO9mxfp3k1bcwPR1U0KyLHNrUZdufZxyhjSKOK0I89HM/Fc7b1gwBZ+ThLJMxHm82
	 qAKJ7K0mToGyE7MqFtSZ95dxNH+B/YM8GkBPkWm3dZsZ+FnNYBvTiEkjHlaYNfHbKm8GY
	 q5PBSE+xFB85PsTch1mUkS6CdNghPLHe+Q87AT/LsXw5BMYgaKKOWQpzgZ4KjJnM1USI/
	 FDxku045mwKYPpKq2jxxz64CyGYAt7+u12n2RCtb+gdt+EmW8fQ91bLYYNGnfpZZDpcxk
	 kpKzgr3c7vwMrybPETMPI4mc3nvqGdVxCbPOpaz576cpA5H3xL0zYL/TZHNDvg+DLaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c5iIZ+1j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA413606A335;
	Thu, 19 Nov 2026 01:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c5iIZ+1j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A4F61F000C4;
	Thu, 19 Nov 2026 01:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050025;
	bh=mQNuF9X7Dk1ay49qRlLxnM1ECbtGtMCyiI7geJb00tU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c5iIZ+1j3ip6Col/qBrEMeONNn/q+Z0mE+vFoPG3sWTM8CgwMBGuZ2L9pPm1SpQvs
	 LSTPuIsuYeKVM0jzIghoaYas7ricKJwehcxo126vim5GnCCkNNf2wDLx+ATXNtTEuu
	 jC7WUBpeY0O+/PzV3zMZjJunyPq4wBIjEBuKKI1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Tom Zanussi <zanussi@kernel.org>,
	Ross Zwisler <zwisler@google.com>,
	Ching-lin Yu <chinglinyu@google.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2561/2857] tracing/histogram: Document variable stacktrace
Date: Wed, 18 Nov 2026 15:59:55 +0100
Message-ID: <20261118150333.708581380@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt (Google) <rostedt@goodmis.org>

[ Upstream commit 88238513bb26713ef6d4418bdf1af062fe608bcb ]

Add a little documentation (and a useful example) of how a stacktrace can
be used within a histogram variable and synthetic event.

Link: https://lkml.kernel.org/r/20230117152236.320181354@goodmis.org

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Tom Zanussi <zanussi@kernel.org>
Cc: Ross Zwisler <zwisler@google.com>
Cc: Ching-lin Yu <chinglinyu@google.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Stable-dep-of: 289e2a775de4 ("tracing: Clamp the printed end of a histogram bucket at U64_MAX")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/trace/histogram.rst | 129 ++++++++++++++++++++++++++++++
 1 file changed, 129 insertions(+)

diff --git a/Documentation/trace/histogram.rst b/Documentation/trace/histogram.rst
index f95459aa984f3..5c391328b9bb4 100644
--- a/Documentation/trace/histogram.rst
+++ b/Documentation/trace/histogram.rst
@@ -81,6 +81,7 @@ Documentation written by Tom Zanussi
 	.usecs         display a common_timestamp in microseconds
         .percent       display a number of percentage value
         .graph         display a bar-graph of a value
+	.stacktrace    display as a stacktrace (must by a long[] type)
 	=============  =================================================
 
   Note that in general the semantics of a given field aren't
@@ -1786,6 +1787,8 @@ or assigned to a variable and referenced in a subsequent expression::
   # echo 'hist:keys=next_pid:us_per_sec=1000000 ...' >> event/trigger
   # echo 'hist:keys=next_pid:timestamp_secs=common_timestamp/$us_per_sec ...' >> event/trigger
 
+Variables can even hold stacktraces, which are useful with synthetic events.
+
 2.2.2 Synthetic Events
 ----------------------
 
@@ -1940,6 +1943,132 @@ the ".buckets" modifier and specify a size (in this case groups of 10).
       Entries: 16
       Dropped: 0
 
+To save stacktraces, create a synthetic event with a field of type "unsigned long[]"
+or even just "long[]". For example, to see how long a task is blocked in an
+uninterruptible state:
+
+  # cd /sys/kernel/tracing
+  # echo 's:block_lat pid_t pid; u64 delta; unsigned long[] stack;' > dynamic_events
+  # echo 'hist:keys=next_pid:ts=common_timestamp.usecs,st=stacktrace  if prev_state == 2' >> events/sched/sched_switch/trigger
+  # echo 'hist:keys=prev_pid:delta=common_timestamp.usecs-$ts,s=$st:onmax($delta).trace(block_lat,prev_pid,$delta,$s)' >> events/sched/sched_switch/trigger
+  # echo 1 > events/synthetic/block_lat/enable
+  # cat trace
+
+  # tracer: nop
+  #
+  # entries-in-buffer/entries-written: 2/2   #P:8
+  #
+  #                                _-----=> irqs-off/BH-disabled
+  #                               / _----=> need-resched
+  #                              | / _---=> hardirq/softirq
+  #                              || / _--=> preempt-depth
+  #                              ||| / _-=> migrate-disable
+  #                              |||| /     delay
+  #           TASK-PID     CPU#  |||||  TIMESTAMP  FUNCTION
+  #              | |         |   |||||     |         |
+            <idle>-0       [005] d..4.   521.164922: block_lat: pid=0 delta=8322 stack=STACK:
+  => __schedule+0x448/0x7b0
+  => schedule+0x5a/0xb0
+  => io_schedule+0x42/0x70
+  => bit_wait_io+0xd/0x60
+  => __wait_on_bit+0x4b/0x140
+  => out_of_line_wait_on_bit+0x91/0xb0
+  => jbd2_journal_commit_transaction+0x1679/0x1a70
+  => kjournald2+0xa9/0x280
+  => kthread+0xe9/0x110
+  => ret_from_fork+0x2c/0x50
+
+             <...>-2       [004] d..4.   525.184257: block_lat: pid=2 delta=76 stack=STACK:
+  => __schedule+0x448/0x7b0
+  => schedule+0x5a/0xb0
+  => schedule_timeout+0x11a/0x150
+  => wait_for_completion_killable+0x144/0x1f0
+  => __kthread_create_on_node+0xe7/0x1e0
+  => kthread_create_on_node+0x51/0x70
+  => create_worker+0xcc/0x1a0
+  => worker_thread+0x2ad/0x380
+  => kthread+0xe9/0x110
+  => ret_from_fork+0x2c/0x50
+
+A synthetic event that has a stacktrace field may use it as a key in histogram:
+
+  # echo 'hist:delta.buckets=100,stack.stacktrace:sort=delta' > events/synthetic/block_lat/trigger
+  # cat events/synthetic/block_lat/hist
+
+  # event histogram
+  #
+  # trigger info: hist:keys=delta.buckets=100,stacktrace:vals=hitcount:sort=delta.buckets=100:size=2048 [active]
+  #
+
+  { delta: ~ 0-99, stacktrace:
+           event_hist_trigger+0x464/0x480
+           event_triggers_call+0x52/0xe0
+           trace_event_buffer_commit+0x193/0x250
+           trace_event_raw_event_sched_switch+0xfc/0x150
+           __traceiter_sched_switch+0x41/0x60
+           __schedule+0x448/0x7b0
+           schedule_idle+0x26/0x40
+           cpu_startup_entry+0x19/0x20
+           start_secondary+0xed/0xf0
+           secondary_startup_64_no_verify+0xe0/0xeb
+  } hitcount:          6
+  { delta: ~ 0-99, stacktrace:
+           event_hist_trigger+0x464/0x480
+           event_triggers_call+0x52/0xe0
+           trace_event_buffer_commit+0x193/0x250
+           trace_event_raw_event_sched_switch+0xfc/0x150
+           __traceiter_sched_switch+0x41/0x60
+           __schedule+0x448/0x7b0
+           schedule_idle+0x26/0x40
+           cpu_startup_entry+0x19/0x20
+           __pfx_kernel_init+0x0/0x10
+           arch_call_rest_init+0xa/0x24
+           start_kernel+0x964/0x98d
+           secondary_startup_64_no_verify+0xe0/0xeb
+  } hitcount:          3
+  { delta: ~ 0-99, stacktrace:
+           event_hist_trigger+0x464/0x480
+           event_triggers_call+0x52/0xe0
+           trace_event_buffer_commit+0x193/0x250
+           trace_event_raw_event_sched_switch+0xfc/0x150
+           __traceiter_sched_switch+0x41/0x60
+           __schedule+0x448/0x7b0
+           schedule+0x5a/0xb0
+           worker_thread+0xaf/0x380
+           kthread+0xe9/0x110
+           ret_from_fork+0x2c/0x50
+  } hitcount:          1
+  { delta: ~ 100-199, stacktrace:
+           event_hist_trigger+0x464/0x480
+           event_triggers_call+0x52/0xe0
+           trace_event_buffer_commit+0x193/0x250
+           trace_event_raw_event_sched_switch+0xfc/0x150
+           __traceiter_sched_switch+0x41/0x60
+           __schedule+0x448/0x7b0
+           schedule_idle+0x26/0x40
+           cpu_startup_entry+0x19/0x20
+           start_secondary+0xed/0xf0
+           secondary_startup_64_no_verify+0xe0/0xeb
+  } hitcount:         15
+  [..]
+  { delta: ~ 8500-8599, stacktrace:
+           event_hist_trigger+0x464/0x480
+           event_triggers_call+0x52/0xe0
+           trace_event_buffer_commit+0x193/0x250
+           trace_event_raw_event_sched_switch+0xfc/0x150
+           __traceiter_sched_switch+0x41/0x60
+           __schedule+0x448/0x7b0
+           schedule_idle+0x26/0x40
+           cpu_startup_entry+0x19/0x20
+           start_secondary+0xed/0xf0
+           secondary_startup_64_no_verify+0xe0/0xeb
+  } hitcount:          1
+
+  Totals:
+      Hits: 89
+      Entries: 11
+      Dropped: 0
+
 2.2.3 Hist trigger 'handlers' and 'actions'
 -------------------------------------------
 
-- 
2.53.0



