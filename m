Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C1E15E5BB;
	Sat, 17 Oct 2026 18:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260848; cv=none; b=GlExHwblE/pg7xdLboRAifngS1zx4vt8C+6KTKsO+f8qa9p9p1Q5Zn34kWwoYxuNlgb7HAyXuyZA4t9mgaiTn2PL3cJO3b07jIUOIH0obKTxc99fKmVxE+uhxeS8m+d9Hh1l+GHOtSoiS1xe/8d2a1E3HfQbiO6+OxRRlTevfS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260848; c=relaxed/simple;
	bh=cwEdqZJ1WAxUN551dmqM16XegmhpOfVWPvRsv1j/AGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YaV2gcJRKTtptUzsRif0zwyr1dorQiwF/s13tPBJbKnzfxSlhVqR8/0XIdyNSlfXXhtFABm+/Ma7yWnWur3J7efoxAQCrdLFLJN1QZDiHoCji2GTwk1LcJFYH+88ZukK4VeXSuwOPSoR+xRx7QYIConO5sZDKhfDIT0wXWhjCIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PcqrAlXd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PcqrAlXd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 372891F000C4;
	Sat, 17 Oct 2026 18:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260847;
	bh=ImjHdBnpYIAGcPMM3QzjfxJKFzDvbZeIhXAawL+XDqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PcqrAlXdkOmOFOwakjCDgwSi+dWg4LmIFJYAu8MiWp43lM+0kP9U6LGpbfBY+ZmzQ
	 QeArRT0Dgjp/VhT9GKGrTXN/+rgJAzSOn/1JCRDGJzHk/dBKgTT0NYequ4LTpVM4NL
	 bopZIE1CZ4uR2ScK21WFA5DLBCONxH69Ze5zYt+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1673/1674] irqwork: Move data struct to a types header
Date: Sat, 17 Oct 2026 18:05:45 +0200
Message-ID: <20261017160514.009269380@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



