Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061647;
	b=pVzznH4DKOukBcOI/qPuuwQ6+v+6URCtRr0vhjB6VXJK63s9f7nGy9qmJN+BNAAh5nI5
	 xxTqne8zguFf/m+xv0RGCQlnPtdCf8tMJ5p/ZEdxNJbnix0OQzZeoDicdqU4ckqyNlwpk
	 sddxp5BpyW0k8pr6YWrJiz/abysa2unMJ61Nnl/C5bJNnvRjLswnGjHS7qNtCQ/bzOJdl
	 9+5+w8VHYBGGHVWvD/m2gf3Wm5IJEn2DxA1GCitqdwn4EnIGgrVRfIfX98zHfk95eMLcG
	 nYhIW9O6gnK04X2mGJ+EDUTk8XU7wD/pZwPtKombgOM66hH3G8Cm+UkGYznSqqR7AiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061647;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+nml2gMrAjfsqGlvigs5K3G7n0PLeH7vEpFa/cGH1/Y=;
	b=pGvtDVcVcBoqCUkVZHU9K5EjCnq8/FX+2ZJUy4bJs+bIWdQJzhND7d5cH7ty9cZuEkFG
	 gc9jJoBdUxB7cs8SRiGiqqpHRcCq7QYACfOSFJX6W3O4jcw67QHFInntn4ZFbHkSrfQ+U
	 73VWcpgmdrF++M1nzDElhpufWorJ7C4veWE65dczvoreY4rcU7/CJAEJsjdUbBGnniAKW
	 KYrYLdk7FbFkz7Ovi5nEOKsju5+oLjCg1oEKhHgSk/Ucb6+zDAUhjuUaz4dCPfsw+dk/k
	 tIIm2meS+Yag/O4THnM8kZdNyGhnCsC7SI0iFSiqkbrkcISsUyamZZrUfsUoBxbfoag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=akpha+Nm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52147606A32D;
	Sat,  7 Nov 2026 14:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=akpha+Nm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF53A1F0089F;
	Sat,  7 Nov 2026 14:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061647;
	bh=+nml2gMrAjfsqGlvigs5K3G7n0PLeH7vEpFa/cGH1/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=akpha+NmwVyvBMOQAdpudiryitpQ0X3FUQCD/QeC5g/+r9/tjl+BZYQiS6jyYNPjd
	 d7GxUh+LYpXCyS0RtxhJ9G2NOvhWYgha8t0YJ1kMTRH3SZMZnnalDQ2m3RgKYZh8DT
	 wT96t79AAFQjwNC2ZPwyOybesUXZd2M5xeb4Ustc=
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
Subject: [PATCH 6.12 0669/1536] ocfs2/heartbeat: unlink live slots when their node is missing
Date: Sat,  7 Nov 2026 08:44:45 -0500
Message-ID: <20261107135016.274153970@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -867,8 +867,11 @@ static void o2hb_shutdown_slot(struct o2
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
@@ -890,7 +893,8 @@ static void o2hb_shutdown_slot(struct o2
 	if (queued)
 		o2hb_run_event_list(&event);
 
-	o2nm_node_put(node);
+	if (node)
+		o2nm_node_put(node);
 }
 
 static void o2hb_set_quorum_device(struct o2hb_region *reg)
@@ -1025,7 +1029,7 @@ static int o2hb_check_slot(struct o2hb_r
 fire_callbacks:
 	/* dead nodes only come to life after some number of
 	 * changes at any time during their dead time */
-	if (list_empty(&slot->ds_live_item) &&
+	if (node && list_empty(&slot->ds_live_item) &&
 	    slot->ds_changed_samples >= O2HB_LIVE_THRESHOLD) {
 		mlog(ML_HEARTBEAT, "Node %d (id 0x%llx) joined my region\n",
 		     slot->ds_node_num, (long long)slot->ds_last_generation);


