Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057952;
	b=1MwHvLWCnJJTDYn2eLbVsReYRWT63Q8zAdacV/c25mUK+7NvyNMQ2R3kq0BvNs2ZKT5j
	 7txQY8D8mzOkcVPKhvhUKBS+AiXqRivPjcbYRUjC+vukl01nzJJMBSlox3WbmyGo2NAdm
	 P1EEA2cL2kc2jlCg84ZHemd2jN2Sc6vcg4ovFoE4F+xuz6s4voF0YugQSCqOqS5UbK2Qs
	 mSfsCDhr3dnsS7OYRtvNV6meOgmqvRL5q+/3i2gJ9VhO59lHnsBfTdV1ziYG7xt6MeXB/
	 dW5cNCUFVrn5NIMnb/qEss2NxbXYkgRPyCMhpJOgTbFvncHR87G2wtqIym+UVY2mTzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057952;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4pKfENLwjkd7DRqtGFnEtzy1xoXAH5z3FIeFi8c1k9I=;
	b=YcGXvDg/GG6O98KPQ5naBjyqhOT3qtwx4io4JgYWMF/8OMqxCc5HMIU0j1KbAhYbSjXW
	 dfTSRkOnnyRg4sSMn5ibrRhITGq9xJpt5dRQlwtCcVjB1cYrdrXPYJJC/9jmfPObZbsaL
	 yNPJmlFNDmKZGf7JRWsmtBsoH3ivc7E6RUJj3vNfkpISnBKE8CLL85v18iydBiLYmMMnM
	 cH+qSIG9uHxFI+8E521/2E/papajYQ21X3kbv5EmL/pCYBanFVXbljfaDNP+WV06dAnf7
	 IAuxZg9DN/LWbAy4BUkbHU7ouMcvAOvlIZiVpWxNroMoKU3ryEA0Rn1SVPJg9RtNSuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E2eBCojL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB0E606A320;
	Thu, 19 Nov 2026 03:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E2eBCojL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4530A1F000C4;
	Thu, 19 Nov 2026 03:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057952;
	bh=4pKfENLwjkd7DRqtGFnEtzy1xoXAH5z3FIeFi8c1k9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E2eBCojLxSJb1214lLum9QZTGRlLSnK0oml7gGaA0Eda82CHzXZ2Gt3ArvzQZLx0C
	 YfQ4jLf5N4mQhZqRGSOVxbIaYjUWjc5jsbXkXFfu5P06rgjioqEz6n2F2jLqC31as+
	 CSFpTumY9TSZfvfKtg/+XxCO4+8M7QQZnYrZDbYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Yufan Chen <ericterminal@gmail.com>,
	Kees Cook <kees@kernel.org>,
	Jia-Ju Bai <baijiaju1990@gmail.com>,
	jjzuming@gmail.com
Subject: [PATCH 5.10 0262/1848] ocfs2/heartbeat: unlink live slots when their node is missing
Date: Wed, 18 Nov 2026 15:38:20 +0100
Message-ID: <20261118145923.236027854@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cen Zhang <zzzccc427@gmail.com>

commit 3ccd24c3f7a577b84a532cb027f1378385b82ef6 upstream.

o2hb_shutdown_slot() returns immediately when its node is no longer in the
configfs registry.  A slot can still be linked in o2hb_live_slots when
that lookup fails.  Region teardown or startup-error cleanup then frees
the slot array without removing its embedded list member.

With the same peer live in another region, the next list update can follow
a predecessor into the freed array.  Reusing the node number can also make
a later insertion encounter that stale member.

Always remove the slot under o2hb_live_lock, even when node lookup fails.
Preserve aggregate membership accounting and the last-region DOWN
callback: the existing callback interface explicitly permits a NULL node
for DOWN events.  Only drop the node reference when lookup returned one.
This closes both normal release and startup-abort paths without changing
the publication or callback locking protocol.

Also require a configured node before admitting a new live slot in
o2hb_check_slot().  The early live-bitmap check is not held through
admission: the last live slot in another region can be removed in between.
Without a node, admission can then queue an UP event with a NULL argument
and hit the event helper's BUG_ON.  Existing live slots can still leave
and generate NULL-node DOWN events.

