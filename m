Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052180;
	b=vUk/PK0UNcQXpSkZ+6HTQuioPJdHKCeSHOB5aJEDOeBLz5Aw8Aol29OJi6IPr5b0KPmM
	 ijWnwQ3TcQUbGqMp+u9cyP33tBiHNabImChuu3VxkwiIBp4QEAZX5TfRBX2KtNZujuKqB
	 O4KqdOaz6jVGl1k0qRSDWC08loUhUFngs7UPJj2dBqEEb/Nh7Q9igBtdk5iG4xpO5Wodr
	 rXKh6sKulJU2uHN5A9/RNTy+uQmkVCoB8U+9BPJQ5Fs0uT1Mwl6xOhMHKHg63iZLPRhfn
	 K90kazywQ/FwyXuAU2ue0XXBN8idoUaZptWO5sTjUQpkGopBIru1vdMNAC726re9c+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052180;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=++/gCQYaGxgqJsxHuIZUGAsNJ63+Gn9FGtt98k4D01I=;
	b=sIr9vgIL+oKwKXAF2x8fLIsHE8qgvChtatG0mToZLLiy2x7A6ECMohXi4SU+DpgOlHGx
	 +wB0tZygyeIzMqV3RWoPR+XaEn4XiL4ScYosCT5hYyH6Fk7cy1hWBEJKz0EALVmZAwtLT
	 IUiftp738gcQDTyVQSy/Lv7yGVPjl3vBUmra69PxDf9ZFrRabTjRb89s6O7ZENhYmzdFi
	 TtkmAQzI378zmYjYL+XiaQHo90b2KLOW2CGwlL57vB1UIqRWAK4EY3iUicvNu4xdsjfBi
	 ThQWxg+Nautc9YqV1yEah/xxJ8smwJZ0StaK/ItNece3KCsUUqVUYSGxLXejGU18DjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BlmHcEnc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30898606A31C;
	Thu, 19 Nov 2026 01:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BlmHcEnc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82A811F000C7;
	Thu, 19 Nov 2026 01:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052180;
	bh=++/gCQYaGxgqJsxHuIZUGAsNJ63+Gn9FGtt98k4D01I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BlmHcEnc++RLq4dHnH9DZ/uIBmfkqqKpfkj0tFn8WL+GG+jaHj/AXHfW2sIxDYNRz
	 X7HErNRwNzKDeSpr2pYq0wKm3DfnaRDGLXfhqkH11FhMxkx3vjS+w1864OxVld0JwP
	 KA4Ipayu87GtSq+Oia+94LnpwZPA2jM6jJbZWkNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Patel <ripatel@wii.dev>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0422/2214] genirq: Defer kfree(irqaction) until irq_thread_dtor() finishes
Date: Wed, 18 Nov 2026 15:34:58 +0100
Message-ID: <20261118150027.743645243@linuxfoundation.org>
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

From: Richard Patel <ripatel@wii.dev>

[ Upstream commit d04adff6860587e843948b0c31174f8ae11b8dfe ]

When an interrupt thread exits abnormally via do_exit() (e.g. the interrupt
handler oopses) without returning from irq_thread(), a concurrent call to
free_irq() could free the irqaction before the irq_thread_dtor() exit task
work runs.

  irq thread (oopsed)                 free_irq()
  -------------------                 ----------
  do_exit()
    exit_mm()
      complete_vfork_done()  -------> kthread_stop() returns
    exit_files() ...                  kfree(action)
    exit_task_work()
      irq_thread_dtor()
        action->...                   <- use-after-free

Track the pending exit work with the IRQTF_EXIT_WORK thread flag, and have
__free_irq() wait for the bit to clear before kfree().

irq_thread_dtor() only runs on irq_thread abnormal exit. If that dtor also
faults, free_irq() will hang indefinitely, but double IRQ thread faults
require a reboot anyways.

[ tglx: Add missing include ]

