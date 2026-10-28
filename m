Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207912;
	b=Lr1IbUx26+LuOGP5v5GuUtMsLGzJmLVoh4jhjZIK68rsYls+O8eLnNY+M/2ALErU/l2u
	 QdIuntMLuqF/Ep9LXe2up8mLvwzL9OCMtfAB06QFTh78KU3mos7xVkHBa9FkG+P+cIgc6
	 GxCXCcg5AuQX4nlescIcCwBHHjpliXJmgCxTqjdsVLWGuBkN5g+X0S56Tqv6LAafB6vDo
	 GEVo+kJiBIymo7sjDY10D9u/gw1i9hc8ncTNb2kqNgGrKCzNbAA0MR8dBjenpkH+zqYAG
	 yeSfvoLjeghcGWp9SRsxM88sbGFbsHZu48Cq5mftWDqJkOoCKWc28NkUbXOzJYmg7+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207912;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VI+MexuF3F7adYasrUQlFMQBpFErf05XoKJn6/80ydg=;
	b=QjJF4TvPTqch3gOE1JAV8d+U2cxGzcoCZSOg3AhiPEyyiip74F3MA1eOIGAQdiHSDIhf
	 93o/W9hSqcjidjWIHloBouPSfRA8QqBUH5d3bTrXZIm1jhmOU0j5ctEjCzQ2DY636Hsdn
	 FGI+jJjtdoLyI1Jt3/xkPB/btAIpiW5sByeyJV97JwyjsiPy/Z0U8NzCTUrtAbAvrTiQ9
	 WN5XcYRk9C3ffVYvBwlTWrwLb6+nn4jA2ZOfr6iXaOwTBoOebs0tzmCq05RzZqLtpRUWD
	 IW+6hOZkR/4w0+BP0b9bz1hDlel1J6n5LgCnQv43mpM9HgrNterwbfzfloAYZbbwN9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PTnHCdwX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94813606A32C;
	Wed, 28 Oct 2026 17:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PTnHCdwX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D09D1F01825;
	Wed, 28 Oct 2026 17:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207911;
	bh=VI+MexuF3F7adYasrUQlFMQBpFErf05XoKJn6/80ydg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PTnHCdwXWvEOLs+3WjYohhVAPNIeET24PwbY7TuPyz2DXDEOoZ+A1sYcY8/niZkhs
	 phZGQwNabFBHGnwTPp9bUvdWQFPADk6dYMakoQ6i1zBScNahcUKX1Dbwg7S6CmDFVp
	 EHbP/u1lXPqL/r+kw1gfooqxyw1gNJfYwDT5m4AA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 184/247] Revert "srcu: Use irq_work to start GP in tiny SRCU"
Date: Wed, 28 Oct 2026 17:59:47 +0100
Message-ID: <20261028165951.778087455@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit 2127e6b79d9d579ea538a350d1bbe859e39814d5.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/49da816c-8082-46f1-bb12-f0d6187bb06a@roeck-us.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/srcutiny.h |  4 ----
 kernel/rcu/srcutiny.c    | 19 +------------------
 2 files changed, 1 insertion(+), 22 deletions(-)

diff --git a/include/linux/srcutiny.h b/include/linux/srcutiny.h
index 6f39d3d8ef879..4d96bbdb45f08 100644
--- a/include/linux/srcutiny.h
+++ b/include/linux/srcutiny.h
@@ -11,7 +11,6 @@
 #ifndef _LINUX_SRCU_TINY_H
 #define _LINUX_SRCU_TINY_H
 
