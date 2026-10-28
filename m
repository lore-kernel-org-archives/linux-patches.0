Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216640;
	b=Mv01NGzvHDukIqbBdqZ5LgZBJptnqBt8OrRVwtcCfrSUqvoOPf2zvbbjMzFcumSydLnf
	 9CIqEenWDlDZLNmYKkKnaScTibC5a6Mkz3YSGsrMNZDCamHnWOrMj46BQgU9bSsy/7O1Y
	 8dvZQ9pWQln1grc1kFbCQcqyy8R+fn2rk9WQbwVPZqw6uwf2E25vaUmJ21dvkG/xcRGEU
	 el6UkK2gENCxwhvAJKzgwNzML5hXO8ZINABui66i7NgrLBi7GXKTfbII/a/P+Z98C/ws2
	 mxFr0tVtF2be9xcEgJUoCtNsNSGn5nGheRPaz03jGb4Vcpc2hcIOUMnjXNIzNgH/G4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216640;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qCta5oPPqWbDtp4r2nvKQax4BsUVGvYdirwsl7AYjCY=;
	b=fGzRbqsh0Ye8eVJ03d2FVjQrne+REc26CQ9r1gAVHUMWEfv70x9MEvfQSCBVQ3UJw3DD
	 f4W2G2eFPxKC40yzubINd+iEUHCWALzwPDg1EhBjXXhwpdL9uyyivBvnVKeLwaPNheO1V
	 1o6rxy5l6OOEgspnDnnzwf8BETpLBwzMw7WRGUnCStEGCCJt8oSPnmXdaERecF+pyPBNr
	 tcLHfI3Hd6WpRiUF0il1zZ+lozl+9OK1C9/gaIZZSkq2x9QSyfpaehxyXdSpjWFoR9i2c
	 SBhtJBGVnDEE0Tiu4jaR49lmYKCP351gLOenZrUrepUcYEj0qtbbXvVb0hNSM9/JTYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="B0TeaB/m";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2A7606A31A;
	Wed, 28 Oct 2026 19:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B0TeaB/m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69A381F01825;
	Wed, 28 Oct 2026 19:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216640;
	bh=qCta5oPPqWbDtp4r2nvKQax4BsUVGvYdirwsl7AYjCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B0TeaB/mx35D/BQKaCzl8NzFILvVLCPv9gnz4iyzcniV4VsvqnzG1z+tYRHw/3OMO
	 VUzdckifNXAmlSlwnZ6LfYea4k88Zx8VkDz9pQpBGDQSTreA+gX6DsG8DKO+w754s6
	 pPSRYSY6CP7/N9giDTuXzl4HcxFrg0RKK6yqziQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kui-Feng Lee <kuifeng@meta.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1600/1887] bpf: Retire the struct_ops map kvalue->refcnt.
Date: Wed, 28 Oct 2026 18:01:36 +0100
Message-ID: <20261028170535.880337998@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kui-Feng Lee <kuifeng@meta.com>

[ Upstream commit b671c2067a04c0668df174ff5dfdb573d1f9b074 ]

We have replaced kvalue-refcnt with synchronize_rcu() to wait for an
RCU grace period.

Maintenance of kvalue->refcnt was a complicated task, as we had to
simultaneously keep track of two reference counts: one for the
reference count of bpf_map. When the kvalue->refcnt reaches zero, we
also have to reduce the reference count on bpf_map - yet these steps
are not performed in an atomic manner and require us to be vigilant
when managing them. By eliminating kvalue->refcnt, we can make our
maintenance more straightforward as the refcount of bpf_map is now
solely managed!

To prevent the trampoline image of a struct_ops from being released
while it is still in use, we wait for an RCU grace period. The
setsockopt(TCP_CONGESTION, "...") command allows you to change your
socket's congestion control algorithm and can result in releasing the
old struct_ops implementation. It is fine. However, this function is
exposed through bpf_setsockopt(), it may be accessed by BPF programs
as well. To ensure that the trampoline image belonging to struct_op
can be safely called while its method is in use, the trampoline
safeguarde the BPF program with rcu_read_lock(). Doing so prevents any
destruction of the associated images before returning from a
trampoline and requires us to wait for an RCU grace period.

