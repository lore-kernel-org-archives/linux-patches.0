Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619069;
	b=h1lvSOB0KkHf1PmW7IPJTSfNEomL0+JQLoCrh9+fynACB1O5ZNWxxbLdibaHiwy2sBoZ
	 wj9f9IiKlS0MxfzxnGmWyWXFX5/+Rssr+uIFcfFmNYp6D1MauBlUzJ70sgcStzzwz86KY
	 JhfsLsCLSlHYe0F5s1Y9GeBmIr6tVokphiwOKSZq1TdZ8sdtaWWJdqKRiDmolQpxemgEN
	 ul0L5qLQ8lslQV+BphKjwmwE9bjXtUosp9NUaMFhlpsFnrpAsP1A6hD2INztEDSsD/fwy
	 c53Q2nkWRQu1tVSzs1KUNUNNrbD8nvspIM51Bvp+FKuAWNWhWv5rh8/OLnYwtRNfnrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619069;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=65ofErfO0pkQJRCgq+LpRAaoiEuXyha0Hs1E5jQBQ3k=;
	b=LtrB3A4MuECHQksuwWlqLm0znqe1OgzZZh+sZ8zic5GpwAp7pJTy+H6t5kniIxKgLo+B
	 cAHTEIBiIiZHqavCZTMjPk8CIOkr/a4AUPybR3wzms84Zf7MNw+wxqjxKQgXXeOl5owt2
	 ehu/TSy4AvbhfxG8C0ejmm+59lBuYggLHq1MmWtBSl2cEJE8zMW3A87jimy7y5/kQqOZe
	 SCVuDaBkjhshIHNVmjj/u+OMGxTOpb0wYHn3azGpUTgBw3AdelxT6h2bZrcuV6Td6IV0B
	 GPsv5dP630RBhRYqYdpLwrPjiUJzC1dR9APMt4ylZ4CBq6JcPbaoU1h1QmciiAuMDfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NYJJ9MfW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1765A606A31E;
	Wed, 25 Nov 2026 15:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NYJJ9MfW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16C551F000C0;
	Wed, 25 Nov 2026 15:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619068;
	bh=65ofErfO0pkQJRCgq+LpRAaoiEuXyha0Hs1E5jQBQ3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NYJJ9MfWpfjJhLp+h5soUm7KQoK+lwYK10OdBB/nwoY8Vi8/jda3YqDk7ooC54ypC
	 FQXZCIQK7hMP629Urm4suKGPSgUaZoSlRHxOGxRCRfQMUlVaPVyfLRVbv72A93zRMU
	 M+p7gegto1NCqUYwnis4Aw8fNEmVvJAeV1cic0wk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kang Chen <k.chen@smail.nju.edu.cn>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0479/1005] sched_ext: make DSQ iterator stay drained after NULL
Date: Wed, 25 Nov 2026 15:30:17 +0100
Message-ID: <20261125143832.969358188@linuxfoundation.org>
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

From: Kang Chen <k.chen@smail.nju.edu.cn>

[ Upstream commit fcbff7b56a881bbe041b6c5ba12831a3c1ac1bb4 ]

nldsq_cursor_next_task() unlinks the iteration cursor when it reaches the
end of the DSQ.  A later call sees list_empty(&cursor->node), starts
from the DSQ head again, and returns the first task of the same
iteration.

The verifier relies on the iterator contract that once next() returns
NULL it keeps returning NULL: process_iter_next_call() marks the
iterator DRAINED and treats the result of later next() calls as the
constant zero.  A restarted DSQ iteration therefore hands the BPF
program a task pointer while the verifier believes R0 == 0.

Remember the drained state in the cursor flags and return NULL on every
later next() call.  The cursor has spare flag bits and the BPF-visible
iterator layout is unchanged.

Fixes: 650ba21b131e ("sched_ext: Implement DSQ iterator")
Signed-off-by: Kang Chen <k.chen@smail.nju.edu.cn>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext/ext.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/ext/ext.c b/kernel/sched/ext/ext.c
index 78773d42b32df..e0d3d73ef031f 100644
--- a/kernel/sched/ext/ext.c
+++ b/kernel/sched/ext/ext.c
@@ -492,12 +492,14 @@ enum scx_dsq_iter_flags {
 	/* iterate in the reverse dispatch order */
 	SCX_DSQ_ITER_REV		= 1U << 16,
 
+	__SCX_DSQ_ITER_DRAINED		= 1U << 28,
 	__SCX_DSQ_ITER_HAS_REENQ	= 1U << 29,
 	__SCX_DSQ_ITER_HAS_SLICE	= 1U << 30,
 	__SCX_DSQ_ITER_HAS_VTIME	= 1U << 31,
 
 	__SCX_DSQ_ITER_USER_FLAGS	= SCX_DSQ_ITER_REV,
 	__SCX_DSQ_ITER_ALL_FLAGS	= __SCX_DSQ_ITER_USER_FLAGS |
+					  __SCX_DSQ_ITER_DRAINED |
 					  __SCX_DSQ_ITER_HAS_REENQ |
 					  __SCX_DSQ_ITER_HAS_SLICE |
 					  __SCX_DSQ_ITER_HAS_VTIME,
@@ -10236,13 +10238,24 @@ __bpf_kfunc int bpf_iter_scx_dsq_new(struct bpf_iter_scx_dsq *it, u64 dsq_id,
 __bpf_kfunc struct task_struct *bpf_iter_scx_dsq_next(struct bpf_iter_scx_dsq *it)
 {
 	struct bpf_iter_scx_dsq_kern *kit = (void *)it;
+	struct task_struct *p;
 
-	if (!kit->dsq)
+	if (!kit->dsq || (kit->cursor.flags & __SCX_DSQ_ITER_DRAINED))
 		return NULL;
 
 	guard(raw_spinlock_irqsave)(&kit->dsq->lock);
 
-	return nldsq_cursor_next_task(&kit->cursor, kit->dsq);
+	p = nldsq_cursor_next_task(&kit->cursor, kit->dsq);
+	/*
+	 * nldsq_cursor_next_task() unlinks the cursor and starts from the DSQ
+	 * head when it is called again.  The verifier relies on an iterator
+	 * which returned NULL to keep returning NULL (see
+	 * process_iter_next_call()), so remember the drained state.
+	 */
+	if (!p)
+		kit->cursor.flags |= __SCX_DSQ_ITER_DRAINED;
+
+	return p;
 }
 
 /**
-- 
2.53.0



