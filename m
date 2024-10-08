Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875E61DFE22;
	Tue,  8 Oct 2024 13:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728394244; cv=none; b=ATvhtZqXhTKBKWC1u4YVYZwhN77luc/FMSR7czync3WduVfQOdGl6CzkW1oz8P/RyjlfCMlrL9RoLXihr8LOyO/wm1j+hRkQIJ8QhfUF3yJUJqH2JpyIjqCFoOFwhvjbwfOMQo5iasV/CU7qUTg4+1kdhwu/RpGiVnWzoxCllHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728394244; c=relaxed/simple;
	bh=ljWHwubegF5XL6j3VpmVJomwbswEXE5ou+m70oi1whw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BL35zM8jJZlcPLl/7nDUnroAud4UJeDWY6Cq98NUNc1/7GmpqNK+sYv8asJts3q8vV7heSNGZ4zcPQ2LyxwrCM4D3cNWjUc8ekECOLlXnEtokHhrZLC7gftIFnF6Ewy62Et33tQ9p6JxiCsA5sdksvsL4EGRtOUKyd10Vn3x+KY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vQIwQ0YF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vQIwQ0YF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0E49C4CECC;
	Tue,  8 Oct 2024 13:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728394244;
	bh=ljWHwubegF5XL6j3VpmVJomwbswEXE5ou+m70oi1whw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vQIwQ0YFGwOflAE17kJ/CjwlKz1I4hJZJFYnh6Ztfvrln86TVu3M44YzIkCcAIUrz
	 eZlksA+W94aAKixZEeEBXkB9XeiLJc5yrPCslg53ByKfcZUbsxKJSo7Kxi1rCphh/e
	 Ttwno1P78aEC7NA/q6GaNSwbQKohX4GuFrY/huz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 364/386] btrfs: relocation: constify parameters where possible
Date: Tue,  8 Oct 2024 14:10:09 +0200
Message-ID: <20241008115643.707741397@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

From: David Sterba <dsterba@suse.com>

[ Upstream commit ab7c8bbf3a088730e58da224bcad512f1dd9ca74 ]

Lots of the functions in relocation.c don't change pointer parameters
but lack the annotations. Add them and reformat according to current
coding style if needed.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: db7e68b522c0 ("btrfs: drop the backref cache during relocation if we commit")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/relocation.c | 56 +++++++++++++++++++++----------------------
 fs/btrfs/relocation.h |  9 +++----
 2 files changed, 33 insertions(+), 32 deletions(-)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 1f4fd6c86fb00..6e590da98742b 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -299,7 +299,7 @@ static int update_backref_cache(struct btrfs_trans_handle *trans,
 	return 1;
 }
 
