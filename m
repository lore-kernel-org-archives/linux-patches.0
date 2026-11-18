Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050857;
	b=SqCh7ng7PrKi8EP7WfROYmm12xWdir0bsmpskVJ5hv7rvBavOPrS32/0KYMZ5Au5nWa2
	 DvakWKeN9EzNmanRF8W0z4Cj9D2m6JDORLxcEmQWNvWVJwN7Sje2u7PjSh3kZvbs/aPDb
	 fx29ufRx5joIQK5X2j4XM6ECqiXD6pfk0sDGSeHOzytK5doUB/o+kOjNWkxa3zXzBGHWw
	 CVs3ziWRqBnKReho+vb53Wfv28KN8aULt9zZEiNE0ZiefpkaA2zaqRo+OMt/B7cA4V1By
	 B2QYkz1VlAlzNtpsOkWXX59vssn7duI3hPRf0Pl127CbG9vhDt6PYkgV6MgTAiPigAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050857;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Hp5uFbTS0OtxYQrpFbSDdbjH8RvuBZmOVdrUKlw5eS8=;
	b=L/NioDbuC6anQmXZrunGh3CPOjbxd3lNUiu2KR1zZmoAj/vqUbrKKQL6kxN5nz3t0r5X
	 rkkgZEhQ4Cfy3/WGsvucnIfGYFekLKeCIKcXactxDfT9p3UGVbiIjmpG6mjFScFbsOR7E
	 OohYsCE8eq4sudNWSygUVfWXSgJ+KiOYsJfrBgFAT+JdVc1wxNdl19x+hC2m6FkcMYI6r
	 yUSxQbWYlx93AYhaQ5W/YGvPlXJhNCo5718PZiz9Uk9tvVWVVVIPHXMn5Dg/exZMM/Q6L
	 wc6FX69Yqr8nF5UVxwpksSEEdicT7mj8ha55j0BZLy8bvLn3coVUb+I9SDUJ6hf4TjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZpY6+air;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31B8C606A320;
	Thu, 19 Nov 2026 01:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZpY6+air
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 497531F000C4;
	Thu, 19 Nov 2026 01:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050856;
	bh=Hp5uFbTS0OtxYQrpFbSDdbjH8RvuBZmOVdrUKlw5eS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZpY6+airu89HbQP+JjvaZ1GxMjV+TMCDxv5hsHozolznr+Y/1GUhG+fA9PgBCmpV9
	 FtqAXSbNzSx6RkMreeo/JClGDZhZyxGpmuIoNi4SyR2n31VWLrjcnatlOhITjefs4o
	 3J9daTtN/f9I4yJRp0Z8GEnO3uFbfbU6Zn+r1oVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	kernel test robot <lkp@intel.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.1 2842/2857] tracing/histogram: Wrap remaining shell snippets in code blocks
Date: Wed, 18 Nov 2026 16:04:36 +0100
Message-ID: <20261118150343.893510886@linuxfoundation.org>
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

From: Bagas Sanjaya <bagasdotme@gmail.com>

commit a2ff84a5d1e65c7d1178f24ecf39fc55283fbd14 upstream.

Most shell command snippets (echo/cat) and their output are already in
literal code blocks. However a few still isn't wrapped, in which the
htmldocs output is ugly.

Wrap the remaining unwrapped snippets, while also fix recent kernel test
robot warnings.

Link: https://lore.kernel.org/linux-trace-kernel/20230129031402.47420-1-bagasdotme@gmail.com

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Link: https://lore.kernel.org/linux-doc/202301290253.LU5yIxcJ-lkp@intel.com/
Fixes: 88238513bb2671 ("tracing/histogram: Document variable stacktrace")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/trace/histogram.rst |  103 +++++++++++++++++++-------------------
 1 file changed, 52 insertions(+), 51 deletions(-)

--- a/Documentation/trace/histogram.rst
+++ b/Documentation/trace/histogram.rst
@@ -1864,7 +1864,7 @@ A histogram can now be defined for the n
 The above shows the latency "lat" in a power of 2 grouping.
 
 Like any other event, once a histogram is enabled for the event, the
-output can be displayed by reading the event's 'hist' file.
+output can be displayed by reading the event's 'hist' file::
 
   # cat /sys/kernel/debug/tracing/events/synthetic/wakeup_latency/hist
 
