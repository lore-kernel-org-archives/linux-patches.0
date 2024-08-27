Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 655A21C7B7B;
	Tue, 27 Aug 2024 15:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771861; cv=none; b=mqlCaQ6mr4Sub6qGnwpWK7t69MWh4iSJE/UkJBYRDQ1ritB0tm+uDkwGey0253v8svZ+i918jIegGvesNoCdYw9BmcgqOQ42LkwiKD5cXFd0t4ZDCqJmHED4TaztnkbPRnphJJ4SJ5d6oKvWMT2Eu+ZbXMyIRQYuTHAKPkV6Rck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771861; c=relaxed/simple;
	bh=TkyGlNsQYwfbHRhftEiYuQf/wHE3Fkl9jQeimIoaJjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tNjhF+7gMaRTFhXIF4pCgpjTu8tF6qHYuWkj6t3qRW7wviUb236FYSik6ayaxk0Kd3VluvVS0Haq1emyQy/PVoxrDMlVQRoHZMkYrezyIHH+hE9bNSs4hutoYwHemwBha/uKcxczczgoMb4HPekMgc3UafqnG7K64QBJP3/18aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o4BYTU5Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o4BYTU5Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CACFC61067;
	Tue, 27 Aug 2024 15:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771861;
	bh=TkyGlNsQYwfbHRhftEiYuQf/wHE3Fkl9jQeimIoaJjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o4BYTU5Y3p5J2U7O2b4FKdsaHzLHDjdXFCRul8TH9f7KxOZHJQKrMWOlCPCZpuPbX
	 +5jOO9Y51GgHG0cSZ9oMsYm4vM9nYw3wdIpXZWDFNb+zSUq1kgY5M9Q1mONU3m5go6
	 O/NTSt5p7dmYJCW/tgIcB+veH6HFxY5hMVU3TxWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 043/321] gfs2: Rename the {freeze,thaw}_super callbacks
Date: Tue, 27 Aug 2024 16:35:51 +0200
Message-ID: <20240827143839.867706907@linuxfoundation.org>
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

[ Upstream commit 097cca525adf10f35c9dac037155564f1b1a688b ]

Rename gfs2_freeze to gfs2_freeze_super and gfs2_unfreeze to
gfs2_thaw_super to match the names of the corresponding super
operations.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Stable-dep-of: f66af88e3321 ("gfs2: Stop using gfs2_make_fs_ro for withdraw")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/super.c | 12 ++++++------
 fs/gfs2/util.c  |  2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index c87fafbe710a6..d7b3a982552cf 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -682,12 +682,12 @@ void gfs2_freeze_func(struct work_struct *work)
 }
 
 /**
- * gfs2_freeze - prevent further writes to the filesystem
+ * gfs2_freeze_super - prevent further writes to the filesystem
  * @sb: the VFS structure for the filesystem
  *
  */
 
-static int gfs2_freeze(struct super_block *sb)
+static int gfs2_freeze_super(struct super_block *sb)
 {
 	struct gfs2_sbd *sdp = sb->s_fs_info;
 	int error;
@@ -727,12 +727,12 @@ static int gfs2_freeze(struct super_block *sb)
 }
 
 /**
- * gfs2_unfreeze - reallow writes to the filesystem
+ * gfs2_thaw_super - reallow writes to the filesystem
  * @sb: the VFS structure for the filesystem
  *
  */
 
-static int gfs2_unfreeze(struct super_block *sb)
+static int gfs2_thaw_super(struct super_block *sb)
 {
 	struct gfs2_sbd *sdp = sb->s_fs_info;
 
@@ -1499,8 +1499,8 @@ const struct super_operations gfs2_super_ops = {
 	.evict_inode		= gfs2_evict_inode,
 	.put_super		= gfs2_put_super,
 	.sync_fs		= gfs2_sync_fs,
-	.freeze_super		= gfs2_freeze,
-	.thaw_super		= gfs2_unfreeze,
+	.freeze_super		= gfs2_freeze_super,
+	.thaw_super		= gfs2_thaw_super,
 	.statfs			= gfs2_statfs,
 	.drop_inode		= gfs2_drop_inode,
 	.show_options		= gfs2_show_options,
diff --git a/fs/gfs2/util.c b/fs/gfs2/util.c
index 86d1415932a43..11cc59ac64fdc 100644
--- a/fs/gfs2/util.c
+++ b/fs/gfs2/util.c
@@ -188,7 +188,7 @@ static void signal_our_withdraw(struct gfs2_sbd *sdp)
 	sdp->sd_jinode_gh.gh_flags |= GL_NOCACHE;
 	gfs2_glock_dq(&sdp->sd_jinode_gh);
 	if (test_bit(SDF_FS_FROZEN, &sdp->sd_flags)) {
-		/* Make sure gfs2_unfreeze works if partially-frozen */
+		/* Make sure gfs2_thaw_super works if partially-frozen */
 		flush_work(&sdp->sd_freeze_work);
 		atomic_set(&sdp->sd_freeze_state, SFS_FROZEN);
 		thaw_super(sdp->sd_vfs);
-- 
2.43.0