Fixes: ed3e694d78cc ("move exit_task_work() past exit_files() et.al.")
Signed-off-by: Richard Patel <ripatel@wii.dev>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261009145842.1616117-2-ripatel@wii.dev
[ sashal: Replaced kthread_stop_put() with separate kthread_stop() and put_task_struct() calls. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/irq/internals.h |  2 ++
 kernel/irq/manage.c    | 32 ++++++++++++++++++++++----------
 2 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index da1f282d5a1d1..e9531706a91ae 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -30,6 +30,7 @@ extern struct irqaction chained_action;
  * IRQTF_AFFINITY  - irq thread is requested to adjust affinity
  * IRQTF_FORCED_THREAD  - irq action is force threaded
  * IRQTF_READY     - signals that irq thread is ready
+ * IRQTF_EXIT_WORK - irq thread exit task_work is pending
  */
 enum {
 	IRQTF_RUNTHREAD,
@@ -37,6 +38,7 @@ enum {
 	IRQTF_AFFINITY,
 	IRQTF_FORCED_THREAD,
 	IRQTF_READY,
+	IRQTF_EXIT_WORK,
 };
 
 /*
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index ce0433446a8ed..87f8ed44ca870 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -21,6 +21,7 @@
 #include <linux/sched/isolation.h>
 #include <uapi/linux/sched/types.h>
 #include <linux/task_work.h>
+#include <linux/wait_bit.h>
 
 #include "internals.h"
 
@@ -1224,17 +1225,14 @@ static void wake_threads_waitq(struct irq_desc *desc)
 		wake_up(&desc->wait_for_threads);
 }
 
-static void irq_thread_dtor(struct callback_head *unused)
+static void __irq_thread_dtor(struct irqaction *action)
 {
 	struct task_struct *tsk = current;
 	struct irq_desc *desc;
-	struct irqaction *action;
 
 	if (WARN_ON_ONCE(!(current->flags & PF_EXITING)))
 		return;
 
-	action = kthread_data(tsk);
-
 	pr_err("exiting task \"%s\" (%d) is an active IRQ thread (irq %d)\n",
 	       tsk->comm, tsk->pid, action->irq);
 
@@ -1251,6 +1249,14 @@ static void irq_thread_dtor(struct callback_head *unused)
 	irq_finalize_oneshot(desc, action);
 }
 
+static void irq_thread_dtor(struct callback_head *unused)
+{
+	struct irqaction *action = kthread_data(current);
+
+	__irq_thread_dtor(action);
+	clear_and_wake_up_bit(IRQTF_EXIT_WORK, &action->thread_flags);
+}
+
 static void irq_wake_secondary(struct irq_desc *desc, struct irqaction *action)
 {
 	struct irqaction *secondary = action->secondary;
@@ -1307,6 +1313,7 @@ static int irq_thread(void *data)
 	else
 		handler_fn = irq_thread_fn;
 
+	set_bit(IRQTF_EXIT_WORK, &action->thread_flags);
 	init_task_work(&on_exit_work, irq_thread_dtor);
 	task_work_add(current, &on_exit_work, TWA_NONE);
 
@@ -1331,6 +1338,7 @@ static int irq_thread(void *data)
 	 * oneshot mask bit can be set.
 	 */
 	task_work_cancel_func(current, irq_thread_dtor);
+	clear_and_wake_up_bit(IRQTF_EXIT_WORK, &action->thread_flags);
 	return 0;
 }
 
@@ -1867,6 +1875,13 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 	return ret;
 }
 
+static void irq_stop_thread(struct irqaction *action)
+{
+	kthread_stop(action->thread);
+	put_task_struct(action->thread);
+	wait_on_bit(&action->thread_flags, IRQTF_EXIT_WORK, TASK_UNINTERRUPTIBLE);
+}
+
 /*
  * Internal function to unregister an irqaction - used to free
  * regular and special interrupts that are part of the architecture.
@@ -1971,12 +1986,9 @@ static struct irqaction *__free_irq(struct irq_desc *desc, void *dev_id)
 	 * the same bit to a newly requested action.
 	 */
 	if (action->thread) {
-		kthread_stop(action->thread);
-		put_task_struct(action->thread);
-		if (action->secondary && action->secondary->thread) {
-			kthread_stop(action->secondary->thread);
-			put_task_struct(action->secondary->thread);
-		}
+		irq_stop_thread(action);
+		if (action->secondary && action->secondary->thread)
+			irq_stop_thread(action->secondary);
 	}
 
 	/* Last action releases resources */
-- 
2.53.0



