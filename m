Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B4D21C7B61;
	Tue, 27 Aug 2024 15:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771857; cv=none; b=LNw65c2AHsD8Fw5ZTf7bob8QQMwZBtL8Azfklxg3bB4NU65GXqW5QsM/vp4iwNh4vRBpIJvZeJIx2aJDri2bZx1N54ENA6U3XXFnZFsrg7ZP9V+LxXF7I+ZPMD14DxyfjpsNnEegZnmB6ioJNM9bxj+3Jjg8qojJ1pLHKSB+rUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771857; c=relaxed/simple;
	bh=JIaB3MKH0Ni1TsUG/Niy/tAat12zKXi7bqset3OSGSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ibe4sSh5cqDXIhY47mi5AdvpZgxVgWYcHDWHSSJ3vum2I0I0f70bofZE8SN3waLJivEvJ2reQKIrw6HIyu3nEZ07VRuj7rgvSexxjxmJ/VgYwHu0POt7AKI06l04yEFwHOV0SzdLjQmoUGTnBAC4Xt73FQTiAL9nqFtokkN2wZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wJDcabQa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wJDcabQa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 214D8C61040;
	Tue, 27 Aug 2024 15:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771857;
	bh=JIaB3MKH0Ni1TsUG/Niy/tAat12zKXi7bqset3OSGSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wJDcabQaRwZbIrOeeOsLswh8CHIy2+YrAtjdy+NKga9byfuNA3fKEggEWqVKiL+WQ
	 41+dwsOIac0oHyk/ZJi3SEPM+8s/xYt0rB/xmYRW4/KUEly8RINiSxB5Gkq/OTTKu0
	 oIuc8ttfyYZXEgtkmbDebhvucoTWlq2Be8EYaBFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 042/321] gfs2: Rename remaining "transaction" glock references
Date: Tue, 27 Aug 2024 16:35:50 +0200
Message-ID: <20240827143839.829297882@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit af1abe11466f1a6cb6ba22ee0d815c21c3559947 ]

The transaction glock was repurposed to serve as the new freeze glock
years ago.  Don't refer to it as the transaction glock anymore.

Also, to be more precise, call it the "freeze glock" instead of the
"freeze lock".  Ditto for the journal glock.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Stable-dep-of: f66af88e3321 ("gfs2: Stop using gfs2_make_fs_ro for withdraw")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/glock.c      | 4 ++--
 fs/gfs2/ops_fstype.c | 2 +-
 fs/gfs2/recovery.c   | 8 ++++----
 fs/gfs2/super.c      | 2 +-
 fs/gfs2/util.c       | 2 +-
 5 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 95353982e643a..be05c43b89a59 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -146,8 +146,8 @@ static void gfs2_glock_dealloc(struct rcu_head *rcu)
  *
  * We need to allow some glocks to be enqueued, dequeued, promoted, and demoted
  * when we're withdrawn. For example, to maintain metadata integrity, we should
- * disallow the use of inode and rgrp glocks when withdrawn. Other glocks, like
- * iopen or the transaction glocks may be safely used because none of their
+ * disallow the use of inode and rgrp glocks when withdrawn. Other glocks like
+ * the iopen or freeze glock may be safely used because none of their
  * metadata goes through the journal. So in general, we should disallow all
  * glocks that are journaled, and allow all the others. One exception is:
  * we need to allow our active journal to be promoted and demoted so others
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index c0cf1d2d0ef5b..c7f6208ad98c0 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -434,7 +434,7 @@ static int init_locking(struct gfs2_sbd *sdp, struct gfs2_holder *mount_gh,
 	error = gfs2_glock_get(sdp, GFS2_FREEZE_LOCK, &gfs2_freeze_glops,
 			       CREATE, &sdp->sd_freeze_gl);
 	if (error) {
-		fs_err(sdp, "can't create transaction glock: %d\n", error);
+		fs_err(sdp, "can't create freeze glock: %d\n", error);
 		goto fail_rename;
 	}
 
diff --git a/fs/gfs2/recovery.c b/fs/gfs2/recovery.c
index 2bb085a72e8ee..d8e522f389aa7 100644
--- a/fs/gfs2/recovery.c
+++ b/fs/gfs2/recovery.c
@@ -420,10 +420,10 @@ void gfs2_recover_func(struct work_struct *work)
 	if (sdp->sd_args.ar_spectator)
 		goto fail;
 	if (jd->jd_jid != sdp->sd_lockstruct.ls_jid) {
-		fs_info(sdp, "jid=%u: Trying to acquire journal lock...\n",
+		fs_info(sdp, "jid=%u: Trying to acquire journal glock...\n",
 			jd->jd_jid);
 		jlocked = 1;
-		/* Acquire the journal lock so we can do recovery */
+		/* Acquire the journal glock so we can do recovery */
 
 		error = gfs2_glock_nq_num(sdp, jd->jd_jid, &gfs2_journal_glops,
 					  LM_ST_EXCLUSIVE,
@@ -465,10 +465,10 @@ void gfs2_recover_func(struct work_struct *work)
 		ktime_ms_delta(t_jhd, t_jlck));
 
 	if (!(head.lh_flags & GFS2_LOG_HEAD_UNMOUNT)) {
-		fs_info(sdp, "jid=%u: Acquiring the transaction lock...\n",
+		fs_info(sdp, "jid=%u: Acquiring the freeze glock...\n",
 			jd->jd_jid);
 
-		/* Acquire a shared hold on the freeze lock */
+		/* Acquire a shared hold on the freeze glock */
 
 		error = gfs2_freeze_lock(sdp, &thaw_gh, LM_FLAG_PRIORITY);
 		if (error)
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 6107cd680176c..c87fafbe710a6 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -463,7 +463,7 @@ static int gfs2_write_inode(struct inode *inode, struct writeback_control *wbc)
  * @flags: The type of dirty
  *
  * Unfortunately it can be called under any combination of inode
- * glock and transaction lock, so we have to check carefully.
+ * glock and freeze glock, so we have to check carefully.
  *
  * At the moment this deals only with atime - it should be possible
  * to expand that role in future, once a review of the locking has
diff --git a/fs/gfs2/util.c b/fs/gfs2/util.c
index 48c69aa60cd17..86d1415932a43 100644
--- a/fs/gfs2/util.c
+++ b/fs/gfs2/util.c
@@ -107,7 +107,7 @@ int gfs2_freeze_lock(struct gfs2_sbd *sdp, struct gfs2_holder *freeze_gh,
 	error = gfs2_glock_nq_init(sdp->sd_freeze_gl, LM_ST_SHARED, flags,
 				   freeze_gh);
 	if (error && error != GLR_TRYFAILED)
-		fs_err(sdp, "can't lock the freeze lock: %d\n", error);
+		fs_err(sdp, "can't lock the freeze glock: %d\n", error);
 	return error;
 }
 
-- 
2.43.0