@@ -1911,7 +1911,7 @@ output can be displayed by reading the e
 
 
 The latency values can also be grouped linearly by a given size with
-the ".buckets" modifier and specify a size (in this case groups of 10).
+the ".buckets" modifier and specify a size (in this case groups of 10)::
 
   # echo 'hist:keys=pid,prio,lat.buckets=10:sort=lat' >> \
         /sys/kernel/debug/tracing/events/synthetic/wakeup_latency/trigger
@@ -1948,7 +1948,7 @@ that range ends and can be smaller than
 
 To save stacktraces, create a synthetic event with a field of type "unsigned long[]"
 or even just "long[]". For example, to see how long a task is blocked in an
-uninterruptible state:
+uninterruptible state::
 
   # cd /sys/kernel/tracing
   # echo 's:block_lat pid_t pid; u64 delta; unsigned long[] stack;' > dynamic_events
@@ -1993,7 +1993,8 @@ uninterruptible state:
   => kthread+0xe9/0x110
   => ret_from_fork+0x2c/0x50
 
-A synthetic event that has a stacktrace field may use it as a key in histogram:
+A synthetic event that has a stacktrace field may use it as a key in
+histogram::
 
   # echo 'hist:delta.buckets=100,stack.stacktrace:sort=delta' > events/synthetic/block_lat/trigger
   # cat events/synthetic/block_lat/hist
@@ -2186,11 +2187,11 @@ The following commonly-used handler.acti
               wakeup_new_test($testpid) if comm=="cyclictest"' >> \
               /sys/kernel/debug/tracing/events/sched/sched_wakeup_new/trigger
 
-    Or, equivalently, using the 'trace' keyword syntax:
+    Or, equivalently, using the 'trace' keyword syntax::
 
-    # echo 'hist:keys=$testpid:testpid=pid:onmatch(sched.sched_wakeup_new).\
-            trace(wakeup_new_test,$testpid) if comm=="cyclictest"' >> \
-            /sys/kernel/debug/tracing/events/sched/sched_wakeup_new/trigger
+      # echo 'hist:keys=$testpid:testpid=pid:onmatch(sched.sched_wakeup_new).\
+              trace(wakeup_new_test,$testpid) if comm=="cyclictest"' >> \
+              /sys/kernel/debug/tracing/events/sched/sched_wakeup_new/trigger
 
     Creating and displaying a histogram based on those events is now
     just a matter of using the fields and new synthetic event in the
@@ -2323,48 +2324,48 @@ The following commonly-used handler.acti
     resulting latency, stored in wakeup_lat, exceeds the current
     maximum latency, a snapshot is taken.  As part of the setup, all
     the scheduler events are also enabled, which are the events that
-    will show up in the snapshot when it is taken at some point:
+    will show up in the snapshot when it is taken at some point::
 
-    # echo 1 > /sys/kernel/debug/tracing/events/sched/enable
+      # echo 1 > /sys/kernel/debug/tracing/events/sched/enable
 
-    # echo 'hist:keys=pid:ts0=common_timestamp.usecs \
-            if comm=="cyclictest"' >> \
-            /sys/kernel/debug/tracing/events/sched/sched_waking/trigger
-
-    # echo 'hist:keys=next_pid:wakeup_lat=common_timestamp.usecs-$ts0: \
-            onmax($wakeup_lat).save(next_prio,next_comm,prev_pid,prev_prio, \
-	    prev_comm):onmax($wakeup_lat).snapshot() \
-	    if next_comm=="cyclictest"' >> \
-	    /sys/kernel/debug/tracing/events/sched/sched_switch/trigger
+      # echo 'hist:keys=pid:ts0=common_timestamp.usecs \
+              if comm=="cyclictest"' >> \
+              /sys/kernel/debug/tracing/events/sched/sched_waking/trigger
+
+      # echo 'hist:keys=next_pid:wakeup_lat=common_timestamp.usecs-$ts0: \
+              onmax($wakeup_lat).save(next_prio,next_comm,prev_pid,prev_prio, \
+	      prev_comm):onmax($wakeup_lat).snapshot() \
+	      if next_comm=="cyclictest"' >> \
+	      /sys/kernel/debug/tracing/events/sched/sched_switch/trigger
 
     When the histogram is displayed, for each bucket the max value
     and the saved values corresponding to the max are displayed
     following the rest of the fields.
 
     If a snapshot was taken, there is also a message indicating that,
