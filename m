Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA22A19CCF2;
	Thu,  6 Jun 2024 14:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683423; cv=none; b=R83/GPryIJkkOgjOh3y2zBx7wSvHodfxbSP9vxje79h6CwubBeltbU8sKn6+5DDQMrJAsMZeMIk41uG53LekpnuMyp5FLcwJCzSem80678zrqSaVOd4ArhUJh8CVaTL+ADqvUng2t3nFsJbi/fkume+sGMEad07iDRTJVEAgR+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683423; c=relaxed/simple;
	bh=VqCwrDlwpPzmrS3keS3fkFEzPgAYH5RGb2Mq8JjZMLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LejGloKi4DYu9IUm6O+Ukah0v44/UAB1MzkAT/IFr+jxecRo45ATKBPnYhLVv6UmjxEN1O0vmIv+Z92EbtJt7V3Mt/ehENoqNHycgnBvQQHHn7KF27cQfkGO0Lriwmq0IGXidQN4pAPUF5Qh5k04vm+ZzbbepaaM30cF/Pfn+B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nrXjpkU+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nrXjpkU+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AFD4C32781;
	Thu,  6 Jun 2024 14:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683423;
	bh=VqCwrDlwpPzmrS3keS3fkFEzPgAYH5RGb2Mq8JjZMLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nrXjpkU+2UmjTfSqVwI3yaBbq6pjDJlxcYw5bfcTdRI9AVgcpLPV6RNEPD3O9bB6/
	 EFnUb4+N6+WEOiT+cBBivu57IRONTr1NU5cC20ZztT5ARWxDl60WQwnBG80yLlm5Kf
	 xjRl4Y3nWyxMVOErb9o3bnDEcuUvNmW8OThuf15w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinyoung Choi <j-young.choi@samsung.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 309/473] f2fs: fix typos in comments
Date: Thu,  6 Jun 2024 16:03:58 +0200
Message-ID: <20240606131710.158376607@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

From: Jinyoung CHOI <j-young.choi@samsung.com>

[ Upstream commit 146949defda868378992171b9e42318b06fcd482 ]

This patch is to fix typos in f2fs files.

