Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021941;
	b=a+VLMQiTvy2OAT+acksbQjL4nKP3W6lCUWW5KBhXANzRY0nvUUcXC/9DKCl4ELSsJ7IH
	 cQtkTu38XwAf95uTxR16kJuuy1AeRtUiO2cpXrWEPisGadF2Q19DUvsPqFKhWYlDGdyQ+
	 hSdom15UGfg31cApTnXbLqTcSuLK/iV4abhUIuVTzeyOmNtJAIUbTh6olyy5YZtn2YqBS
	 DJMya0mONvyaoFuzUWHul7Y0unVH+wFu3e5SA0AgdY5th7z8d0rzPX+O/K/vk7F+M8Shi
	 hSvaNLgm9lNpKXigvbZrdte/ULaStQGJBHz7YiaxbAYIzN0f9nS/cToMikGtOpHKqtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021941;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Iej7zLbfitgT7FKX+6f84XXuCZI4s9EHRqAsm5n80gs=;
	b=mpgfiK2K6cjRxY9CaqOCKSs4PWCl9YHMBmnIJBRVxFTq/UP1Xjyz7LnrpOcfp+6ZVk4N
	 xiNxrBfdP/QRkIB4tNHzlCbG+H60cLoTuGttYLG1jsii6sP5br2J/xU4YWxoAKN2gSkzj
	 PNhGhoubz+6bG7Nu0ZQWLVGdTc22yJaxhProLnajLkMrTdhRVCTuQcjyoHx4jhqkMwcgu
	 Z8X/74c3PAkahGoY94FxDsuocstfKWTl5x3aTxtDh9K12eFD+4GoI6Aa+xbHVVJwgE2GF
	 U0q+M8E7xPvDlTTj9A1L9snsdokppvgPaOUgy9lA8CxUeThX6Mfjwg6cU8IHvM1AnEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TWVz14Aq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B12DD606A31C;
	Wed, 18 Nov 2026 17:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TWVz14Aq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 138211F000C4;
	Wed, 18 Nov 2026 17:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021941;
	bh=Iej7zLbfitgT7FKX+6f84XXuCZI4s9EHRqAsm5n80gs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TWVz14AqTzjGjwUYaynmSU1yTP9/ymbiGOh9QJeGWo/Peg8muDXLbN3p8FSCIgbCr
	 ESGl7h7F+P7p1NBDrKjAxR4xOtocWLs2hF6o56NU0IlXc6Q3tvKsjp98/4v5zLorBC
	 fcHQZNKIlp7OAIA7QexyJ3zudy4QYmXn7UwjTYRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Righi <arighi@nvidia.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2485/2651] sched: Add sched_ext hooks for proxy execution
Date: Wed, 18 Nov 2026 16:02:05 +0100
Message-ID: <20261118150414.358745649@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrea Righi <arighi@nvidia.com>

[ Upstream commit be100c77178ef2299a080eb698720832a870248b ]

Proxy execution splits the scheduling context (the donor) from the
execution context (the lock owner). sched_ext needs to observe that
split at three points in __schedule():

 - whether a blocked EXT task can be retained on the runqueue as a
   donor,
 - when a donor's scheduling context starts driving a lock owner,
 - after proxy resolution, when deferred reenqueue work that was blocked
   by an active proxy relationship can be retried.

Introduce scx_allow_proxy_exec(), scx_proxy_donor_start() and
scx_proxy_reenqueue_retry(), and add their call sites in __schedule().
The implementations are empty here and are filled in by the sched_ext
changes that follow, so that all the sched core changes needed by proxy
execution stay together in the preparatory patches.

SCHED_PROXY_EXEC still depends on !SCHED_CLASS_EXT, so the new hooks are
inert: they are compiled out with CONFIG_SCHED_CLASS_EXT=n and
unreachable otherwise.

This is a preparatory change to support proxy execution with sched_ext.
No functional change.

