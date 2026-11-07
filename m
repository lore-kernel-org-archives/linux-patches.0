Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065182;
	b=SBOInWrsboftKpEiJedjjOrls4ehfjlrm6QpS0BNJQDvx3+5JoVmij9uvkxn16iJX5M+
	 g9f6BWGFQd697WcKVBNudVQvnSaNFw+/SRIH6UWKQAw9vOu9CwfMPeyiELfKuXQ9HojbF
	 UkkOdDyYPx/Z7bXXRtYtDu9K9XsjpuvcaJXlwGLVgAA9ePLLt8B/60CdIxSuu0rzRQKJq
	 rBv6mpqLHEPLjuJkzi2hGLpoF0s5U0/TmjwHEdW1R+2GZi0ILJME37TfH1l7uix7VucEl
	 fs+m0PxFclwErVrrzSGv4haB7CPp6jpm3MRzDmLpID1pkKkhOKxUWXTFkgfI5pLNfjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065182;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VpydYDG9gOzpFnk78MnTgV2T97DpmyUIEgkCHHaQsNg=;
	b=LdA2RZsrz/nfI3HnvkX4NRTE4tuR3Ljn2EF65LzF5v8fe4PeVflD4h1Rf/9nyZC56m8l
	 fT+s418Qf3qUCUh6bxaYcnahvWrQOBearvedrvZt5moerq1DN8+cK2aJw9sQonRpPwomg
	 4uMmCwNc5KA3RKsmGPG9F1aR2XcM2YMtKusRo+x3BSea9yWOGllWUEFXnyfQHW/KVoqUv
	 eXMvS9gznm55lktEQ5FSaNkuulnBz/fK+PBDcdzgwuG6Xq5fyi9ZgKWOxO5l9ih1ixxae
	 Zlm2KwzK2rzI2Vi6dN11KNsvqSCSW92/VS47QJVlWXu4DWY8NdPZbhtDsM84zTq4v4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="IlR/6EY+";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D373B606A331;
	Sat,  7 Nov 2026 15:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IlR/6EY+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D74681F0089F;
	Sat,  7 Nov 2026 15:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065181;
	bh=VpydYDG9gOzpFnk78MnTgV2T97DpmyUIEgkCHHaQsNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IlR/6EY+DvNB2el9GmPr/MJKu6XcRKGFmkMbt6UeAlwM0Gnd74y0JruiYS5YZQQuW
	 mYG+lMFxs9FkmlZzS8Vfoo+yve3TUMQqu54RlwEA92Ii7W33eLVWLyeSMOhHiDy6jM
	 2KaGXwltJjOUZPTqMuDs9ks5o3gEVe6cSUseBYA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chi Zhiling <chizhiling@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0986/1257] exfat: make valid_size and zeroed_size atomic
Date: Sat,  7 Nov 2026 08:54:42 -0500
Message-ID: <20261107135006.595759751@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chi Zhiling <chizhiling@kylinos.cn>

[ Upstream commit 6bb112f5d90a78461648e3bd89093ea299196be5 ]

ei->valid_size and ei->zeroed_size are 64-bit fields read from bio
completion context (exfat_iomap_read_end_io()) and from ->iomap_begin
without i_rwsem, while writers update them under i_rwsem.  On 32-bit
these loads can tear, and the "if (x < new) x = new" read-modify-write
can lose an update or regress the value when two writers race.

Convert both to atomic64_t and funnel updates through a cmpxchg-based
monotonic advance helper so the value only moves forward; plain reads use
exfat_get_*(), and the few shrink/init paths (truncate, inode fill,
create) use exfat_set_*().  This is a prerequisite for taking
exfat_page_mkwrite() out from under i_rwsem.

Fixes: 82a81a7352bc ("exfat: add iomap buffered I/O support")
Cc: stable@vger.kernel.org
Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/exfat_fs.h | 60 +++++++++++++++++++++++++++++++++++++++++++--
 fs/exfat/file.c     | 32 +++++++++++++-----------
 fs/exfat/inode.c    | 16 ++++++------
 fs/exfat/iomap.c    | 20 +++++++--------
 fs/exfat/namei.c    |  4 +--
 5 files changed, 96 insertions(+), 36 deletions(-)

