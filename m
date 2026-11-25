Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622755;
	b=NmXjXQWB53Dz6JmvyNfPrzLdBm62VXPbKEHInTJbcwmHuXffRKouWN9bcp64wFbKsw2F
	 TVb75a02UM5UcC88hmvqXfQBdYPM4pDR0ohsenCAfTAMj60tI7Pmuj5Xge8zfjcpXepcG
	 XOyKqa9FYcED8Nio4nO0oXYp4Umy6uz9C86eIaZwCxCCAahpI20mThdj7Uks31XEoFiH2
	 VVXttJPUJRLd5kVP1/Mx7Ks5juEzF6vaXEUA5Tilbs3P7BXSgIddvTzY1tdzp+OxK3Bcx
	 KMOGu3qoHCDX7AVEFvhnq1IWaEiC7NLsp0Bd0InGRHSYqvICey/DTTE4273j9wn3Xmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622755;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mcIAHjYB9ry/SeH+4Iu26o6Z2V6/g+rylLqsMnqplLA=;
	b=p6yhWUCNWnSrp/1Dhl/z+QUu3c07XEg/Q9ZhyMZt7Ho5gA2PCIeDTnyHW6ZdJnlNU18M
	 ZvBFlQGWSzq9+DSqQyuIPyGrhoZKpWXY/i5RON0VrGHryDy/xqWGuiPuKQx0y328Bk6GC
	 wTNXv3d/hW1kjtT/qwceYetYkM5rDs5PvM9SL4f+tAuaktOHhFkzSQ8TPeopmWCq64Ifr
	 SGMOJw2Bcf3qKKx8eUaNHiICN6dWfydyfXsm5P2v4XEzP/3cfcb6leR2xglQigv277E4Y
	 84X8WA7K8m+tXTeZ+CVBTuOCcfjvM4eoWO1wcvXUoOme+hpILSzQPcDKlYyjFbDXyeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2IavpsZY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 476D3606A323;
	Wed, 25 Nov 2026 16:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2IavpsZY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98B141F000C0;
	Wed, 25 Nov 2026 16:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622755;
	bh=mcIAHjYB9ry/SeH+4Iu26o6Z2V6/g+rylLqsMnqplLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2IavpsZY1pzYbDfHRcCekvbHFPvTwGAqjpfViyefBn3h0G/JM9DP1qfxvFkPnyp46
	 MSYEOGs8yJDh3htiNVAkAcsy7L5AYJxVi5f4/gSV9vTWUTZ6HryZucI3bJstVYLTt9
	 uV/Dx6xRhi0V6XlsNdKNF8SJYFhzWbJNJdyPdeIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junbin Zhang <sprooc69@gmail.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 635/990] sched_ext: Reject rq-lock-taking kfuncs in tracing programs
Date: Wed, 25 Nov 2026 15:33:22 +0100
Message-ID: <20261125143836.969182161@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junbin Zhang <sprooc69@gmail.com>

[ Upstream commit b07a7450f6ef98c79ebd450a92fc4bb6b8f1e02e ]

scx_bpf_cpuperf_set() and scx_bpf_cidperf_set() are members of
scx_kfunc_ids_any, which is registered for BPF_PROG_TYPE_TRACING.
A tracing program can run in a context which already holds the target
rq lock, in which case scx_cpuperf_set() attempts to acquire the same
lock again:

  __schedule()
    rq_lock(rq);                          /* rq->__lock is held */
    trace_sched_switch();
      BPF tracing program
        scx_bpf_cpuperf_set(smp_processor_id(), 1024);
          scx_cpuperf_set();
            locked_rq = scx_locked_rq(); /* NULL */
            rq_lock_irqsave(rq, &rf);    /* same lock */

scx_locked_rq() only tracks rq locks held during SCX callback
invocations, so it cannot detect an rq lock held by the surrounding
kernel code.

The deadlock can be reproduced with two BPF programs. The first is a
minimal SCX scheduler, which only needs to be registered and enabled:

  SEC(".struct_ops.link")
  struct sched_ext_ops minimal_ops = {
          .name = "minimal",
  };

The second is a tracing program attached to tp_btf/sched_switch,
which fires from __schedule() with rq->__lock already held:

  SEC("tp_btf/sched_switch")
  int BPF_PROG(on_sched_switch, bool preempt, struct task_struct *prev,
               struct task_struct *next, unsigned int prev_state)
  {
          scx_bpf_cpuperf_set(bpf_get_smp_processor_id(), 1024);
          return 0;
  }

