Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 009E446C82A;
	Thu, 20 Aug 2026 17:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248567; cv=none; b=g8eV6cDoFh874+ZoXOHQTq4OyxFP+0d17CHhJXxrjyl4mZzGKXNFTzkiwR+R5zvHgLkO3kr9ttu2uMq7XoH8ZWD4OXDbUitioiY8PuzWK3J1JQoE1zzUt1wIetL69UrCjsBgbsB8qLKcOg3Awzg64srZgU23DnIV+qlK9XMcTMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248567; c=relaxed/simple;
	bh=8p9vddHUE8zx53pcmnocpdTDoBChdt2T/j9Mb/sxl94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IdAzLSoqEGdIYAlJvdIh9FcolwE2uJrllU6vXu5zjTKrH6W+Yp8X3+kaCqDJIg2bJLhpST3w04PSnm3tV8urK3zBTnRlnu3BpwS1TKOKXXb5Ci0Vx07TUQPm05eW4i0W7e0BAYjwlHB1JUbn7CD3ZTcnMg/RV79RL83BnGkYsbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kVM6l1Fx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kVM6l1Fx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CF6A1F000E9;
	Thu, 20 Aug 2026 17:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248565;
	bh=QlzSUirRyHgBqzW2Yf09+kI7pn5bekP0vhSi42OxlEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kVM6l1FxuBwpBYyUc7vNbIkY9Rw1g26lynHQ0mfOM+v6g5dyd+gKUwLUv5wiM0gZy
	 ZzYKS4pFHyseqVEJKPuAZ1Y6fXCUnU0TgXhRbHmZ+7PKRP+HaIbfXUo3jLV9nN0/65
	 KFW9j3ewBxQO4zAYY+epqSBwY0qVB8rSM1nJWfq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yue Hu <huyue2@coolpad.com>,
	Jingbo Xu <jefflexu@linux.alibaba.com>,
	Chao Yu <chao@kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 233/303] erofs: tidy up internal.h
Date: Thu, 20 Aug 2026 16:56:09 +0200
Message-ID: <20260820145300.453341746@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit 557afdd94cf853885ac3b5c218bdf49c021f7323 ]

Reorder internal.h code so that removing unneeded macros and more.
No logic changes.

Reviewed-by: Yue Hu <huyue2@coolpad.com>
Reviewed-by: Jingbo Xu <jefflexu@linux.alibaba.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Link: https://lore.kernel.org/r/20230204093040.97967-6-hsiangkao@linux.alibaba.com
Stable-dep-of: c9b47e6b2311 ("erofs: cap LZMA stream pool size")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/erofs/internal.h |   83 +++++++++++++++++-----------------------------------
 1 file changed, 28 insertions(+), 55 deletions(-)

--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -364,12 +364,6 @@ struct page *erofs_grab_cache_page_nowai
 			readahead_gfp_mask(mapping) & ~__GFP_RECLAIM);
 }
 