diff --git a/fs/exfat/exfat_fs.h b/fs/exfat/exfat_fs.h
index a9131fe03302e..249aa59288631 100644
--- a/fs/exfat/exfat_fs.h
+++ b/fs/exfat/exfat_fs.h
@@ -7,6 +7,7 @@
 #define _EXFAT_FS_H
 
 #include <linux/fs.h>
+#include <linux/atomic.h>
 #include <linux/ratelimit.h>
 #include <linux/nls.h>
 #include <linux/blkdev.h>
@@ -293,9 +294,16 @@ struct exfat_inode_info {
 
 	/* on-disk position of directory entry or 0 */
 	loff_t i_pos;
-	loff_t valid_size;
+	/*
+	 * valid_size and zeroed_size are updated from multiple contexts that
+	 * are not serialised against each other (page_mkwrite runs without
+	 * i_rwsem, while buffered/DIO writes advance them under i_rwsem).  Keep
+	 * them atomic and only ever advance them with a cmpxchg loop so a
+	 * concurrent update can never regress the value or tear on 32-bit.
+	 */
+	atomic64_t valid_size;
 	/* block-aligned size zeroed in the page cache (>= valid_size) */
-	loff_t zeroed_size;
+	atomic64_t zeroed_size;
 	/* hash by i_location */
 	struct hlist_node i_hash_fat;
 	struct inode vfs_inode;
@@ -313,6 +321,54 @@ static inline struct exfat_inode_info *EXFAT_I(struct inode *inode)
 	return container_of(inode, struct exfat_inode_info, vfs_inode);
 }
 
+static inline loff_t exfat_get_valid_size(struct exfat_inode_info *ei)
+{
+	return atomic64_read(&ei->valid_size);
+}
+
+static inline loff_t exfat_get_zeroed_size(struct exfat_inode_info *ei)
+{
+	return atomic64_read(&ei->zeroed_size);
+}
+
+static inline void exfat_set_valid_size(struct exfat_inode_info *ei, loff_t v)
+{
+	atomic64_set(&ei->valid_size, v);
+}
+
+static inline void exfat_set_zeroed_size(struct exfat_inode_info *ei, loff_t v)
+{
+	atomic64_set(&ei->zeroed_size, v);
+}
+
+/*
+ * Monotonically advance @v to at least @new. Returns true if the value was
+ * actually raised, so callers can decide whether to mark the inode dirty.
+ */
+static inline bool exfat_size_advance(atomic64_t *v, loff_t new)
+{
+	loff_t old = atomic64_read(v);
+
+	do {
+		if (old >= new)
+			return false;
+	} while (!atomic64_try_cmpxchg(v, &old, new));
+
+	return true;
+}
+
+static inline bool exfat_advance_valid_size(struct exfat_inode_info *ei,
+		loff_t new)
+{
+	return exfat_size_advance(&ei->valid_size, new);
+}
+
+static inline bool exfat_advance_zeroed_size(struct exfat_inode_info *ei,
+		loff_t new)
+{
+	return exfat_size_advance(&ei->zeroed_size, new);
+}
+
 static inline int exfat_forced_shutdown(struct super_block *sb)
 {
 	return test_bit(EXFAT_FLAGS_SHUTDOWN, &EXFAT_SB(sb)->s_exfat_flags);
diff --git a/fs/exfat/file.c b/fs/exfat/file.c
index 8b551bb83676e..89e2fdebcc2c1 100644
--- a/fs/exfat/file.c
+++ b/fs/exfat/file.c
@@ -247,8 +247,10 @@ int __exfat_truncate(struct inode *inode)
 		ei->start_clu = EXFAT_EOF_CLUSTER;
 	}
 