With both programs attached, the next context switch on any CPU
deadlocks that CPU. Lockdep reports:

  WARNING: possible recursive locking detected
  7.3.0-rc7 #3 Not tainted
  swapper/3/0 is trying to acquire lock:
   (&rq->__lock){-.-.}-{2:2}, at: raw_spin_rq_lock_nested+0x1e/0x30

  but task is already holding lock:
   (&rq->__lock){-.-.}-{2:2}, at: __schedule+0xeb/0x1430

   Possible unsafe locking scenario:

         CPU0
         ----
    lock(&rq->__lock);
    lock(&rq->__lock);

    *** DEADLOCK ***

  Call Trace:
   <TASK>
   print_deadlock_bug.cold+0xc0/0xd0
   __lock_acquire+0x12fa/0x1b80
   lock_acquire+0xd1/0x2f0
   _raw_spin_lock_nested+0x32/0x40
   raw_spin_rq_lock_nested+0x1e/0x30
   scx_cpuperf_set+0x1e9/0x310
   scx_bpf_cpuperf_set+0x9b/0x230
   bpf_prog_..._on_sched_switch+0x3d/0x41
   bpf_trace_run4+0x125/0x450
   __traceiter_sched_switch+0x4b/0x70
   __schedule+0x94a/0x1430
   schedule_idle+0x26/0x50
   cpu_startup_entry+0x2d/0x30
   start_secondary+0xfc/0x100
   </TASK>

The CPU remains locked up with interrupts disabled.
scx_bpf_cidperf_set() is similarly affected, as it resolves the CID
through scx_cid_to_cpu() before reaching the same rq-locking path.

There is no reliable way for these kfuncs to determine whether the
surrounding tracing context already holds an rq lock. Reject calls to
both kfuncs from tracing programs at verification time, while
preserving their availability to SCX struct_ops and syscall programs.

Fixes: a11d6784d731 ("sched_ext: Fix missing rq lock in scx_bpf_cpuperf_set()")
Signed-off-by: Junbin Zhang <sprooc69@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
[ sashal: Replaced the tracing-visible scx_kfunc_context_filter() check with a separate BTF kfunc set for scx_bpf_cpuperf_set(), registered only for struct_ops and syscall programs, and dropped the cid variant. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext.c | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/ext.c b/kernel/sched/ext.c
index af5828f093045..b3a6d60709403 100644
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -7013,7 +7013,6 @@ BTF_ID_FLAGS(func, scx_bpf_error_bstr, KF_TRUSTED_ARGS)
 BTF_ID_FLAGS(func, scx_bpf_dump_bstr, KF_TRUSTED_ARGS)
 BTF_ID_FLAGS(func, scx_bpf_cpuperf_cap)
 BTF_ID_FLAGS(func, scx_bpf_cpuperf_cur)
-BTF_ID_FLAGS(func, scx_bpf_cpuperf_set)
 BTF_ID_FLAGS(func, scx_bpf_nr_node_ids)
 BTF_ID_FLAGS(func, scx_bpf_nr_cpu_ids)
 BTF_ID_FLAGS(func, scx_bpf_get_possible_cpumask, KF_ACQUIRE)
@@ -7036,6 +7035,25 @@ static const struct btf_kfunc_id_set scx_kfunc_set_any = {
 	.set			= &scx_kfunc_ids_any,
 };
 
+/*
+ * Kfuncs which may take the rq lock on their unlocked path.
+ *
+ * A tracing program can execute in any kernel context, including ones which
+ * already hold the rq lock (e.g. sched_switch). scx_locked_rq() only tracks
+ * rq locks taken for SCX callbacks, so from such a context it returns NULL
+ * and these kfuncs would acquire the already held rq lock again and deadlock
+ * the CPU. They cannot be made safe for tracing programs, so keep them off
+ * the tracing hook.
+ */
+BTF_KFUNCS_START(scx_kfunc_ids_no_tracing)
+BTF_ID_FLAGS(func, scx_bpf_cpuperf_set)
+BTF_KFUNCS_END(scx_kfunc_ids_no_tracing)
+
+static const struct btf_kfunc_id_set scx_kfunc_set_no_tracing = {
+	.owner			= THIS_MODULE,
+	.set			= &scx_kfunc_ids_no_tracing,
+};
+
 static int __init scx_init(void)
 {
 	int ret;
@@ -7065,6 +7083,10 @@ static int __init scx_init(void)
 					     &scx_kfunc_set_any)) ||
 	    (ret = register_btf_kfunc_id_set(BPF_PROG_TYPE_TRACING,
 					     &scx_kfunc_set_any)) ||
+	    (ret = register_btf_kfunc_id_set(BPF_PROG_TYPE_STRUCT_OPS,
+					     &scx_kfunc_set_no_tracing)) ||
+	    (ret = register_btf_kfunc_id_set(BPF_PROG_TYPE_SYSCALL,
+					     &scx_kfunc_set_no_tracing)) ||
 	    (ret = register_btf_kfunc_id_set(BPF_PROG_TYPE_SYSCALL,
 					     &scx_kfunc_set_any))) {
 		pr_err("sched_ext: Failed to register kfunc sets (%d)\n", ret);
-- 
2.53.0



