Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590354;
	b=sarE06JpIpCQSpCK5Ocg56dBTcwgFgS7w1pSzUL6E2yem20bdgmyYJ+IxRZFt24pIzf0
	 BKyaZhSSnjGdhVXQhxRAklnRqoqHHeVC7m6+KiR1PwaC8F8UMauA4HoI4tbQzfkbheXl2
	 8TFNr30smBYmIUh+JLNtiXTBOf/R+TN7xzGi9V5iFWCPrZJ1R+gb4H+zlvLca9BTgM92x
	 iBqpw5fbIbOQr0Y6phpN3RiIwBxE1+UVYGMOz0SOCkol0ip26lqRzyHXpu7jgBZ3tROs4
	 walhQHYt52FrMnuKFWzebaIf8njGGk7GOv16iYg34krOHVpRq4drkyJ3MjugXEnhK3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590354;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fO/ETl6OBcDj/DAYyXC6SQq5XAKBI/DtKWWtjgksudg=;
	b=JzUKGiYT8Xm+a41CGSyZij0hHa9lkJ55W7Zip++xpmwSQ3OM1ELchyfkBULzlSpcOL5p
	 lX97qpru3Kyr6OqERh8+TD52g2lbcFagSQ8z6c3a0Oe//jL1xuYxgZUivoXyhOWx8V5pF
	 QxqUCSouqViR+5Kr4hiZ1EdDozy/pptUGTzvWINqYAuk2LsXKSwcvugJCAoFA2pV4zFSz
	 4GY9FDSFxtlH8tqptnbNB3Q72Pr4qKu5wSSS5KxJJZ83oOJcfbrv4TxL73gQYWIhNGvy7
	 Vnh029PN6/qbK7R03KAOYFzqK3v3mKy5Kk2IZF/otekYeDdiOMGhIvKDbv70GhUFIfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cfTZgGg6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C27606E23A;
	Fri, 13 Nov 2026 17:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cfTZgGg6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFE041F000C4;
	Fri, 13 Nov 2026 17:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590354;
	bh=fO/ETl6OBcDj/DAYyXC6SQq5XAKBI/DtKWWtjgksudg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cfTZgGg6aWj/kBHV8Zl0c0gvcQ8uOu8luiSeDks+9Ndy+JSALdGaa4DupYi2Pj3CF
	 yBFG/3AA7a8MP2gJCSz03+piRe2ev5Hiqr4bsvs0Zc1HpoO9TJY+T/K6+aLBS7yrMD
	 gJOyfC5NzUqz+8fO+1suxO7Jri0JUeCFJsCNxE40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Heming Zhao <heming.zhao@suse.com>,
	Jia-Ju Bai <baijiaju1990@gmail.com>,
	jjzuming@gmail.com,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 331/686] ocfs2/dlm: serialize migration MLE cleanup on failure
Date: Fri, 13 Nov 2026 10:47:44 -0500
Message-ID: <20261113153832.135351283@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cen Zhang <zzzccc427@gmail.com>

[ Upstream commit 61469249aab03799b0d3294b7a0cd25dd303017a ]

A migration MLE has a base reference for the mastering answer and an
in-use reference held by dlm_migrate_lockres(). The finishing assertion
consumes the base reference, but migration failure drops it again
without checking whether the assertion already consumed it.

The target queues its migration worker before it acknowledges the
ALL_DONE packet, so its finishing assertion can be handled while the
sender still waits for the status. If the connection fails before the
status arrives, dlm_send_one_lockres() returns an error for a migration
that the target has already completed:

  Old-master sender                  Finishing assertion
  -----------------                  -------------------
  publish MLE; take in-use reference
  send ALL_DONE; wait for status
                                     take lookup reference
                                     unlink MLE
                                     put lookup and base references
  send returns a connection error
  put base reference again; free MLE
  put in-use reference; access freed MLE

dlm_assert_master_handler() holds dlm->spinlock from the MLE lookup to
the final puts, and it takes dlm->master_lock around the unlink and the
puts. Decide under the same locks: if the MLE is already unhashed, the
assertion consumed the base reference, so drop only the sender's in-use
reference. Otherwise unlink it before consuming the base reference so a
later assertion no longer finds it.

