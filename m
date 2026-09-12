Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A945475F;
	Sat, 12 Sep 2026 14:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224173; cv=none; b=pj7IacmiS+q8GAV0rjhyXaTtEaeQAJ5fd57AShfviNXGWJHvbekMe2objz9aHzj7L4nhSUhseYlR0uAm6s4ElqacyGH28qQlTQBXDRHb4lbTiMjQnxpmZmGDHWo9u0bdyorFR9nKGrQlKagU7fjzIpAlOg8xiBkWubqOA7THxvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224173; c=relaxed/simple;
	bh=9+cZRF8ScH5cePClp/95I2wekJwTkbiOolneM9G6+Uk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nilpa35zAlN7XS1KQbTV8+u8eQjp1UrNEyJXylV9Rb6kFOcWhYRY2m0ESOW3pPzjGRbuFTTQtt93J/reuUAKXchnFuOt7y1cOWgWp6hH1mcYe1EiSveIL3cLSjnkWdgoUstyxBcMfdATFhD4Vp1Oi1oiapL1gJFxpWwHiRtXVCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eV9NHipU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eV9NHipU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E81941F000FF;
	Sat, 12 Sep 2026 14:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224172;
	bh=amNBgQ4xrBzf6SkA5XGUFFk0Rcsh2wwrFRZZJWnHFiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eV9NHipUnbsVtLzqT55/rsOAIEorexITTZrXi48Z0YpxciLTfJErYF0OBfhFIc28U
	 IuOypB2OdcNe2+6xUv2tSJ+PSH37X/rHpXGhOtkWLTNTigZ8+wiDsPDQ7MV9ZQFo+A
	 JpKZCMlNZEbxW9BaNR8IrIN1kZ9A8W6wmrCcrMBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Valentin Schneider <vschneid@redhat.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0938/1424] rcu: Rename rcu_momentary_dyntick_idle() into rcu_momentary_eqs()
Date: Sat, 12 Sep 2026 08:56:10 +0200
Message-ID: <20260912065628.327940036@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
index 7b949292908a9..e0a3a12380e5d 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -158,7 +158,7 @@ void rcu_scheduler_starting(void);
 static inline void rcu_end_inkernel_boot(void) { }
 static inline bool rcu_inkernel_boot_has_ended(void) { return true; }
 static inline bool rcu_is_watching(void) { return true; }
-static inline void rcu_momentary_dyntick_idle(void) { }
+static inline void rcu_momentary_eqs(void) { }
 static inline void kfree_rcu_scheduler_running(void) { }
 static inline bool rcu_gp_might_be_stalled(void) { return false; }
 
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index daa94d3b458d7..50d48af37abcb 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -37,7 +37,7 @@ void synchronize_rcu_expedited(void);
 void kvfree_call_rcu(struct rcu_head *head, void *ptr);
 
 void rcu_barrier(void);
-void rcu_momentary_dyntick_idle(void);
+void rcu_momentary_eqs(void);
 void kfree_rcu_scheduler_running(void);
 bool rcu_gp_might_be_stalled(void);
 
diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index 46612fb15fc6d..6a42accb14634 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -2641,7 +2641,7 @@ static unsigned long rcu_torture_fwd_prog_cbfree(struct rcu_fwd *rfp)
 		rcu_torture_fwd_prog_cond_resched(freed);
 		if (tick_nohz_full_enabled()) {
 			local_irq_save(flags);
-			rcu_momentary_dyntick_idle();
+			rcu_momentary_eqs();
 			local_irq_restore(flags);
 		}
 	}
@@ -2791,7 +2791,7 @@ static void rcu_torture_fwd_prog_cr(struct rcu_fwd *rfp)
 		rcu_torture_fwd_prog_cond_resched(n_launders + n_max_cbs);
 		if (tick_nohz_full_enabled()) {
 			local_irq_save(flags);
-			rcu_momentary_dyntick_idle();
+			rcu_momentary_eqs();
 			local_irq_restore(flags);
 		}
 	}
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 81f0a730c54b2..849d9daf45f72 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -323,7 +323,7 @@ bool rcu_dynticks_zero_in_eqs(int cpu, int *vp)
  *
  * The caller must have disabled interrupts and must not be idle.
  */
-notrace void rcu_momentary_dyntick_idle(void)
+notrace void rcu_momentary_eqs(void)
 {
 	int seq;
 
@@ -333,7 +333,7 @@ notrace void rcu_momentary_dyntick_idle(void)
 	WARN_ON_ONCE(!(seq & RCU_DYNTICKS_IDX));
 	rcu_preempt_deferred_qs(current);
 }
-EXPORT_SYMBOL_GPL(rcu_momentary_dyntick_idle);
+EXPORT_SYMBOL_GPL(rcu_momentary_eqs);
 
 /**
  * rcu_is_cpu_rrupt_from_idle - see if 'interrupted' from idle
diff --git a/kernel/rcu/tree_nocb.h b/kernel/rcu/tree_nocb.h
index a3d613f063a8f..42b7f0d4d4d8d 100644
--- a/kernel/rcu/tree_nocb.h
+++ b/kernel/rcu/tree_nocb.h
@@ -930,7 +930,7 @@ static void nocb_cb_wait(struct rcu_data *rdp)
 
 
 	local_irq_save(flags);
-	rcu_momentary_dyntick_idle();
+	rcu_momentary_eqs();
 	local_irq_restore(flags);
 	/*
 	 * Disable BH to provide the expected environment.  Also, when
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 8cf1adcd259ba..8e8b44edcc97a 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -953,7 +953,7 @@ static void rcu_qs(void)
 
 /*
  * Register an urgently needed quiescent state.  If there is an
- * emergency, invoke rcu_momentary_dyntick_idle() to do a heavy-weight
+ * emergency, invoke rcu_momentary_eqs() to do a heavy-weight
  * dyntick-idle quiescent state visible to other CPUs, which will in
  * some cases serve for expedited as well as normal grace periods.
  * Either way, register a lightweight quiescent state.
@@ -973,7 +973,7 @@ void rcu_all_qs(void)
 	this_cpu_write(rcu_data.rcu_urgent_qs, false);
 	if (unlikely(raw_cpu_read(rcu_data.rcu_need_heavy_qs))) {
 		local_irq_save(flags);
-		rcu_momentary_dyntick_idle();
+		rcu_momentary_eqs();
 		local_irq_restore(flags);
 	}
 	rcu_qs();
@@ -993,7 +993,7 @@ void rcu_note_context_switch(bool preempt)
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
index 8f4b59bedea66..f18e9bd0818dc 100644
--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -1554,7 +1554,7 @@ static int run_osnoise(void)
 		 * This will eventually cause unwarranted noise as PREEMPT_RCU
 		 * will force preemption as the means of ending the current
 		 * grace period. We avoid this problem by calling
-		 * rcu_momentary_dyntick_idle(), which performs a zero duration
+		 * rcu_momentary_eqs(), which performs a zero duration
 		 * EQS allowing PREEMPT_RCU to end the current grace period.
 		 * This call shouldn't be wrapped inside an RCU critical
 		 * section.
@@ -1566,7 +1566,7 @@ static int run_osnoise(void)
 			if (!disable_irq)
 				local_irq_disable();
 
-			rcu_momentary_dyntick_idle();
+			rcu_momentary_eqs();
 
 			if (!disable_irq)
 				local_irq_enable();
-- 
2.53.0



