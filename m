Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210219;
	b=uK0sa0cUfYtI3987JL/+SEutu7x5bb0PgcTlmhiNGP93OhkMiIbWBEMMqr+lAbdrp1HX
	 MGVAQL1NLy26MWToII6pes+wmizdsPlNdYYWnSDEIpsn0IYP/yGBYpf4IjcT7BuepJ+pm
	 /o6JYaz9jfrxBCmEzSex8cANU6Ou1tg5DtNvsPlLbGErmzM9TS2vkP2d2HbuLV/Y5Se+O
	 CJi3z023rEyWfvcKjgKRB/gzqdDlE4csn7V/CFvXw0R6ywKVQN1fdvSg2xyRW2fUrpIyl
	 xWpGv+FmRxSzKbR+sGwcbFVCIQJAz83v3i86cNJ0BHcFuEI5tou6feuRyVY1QGVGohA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210219;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VqPmwYcZzDl4XUWD6P+RLk6Fkh/xiXKqE7yDAqUmJRk=;
	b=jq6f3i+LzZH6E2DbLp3pHIpR5fbyClCHJHrVKP8YG2fyU9PV7hkLaLngKhGLtzJOHulU
	 Q6P2ltqX53e+AFMWGyMw0UwQPYhkxcSe4Fm3aNQrbKMpE3HbXkfbmUBHBseom8Bu4ObUl
	 qBow7CMXq6DNcoPjITLBj+9AYDvAY4H9HTicIoUvd0u3jwkytQve+JL9gVbUNhKu1Z2KE
	 zMubtQnHiWdhuUaMsGuPHoQx59xveJ3rsX5QMKeRLNi0jISmCLjxNs2m8iNOY6+HKhtZD
	 faARpaBtDuydxFnLvu76+TwmbWFvHLgNeeaYx/xvjPdF564UJaVfoZ4/8IiLAOmZ9JA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mzxih3F+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D081A606A31A;
	Wed, 28 Oct 2026 17:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mzxih3F+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6B641F01828;
	Wed, 28 Oct 2026 17:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210218;
	bh=VqPmwYcZzDl4XUWD6P+RLk6Fkh/xiXKqE7yDAqUmJRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mzxih3F+xJ6c1ztF7sXir9QzAs/v/VIqc9DhA3QzG7BSwuvyZ5uEN4UHeyT9CeksX
	 Epvh49B63ijvuaFK4Hp5YhamiDzY8YZVu1PrHG/TK/SeWhPLdajfBL+wB8kqdvFxUQ
	 oyyKomgcgcAyBGinG0OsAnPq+y47fLvRQwhyOHgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 118/168] Revert "srcu: Use irq_work to start GP in tiny SRCU"
Date: Wed, 28 Oct 2026 18:00:54 +0100
Message-ID: <20261028165945.881914469@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit 20b98d9ffb09763048a7c84b47403eb0f177272c.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/49da816c-8082-46f1-bb12-f0d6187bb06a@roeck-us.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/srcutiny.h |  4 ----
 kernel/rcu/srcutiny.c    | 19 +------------------
 2 files changed, 1 insertion(+), 22 deletions(-)

diff --git a/include/linux/srcutiny.h b/include/linux/srcutiny.h
index bad5fd0f1ddb6..447133171d95f 100644
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
index 24aa302b3269a..c38e5933a5d69 100644
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
@@ -159,20 +156,6 @@ void srcu_drive_gp(struct work_struct *wp)
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
@@ -183,7 +166,7 @@ static void srcu_gp_start_if_needed(struct srcu_struct *ssp)
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