-extern const struct super_operations erofs_sops;
-extern struct file_system_type erofs_fs_type;
-
-extern const struct address_space_operations erofs_raw_access_aops;
-extern const struct address_space_operations z_erofs_aops;
-
 enum {
 	BH_Encoded = BH_PrivateStart,
 	BH_FullMapped,
@@ -401,7 +395,6 @@ struct erofs_map_blocks {
 	unsigned int m_flags;
 };
 
-/* Flags used by erofs_map_blocks_flatmode() */
 #define EROFS_GET_BLOCKS_RAW    0x0001
 /*
  * Used to get the exact decompressed length, e.g. fiemap (consider lookback
@@ -419,24 +412,6 @@ enum {
 	Z_EROFS_COMPRESSION_RUNTIME_MAX
 };
 
-/* zmap.c */
-extern const struct iomap_ops z_erofs_iomap_report_ops;
-
-#ifdef CONFIG_EROFS_FS_ZIP
-int z_erofs_fill_inode(struct inode *inode);
-int z_erofs_map_blocks_iter(struct inode *inode,
-			    struct erofs_map_blocks *map,
-			    int flags);
-#else
-static inline int z_erofs_fill_inode(struct inode *inode) { return -EOPNOTSUPP; }
-static inline int z_erofs_map_blocks_iter(struct inode *inode,
-					  struct erofs_map_blocks *map,
-					  int flags)
-{
-	return -EOPNOTSUPP;
-}
-#endif	/* !CONFIG_EROFS_FS_ZIP */
-
 struct erofs_map_dev {
 	struct erofs_fscache *m_fscache;
 	struct block_device *m_bdev;
@@ -447,8 +422,27 @@ struct erofs_map_dev {
 	unsigned int m_deviceid;
 };
 
-/* data.c */
+extern struct file_system_type erofs_fs_type;
+extern const struct super_operations erofs_sops;
+
+extern const struct address_space_operations erofs_raw_access_aops;
+extern const struct address_space_operations z_erofs_aops;
+extern const struct address_space_operations erofs_fscache_access_aops;
+
+extern const struct inode_operations erofs_generic_iops;
+extern const struct inode_operations erofs_symlink_iops;
+extern const struct inode_operations erofs_fast_symlink_iops;
+extern const struct inode_operations erofs_dir_iops;
+
 extern const struct file_operations erofs_file_fops;
+extern const struct file_operations erofs_dir_fops;
+
+extern const struct iomap_ops z_erofs_iomap_report_ops;
+
+/* flags for erofs_fscache_register_cookie() */
+#define EROFS_REG_COOKIE_NEED_INODE	1
+#define EROFS_REG_COOKIE_NEED_NOEXIST	2
+
 void *erofs_read_metadata(struct super_block *sb, struct erofs_buf *buf,
 			  erofs_off_t *offset, int *lengthp);
 void erofs_unmap_metabuf(struct erofs_buf *buf);
@@ -463,7 +457,6 @@ int erofs_fiemap(struct inode *inode, st
 int erofs_map_blocks(struct inode *inode,
 		     struct erofs_map_blocks *map, int flags);
 
-/* inode.c */
 static inline unsigned long erofs_inode_hash(erofs_nid_t nid)
 {
 #if BITS_PER_LONG == 32
@@ -473,24 +466,13 @@ static inline unsigned long erofs_inode_
 #endif
 }
 
-extern const struct inode_operations erofs_generic_iops;
-extern const struct inode_operations erofs_symlink_iops;
-extern const struct inode_operations erofs_fast_symlink_iops;
-
 struct inode *erofs_iget(struct super_block *sb, erofs_nid_t nid);
 int erofs_getattr(struct user_namespace *mnt_userns, const struct path *path,
 		  struct kstat *stat, u32 request_mask,
 		  unsigned int query_flags);
-
-/* namei.c */
-extern const struct inode_operations erofs_dir_iops;
-
 int erofs_namei(struct inode *dir, const struct qstr *name,
 		erofs_nid_t *nid, unsigned int *d_type);
 
-/* dir.c */
-extern const struct file_operations erofs_dir_fops;
-
 static inline void *erofs_vm_map_ram(struct page **pages, unsigned int count)
 {
 	int retried = 0;
@@ -506,23 +488,19 @@ static inline void *erofs_vm_map_ram(str
 	return NULL;
 }
 
-/* pcpubuf.c */
 void *erofs_get_pcpubuf(unsigned int requiredpages);
 void erofs_put_pcpubuf(void *ptr);
 int erofs_pcpubuf_growsize(unsigned int nrpages);
 void erofs_pcpubuf_init(void);
 void erofs_pcpubuf_exit(void);
 
-/* sysfs.c */
 int erofs_register_sysfs(struct super_block *sb);
 void erofs_unregister_sysfs(struct super_block *sb);
 int __init erofs_init_sysfs(void);
 void erofs_exit_sysfs(void);
 
-/* utils.c / zdata.c */
 struct page *erofs_allocpage(struct page **pagepool, gfp_t gfp);
-static inline void erofs_pagepool_add(struct page **pagepool,
-		struct page *page)
+static inline void erofs_pagepool_add(struct page **pagepool, struct page *page)
 {
 	set_page_private(page, (unsigned long)*pagepool);
 	*pagepool = page;
@@ -546,6 +524,9 @@ int erofs_try_to_free_all_cached_pages(s
 				       struct erofs_workgroup *egrp);
 int erofs_try_to_free_cached_page(struct page *page);
 int z_erofs_parse_cfgs(struct super_block *sb, struct erofs_super_block *dsb);
+int z_erofs_fill_inode(struct inode *inode);
+int z_erofs_map_blocks_iter(struct inode *inode, struct erofs_map_blocks *map,
+			    int flags);
 #else
 static inline void erofs_shrinker_register(struct super_block *sb) {}
 static inline void erofs_shrinker_unregister(struct super_block *sb) {}
@@ -553,6 +534,7 @@ static inline int erofs_init_shrinker(vo
 static inline void erofs_exit_shrinker(void) {}
 static inline int z_erofs_init_zip_subsystem(void) { return 0; }
 static inline void z_erofs_exit_zip_subsystem(void) {}
+static inline int z_erofs_fill_inode(struct inode *inode) { return -EOPNOTSUPP; }
 #endif	/* !CONFIG_EROFS_FS_ZIP */
 
 #ifdef CONFIG_EROFS_FS_ZIP_LZMA
@@ -561,23 +543,15 @@ void z_erofs_lzma_exit(void);
 #else
 static inline int z_erofs_lzma_init(void) { return 0; }
 static inline int z_erofs_lzma_exit(void) { return 0; }
-#endif	/* !CONFIG_EROFS_FS_ZIP */
+#endif	/* !CONFIG_EROFS_FS_ZIP_LZMA */
 
-/* flags for erofs_fscache_register_cookie() */
-#define EROFS_REG_COOKIE_NEED_INODE	1
-#define EROFS_REG_COOKIE_NEED_NOEXIST	2
-
-/* fscache.c */
 #ifdef CONFIG_EROFS_FS_ONDEMAND
 int erofs_fscache_register_fs(struct super_block *sb);
 void erofs_fscache_unregister_fs(struct super_block *sb);
 
 struct erofs_fscache *erofs_fscache_register_cookie(struct super_block *sb,
-						    char *name,
-						    unsigned int flags);
+					char *name, unsigned int flags);
 void erofs_fscache_unregister_cookie(struct erofs_fscache *fscache);
-
-extern const struct address_space_operations erofs_fscache_access_aops;
 #else
 static inline int erofs_fscache_register_fs(struct super_block *sb)
 {
@@ -587,8 +561,7 @@ static inline void erofs_fscache_unregis
 
 static inline
 struct erofs_fscache *erofs_fscache_register_cookie(struct super_block *sb,
-						     char *name,
-						     unsigned int flags)
+					char *name, unsigned int flags)
 {
 	return ERR_PTR(-EOPNOTSUPP);
 }


