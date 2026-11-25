Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619247;
	b=JaGdIAOY2Z7vJzcoJv93LzKfI27a6jhWrh40E3Qh3e4yk5f36SqKyJS+gqyMvpK3po0k
	 eXyysykY4eCGrlFfAgNcZ7IrSBoRYW3mR+0CoE2NSVbcNW6kwBItaMBQLVoMGxxulIkdq
	 GvY/fYY6ruS52ld4NLVWxIXUFwqdirm/hjF0Dn6aIX2kdxG1NiCzaBKp7xsEzo6mOZ3c5
	 rohZ73Vi6xNN5TEOy/GNfFJfag2Xleb6FjvQ2/Dm5+F3QihSXqvlkUM2OIEXB/W6Zg46F
	 dDPYtZT4W+ONZw0A2IOo/sf5yErHTEZVQZN0qJSjxkJXP0L0WXrN4AoJFrEySfYYlXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619247;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wkpnOnW2cTbdvuprQ6Zh44xplcHaTOxGrIX1yVt04GA=;
	b=slEia7o2FK3bmdhWoGF1eEqkycQfyARRgPfg5qmtzPqZvnS8zc/WY4DqF2B4rYErOgAY
	 Xoff+1PgrL5H1LhWPkeQ7T13Yuy9xlJh33h5V/LcW1XYvTaOidBF6g7NE3oeXA28BMb/9
	 QstZczzX7KaJPTDCPQTE6PUCgODVw3Nx13M9/lgx1q2f+/XEVI1tmhIEGb5sh7rEMTo5u
	 PKEDJwAJ7S49Z6A4kg5dwW1VJ/4B4cgklUgGQUJ/b9H/xNy8jVKyAESyKapdjPr1YCu3S
	 Vx3tJtWen9Lw1Ail+ASyQPIZjI87GbcUV3Hqhfoe6Q49dLPLIDOGhnEampWlVL+P4mA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YjZgCRYH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F49F606A31E;
	Wed, 25 Nov 2026 15:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YjZgCRYH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA12D1F000CA;
	Wed, 25 Nov 2026 15:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619246;
	bh=wkpnOnW2cTbdvuprQ6Zh44xplcHaTOxGrIX1yVt04GA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YjZgCRYHxfF80LwciOLjeN4HpDVqwCI9J6QVN1CIQ4W+RAWdliHIiFyZ4ji0bb1UW
	 lmWuLgZrcCrKHa0BSSF0Jeuu6VElXJBJGu1dEa9Jotc5kDZv9s9/gpOIYXWpTw5wFn
	 MNdXTRmf+cuAMdROrDITqUHSXscdj301VGzVVe3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Cui <cuitao@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0535/1005] sched_ext: Reject DSQ iterator kfuncs in tracing programs
Date: Wed, 25 Nov 2026 15:31:13 +0100
Message-ID: <20261125143834.279392385@linuxfoundation.org>
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

From: Tao Cui <cuitao@kylinos.cn>

[ Upstream commit 700a332c3fe33014bbd5ae852d71ba679fc29e0a ]

bpf_iter_scx_dsq_next() and bpf_iter_scx_dsq_destroy() take the target
user DSQ's raw spinlock, but they are in scx_kfunc_ids_any, which is
also registered for BPF_PROG_TYPE_TRACING.

For an active root scheduler without ops.sub_attach, the compatibility
path in scx_prog_sched() lets an unassociated tracing program resolve to
that scheduler. The tracing program can then call the iterator kfuncs
while the target DSQ lock is already held.

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
            bpf_iter_scx_dsq_new(dsq_id)
            bpf_for_each(scx_dsq, p, dsq_id, 0)
              bpf_iter_scx_dsq_next(it)
                raw_spin_lock_irqsave(&dsq->lock)

The tracing program recursively acquires the same raw spinlock and locks
up the CPU. Because the tracepoint runs before scx_finish_exit(),
disable_irq_work is not queued and the scheduler cannot enter its normal
disable path.

Reject the two iterator kfuncs from tracing programs at verification
time. The kfuncs remain available to SCX struct_ops and syscall
programs. bpf_iter_scx_dsq_destroy() has no independent live
reproduction: its cursor only links into the DSQ after at least one
successful next(), which deadlocks in the same window first. It is
included for symmetry.

This extends the coverage of commit b07a7450f6ef ("sched_ext: Reject
rq-lock-taking kfuncs in tracing programs") and commit 4c2e0751d5e6
("sched_ext: Reject scx_bpf_destroy_dsq() in tracing programs").

Fixes: 650ba21b131e ("sched_ext: Implement DSQ iterator")
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext/ext.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/ext/ext.c b/kernel/sched/ext/ext.c
index e0d3d73ef031f..ad782f3f37c8e 100644
--- a/kernel/sched/ext/ext.c
+++ b/kernel/sched/ext/ext.c
@@ -11316,8 +11316,10 @@ static const struct btf_kfunc_id_set scx_kfunc_set_any = {
  * when scx_locked_rq() returns NULL. Taking it while the context already holds
  * an rq lock, the same one or another cpu's, can deadlock.
  *
- * scx_bpf_destroy_dsq() takes a user DSQ lock. A tracing program can run while
- * that lock is already held and recursively acquire it.
+ * scx_bpf_destroy_dsq() takes a user DSQ lock. So do
+ * bpf_iter_scx_dsq_next() and bpf_iter_scx_dsq_destroy(), the latter only
+ * after a successful next() has linked the cursor. A tracing program can
+ * run while that lock is already held and recursively acquire it.
  *
  * Before returning, scx_bpf_sub_grant() and scx_bpf_sub_revoke() invoke
  * ops.sub_caps_updated() of the sub-schedulers whose caps changed, so those ops
@@ -11334,6 +11336,8 @@ BTF_ID_FLAGS(func, scx_bpf_cidperf_set, KF_IMPLICIT_ARGS)
 BTF_ID_FLAGS(func, scx_bpf_sub_grant, KF_IMPLICIT_ARGS)
 BTF_ID_FLAGS(func, scx_bpf_sub_revoke, KF_IMPLICIT_ARGS)
 BTF_ID_FLAGS(func, scx_bpf_destroy_dsq, KF_IMPLICIT_ARGS)
+BTF_ID_FLAGS(func, bpf_iter_scx_dsq_next, KF_ITER_NEXT | KF_RET_NULL)
+BTF_ID_FLAGS(func, bpf_iter_scx_dsq_destroy, KF_ITER_DESTROY)
 BTF_KFUNCS_END(scx_kfunc_ids_no_tracing)
 
 /*
-- 
2.53.0



