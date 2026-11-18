Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057033;
	b=JPsBC+bGifZ3z7PDloITawDmH/zOpHQY9eYnIB3rZ6u2KK42MJp2j9Z+6sW/JYu6pHRs
	 UgPg3h3xgKT23TPO07CkxtamzCyWZK8L8dCdP3UnzITYWVdgIytmq0GZOh35C/DoE7lNz
	 p2GwKLgz7IPS8+i2CRv7X9uEDCzqjcy5O/8pSQsyMeeKOrva8gtDbdVtaPLKpBNHMf96G
	 0YEt1rBjllpCocGS0+HGv8jDfWmSzTq0TEgejPP76D3FG+agCBM8iJK57LHEoJkT6Lboh
	 xAm3QlK6GQMW3+cTbotzkeVpXZtQNYbNaWFtxYSGU3ibcRr+OUAL4Ga7sqv9pvtv5nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057033;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uLN/PWIOAmtK4YDtZpP6CVNeO9HxNGfbE1r8Xpq7hFo=;
	b=SdewsIZDCOK/MDyVTAHKa+k3wK2kiKH7W/upV1cMC+4GmXPRAW+ToBpr0kw1GkjetgIr
	 vqH69nHgoqa0QmMUxwLvCcj7uUBaMQr0jdevLz9czESpQuGaSOfAHIDDq1khKf8DDA8uU
	 u2mc370dHNNOUQPEXPYd68UDMQhFiUKDigwL+/KKIaHBhqi3jdK0/OMMrQijIu9L6/q/7
	 oBsL0FYLxRI0rPsdZkpE8/qgjMlW9tolQt85SFnAvFv4r4vTvRSEyu8gAEdH9N+I/LAun
	 zpWuXGC6W3vkLTVuVZBci7lKrILRlS8U93UwIBMZPx+HNcLb9KLXjTxAPDYyjHFDqCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CbgWAVPL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FEA1606A31C;
	Thu, 19 Nov 2026 02:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CbgWAVPL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C53ED1F000C4;
	Thu, 19 Nov 2026 02:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057033;
	bh=uLN/PWIOAmtK4YDtZpP6CVNeO9HxNGfbE1r8Xpq7hFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CbgWAVPLfgFT2SFbMZmrYrcSotYDgM/cdffAuFByjC8YWMeYnooPebugo71lrdFWF
	 S5u0Dgc2U9PcqZe/paGQO8Tot2OLLtyXKgRgNasC5l8cur2ZM+81XmfA7to0o9rI7o
	 ALmCiBmiQ2KG56SEbkPbWlIU6mVdSmzyAEn2j20U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	kernel test robot <lkp@intel.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.15 2199/2214] tracing/histogram: Wrap remaining shell snippets in code blocks
Date: Wed, 18 Nov 2026 16:04:35 +0100
Message-ID: <20261118150138.261033683@linuxfoundation.org>
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
@@ -1863,7 +1863,7 @@ A histogram can now be defined for the n
 The above shows the latency "lat" in a power of 2 grouping.
 
 Like any other event, once a histogram is enabled for the event, the
-output can be displayed by reading the event's 'hist' file.
+output can be displayed by reading the event's 'hist' file::
 
   # cat /sys/kernel/debug/tracing/events/synthetic/wakeup_latency/hist
 
@@ -1910,7 +1910,7 @@ output can be displayed by reading the e
 
 
 The latency values can also be grouped linearly by a given size with
-the ".buckets" modifier and specify a size (in this case groups of 10).
+the ".buckets" modifier and specify a size (in this case groups of 10)::
 
   # echo 'hist:keys=pid,prio,lat.buckets=10:sort=lat' >> \
         /sys/kernel/debug/tracing/events/synthetic/wakeup_latency/trigger
@@ -1947,7 +1947,7 @@ that range ends and can be smaller than
 
 To save stacktraces, create a synthetic event with a field of type "unsigned long[]"
 or even just "long[]". For example, to see how long a task is blocked in an
-uninterruptible state:
+uninterruptible state::
 
   # cd /sys/kernel/tracing
   # echo 's:block_lat pid_t pid; u64 delta; unsigned long[] stack;' > dynamic_events
@@ -1992,7 +1992,8 @@ uninterruptible state:
   => kthread+0xe9/0x110
   => ret_from_fork+0x2c/0x50
 
-A synthetic event that has a stacktrace field may use it as a key in histogram:
+A synthetic event that has a stacktrace field may use it as a key in
+histogram::
 
   # echo 'hist:delta.buckets=100,stack.stacktrace:sort=delta' > events/synthetic/block_lat/trigger
   # cat events/synthetic/block_lat/hist
@@ -2185,11 +2186,11 @@ The following commonly-used handler.acti
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
@@ -2322,48 +2323,48 @@ The following commonly-used handler.acti
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
@@ -2441,15 +2442,15 @@ The following commonly-used handler.acti
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
@@ -2472,10 +2473,10 @@ The following commonly-used handler.acti
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


