Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045508;
	b=xmbBEmAPvexKT6KiXx+iVmtzUVSwOXH2hPGGXPvYG18+zv9uebEkiwbZXgG305dIYRBG
	 i8ww1Ch1A49P3Y97hYKkMUSTosDyCtuB25hVWvCtNjh7pW07JbN35qUKEYBQiscTnqBJo
	 ENT4yroGHD+DOLLStSBU4LFi1TvHm0NHeszM+CzfDtVzEQP99fPubmN82EB48MGeTICyb
	 JTXPy9Xe0UN4CqPu1QWgHk2eEonguEtqeX16gDItyKmofLH5p3WDq3bEccsCsajYEmqwh
	 kwaRFByRm+HyndoLlFy6ifa2OuMQkD9JLS6Khahwxv72bO7t0vgmphbioVuK2DPBPRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045508;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x/vSV1GilzJJw20TM+WjHqPY+uxN7x6cZUR+nLrNVj0=;
	b=g752ha1nWZEgvwKBsstNEBpYv2c9fYIfyDnNX8mIFcywiDt8HikYbX9rXOqumtArIS1U
	 5GdWpYjFz1sEAMuCH7fAgFCa24aI8Fv60qj8uARLJB3Hcksz9yb7NzRBSObKR/C5a89wr
	 4AI1c553oz8KyO6DiC3EyO9wzQ9LR5uam9Uvb81TklYtP1gLhMiajwrgESnrQoo9sCbyD
	 eAY+vovrDz4Eus/qdHoj7EHZTqDEj6T6/1mCMcMozHf+8HEPekbomplBi1X1b9BAx2wgh
	 PoqwbHIAOX4cUhTheD2dHRk/2nlzb2iFw8uChYtmqIyRt0LQ2rX8DR3M94pUfQyaOjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g2tLJtNS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78C2E606A336;
	Wed, 18 Nov 2026 23:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g2tLJtNS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4CFC1F000C4;
	Wed, 18 Nov 2026 23:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045508;
	bh=x/vSV1GilzJJw20TM+WjHqPY+uxN7x6cZUR+nLrNVj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g2tLJtNSrRKc20lrOvfWsGSuvhc98LoQ1i4C5CsK2bksNYXGn2nZIicgbn0sdzY/t
	 c4r0uCEMTJwKLI4UVkDfQS1g+Ly8DNKNGvhs7kopB8vCnemNmm23tDQv4lDxlosagS
	 1SnvZeSNX2+XPYufIZouQ113527D3j0w/Y9EnEuc=
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
Subject: [PATCH 6.1 0889/2857] ocfs2: free replay slots in ocfs2_recovery_exit()
Date: Wed, 18 Nov 2026 15:32:03 +0100
Message-ID: <20261118150233.565342464@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index a2e624ac0e9dc..cf550d664b66c 100644
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -157,7 +157,7 @@ static void ocfs2_queue_replay_slots(struct ocfs2_super *osb,
 	replay_map->rm_state = REPLAY_DONE;
 }
 
-void ocfs2_free_replay_slots(struct ocfs2_super *osb)
+static void ocfs2_free_replay_slots(struct ocfs2_super *osb)
 {
 	struct ocfs2_replay_map *replay_map = osb->replay_map;
 
@@ -248,6 +248,7 @@ void ocfs2_recovery_exit(struct ocfs2_super *osb)
 	/* XXX: Should we bug if there are dirty entries? */
 
 	kfree(rm);
+	ocfs2_free_replay_slots(osb);
 }
 
 static int __ocfs2_recovery_map_test(struct ocfs2_super *osb,
diff --git a/fs/ocfs2/journal.h b/fs/ocfs2/journal.h
index 2e149e9a6a960..6b5e57a25346f 100644
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
index 8dd141609f69c..94efa4d45dd31 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1162,7 +1162,6 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 out_dismount:
 	atomic_set(&osb->vol_state, VOLUME_DISABLED);
 	wake_up(&osb->osb_mount_event);
-	ocfs2_free_replay_slots(osb);
 	ocfs2_dismount_volume(sb, 1);
 	goto out;
 
@@ -1835,14 +1834,12 @@ static int ocfs2_mount_volume(struct super_block *sb)
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



