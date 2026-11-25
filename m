Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620033;
	b=mIJXAdG57gRYeRc9rivh0u0mixD9Pz2zSMYUr5dEqBWXYpVleDG1RnfRE5egbEjdP7j6
	 D8bthAV0ODasLjAhdO8jmjHtCXi+HYPIEediiodPD6ES8dpbDgY+82MjUUNJIUW07A2uy
	 H7GNYYt0WQbIEo+xfd52vGdRG+Bip4kt9TUV+zlFgDpjPxKdB1e7Z8VnUWvigyIP54PaQ
	 eNHSdCHVUBJ8hzZja8Gb6qHRyBxAt9UFhLWCKg5h8CqavyQCoD2HQ08Oh3QS97YpDdQ0L
	 Biyb0+1iICYiMw+JrahSmjikkcl701clHQIeoQ4WpV45NJ6uEWDKPuf01XJMXP4+6lA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620033;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rSIEhaWlPO9is+/iLbMpHKrCMvVpWbtyraS38+NpfJw=;
	b=IZUOQl9GhYzEIO+Gx7MVJw6UXGBtrgF+i+zQVmhbc8X0Rk6Z63AEkx+2BmziHmFILwmp
	 f0opsriLTeyh2+ose907NawcE3hSpQw2clNIG0/EOS8jDqkAw/o5gLlUgkDVSV2nZYnek
	 6B2lhz+qrgTk2HiskL31KF5K64jVfOFO7bpiC7hreQiosgdisQxseEMgflZlJ8ey8kU3e
	 9FB/CA4H1y5XLnU15k8zE8j4ufZhLxZHEfjv9/QNxyhDdV/qOi0kMrep454lajwK0+jxp
	 wNOs77pZhWgaSaP4YPOvgAqhWJC0Wzy1yzb10j8dOEf9HOmtKTxY6tDB4Op/Xrw8WJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MwHONvKF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9BD2606A321;
	Wed, 25 Nov 2026 15:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MwHONvKF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B75C11F000C4;
	Wed, 25 Nov 2026 15:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620033;
	bh=rSIEhaWlPO9is+/iLbMpHKrCMvVpWbtyraS38+NpfJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MwHONvKFJxUuf9OD9sItdcva6QiDWbTI8QPEF1XI8Y8bLkHR1Ogc8VfWQa64t/Yfx
	 UTE7prcLPZrD8fABUMtraaesSd3P5qt+WsSpaUdpoTmVDgJbMo+TNeAXyRdPCuRmpd
	 J/rRnrxhUDLvYCqc0+kwOaDZ96ppqSnFh4n5GFt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 7.3 0785/1005] tracing/probes: Check enabled and busy state before unlinking sibling probes
Date: Wed, 25 Nov 2026 15:35:23 +0100
Message-ID: <20261125143840.129705105@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit f1d9b7a3fe99b4228acdbab3c744c29f7ffe86ef upstream.

When a multiprobe event is enabled or referenced (for example, by an
eprobe, trigger, or open tracefs file) and a user attempts to delete the
event or one of its probes via dynamic_events, checking
trace_probe_has_sibling() before the enabled and busy checks allows the
first probe to be unlinked and freed while the event is still active,
only returning -EBUSY on the last sibling probe. For uprobe events,
unlinking and freeing an enabled sibling probe without unregistering its
uprobe_consumer also causes a use-after-free.

Ensure all four probe types (kprobe, fprobe, uprobe, and eprobe) verify
that the event is neither enabled nor busy before unlinking any sibling
probe.

Link: https://lore.kernel.org/all/179455848898.403392.17675270675769076596.stgit@devnote2/

Fixes: ca89bc071d5e ("tracing/kprobe: Add multi-probe per event support")
Fixes: 41af3cf587f4 ("tracing/uprobe: Add multi-probe per uprobe event support")
Fixes: 7491e2c44278 ("tracing: Add a probe that attaches to trace events")
Fixes: 334e5519c375 ("tracing/probes: Add fprobe events for tracing function entry and exit.")
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_eprobe.c |   12 ++++++++----
 kernel/trace/trace_fprobe.c |    8 ++++----
 kernel/trace/trace_kprobe.c |    8 ++++----
 kernel/trace/trace_uprobe.c |    8 ++++++--
 4 files changed, 22 insertions(+), 14 deletions(-)

