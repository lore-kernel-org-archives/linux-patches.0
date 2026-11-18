Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021953;
	b=FhjGwKB0h2YkeJsifwr8edbzF5+jletItttzts54dM5h0OgxRreK7noIyi0FOntahoIl
	 kjpiVj8ksUVIByCGGrO6AIpLQpJyeE1VKt1ENAYa48VZy5pLPkmwMaYJcLVWhq7Q8TKLQ
	 r3mDudDDBQ8vsBQIEOuh2/ATqRF9KhsYw8OHxQaTKx0bABMHXQMZP0pDtch5fbN65MzxA
	 YLcGMq8EtZnHjDR6BelFngVu7AAwLXJKdYXHARPCRU4Ev+wOBRLfBljd5wc7hmwurC3k5
	 0g6/oK7ug5LuBICLhccg2upfYfAeN9tl6HHKATmV4IVffDyY7WM4BwqEwC4PvMdSmwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021953;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gaBB1lr4b/rMYVegDlnou6c0kMCoDx7pnnB396JjD+Q=;
	b=QujyuyFtWcndSweK0y+gZ/qQT8lWj0vgsWgaBmxGkSHlx4H0vpScPLciCmVjOHo1oQEI
	 2ToOUtR1fn1fuFm32m+1IbWllq1/1PCs7wv+JhOTtWLhNExIWqYOtatSakhDklchdmoLn
	 gew3J5oLNmcKgIU6RE6/cTrC3fP4Hq+jSYii/Or5a9uPFDoRUt4ZA9eNbq3j5SvDse7MP
	 Y/gbWgtIdpNF0QK+H1WUJXZmXFbT+dlWELCTmiIsuGadllnaWjo1qUx9FMGt+a1fZbTvz
	 O3nH8AP1ZQGxtbODnw/ttl9Lnh3xmZ1f68pNfRyMKC5PRWiFGxQ6nLIL8UhABwBqNHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="pc/6nuJG";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F917606A320;
	Wed, 18 Nov 2026 17:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pc/6nuJG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61F111F000C5;
	Wed, 18 Nov 2026 17:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021952;
	bh=gaBB1lr4b/rMYVegDlnou6c0kMCoDx7pnnB396JjD+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pc/6nuJGjC1tiO1lUSkWCrEBh5pEZh3tUoOtxZ1klv07IS0+adQ9juas4kwaV5QsO
	 Q/wamXyHO42gZCvrl+8Ub2r5s5RHYWk0rKgVM4K5UsQINZC6QgbVRoix/3wLSFZDhW
	 hfbW/QWnFhw+DbI9fTO0xpawrZxMtJzCNiZK5zCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Andrea Righi <arighi@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2488/2651] sched_ext: Add ops.sub_child_ecaps_updated() to report a childs effective cap changes
Date: Wed, 18 Nov 2026 16:02:08 +0100
Message-ID: <20261118150414.449451911@linuxfoundation.org>
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

From: Tejun Heo <tj@kernel.org>

[ Upstream commit da3bad759ef2df9db38ad851a061d719091d74dd ]

A grant or revoke only records the target caps. They take effect on a cid at
its next dispatch, and nothing tells the parent when. Without that the
parent cannot act on a revoke: a child that ran a cid at a low cpuperf
target leaves the target there when PERF is revoked, as the kernel resets
targets only at root enable. Nor can the parent tell when it may schedule on
the cid again.

Add ops.sub_child_ecaps_updated(), delivered to the direct parent right
after the child's own ops.sub_ecaps_updated() with the child's cgroup id and
the same before and after caps, in the same dispatch context. Both
deliveries are suppressed while the child is bypassing and replayed together
afterwards. A disabled child reports nothing: ops.sub_detach() is where the
parent restores what it had delegated.

A sub is now bypassed before it is linked, so that the grants queued for it
from ops.sub_attach() are consumed while it is bypassed and replayed to it
and the parent once it is enabled. Otherwise a sync consumed before the
sub's ops are registered would reach the parent but never the sub.

