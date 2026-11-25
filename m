Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617930;
	b=aV8ILgtTLs044RR/W+IU3CNa1sSHW17e6xZ+l7G4jFa8ksUGscA6wVS9U3l4zXw6oxOD
	 hVPCwYGFLxVXJ7ggttCHDnsLaaWvo7NH6/+8DGGlYTYuVKeTjbfTF5W9oRoJsNvGTGDjN
	 b5k76kxGlKSveJL8JHqLUJW9G1usA2B/s6n/o9gekk61YqVN4bTeNg6u8tjnLu4MhqT9O
	 nOX57keKUE2SqvG1HFj/gBj7taSK6gStchFM9xmdJUXBUFRHwaq6ZNCHWNUVKPjXTODO/
	 x+kco1jPJyV8nSJZelR7OtBl3QicqZ7Th4MA+dQOjVPaMtO+DNKKD6RLc/T61e/gSRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617930;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/vupTL9o7gEdYgFp4v6I3mrPwvSSlZAFCyVlkxCO1b0=;
	b=OcaIkUqJ4t3VONkZsbZJ0CEMxkFzf0aPrTm2J94bL02E8HljINDAUYflLFT8kfTApQty
	 dWUd/5AE1urZZt8QUNV1PHEmtzziwALUFytyPskZ5AV5lb18BlKrGQkbByFgvnKtWA1md
	 9t8pl12BmnwDO+m8ANXfLi8YiAdYo2Db9uXebEB/QI438SBvQ3ynne2gnILSb5xQItn7d
	 yGpAi1qv0/hKCZAo3mvBLbqgmZ4ovsTNLBYxFxbvoE+3TOmJeS2mP1NIcHXIkDQSfXdZh
	 Z4aCMLSrjzVtsfwwtdRd1a7bByOeznpZu13BvL2o+lkWATbNrVk3NNdV+VPXdFO1IJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0WSTcGdI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4510606A32E;
	Wed, 25 Nov 2026 14:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0WSTcGdI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F30AF1F000F2;
	Wed, 25 Nov 2026 14:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617930;
	bh=/vupTL9o7gEdYgFp4v6I3mrPwvSSlZAFCyVlkxCO1b0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0WSTcGdIa6bZuFefwhc76Pdm8+eYXP4VhlYEKP80X9ZaVraq+jRMe3yldE2KYdzvp
	 MsKvPzMDqNQ46ZRhX/zYncfaCdpwHLSpGccLZM3mdypBnQIPjvxvxQV9/IZjtpsOuf
	 uCf3sgM3UrOLOeHqed7ccXUoQE+UCCeLDY6PzNOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Puranjay Mohan <puranjay@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0075/1005] bpf: Drop percpu_counter from the htab element count
Date: Wed, 25 Nov 2026 15:23:33 +0100
Message-ID: <20261125143823.497349636@linuxfoundation.org>
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

From: Puranjay Mohan <puranjay@kernel.org>

[ Upstream commit 1cd28b5354ab77c727ed87255bf289a87178b415 ]

