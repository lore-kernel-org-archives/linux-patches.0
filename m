Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212408;
	b=naEtCRSC3R8N7wQNzSHEhbUWMlwYwTSm3Q8tbp7SNOCjhHizm6Q0bA/K8kseZhLX0OXz
	 0F6FNrRNVzD3GRDOeYw/DHguVPDddDwWfARGk2wJfTGbky82uaDUauOlXCcPDGcYR7Pv9
	 R3QMtX3Eu2bZdQrgqN9sPXJRbjPaXWY9zbDE3yIu2SzKvoKMgv1QNj0NUKjcpe8pqmnnG
	 5IdzjChxS4zJJOkO3wqzt/Qzux8Nv8vPnv1qXbHPVa/y+Rj29cDp1Z5SBBMoAq2ONU84+
	 kQ4QtdsxlM5S41+fwJCp5OIWtMyBshTJ3LPbzTg+O0Q24edEKhWMgCb2LshVZBREFPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212408;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DT/qJLhUm/34MRu0M4npWj9gtTbpcuW+MH6VOWlkbA4=;
	b=M37hvsqW46cnCp5emjHQ/kM/tUt0di6bNlrdUulFgwN0zjgsTlv3M/GhLRtv5Bc4T9lK
	 o29UsGhsWjF/kqT7rLnWVw0ukxIv/tpEqBfMN1RLMvsclxkUCBoDlnJnvBwQ7UL+25VDs
	 yplbpYtG5htUgouJH7J+9DhQ1wHUvfFyXHdYr/uvLUXQtIqIJP07DNb+GP2AcYB3vdHpj
	 omI55U1P6FRANv//5EfssVwTckwvO35rg+Af/FVIZpwENfaW+Lsbk5OzS3SBnSJbPEN5B
	 1vJwapRKxt8ZUoz2Tjr/QaSEQ3K9AFViDFPzNHmTCn/AvKQKVDSrhzdAmLJrm28NLfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Yces/QXM";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65A2606A32A;
	Wed, 28 Oct 2026 18:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yces/QXM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0202B1F031E3;
	Wed, 28 Oct 2026 18:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212407;
	bh=DT/qJLhUm/34MRu0M4npWj9gtTbpcuW+MH6VOWlkbA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yces/QXMdOlEWazZfjJ5RXap85XpE+H4M70sgwasBJejU9RmqSz7TrKXzVXE7ocTG
	 hq3cl739DqzsbmpJZx9l4Swq6mPWpqOJkIa21sSE6vRnRQ8UsxDCrOvcp7Vqvc5BgI
	 jvsw5VB+IjahKpkVUV348LaXNFZzI/54Eyg9zXlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Muchun Song <songmuchun@bytedance.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0142/1887] mm/kmemleak: fix UAF bug in kmemleak_scan()
Date: Wed, 28 Oct 2026 17:37:18 +0100
Message-ID: <20261028170502.466658570@linuxfoundation.org>
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

From: Waiman Long <longman@redhat.com>

[ Upstream commit 782e4179535971c3574c367bfaaefea8970b3e0b ]

