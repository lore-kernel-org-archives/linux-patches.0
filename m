Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 323F4363C6F;
	Sat, 12 Sep 2026 16:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230264; cv=none; b=Gth0K+lQkt+KLjpvL40T+G0lluoPVGqi2XaYaQIMt6TT9GTb/D6nODPoFgeb7PKsxqVQqAhEEjqt4iKSyvc3VHJFnKKfvL0yAslgdgHQkEcUBPfztz7kEVagUpa4Ban7B32Kp3HZpafWaY+g9L70C94mAX+JXydw4SCaxMbPgp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230264; c=relaxed/simple;
	bh=otgFFe10ADtbYB6eBtMFl03AYpiyuJ/821TosXEwaz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uIzTqGCGre/mojdnCaYgmfefDx2FolUa3m1b0HcR8yjWY98N3/bfFigHEDsADLA/1BQsrMIZvUmu11mVVB0QvGZnVfRbylczP0XOThVRSqcCJnMRVS1SwAzlVqzEiIxpykDD3ypBexFEtiEA657nnELIkMV20N1kGhCzyr4J7NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lq0bjOTz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lq0bjOTz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0481A1F00893;
	Sat, 12 Sep 2026 16:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230263;
	bh=lU04tm9NWSJDxmbFG/t7jcaWZAD6XEkPJFzZI9/GAUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lq0bjOTzdQHiBkGgNKuRW4GksgTAYw+Ypo/mnzGteFsw6b2viuijH7DwPlneMXDBa
	 Kfnu73623LOP1QmeZWxeD1C3ArTQ8O53AbqguJTkeaxY5HKaOaxUFBGCQb6oRlt1lH
	 SZat848J0fYhsnOV4pP+u1ecS8DgW6kyZCzNcmOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Valentin Schneider <vschneid@redhat.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0758/1191] rcu: Rename rcu_momentary_dyntick_idle() into rcu_momentary_eqs()
Date: Sat, 12 Sep 2026 08:58:06 +0200
Message-ID: <20260912065605.302464274@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Valentin Schneider <vschneid@redhat.com>

[ Upstream commit 32a9f26e5e266f0116cc8536e5e4544523ddd334 ]

The context_tracking.state RCU_DYNTICKS subvariable has been renamed to
RCU_WATCHING, replace "dyntick_idle" into "eqs" to drop the dyntick
reference.

Signed-off-by: Valentin Schneider <vschneid@redhat.com>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Neeraj Upadhyay <neeraj.upadhyay@kernel.org>
Stable-dep-of: 27d73e81195b ("rcu: Mark accesses to ->rcu_urgent_qs and ->rcu_need_heavy_qs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/rcutiny.h      | 2 +-
 include/linux/rcutree.h      | 2 +-
 kernel/rcu/rcutorture.c      | 4 ++--
 kernel/rcu/tree.c            | 4 ++--
 kernel/rcu/tree_nocb.h       | 2 +-
 kernel/rcu/tree_plugin.h     | 6 +++---
 kernel/stop_machine.c        | 2 +-
 kernel/trace/trace_osnoise.c | 4 ++--
 8 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index 768196a5f39d6..2780a9e69ba90 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -162,7 +162,7 @@ static inline void rcu_scheduler_starting(void) { }
 static inline void rcu_end_inkernel_boot(void) { }
 static inline bool rcu_inkernel_boot_has_ended(void) { return true; }
 static inline bool rcu_is_watching(void) { return true; }
-static inline void rcu_momentary_dyntick_idle(void) { }
+static inline void rcu_momentary_eqs(void) { }
 static inline void kfree_rcu_scheduler_running(void) { }
 static inline bool rcu_gp_might_be_stalled(void) { return false; }
 
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index dd68a841dcbd9..e0711134a9c4d 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -36,7 +36,7 @@ void synchronize_rcu_expedited(void);
 void kvfree_call_rcu(struct rcu_head *head, rcu_callback_t func);
 
 void rcu_barrier(void);
-void rcu_momentary_dyntick_idle(void);
+void rcu_momentary_eqs(void);
 void kfree_rcu_scheduler_running(void);
 bool rcu_gp_might_be_stalled(void);
 
diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index c14517912cfaa..f6c67d3b68714 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -2596,7 +2596,7 @@ static unsigned long rcu_torture_fwd_prog_cbfree(struct rcu_fwd *rfp)
 		rcu_torture_fwd_prog_cond_resched(freed);
 		if (tick_nohz_full_enabled()) {
 			local_irq_save(flags);
-			rcu_momentary_dyntick_idle();
+			rcu_momentary_eqs();
 			local_irq_restore(flags);
 		}
 	}
