Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053095;
	b=Xz2aeWkGYN3PE+R8ILuVdROehyNOb5mL61iPje/Y5ICAPd8KeS8n5baijGIjcaMImrjt
	 D77bHPBRSB89p7gF/8GOWMpZWpcdM2lmuYaWP+qWBG8Rx8mQGW4FmEFdvxNZiQ921hSgL
	 EHgjyBoGqRjWUJYSk/vWQDo4oUOoULHkjLL9gjerM5vauUtRsTpad7KrKoqJELqkd2BQU
	 26/owpMd7j1V2iaFi6MMxySRcntk7v9bgADg+jW7AfSyWWFo2N/7tcn0TrEqq2o8FEU/o
	 5KrcXHrxFiTo4MGh7MM5K7lnEMPJaFpWUwJMGz40SCcQgkfw2Y1gh2qOu2HiD5HR8EQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053095;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5l2f8xmSVEF8JYFEa0dRTJzOfff8dsYZEyLN3QU0Xr8=;
	b=VsntNy8VGWmsJpo9PU8qd1kq7fTS1j4UbN3DqzE+xQJqKJT7HeOEnoKO11b79qvhRz3k
	 NpZ+O157nyinJw2urb8MwZ/OjpDqdIjcTvSVRj6zMc8y/3s8rHB32aWyDbh/YQ0fTEL/M
	 JXfhdySrCKk0vWzKD9EvepkkhnusP4ufkGvJjnov7c2il06LUuU/vpWEZ9xHVdA6gcuS+
	 299zn9aYnXfyFZmYuDrB+ygTT+ewaOVNyuTGckrNoZIz1ephX9FEvR+SOgYQ1WWls1mnC
	 uCB6+k/6LTe/zo8GCrt9mjLdkEfppFtWjfOV5nCGoCU/A5EVBMr2gNpvMJ+wHMFHvRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=abXvgAB2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60FF606A320;
	Thu, 19 Nov 2026 01:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=abXvgAB2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30BEE1F000C4;
	Thu, 19 Nov 2026 01:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053095;
	bh=5l2f8xmSVEF8JYFEa0dRTJzOfff8dsYZEyLN3QU0Xr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=abXvgAB2Rvm+p8edPc0YGtZpdhgbj/gkCaU+U47duwV5KAiFnw2MVmxmPW0WCVjD+
	 StzX4r10Qc6+DoYUGmcneIXuD3XGb0s+chTVdOz6St96S7QdoBfpuLHJU9HWrzVv2P
	 8uol97BbRIcfEy+5Mr2kzAvqX8HWJOluuCN/jViA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Christian Loehle <christian.loehle@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0799/2214] debugobjects,locking: Annotate debug_object_fill_pool() wait type violation
Date: Wed, 18 Nov 2026 15:41:15 +0100
Message-ID: <20261118150043.489602238@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

commit 0cce06ba859a515bd06224085d3addb870608b6d upstream.

There is an explicit wait-type violation in debug_object_fill_pool()
for PREEMPT_RT=n kernels which allows them to more easily fill the
object pool and reduce the chance of allocation failures.

Lockdep's wait-type checks are designed to check the PREEMPT_RT
locking rules even for PREEMPT_RT=n kernels and object to this, so
create a lockdep annotation to allow this to stand.

Specifically, create a 'lock' type that overrides the inner wait-type
while it is held -- allowing one to temporarily raise it, such that
the violation is hidden.

Reported-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Qi Zheng <zhengqi.arch@bytedance.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Qi Zheng <zhengqi.arch@bytedance.com>
Link: https://lkml.kernel.org/r/20230429100614.GA1489784@hirez.programming.kicks-ass.net
Signed-off-by: Christian Loehle <christian.loehle@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/lockdep.h       | 14 ++++++++++++++
 include/linux/lockdep_types.h |  1 +
 kernel/locking/lockdep.c      | 28 +++++++++++++++++++++-------
 lib/debugobjects.c            | 15 +++++++++++++--
 4 files changed, 49 insertions(+), 9 deletions(-)

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index e8cb0f1925ba4..5abb22964e36c 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -345,6 +345,16 @@ extern void lock_unpin_lock(struct lockdep_map *lock, struct pin_cookie);
 #define lockdep_repin_lock(l,c)	lock_repin_lock(&(l)->dep_map, (c))
 #define lockdep_unpin_lock(l,c)	lock_unpin_lock(&(l)->dep_map, (c))
 
+/*
+ * Must use lock_map_aquire_try() with override maps to avoid
+ * lockdep thinking they participate in the block chain.
+ */
+#define DEFINE_WAIT_OVERRIDE_MAP(_name, _wait_type)	\
+	struct lockdep_map _name = {			\
+		.name = #_name "-wait-type-override",	\
+		.wait_type_inner = _wait_type,		\
+		.lock_type = LD_LOCK_WAIT_OVERRIDE, }
+
 #else /* !CONFIG_LOCKDEP */
 
 static inline void lockdep_init_task(struct task_struct *task)
@@ -432,6 +442,9 @@ extern int lockdep_is_held(const void *);
 #define lockdep_repin_lock(l, c)		do { (void)(l); (void)(c); } while (0)
 #define lockdep_unpin_lock(l, c)		do { (void)(l); (void)(c); } while (0)
 