--- a/kernel/trace/trace_eprobe.c
+++ b/kernel/trace/trace_eprobe.c
@@ -94,14 +94,18 @@ static int eprobe_dyn_event_show(struct
 
 static int unregister_trace_eprobe(struct trace_eprobe *ep)
 {
-	/* If other probes are on the event, just unregister eprobe */
-	if (trace_probe_has_sibling(&ep->tp))
-		goto unreg;
-
 	/* Enabled event can not be unregistered */
 	if (trace_probe_is_enabled(&ep->tp))
 		return -EBUSY;
 
+	/* If there's a reference to the dynamic event */
+	if (trace_event_dyn_busy(trace_probe_event_call(&ep->tp)))
+		return -EBUSY;
+
+	/* If other probes are on the event, just unregister eprobe */
+	if (trace_probe_has_sibling(&ep->tp))
+		goto unreg;
+
 	/* Will fail if probe is being used by ftrace or perf */
 	if (trace_probe_unregister_event_call(&ep->tp))
 		return -EBUSY;
--- a/kernel/trace/trace_fprobe.c
+++ b/kernel/trace/trace_fprobe.c
@@ -853,10 +853,6 @@ static void __unregister_trace_fprobe(st
 /* Unregister a trace_probe and probe_event */
 static int unregister_trace_fprobe(struct trace_fprobe *tf)
 {
-	/* If other probes are on the event, just unregister fprobe */
-	if (trace_probe_has_sibling(&tf->tp))
-		goto unreg;
-
 	/* Enabled event can not be unregistered */
 	if (trace_probe_is_enabled(&tf->tp))
 		return -EBUSY;
@@ -865,6 +861,10 @@ static int unregister_trace_fprobe(struc
 	if (trace_event_dyn_busy(trace_probe_event_call(&tf->tp)))
 		return -EBUSY;
 
+	/* If other probes are on the event, just unregister fprobe */
+	if (trace_probe_has_sibling(&tf->tp))
+		goto unreg;
+
 	/* Will fail if probe is being used by ftrace or perf */
 	if (unregister_fprobe_event(tf))
 		return -EBUSY;
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -548,10 +548,6 @@ static void __unregister_trace_kprobe(st
 /* Unregister a trace_probe and probe_event */
 static int unregister_trace_kprobe(struct trace_kprobe *tk)
 {
-	/* If other probes are on the event, just unregister kprobe */
-	if (trace_probe_has_sibling(&tk->tp))
-		goto unreg;
-
 	/* Enabled event can not be unregistered */
 	if (trace_probe_is_enabled(&tk->tp))
 		return -EBUSY;
@@ -560,6 +556,10 @@ static int unregister_trace_kprobe(struc
 	if (trace_event_dyn_busy(trace_probe_event_call(&tk->tp)))
 		return -EBUSY;
 
+	/* If other probes are on the event, just unregister kprobe */
+	if (trace_probe_has_sibling(&tk->tp))
+		goto unreg;
+
 	/* Will fail if probe is being used by ftrace or perf */
 	if (unregister_kprobe_event(tk))
 		return -EBUSY;
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -396,13 +396,17 @@ static int unregister_trace_uprobe(struc
 {
 	int ret;
 
-	if (trace_probe_has_sibling(&tu->tp))
-		goto unreg;
+	/* Enabled event can not be unregistered */
+	if (trace_probe_is_enabled(&tu->tp))
+		return -EBUSY;
 
 	/* If there's a reference to the dynamic event */
 	if (trace_event_dyn_busy(trace_probe_event_call(&tu->tp)))
 		return -EBUSY;
 
+	if (trace_probe_has_sibling(&tu->tp))
+		goto unreg;
+
 	ret = unregister_uprobe_event(tu);
 	if (ret)
 		return ret;