Signed-off-by: Jinyoung Choi <j-young.choi@samsung.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: 278a6253a673 ("f2fs: fix to relocate check condition in f2fs_fallocate()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/checkpoint.c   | 4 ++--
 fs/f2fs/compress.c     | 2 +-
 fs/f2fs/data.c         | 8 ++++----
 fs/f2fs/extent_cache.c | 4 ++--
 fs/f2fs/file.c         | 6 +++---
 fs/f2fs/namei.c        | 2 +-
 fs/f2fs/segment.c      | 2 +-
 7 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 3ec203bbd5593..13d8774706758 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -797,7 +797,7 @@ static void write_orphan_inodes(struct f2fs_sb_info *sbi, block_t start_blk)
 	 */
 	head = &im->ino_list;
 
-	/* loop for each orphan inode entry and write them in Jornal block */
+	/* loop for each orphan inode entry and write them in journal block */
 	list_for_each_entry(orphan, head, list) {
 		if (!page) {
 			page = f2fs_grab_meta_page(sbi, start_blk++);
@@ -1127,7 +1127,7 @@ int f2fs_sync_dirty_inodes(struct f2fs_sb_info *sbi, enum inode_type type,
 	} else {
 		/*
 		 * We should submit bio, since it exists several
-		 * wribacking dentry pages in the freeing inode.
+		 * writebacking dentry pages in the freeing inode.
 		 */
 		f2fs_submit_merged_write(sbi, DATA);
 		cond_resched();
diff --git a/fs/f2fs/compress.c b/fs/f2fs/compress.c
index df6dfd7de6d0d..84585dba86a57 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -1264,7 +1264,7 @@ static int f2fs_write_compressed_pages(struct compress_ctx *cc,
 	int i, err;
 	bool quota_inode = IS_NOQUOTA(inode);
 
-	/* we should bypass data pages to proceed the kworkder jobs */
+	/* we should bypass data pages to proceed the kworker jobs */
 	if (unlikely(f2fs_cp_error(sbi))) {
 		mapping_set_error(cc->rpages[0]->mapping, -EIO);
 		goto out_free;
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index ea9b78b5a1ebe..0b0e3d44e158e 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2363,7 +2363,7 @@ static int f2fs_mpage_readpages(struct inode *inode,
 
 #ifdef CONFIG_F2FS_FS_COMPRESSION
 		if (f2fs_compressed_file(inode)) {
-			/* there are remained comressed pages, submit them */
+			/* there are remained compressed pages, submit them */
 			if (!f2fs_cluster_can_merge_page(&cc, page->index)) {
 				ret = f2fs_read_multi_pages(&cc, &bio,
 							max_nr_pages,
@@ -2779,7 +2779,7 @@ int f2fs_write_single_data_page(struct page *page, int *submitted,
 
 	trace_f2fs_writepage(page, DATA);
 
-	/* we should bypass data pages to proceed the kworkder jobs */
+	/* we should bypass data pages to proceed the kworker jobs */
 	if (unlikely(f2fs_cp_error(sbi))) {
 		mapping_set_error(page->mapping, -EIO);
 		/*
@@ -2898,7 +2898,7 @@ int f2fs_write_single_data_page(struct page *page, int *submitted,
 redirty_out:
 	redirty_page_for_writepage(wbc, page);
 	/*
-	 * pageout() in MM traslates EAGAIN, so calls handle_write_error()
+	 * pageout() in MM translates EAGAIN, so calls handle_write_error()
 	 * -> mapping_set_error() -> set_bit(AS_EIO, ...).
 	 * file_write_and_wait_range() will see EIO error, which is critical
 	 * to return value of fsync() followed by atomic_write failure to user.
@@ -2932,7 +2932,7 @@ static int f2fs_write_data_page(struct page *page,
 }
 
 /*
- * This function was copied from write_cche_pages from mm/page-writeback.c.
+ * This function was copied from write_cache_pages from mm/page-writeback.c.
  * The major change is making write step of cold data page separately from
  * warm/hot data page.
  */
diff --git a/fs/f2fs/extent_cache.c b/fs/f2fs/extent_cache.c
index 16692c96e7650..c55359267d438 100644
--- a/fs/f2fs/extent_cache.c
+++ b/fs/f2fs/extent_cache.c
@@ -205,7 +205,7 @@ struct rb_node **f2fs_lookup_rb_tree_for_insert(struct f2fs_sb_info *sbi,
  * @prev_ex: extent before ofs
  * @next_ex: extent after ofs
  * @insert_p: insert point for new extent at ofs
- * in order to simpfy the insertion after.
+ * in order to simplify the insertion after.
  * tree must stay unchanged between lookup and insertion.
  */
 struct rb_entry *f2fs_lookup_rb_tree_ret(struct rb_root_cached *root,
@@ -662,7 +662,7 @@ static void __update_extent_tree_range(struct inode *inode,
 	if (!en)
 		en = next_en;
 
-	/* 2. invlidate all extent nodes in range [fofs, fofs + len - 1] */
+	/* 2. invalidate all extent nodes in range [fofs, fofs + len - 1] */
 	while (en && en->ei.fofs < end) {
 		unsigned int org_end;
 		int parts = 0;	/* # of parts current extent split into */
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 46b6f06a4a76a..423b9150dc0a8 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -305,7 +305,7 @@ static int f2fs_do_sync_file(struct file *file, loff_t start, loff_t end,
 		 * for OPU case, during fsync(), node can be persisted before
 		 * data when lower device doesn't support write barrier, result
 		 * in data corruption after SPO.
-		 * So for strict fsync mode, force to use atomic write sematics
+		 * So for strict fsync mode, force to use atomic write semantics
 		 * to keep write order in between data/node and last node to
 		 * avoid potential data corruption.
 		 */
@@ -1805,7 +1805,7 @@ static long f2fs_fallocate(struct file *file, int mode,
 		return -EOPNOTSUPP;
 
 	/*
-	 * Pinned file should not support partial trucation since the block
+	 * Pinned file should not support partial truncation since the block
 	 * can be used by applications.
 	 */
 	if ((f2fs_compressed_file(inode) || f2fs_is_pinned_file(inode)) &&
@@ -1855,7 +1855,7 @@ static long f2fs_fallocate(struct file *file, int mode,
 static int f2fs_release_file(struct inode *inode, struct file *filp)
 {
 	/*
-	 * f2fs_relase_file is called at every close calls. So we should
+	 * f2fs_release_file is called at every close calls. So we should
 	 * not drop any inmemory pages by close called by other process.
 	 */
 	if (!(filp->f_mode & FMODE_WRITE) ||
diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 328cd20b16a54..6dcc73ca32172 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -970,7 +970,7 @@ static int f2fs_rename(struct user_namespace *mnt_userns, struct inode *old_dir,
 
 	/*
 	 * If new_inode is null, the below renaming flow will
-	 * add a link in old_dir which can conver inline_dir.
+	 * add a link in old_dir which can convert inline_dir.
 	 * After then, if we failed to get the entry due to other
 	 * reasons like ENOMEM, we had to remove the new entry.
 	 * Instead of adding such the error handling routine, let's
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 205216c1db91f..e19b569d938d8 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -3615,7 +3615,7 @@ void f2fs_wait_on_page_writeback(struct page *page,
 
 		/* submit cached LFS IO */
 		f2fs_submit_merged_write_cond(sbi, NULL, page, 0, type);
-		/* sbumit cached IPU IO */
+		/* submit cached IPU IO */
 		f2fs_submit_merged_ipu_write(sbi, NULL, page);
 		if (ordered) {
 			wait_on_page_writeback(page);
-- 
2.43.0