+#define DEFINE_WAIT_OVERRIDE_MAP(_name, _wait_type)	\
+	struct lockdep_map __maybe_unused _name = {}
+
 #endif /* !LOCKDEP */
 
 #ifdef CONFIG_PROVE_LOCKING
@@ -582,6 +595,7 @@ do {									\
 #define rwsem_release(l, i)			lock_release(l, i)
 
 #define lock_map_acquire(l)			lock_acquire_exclusive(l, 0, 0, NULL, _THIS_IP_)
+#define lock_map_acquire_try(l)			lock_acquire_exclusive(l, 0, 1, NULL, _THIS_IP_)
 #define lock_map_acquire_read(l)		lock_acquire_shared_recursive(l, 0, 0, NULL, _THIS_IP_)
 #define lock_map_acquire_tryread(l)		lock_acquire_shared_recursive(l, 0, 1, NULL, _THIS_IP_)
 #define lock_map_release(l)			lock_release(l, _THIS_IP_)
diff --git a/include/linux/lockdep_types.h b/include/linux/lockdep_types.h
index 6c5c270469469..aaa681ba65546 100644
--- a/include/linux/lockdep_types.h
+++ b/include/linux/lockdep_types.h
@@ -33,6 +33,7 @@ enum lockdep_wait_type {
 enum lockdep_lock_type {
 	LD_LOCK_NORMAL = 0,	/* normal, catch all */
 	LD_LOCK_PERCPU,		/* percpu */
+	LD_LOCK_WAIT_OVERRIDE,	/* annotation */
 	LD_LOCK_MAX,
 };
 
diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index 43a58e749d5fc..7fdf066620c2d 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -2253,6 +2253,9 @@ static inline bool usage_match(struct lock_list *entry, void *mask)
 
 static inline bool usage_skip(struct lock_list *entry, void *mask)
 {
+	if (entry->class->lock_type == LD_LOCK_NORMAL)
+		return false;
+
 	/*
 	 * Skip local_lock() for irq inversion detection.
 	 *
@@ -2279,14 +2282,16 @@ static inline bool usage_skip(struct lock_list *entry, void *mask)
 	 * As a result, we will skip local_lock(), when we search for irq
 	 * inversion bugs.
 	 */
-	if (entry->class->lock_type == LD_LOCK_PERCPU) {
-		if (DEBUG_LOCKS_WARN_ON(entry->class->wait_type_inner < LD_WAIT_CONFIG))
-			return false;
+	if (entry->class->lock_type == LD_LOCK_PERCPU &&
+	    DEBUG_LOCKS_WARN_ON(entry->class->wait_type_inner < LD_WAIT_CONFIG))
+		return false;
 
-		return true;
-	}
+	/*
+	 * Skip WAIT_OVERRIDE for irq inversion detection -- it's not actually
+	 * a lock and only used to override the wait_type.
+	 */
 
-	return false;
+	return true;
 }
 
 /*
@@ -4781,7 +4786,8 @@ static int check_wait_context(struct task_struct *curr, struct held_lock *next)
 
 	for (; depth < curr->lockdep_depth; depth++) {
 		struct held_lock *prev = curr->held_locks + depth;
-		u8 prev_inner = hlock_class(prev)->wait_type_inner;
+		struct lock_class *class = hlock_class(prev);
+		u8 prev_inner = class->wait_type_inner;
 
 		if (prev_inner) {
 			/*
@@ -4791,6 +4797,14 @@ static int check_wait_context(struct task_struct *curr, struct held_lock *next)
 			 * Also due to trylocks.
 			 */
 			curr_inner = min(curr_inner, prev_inner);
+
+			/*
+			 * Allow override for annotations -- this is typically
+			 * only valid/needed for code that only exists when
+			 * CONFIG_PREEMPT_RT=n.
+			 */
+			if (unlikely(class->lock_type == LD_LOCK_WAIT_OVERRIDE))
+				curr_inner = prev_inner;
 		}
 	}
 
diff --git a/lib/debugobjects.c b/lib/debugobjects.c
index 81b319d574176..29b495adac242 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -609,10 +609,21 @@ __debug_object_init(void *addr, const struct debug_obj_descr *descr, int onstack
 
 	/*
 	 * On RT enabled kernels the pool refill must happen in preemptible
-	 * context:
+	 * context -- for !RT kernels we rely on the fact that spinlock_t and
+	 * raw_spinlock_t are basically the same type and this lock-type
+	 * inversion works just fine.
 	 */
-	if (!IS_ENABLED(CONFIG_PREEMPT_RT) || preemptible())
+	if (!IS_ENABLED(CONFIG_PREEMPT_RT) || preemptible()) {
+		/*
+		 * Annotate away the spinlock_t inside raw_spinlock_t warning
+		 * by temporarily raising the wait-type to LD_WAIT_SLEEP,
+		 * allowing the allocator's spinlock_t and local_lock_t locks.
+		 */
+		static DEFINE_WAIT_OVERRIDE_MAP(fill_pool_map, LD_WAIT_SLEEP);
+		lock_map_acquire_try(&fill_pool_map);
 		fill_pool();
+		lock_map_release(&fill_pool_map);
+	}
 
 	db = get_bucket((unsigned long) addr);
 
-- 
2.53.0



