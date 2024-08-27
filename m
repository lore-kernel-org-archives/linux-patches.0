Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F1D1C7B9D;
	Tue, 27 Aug 2024 15:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771864; cv=none; b=i61rSr3W0RedkfFg54pCmshbwgDF82mXEWcYdv2lnfpV9jtPAySdZ1YMp/5NwFruAAF3rZh+Z2QlmPYJ6GNwVmxjwou8bRZmYMcyFT80+nRSnai1e0choj2WW2I9URhVNEBKzugGFaaOzb+uT5FltkzxSms0GViu/N2MtcsWm5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771864; c=relaxed/simple;
	bh=VdSEvipIU5e0q7V0vbGs1puAnadvbDw94nR4psOr+3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LEAUm7QmN76UuU8eiqcMwLvQdbaHoGaGEkilejo+HKRjquT5WnFqmLGI2xLwEYotnKIiB1bX9L+lSNpZKRL5Bi1qfc99XMOJgh0r8UNLhpm784do47fmBLYuC2Ll6CDYb7DnqerT/JHzML9ibQVyAp2BsE4CcJEKtAa6ZDPRBcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DSVZUk4r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DSVZUk4r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6F6AC61040;
	Tue, 27 Aug 2024 15:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771864;
	bh=VdSEvipIU5e0q7V0vbGs1puAnadvbDw94nR4psOr+3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DSVZUk4recS38Fn7Bi9JjWE3qsJCQI/Xx8Pd3NCaPEaE7gsEuSYMaEGJM5fldCRD0
	 b7Yw6MkWD0IpkileK1h3SSDQYoPGkPy0HpTrd8YAX3mbhJoNmev+ObnbFjq37srpwP
	 VzmygYflNl4HJlAxPE10HYoYHPdGppRqVRkf9jO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 044/321] gfs2: Rename gfs2_freeze_lock{ => _shared }
Date: Tue, 27 Aug 2024 16:35:52 +0200
Message-ID: <20240827143839.906015662@linuxfoundation.org>
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

[ Upstream commit e392edd5d52a6742595ecaf8270c1af3e96b9a38 ]

Rename gfs2_freeze_lock to gfs2_freeze_lock_shared to make it a bit more
obvious that this function establishes the "thawed" state of the freeze
glock.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Stable-dep-of: f66af88e3321 ("gfs2: Stop using gfs2_make_fs_ro for withdraw")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/ops_fstype.c |  4 ++--
 fs/gfs2/recovery.c   |  2 +-
 fs/gfs2/super.c      |  2 +-
 fs/gfs2/util.c       | 10 +++++-----
 fs/gfs2/util.h       |  5 +++--
 5 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index c7f6208ad98c0..e427fb7fbe998 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -1266,7 +1266,7 @@ static int gfs2_fill_super(struct super_block *sb, struct fs_context *fc)
 		}
 	}
 
-	error = gfs2_freeze_lock(sdp, &freeze_gh, 0);
+	error = gfs2_freeze_lock_shared(sdp, &freeze_gh, 0);
 	if (error)
 		goto fail_per_node;
 
@@ -1587,7 +1587,7 @@ static int gfs2_reconfigure(struct fs_context *fc)
 	if ((sb->s_flags ^ fc->sb_flags) & SB_RDONLY) {
 		struct gfs2_holder freeze_gh;
 
-		error = gfs2_freeze_lock(sdp, &freeze_gh, 0);
+		error = gfs2_freeze_lock_shared(sdp, &freeze_gh, 0);
 		if (error)
 			return -EINVAL;
 
diff --git a/fs/gfs2/recovery.c b/fs/gfs2/recovery.c
index d8e522f389aa7..61ef07da40b22 100644
--- a/fs/gfs2/recovery.c
+++ b/fs/gfs2/recovery.c
@@ -470,7 +470,7 @@ void gfs2_recover_func(struct work_struct *work)
 
 		/* Acquire a shared hold on the freeze glock */
 
-		error = gfs2_freeze_lock(sdp, &thaw_gh, LM_FLAG_PRIORITY);
+		error = gfs2_freeze_lock_shared(sdp, &thaw_gh, LM_FLAG_PRIORITY);
 		if (error)
 			goto fail_gunlock_ji;
 
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index d7b3a982552cf..cb05332e473bd 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -662,7 +662,7 @@ void gfs2_freeze_func(struct work_struct *work)
 	struct super_block *sb = sdp->sd_vfs;
 
 	atomic_inc(&sb->s_active);
-	error = gfs2_freeze_lock(sdp, &freeze_gh, 0);
+	error = gfs2_freeze_lock_shared(sdp, &freeze_gh, 0);
 	if (error) {
 		gfs2_assert_withdraw(sdp, 0);
 	} else {
diff --git a/fs/gfs2/util.c b/fs/gfs2/util.c
index 11cc59ac64fdc..1195ea08f9ca4 100644
--- a/fs/gfs2/util.c
+++ b/fs/gfs2/util.c
@@ -93,13 +93,13 @@ int check_journal_clean(struct gfs2_sbd *sdp, struct gfs2_jdesc *jd,
 }
 
 /**
- * gfs2_freeze_lock - hold the freeze glock
+ * gfs2_freeze_lock_shared - hold the freeze glock
  * @sdp: the superblock
  * @freeze_gh: pointer to the requested holder
  * @caller_flags: any additional flags needed by the caller
  */
-int gfs2_freeze_lock(struct gfs2_sbd *sdp, struct gfs2_holder *freeze_gh,
-		     int caller_flags)
+int gfs2_freeze_lock_shared(struct gfs2_sbd *sdp, struct gfs2_holder *freeze_gh,
+			    int caller_flags)
 {
 	int flags = LM_FLAG_NOEXP | GL_EXACT | caller_flags;
 	int error;
@@ -157,8 +157,8 @@ static void signal_our_withdraw(struct gfs2_sbd *sdp)
 		gfs2_holder_mark_uninitialized(&freeze_gh);
 		if (sdp->sd_freeze_gl &&
 		    !gfs2_glock_is_locked_by_me(sdp->sd_freeze_gl)) {
-			ret = gfs2_freeze_lock(sdp, &freeze_gh,
-				       log_write_allowed ? 0 : LM_FLAG_TRY);
+			ret = gfs2_freeze_lock_shared(sdp, &freeze_gh,
+					log_write_allowed ? 0 : LM_FLAG_TRY);
 			if (ret == GLR_TRYFAILED)
 				ret = 0;
 		}
diff --git a/fs/gfs2/util.h b/fs/gfs2/util.h
index 78ec190f4155b..3291e33e81e97 100644
--- a/fs/gfs2/util.h
+++ b/fs/gfs2/util.h
@@ -149,8 +149,9 @@ int gfs2_io_error_i(struct gfs2_sbd *sdp, const char *function,
 
 extern int check_journal_clean(struct gfs2_sbd *sdp, struct gfs2_jdesc *jd,
 			       bool verbose);
-extern int gfs2_freeze_lock(struct gfs2_sbd *sdp,
-			    struct gfs2_holder *freeze_gh, int caller_flags);
+extern int gfs2_freeze_lock_shared(struct gfs2_sbd *sdp,
+				   struct gfs2_holder *freeze_gh,
+				   int caller_flags);
 extern void gfs2_freeze_unlock(struct gfs2_holder *freeze_gh);
 
 #define gfs2_io_error(sdp) \
-- 
2.43.0