-    along with the value and event that triggered the global maximum:
+    along with the value and event that triggered the global maximum::
 
-    # cat /sys/kernel/debug/tracing/events/sched/sched_switch/hist
-      { next_pid:       2101 } hitcount:        200
-	max:         52  next_prio:        120  next_comm: cyclictest \
-        prev_pid:          0  prev_prio:        120  prev_comm: swapper/6
-
-      { next_pid:       2103 } hitcount:       1326
-	max:        572  next_prio:         19  next_comm: cyclictest \
-        prev_pid:          0  prev_prio:        120  prev_comm: swapper/1
-
-      { next_pid:       2102 } hitcount:       1982 \
-	max:         74  next_prio:         19  next_comm: cyclictest \
-        prev_pid:          0  prev_prio:        120  prev_comm: swapper/5
-
-    Snapshot taken (see tracing/snapshot).  Details:
-	triggering value { onmax($wakeup_lat) }:        572	\
-	triggered by event with key: { next_pid:       2103 }
-
-    Totals:
-        Hits: 3508
-        Entries: 3
-        Dropped: 0
+      # cat /sys/kernel/debug/tracing/events/sched/sched_switch/hist
+        { next_pid:       2101 } hitcount:        200
+	  max:         52  next_prio:        120  next_comm: cyclictest \
+          prev_pid:          0  prev_prio:        120  prev_comm: swapper/6
+
+        { next_pid:       2103 } hitcount:       1326
+	  max:        572  next_prio:         19  next_comm: cyclictest \
+          prev_pid:          0  prev_prio:        120  prev_comm: swapper/1
+
+        { next_pid:       2102 } hitcount:       1982 \
+	  max:         74  next_prio:         19  next_comm: cyclictest \
+          prev_pid:          0  prev_prio:        120  prev_comm: swapper/5
+
+      Snapshot taken (see tracing/snapshot).  Details:
+	  triggering value { onmax($wakeup_lat) }:        572	\
+	  triggered by event with key: { next_pid:       2103 }
+
+      Totals:
+          Hits: 3508
+          Entries: 3
+          Dropped: 0
 
     In the above case, the event that triggered the global maximum has
     the key with next_pid == 2103.  If you look at the bucket that has
@@ -2442,15 +2443,15 @@ The following commonly-used handler.acti
     $cwnd variable.  If the value has changed, a snapshot is taken.
     As part of the setup, all the scheduler and tcp events are also
     enabled, which are the events that will show up in the snapshot
-    when it is taken at some point:
+    when it is taken at some point::
 
-    # echo 1 > /sys/kernel/debug/tracing/events/sched/enable
-    # echo 1 > /sys/kernel/debug/tracing/events/tcp/enable
+      # echo 1 > /sys/kernel/debug/tracing/events/sched/enable
+      # echo 1 > /sys/kernel/debug/tracing/events/tcp/enable
 
-    # echo 'hist:keys=dport:cwnd=snd_cwnd: \
-            onchange($cwnd).save(snd_wnd,srtt,rcv_wnd): \
-	    onchange($cwnd).snapshot()' >> \
-	    /sys/kernel/debug/tracing/events/tcp/tcp_probe/trigger
+      # echo 'hist:keys=dport:cwnd=snd_cwnd: \
+              onchange($cwnd).save(snd_wnd,srtt,rcv_wnd): \
+	      onchange($cwnd).snapshot()' >> \
+	      /sys/kernel/debug/tracing/events/tcp/tcp_probe/trigger
 
     When the histogram is displayed, for each bucket the tracked value
     and the saved values corresponding to that value are displayed
@@ -2473,10 +2474,10 @@ The following commonly-used handler.acti
       { dport:        443 } hitcount:        211
 	changed:         10  snd_wnd:      26960  srtt:      17379  rcv_wnd:      28800
 
-    Snapshot taken (see tracing/snapshot).  Details::
+      Snapshot taken (see tracing/snapshot).  Details:
 
-        triggering value { onchange($cwnd) }:         10
-        triggered by event with key: { dport:         80 }
+          triggering value { onchange($cwnd) }:         10
+          triggered by event with key: { dport:         80 }
 
       Totals:
           Hits: 414