The element count of a large non-preallocated hash map is a
percpu_counter, whose slow path takes fbc->lock with
raw_spin_lock_irqsave(). That is not safe against BPF programs that run
while the lock is held or contended: NMI programs and, as
queued_spin_lock_slowpath() calls trace_contention_end() with the lock
already held, programs attached to the contention_end tracepoint. If such
a program updates the same map it spins on the lock its own CPU holds:

  WARNING: possible recursive locking detected
  cend/250 is trying to acquire lock:
  (key#5){....}-{2:2}, at: _raw_spin_lock_irqsave+0x18/0x30
  but task is already holding lock:
  (key#5){....}-{2:2}, at: _raw_spin_lock_irqsave+0x18/0x30
    percpu_counter_add_batch+0xd8/0x160
    alloc_htab_elem+0x408/0x480
    htab_map_update_elem+0x1e8/0x6a0
    bpf_prog_7a29a1ae68aedf07_cend+0x14c/0x1f8
    __bpf_trace_contention_end+0x14/0x20
    queued_spin_lock_slowpath+0x2e8/0x468
    percpu_counter_add_batch+0xd8/0x160
    alloc_htab_elem+0x408/0x480
    htab_map_update_elem+0x1e8/0x6a0

is_map_full() is affected too, as __percpu_counter_compare() falls back
to percpu_counter_sum(), which takes the same lock.

map.elem_count already is a lockless per-cpu count of the same elements.
Make htab->count follow it in steps of PERCPU_COUNTER_BATCH and let
is_map_full() sum elem_count once count is within nr_cpu_ids * batch of
max_entries. Each cpu's elem_count is ahead of count by less than the
batch, so that is exact, in NMI as well.

Fixes: 86fe28f7692d ("bpf: Optimize element count in non-preallocated hash map.")
Suggested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Puranjay Mohan <puranjay@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261021185117.650403-1-puranjay@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h  |  2 ++
 kernel/bpf/hashtab.c | 64 ++++++++++++++++++--------------------------
 2 files changed, 28 insertions(+), 38 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index a628f182bb64c..c4d1053bfe2bf 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2916,6 +2916,8 @@ static inline void bpf_map_dec_elem_count(struct bpf_map *map)
 	this_cpu_dec(*map->elem_count);
 }
 
+s64 bpf_map_sum_elem_count(const struct bpf_map *map);
+
 extern int sysctl_unprivileged_bpf_disabled;
 
 bool bpf_token_capable(const struct bpf_token *token, int cap);
diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index b2b27f87d8f55..d41fe658ae847 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -94,10 +94,10 @@ struct bpf_htab {
 		struct bpf_lru lru;
 	};
 	struct htab_elem *__percpu *extra_elems;
-	/* number of elements in non-preallocated hashtable are kept
-	 * in either pcount or count
+	/* number of elements in non-preallocated hashtable. With
+	 * use_percpu_counter it only follows map.elem_count in steps of
+	 * PERCPU_COUNTER_BATCH, see is_map_full()
 	 */
-	struct percpu_counter pcount;
 	atomic_t count;
 	bool use_percpu_counter;
 	u32 n_buckets;	/* number of hash buckets */
@@ -630,29 +630,20 @@ static struct bpf_map *htab_map_alloc(union bpf_attr *attr)
 
 	htab_init_buckets(htab);
 
-/* compute_batch_value() computes batch value as num_online_cpus() * 2
- * and __percpu_counter_compare() needs
- * htab->max_entries - cur_number_of_elems to be more than batch * num_online_cpus()
- * for percpu_counter to be faster than atomic_t. In practice the average bpf
- * hash map size is 10k, which means that a system with 64 cpus will fill
- * hashmap to 20% of 10k before percpu_counter becomes ineffective. Therefore
- * define our own batch count as 32 then 10k hash map can be filled up to 80%:
+/* is_map_full() needs htab->max_entries - cur_number_of_elems to be more than
+ * batch * nr_cpu_ids for the percpu counter to be faster than atomic_t. In
+ * practice the average bpf hash map size is 10k. With batch count of 32 a 10k
+ * hash map on a system with 64 cpus can be filled up to 80%:
  * 10k - 8k > 32 _batch_ * 64 _cpus_
- * and __percpu_counter_compare() will still be fast. At that point hash map
+ * and is_map_full() will still be fast. At that point hash map
  * collisions will dominate its performance anyway. Assume that hash map filled
  * to 50+% isn't going to be O(1) and use the following formula to choose
- * between percpu_counter and atomic_t.
+ * between the percpu counter and atomic_t. The batch has to be a power of 2.
  */
 #define PERCPU_COUNTER_BATCH 32
-	if (attr->max_entries / 2 > num_online_cpus() * PERCPU_COUNTER_BATCH)
+	if (attr->max_entries / 2 > nr_cpu_ids * PERCPU_COUNTER_BATCH)
 		htab->use_percpu_counter = true;
 
-	if (htab->use_percpu_counter) {
-		err = percpu_counter_init(&htab->pcount, 0, GFP_KERNEL);
-		if (err)
-			goto free_map_locked;
-	}
-
 	if (prealloc) {
 		err = prealloc_init(htab);
 		if (err)
@@ -680,8 +671,6 @@ static struct bpf_map *htab_map_alloc(union bpf_attr *attr)
 free_prealloc:
 	prealloc_destroy(htab);
 free_map_locked:
-	if (htab->use_percpu_counter)
-		percpu_counter_destroy(&htab->pcount);
 	bpf_map_area_free(htab->buckets);
 	bpf_mem_alloc_destroy(&htab->pcpu_ma);
 	bpf_mem_alloc_destroy(&htab->ma);
@@ -990,30 +979,33 @@ static void htab_put_fd_value(struct bpf_htab *htab, struct htab_elem *l)
 
 static bool is_map_full(struct bpf_htab *htab)
 {
-	if (htab->use_percpu_counter)
-		return __percpu_counter_compare(&htab->pcount, htab->map.max_entries,
-						PERCPU_COUNTER_BATCH) >= 0;
-	return atomic_read(&htab->count) >= htab->map.max_entries;
+	s64 count = atomic_read(&htab->count);
+
+	/* each cpu's elem_count is ahead of count by less than the batch */
+	if (htab->use_percpu_counter &&
+	    count + nr_cpu_ids * PERCPU_COUNTER_BATCH >= htab->map.max_entries)
+		count = bpf_map_sum_elem_count(&htab->map);
+	return count >= htab->map.max_entries;
 }
 
 static void inc_elem_count(struct bpf_htab *htab)
 {
-	bpf_map_inc_elem_count(&htab->map);
+	s64 cnt = this_cpu_inc_return(*htab->map.elem_count);
 
-	if (htab->use_percpu_counter)
-		percpu_counter_add_batch(&htab->pcount, 1, PERCPU_COUNTER_BATCH);
-	else
+	if (!htab->use_percpu_counter)
 		atomic_inc(&htab->count);
+	else if (!(cnt & (PERCPU_COUNTER_BATCH - 1)))
+		atomic_add(PERCPU_COUNTER_BATCH, &htab->count);
 }
 
 static void dec_elem_count(struct bpf_htab *htab)
 {
-	bpf_map_dec_elem_count(&htab->map);
+	s64 cnt = this_cpu_dec_return(*htab->map.elem_count);
 
-	if (htab->use_percpu_counter)
-		percpu_counter_add_batch(&htab->pcount, -1, PERCPU_COUNTER_BATCH);
-	else
+	if (!htab->use_percpu_counter)
 		atomic_dec(&htab->count);
+	else if (!((cnt + 1) & (PERCPU_COUNTER_BATCH - 1)))
+		atomic_sub(PERCPU_COUNTER_BATCH, &htab->count);
 }
 
 static void free_htab_elem(struct bpf_htab *htab, struct htab_elem *l)
@@ -1682,8 +1674,6 @@ static void htab_map_free(struct bpf_map *map)
 	bpf_map_area_free(htab->buckets);
 	bpf_mem_alloc_destroy(&htab->pcpu_ma);
 	bpf_mem_alloc_destroy(&htab->ma);
-	if (htab->use_percpu_counter)
-		percpu_counter_destroy(&htab->pcount);
 	bpf_map_area_free(htab);
 }
 
@@ -2393,9 +2383,7 @@ static u64 htab_map_mem_usage(const struct bpf_map *map)
 	} else {
 #define LLIST_NODE_SZ sizeof(struct llist_node)
 
-		num_entries = htab->use_percpu_counter ?
-					  percpu_counter_sum(&htab->pcount) :
-					  atomic_read(&htab->count);
+		num_entries = bpf_map_sum_elem_count(map);
 		usage += (htab->elem_size + LLIST_NODE_SZ) * num_entries;
 		if (percpu) {
 			usage += (LLIST_NODE_SZ + sizeof(void *)) * num_entries;
-- 
2.53.0



