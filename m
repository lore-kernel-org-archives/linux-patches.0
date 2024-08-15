Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 148B817BEC0;
	Thu, 15 Aug 2024 14:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732651; cv=none; b=o66sV0/ViPP/c+y1s9NhuUVJr/LtjLoIi+O1wOqp41JxpGrcvrISHGkNcrAdXo/MVHVgLdX4y4dHZW7mlOo2NiUV2n6IPPYJjEJPq7M8MAWd3qeNdFC+1jWHLCrYU2vld4Z7n3j39P1e39ezUrW/sg47xJj9RHrorR8QqQi9eL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732651; c=relaxed/simple;
	bh=GFvGTCO8+GSd/6aD6TJIe3vJGbIaw7H4GMkymofVOJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C6InuxP+wXngL2gdG+XZs/3j6W834+C8RvukK3U9ADF1cAnDUSO0J1+wafqNtgUbSdwyR5LlmJg8p6MrQsyfgQclDBOsWad0hUEDuavXV3MMcef4DjiVJnGOdbRSO/Pq8NCBGl/Alif0Td/gya4r5FMscyqHZrOHDXg07nMWOO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fq520k7O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fq520k7O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ACC3C32786;
	Thu, 15 Aug 2024 14:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732651;
	bh=GFvGTCO8+GSd/6aD6TJIe3vJGbIaw7H4GMkymofVOJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fq520k7OnGBKQK/TXjg/9hv0AjXDnUsKsAVLhzcRm1Gnf58oAyQ8ZRwqQN+pw526Q
	 12waaTLuZC7Dj0vIEjur7izDRhJS3pwJ/kKG4HPbgZJngk7U3B/vNpw4/LXPU+yhI9
	 ss/NvVqFVXmM18UOxzMY3HdviYD9XGON+9MKWUKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 217/352] fuse: name fs_context consistently
Date: Thu, 15 Aug 2024 15:24:43 +0200
Message-ID: <20240815131927.677111155@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@redhat.com>

[ Upstream commit 84c215075b5723ab946708a6c74c26bd3c51114c ]

Naming convention under fs/fuse/:

	struct fuse_conn *fc;
	struct fs_context *fsc;

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Stable-dep-of: 525bd65aa759 ("fuse: verify {g,u}id mount options correctly")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/control.c   | 10 ++++----
 fs/fuse/inode.c     | 60 ++++++++++++++++++++++-----------------------
 fs/fuse/virtio_fs.c | 12 ++++-----
 3 files changed, 41 insertions(+), 41 deletions(-)

diff --git a/fs/fuse/control.c b/fs/fuse/control.c
index 24b4d9db231db..79f01d09c78cb 100644
--- a/fs/fuse/control.c
+++ b/fs/fuse/control.c
@@ -328,7 +328,7 @@ void fuse_ctl_remove_conn(struct fuse_conn *fc)
 	drop_nlink(d_inode(fuse_control_sb->s_root));
 }
 
-static int fuse_ctl_fill_super(struct super_block *sb, struct fs_context *fctx)
+static int fuse_ctl_fill_super(struct super_block *sb, struct fs_context *fsc)
 {
 	static const struct tree_descr empty_descr = {""};
 	struct fuse_conn *fc;
@@ -354,18 +354,18 @@ static int fuse_ctl_fill_super(struct super_block *sb, struct fs_context *fctx)
 	return 0;
 }
 
-static int fuse_ctl_get_tree(struct fs_context *fc)
+static int fuse_ctl_get_tree(struct fs_context *fsc)
 {
-	return get_tree_single(fc, fuse_ctl_fill_super);
+	return get_tree_single(fsc, fuse_ctl_fill_super);
 }
 
 static const struct fs_context_operations fuse_ctl_context_ops = {
 	.get_tree	= fuse_ctl_get_tree,
 };
 
-static int fuse_ctl_init_fs_context(struct fs_context *fc)
+static int fuse_ctl_init_fs_context(struct fs_context *fsc)
 {
-	fc->ops = &fuse_ctl_context_ops;
+	fsc->ops = &fuse_ctl_context_ops;
 	return 0;
 }
 
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 4a7ebccd359ee..5f9b2dc59135b 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -141,12 +141,12 @@ static void fuse_evict_inode(struct inode *inode)
 	}
 }
 
