Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 192241EEF8;
	Thu, 13 Jun 2024 12:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282203; cv=none; b=JKZMDh7y4hFPCFRdp4NG95tnJyc8hC6WEoIJNo4YwsNVJ9MkHg9hcXA4AcqagBefLYEwJUFUZXh+Mr1/RFVzX0IGsEq+k4iPPIHRZf/4SwwLbSMF+2ETXw3k47Im6A6spmg6UdDs4bTPeVApgRnejHUdFNcDpkGjXgRU7swc5BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282203; c=relaxed/simple;
	bh=cK3BptSmGQKKDKbs7X8b+3j2vI19ibgqHbw7bCgT5OU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eIZU+3Lirjesacq9nRpKjZftixkqt7I39Yhwqcq754J3XLvrG/LAd8nPVFmqUig8jzxDCJBqSVjZocISYY/t8KfhXJ6Ui7bIhGDdoe4w6Rz33qcp5hn3cfyth0yOEEvbbOBOngL4Tbu2qLdiP3unY0ABt/ML5x3bWkL03j5Xe4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rR/6TsJj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rR/6TsJj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53D76C2BBFC;
	Thu, 13 Jun 2024 12:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282202;
	bh=cK3BptSmGQKKDKbs7X8b+3j2vI19ibgqHbw7bCgT5OU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rR/6TsJjWWfVbRlnRW3RtBj0JXe1aWDdkKo0fylCpjD3oFpoZ7jr8I+J/ercc3IbJ
	 ZIau6UkZVT+XUxa8KMqwgrcyuXBcXlrKsARWCo/5UAo4ZF7/4QVgD8G95TbUtZvNQo
	 v3En1/3/4fastDO9oOYNdR7v+ZmC/0q7mgIVy3do=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinyoung Choi <j-young.choi@samsung.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 198/402] f2fs: fix typos in comments
Date: Thu, 13 Jun 2024 13:32:35 +0200
Message-ID: <20240613113309.863530615@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 7d3e7418d8fd5..71a3714419f85 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -792,7 +792,7 @@ static void write_orphan_inodes(struct f2fs_sb_info *sbi, block_t start_blk)
 	 */
 	head = &im->ino_list;
 
