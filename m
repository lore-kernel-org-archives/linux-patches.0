Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E38173ADB9A;
	Sat, 17 Oct 2026 16:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255709; cv=none; b=RziIlU/rrS2Qhk7qRBR1xc2SyzXfNtjuJ1X9f5+gG+nVaxTnMOeP5K5xYluWlZlUKW64fxKdcmx+BVBvdqrGeHezZbIiOyg61C90+VGO56MQJx/vIlfz8YoZ4Jxq9TsMd2sAbiZrZchIlOOF0VD5wlNahcBri2zHPHR2t2holxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255709; c=relaxed/simple;
	bh=q4aHTx8/13zRd8gOA+0WoIAPpvjxomL1z9uep1o2mA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T/F6hd1HQSIg7nutcVE+HWxNaI6pyV1NUayJCa/410P4tSRJJcWjZBXTWd7gEz1m8eHgjkdZo71evrhQLsq3AHwtc/0nibuOWXXKF3n+nIHlkRpaTP3PvQxDDgeBTNNsXSa1jvo/EBunTNIL+SD+J0BsOH1SsPnylnRkpMrIPtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iP+EPBME; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iP+EPBME"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C9131F000C4;
	Sat, 17 Oct 2026 16:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255707;
	bh=4lvdd3obTVr+2mJup3mRjJtbE3KfWtUwOONyadUg8Qc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iP+EPBMEGWPPzVYRUnTflH0bRIQq9aEjHqf2WJEmzO0hhCzR8qU1lagqq4obJxf/S
	 aNliu8buHJCJV1zmiYJfG4dB1uOYJayHDCK6uRnwJt/hOCcOeV9Q8q+BIYIzClKXkS
	 3fErIuGmxbmmDCU3KosGprtseDG5d6+XWPje8BXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 865/869] irqwork: Move data struct to a types header
Date: Sat, 17 Oct 2026 18:01:46 +0200
Message-ID: <20261017160059.034672390@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit c809f081fe400cb1b9898f4791c0d33146315161 ]

... to avoid header recursion hell.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Link: https://patch.msgid.link/20251119172550.152813625@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/irq_work.h       |  9 ++-------
 include/linux/irq_work_types.h | 14 ++++++++++++++
 2 files changed, 16 insertions(+), 7 deletions(-)
 create mode 100644 include/linux/irq_work_types.h

diff --git a/include/linux/irq_work.h b/include/linux/irq_work.h
index 136f2980cba30..c5afd053ae32c 100644
--- a/include/linux/irq_work.h
+++ b/include/linux/irq_work.h
@@ -2,8 +2,9 @@
 #ifndef _LINUX_IRQ_WORK_H
 #define _LINUX_IRQ_WORK_H
 
-#include <linux/smp_types.h>
+#include <linux/irq_work_types.h>
 #include <linux/rcuwait.h>
+#include <linux/smp_types.h>
 
 /*
  * An entry can be in one of four states:
@@ -14,12 +15,6 @@
  * busy      NULL, 2 -> {free, claimed} : callback in progress, can be claimed
  */
 
-struct irq_work {
-	struct __call_single_node node;
-	void (*func)(struct irq_work *);
-	struct rcuwait irqwait;
-};
-
 #define __IRQ_WORK_INIT(_func, _flags) (struct irq_work){	\
 	.node = { .u_flags = (_flags), },			\
 	.func = (_func),					\
diff --git a/include/linux/irq_work_types.h b/include/linux/irq_work_types.h
new file mode 100644
index 0000000000000..73abec5bb06ed
--- /dev/null
+++ b/include/linux/irq_work_types.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_IRQ_WORK_TYPES_H
+#define _LINUX_IRQ_WORK_TYPES_H
+
+#include <linux/smp_types.h>
+#include <linux/types.h>
+
+struct irq_work {
+	struct __call_single_node	node;
+	void				(*func)(struct irq_work *);
+	struct rcuwait			irqwait;
+};
+
+#endif
-- 
2.53.0