An assertion that got there first has also made the target the owner
and cleared DLM_LOCK_RES_MIGRATING. Treating the attempt as failed at
that point would leave the lockres owned by the target while this node
still holds the other nodes' locks and refmap bits, so it could neither
be purged nor migrated again. Finish our side as a completed migration
does instead: drop those locks under res->spinlock if the target still
owns the lockres, and recalculate its usage.

Use the same cleanup for the pre-send failure, the send failure and the
target-death failure paths. The sender's in-use reference keeps the MLE
alive until its final put outside the nested locks. Successful
migration retains its existing in-use-only put.

A target that has died cannot assert after the sender has seen its
death. The o2net node-down callback runs before the DLM one; it
disconnects the node and flushes the workqueue that runs the message
handlers, so an assertion already received has been handled by the time
the DLM removes the node from the domain map. A node that leaves the
domain cleanly sends its exit message only after its assertions have
been answered.

Two windows of the hand-over itself are left as they are: the handler
switches the owner and the sender drops the other nodes' locks moments
later, and an assertion from a live target that arrives after the
sender has given up still meets the owner check in the handler. Waiting
for the target before giving up would only stretch the first window
into the time in which recovery of the target can observe it.

KASAN report, only the relevant frames are kept:

BUG: KASAN: slab-use-after-free in dlm_put_mle_inuse+0xce/0xe0
Read of size 8 at addr ffff8881190e3c20 by task umount/593

Call Trace:
 <TASK>
 dlm_put_mle_inuse+0xce/0xe0
 dlm_migrate_lockres+0x16af/0x20d0
 dlm_empty_lockres+0x60a/0xbd0
 dlm_unregister_domain+0x53b/0x11d0
 o2cb_cluster_disconnect+0xa5/0x110
 ocfs2_cluster_disconnect+0x73/0xc0
 ocfs2_dlm_shutdown+0x311/0x440
 ocfs2_dismount_volume+0x696/0x940
 generic_shutdown_super+0x15f/0x490
 kill_block_super+0x40/0xa0
 deactivate_locked_super+0xae/0x120
 deactivate_super+0xa2/0xc0
 cleanup_mnt+0x217/0x450
 task_work_run+0x144/0x230
 </TASK>

Allocated by task 593:
 kmem_cache_alloc_noprof+0x20b/0x5c0
 dlm_migrate_lockres+0x20e/0x20d0
 dlm_empty_lockres+0x60a/0xbd0
 dlm_unregister_domain+0x53b/0x11d0
 o2cb_cluster_disconnect+0xa5/0x110
 ocfs2_cluster_disconnect+0x73/0xc0
 ocfs2_dlm_shutdown+0x311/0x440
 ocfs2_dismount_volume+0x696/0x940

Freed by task 593:
 kmem_cache_free+0x242/0x580
 __dlm_put_mle+0x4b2/0x660
 dlm_migrate_lockres+0x1690/0x20d0
 dlm_empty_lockres+0x60a/0xbd0
 dlm_unregister_domain+0x53b/0x11d0
 o2cb_cluster_disconnect+0xa5/0x110
 ocfs2_cluster_disconnect+0x73/0xc0
 ocfs2_dlm_shutdown+0x311/0x440

The buggy address belongs to the object at ffff8881190e3c00
 which belongs to the cache o2dlm_mle of size 480
The buggy address is located 32 bytes inside of
 freed 480-byte region [ffff8881190e3c00, ffff8881190e3de0)

Link: https://lore.kernel.org/pm-ocfs2-objects-candidate-0038-v9-659f247ea980d5f3fbeb@gmail.com
Fixes: 6714d8e86bf4 ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Assisted-by: LLM
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: <jjzuming@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/dlm/dlmmaster.c | 70 ++++++++++++++++++++++++++++++++++------
 1 file changed, 61 insertions(+), 9 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmmaster.c b/fs/ocfs2/dlm/dlmmaster.c
