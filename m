Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064490;
	b=yzMnrvBPWX0pj6Nk8Sg5u1kq6j7nxmg6e0t4Fuw0THug1IdWhS68PBmpZVvwYLfrYMBu
	 guOdSt1byET5Bx+LmfsKDINtXurefzDIULOulyhbB8ZR4MD0LYmluA9WW6rKz7cODPMFG
	 LGShThV/xQ+iP+waATCItQjkaZ9kAHS4Xcjwm7ZcXTBGXlYfkAnEfoSXkcghh7xJbs5u0
	 vk4OK8aa60HvYPjdB0n3LkDGMHxL7taLi6AsoTrC7MrBEgeND11dALiokCjyiXVwcoRjv
	 n7pb1kNQJL14SNpPCykwoja4eEsUvskomiA6caCVk/mM8O2Fvp5EFUIDrvW5oJcOdxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064490;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qgA9KbqkPMYmRYFGeqvsvoJ35jGV/07pQ61zoU3P/as=;
	b=MqnRLyO1bzKo9TytcL9NGYTcIxeDWrKveBxkXnKgxlmb+tQe1MGRxi54Y1JQzsEJsNUg
	 NsFPo23GY/BKHk1ZbFZQmaIjLcTNWVmwCeFKycDQT3185JsJKfZNiEskY05HVQF4+ikXg
	 6nUiQqWRFY15AkFq9HVbO6ILEA4sYFriSYmXXHhAHYwHLT8mLEP/cqBdLGs25i2/+QzHk
	 9EBuHqeY0HV1jYnpe9Gxvz4yThcttssxRO3LF6c9PYDEybKxadQuQDA523bjNoFzU/qpK
	 UDUhB8T5synO+Wo1dmDclGrehu/OHveneKMXZl3uKk39fbtXD3G2Lu25K66t4bXPJqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W0ZZPfYs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF5C606A9EE;
	Sat,  7 Nov 2026 15:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W0ZZPfYs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7C0F1F008A4;
	Sat,  7 Nov 2026 15:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064490;
	bh=qgA9KbqkPMYmRYFGeqvsvoJ35jGV/07pQ61zoU3P/as=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W0ZZPfYsfzetKdOyQpEaq3aBPjJD24SOhWQTZKeRj5sxkDhfvkQO2ruQX33Fas6bV
	 6+FO2BWnL3OISXPxokDxf9Cc83PCmGsqiu2V4TG2YZKHKIgDGXWgO2/eU+q993AvCf
	 PVqERtZLov8b1DpWyGBozoa8ieorDNxyEflmt2WM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>,
	Changwei Ge <gechangwei@live.cn>,
	Joel Becker <jlbec@evilplan.org>,
	Jun Piao <piaojun@huawei.com>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Mark Fasheh <mark@fasheh.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0526/1257] ocfs2: free replay slots in ocfs2_recovery_exit()
Date: Sat,  7 Nov 2026 08:47:02 -0500
Message-ID: <20261107134953.943595402@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Joseph Qi <joseph.qi@linux.alibaba.com>

[ Upstream commit 1ddadc6d41c1a29fd8fad1891bdcd2956e08b7f0 ]

Commit ce2fcf1516d6 ("ocfs2: fix memory leak in ocfs2_mount_volume()")
added ocfs2_free_replay_slots() calls to the mount error paths
out_dismount and out_check_volume to fix a leak of osb->replay_map.
However these calls are unlocked while the bail path of the recovery
thread, which is woken up by out_dismount right before the call, also
frees the replay slots under osb->recovery_lock.  Both sides can thus
observe a non-NULL osb->replay_map and trigger a double free.

Fix this by moving ocfs2_free_replay_slots() into ocfs2_recovery_exit()
after ocfs2_recovery_disable(), which waits for a running recovery thread
to exit under osb->recovery_lock, and drop the unlocked call sites.  Both
ocfs2_dismount_volume() and the out_super path of ocfs2_fill_super() call
ocfs2_recovery_exit(), so the replay slots are freed on every path.  Since
super.c no longer references it, make ocfs2_free_replay_slots() static
again.

Link: https://lore.kernel.org/20260828112825.666097-2-joseph.qi@linux.alibaba.com
Fixes: ce2fcf1516d6 ("ocfs2: fix memory leak in ocfs2_mount_volume()")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/journal.c | 3 ++-
 fs/ocfs2/journal.h | 1 -
 fs/ocfs2/super.c   | 5 +----
 3 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
index d8afbc1a76bb8..a3938a03e93bf 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -156,7 +156,7 @@ static void ocfs2_queue_replay_slots(struct ocfs2_super *osb,
 	replay_map->rm_state = REPLAY_DONE;
 }
 
-void ocfs2_free_replay_slots(struct ocfs2_super *osb)
+static void ocfs2_free_replay_slots(struct ocfs2_super *osb)
 {
 	struct ocfs2_replay_map *replay_map = osb->replay_map;
 
@@ -243,6 +243,7 @@ void ocfs2_recovery_exit(struct ocfs2_super *osb)
 	/* XXX: Should we bug if there are dirty entries? */
 
 	kfree(rm);
+	ocfs2_free_replay_slots(osb);
 }
 
 static int __ocfs2_recovery_map_test(struct ocfs2_super *osb,
diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index f8b3b2a3d6309..19fc920d26b1c 100644
--- a/fs/ocfs2/journal.h
+++ b/fs/ocfs2/journal.h
@@ -151,7 +151,6 @@ void ocfs2_recovery_exit(struct ocfs2_super *osb);
 void ocfs2_recovery_disable_quota(struct ocfs2_super *osb);
 
 int ocfs2_compute_replay_slots(struct ocfs2_super *osb);
-void ocfs2_free_replay_slots(struct ocfs2_super *osb);
 /*
  *  Journal Control:
  *  Initialize, Load, Shutdown, Wipe a journal.
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 736cc1fa8b23e..169c576f06bf5 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1163,7 +1163,6 @@ static int ocfs2_fill_super(struct super_block *sb, struct fs_context *fc)
 out_dismount:
 	atomic_set(&osb->vol_state, VOLUME_DISABLED);
 	wake_up(&osb->osb_mount_event);
-	ocfs2_free_replay_slots(osb);
 	ocfs2_dismount_volume(sb, 1);
 	goto out;
 
@@ -1777,14 +1776,12 @@ static int ocfs2_mount_volume(struct super_block *sb)
 	status = ocfs2_truncate_log_init(osb);
 	if (status < 0) {
 		mlog_errno(status);
-		goto out_check_volume;
+		goto out_system_inodes;
 	}
 
 	ocfs2_super_unlock(osb, 1);
 	return 0;
 
-out_check_volume:
-	ocfs2_free_replay_slots(osb);
 out_system_inodes:
 	if (osb->local_alloc_state == OCFS2_LA_ENABLED)
 		ocfs2_shutdown_local_alloc(osb);
-- 
2.53.0



