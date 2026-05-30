Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA42017555;
	Sat, 30 May 2026 18:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165544; cv=none; b=IyteZ41ew36VaUYlxdSA5u3EF7YG8bvVHXbDk6BLcYto7KQGOEelzltdv+5oe0yWuXss40r/kkVISg+A9qogk1I+Ny30sjDuZjzTmjPI4BmqHBs3CPRD29LHrh0JAN0CNLlXxpdiQRdaRetF+y5Zirtqxokrx8Y2vVYvoFXhY34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165544; c=relaxed/simple;
	bh=Xby8J6UHk9KQhIbhRTEP1AIHmeWLs9cdVmQmPbKUNrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bx6mjiDXBOjYd6x1O0RWJRuPD9+O4PUdwz9AGw0fCHsmQaBcTvEWTq+3PiY16Q8Ikqn/sKmTHEY6hGUouNymCxZcmEb/7t+JuroJnxC6UvsmCFNmENUMWKlWrPsqGbxoksUXayc32k0xApq3ziPkV5pW7bBdMgT1LWBD/PpPt9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vv6IPiw1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vv6IPiw1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E96781F00893;
	Sat, 30 May 2026 18:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165542;
	bh=0WnDpo2XtAMJbwui7UElahhBW1suN616RCWDDXA0+PM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vv6IPiw1M5SAVsROpOM9/rr7ymW/cO4HjNLHhCfmy9gutvgTpSfXVe/2aN0M6RjPd
	 HfIxFGxuiIP+H68ljv0MTIutSLQ9KB+4v8cX9VmaumElqQ3/jxAsn2bEMqtksJ1Khj
	 l4TmVUfOKMY408s6Clw5760X6c/TottTPn+pcbPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	hongnanli <hongnan.li@linux.alibaba.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Gang He <ghe@suse.com>,
	Jun Piao <piaojun@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 110/589] fs/ocfs2: fix comments mentioning i_mutex
Date: Sat, 30 May 2026 17:59:51 +0200
Message-ID: <20260530160227.643072625@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: hongnanli <hongnan.li@linux.alibaba.com>

[ Upstream commit 137cebf9432eae024d0334953ed92a2a78619b52 ]

inode->i_mutex has been replaced with inode->i_rwsem long ago.  Fix
comments still mentioning i_mutex.

Link: https://lkml.kernel.org/r/20220214031314.100094-1-hongnan.li@linux.alibaba.com
Signed-off-by: hongnanli <hongnan.li@linux.alibaba.com>
Acked-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Gang He <ghe@suse.com>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Stable-dep-of: b02da26a992d ("ocfs2: fix possible deadlock between unlink and dio_end_io_write")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/alloc.c               |    2 +-
 fs/ocfs2/aops.c                |    2 +-
 fs/ocfs2/cluster/nodemanager.c |    2 +-
 fs/ocfs2/dir.c                 |    4 ++--
 fs/ocfs2/file.c                |    4 ++--
 fs/ocfs2/inode.c               |    2 +-
 fs/ocfs2/localalloc.c          |    6 +++---
 fs/ocfs2/namei.c               |    2 +-
 fs/ocfs2/ocfs2.h               |    4 ++--
 fs/ocfs2/quota_global.c        |    2 +-
 fs/ocfs2/xattr.c               |    2 +-
 11 files changed, 16 insertions(+), 16 deletions(-)

--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -5988,7 +5988,7 @@ bail:
 	return status;
 }
 
