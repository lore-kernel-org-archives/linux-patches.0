Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061558;
	b=e3zqpvV1vj8x1u0vU3X28MmjiA9rAwgXTn1blps02tvARrMx22XHeHFQfYVStdeG3JU1
	 PbBH6cJ3IcQpGSpGhm6yHyxriC0hUkTHv7lX3zxAYORVoeqOU3Naflo/VOY8VROYBrRrQ
	 i8BthgcWhD+OcCqdjoI7UDWSqs1hTO16NJWisxSegfX8BaE2UXSatisCLSGJQfSTq/gju
	 RB3gLXrR7v8Fp6RNG5DVCX49A+6nv+T781EVo3flku+RZyqEPr/JWiH3LbsfLPxmwnVcW
	 EhSSgcSLUvU70JHU7OLY5STImiBlw18ZWA7Vz5KBpSq1Rt+5b1lk4fMjNt3kJ+iJKhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061558;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gIOUAa5DNlm8wfJh2d1fOKSfvgNe7h8u9TIMfdNObeU=;
	b=OyxnAvsvfHIRVcz+TWgqAfc/9HnhsM4m7Wo5f33QfZandWILjelm0qup/z6mXouqgXOb
	 QOQUJx/0VjGzAbd3oGLiOViIGKMZF0kvAbSzmWBOhPuiuDm1hT7qWr1Q+dSl6YM/PL9Xw
	 7wPbj3ND6d8J6noBqSUamS+kDreZEu9zKpjgh9rFEFWkIa62XCOm9Fw9u0NClehwasd9k
	 ved2fvGj/LeD2uBjxwxA2SnhGLoGm326ieyj+pCeF2/93ikjL4Fwh/3+cNEk8tKPZm8B/
	 PivDOErkk2kGcxCOCF9xK9ZuRT/T6RN9kfBocr7sgPbJ10aKpeUdXxuViOnowFnmWeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sEm5HduB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E75B6606A32F;
	Sat,  7 Nov 2026 14:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sEm5HduB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 908781F008A1;
	Sat,  7 Nov 2026 14:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061557;
	bh=gIOUAa5DNlm8wfJh2d1fOKSfvgNe7h8u9TIMfdNObeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sEm5HduBXk7GN9seUjT2zY6Ok4CsocAF3x5JFPFJl3tI5nRooLJL4ZMbgSNFEcYen
	 d15iosIRtI3u13aeTbILOjZOIj8ihiaJwlonqQMmQ+VyfNrMHJ8UqKatTEg83n9afP
	 wT0Nr4IwspcPj3ZjVDIlYXS/GIdI0WMK8fV2vi68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Patel <ripatel@wii.dev>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 6.12 0639/1536] genirq: Move interrupt thread exit_work object to irqaction
Date: Sat,  7 Nov 2026 08:44:15 -0500
Message-ID: <20261107135015.479803595@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Richard Patel <ripatel@wii.dev>

commit 89a9e003a2ef73f67dff03dfd59e0a5474b56b0b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/interrupt.h |    2 ++
 kernel/irq/manage.c       |    9 ++++-----
 2 files changed, 6 insertions(+), 5 deletions(-)

--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -118,6 +118,7 @@ typedef irqreturn_t (*irq_handler_t)(int
  * @thread_flags:	flags related to @thread
  * @thread_mask:	bitmask for keeping track of @thread activity
  * @dir:	pointer to the proc/irq/NN/name entry
+ * @thread_dtor:	task_work for @thread irregular exit cleanup
  */
 struct irqaction {
 	irq_handler_t		handler;
@@ -133,6 +134,7 @@ struct irqaction {
 	unsigned long		thread_mask;
 	const char		*name;
 	struct proc_dir_entry	*dir;
+	struct callback_head	thread_dtor;
 } ____cacheline_internodealigned_in_smp;
 
 extern irqreturn_t no_action(int cpl, void *dev_id);
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1255,9 +1255,9 @@ static void __irq_thread_dtor(struct irq
 	irq_finalize_oneshot(desc, action);
 }
 
-static void irq_thread_dtor(struct callback_head *unused)
+static void irq_thread_dtor(struct callback_head *work)
 {
-	struct irqaction *action = kthread_data(current);
+	struct irqaction *action = container_of(work, struct irqaction, thread_dtor);
 
 	__irq_thread_dtor(action);
 	clear_and_wake_up_bit(IRQTF_EXIT_WORK, &action->thread_flags);
@@ -1305,7 +1305,6 @@ static void wake_up_and_wait_for_irq_thr
  */
 static int irq_thread(void *data)
 {
-	struct callback_head on_exit_work;
 	struct irqaction *action = data;
 	struct irq_desc *desc = irq_to_desc(action->irq);
 	irqreturn_t (*handler_fn)(struct irq_desc *desc,
@@ -1322,8 +1321,8 @@ static int irq_thread(void *data)
 		handler_fn = irq_thread_fn;
 
 	set_bit(IRQTF_EXIT_WORK, &action->thread_flags);
-	init_task_work(&on_exit_work, irq_thread_dtor);
-	task_work_add(current, &on_exit_work, TWA_NONE);
+	init_task_work(&action->thread_dtor, irq_thread_dtor);
+	task_work_add(current, &action->thread_dtor, TWA_NONE);
 
 	while (!irq_wait_for_interrupt(desc, action)) {
 		irqreturn_t action_ret;