Commit 6edda04ccc7c ("mm/kmemleak: prevent soft lockup in first object
iteration loop of kmemleak_scan()") fixes soft lockup problem in
kmemleak_scan() by periodically doing a cond_resched().  It does take a
reference of the current object before doing it.  Unfortunately, if the
object has been deleted from the object_list, the next object pointed to
by its next pointer may no longer be valid after coming back from
cond_resched().  This can result in use-after-free and other nasty
problem.

Fix this problem by adding a del_state flag into kmemleak_object structure
to synchronize the object deletion process between kmemleak_cond_resched()
and __remove_object() to make sure that the object remained in the
object_list in the duration of the cond_resched() call.

Link: https://lkml.kernel.org/r/20230119040111.350923-3-longman@redhat.com
Fixes: 6edda04ccc7c ("mm/kmemleak: prevent soft lockup in first object iteration loop of kmemleak_scan()")
Signed-off-by: Waiman Long <longman@redhat.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/kmemleak.c | 35 +++++++++++++++++++++++++++++------
 1 file changed, 29 insertions(+), 6 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index fa01854e32b09..3e41e669e2528 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -13,11 +13,12 @@
  *
  * The following locks and mutexes are used by kmemleak:
  *
- * - kmemleak_lock (raw_spinlock_t): protects the object_list modifications and
- *   accesses to the object_tree_root (or object_phys_tree_root). The
- *   object_list is the main list holding the metadata (struct kmemleak_object)
- *   for the allocated memory blocks. The object_tree_root and object_phys_tree_root
- *   are red black trees used to look-up metadata based on a pointer to the
+ * - kmemleak_lock (raw_spinlock_t): protects the object_list as well as
+ *   del_state modifications and accesses to the object_tree_root (or
+ *   object_phys_tree_root). The object_list is the main list holding the
+ *   metadata (struct kmemleak_object) for the allocated memory blocks.
+ *   The object_tree_root and object_phys_tree_root are red
+ *   black trees used to look-up metadata based on a pointer to the
  *   corresponding memory block. The object_phys_tree_root is for objects
  *   allocated with physical address. The kmemleak_object structures are
  *   added to the object_list and object_tree_root (or object_phys_tree_root)
@@ -147,6 +148,7 @@ struct kmemleak_object {
 	struct rcu_head rcu;		/* object_list lockless traversal */
 	/* object usage count; object freed when use_count == 0 */
 	atomic_t use_count;
+	unsigned int del_state;		/* deletion state */
 	unsigned long pointer;
 	size_t size;
 	/* pass surplus references to this pointer */
@@ -177,6 +179,11 @@ struct kmemleak_object {
 /* flag set for object allocated with physical address */
 #define OBJECT_PHYS		(1 << 4)
 
+/* set when __remove_object() called */
+#define DELSTATE_REMOVED	(1 << 0)
+/* set to temporarily prevent deletion from object_list */
+#define DELSTATE_NO_DELETE	(1 << 1)
+
 #define HEX_PREFIX		"    "
 /* number of bytes to print per line; must be 16 or 32 */
 #define HEX_ROW_SIZE		16
@@ -570,7 +577,9 @@ static void __remove_object(struct kmemleak_object *object)
 	rb_erase(&object->rb_node, object->flags & OBJECT_PHYS ?
 				   &object_phys_tree_root :
 				   &object_tree_root);
-	list_del_rcu(&object->object_list);
+	if (!(object->del_state & DELSTATE_NO_DELETE))
+		list_del_rcu(&object->object_list);
+	object->del_state |= DELSTATE_REMOVED;
 }
 
 /*
@@ -636,6 +645,7 @@ static void __create_object(unsigned long ptr, size_t size,
 	object->count = 0;			/* white color initially */
 	object->jiffies = jiffies;
 	object->checksum = 0;
+	object->del_state = 0;
 
 	/* task information */
 	if (in_hardirq()) {
@@ -1473,9 +1483,22 @@ static void kmemleak_cond_resched(struct kmemleak_object *object)
 	if (!get_object(object))
 		return;	/* Try next object */
 
+	raw_spin_lock_irq(&kmemleak_lock);
+	if (object->del_state & DELSTATE_REMOVED)
+		goto unlock_put;	/* Object removed */
+	object->del_state |= DELSTATE_NO_DELETE;
+	raw_spin_unlock_irq(&kmemleak_lock);
+
 	rcu_read_unlock();
 	cond_resched();
 	rcu_read_lock();
+
+	raw_spin_lock_irq(&kmemleak_lock);
+	if (object->del_state & DELSTATE_REMOVED)
+		list_del_rcu(&object->object_list);
+	object->del_state &= ~DELSTATE_NO_DELETE;
+unlock_put:
+	raw_spin_unlock_irq(&kmemleak_lock);
 	put_object(object);
 }
 
-- 
2.53.0



