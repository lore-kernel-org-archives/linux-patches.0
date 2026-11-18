Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022258;
	b=oxfX4TQGatWF6nce+7Bh1+IR4ixQbQoG/yTXstxwlsdYOmhMnwkteXMtNfbPRXqL3WD6
	 jSgPRBA1+ucoXqQ+RKwoYp/W9Ohp6mmFKYsMO11os2esXJl0hpklqh75ciGWHp1zpg3a2
	 HCVhACaq881FBTNij1OnoT6uo1z+qNT/Q+L0nhIySu4/cTkmrGdx6Wpm5f5/3mZxu/NMY
	 dfuBU+e22UV5228WfFVoxSx+K2ulneX6koB540FRbFxyWv/SuN0Qqhi4Z9Ie1FCcHvxb7
	 6U9vdibBF1/x60zVlEofvVqBUG6nPE3441+EadRCxwlXJAG7arobzUOeX7GJRSDc3Rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022258;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ra+Je3/EeVt80nZogCW9mtmDhjrebUG7UojY9IuaLzw=;
	b=07hepZJPHXKcWCZZ29vMfybWV7ARG3RbJdmuNp4Pl6pR6c1tJiITEyvNelb4AJkaLvgI
	 d0adELYj8OPyqsI2uAgQbSw867C0APTjSCeviA09OkfaV0md5EtJfPydyvKRUW0HbNGAf
	 NHCFh3w9k7XzROZF/PEzUU3N8n1O3lDg1/FILtbSFM7VovOAtN24DHKDEQnS/PWcJPPjR
	 EwP9VUSwyxc66KTn7amexik3hwqjwfPjyteew7qOMdpCVJPsf8YwQf0vCC2Go97pLWZFP
	 nETeH39keoyKHnoQqzsjuPRldgu3wECmOT/L95bhP+1aRcHnWsu+/krJfS8BPC1z9GA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t41BB2Q7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A105E606A320;
	Wed, 18 Nov 2026 17:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t41BB2Q7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F19531F000C4;
	Wed, 18 Nov 2026 17:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022258;
	bh=ra+Je3/EeVt80nZogCW9mtmDhjrebUG7UojY9IuaLzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t41BB2Q7yIB/XhzplF6K/1EJXTC9tZixrYfp+6843z5cYnYfeMzzO5VPcH3TJ1rOF
	 /M6d/W6PC5A+yKkm0K+zv0xyXTJ8HbLE/bxh0bz4jvrG+VDkoaB+yTUAOdQEeuY6bp
	 ZrFSM3nDW34dj9wxmPMG/LhYUlq+pHjf5otXYNyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunhai Dai <daikunhai@didiglobal.com>,
	Tao Cui <cuitao@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2598/2651] blk-iocost: publish hweights as one atomic value
Date: Wed, 18 Nov 2026 16:03:58 +0100
Message-ID: <20261118150417.802769443@linuxfoundation.org>
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

From: Kunhai Dai <daikunhai@didiglobal.com>

[ Upstream commit 0150554a3f38e1850d5964102eb89a720c5fe789 ]

current_hweight() publishes the cache generation and both weights with
separate stores.  Refreshers running on different CPUs can interleave
their stores and leave a new generation paired with weights from an older
calculation.  The compiler can also reorder the generation store before
the weight stores, so a reader that sees the new generation can accept
stale weights.

A stale weight is not only a reporting artifact.  It feeds the cost
calculation and the donation logic, where an inconsistent combination can
lead to a zero divisor in transfer_surpluses().

In addition, the slow path rereads iocg->hweight_active/inuse after
publishing them, so the value it returns can be the one written by another
refresher instead of the locally computed one.

Pack the generation and both weights into a single atomic64_t and publish
them with one atomic write.  Readers take one atomic snapshot and return
the local values.  Weights are in [1, WEIGHT_ONE]; storing each minus one
preserves the full range in 16 bits and leaves 32 bits for the generation.

The two weight fields remain as the donation workspace used under
ioc->lock.  Tracepoints decode the packed cache without refreshing it and
iocost_monitor.py is updated accordingly.

