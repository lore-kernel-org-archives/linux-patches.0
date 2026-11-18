Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059071;
	b=pAgLsaY5pZlLJ7WhQfvSWq9XC0xf/ZZyLBFBBM8C5aJBfu/ctNQo/UB75pVSo8vKLKq/
	 mZy6uLyIdobq6+nfNh3GbsQ+lUkotAIIqTxBhYbTb2J/U8YG49OrLVl+W+hRnkesOBeXf
	 QupehnFIzmsDXPprGo6FCyATK8iulNdYs5F1fPD8ZXa1AcdwOoZWvxIS5MF9e7mEVkhcc
	 gQ841O6dW1weuc4NDeI5/GjDFsPCEr8Fm0DPmGTri8ngEcR7RtSPui3HMPx9qICiUAx6g
	 aEU4RsYTJH6IumgghjbE69SKi4iEaFkzQHHHsProR7Vb7UCIr7DA6GcOlCE8DzEOWaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059071;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Yd+9v6IQo4aJYsN1VRDsFOoZIL84mTepx5uJLwO2IfI=;
	b=2FPSmZ4G7SF7dBYx/bE2Z8TQD+RqYlPc2+uV4HC6qaiDWJ3zKkM1HWk3I4AwHUEHLLZe
	 rkDVkotkLZNUPkYoy4W0yvgsC9zMSWCIoFE/I/TSFcTHEIIXkP1UfFJdPtkOOotrqYm3+
	 rIkrJtn6d43qT0vCgsGfQrhPKn0s2o1QvtuIuzT7XrSIw4AnrxfGGKh6spv71I1E7Fb5Q
	 PWrYOLRut+0TtyIpfxGWWbxMNgrRSUaoMmONr0QPdA6W1epXeKKv4cNSOwBi9B1xFZ7Zf
	 Nn8nMtWSlQXAPG2nVMo3fhRVPmyThkmd4ukDJ59zfa9j5cCvHuiwukel1C4e2ylCR9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q+jrN3tI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF36606A32F;
	Thu, 19 Nov 2026 03:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q+jrN3tI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC2AB1F000C4;
	Thu, 19 Nov 2026 03:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059071;
	bh=Yd+9v6IQo4aJYsN1VRDsFOoZIL84mTepx5uJLwO2IfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q+jrN3tIBzX1rfvFACGNEAUZ1GDXJwPnPc473wXyJZnK2fAT+aT/zQjVg2MXIOBrn
	 6nk3OgwKoeBraZc+qGMjNMQacwvA5IX6x5O2LvDLCBWIupwmbQfmlSYLEFHz5FNOhm
	 yCBcbkDbyyT5/v+viuN5VOch2mykSQENWDDAUlCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Patel <ripatel@wii.dev>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0669/1848] genirq: Move interrupt thread exit_work object to irqaction
Date: Wed, 18 Nov 2026 15:45:07 +0100
Message-ID: <20261118145943.882520285@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 4994465ad1d9c..3b85bebd82d5e 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -110,6 +110,7 @@ typedef irqreturn_t (*irq_handler_t)(int, void *);
  * @thread_flags:	flags related to @thread
  * @thread_mask:	bitmask for keeping track of @thread activity
  * @dir:	pointer to the proc/irq/NN/name entry
+ * @thread_dtor:	task_work for @thread irregular exit cleanup
  */
 struct irqaction {
 	irq_handler_t		handler;
@@ -125,6 +126,7 @@ struct irqaction {
 	unsigned long		thread_mask;
 	const char		*name;
 	struct proc_dir_entry	*dir;
+	struct callback_head	thread_dtor;
 } ____cacheline_internodealigned_in_smp;
 
 extern irqreturn_t no_action(int cpl, void *dev_id);
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index bcd5780b2f513..066af7a5522e8 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1250,9 +1250,9 @@ static void __irq_thread_dtor(struct irqaction *action)
 	irq_finalize_oneshot(desc, action);
 }
 
-static void irq_thread_dtor(struct callback_head *unused)
+static void irq_thread_dtor(struct callback_head *work)
 {
-	struct irqaction *action = kthread_data(current);
+	struct irqaction *action = container_of(work, struct irqaction, thread_dtor);
 
 	__irq_thread_dtor(action);
 	clear_and_wake_up_bit(IRQTF_EXIT_WORK, &action->thread_flags);
@@ -1300,7 +1300,6 @@ static void wake_up_and_wait_for_irq_thread_ready(struct irq_desc *desc,
  */
 static int irq_thread(void *data)
 {
-	struct callback_head on_exit_work;
 	struct irqaction *action = data;
 	struct irq_desc *desc = irq_to_desc(action->irq);
 	irqreturn_t (*handler_fn)(struct irq_desc *desc,
@@ -1315,8 +1314,8 @@ static int irq_thread(void *data)
 		handler_fn = irq_thread_fn;
 
 	set_bit(IRQTF_EXIT_WORK, &action->thread_flags);
-	init_task_work(&on_exit_work, irq_thread_dtor);
-	task_work_add(current, &on_exit_work, TWA_NONE);
+	init_task_work(&action->thread_dtor, irq_thread_dtor);
+	task_work_add(current, &action->thread_dtor, TWA_NONE);
 
 	irq_thread_check_affinity(desc, action);
 
-- 
2.53.0



