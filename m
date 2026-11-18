Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052497;
	b=W9DetpoLNEf1ZNuDKHhLA03bQhuGfQ8/ohhXbhWF2CZhISTmwpkr7K0N86de43K2lbUk
	 XIwr7XXNpVZKzQnUHk0aWYtpdzQSp5G7fM2P5f17dHXmy0HpVpuk7U1fammsA1dZtFyDK
	 r5zhddvCoBtMHXiZVwUzgDqcRPjUiI2fTUrHy9lYtOXfRVYRaCFQLkCwXOie1ZwKCVaT0
	 7hqIXGUzyoqmNikoxgVrEu9fcXHY7UEX8CuIucXyeamRGpwI0yZX3M1SuULH1Ih+q3E70
	 /ambQiB+SyroaLufILAWQ0WfSPYkUo9P7AZ0VtM5FGQI7Qzxuo7htQoIO42+Fu1IMqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052497;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EKGOJs0mKf8Yqk2uceGLQ1alDhvgE+/+RyjEfWt6xtc=;
	b=ea7UUF7UgPOHOLfOC61mbQxH944N8j+JxBc8s/vEfd9Grc7gHRS/OeePTJvJa5tWhviR
	 w9wjrdwq1zcziz7cIy/fsiDUzU9ZAtHh0eteA0FJlJ8Q6CPlwdi4/+e4PFbyKb019O+om
	 Gk6AzjSL8lPiB1nd2Bo8EMSvm5XFaGt4+NUDwRV+Mtm3uUV4qqLdC2Xa90VbLMepcABv4
	 IDnnhthYl1CITeXHRsSxJD9O23ebreZnVth98wf+xXCRwkVI2K6B4oev8u0q9kKBGjZKX
	 DxC0ChCgsgWEcSCbe9xjNVDA0y1SVwWfM6OKliOeV0O7FzQgNxDjJ3VbPz4DqjxcUxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RpzuiQVt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39280606A31C;
	Thu, 19 Nov 2026 01:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RpzuiQVt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AE141F000C4;
	Thu, 19 Nov 2026 01:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052497;
	bh=EKGOJs0mKf8Yqk2uceGLQ1alDhvgE+/+RyjEfWt6xtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RpzuiQVtYJHjlOgfbqUhhjqXLTSzHPSaL07rTqssQqX8UPcTb1E91wN45YHkUqOC9
	 PXYezX2c8aimyca/fipC9/3O2WlnvUIhx/XMhT12NioMa/qdmHcY/n9JDizLwSbKux
	 cZV0zFy8DSU/2NZk0TUGu/OJN1hgxu9QA9neC+hQ=
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
Subject: [PATCH 5.15 0586/2214] ocfs2: free replay slots in ocfs2_recovery_exit()
Date: Wed, 18 Nov 2026 15:37:42 +0100
Message-ID: <20261118150034.354435197@linuxfoundation.org>
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
index 3a550ac25a4f9..92ab500572f41 100644
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
index 6036eb150e1ae..dce9356dcaeae 100644
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
index 052dfe49e03e4..edbf70fdcc589 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -1163,7 +1163,6 @@ static int ocfs2_fill_super(struct super_block *sb, void *data, int silent)
 out_dismount:
 	atomic_set(&osb->vol_state, VOLUME_DISABLED);
 	wake_up(&osb->osb_mount_event);
-	ocfs2_free_replay_slots(osb);
 	ocfs2_dismount_volume(sb, 1);
 	goto out;
 
@@ -1838,14 +1837,12 @@ static int ocfs2_mount_volume(struct super_block *sb)
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