Signed-off-by: Kui-Feng Lee <kuifeng@meta.com>
Link: https://lore.kernel.org/r/20230323032405.3735486-2-kuifeng@meta.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Stable-dep-of: 863f3ddd0b8a ("bpf: Fix potential UAF when reading bpf link info")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h         |  1 +
 kernel/bpf/bpf_struct_ops.c | 77 +++++++++++++++++++++----------------
 kernel/bpf/syscall.c        |  6 ++-
 3 files changed, 49 insertions(+), 35 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 4f09079ecaebd..546d40d82edbc 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1813,6 +1813,7 @@ struct bpf_map *bpf_map_get_with_uref(u32 ufd);
 struct bpf_map *__bpf_map_get(struct fd f);
 void bpf_map_inc(struct bpf_map *map);
 void bpf_map_inc_with_uref(struct bpf_map *map);
+struct bpf_map *__bpf_map_inc_not_zero(struct bpf_map *map, bool uref);
 struct bpf_map * __must_check bpf_map_inc_not_zero(struct bpf_map *map);
 void bpf_map_put_with_uref(struct bpf_map *map);
 void bpf_map_put(struct bpf_map *map);
diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
index 84b2d9dba79a7..4daedbb6bf13a 100644
--- a/kernel/bpf/bpf_struct_ops.c
+++ b/kernel/bpf/bpf_struct_ops.c
@@ -11,6 +11,7 @@
 #include <linux/refcount.h>
 #include <linux/mutex.h>
 #include <linux/btf_ids.h>