-/* Expects you to already be holding tl_inode->i_mutex */
+/* Expects you to already be holding tl_inode->i_rwsem */
 int __ocfs2_flush_truncate_log(struct ocfs2_super *osb)
 {
 	int status;
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -2327,7 +2327,7 @@ static int ocfs2_dio_end_io_write(struct
 
 	down_write(&oi->ip_alloc_sem);
 
-	/* Delete orphan before acquire i_mutex. */
+	/* Delete orphan before acquire i_rwsem. */
 	if (dwc->dw_orphaned) {
 		BUG_ON(dwc->dw_writer_pid != task_pid_nr(current));
 
--- a/fs/ocfs2/cluster/nodemanager.c
+++ b/fs/ocfs2/cluster/nodemanager.c
@@ -691,7 +691,7 @@ static struct config_group *o2nm_cluster
 	struct o2nm_node_group *ns = NULL;
 	struct config_group *o2hb_group = NULL, *ret = NULL;
 
-	/* this runs under the parent dir's i_mutex; there can be only
+	/* this runs under the parent dir's i_rwsem; there can be only
 	 * one caller in here at a time */
 	if (o2nm_single_cluster)
 		return ERR_PTR(-ENOSPC);
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -1981,7 +1981,7 @@ bail_nolock:
 }
 
 /*
- * NOTE: this should always be called with parent dir i_mutex taken.
+ * NOTE: this should always be called with parent dir i_rwsem taken.
  */
 int ocfs2_find_files_on_disk(const char *name,
 			     int namelen,
@@ -2028,7 +2028,7 @@ int ocfs2_lookup_ino_from_name(struct in
  * Return -EEXIST if the directory contains the name
  * Return -EFSCORRUPTED if found corruption
  *
- * Callers should have i_mutex + a cluster lock on dir
+ * Callers should have i_rwsem + a cluster lock on dir
  */
 int ocfs2_check_dir_for_entry(struct inode *dir,
 			      const char *name,
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -272,7 +272,7 @@ int ocfs2_update_inode_atime(struct inod
 
 	/*
 	 * Don't use ocfs2_mark_inode_dirty() here as we don't always
-	 * have i_mutex to guard against concurrent changes to other
+	 * have i_rwsem to guard against concurrent changes to other
 	 * inode fields.
 	 */
 	inode->i_atime = current_time(inode);
@@ -1070,7 +1070,7 @@ static int ocfs2_extend_file(struct inod
 	/*
 	 * The alloc sem blocks people in read/write from reading our
 	 * allocation until we're done changing it. We depend on
-	 * i_mutex to block other extend/truncate calls while we're
+	 * i_rwsem to block other extend/truncate calls while we're
 	 * here.  We even have to hold it for sparse files because there
 	 * might be some tail zeroing.
 	 */
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -715,7 +715,7 @@ bail:
 /*
  * Serialize with orphan dir recovery. If the process doing
  * recovery on this orphan dir does an iget() with the dir
- * i_mutex held, we'll deadlock here. Instead we detect this
+ * i_rwsem held, we'll deadlock here. Instead we detect this
  * and exit early - recovery will wipe this inode for us.
  */
 static int ocfs2_check_orphan_recovery_state(struct ocfs2_super *osb,
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -608,7 +608,7 @@ out:
 
 /*
  * make sure we've got at least bits_wanted contiguous bits in the
- * local alloc. You lose them when you drop i_mutex.
+ * local alloc. You lose them when you drop i_rwsem.
  *
  * We will add ourselves to the transaction passed in, but may start
  * our own in order to shift windows.
@@ -638,7 +638,7 @@ int ocfs2_reserve_local_alloc_bits(struc
 
 	/*
 	 * We must double check state and allocator bits because
-	 * another process may have changed them while holding i_mutex.
+	 * another process may have changed them while holding i_rwsem.
 	 */
 	spin_lock(&osb->osb_lock);
 	if (!ocfs2_la_state_enabled(osb) ||
@@ -1031,7 +1031,7 @@ enum ocfs2_la_event {
 /*
  * Given an event, calculate the size of our next local alloc window.
  *
- * This should always be called under i_mutex of the local alloc inode
+ * This should always be called under i_rwsem of the local alloc inode
  * so that local alloc disabling doesn't race with processes trying to
  * use the allocator.
  *
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -485,7 +485,7 @@ leave:
 		ocfs2_free_alloc_context(meta_ac);
 
 	/*
-	 * We should call iput after the i_mutex of the bitmap been
+	 * We should call iput after the i_rwsem of the bitmap been
 	 * unlocked in ocfs2_free_alloc_context, or the
 	 * ocfs2_delete_inode will mutex_lock again.
 	 */
--- a/fs/ocfs2/ocfs2.h
+++ b/fs/ocfs2/ocfs2.h
@@ -371,7 +371,7 @@ struct ocfs2_super
 	struct delayed_work		la_enable_wq;
 
 	/*
-	 * Must hold local alloc i_mutex and osb->osb_lock to change
+	 * Must hold local alloc i_rwsem and osb->osb_lock to change
 	 * local_alloc_bits. Reads can be done under either lock.
 	 */
 	unsigned int local_alloc_bits;
@@ -446,7 +446,7 @@ struct ocfs2_super
 	atomic_t			osb_tl_disable;
 	/*
 	 * How many clusters in our truncate log.
-	 * It must be protected by osb_tl_inode->i_mutex.
+	 * It must be protected by osb_tl_inode->i_rwsem.
 	 */
 	unsigned int truncated_clusters;
 
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -36,7 +36,7 @@
  * should be obeyed by all the functions:
  * - any write of quota structure (either to local or global file) is protected
  *   by dqio_sem or dquot->dq_lock.
- * - any modification of global quota file holds inode cluster lock, i_mutex,
+ * - any modification of global quota file holds inode cluster lock, i_rwsem,
  *   and ip_alloc_sem of the global quota file (achieved by
  *   ocfs2_lock_global_qf). It also has to hold qinfo_lock.
  * - an allocation of new blocks for local quota file is protected by
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -7210,7 +7210,7 @@ out:
  * Used for reflink a non-preserve-security file.
  *
  * It uses common api like ocfs2_xattr_set, so the caller
- * must not hold any lock expect i_mutex.
+ * must not hold any lock expect i_rwsem.
  */
 int ocfs2_init_security_and_acl(struct inode *dir,
 				struct inode *inode,


