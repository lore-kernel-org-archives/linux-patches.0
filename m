Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053184;
	b=IxngACsaAYgZCuuiWh3wKHJ6kRj3MBbav4cn3Z0D6LUz5lbyfeQVBMV5XtVbUGpBEQI1
	 nf7qXMRXd5KEWD8VmAzQJ+8G7Sg6DgY9in5SbW9qSYyVZecbDvl8EbVqqdKlIDqfvEuSK
	 9nhq+Q2Qiptux5avzBdlQJEN8CSboGc1UyM0BxOEQsplVQ4wmxBO97XrZWXiTJrCRGni3
	 ckZKqnPAwbsZGD/BJu0bjSEI8FAZnDPEHGi+H/YremZZZ+Og1IZL8+vxzjfxgU9PFpxZO
	 EVgXA67jLgJwNqCUso8I43Ny08RXm15mYbxSGyXe6n7Lb8Zp8AeUGv+9pZKXCh8wjzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053184;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YDm/2X7qnwu2UsshpSuA931lRvQgJYllAQP2OZsqi7w=;
	b=2MORAxlafgYKDzAjFCZGl4IGywkKYAdNt7suDELBp0zgHDWGlu3enuRD275pUK9ymSXg
	 8yOCSeFSJjrcLgnJCbFcxf1Y4po5KqKyqo0JhdP91G3mwr98U5CZI8O3MIrtAOz0Bd29j
	 HftvFhC9DjnTHnvsxsPUYKNbqgTPeoXxebAD+o7P3ZmmOo6Xl1TM0jZR4+K/B269Frw8L
	 5wlVPqxToSnEdIxF6xRAMiozDNu0JI1R/9AD8TOLUFgUGLXoy3gQKtwF5mT7LBaMQugoo
	 tnOcv9X/+9vbcitwIYPnBqpwSgAa5dUGyhzFon8dtUdyCNG4xzbkAAfQZtjGeaNCNqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B62BHXAB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A4AE606A320;
	Thu, 19 Nov 2026 01:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B62BHXAB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAA491F000C4;
	Thu, 19 Nov 2026 01:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053184;
	bh=YDm/2X7qnwu2UsshpSuA931lRvQgJYllAQP2OZsqi7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B62BHXABEi+/FxDV/YD+jzR6Sio8MxfqSAhW+dp9smA0AtPkzNd6+wVm/BGDYJiel
	 BtBpMrKe3q+QRjpNY3Qq0l0VnQxP6k0aJ8mMXotOJrSb4vQ1B0bwEXiYvCgOrHTOVA
	 1C1GXbwxHzGU1M8lLLUt1ZW0VFq3s67d0nZ7t8ZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Patel <ripatel@wii.dev>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0827/2214] genirq: Move interrupt thread exit_work object to irqaction
Date: Wed, 18 Nov 2026 15:41:43 +0100
Message-ID: <20261118150044.984003957@linuxfoundation.org>
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

[ Upstream commit 89a9e003a2ef73f67dff03dfd59e0a5474b56b0b ]

irq_thread() registers irq_thread_dtor() as exit task_work using a
stack-allocated callback_head.  On normal interrupt thread exit, this work
gets cancelled and never runs.

On x86, an abnormal interrupt thread exit (e.g. handler oops) discards the
stack, including the callback_head, while that callback_head is still
pending. By the time exit_task_work() runs, the stack memory formerly
backing callback_head is already clobbered.

  irq_thread()                      <-- on_exit_work allocated
    ** IRQ handler faults **
    oops_end()
      rewind_stack_and_make_dead()  <-- on_exit_work freed
  make_task_dead()
    do_exit(SIGSEGV)
      ...
      exit_shm()                    <-- on_exit_work clobbered
      ...
      exit_task_work()              <-- stack use-after-free
        exit_shm()+0x30             <-- wild jump to return addr

Thus, a benign threaded IRQ oops (e.g. a NULL pointer deref) is
turned into a wild jump. This is caught by kernel IBT:

  ** first fault **
  Oops: general protection fault, kernel NULL pointer dereference 0x3c0: 0000 [#1] SMP NOPTI
  ...
  ** second fault **
  Missing ENDBR: exit_shm+0x30/0x1c0
  kernel BUG at arch/x86/kernel/cet.c:133!
  ...
   ? task_work_run+0x5c/0x90
   ? do_exit+0x209/0x460
   ? rewind_stack_and_make_dead+0x16/0x20
  ...
  note: irq/165-AudioDS[1427] exited with irqs disabled
  Fixing recursive fault but reboot is needed!

Fix this by storing the callback_head in struct irqaction.  The irqaction
is only freed once irq_thread_dtor() finishes.

Fixes: 2deb4be28077 ("x86/dumpstack: When OOPSing, rewind the stack before do_exit()")
Signed-off-by: Richard Patel <ripatel@wii.dev>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261009145842.1616117-3-ripatel@wii.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/interrupt.h | 2 ++
 kernel/irq/manage.c       | 9 ++++-----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 5c4ba2ee582a9..920dc7693e5ce 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -114,6 +114,7 @@ typedef irqreturn_t (*irq_handler_t)(int, void *);
  * @thread_flags:	flags related to @thread
  * @thread_mask:	bitmask for keeping track of @thread activity
  * @dir:	pointer to the proc/irq/NN/name entry
+ * @thread_dtor:	task_work for @thread irregular exit cleanup
  */
 struct irqaction {
 	irq_handler_t		handler;
@@ -129,6 +130,7 @@ struct irqaction {
 	unsigned long		thread_mask;
 	const char		*name;
 	struct proc_dir_entry	*dir;
+	struct callback_head	thread_dtor;
 } ____cacheline_internodealigned_in_smp;
 
 extern irqreturn_t no_action(int cpl, void *dev_id);
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 87f8ed44ca870..a9401080cf519 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1249,9 +1249,9 @@ static void __irq_thread_dtor(struct irqaction *action)
 	irq_finalize_oneshot(desc, action);
 }
 
-static void irq_thread_dtor(struct callback_head *unused)
+static void irq_thread_dtor(struct callback_head *work)
 {
-	struct irqaction *action = kthread_data(current);
+	struct irqaction *action = container_of(work, struct irqaction, thread_dtor);
 
 	__irq_thread_dtor(action);
 	clear_and_wake_up_bit(IRQTF_EXIT_WORK, &action->thread_flags);
@@ -1299,7 +1299,6 @@ static void wake_up_and_wait_for_irq_thread_ready(struct irq_desc *desc,
  */
 static int irq_thread(void *data)
 {
-	struct callback_head on_exit_work;
 	struct irqaction *action = data;
 	struct irq_desc *desc = irq_to_desc(action->irq);
 	irqreturn_t (*handler_fn)(struct irq_desc *desc,
@@ -1314,8 +1313,8 @@ static int irq_thread(void *data)
 		handler_fn = irq_thread_fn;
 
 	set_bit(IRQTF_EXIT_WORK, &action->thread_flags);
-	init_task_work(&on_exit_work, irq_thread_dtor);
-	task_work_add(current, &on_exit_work, TWA_NONE);
+	init_task_work(&action->thread_dtor, irq_thread_dtor);
+	task_work_add(current, &action->thread_dtor, TWA_NONE);
 
 	irq_thread_check_affinity(desc, action);
 
-- 
2.53.0