-	/* loop for each orphan inode entry and write them in Jornal block */
+	/* loop for each orphan inode entry and write them in journal block */
 	list_for_each_entry(orphan, head, list) {
 		if (!page) {
 			page = f2fs_grab_meta_page(sbi, start_blk++);
@@ -1124,7 +1124,7 @@ int f2fs_sync_dirty_inodes(struct f2fs_sb_info *sbi, enum inode_type type,
 	} else {
 		/*
 		 * We should submit bio, since it exists several
-		 * wribacking dentry pages in the freeing inode.
+		 * writebacking dentry pages in the freeing inode.
 		 */
 		f2fs_submit_merged_write(sbi, DATA);
 		cond_resched();
diff --git a/fs/f2fs/compress.c b/fs/f2fs/compress.c
index 88799c6ebd7de..be46dc41523b4 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -1247,7 +1247,7 @@ static int f2fs_write_compressed_pages(struct compress_ctx *cc,
 	loff_t psize;
 	int i, err;
 
-	/* we should bypass data pages to proceed the kworkder jobs */
+	/* we should bypass data pages to proceed the kworker jobs */
 	if (unlikely(f2fs_cp_error(sbi))) {
 		mapping_set_error(cc->rpages[0]->mapping, -EIO);
 		goto out_free;
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index a8e99da8edc1f..fa86eaf1d6393 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2412,7 +2412,7 @@ static int f2fs_mpage_readpages(struct inode *inode,
 
 #ifdef CONFIG_F2FS_FS_COMPRESSION
 		if (f2fs_compressed_file(inode)) {
-			/* there are remained comressed pages, submit them */
+			/* there are remained compressed pages, submit them */
 			if (!f2fs_cluster_can_merge_page(&cc, page->index)) {
 				ret = f2fs_read_multi_pages(&cc, &bio,
 							max_nr_pages,
@@ -2811,7 +2811,7 @@ int f2fs_write_single_data_page(struct page *page, int *submitted,
 
 	trace_f2fs_writepage(page, DATA);
 
-	/* we should bypass data pages to proceed the kworkder jobs */
+	/* we should bypass data pages to proceed the kworker jobs */
 	if (unlikely(f2fs_cp_error(sbi))) {
 		mapping_set_error(page->mapping, -EIO);
 		/*
@@ -2938,7 +2938,7 @@ int f2fs_write_single_data_page(struct page *page, int *submitted,
 redirty_out:
 	redirty_page_for_writepage(wbc, page);
 	/*
-	 * pageout() in MM traslates EAGAIN, so calls handle_write_error()
+	 * pageout() in MM translates EAGAIN, so calls handle_write_error()
 	 * -> mapping_set_error() -> set_bit(AS_EIO, ...).
 	 * file_write_and_wait_range() will see EIO error, which is critical
 	 * to return value of fsync() followed by atomic_write failure to user.
@@ -2972,7 +2972,7 @@ static int f2fs_write_data_page(struct page *page,
 }
 
 /*
- * This function was copied from write_cche_pages from mm/page-writeback.c.
+ * This function was copied from write_cache_pages from mm/page-writeback.c.
  * The major change is making write step of cold data page separately from
  * warm/hot data page.
  */
diff --git a/fs/f2fs/extent_cache.c b/fs/f2fs/extent_cache.c
index 6a9ab5c11939f..30b8924d1493d 100644
--- a/fs/f2fs/extent_cache.c
+++ b/fs/f2fs/extent_cache.c
@@ -112,7 +112,7 @@ struct rb_node **f2fs_lookup_rb_tree_for_insert(struct f2fs_sb_info *sbi,
  * @prev_ex: extent before ofs
  * @next_ex: extent after ofs
  * @insert_p: insert point for new extent at ofs
- * in order to simpfy the insertion after.
+ * in order to simplify the insertion after.
  * tree must stay unchanged between lookup and insertion.
  */
 struct rb_entry *f2fs_lookup_rb_tree_ret(struct rb_root_cached *root,
@@ -573,7 +573,7 @@ static void f2fs_update_extent_tree_range(struct inode *inode,
 	if (!en)
 		en = next_en;
 
-	/* 2. invlidate all extent nodes in range [fofs, fofs + len - 1] */
+	/* 2. invalidate all extent nodes in range [fofs, fofs + len - 1] */
 	while (en && en->ei.fofs < end) {
 		unsigned int org_end;
 		int parts = 0;	/* # of parts current extent split into */
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 959e1458412df..ffec3c5374f89 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -304,7 +304,7 @@ static int f2fs_do_sync_file(struct file *file, loff_t start, loff_t end,
 		 * for OPU case, during fsync(), node can be persisted before
 		 * data when lower device doesn't support write barrier, result
 		 * in data corruption after SPO.
-		 * So for strict fsync mode, force to use atomic write sematics
+		 * So for strict fsync mode, force to use atomic write semantics
 		 * to keep write order in between data/node and last node to
 		 * avoid potential data corruption.
 		 */
@@ -1761,7 +1761,7 @@ static long f2fs_fallocate(struct file *file, int mode,
 		return -EOPNOTSUPP;
 
 	/*
-	 * Pinned file should not support partial trucation since the block
+	 * Pinned file should not support partial truncation since the block
 	 * can be used by applications.
 	 */
 	if ((f2fs_compressed_file(inode) || f2fs_is_pinned_file(inode)) &&
@@ -1811,7 +1811,7 @@ static long f2fs_fallocate(struct file *file, int mode,
 static int f2fs_release_file(struct inode *inode, struct file *filp)
 {
 	/*
-	 * f2fs_relase_file is called at every close calls. So we should
+	 * f2fs_release_file is called at every close calls. So we should
 	 * not drop any inmemory pages by close called by other process.
 	 */
 	if (!(filp->f_mode & FMODE_WRITE) ||
diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 0d6906644feb7..80bc386ec6980 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -959,7 +959,7 @@ static int f2fs_rename(struct inode *old_dir, struct dentry *old_dentry,
 
 	/*
 	 * If new_inode is null, the below renaming flow will
-	 * add a link in old_dir which can conver inline_dir.
+	 * add a link in old_dir which can convert inline_dir.
 	 * After then, if we failed to get the entry due to other
 	 * reasons like ENOMEM, we had to remove the new entry.
 	 * Instead of adding such the error handling routine, let's
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index b454496ca67a1..1c69dc91c3292 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -3772,7 +3772,7 @@ void f2fs_wait_on_page_writeback(struct page *page,
 
 		/* submit cached LFS IO */
 		f2fs_submit_merged_write_cond(sbi, NULL, page, 0, type);
-		/* sbumit cached IPU IO */
+		/* submit cached IPU IO */
 		f2fs_submit_merged_ipu_write(sbi, NULL, page);
 		if (ordered) {
 			wait_on_page_writeback(page);
-- 
2.43.0



