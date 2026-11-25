Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618116;
	b=vqxnG+nb7g3HsMXC+6Yel1AuZ5zzCMsHRKKTFg+RTcSEaN51I/vAvVexxjygfrdVhKsc
	 9P1Jwma8Uq75ndV2f3v5ZuX9pCqIxs4qTYd/TiVRRVKtBm4FEhjmb/uP0SooioIc4QePY
	 dcIxWlRJAA3ELeM1ONpnH5aaQ05cfySo4xSWtpCVFLau1EiuRWIAt9GN1i/cEecfyCi/W
	 ctCxu9dAmZrLa6G7qHQQPzSRIUuRL0Ga6iXTxkgBLx6hlFEtBvKjyHY6vHvNvq3qqXtQq
	 oieUz8+UUC0SaPDWG34Si7d+a1IahyRJ5+/+AXmvJCgs4sORWCsnXcpB4LsBBVBfubA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618116;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2sretvQG+Ot60foLK/imNYlcDRJZrW7H8DLEl0rP8zs=;
	b=ygk8Irtd2DQKiPGWUYkbUt97WE1oF9plb8eM6ZU3cfMYlRBFBaAVgBWVhab9yA6yE9+w
	 y5C4ke0PlCgquYBUgYVSHyBKpCHwrHdyZaX70/ZCRig+10Gi1ijR9YT7+e2egowrPKHPr
	 7qdQwzEVVsHbGoIrHsMwTKX0RTew1R7bjhSBU3y2MkbAID4dURKDOwE4DFOtICpmumMpQ
	 gAfu+6Zarvf4P3ubn0Rfh00hvyAlpxVbqX12q6/yK+5GDjLL31YSQGkFSlgCo8I9xzwmS
	 bf4kcnBFBSaHTiKW9/WnBy5KeAHS5QoqnuHPL72k9iuTPZbApI1+ZRVN68tTcwnFpuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DUXoXarj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E5C3606A31E;
	Wed, 25 Nov 2026 14:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DUXoXarj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 701C61F000C0;
	Wed, 25 Nov 2026 14:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618116;
	bh=2sretvQG+Ot60foLK/imNYlcDRJZrW7H8DLEl0rP8zs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DUXoXarjZQnIAQzUdOrpRm/EUuqrcfHWGFQwanIQudE+dJs8HOe6WOzMZEg76nGXb
	 h7ET3MRe/rCjkC+2OBJnx+NRqppsh1PepF2EeDJUHxBtrRMFyFkaiMEHu2LwXk+Am/
	 YK7hQYdsLEsQ2HeE8/tub1A7SL0afXXxBcDXQA+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Shubhang Kaushik (Ampere)" <sh@gentwo.org>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0178/1005] sched_ext: Reject scx_bpf_destroy_dsq() in tracing programs
Date: Wed, 25 Nov 2026 15:25:16 +0100
Message-ID: <20261125143825.911614702@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Shubhang Kaushik (Ampere) <sh@gentwo.org>

[ Upstream commit 4c2e0751d5e6d181a5b9b2a8ada869b5bee66a83 ]

scx_bpf_destroy_dsq() takes the target user DSQ's raw spinlock. However,
it is in scx_kfunc_ids_any, which is also registered for
BPF_PROG_TYPE_TRACING.

For an active root scheduler without ops.sub_attach, the compatibility
path in scx_prog_sched() lets an unassociated tracing program resolve to
that scheduler. The tracing program can then call
scx_bpf_destroy_dsq() while the target DSQ lock is already held.

For example, a scheduler which mixes FIFO and priority-queue insertions
into a user DSQ triggers scx_error() from scx_dispatch_enqueue() while
holding that DSQ's lock. scx_claim_exit() emits sched_ext_exit before
the lock is released:

  scx_dispatch_enqueue()
    raw_spin_lock(&dsq->lock)
    scx_error()
      scx_claim_exit()
        trace_sched_ext_exit()
          tracing BPF program
            scx_bpf_destroy_dsq(dsq_id)
              destroy_dsq()
                raw_spin_lock_irqsave(&dsq->lock)

The tracing program recursively acquires the same raw spinlock and locks
up the CPU. Because the tracepoint runs before scx_finish_exit(),
disable_irq_work is not queued and the scheduler cannot enter its normal
disable path.

Reject scx_bpf_destroy_dsq() from tracing programs at verification time.
The kfunc remains available to SCX struct_ops and syscall programs.

Fixes: f0e1a0643a59 ("sched_ext: Implement BPF extensible scheduler class")
Signed-off-by: Shubhang Kaushik (Ampere) <sh@gentwo.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext/ext.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/sched/ext/ext.c b/kernel/sched/ext/ext.c
index 4b04ed0441fc9..50d5185bcd548 100644
--- a/kernel/sched/ext/ext.c
+++ b/kernel/sched/ext/ext.c
@@ -11226,6 +11226,9 @@ static const struct btf_kfunc_id_set scx_kfunc_set_any = {
  * when scx_locked_rq() returns NULL. Taking it while the context already holds
  * an rq lock, the same one or another cpu's, can deadlock.
  *
+ * scx_bpf_destroy_dsq() takes a user DSQ lock. A tracing program can run while
+ * that lock is already held and recursively acquire it.
+ *
  * Before returning, scx_bpf_sub_grant() and scx_bpf_sub_revoke() invoke
  * ops.sub_caps_updated() of the sub-schedulers whose caps changed, so those ops
  * run in the tracing program's context. No SCX op expects to run from an
@@ -11240,6 +11243,7 @@ BTF_ID_FLAGS(func, scx_bpf_cpuperf_set, KF_IMPLICIT_ARGS)
 BTF_ID_FLAGS(func, scx_bpf_cidperf_set, KF_IMPLICIT_ARGS)
 BTF_ID_FLAGS(func, scx_bpf_sub_grant, KF_IMPLICIT_ARGS)
 BTF_ID_FLAGS(func, scx_bpf_sub_revoke, KF_IMPLICIT_ARGS)
+BTF_ID_FLAGS(func, scx_bpf_destroy_dsq, KF_IMPLICIT_ARGS)
 BTF_KFUNCS_END(scx_kfunc_ids_no_tracing)
 
 /*
-- 
2.53.0