@@ -2746,7 +2746,7 @@ static void rcu_torture_fwd_prog_cr(struct rcu_fwd *rfp)
 		rcu_torture_fwd_prog_cond_resched(n_launders + n_max_cbs);
 		if (tick_nohz_full_enabled()) {
 			local_irq_save(flags);
-			rcu_momentary_dyntick_idle();
+			rcu_momentary_eqs();
 			local_irq_restore(flags);
 		}
 	}
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 38ab28a53e108..d39d7efdaf798 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -348,7 +348,7 @@ bool rcu_dynticks_zero_in_eqs(int cpu, int *vp)
  *
  * The caller must have disabled interrupts and must not be idle.
  */
-notrace void rcu_momentary_dyntick_idle(void)
+notrace void rcu_momentary_eqs(void)
 {
 	int seq;
 
@@ -358,7 +358,7 @@ notrace void rcu_momentary_dyntick_idle(void)
 	WARN_ON_ONCE(!(seq & RCU_DYNTICKS_IDX));
 	rcu_preempt_deferred_qs(current);
 }
-EXPORT_SYMBOL_GPL(rcu_momentary_dyntick_idle);
+EXPORT_SYMBOL_GPL(rcu_momentary_eqs);
 
 /**
  * rcu_is_cpu_rrupt_from_idle - see if 'interrupted' from idle
diff --git a/kernel/rcu/tree_nocb.h b/kernel/rcu/tree_nocb.h
index 2f501de7bec9d..a22988233b1d0 100644
--- a/kernel/rcu/tree_nocb.h
+++ b/kernel/rcu/tree_nocb.h
@@ -821,7 +821,7 @@ static void nocb_cb_wait(struct rcu_data *rdp)
 
 
 	local_irq_save(flags);
-	rcu_momentary_dyntick_idle();
+	rcu_momentary_eqs();
 	local_irq_restore(flags);
 	/*
 	 * Disable BH to provide the expected environment.  Also, when
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 6fc1ff14bfdfc..4996125222b04 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -871,7 +871,7 @@ static void rcu_qs(void)
 
 /*
  * Register an urgently needed quiescent state.  If there is an
- * emergency, invoke rcu_momentary_dyntick_idle() to do a heavy-weight
+ * emergency, invoke rcu_momentary_eqs() to do a heavy-weight
  * dyntick-idle quiescent state visible to other CPUs, which will in
  * some cases serve for expedited as well as normal grace periods.
  * Either way, register a lightweight quiescent state.
@@ -891,7 +891,7 @@ void rcu_all_qs(void)
 	this_cpu_write(rcu_data.rcu_urgent_qs, false);
 	if (unlikely(raw_cpu_read(rcu_data.rcu_need_heavy_qs))) {
 		local_irq_save(flags);
-		rcu_momentary_dyntick_idle();
+		rcu_momentary_eqs();
 		local_irq_restore(flags);
 	}
 	rcu_qs();
@@ -911,7 +911,7 @@ void rcu_note_context_switch(bool preempt)
 		goto out;
 	this_cpu_write(rcu_data.rcu_urgent_qs, false);
 	if (unlikely(raw_cpu_read(rcu_data.rcu_need_heavy_qs)))
-		rcu_momentary_dyntick_idle();
+		rcu_momentary_eqs();
 out:
 	rcu_tasks_qs(current, preempt);
 	trace_rcu_utilization(TPS("End context switch"));
diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index cedb17ba158a9..da821ce258ea7 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -251,7 +251,7 @@ static int multi_cpu_stop(void *data)
 			 */
 			touch_nmi_watchdog();
 		}
-		rcu_momentary_dyntick_idle();
+		rcu_momentary_eqs();
 	} while (curstate != MULTI_STOP_EXIT);
 
 	local_irq_restore(flags);
diff --git a/kernel/trace/trace_osnoise.c b/kernel/trace/trace_osnoise.c
index 366d8c288f5fa..368d2ffed2f14 100644
--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -1438,7 +1438,7 @@ static int run_osnoise(void)
 		 * This will eventually cause unwarranted noise as PREEMPT_RCU
 		 * will force preemption as the means of ending the current
 		 * grace period. We avoid this problem by calling
-		 * rcu_momentary_dyntick_idle(), which performs a zero duration
+		 * rcu_momentary_eqs(), which performs a zero duration
 		 * EQS allowing PREEMPT_RCU to end the current grace period.
 		 * This call shouldn't be wrapped inside an RCU critical
 		 * section.
@@ -1450,7 +1450,7 @@ static int run_osnoise(void)
 			if (!disable_irq)
 				local_irq_disable();
 
-			rcu_momentary_dyntick_idle();
+			rcu_momentary_eqs();
 
 			if (!disable_irq)
 				local_irq_enable();
-- 
2.53.0