index 4ab8c48582b15..ee28a01e7be34 100644
--- a/fs/ocfs2/dlm/dlmmaster.c
+++ b/fs/ocfs2/dlm/dlmmaster.c
@@ -2526,6 +2526,52 @@ static int dlm_is_lockres_migratable(struct dlm_ctxt *dlm,
  */
 
 
+/*
+ * Drop the sender's references on a migration MLE after the attempt has
+ * failed. The finishing assert from the target may already have unlinked
+ * the MLE and consumed its base reference; decide under the locks the
+ * assert handler holds, and only drop the base reference while the MLE is
+ * still hashed. Returns true when the assert got there first: the target
+ * has become the master, so the caller must complete the migration.
+ */
+static bool dlm_put_migration_mle(struct dlm_ctxt *dlm,
+				  struct dlm_master_list_entry *mle)
+{
+	bool asserted;
+
+	spin_lock(&dlm->spinlock);
+	spin_lock(&dlm->master_lock);
+	__dlm_mle_detach_hb_events(dlm, mle);
+	asserted = hlist_unhashed(&mle->master_hash_node);
+	if (!asserted) {
+		__dlm_unlink_mle(dlm, mle);
+		__dlm_put_mle(mle);
+	}
+	spin_unlock(&dlm->master_lock);
+	spin_unlock(&dlm->spinlock);
+
+	dlm_put_mle_inuse(mle);
+	return asserted;
+}
+
+/*
+ * The finishing assert got there first: it switched the owner to the
+ * target and cleared DLM_LOCK_RES_MIGRATING. Drop the other nodes' locks
+ * as a completed migration does, unless recovery has taken the lockres
+ * over since, and let the usage be recalculated.
+ */
+static void dlm_migrate_lockres_asserted(struct dlm_ctxt *dlm,
+					 struct dlm_lock_resource *res,
+					 u8 target)
+{
+	spin_lock(&res->spinlock);
+	if (res->owner == target)
+		dlm_remove_nonlocal_locks(dlm, res);
+	spin_unlock(&res->spinlock);
+
+	dlm_lockres_calc_usage(dlm, res);
+}
+
 static int dlm_migrate_lockres(struct dlm_ctxt *dlm,
 			       struct dlm_lock_resource *res, u8 target)
 {
@@ -2610,9 +2656,10 @@ static int dlm_migrate_lockres(struct dlm_ctxt *dlm,
 
 	if (ret < 0) {
 		if (mle_added) {
-			dlm_mle_detach_hb_events(dlm, mle);
-			dlm_put_mle(mle);
-			dlm_put_mle_inuse(mle);
+			if (dlm_put_migration_mle(dlm, mle)) {
+				dlm_migrate_lockres_asserted(dlm, res, target);
+				ret = 0;
+			}
 		} else if (mle) {
 			kmem_cache_free(dlm_mle_cache, mle);
 			mle = NULL;
@@ -2641,9 +2688,11 @@ static int dlm_migrate_lockres(struct dlm_ctxt *dlm,
 		mlog(0, "migration to node %u failed with %d\n",
 		     target, ret);
 		/* migration failed, detach and clean up mle */
-		dlm_mle_detach_hb_events(dlm, mle);
-		dlm_put_mle(mle);
-		dlm_put_mle_inuse(mle);
+		if (dlm_put_migration_mle(dlm, mle)) {
+			dlm_migrate_lockres_asserted(dlm, res, target);
+			ret = 0;
+			goto leave;
+		}
 		spin_lock(&res->spinlock);
 		res->state &= ~DLM_LOCK_RES_MIGRATING;
 		wake = 1;
@@ -2687,9 +2736,12 @@ static int dlm_migrate_lockres(struct dlm_ctxt *dlm,
 				     res->lockname.name, target);
 				ret = -EINVAL;
 				/* migration failed, detach and clean up mle */
-				dlm_mle_detach_hb_events(dlm, mle);
-				dlm_put_mle(mle);
-				dlm_put_mle_inuse(mle);
+				if (dlm_put_migration_mle(dlm, mle)) {
+					dlm_migrate_lockres_asserted(dlm, res,
+								     target);
+					ret = 0;
+					goto leave;
+				}
 				spin_lock(&res->spinlock);
 				res->state &= ~DLM_LOCK_RES_MIGRATING;
 				wake = 1;
-- 
2.53.0