+#include <linux/rcupdate_wait.h>
 
 enum bpf_struct_ops_state {
 	BPF_STRUCT_OPS_STATE_INIT,
@@ -249,6 +250,7 @@ int bpf_struct_ops_map_sys_lookup_elem(struct bpf_map *map, void *key,
 	struct bpf_struct_ops_map *st_map = (struct bpf_struct_ops_map *)map;
 	struct bpf_struct_ops_value *uvalue, *kvalue;
 	enum bpf_struct_ops_state state;
+	s64 refcnt;
 
 	if (unlikely(*(u32 *)key != 0))
 		return -ENOENT;
@@ -267,7 +269,14 @@ int bpf_struct_ops_map_sys_lookup_elem(struct bpf_map *map, void *key,
 	uvalue = value;
 	memcpy(uvalue, st_map->uvalue, map->value_size);
 	uvalue->state = state;
-	refcount_set(&uvalue->refcnt, refcount_read(&kvalue->refcnt));
+
+	/* This value offers the user space a general estimate of how
+	 * many sockets are still utilizing this struct_ops for TCP
+	 * congestion control. The number might not be exact, but it
+	 * should sufficiently meet our present goals.
+	 */
+	refcnt = atomic64_read(&map->refcnt) - atomic64_read(&map->usercnt);
+	refcount_set(&uvalue->refcnt, max_t(s64, refcnt, 0));
 
 	return 0;
 }
@@ -491,7 +500,6 @@ static int bpf_struct_ops_map_update_elem(struct bpf_map *map, void *key,
 		*(unsigned long *)(udata + moff) = prog->aux->id;
 	}
 
-	refcount_set(&kvalue->refcnt, 1);
 	bpf_map_inc(map);
 
 	set_memory_ro((long)st_map->image, 1);
@@ -537,8 +545,7 @@ static int bpf_struct_ops_map_delete_elem(struct bpf_map *map, void *key)
 	switch (prev_state) {
 	case BPF_STRUCT_OPS_STATE_INUSE:
 		st_map->st_ops->unreg(&st_map->kvalue.data);
-		if (refcount_dec_and_test(&st_map->kvalue.refcnt))
-			bpf_map_put(map);
+		bpf_map_put(map);
 		return 0;
 	case BPF_STRUCT_OPS_STATE_TOBEFREE:
 		return -EINPROGRESS;
@@ -571,7 +578,7 @@ static void bpf_struct_ops_map_seq_show_elem(struct bpf_map *map, void *key,
 	kfree(value);
 }
 
-static void bpf_struct_ops_map_free(struct bpf_map *map)
+static void __bpf_struct_ops_map_free(struct bpf_map *map)
 {
 	struct bpf_struct_ops_map *st_map = (struct bpf_struct_ops_map *)map;
 
@@ -583,6 +590,28 @@ static void bpf_struct_ops_map_free(struct bpf_map *map)
 	bpf_map_area_free(st_map);
 }
 
+static void bpf_struct_ops_map_free(struct bpf_map *map)
+{
+	/* The struct_ops's function may switch to another struct_ops.
+	 *
+	 * For example, bpf_tcp_cc_x->init() may switch to
+	 * another tcp_cc_y by calling
+	 * setsockopt(TCP_CONGESTION, "tcp_cc_y").
+	 * During the switch,  bpf_struct_ops_put(tcp_cc_x) is called
+	 * and its refcount may reach 0 which then free its
+	 * trampoline image while tcp_cc_x is still running.
+	 *
+	 * A vanilla rcu gp is to wait for all bpf-tcp-cc prog
+	 * to finish. bpf-tcp-cc prog is non sleepable.
+	 * A rcu_tasks gp is to wait for the last few insn
+	 * in the tramopline image to finish before releasing
+	 * the trampoline image.
+	 */
+	synchronize_rcu_mult(call_rcu, call_rcu_tasks);
+
+	__bpf_struct_ops_map_free(map);
+}
+
 static int bpf_struct_ops_map_alloc_check(union bpf_attr *attr)
 {
 	if (attr->key_size != sizeof(unsigned int) || attr->max_entries != 1 ||
@@ -631,7 +660,7 @@ static struct bpf_map *bpf_struct_ops_map_alloc(union bpf_attr *attr)
 				   NUMA_NO_NODE);
 	st_map->image = bpf_jit_alloc_exec(PAGE_SIZE);
 	if (!st_map->uvalue || !st_map->links || !st_map->image) {
-		bpf_struct_ops_map_free(map);
+		__bpf_struct_ops_map_free(map);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -661,41 +690,23 @@ const struct bpf_map_ops bpf_struct_ops_map_ops = {
 bool bpf_struct_ops_get(const void *kdata)
 {
 	struct bpf_struct_ops_value *kvalue;
+	struct bpf_struct_ops_map *st_map;
+	struct bpf_map *map;
 
 	kvalue = container_of(kdata, struct bpf_struct_ops_value, data);
+	st_map = container_of(kvalue, struct bpf_struct_ops_map, kvalue);
 
-	return refcount_inc_not_zero(&kvalue->refcnt);
-}
-
-static void bpf_struct_ops_put_rcu(struct rcu_head *head)
-{
-	struct bpf_struct_ops_map *st_map;
-
-	st_map = container_of(head, struct bpf_struct_ops_map, rcu);
-	bpf_map_put(&st_map->map);
+	map = __bpf_map_inc_not_zero(&st_map->map, false);
+	return !IS_ERR(map);
 }
 
 void bpf_struct_ops_put(const void *kdata)
 {
 	struct bpf_struct_ops_value *kvalue;
+	struct bpf_struct_ops_map *st_map;
 
 	kvalue = container_of(kdata, struct bpf_struct_ops_value, data);
-	if (refcount_dec_and_test(&kvalue->refcnt)) {
-		struct bpf_struct_ops_map *st_map;
-
-		st_map = container_of(kvalue, struct bpf_struct_ops_map,
-				      kvalue);
-		/* The struct_ops's function may switch to another struct_ops.
-		 *
-		 * For example, bpf_tcp_cc_x->init() may switch to
-		 * another tcp_cc_y by calling
-		 * setsockopt(TCP_CONGESTION, "tcp_cc_y").
-		 * During the switch,  bpf_struct_ops_put(tcp_cc_x) is called
-		 * and its map->refcnt may reach 0 which then free its
-		 * trampoline image while tcp_cc_x is still running.
-		 *
-		 * Thus, a rcu grace period is needed here.
-		 */
-		call_rcu(&st_map->rcu, bpf_struct_ops_put_rcu);
-	}
+	st_map = container_of(kvalue, struct bpf_struct_ops_map, kvalue);
+
+	bpf_map_put(&st_map->map);
 }
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index e32d9b9de0dcb..f629db72bd1c2 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1298,8 +1298,10 @@ struct bpf_map *bpf_map_get_with_uref(u32 ufd)
 	return map;
 }
 
-/* map_idr_lock should have been held */
-static struct bpf_map *__bpf_map_inc_not_zero(struct bpf_map *map, bool uref)
+/* map_idr_lock should have been held or the map should have been
+ * protected by rcu read lock.
+ */
+struct bpf_map *__bpf_map_inc_not_zero(struct bpf_map *map, bool uref)
 {
 	int refold;
 
-- 
2.53.0