Signed-off-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260922165445.943315-6-arighi@nvidia.com
Stable-dep-of: 5c23d1710606 ("sched_ext: Fix queued bypassed tasks stalling when the host loses SCX_CAP_BASE")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c    | 12 +++++++-----
 kernel/sched/ext/ext.c | 13 +++++++++++++
 kernel/sched/ext/ext.h |  7 +++++++
 3 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b596d9f5d83f6..4a051764e7119 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7196,13 +7196,12 @@ static void __sched notrace __schedule(int sched_mode)
 		}
 	} else if (!preempt && prev_state) {
 		/*
-		 * We pass task_is_blocked() as the should_block arg
-		 * in order to keep mutex-blocked tasks on the runqueue
-		 * for slection with proxy-exec (without proxy-exec
-		 * task_is_blocked() will always be false).
+		 * Keep mutex-blocked tasks on the runqueue for proxy execution
+		 * only when their scheduling class allows it. Without proxy
+		 * execution, task_is_blocked() always returns false.
 		 */
 		try_to_block_task(rq, prev, &prev_state,
-				  !task_is_blocked(prev));
+				  !task_is_blocked(prev) || !scx_allow_proxy_exec(prev));
 		switch_count = &prev->nvcsw;
 	}
 
@@ -7223,6 +7222,7 @@ static void __sched notrace __schedule(int sched_mode)
 			}
 			if (next == rq->idle) {
 				zap_balance_callbacks(rq);
+				scx_proxy_reenqueue_retry(rq, next);
 				goto keep_resched;
 			}
 		}
@@ -7243,6 +7243,8 @@ static void __sched notrace __schedule(int sched_mode)
 			donor->sched_class->put_prev_task(rq, donor, donor);
 			donor->sched_class->set_next_task(rq, donor, SNT_PICK);
 		}
+		scx_proxy_donor_start(rq);
+		scx_proxy_reenqueue_retry(rq, next);
 	} else {
 		rq_set_donor(rq, next);
 	}
diff --git a/kernel/sched/ext/ext.c b/kernel/sched/ext/ext.c
index 89e52371f7d29..4482df6d1187d 100644
--- a/kernel/sched/ext/ext.c
+++ b/kernel/sched/ext/ext.c
@@ -24,6 +24,11 @@
 
 DEFINE_RAW_SPINLOCK(scx_sched_lock);
 
+bool scx_allow_proxy_exec(const struct task_struct *p)
+{
+	return true;
+}
+
 /*
  * NOTE: sched_ext is in the process of growing multiple scheduler support and
  * scx_root usage is in a transitional state. Naked dereferences are safe if the
@@ -1083,6 +1088,10 @@ static void schedule_deferred_locked(struct rq *rq)
 	schedule_deferred(rq);
 }
 
+void scx_proxy_reenqueue_retry(struct rq *rq, struct task_struct *next)
+{
+}
+
 void schedule_dsq_reenq(struct scx_sched *sch, struct scx_dispatch_q *dsq,
 			u64 reenq_flags, struct rq *locked_rq)
 {
@@ -3120,6 +3129,10 @@ static void set_next_task_scx(struct rq *rq, struct task_struct *p, enum snt_e t
 	}
 }
 
+void scx_proxy_donor_start(struct rq *rq)
+{
+}
+
 static enum scx_cpu_preempt_reason
 preempt_reason_from_class(const struct sched_class *class)
 {
diff --git a/kernel/sched/ext/ext.h b/kernel/sched/ext/ext.h
index 0b7fc46aee08c..3cfbfeb1bf9d1 100644
--- a/kernel/sched/ext/ext.h
+++ b/kernel/sched/ext/ext.h
@@ -20,6 +20,9 @@ void scx_rq_deactivate(struct rq *rq);
 int scx_check_setscheduler(struct task_struct *p, int policy);
 bool task_should_scx(int policy);
 bool scx_allow_ttwu_queue(const struct task_struct *p);
+bool scx_allow_proxy_exec(const struct task_struct *p);
+void scx_proxy_donor_start(struct rq *rq);
+void scx_proxy_reenqueue_retry(struct rq *rq, struct task_struct *next);
 void init_sched_ext_class(void);
 
 static inline u32 scx_cpuperf_target(s32 cpu)
@@ -54,6 +57,10 @@ static inline void scx_rq_deactivate(struct rq *rq) {}
 static inline int scx_check_setscheduler(struct task_struct *p, int policy) { return 0; }
 static inline bool task_on_scx(const struct task_struct *p) { return false; }
 static inline bool scx_allow_ttwu_queue(const struct task_struct *p) { return true; }
+static inline bool scx_allow_proxy_exec(const struct task_struct *p) { return true; }
+static inline void scx_proxy_donor_start(struct rq *rq) {}
+static inline void scx_proxy_reenqueue_retry(struct rq *rq,
+					     struct task_struct *next) {}
 static inline void init_sched_ext_class(void) {}
 
 #endif	/* CONFIG_SCHED_CLASS_EXT */
-- 
2.53.0



