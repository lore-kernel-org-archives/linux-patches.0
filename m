Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617621;
	b=R/47MvjTif+0RZaU9r5JzEpO8XQ0Y9o0csjNWvLKEExFtICMk7MwDBRCgoG7nrkqfPmB
	 AVSTkzoV6z9Ac7i8laQoCsFp4S3pKZgnJt3Eg40oJovzG7Mkoqcuh5juJhq2bR7LnWN4t
	 ExymgWblxw+gD4w3fGlYkQ82BZCluR5+VK2mfLDb5SmdMT2RA5Xcmgp3dl+1eaPsQTaSp
	 LqYMRarD9/xKi1GLC2XEYjXIBgTjSDA3Zxn+95Ge5G7e6QyY1J1Y7kADzL3mVaGrj6Wfo
	 4uU4a2eijIZuks05dBuWJjV/qqUKNYDqvdlcsXfaerHRkkgnVIA3n/Z12z++7HmMC8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617621;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vda0iBwsT41ccVeLA6PCeMVZQzsoaIrvFwfNk0vjpRg=;
	b=uI3VoDh83sbN35EyNHleyiVdVkL6vZ6RPX76Y5r4aG/tn4lKJWCYxGru/vAhvjiF/t8I
	 GAReRl5dU/IjHuZ/mkXGhkXL8jOx51dNRzUvH+7YUqJxY8u+J+gL5RjkUC2ci4Oqo0eXg
	 +iiBsL03I6WN53F4So4wqKcH4qXJdN0llaOAv6DewD/XiZ8cpONIYJYS2HKza+e575uoB
	 PkF9fVUlr+cJEcBb6hhcXM4KoBjLWTQ75/wmxuBiVMqBMc4LyyBo/7BB549iUOdHWd9l4
	 Q1XK8gEZ3MMVcXFHp78nSiv+SmHtAV+GhgC2YxlzC199J2g23diGtEtO5Wk6hR6V9ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gvUowlGU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB73606A329;
	Wed, 25 Nov 2026 14:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gvUowlGU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5945B1F000D0;
	Wed, 25 Nov 2026 14:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617620;
	bh=vda0iBwsT41ccVeLA6PCeMVZQzsoaIrvFwfNk0vjpRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gvUowlGUibMJzlatTJAkUeTH0ArGMgz4mdAMpCgoNFMlBqla3D6Ms04voooZ3T7il
	 hIeW5KzEDt91r/wN2Gjl/54j7pxo1nlG9AiwHAWdVBd/0ZKPH7BR50BQMDj/BNTWMe
	 L7tz0uuzUussGffWR1LVDlAhdj0oc7dpVZV4Y21I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Li <hao.li@linux.dev>,
	"Harry Yoo (Meta)" <harry@kernel.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0006/1005] mm/slub: refill prefilled sheaves from the barn
Date: Wed, 25 Nov 2026 15:22:24 +0100
Message-ID: <20261125143821.886512001@linuxfoundation.org>
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

From: Hao Li <hao.li@linux.dev>

commit 1b87ea06a34b213e45e3e0c4effd5043f15046ed upstream.

Currently, when the prefill API refills a non-full sheaf, it takes the
objects from partial slabs and never from the full sheaves in the barn,
so once the barn's full list becomes saturated, it stays saturated.

For objects freed via kfree_rcu(), every RCU sheaf then has to be
flushed to slabs because the barn's full list has no room.

To fix this, let the sheaf refill from the barn first, and introduce a
partial sheaf in the barn, which holds the leftover objects [1].

Only the prefill path needs the partial sheaf. The generic allocation
path (__pcs_replace_empty_main()) exchanges an empty sheaf for a full
one from the barn, so nothing is left over. The prefill path refills a
sheaf that is not necessarily empty, so taking objects from the barn
usually leaves leftovers, and the partial sheaf is where they are
kept. refill_sheaf() only takes objects from partial slabs and never
involves the partial sheaf.

The sheaf is refilled by copying objects from the partial sheaf, and
then from a full sheaf taken from the barn if it is still not full. A
sheaf that objects were copied from stays in the barn as the partial
sheaf if it still holds objects, or goes on the empty list if it is
empty. The sheaf being refilled is never replaced.

