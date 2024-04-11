Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A45813DDDD;
	Thu, 11 Apr 2024 09:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829590; cv=none; b=Htw4GLTX4e66vqS3aMQ2q/trmLnlCBrZ2Dy4SbfftNQVduS1eHRgv+SOCuBk7pLbEISy50DTg2sde6AEhzRlgCwKVmgCtefpCy184P7KMCXnj/B8yBEZ+8CFXcJFpqTHttY82NpD3admKGL3IXgms5tkkHLEMhYdBlRseomBQFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829590; c=relaxed/simple;
	bh=q9AFkWerm7xBHNsF+z6Ls9OQ46zn1ud7k8pvXnpV0A4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cZ0LpV05wX2smG+hOQazGHGtSeIuVo6uKApggrKQM+xrKp3v37/kYCld0OlxFnAzGsmVs3/Mgm4UXuXwznoi6FbRc/1XemWlpLwROa99CM+5xPDqe0ElkrtwUweBea64DigdmYIpLuSR4GVFOg2/jM10IsEcbQ5/YKZIOR1yAlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oytjELrs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oytjELrs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 931CDC433C7;
	Thu, 11 Apr 2024 09:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829590;
	bh=q9AFkWerm7xBHNsF+z6Ls9OQ46zn1ud7k8pvXnpV0A4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oytjELrsZ71rnFg5vPD8d4LO+1BpYHYYOhhXIptVd+4iN0/zGlMDIJEEJLJdR6yhy
	 E87vuxScZ3Z1eAoSoDkHX71UYEP9c/S35h2XASCiqldRsppwNmA9Hn3AGz75PyYNiw
	 ExnULstHVyc/4zKmzBt80AjNbJTU0iZGdwWqTuxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anna-Maria Gleixner <anna-maria@linutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	fweisbec@gmail.com,
	peterz@infradead.org,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 004/175] timer/trace: Replace deprecated vsprintf pointer extension %pf by %ps
Date: Thu, 11 Apr 2024 11:53:47 +0200
Message-ID: <20240411095419.671078435@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anna-Maria Gleixner <anna-maria@linutronix.de>

[ Upstream commit 6849cbb0f9a8dbc1ba56e9abc6955613103e01e3 ]

Since commit 04b8eb7a4ccd ("symbol lookup: introduce
dereference_symbol_descriptor()") %pf is deprecated, because %ps is smart
enough to handle function pointer dereference on platforms where such a
dereference is required.

While at it add proper line breaks to stay in the 80 character limit.

Signed-off-by: Anna-Maria Gleixner <anna-maria@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: fweisbec@gmail.com
Cc: peterz@infradead.org
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: https://lkml.kernel.org/r/20190321120921.16463-4-anna-maria@linutronix.de
Stable-dep-of: 0f7352557a35 ("wifi: brcmfmac: Fix use-after-free bug in brcmf_cfg80211_detach")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/timer.h | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/trace/events/timer.h b/include/trace/events/timer.h
index 350b046e7576c..8f6240854e28f 100644
--- a/include/trace/events/timer.h
+++ b/include/trace/events/timer.h
@@ -73,7 +73,7 @@ TRACE_EVENT(timer_start,
 		__entry->flags		= flags;
 	),
 
-	TP_printk("timer=%p function=%pf expires=%lu [timeout=%ld] cpu=%u idx=%u flags=%s",
+	TP_printk("timer=%p function=%ps expires=%lu [timeout=%ld] cpu=%u idx=%u flags=%s",
 		  __entry->timer, __entry->function, __entry->expires,
 		  (long)__entry->expires - __entry->now,
 		  __entry->flags & TIMER_CPUMASK,
@@ -105,7 +105,8 @@ TRACE_EVENT(timer_expire_entry,
 		__entry->function	= timer->function;
 	),
 
-	TP_printk("timer=%p function=%pf now=%lu", __entry->timer, __entry->function,__entry->now)
+	TP_printk("timer=%p function=%ps now=%lu",
+		  __entry->timer, __entry->function, __entry->now)
 );
 
 /**
@@ -210,7 +211,7 @@ TRACE_EVENT(hrtimer_start,
 		__entry->mode		= mode;
 	),
 
-	TP_printk("hrtimer=%p function=%pf expires=%llu softexpires=%llu "
+	TP_printk("hrtimer=%p function=%ps expires=%llu softexpires=%llu "
 		  "mode=%s", __entry->hrtimer, __entry->function,
 		  (unsigned long long) __entry->expires,
 		  (unsigned long long) __entry->softexpires,
@@ -243,7 +244,8 @@ TRACE_EVENT(hrtimer_expire_entry,
 		__entry->function	= hrtimer->function;
 	),
 
-	TP_printk("hrtimer=%p function=%pf now=%llu", __entry->hrtimer, __entry->function,
+	TP_printk("hrtimer=%p function=%ps now=%llu",
+		  __entry->hrtimer, __entry->function,
 		  (unsigned long long) __entry->now)
 );
 
-- 
2.43.0



