Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1979B1A3BDD;
	Thu,  6 Jun 2024 14:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683248; cv=none; b=VGqLHGVpmUVQNK90sItJ1owvilxs1M0F9MYyaYXRq0a4dgxgNcxCZtTvTJHvGdO0xsB1lyFsjP1w9N9EvS5Pp4Ti75F9YS3HhJyna3oQOZVmAOyhxvrOsnCiTI+p4b0lt0wm9oCh2iEUQGRXCbWv7bBsjNQc4ffIjQu5uw4RQXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683248; c=relaxed/simple;
	bh=D6hikiBbCYdSF/eCDZhFoC4rQP0B0OfwUjYZEecgUNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tgd7BPAXS+Ocjd6ASQ9NEalUAW0BMxMwEJK0F1Ck1bH7lP/GwSKHaqizVNyxVXuIrn03t+i2DF1MzRZCqRVuNGUGGOIj2n85zPJLThGZaJO2SgBeHbQ8fdNVXrKxxCGQ1KI8gbC0qATwCr/ZiXp8+m7V/Ce/4+ys7rkmhUJLNpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VgxyQoC8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VgxyQoC8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9B8AC2BD10;
	Thu,  6 Jun 2024 14:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683248;
	bh=D6hikiBbCYdSF/eCDZhFoC4rQP0B0OfwUjYZEecgUNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VgxyQoC82SXeUPrSYaWBRKCp29Xykd0Bo1ySx4uRbWRMu4EAtWZsF0buvxoPuqH8L
	 cvVdC96ZwzLtwOB/jhSF1+W8x204mdL5TWny4kfjbEr+hxYP37EVzi+v7MShgP5SiL
	 bivPbNMXZmopshBPrlVspcpTJNEeQ5ox2zDA1A1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 192/744] gfs2: Mark withdraws as unlikely
Date: Thu,  6 Jun 2024 15:57:44 +0200
Message-ID: <20240606131738.596784324@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 015af1af44003fff797f8632e940824c07d282bf ]

Mark the gfs2_withdrawn(), gfs2_withdrawing(), and
gfs2_withdraw_in_prog() inline functions as likely to return %false.
This allows to get rid of likely() and unlikely() annotations at the
call sites of those functions.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Stable-dep-of: 9947a06d29c0 ("gfs2: do_xmote fixes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/aops.c       |  2 +-
 fs/gfs2/file.c       |  2 +-
 fs/gfs2/glock.c      |  4 ++--
 fs/gfs2/meta_io.c    |  6 +++---
 fs/gfs2/ops_fstype.c |  2 +-
 fs/gfs2/super.c      |  2 +-
 fs/gfs2/trans.c      |  2 +-
 fs/gfs2/util.h       | 10 +++++-----
 8 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index 48dc35caa60b4..b8404ce301b3c 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -464,7 +464,7 @@ static int gfs2_read_folio(struct file *file, struct folio *folio)
 		error = mpage_read_folio(folio, gfs2_block_map);
 	}
 
-	if (unlikely(gfs2_withdrawn(sdp)))
+	if (gfs2_withdrawn(sdp))
 		return -EIO;
 
 	return error;
diff --git a/fs/gfs2/file.c b/fs/gfs2/file.c
index f2700477a3001..1dc7fe805d2f1 100644
--- a/fs/gfs2/file.c
+++ b/fs/gfs2/file.c
@@ -1436,7 +1436,7 @@ static int gfs2_lock(struct file *file, int cmd, struct file_lock *fl)
 
 	if (!(fl->fl_flags & FL_POSIX))
 		return -ENOLCK;