The gain comes from two sides: every full sheaf taken out makes room on
the barn's full list for a future RCU sheaf, and refilling from the
barn is cheaper than refilling from partial slabs under list_lock.

Note that putting the sheaf with the leftover objects on the full list
instead would not work: it would occupy room on the full list, so the
list would stay saturated and rcu_free_sheaf() would still keep
flushing.

An earlier version of this patch swapped sheaves instead, to minimize
the memcpy overhead. As Harry Yoo pointed out [2], replacing the
caller's sheaf loses cache affinity, filling it directly is more
straightforward, and testing showed no measurable difference between
the two approaches, so the approach he suggested is used.

Tested with will-it-scale mmap1 (192 processes, one-minute runs) on the
maple_node cache.

throughput: 27778727 -> 34500556 (+24.2%)

metric                       baseline           patched        change
=====================================================================
alloc_fastpath                 54,124            56,696        +4.75%
alloc_slab                  7,100,651           159,739       -97.75%
barn_get                          849       194,460,392    +22904539.81%
barn_get_fail                       2               217    +10750.00%
barn_put                          851       182,306,701    +21422544.07%
barn_put_fail             260,400,484       145,522,675       -44.12%
cmpxchg_double_fail         1,029,204           334,228       -67.53%
free_add_partial          326,694,687       181,935,790       -44.31%
free_fastpath                  13,297            15,611       +17.40%
free_rcu_sheaf          8,332,839,104    10,490,535,227       +25.89%
free_remove_partial         7,099,788           158,297       -97.77%
free_slab                   7,099,788           158,297       -97.77%
free_slowpath              10,969,156           782,851       -92.86%
objects                        15,295            14,849        -2.92%
objects_partial                15,295            14,849        -2.92%
partial                         1,604             2,336       +45.64%
sheaf_alloc               137,757,895       141,208,076        +2.50%
sheaf_flush             8,332,823,922     4,656,725,764       -44.12%
sheaf_free                137,757,883       141,208,072        +2.50%
sheaf_prefill_fast      3,337,502,163     4,196,506,116       +25.74%
sheaf_prefill_slow                685               400       -41.61%
sheaf_refill            8,343,794,364     4,657,509,724       -44.18%
sheaf_return_fast       3,337,502,411     4,196,506,382       +25.74%
sheaf_return_slow                 437               134       -69.34%
slabs                           1,604             2,336       +45.64%
total_objects                 102,656           149,504       +45.64%

Here is what the important metric changes mean.

barn_get and barn_put: refills now take full sheaves out of the barn,
and RCU sheaves are put into the barn again. Before, the barn's full
list was saturated once and hardly ever consumed.

barn_put_fail: more than half of the RCU sheaves are now put into the
barn instead of being flushed. The rest are still flushed because they
arrive while the barn's full list is at its limit.

sheaf_refill and free_add_partial: fewer objects are taken from partial
slabs to refill sheaves, and fewer slabs are added to the partial list,
by the same percentage.

alloc_slab and free_slab: the partial list is almost never empty when a
refill looks at it, so slabs are almost never allocated and freed again
only to serve refills.

After the test, the maple_node cache holds 1604 slabs without the patch
and 2336 with it. After a manual shrink
(echo 1 > /sys/kernel/slab/maple_node/shrink), it holds 485 without
the patch and 563 with it. So most of the extra slabs are held only by
objects sitting in sheaves and are returned by a shrink, and what
remains is a small difference, because objects handed out from the barn
come from many more slabs than a refill from partial slabs would use.

Link: https://lore.kernel.org/linux-mm/aqPlMzUIw-4g2iOX@fedora/ [1]
Link: https://lore.kernel.org/linux-mm/aq0ylDidEHa2kg4X@thinkstation/ [2]
Signed-off-by: Hao Li <hao.li@linux.dev>
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
Link: https://patch.msgid.link/20260921094521.141665-1-hao.li@linux.dev
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/slub.c | 81 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 81 insertions(+)

diff --git a/mm/slub.c b/mm/slub.c
index 6bb75db087a2d..41a66fc15edf8 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -422,6 +422,7 @@ struct node_barn {
 	spinlock_t lock;
 	struct list_head sheaves_full;
 	struct list_head sheaves_empty;
+	struct slab_sheaf *sheaf_partial;
 	unsigned int nr_full;
 	unsigned int nr_empty;
 };