A controlled probe-instrumented test reproduced this while stopping one of
two regions after removing the peer from configfs.  Its KASAN report
includes:

  BUG: KASAN: slab-use-after-free in __list_del_entry_valid_or_report+0x1e0/0x210
  Read of size 8 at addr ffff888106a4ac60 by task o2hb-pmbd0058_b/497
  Call Trace:
   <TASK>
   dump_stack_lvl+0x93/0xd0
   print_report+0xce/0x630
   kasan_report+0xe0/0x110
   __list_del_entry_valid_or_report+0x1e0/0x210
   o2hb_do_disk_heartbeat+0x1591/0x2c50
   o2hb_thread+0x1ed/0xe70
   kthread+0x351/0x460
   ret_from_fork+0x659/0x940
   ret_from_fork_asm+0x1a/0x30
   </TASK>
  Allocated by task 491:
   kasan_save_stack+0x33/0x60
   kasan_save_track+0x14/0x30
   __kasan_kmalloc+0xaa/0xb0
   __kmalloc_noprof+0x2de/0x780
   o2hb_region_dev_store+0x7c2/0x1b60
   configfs_write_iter+0x2f9/0x4f0
   vfs_write+0x639/0x1010
   ksys_write+0x111/0x200
   do_syscall_64+0x114/0x620
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
  Freed by task 491:
   kasan_save_stack+0x33/0x60
   kasan_save_track+0x14/0x30
   kasan_save_free_info+0x3b/0x60
   __kasan_slab_free+0x5f/0x80
   kfree+0x308/0x580
   o2hb_unmap_slot_data+0x1db/0x330
   o2hb_region_release+0x14b/0x4f0
   config_item_cleanup+0x14b/0x230
   config_item_put+0x79/0x90
   configfs_rmdir+0x58a/0x910
   vfs_rmdir+0x2e8/0x820
   filename_rmdir+0x3b1/0x520
   __x64_sys_rmdir+0x4b/0x70
   do_syscall_64+0x114/0x620
   entry_SYSCALL_64_after_hwframe+0x77/0x7f

Link: https://lore.kernel.org/pm-ocfs2-objects-candidate-0058-v2-9446113c2b16c817c538@gmail.com
Fixes: a7f6a5fb4bde ("[PATCH] OCFS2: The Second Oracle Cluster Filesystem")
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Assisted-by: LLM
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Yufan Chen <ericterminal@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Jia-Ju Bai <baijiaju1990@gmail.com>
Cc: <jjzuming@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/cluster/heartbeat.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -822,8 +822,11 @@ static void o2hb_shutdown_slot(struct o2
 	int queued = 0;
 
 	node = o2nm_get_node_by_num(slot->ds_node_num);
-	if (!node)
-		return;
+	/*
+	 * The node may have been removed from the node table while this
+	 * region's slot is still linked.  The list member must still be
+	 * removed before the region releases its slot array.
+	 */
 
 	spin_lock(&o2hb_live_lock);
 	if (!list_empty(&slot->ds_live_item)) {
@@ -845,7 +848,8 @@ static void o2hb_shutdown_slot(struct o2
 	if (queued)
 		o2hb_run_event_list(&event);
 
-	o2nm_node_put(node);
+	if (node)
+		o2nm_node_put(node);
 }
 
 static void o2hb_set_quorum_device(struct o2hb_region *reg)
@@ -980,7 +984,7 @@ static int o2hb_check_slot(struct o2hb_r
 fire_callbacks:
 	/* dead nodes only come to life after some number of
 	 * changes at any time during their dead time */
-	if (list_empty(&slot->ds_live_item) &&
+	if (node && list_empty(&slot->ds_live_item) &&
 	    slot->ds_changed_samples >= O2HB_LIVE_THRESHOLD) {
 		mlog(ML_HEARTBEAT, "Node %d (id 0x%llx) joined my region\n",
 		     slot->ds_node_num, (long long)slot->ds_last_generation);