v2: Drop the disable report with its sleep lock and nested-dispatch gate,
the parent restores from ops.sub_detach() instead.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Stable-dep-of: 5c23d1710606 ("sched_ext: Fix queued bypassed tasks stalling when the host loses SCX_CAP_BASE")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext/ext.c      |  4 +++
 kernel/sched/ext/internal.h | 30 +++++++++++++++++--
 kernel/sched/ext/sub.c      | 59 ++++++++++++++++++++++++++-----------
 3 files changed, 72 insertions(+), 21 deletions(-)

diff --git a/kernel/sched/ext/ext.c b/kernel/sched/ext/ext.c
index e6211adf015e1..0b08f78f7f851 100644
--- a/kernel/sched/ext/ext.c
+++ b/kernel/sched/ext/ext.c
@@ -8631,6 +8631,7 @@ static void sched_ext_ops_cid__enable(struct task_struct *p, struct scx_enable_a
 static void sched_ext_ops__sub_caps_updated(const struct scx_cmask *cmask__arena, u64 caps) {}
 static void sched_ext_ops__sub_ecaps_updated(s32 cid, u64 before, u64 after) {}
 static void sched_ext_ops__sub_cid_sched_updated(s32 cid, u64 sched) {}
+static void sched_ext_ops__sub_child_ecaps_updated(u64 cgroup_id, s32 cid, u64 before, u64 after) {}
 
 static struct sched_ext_ops_cid __bpf_ops_sched_ext_ops_cid = {
 	.select_cid		= sched_ext_ops__select_cpu,
@@ -8666,6 +8667,7 @@ static struct sched_ext_ops_cid __bpf_ops_sched_ext_ops_cid = {
 	.sub_caps_updated	= sched_ext_ops__sub_caps_updated,
 	.sub_ecaps_updated	= sched_ext_ops__sub_ecaps_updated,
 	.sub_cid_sched_updated	= sched_ext_ops__sub_cid_sched_updated,
+	.sub_child_ecaps_updated = sched_ext_ops__sub_child_ecaps_updated,
 	.cid_online		= sched_ext_ops__cpu_online,
 	.cid_offline		= sched_ext_ops__cpu_offline,
 	.init_cids		= sched_ext_ops__init_cids,
@@ -11165,6 +11167,7 @@ static const u32 scx_kf_allow_flags[] = {
 	[SCX_OP_IDX(sub_attach)]	= SCX_KF_ALLOW_UNLOCKED,
 	[SCX_OP_IDX(sub_detach)]	= SCX_KF_ALLOW_UNLOCKED,
 	[SCX_OP_IDX(sub_ecaps_updated)]	= SCX_KF_ALLOW_ENQUEUE | SCX_KF_ALLOW_DISPATCH,
+	[SCX_OP_IDX(sub_child_ecaps_updated)] = SCX_KF_ALLOW_ENQUEUE | SCX_KF_ALLOW_DISPATCH,
 	[SCX_OP_IDX(cpu_online)]	= SCX_KF_ALLOW_UNLOCKED,
 	[SCX_OP_IDX(cpu_offline)]	= SCX_KF_ALLOW_UNLOCKED,
 	[SCX_OP_IDX(init_cids)]		= SCX_KF_ALLOW_UNLOCKED | SCX_KF_ALLOW_INIT_CIDS,
@@ -11310,6 +11313,7 @@ static int __init scx_init(void)
 	CID_OFFSET_MATCH(sub_caps_updated, sub_caps_updated);
 	CID_OFFSET_MATCH(sub_ecaps_updated, sub_ecaps_updated);
 	CID_OFFSET_MATCH(sub_cid_sched_updated, sub_cid_sched_updated);
+	CID_OFFSET_MATCH(sub_child_ecaps_updated, sub_child_ecaps_updated);
 	CID_OFFSET_MATCH(init_cids, init_cids);
 	CID_OFFSET_MATCH(init, init);
 	CID_OFFSET_MATCH(exit, exit);
diff --git a/kernel/sched/ext/internal.h b/kernel/sched/ext/internal.h
index 73a84c660caf5..67c1c81c0bc36 100644
--- a/kernel/sched/ext/internal.h
+++ b/kernel/sched/ext/internal.h
@@ -848,8 +848,9 @@ struct sched_ext_ops {
 	 * @args: argument container, see the struct definition
 	 *
 	 * The sub-scheduler holds no caps by this point and can no longer
-	 * affect any cid. Whatever was delegated to it, e.g. cpuperf targets,
-	 * is the parent's to restore here.
+	 * affect any cid. Its caps went away without a
+	 * sub_child_ecaps_updated() report, so whatever was delegated to it,
+	 * e.g. cpuperf targets, is the parent's to restore here.
 	 */
 	void (*sub_detach)(struct scx_sub_detach_args *args);
 
@@ -902,6 +903,25 @@ struct sched_ext_ops {
 	 */
 	void (*sub_cid_sched_updated)(s32 cid, u64 sched);
 
+	/**
+	 * @sub_child_ecaps_updated: A child's effective caps on a cid changed
+	 * @cgroup_id: cgroup id of the direct child
+	 * @cid: the cid whose effective caps changed
+	 * @before: the child's effective caps as of the last delivery
+	 * @after: the child's effective caps now
+	 *
+	 * Invoked right after the child's sub_ecaps_updated(), once a grant or
+	 * revoke is in effect on the cpu. From here on the parent can act on a
+	 * cap the child lost, e.g. reset the cpuperf target or schedule on the
+	 * cid. A detaching child's caps go away without a report, see
+	 * sub_detach(). A cpu going offline drops caps without a report.
+	 *
+	 * Runs in dispatch context with rq lock held, and can perform all
+	 * operations allowed in ops.dispatch() including inserting/moving
+	 * tasks.
+	 */
+	void (*sub_child_ecaps_updated)(u64 cgroup_id, s32 cid, u64 before, u64 after);
+
 	/*
 	 * All online ops must come before ops.cpu_online().
 	 */
@@ -1160,6 +1180,7 @@ struct sched_ext_ops_cid {
 	void (*sub_caps_updated)(const struct scx_cmask *cmask__arena, u64 caps);
 	void (*sub_ecaps_updated)(s32 cid, u64 before, u64 after);
 	void (*sub_cid_sched_updated)(s32 cid, u64 sched);
+	void (*sub_child_ecaps_updated)(u64 cgroup_id, s32 cid, u64 before, u64 after);
 	void (*cid_online)(s32 cid);
 	void (*cid_offline)(s32 cid);
 	s32 (*init_cids)(void);
@@ -1422,7 +1443,10 @@ struct scx_sched_pcpu {
 	struct llist_node	ecaps_to_sync_node;
 	/* owed a forced update_idle() re-notify on this cpu */
 	bool			idle_renotify;
-	/* effective caps as of the last sub_ecaps_updated() delivery */
+	/*
+	 * ecaps as of the last sub_ecaps_updated() and
+	 * sub_child_ecaps_updated() delivery. See __scx_process_sync_ecaps().
+	 */
 	u64			reported_ecaps;
 
 	/*
diff --git a/kernel/sched/ext/sub.c b/kernel/sched/ext/sub.c
index 02a27571f2d0a..f40c8b64e026d 100644
--- a/kernel/sched/ext/sub.c
+++ b/kernel/sched/ext/sub.c
@@ -1180,27 +1180,43 @@ void scx_process_sync_ecaps(struct rq *rq, struct task_struct *prev)
 		lost_all |= lost;
 
 		/*
-		 * Tell the sched its effective caps on this cid changed. The
-		 * invocation is equivalent to the dispatch path and may drop
-		 * and re-acquire the rq lock temporarily while the rest of
-		 * @batch is held privately, see scx_discard_ecaps_to_sync().
-		 * The dispatch kfuncs resolve their context on the executing
-		 * cpu, which under core scheduling can differ from @rq's cpu,
-		 * so the context is set up there. The rq recorded in it keeps
-		 * the dispatches targeting @rq.
+		 * Tell the sched and its parent that the sched's effective caps
+		 * on this cid changed. The invocations are equivalent to the
+		 * dispatch path and may drop and re-acquire the rq lock
+		 * temporarily while the rest of @batch is held privately, see
+		 * scx_discard_ecaps_to_sync(). The dispatch kfuncs resolve
+		 * their context on the executing cpu, which under core
+		 * scheduling can differ from @rq's cpu, so the context is set
+		 * up there. The rq recorded in it keeps the dispatches
+		 * targeting @rq.
+		 *
+		 * Bypass propagates down the hierarchy, so a sched that isn't
+		 * bypassing has no bypassing parent. The child's bypass state
+		 * gates both deliveries. Both report the same before value, so
+		 * one reported_ecaps covers them.
 		 */
-		if (ecaps != pcpu->reported_ecaps &&
-		    SCX_HAS_OP(pcpu->sch, sub_ecaps_updated) &&
-		    !scx_bypassing(pcpu->sch, cpu)) {
-			struct scx_dsp_ctx *dspc = &this_cpu_ptr(pcpu->sch->pcpu)->dsp_ctx;
+		if (ecaps != pcpu->reported_ecaps && !scx_bypassing(pcpu->sch, cpu)) {
+			struct scx_sched *parent = scx_parent(pcpu->sch);
+			struct scx_dsp_ctx *dspc;
 
-			dspc->rq = rq;
 			/* stash @prev so nested dispatches can access it */
 			rq->scx.sub_dispatch_prev = prev;
-			SCX_CALL_OP(pcpu->sch, sub_ecaps_updated, rq, scx_cpu_arg(cpu),
-				    pcpu->reported_ecaps, ecaps);
+			if (SCX_HAS_OP(pcpu->sch, sub_ecaps_updated)) {
+				dspc = &this_cpu_ptr(pcpu->sch->pcpu)->dsp_ctx;
+				dspc->rq = rq;
+				SCX_CALL_OP(pcpu->sch, sub_ecaps_updated, rq,
+					    scx_cpu_arg(cpu), pcpu->reported_ecaps, ecaps);
+				scx_flush_dispatch_buf(pcpu->sch, rq);
+			}
+			if (SCX_HAS_OP(parent, sub_child_ecaps_updated)) {
+				dspc = &this_cpu_ptr(parent->pcpu)->dsp_ctx;
+				dspc->rq = rq;
+				SCX_CALL_OP(parent, sub_child_ecaps_updated, rq,
+					    pcpu->sch->ops.sub_cgroup_id, scx_cpu_arg(cpu),
+					    pcpu->reported_ecaps, ecaps);
+				scx_flush_dispatch_buf(parent, rq);
+			}
 			rq->scx.sub_dispatch_prev = NULL;
-			scx_flush_dispatch_buf(pcpu->sch, rq);
 			pcpu->reported_ecaps = ecaps;
 		}
 
@@ -1995,6 +2011,15 @@ void scx_sub_enable_workfn(struct kthread_work *work)
 	if (ret)
 		goto err_disable;
 
+	/*
+	 * Bypass before @sch is linked and grants can reach it. The parent's
+	 * delivery advances reported_ecaps, so a sync consumed before @sch's
+	 * ops are registered would reach the parent and never be replayed to
+	 * @sch. While bypassed, the syncs are consumed without a delivery and
+	 * replayed to both at unbypass.
+	 */
+	scx_bypass(sch, true);
+
 	ret = scx_link_sched(sch);
 	if (ret)
 		goto err_disable;
@@ -2040,8 +2065,6 @@ void scx_sub_enable_workfn(struct kthread_work *work)
 	}
 	sch->sub_attached = true;
 
-	scx_bypass(sch, true);
-
 	for (i = SCX_OPI_BEGIN; i < SCX_OPI_END; i++)
 		if (((void (**)(void))ops)[i])
 			set_bit(i, sch->has_op);
-- 
2.53.0