@@ -3298,6 +3299,7 @@ static void barn_init(struct node_barn *barn)
 	spin_lock_init(&barn->lock);
 	INIT_LIST_HEAD(&barn->sheaves_full);
 	INIT_LIST_HEAD(&barn->sheaves_empty);
+	barn->sheaf_partial = NULL;
 	barn->nr_full = 0;
 	barn->nr_empty = 0;
 }
@@ -3315,6 +3317,10 @@ static void barn_shrink(struct kmem_cache *s, struct node_barn *barn)
 	barn->nr_full = 0;
 	list_splice_init(&barn->sheaves_empty, &empty_list);
 	barn->nr_empty = 0;
+	if (barn->sheaf_partial) {
+		list_add(&barn->sheaf_partial->barn_list, &full_list);
+		barn->sheaf_partial = NULL;
+	}
 
 	spin_unlock_irqrestore(&barn->lock, flags);
 
@@ -5073,12 +5079,87 @@ void *kmem_cache_alloc_node_noprof(struct kmem_cache *s, gfp_t gfpflags, int nod
 }
 EXPORT_SYMBOL(kmem_cache_alloc_node_noprof);
 
+/*
+ * Refill @sheaf from the barn: from its partial sheaf first, then from its full
+ * sheaves. A sheaf that objects were copied from stays in the barn as the
+ * partial sheaf if it still holds objects, or goes on the empty list if it is
+ * empty.
+ *
+ * Returns true if the sheaf is now full, at s->sheaf_capacity.
+ * Returns false if the sheaf is still not full.
+ */
+static bool refill_sheaf_from_barn(struct kmem_cache *s,
+				   struct slab_sheaf *sheaf)
+{
+	struct node_barn *barn = get_barn(s);
+	struct slab_sheaf *src;
+	unsigned int to_move;
+	unsigned long flags;
+
+	if (!barn)
+		return false;
+
+	if (!data_race(barn->nr_full) && !data_race(barn->sheaf_partial))
+		return false;
+
+	spin_lock_irqsave(&barn->lock, flags);
+
+	/*
+	 * The partial sheaf can hold fewer objects than @sheaf needs to
+	 * reach capacity, and a sheaf on the full list is not necessarily
+	 * full (see the comment in rcu_free_sheaf()), so keep taking from
+	 * the barn until @sheaf is full or nothing is left.
+	 */
+	while (sheaf->size < s->sheaf_capacity) {
+		src = barn->sheaf_partial;
+		barn->sheaf_partial = NULL;
+		if (!src) {
+			if (!barn->nr_full)
+				break;
+			src = list_first_entry(&barn->sheaves_full,
+					       struct slab_sheaf, barn_list);
+			list_del(&src->barn_list);
+			barn->nr_full--;
+		}
+
+		to_move = min(s->sheaf_capacity - sheaf->size, src->size);
+		src->size -= to_move;
+		memcpy(&sheaf->objects[sheaf->size], &src->objects[src->size],
+		       to_move * sizeof(void *));
+		sheaf->size += to_move;
+
+		if (src->size) {
+			barn->sheaf_partial = src;
+		} else {
+			/*
+			 * No empty-limit check: the sheaf put on the empty list
+			 * was already in the barn, so the barn holds no more
+			 * sheaves than before. barn_replace_empty_sheaf() skips
+			 * the check for the same reason.
+			 */
+			list_add(&src->barn_list, &barn->sheaves_empty);
+			barn->nr_empty++;
+		}
+	}
+
+	spin_unlock_irqrestore(&barn->lock, flags);
+
+	if (sheaf->size < s->sheaf_capacity)
+		return false;
+
+	stat(s, BARN_GET);
+	return true;
+}
+
 static int __prefill_sheaf_pfmemalloc(struct kmem_cache *s,
 				      struct slab_sheaf *sheaf, gfp_t gfp)
 {
 	gfp_t gfp_nomemalloc;
 	int ret;
 
+	if (refill_sheaf_from_barn(s, sheaf))
+		return 0;
+
 	gfp_nomemalloc = gfp | __GFP_NOMEMALLOC;
 	if (gfp_pfmemalloc_allowed(gfp))
 		gfp_nomemalloc |= __GFP_NOWARN;
-- 
2.53.0