-static bool reloc_root_is_dead(struct btrfs_root *root)
+static bool reloc_root_is_dead(const struct btrfs_root *root)
 {
 	/*
 	 * Pair with set_bit/clear_bit in clean_dirty_subvols and
@@ -320,7 +320,7 @@ static bool reloc_root_is_dead(struct btrfs_root *root)
  * from no reloc root.  But btrfs_should_ignore_reloc_root() below is a
  * special case.
  */
-static bool have_reloc_root(struct btrfs_root *root)
+static bool have_reloc_root(const struct btrfs_root *root)
 {
 	if (reloc_root_is_dead(root))
 		return false;
@@ -329,7 +329,7 @@ static bool have_reloc_root(struct btrfs_root *root)
 	return true;
 }
 
-bool btrfs_should_ignore_reloc_root(struct btrfs_root *root)
+bool btrfs_should_ignore_reloc_root(const struct btrfs_root *root)
 {
 	struct btrfs_root *reloc_root;
 
@@ -546,7 +546,7 @@ static noinline_for_stack struct btrfs_backref_node *build_backref_tree(
  */
 static int clone_backref_node(struct btrfs_trans_handle *trans,
 			      struct reloc_control *rc,
-			      struct btrfs_root *src,
+			      const struct btrfs_root *src,
 			      struct btrfs_root *dest)
 {
 	struct btrfs_root *reloc_root = src->reloc_root;
@@ -1186,9 +1186,9 @@ int replace_file_extents(struct btrfs_trans_handle *trans,
 	return ret;
 }
 
-static noinline_for_stack
-int memcmp_node_keys(struct extent_buffer *eb, int slot,
-		     struct btrfs_path *path, int level)
+static noinline_for_stack int memcmp_node_keys(const struct extent_buffer *eb,
+					       int slot, const struct btrfs_path *path,
+					       int level)
 {
 	struct btrfs_disk_key key1;
 	struct btrfs_disk_key key2;
@@ -1517,8 +1517,8 @@ int walk_down_reloc_tree(struct btrfs_root *root, struct btrfs_path *path,
  * [min_key, max_key)
  */
 static int invalidate_extent_cache(struct btrfs_root *root,
-				   struct btrfs_key *min_key,
-				   struct btrfs_key *max_key)
+				   const struct btrfs_key *min_key,
+				   const struct btrfs_key *max_key)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct inode *inode = NULL;
@@ -2829,7 +2829,7 @@ int relocate_tree_blocks(struct btrfs_trans_handle *trans,
 
 static noinline_for_stack int prealloc_file_extent_cluster(
 				struct btrfs_inode *inode,
-				struct file_extent_cluster *cluster)
+				const struct file_extent_cluster *cluster)
 {
 	u64 alloc_hint = 0;
 	u64 start;
@@ -2964,7 +2964,7 @@ static noinline_for_stack int setup_relocation_extent_mapping(struct inode *inod
 /*
  * Allow error injection to test balance/relocation cancellation
  */
-noinline int btrfs_should_cancel_balance(struct btrfs_fs_info *fs_info)
+noinline int btrfs_should_cancel_balance(const struct btrfs_fs_info *fs_info)
 {
 	return atomic_read(&fs_info->balance_cancel_req) ||
 		atomic_read(&fs_info->reloc_cancel_req) ||
@@ -2972,7 +2972,7 @@ noinline int btrfs_should_cancel_balance(struct btrfs_fs_info *fs_info)
 }
 ALLOW_ERROR_INJECTION(btrfs_should_cancel_balance, TRUE);
 
-static u64 get_cluster_boundary_end(struct file_extent_cluster *cluster,
+static u64 get_cluster_boundary_end(const struct file_extent_cluster *cluster,
 				    int cluster_nr)
 {
 	/* Last extent, use cluster end directly */
@@ -2984,7 +2984,7 @@ static u64 get_cluster_boundary_end(struct file_extent_cluster *cluster,
 }
 
 static int relocate_one_page(struct inode *inode, struct file_ra_state *ra,
-			     struct file_extent_cluster *cluster,
+			     const struct file_extent_cluster *cluster,
 			     int *cluster_nr, unsigned long page_index)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
@@ -3119,7 +3119,7 @@ static int relocate_one_page(struct inode *inode, struct file_ra_state *ra,
 }
 
 static int relocate_file_extent_cluster(struct inode *inode,
-					struct file_extent_cluster *cluster)
+					const struct file_extent_cluster *cluster)
 {
 	u64 offset = BTRFS_I(inode)->index_cnt;
 	unsigned long index;
@@ -3157,9 +3157,9 @@ static int relocate_file_extent_cluster(struct inode *inode,
 	return ret;
 }
 
-static noinline_for_stack
-int relocate_data_extent(struct inode *inode, struct btrfs_key *extent_key,
-			 struct file_extent_cluster *cluster)
+static noinline_for_stack int relocate_data_extent(struct inode *inode,
+				const struct btrfs_key *extent_key,
+				struct file_extent_cluster *cluster)
 {
 	int ret;
 
@@ -3192,7 +3192,7 @@ int relocate_data_extent(struct inode *inode, struct btrfs_key *extent_key,
  * the major work is getting the generation and level of the block
  */
 static int add_tree_block(struct reloc_control *rc,
-			  struct btrfs_key *extent_key,
+			  const struct btrfs_key *extent_key,
 			  struct btrfs_path *path,
 			  struct rb_root *blocks)
 {
@@ -3443,11 +3443,10 @@ static int delete_v1_space_cache(struct extent_buffer *leaf,
 /*
  * helper to find all tree blocks that reference a given data extent
  */
-static noinline_for_stack
-int add_data_references(struct reloc_control *rc,
-			struct btrfs_key *extent_key,
-			struct btrfs_path *path,
-			struct rb_root *blocks)
+static noinline_for_stack int add_data_references(struct reloc_control *rc,
+						  const struct btrfs_key *extent_key,
+						  struct btrfs_path *path,
+						  struct rb_root *blocks)
 {
 	struct btrfs_backref_walk_ctx ctx = { 0 };
 	struct ulist_iterator leaf_uiter;
@@ -3873,9 +3872,9 @@ static void delete_orphan_inode(struct btrfs_trans_handle *trans,
  * helper to create inode for data relocation.
  * the inode is in data relocation tree and its link count is 0
  */
-static noinline_for_stack
-struct inode *create_reloc_inode(struct btrfs_fs_info *fs_info,
-				 struct btrfs_block_group *group)
+static noinline_for_stack struct inode *create_reloc_inode(
+					struct btrfs_fs_info *fs_info,
+					const struct btrfs_block_group *group)
 {
 	struct inode *inode = NULL;
 	struct btrfs_trans_handle *trans;
@@ -4421,7 +4420,8 @@ int btrfs_reloc_clone_csums(struct btrfs_ordered_extent *ordered)
 }
 
 int btrfs_reloc_cow_block(struct btrfs_trans_handle *trans,
-			  struct btrfs_root *root, struct extent_buffer *buf,
+			  struct btrfs_root *root,
+			  const struct extent_buffer *buf,
 			  struct extent_buffer *cow)
 {
 	struct btrfs_fs_info *fs_info = root->fs_info;
@@ -4560,7 +4560,7 @@ int btrfs_reloc_post_snapshot(struct btrfs_trans_handle *trans,
  *
  * Return U64_MAX if no running relocation.
  */
-u64 btrfs_get_reloc_bg_bytenr(struct btrfs_fs_info *fs_info)
+u64 btrfs_get_reloc_bg_bytenr(const struct btrfs_fs_info *fs_info)
 {
 	u64 logical = U64_MAX;
 
diff --git a/fs/btrfs/relocation.h b/fs/btrfs/relocation.h
index af749c780b4e7..5fb60f2deb530 100644
--- a/fs/btrfs/relocation.h
+++ b/fs/btrfs/relocation.h
@@ -10,15 +10,16 @@ int btrfs_update_reloc_root(struct btrfs_trans_handle *trans,
 int btrfs_recover_relocation(struct btrfs_fs_info *fs_info);
 int btrfs_reloc_clone_csums(struct btrfs_ordered_extent *ordered);
 int btrfs_reloc_cow_block(struct btrfs_trans_handle *trans,
-			  struct btrfs_root *root, struct extent_buffer *buf,
+			  struct btrfs_root *root,
+			  const struct extent_buffer *buf,
 			  struct extent_buffer *cow);
 void btrfs_reloc_pre_snapshot(struct btrfs_pending_snapshot *pending,
 			      u64 *bytes_to_reserve);
 int btrfs_reloc_post_snapshot(struct btrfs_trans_handle *trans,
 			      struct btrfs_pending_snapshot *pending);
-int btrfs_should_cancel_balance(struct btrfs_fs_info *fs_info);
+int btrfs_should_cancel_balance(const struct btrfs_fs_info *fs_info);
 struct btrfs_root *find_reloc_root(struct btrfs_fs_info *fs_info, u64 bytenr);
-bool btrfs_should_ignore_reloc_root(struct btrfs_root *root);
-u64 btrfs_get_reloc_bg_bytenr(struct btrfs_fs_info *fs_info);
+bool btrfs_should_ignore_reloc_root(const struct btrfs_root *root);
+u64 btrfs_get_reloc_bg_bytenr(const struct btrfs_fs_info *fs_info);
 
 #endif
-- 
2.43.0