-#include <linux/irq_work_types.h>
 #include <linux/swait.h>
 
 struct srcu_struct {
@@ -25,21 +24,18 @@ struct srcu_struct {
 	struct rcu_head *srcu_cb_head;	/* Pending callbacks: Head. */
 	struct rcu_head **srcu_cb_tail;	/* Pending callbacks: Tail. */
 	struct work_struct srcu_work;	/* For driving grace periods. */
-	struct irq_work srcu_irq_work;	/* Defer schedule_work() to irq work. */
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 	struct lockdep_map dep_map;
 #endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 };
 
 void srcu_drive_gp(struct work_struct *wp);
-void srcu_tiny_irq_work(struct irq_work *irq_work);
 
 #define __SRCU_STRUCT_INIT(name, __ignored, ___ignored)			\
 {									\
 	.srcu_wq = __SWAIT_QUEUE_HEAD_INITIALIZER(name.srcu_wq),	\
 	.srcu_cb_tail = &name.srcu_cb_head,				\
 	.srcu_work = __WORK_INITIALIZER(name.srcu_work, srcu_drive_gp),	\
-	.srcu_irq_work = { .func = srcu_tiny_irq_work },		\
 	__SRCU_DEP_MAP_INIT(name)					\
 }
 
diff --git a/kernel/rcu/srcutiny.c b/kernel/rcu/srcutiny.c
index ddea40b68e5f6..4dcbf8aa80ff7 100644
--- a/kernel/rcu/srcutiny.c
+++ b/kernel/rcu/srcutiny.c
@@ -9,7 +9,6 @@
  */
 
 #include <linux/export.h>
-#include <linux/irq_work.h>
 #include <linux/mutex.h>
 #include <linux/preempt.h>
 #include <linux/rcupdate_wait.h>
@@ -38,7 +37,6 @@ static int init_srcu_struct_fields(struct srcu_struct *ssp)
 	ssp->srcu_idx_max = 0;
 	INIT_WORK(&ssp->srcu_work, srcu_drive_gp);
 	INIT_LIST_HEAD(&ssp->srcu_work.entry);
-	init_irq_work(&ssp->srcu_irq_work, srcu_tiny_irq_work);
 	return 0;
 }
 
@@ -82,7 +80,6 @@ EXPORT_SYMBOL_GPL(init_srcu_struct);
 void cleanup_srcu_struct(struct srcu_struct *ssp)
 {
 	WARN_ON(ssp->srcu_lock_nesting[0] || ssp->srcu_lock_nesting[1]);
-	irq_work_sync(&ssp->srcu_irq_work);
 	flush_work(&ssp->srcu_work);
 	WARN_ON(ssp->srcu_gp_running);
 	WARN_ON(ssp->srcu_gp_waiting);
@@ -171,20 +168,6 @@ void srcu_drive_gp(struct work_struct *wp)
 }
 EXPORT_SYMBOL_GPL(srcu_drive_gp);
 
-/*
- * Use an irq_work to defer schedule_work() to avoid acquiring the workqueue
- * pool->lock while the caller might hold scheduler locks, causing lockdep
- * splats due to workqueue_init() doing a wakeup.
- */
-void srcu_tiny_irq_work(struct irq_work *irq_work)
-{
-	struct srcu_struct *ssp;
-
-	ssp = container_of(irq_work, struct srcu_struct, srcu_irq_work);
-	schedule_work(&ssp->srcu_work);
-}
-EXPORT_SYMBOL_GPL(srcu_tiny_irq_work);
-
 static void srcu_gp_start_if_needed(struct srcu_struct *ssp)
 {
 	unsigned long cookie;
@@ -198,7 +181,7 @@ static void srcu_gp_start_if_needed(struct srcu_struct *ssp)
 	WRITE_ONCE(ssp->srcu_idx_max, cookie);
 	if (!READ_ONCE(ssp->srcu_gp_running)) {
 		if (likely(srcu_init_done))
-			irq_work_queue(&ssp->srcu_irq_work);
+			schedule_work(&ssp->srcu_work);
 		else if (list_empty(&ssp->srcu_work.entry))
 			list_add(&ssp->srcu_work.entry, &srcu_boot_list);
 	}
-- 
2.53.0