-static int fuse_reconfigure(struct fs_context *fc)
+static int fuse_reconfigure(struct fs_context *fsc)
 {
-	struct super_block *sb = fc->root->d_sb;
+	struct super_block *sb = fsc->root->d_sb;
 
 	sync_filesystem(sb);
-	if (fc->sb_flags & SB_MANDLOCK)
+	if (fsc->sb_flags & SB_MANDLOCK)
 		return -EINVAL;
 
 	return 0;
@@ -535,38 +535,38 @@ static const struct fs_parameter_spec fuse_fs_parameters[] = {
 	{}
 };
 
-static int fuse_parse_param(struct fs_context *fc, struct fs_parameter *param)
+static int fuse_parse_param(struct fs_context *fsc, struct fs_parameter *param)
 {
 	struct fs_parse_result result;
-	struct fuse_fs_context *ctx = fc->fs_private;
+	struct fuse_fs_context *ctx = fsc->fs_private;
 	int opt;
 
-	if (fc->purpose == FS_CONTEXT_FOR_RECONFIGURE) {
+	if (fsc->purpose == FS_CONTEXT_FOR_RECONFIGURE) {
 		/*
 		 * Ignore options coming from mount(MS_REMOUNT) for backward
 		 * compatibility.
 		 */
-		if (fc->oldapi)
+		if (fsc->oldapi)
 			return 0;
 
-		return invalfc(fc, "No changes allowed in reconfigure");
+		return invalfc(fsc, "No changes allowed in reconfigure");
 	}
 
-	opt = fs_parse(fc, fuse_fs_parameters, param, &result);
+	opt = fs_parse(fsc, fuse_fs_parameters, param, &result);
 	if (opt < 0)
 		return opt;
 
 	switch (opt) {
 	case OPT_SOURCE:
-		if (fc->source)
-			return invalfc(fc, "Multiple sources specified");
-		fc->source = param->string;
+		if (fsc->source)
+			return invalfc(fsc, "Multiple sources specified");
+		fsc->source = param->string;
 		param->string = NULL;
 		break;
 
 	case OPT_SUBTYPE:
 		if (ctx->subtype)
-			return invalfc(fc, "Multiple subtypes specified");
+			return invalfc(fsc, "Multiple subtypes specified");
 		ctx->subtype = param->string;
 		param->string = NULL;
 		return 0;
@@ -578,22 +578,22 @@ static int fuse_parse_param(struct fs_context *fc, struct fs_parameter *param)
 
 	case OPT_ROOTMODE:
 		if (!fuse_valid_type(result.uint_32))
-			return invalfc(fc, "Invalid rootmode");
+			return invalfc(fsc, "Invalid rootmode");
 		ctx->rootmode = result.uint_32;
 		ctx->rootmode_present = true;
 		break;
 
 	case OPT_USER_ID:
-		ctx->user_id = make_kuid(fc->user_ns, result.uint_32);
+		ctx->user_id = make_kuid(fsc->user_ns, result.uint_32);
 		if (!uid_valid(ctx->user_id))
-			return invalfc(fc, "Invalid user_id");
+			return invalfc(fsc, "Invalid user_id");
 		ctx->user_id_present = true;
 		break;
 
 	case OPT_GROUP_ID:
-		ctx->group_id = make_kgid(fc->user_ns, result.uint_32);
+		ctx->group_id = make_kgid(fsc->user_ns, result.uint_32);
 		if (!gid_valid(ctx->group_id))
-			return invalfc(fc, "Invalid group_id");
+			return invalfc(fsc, "Invalid group_id");
 		ctx->group_id_present = true;
 		break;
 
@@ -611,7 +611,7 @@ static int fuse_parse_param(struct fs_context *fc, struct fs_parameter *param)
 
 	case OPT_BLKSIZE:
 		if (!ctx->is_bdev)
-			return invalfc(fc, "blksize only supported for fuseblk");
+			return invalfc(fsc, "blksize only supported for fuseblk");
 		ctx->blksize = result.uint_32;
 		break;
 
@@ -622,9 +622,9 @@ static int fuse_parse_param(struct fs_context *fc, struct fs_parameter *param)
 	return 0;
 }
 
-static void fuse_free_fc(struct fs_context *fc)
+static void fuse_free_fsc(struct fs_context *fsc)
 {
-	struct fuse_fs_context *ctx = fc->fs_private;
+	struct fuse_fs_context *ctx = fsc->fs_private;
 
 	if (ctx) {
 		kfree(ctx->subtype);
@@ -1486,9 +1486,9 @@ static int fuse_fill_super(struct super_block *sb, struct fs_context *fsc)
 	return err;
 }
 
-static int fuse_get_tree(struct fs_context *fc)
+static int fuse_get_tree(struct fs_context *fsc)
 {
-	struct fuse_fs_context *ctx = fc->fs_private;
+	struct fuse_fs_context *ctx = fsc->fs_private;
 
 	if (!ctx->fd_present || !ctx->rootmode_present ||
 	    !ctx->user_id_present || !ctx->group_id_present)
@@ -1496,14 +1496,14 @@ static int fuse_get_tree(struct fs_context *fc)
 
 #ifdef CONFIG_BLOCK
 	if (ctx->is_bdev)
-		return get_tree_bdev(fc, fuse_fill_super);
+		return get_tree_bdev(fsc, fuse_fill_super);
 #endif
 
-	return get_tree_nodev(fc, fuse_fill_super);
+	return get_tree_nodev(fsc, fuse_fill_super);
 }
 
 static const struct fs_context_operations fuse_context_ops = {
-	.free		= fuse_free_fc,
+	.free		= fuse_free_fsc,
 	.parse_param	= fuse_parse_param,
 	.reconfigure	= fuse_reconfigure,
 	.get_tree	= fuse_get_tree,
@@ -1512,7 +1512,7 @@ static const struct fs_context_operations fuse_context_ops = {
 /*
  * Set up the filesystem mount context.
  */
-static int fuse_init_fs_context(struct fs_context *fc)
+static int fuse_init_fs_context(struct fs_context *fsc)
 {
 	struct fuse_fs_context *ctx;
 
@@ -1525,14 +1525,14 @@ static int fuse_init_fs_context(struct fs_context *fc)
 	ctx->legacy_opts_show = true;
 
 #ifdef CONFIG_BLOCK
-	if (fc->fs_type == &fuseblk_fs_type) {
+	if (fsc->fs_type == &fuseblk_fs_type) {
 		ctx->is_bdev = true;
 		ctx->destroy = true;
 	}
 #endif
 
-	fc->fs_private = ctx;
-	fc->ops = &fuse_context_ops;
+	fsc->fs_private = ctx;
+	fsc->ops = &fuse_context_ops;
 	return 0;
 }
 
diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index faadc80485e7f..7d4655022afc6 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -97,14 +97,14 @@ static const struct fs_parameter_spec virtio_fs_parameters[] = {
 	{}
 };
 
-static int virtio_fs_parse_param(struct fs_context *fc,
+static int virtio_fs_parse_param(struct fs_context *fsc,
 				 struct fs_parameter *param)
 {
 	struct fs_parse_result result;
-	struct fuse_fs_context *ctx = fc->fs_private;
+	struct fuse_fs_context *ctx = fsc->fs_private;
 	int opt;
 
-	opt = fs_parse(fc, virtio_fs_parameters, param, &result);
+	opt = fs_parse(fsc, virtio_fs_parameters, param, &result);
 	if (opt < 0)
 		return opt;
 
@@ -119,9 +119,9 @@ static int virtio_fs_parse_param(struct fs_context *fc,
 	return 0;
 }
 
-static void virtio_fs_free_fc(struct fs_context *fc)
+static void virtio_fs_free_fsc(struct fs_context *fsc)
 {
-	struct fuse_fs_context *ctx = fc->fs_private;
+	struct fuse_fs_context *ctx = fsc->fs_private;
 
 	kfree(ctx);
 }
@@ -1500,7 +1500,7 @@ static int virtio_fs_get_tree(struct fs_context *fsc)
 }
 
 static const struct fs_context_operations virtio_fs_context_ops = {
-	.free		= virtio_fs_free_fc,
+	.free		= virtio_fs_free_fsc,
 	.parse_param	= virtio_fs_parse_param,
 	.get_tree	= virtio_fs_get_tree,
 };
-- 
2.43.0



