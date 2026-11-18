Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056471;
	b=IVOpyjk43YexXX9yUnwdnlGJCDf6jxwESX08pqwzrRedWqcEzGTKPI5fzVCJvppIWPNx
	 laFwb/OPFcp4yoOlsoZZ/Sm/O2KSF18MIDxw79P+welNEw0pXEV0iqUYeXcdNpmq1MdBs
	 s4aHICOjz84Y+pQAFMTFJ+Kf6+tR/Dl8k+777ruR8Otgx9XW80E7tavBRJ2nwimzCd9uD
	 SBDGJnCgYZ0O5VRPURY22Z1xqGMA/1KKFlp1rEmNwKGyaiiUAehhFMkvyZ3edDMAQAOy3
	 5nVVwuyQGPdVVhJXBqtMG+UsWiC6Z8Xc86EzYgkTUYDpX+Z3gOr9n7ytF92ZN7b3ubA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056471;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X+0LDDzkkIBsami+ATwiLT2Amps/uOsnpPbixKUYBlE=;
	b=ff38HG+QH+Q1hOOcJomXvdrGBpvYefv6PmZ0Ugo+VMDJ6qU1lwC8HiOC6kmiC2wWpN2H
	 vbAhHle1Ihatk+CkNH/odq2rcqZgZp/st11k1Pdve3uz3FLJxZ1Rts3XZwzSMXmK97oX/
	 AP273IUm5lslv9sn8CdsJ0iJG1yS4z4zCov9UHXmQ+Z54M3rdBVvKj3SYfkIAVYIrxZZo
	 xg7U+7Z2qbCw6O+lMBuie3DVRQm5Zwt7KZAu0NOYK0TotySgnoefgKuy+Q5GvBuW6XoDH
	 FiPe017jKEECOA3XIHekke1JaexAdKF0yk8aYEEnoeygCqRj6WaVchm9jBSyxV7PK3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LW6SdGJT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CDDB60A2634;
	Thu, 19 Nov 2026 02:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LW6SdGJT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 028861F00925;
	Thu, 19 Nov 2026 02:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056471;
	bh=X+0LDDzkkIBsami+ATwiLT2Amps/uOsnpPbixKUYBlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LW6SdGJTFtFgqb+QFUuf/tOUxW5rlLcdsSv7Q5p8Rb/RqCNhHrZtJWDIvnIUqtxXr
	 xluQTw70+O3LBUufVAkp23IcaXUBXJmNrRWnsnhfR1L6A5/4qxqfFoE7wpdShjJHek
	 YoNwpJpdSpx1IesPZKB1kNpsvy5kEJMfshqk4FVE=
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
Subject: [PATCH 5.15 2001/2214] tracing/histogram: Document variable stacktrace
Date: Wed, 18 Nov 2026 16:01:17 +0100
Message-ID: <20261118150130.827913901@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index abb023ef9f5eb..63c52126205b7 100644
--- a/Documentation/trace/histogram.rst
+++ b/Documentation/trace/histogram.rst
@@ -81,6 +81,7 @@ Documentation written by Tom Zanussi
 	.usecs         display a common_timestamp in microseconds
         .percent       display a number of percentage value
         .graph         display a bar-graph of a value
+	.stacktrace    display as a stacktrace (must by a long[] type)
 	=============  =================================================
 
   Note that in general the semantics of a given field aren't
@@ -1785,6 +1786,8 @@ or assigned to a variable and referenced in a subsequent expression::
   # echo 'hist:keys=next_pid:us_per_sec=1000000 ...' >> event/trigger
   # echo 'hist:keys=next_pid:timestamp_secs=common_timestamp/$us_per_sec ...' >> event/trigger
 
+Variables can even hold stacktraces, which are useful with synthetic events.
+
 2.2.2 Synthetic Events
 ----------------------
 
@@ -1939,6 +1942,132 @@ the ".buckets" modifier and specify a size (in this case groups of 10).
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