-	if (i_size_read(inode) < ei->valid_size)
-		ei->valid_size = ei->zeroed_size = i_size_read(inode);
+	if (i_size_read(inode) < exfat_get_valid_size(ei)) {
+		exfat_set_valid_size(ei, i_size_read(inode));
+		exfat_set_zeroed_size(ei, i_size_read(inode));
+	}
 
 	if (ei->type == TYPE_FILE)
 		ei->attr |= EXFAT_ATTR_ARCHIVE;
@@ -700,12 +702,12 @@ static int exfat_prepare_valid_range(struct inode *inode, loff_t start,
 static int exfat_extend_valid_size(struct inode *inode, loff_t new_valid_size)
 {
 	struct exfat_inode_info *ei = EXFAT_I(inode);
-	loff_t old_valid_size = ei->valid_size;
+	loff_t old_valid_size = exfat_get_valid_size(ei);
 	int ret = 0;
 
 	if (old_valid_size < new_valid_size) {
 		/* Do not re-zero blocks already covered by zeroed_size. */
-		loff_t gap_start = max(old_valid_size, ei->zeroed_size);
+		loff_t gap_start = max(old_valid_size, exfat_get_zeroed_size(ei));
 
 		if (i_size_read(inode) < new_valid_size) {
 			/*
@@ -737,9 +739,9 @@ static int exfat_extend_valid_size(struct inode *inode, loff_t new_valid_size)
 			return ret;
 		}
 
-		ei->valid_size = new_valid_size;
-		if (ei->zeroed_size < round_up(new_valid_size, i_blocksize(inode)))
-			ei->zeroed_size = round_up(new_valid_size, i_blocksize(inode));
+		exfat_set_valid_size(ei, new_valid_size);
+		exfat_advance_zeroed_size(ei,
+				round_up(new_valid_size, i_blocksize(inode)));
 		mark_inode_dirty(inode);
 	}
 
@@ -824,7 +826,7 @@ static ssize_t exfat_file_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 	if (pos > i_size_read(inode))
 		truncate_pagecache(inode, i_size_read(inode));
 
-	valid_size = ei->valid_size;
+	valid_size = exfat_get_valid_size(ei);
 	if (pos > valid_size) {
 		ret = exfat_extend_valid_size(inode, pos);
 		if (ret < 0 && ret != -ENOSPC) {
@@ -900,8 +902,10 @@ static vm_fault_t exfat_page_mkwrite(struct vm_fault *vmf)
 	fault_page_start = ((loff_t)vmf->pgoff) << PAGE_SHIFT;
 	new_valid_size = min(mmap_valid_size, i_size_read(inode));
 
-	if (ei->valid_size < new_valid_size) {
-		if (ei->zeroed_size < fault_page_start) {
+	if (exfat_get_valid_size(ei) < new_valid_size) {
+		loff_t zeroed_size = exfat_get_zeroed_size(ei);
+
+		if (zeroed_size < fault_page_start) {
 			int err;
 
 			/*
@@ -909,7 +913,7 @@ static vm_fault_t exfat_page_mkwrite(struct vm_fault *vmf)
 			 * fault populated its folio and iomap_page_mkwrite()
 			 * will dirty it.
 			 */
-			err = exfat_prepare_valid_range(inode, ei->zeroed_size,
+			err = exfat_prepare_valid_range(inode, zeroed_size,
 					fault_page_start);
 			if (err < 0) {
 				inode_unlock(inode);
@@ -922,9 +926,9 @@ static vm_fault_t exfat_page_mkwrite(struct vm_fault *vmf)
 		 * at i_size recording blocks wholly beyond it could skip a
 		 * later required zeroing.
 		 */
-		if (ei->zeroed_size < round_up(new_valid_size, i_blocksize(inode)))
-			ei->zeroed_size = round_up(new_valid_size, i_blocksize(inode));
-		ei->valid_size = new_valid_size;
+		exfat_advance_zeroed_size(ei,
+				round_up(new_valid_size, i_blocksize(inode)));
+		exfat_set_valid_size(ei, new_valid_size);
 		mark_inode_dirty(inode);
 	}
 
diff --git a/fs/exfat/inode.c b/fs/exfat/inode.c
index ccd13630187e1..5129df1e79b44 100644
--- a/fs/exfat/inode.c
+++ b/fs/exfat/inode.c
@@ -29,6 +29,7 @@ int __exfat_write_inode(struct inode *inode, int sync)
 	struct exfat_sb_info *sbi = EXFAT_SB(sb);
 	struct exfat_inode_info *ei = EXFAT_I(inode);
 	bool is_dir = (ei->type == TYPE_DIR);
+	loff_t valid_size = exfat_get_valid_size(ei);
 	struct timespec64 ts;
 
 	if (inode->i_ino == EXFAT_ROOT_INO)
@@ -81,7 +82,7 @@ int __exfat_write_inode(struct inode *inode, int sync)
 	 * preventing fsck from reporting "more clusters are allocated".
 	 */
 	on_disk_size = max_t(unsigned long long, i_size_read(inode),
-			ei->valid_size);
+			valid_size);
 
 	if (ei->start_clu == EXFAT_EOF_CLUSTER)
 		on_disk_size = 0;
@@ -89,7 +90,7 @@ int __exfat_write_inode(struct inode *inode, int sync)
 	 * valid_size on disk must reflect only confirmed data (up to i_size)
 	 * and must not exceed on_disk_size.
 	 */
-	on_disk_valid_size = min_t(unsigned long long, ei->valid_size,
+	on_disk_valid_size = min_t(unsigned long long, valid_size,
 			i_size_read(inode));
 	if (ei->start_clu == EXFAT_EOF_CLUSTER)
 		on_disk_valid_size = 0;
@@ -258,15 +259,16 @@ static void exfat_readahead(struct readahead_control *rac)
 	struct inode *inode = mapping->host;
 	struct exfat_inode_info *ei = EXFAT_I(inode);
 	loff_t pos = readahead_pos(rac);
+	loff_t valid_size = exfat_get_valid_size(ei);
 	struct iomap_read_folio_ctx ctx = {
 		.ops = &exfat_iomap_bio_read_ops,
 		.rac = rac,
 	};
 
 	/* Range cross valid_size, read it page by page. */
-	if (ei->valid_size < i_size_read(inode) &&
-	    pos <= ei->valid_size &&
-	    ei->valid_size < pos + readahead_length(rac))
+	if (valid_size < i_size_read(inode) &&
+	    pos <= valid_size &&
+	    valid_size < pos + readahead_length(rac))
 		return;
 
 	iomap_readahead(&exfat_iomap_ops, &ctx, NULL);
@@ -371,8 +373,8 @@ static int exfat_fill_inode(struct inode *inode, struct exfat_dir_entry *info)
 	ei->start_clu = info->start_clu;
 	ei->flags = info->flags;
 	ei->type = info->type;
-	ei->valid_size = info->valid_size;
-	ei->zeroed_size = info->valid_size;
+	exfat_set_valid_size(ei, info->valid_size);
+	exfat_set_zeroed_size(ei, info->valid_size);
 
 	ei->version = 0;
 	ei->hint_stat.eidx = 0;
diff --git a/fs/exfat/iomap.c b/fs/exfat/iomap.c
index 8911aa84a730e..faa9b116e5528 100644
--- a/fs/exfat/iomap.c
+++ b/fs/exfat/iomap.c
@@ -46,6 +46,7 @@ static int __exfat_iomap_begin(struct inode *inode, loff_t offset, loff_t length
 	struct exfat_inode_info *ei = EXFAT_I(inode);
 	unsigned int cluster, num_clusters;
 	loff_t cluster_offset, cluster_length;
+	loff_t valid_size = exfat_get_valid_size(ei);
 	int err;
 	bool balloc = false;
 
@@ -88,7 +89,7 @@ static int __exfat_iomap_begin(struct inode *inode, loff_t offset, loff_t length
 	if (may_alloc || flags & IOMAP_ZERO) {
 		if (balloc)
 			iomap->flags |= IOMAP_F_NEW;
-		else if (iomap->offset + iomap->length >= ei->valid_size) {
+		else if (iomap->offset + iomap->length >= valid_size) {
 			/*
 			 * This is a write that starts at or extends beyond
 			 * the current valid_size. The region between the old
@@ -114,10 +115,10 @@ static int __exfat_iomap_begin(struct inode *inode, loff_t offset, loff_t length
 		 * return IOMAP_UNWRITTEN so the write path can
 		 * distinguish it from a real hole.
 		 */
-		if (offset >= ei->valid_size) {
+		if (offset >= valid_size) {
 			iomap->type = flags & IOMAP_REPORT ?
 				IOMAP_HOLE : IOMAP_UNWRITTEN;
-		} else if (offset + iomap->length > ei->valid_size) {
+		} else if (offset + iomap->length > valid_size) {
 			if (flags & IOMAP_REPORT) {
 				/*
 				 * For SEEK_HOLE/SEEK_DATA, clip the length
@@ -125,9 +126,9 @@ static int __exfat_iomap_begin(struct inode *inode, loff_t offset, loff_t length
 				 * This ensures the caller gets the precise
 				 * hole position in byte units.
 				 */
-				iomap->length = ei->valid_size - iomap->offset;
+				iomap->length = valid_size - iomap->offset;
 			} else
-				iomap->length = round_up(ei->valid_size,
+				iomap->length = round_up(valid_size,
 							 i_blocksize(inode)) -
 								iomap->offset;
 		}
@@ -175,10 +176,8 @@ static int exfat_write_iomap_end(struct inode *inode, loff_t pos, loff_t length,
 
 	end = pos + written;
 
-	if (ei->valid_size < end) {
-		ei->valid_size = end;
+	if (exfat_advance_valid_size(ei, end))
 		dirtied = true;
-	}
 
 	/*
 	 * IOMAP_F_ZERO_TAIL zeroes the remainder of the last block. Track that
@@ -186,8 +185,7 @@ static int exfat_write_iomap_end(struct inode *inode, loff_t pos, loff_t length,
 	 */
 	if (iomap->flags & IOMAP_F_ZERO_TAIL)
 		end = round_up(end, i_blocksize(inode));
-	if (ei->zeroed_size < end)
-		ei->zeroed_size = end;
+	exfat_advance_zeroed_size(ei, end);
 
 	if (dirtied || iomap->flags & IOMAP_F_SIZE_CHANGED)
 		mark_inode_dirty(inode);
@@ -250,7 +248,7 @@ static void exfat_iomap_read_end_io(struct bio *bio)
 		s64 valid_size;
 		loff_t pos = folio_pos(folio);
 
-		valid_size = ei->valid_size;
+		valid_size = exfat_get_valid_size(ei);
 		if (pos + iter.offset < valid_size &&
 		    pos + iter.offset + iter.length > valid_size)
 			folio_zero_segment(folio, offset_in_folio(folio, valid_size),
diff --git a/fs/exfat/namei.c b/fs/exfat/namei.c
index a4dc83b5949c4..1ab26833ba91d 100644
--- a/fs/exfat/namei.c
+++ b/fs/exfat/namei.c
@@ -380,7 +380,7 @@ int exfat_find_empty_entry(struct inode *inode,
 
 		/* directory inode should be updated in here */
 		i_size_write(inode, size);
-		ei->valid_size += sbi->cluster_size;
+		atomic64_add(sbi->cluster_size, &ei->valid_size);
 		ei->flags = p_dir->flags;
 		inode->i_blocks += sbi->cluster_size >> 9;
 	}
@@ -1248,7 +1248,7 @@ static int __exfat_rename(struct inode *old_parent_inode,
 			}
 
 			i_size_write(new_inode, 0);
-			new_ei->valid_size = 0;
+			exfat_set_valid_size(new_ei, 0);
 			new_ei->start_clu = EXFAT_EOF_CLUSTER;
 			new_ei->flags = ALLOC_NO_FAT_CHAIN;
 		}
-- 
2.53.0