-	if (unlikely(gfs2_withdrawn(sdp))) {
+	if (gfs2_withdrawn(sdp)) {
 		if (fl->fl_type == F_UNLCK)
 			locks_lock_file_wait(file, fl);
 		return -EIO;
diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index c195244d21dfd..42de9db983a8b 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -156,7 +156,7 @@ static bool glock_blocked_by_withdraw(struct gfs2_glock *gl)
 {
 	struct gfs2_sbd *sdp = gl->gl_name.ln_sbd;
 
-	if (likely(!gfs2_withdrawn(sdp)))
+	if (!gfs2_withdrawn(sdp))
 		return false;
 	if (gl->gl_ops->go_flags & GLOF_NONDISK)
 		return false;
@@ -783,7 +783,7 @@ __acquires(&gl->gl_lockref.lock)
 	 * gfs2_gl_hash_clear calls clear_glock) and recovery is complete
 	 * then it's okay to tell dlm to unlock it.
 	 */
-	if (unlikely(sdp->sd_log_error && !gfs2_withdrawn(sdp)))
+	if (unlikely(sdp->sd_log_error) && !gfs2_withdrawn(sdp))
 		gfs2_withdraw_delayed(sdp);
 	if (glock_blocked_by_withdraw(gl) &&
 	    (target != LM_ST_UNLOCKED ||
diff --git a/fs/gfs2/meta_io.c b/fs/gfs2/meta_io.c
index 924361fa510b1..50c2ecbba7ca7 100644
--- a/fs/gfs2/meta_io.c
+++ b/fs/gfs2/meta_io.c
@@ -257,7 +257,7 @@ int gfs2_meta_read(struct gfs2_glock *gl, u64 blkno, int flags,
 	struct buffer_head *bh, *bhs[2];
 	int num = 0;
 
-	if (unlikely(gfs2_withdrawn(sdp)) && !gfs2_withdraw_in_prog(sdp)) {
+	if (gfs2_withdrawn(sdp) && !gfs2_withdraw_in_prog(sdp)) {
 		*bhp = NULL;
 		return -EIO;
 	}
@@ -315,7 +315,7 @@ int gfs2_meta_read(struct gfs2_glock *gl, u64 blkno, int flags,
 
 int gfs2_meta_wait(struct gfs2_sbd *sdp, struct buffer_head *bh)
 {
-	if (unlikely(gfs2_withdrawn(sdp)) && !gfs2_withdraw_in_prog(sdp))
+	if (gfs2_withdrawn(sdp) && !gfs2_withdraw_in_prog(sdp))
 		return -EIO;
 
 	wait_on_buffer(bh);
@@ -326,7 +326,7 @@ int gfs2_meta_wait(struct gfs2_sbd *sdp, struct buffer_head *bh)
 			gfs2_io_error_bh_wd(sdp, bh);
 		return -EIO;
 	}
-	if (unlikely(gfs2_withdrawn(sdp)) && !gfs2_withdraw_in_prog(sdp))
+	if (gfs2_withdrawn(sdp) && !gfs2_withdraw_in_prog(sdp))
 		return -EIO;
 
 	return 0;
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index fc7bc1e59748f..be7df57bd5c86 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -1075,7 +1075,7 @@ static int gfs2_lm_mount(struct gfs2_sbd *sdp, int silent)
 void gfs2_lm_unmount(struct gfs2_sbd *sdp)
 {
 	const struct lm_lockops *lm = sdp->sd_lockstruct.ls_ops;
-	if (likely(!gfs2_withdrawn(sdp)) && lm->lm_unmount)
+	if (!gfs2_withdrawn(sdp) && lm->lm_unmount)
 		lm->lm_unmount(sdp);
 }
 
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 2b47a4119591f..1afcca5292d55 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -499,7 +499,7 @@ static void gfs2_dirty_inode(struct inode *inode, int flags)
 		return;
 	}
 
-	if (unlikely(gfs2_withdrawn(sdp)))
+	if (gfs2_withdrawn(sdp))
 		return;
 	if (!gfs2_glock_is_locked_by_me(ip->i_gl)) {
 		ret = gfs2_glock_nq_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &gh);
diff --git a/fs/gfs2/trans.c b/fs/gfs2/trans.c
index 7e835be7032d0..1487fbb62d842 100644
--- a/fs/gfs2/trans.c
+++ b/fs/gfs2/trans.c
@@ -268,7 +268,7 @@ void gfs2_trans_add_meta(struct gfs2_glock *gl, struct buffer_head *bh)
 		       (unsigned long long)bd->bd_bh->b_blocknr);
 		BUG();
 	}
-	if (unlikely(gfs2_withdrawn(sdp))) {
+	if (gfs2_withdrawn(sdp)) {
 		fs_info(sdp, "GFS2:adding buf while withdrawn! 0x%llx\n",
 			(unsigned long long)bd->bd_bh->b_blocknr);
 		goto out_unlock;
diff --git a/fs/gfs2/util.h b/fs/gfs2/util.h
index 11c9d59b68896..76acf0b398149 100644
--- a/fs/gfs2/util.h
+++ b/fs/gfs2/util.h
@@ -203,8 +203,8 @@ static inline void gfs2_withdraw_delayed(struct gfs2_sbd *sdp)
  */
 static inline bool gfs2_withdrawn(struct gfs2_sbd *sdp)
 {
-	return test_bit(SDF_WITHDRAWN, &sdp->sd_flags) ||
-		test_bit(SDF_WITHDRAWING, &sdp->sd_flags);
+	return unlikely(test_bit(SDF_WITHDRAWN, &sdp->sd_flags) ||
+			test_bit(SDF_WITHDRAWING, &sdp->sd_flags));
 }
 
 /**
@@ -213,13 +213,13 @@ static inline bool gfs2_withdrawn(struct gfs2_sbd *sdp)
  */
 static inline bool gfs2_withdrawing(struct gfs2_sbd *sdp)
 {
-	return test_bit(SDF_WITHDRAWING, &sdp->sd_flags) &&
-	       !test_bit(SDF_WITHDRAWN, &sdp->sd_flags);
+	return unlikely(test_bit(SDF_WITHDRAWING, &sdp->sd_flags) &&
+			!test_bit(SDF_WITHDRAWN, &sdp->sd_flags));
 }
 
 static inline bool gfs2_withdraw_in_prog(struct gfs2_sbd *sdp)
 {
-	return test_bit(SDF_WITHDRAW_IN_PROG, &sdp->sd_flags);
+	return unlikely(test_bit(SDF_WITHDRAW_IN_PROG, &sdp->sd_flags));
 }
 
 #define gfs2_tune_get(sdp, field) \
-- 
2.43.0