Developed with assistance from Claude Code (Anthropic): the assistant
drafted the packed representation, the helpers and the tracepoint/monitor
changes, and ran the checks listed below.  The author reviewed the result
and remains responsible for it.

Fixes: 7caa47151ab2 ("blkcg: implement blk-iocost")
Signed-off-by: Kunhai Dai <daikunhai@didiglobal.com>
Tested-by: Tao Cui <cuitao@kylinos.cn>
Reviewed-by: Tao Cui <cuitao@kylinos.cn>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://patch.msgid.link/20261019125412.3123895-3-daikunhai@didiglobal.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-iocost.c             | 109 +++++++++++++++++++++++++++------
 include/trace/events/iocost.h  |   7 ++-
 tools/cgroup/iocost_monitor.py |   7 ++-
 3 files changed, 99 insertions(+), 24 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 2ed9812654a34..6cf314f9de401 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -173,6 +173,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/bitfield.h>
 #include <linux/module.h>
 #include <linux/timer.h>
 #include <linux/time64.h>
@@ -472,8 +473,8 @@ struct ioc_gq {
 	 *
 	 * When an idle cgroup becomes active its `active` goes from 0 to
 	 * `weight`.  `inuse` is the surplus adjusted active weight.
-	 * `active` and `inuse` are used to calculate `hweight_active` and
-	 * `hweight_inuse`.
+	 * `active` and `inuse` determine the hierarchical weights cached in
+	 * `hweight_cache`.
 	 *
 	 * `last_inuse` remembers `inuse` while an iocg is idle to persist
 	 * surplus adjustments.
@@ -520,7 +521,9 @@ struct ioc_gq {
 	u64				child_active_sum;
 	u64				child_inuse_sum;
 	u64				child_adjusted_sum;
-	int				hweight_gen;
+	/* Generation in bits 63:32; active - 1 and inuse - 1 in 31:16/15:0. */
+	atomic64_t			hweight_cache;
+	/* Donation workspace, protected by ioc->lock. */
 	u32				hweight_active;
 	u32				hweight_inuse;
 	u32				hweight_donating;
@@ -727,6 +730,54 @@ static void iocg_commit_bio(struct ioc_gq *iocg, struct bio *bio,
 	put_cpu_ptr(gcs);
 }
 
+/*
+ * The hierarchical weights are in [1, WEIGHT_ONE] and the generation is a
+ * 32-bit counter.  Pack generation and both weights into one 64-bit value so
+ * that a reader or a refresher always observes a complete snapshot:
+ *
+ *   bits 63:32  generation
+ *   bits 31:16  hweight_active - 1
+ *   bits 15:0   hweight_inuse - 1
+ */
+#define HWEIGHT_GEN_MASK	GENMASK_ULL(63, 32)
+#define HWEIGHT_ACTIVE_MASK	GENMASK_ULL(31, 16)
+#define HWEIGHT_INUSE_MASK	GENMASK_ULL(15, 0)
+
+static inline u64 hweight_cache_pack(u32 gen, u32 active, u32 inuse)
+{
+	return FIELD_PREP(HWEIGHT_GEN_MASK, gen) |
+	       FIELD_PREP(HWEIGHT_ACTIVE_MASK, active - 1) |
+	       FIELD_PREP(HWEIGHT_INUSE_MASK, inuse - 1);
+}
+
+static inline void hweight_cache_unpack(u64 cache, u32 *genp, u32 *activep,
+					u32 *inusep)
+{
+	if (genp)
+		*genp = FIELD_GET(HWEIGHT_GEN_MASK, cache);
+	if (activep)
+		*activep = FIELD_GET(HWEIGHT_ACTIVE_MASK, cache) + 1;
+	if (inusep)
+		*inusep = FIELD_GET(HWEIGHT_INUSE_MASK, cache) + 1;
+}
+
+/* Decode the published weights without refreshing the cache. */
+static inline void iocg_hweight_cache(struct ioc_gq *iocg, u32 *activep,
+				      u32 *inusep)
+{
+	hweight_cache_unpack(atomic64_read(&iocg->hweight_cache), NULL,
+			     activep, inusep);
+}
+
+/* Decode the cached inuse weight; only used by tracepoints. */
+static inline u32 iocg_hweight_cache_inuse(struct ioc_gq *iocg)
+{
+	u32 inuse;
+
+	iocg_hweight_cache(iocg, NULL, &inuse);
+	return inuse;
+}
+
 #define CREATE_TRACE_POINTS
 #include <trace/events/iocost.h>
 
@@ -1154,12 +1205,15 @@ static void current_hweight(struct ioc_gq *iocg, u32 *hw_activep, u32 *hw_inusep
 {
 	struct ioc *ioc = iocg->ioc;
 	int lvl;
-	u32 hwa, hwi;
-	int ioc_gen;
+	u32 hwa, hwi, ioc_gen, cache_gen;
+	u64 cache;
+
+	ioc_gen = (u32)atomic_read(&ioc->hweight_gen);
 
-	/* hot path - if uptodate, use cached */
-	ioc_gen = atomic_read(&ioc->hweight_gen);
-	if (ioc_gen == iocg->hweight_gen)
+	/* hot path - if uptodate, use the cached snapshot */
+	cache = atomic64_read(&iocg->hweight_cache);
+	hweight_cache_unpack(cache, &cache_gen, &hwa, &hwi);
+	if (cache_gen == ioc_gen)
 		goto out;
 
 	/*
@@ -1194,14 +1248,20 @@ static void current_hweight(struct ioc_gq *iocg, u32 *hw_activep, u32 *hw_inusep
 		hwi = div64_u64((u64)hwi * inuse, inuse_sum);
 	}
 
-	iocg->hweight_active = max_t(u32, hwa, 1);
-	iocg->hweight_inuse = max_t(u32, hwi, 1);
-	iocg->hweight_gen = ioc_gen;
+	hwa = max_t(u32, hwa, 1);
+	hwi = max_t(u32, hwi, 1);
+	/*
+	 * Publish the generation and both weights as one atomic snapshot.
+	 * A concurrent refresher may overwrite this with its own snapshot,
+	 * but the generation travels with the weights so the next reader
+	 * detects the mismatch and refreshes again.
+	 */
+	atomic64_set(&iocg->hweight_cache, hweight_cache_pack(ioc_gen, hwa, hwi));
 out:
 	if (hw_activep)
-		*hw_activep = iocg->hweight_active;
+		*hw_activep = hwa;
 	if (hw_inusep)
-		*hw_inusep = iocg->hweight_inuse;
+		*hw_inusep = hwi;
 }
 
 /*
@@ -1249,7 +1309,8 @@ static bool iocg_activate(struct ioc_gq *iocg, struct ioc_now *now)
 {
 	struct ioc *ioc = iocg->ioc;
 	u64 __maybe_unused last_period, cur_period;
-	u64 vtime, vtarget;
+	u64 vtime, vtarget, cache;
+	u32 active, inuse;
 	int i;
 
 	/*
@@ -1299,11 +1360,16 @@ static bool iocg_activate(struct ioc_gq *iocg, struct ioc_now *now)
 	vtime = vtarget;
 
 	/*
-	 * Activate, propagate weight and start period timer if not
-	 * running.  Reset hweight_gen to avoid accidental match from
-	 * wrapping.
+	 * Activate, propagate weight and start period timer if not running.
+	 * Invalidate the cached generation to avoid an accidental match from
+	 * wrapping.  Keep the last published weights so that the activation
+	 * tracepoint can report them; the next current_hweight() recomputes.
 	 */
-	iocg->hweight_gen = atomic_read(&ioc->hweight_gen) - 1;
+	cache = atomic64_read(&iocg->hweight_cache);
+	hweight_cache_unpack(cache, NULL, &active, &inuse);
+	atomic64_set(&iocg->hweight_cache,
+		     hweight_cache_pack((u32)(atomic_read(&ioc->hweight_gen) - 1),
+					active, inuse));
 	list_add(&iocg->active_list, &ioc->active_iocgs);
 
 	propagate_weights(iocg, iocg->weight,
@@ -2049,7 +2115,7 @@ static void transfer_surpluses(struct list_head *surpluses, struct ioc_now *now)
 
 		TRACE_IOCG_PATH(inuse_transfer, iocg, now,
 				iocg->inuse, inuse,
-				iocg->hweight_inuse,
+				iocg_hweight_cache_inuse(iocg),
 				iocg->hweight_after_donation);
 
 		__propagate_weights(iocg, iocg->active, inuse, true, now);
@@ -2362,7 +2428,7 @@ static void ioc_timer_fn(struct timer_list *timer)
 				 */
 				TRACE_IOCG_PATH(inuse_shortage, iocg, &now,
 						iocg->inuse, iocg->active,
-						iocg->hweight_inuse, new_hwi);
+						old_hwi, new_hwi);
 
 				__propagate_weights(iocg, iocg->active,
 						    iocg->active, true, &now);
@@ -3042,6 +3108,9 @@ static void ioc_pd_init(struct blkg_policy_data *pd)
 	INIT_LIST_HEAD(&iocg->active_list);
 	INIT_LIST_HEAD(&iocg->walk_list);
 	INIT_LIST_HEAD(&iocg->surplus_list);
+	atomic64_set(&iocg->hweight_cache,
+		     hweight_cache_pack((u32)(atomic_read(&ioc->hweight_gen) - 1),
+					WEIGHT_ONE, WEIGHT_ONE));
 	iocg->hweight_active = WEIGHT_ONE;
 	iocg->hweight_inuse = WEIGHT_ONE;
 
diff --git a/include/trace/events/iocost.h b/include/trace/events/iocost.h
index e772b1bc60d60..eb711343ce4fc 100644
--- a/include/trace/events/iocost.h
+++ b/include/trace/events/iocost.h
@@ -34,6 +34,9 @@ DECLARE_EVENT_CLASS(iocost_iocg_state,
 	),
 
 	TP_fast_assign(
+		u32 hwa, hwi;
+
+		iocg_hweight_cache(iocg, &hwa, &hwi);
 		__assign_str(devname);
 		__assign_str(cgroup);
 		__entry->now = now->now;
@@ -44,8 +47,8 @@ DECLARE_EVENT_CLASS(iocost_iocg_state,
 		__entry->vtime = vtime;
 		__entry->weight = iocg->weight;
 		__entry->inuse = iocg->inuse;
-		__entry->hweight_active = iocg->hweight_active;
-		__entry->hweight_inuse = iocg->hweight_inuse;
+		__entry->hweight_active = hwa;
+		__entry->hweight_inuse = hwi;
 	),
 
 	TP_printk("[%s:%s] now=%llu:%llu vrate=%llu "
diff --git a/tools/cgroup/iocost_monitor.py b/tools/cgroup/iocost_monitor.py
index bdd78ba271b04..8a4f844c98d40 100644
--- a/tools/cgroup/iocost_monitor.py
+++ b/tools/cgroup/iocost_monitor.py
@@ -149,8 +149,11 @@ class IocgStat:
         self.weight = iocg.weight.value_() / WEIGHT_ONE
         self.active = iocg.active.value_() / WEIGHT_ONE
         self.inuse = iocg.inuse.value_() / WEIGHT_ONE
-        self.hwa_pct = iocg.hweight_active.value_() * 100 / WEIGHT_ONE
-        self.hwi_pct = iocg.hweight_inuse.value_() * 100 / WEIGHT_ONE
+        hweight_cache = iocg.hweight_cache.counter.value_()
+        hwa = ((hweight_cache >> 16) & (WEIGHT_ONE - 1)) + 1
+        hwi = (hweight_cache & (WEIGHT_ONE - 1)) + 1
+        self.hwa_pct = hwa * 100 / WEIGHT_ONE
+        self.hwi_pct = hwi * 100 / WEIGHT_ONE
         self.address = iocg.value_()
 
         vdone = iocg.done_vtime.counter.value_()
-- 
2.53.0



