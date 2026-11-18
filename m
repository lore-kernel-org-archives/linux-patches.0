Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046958;
	b=nuU1nz9oh6csiEkdQHTjpbyKZsV5Sesg8yomiI8cpbTu8f9cmp+ZIUp+tstQmPrAt6Ps
	 Ug+JgZuWIwo/O68RijxQZAVzlSMO67du8vuD2WyEQRH9Y1yA7NrFaRvabxkvsabHXl6qd
	 6sYQXOfqnhQjd1SF2dZsib45sI8EQfhCjxtxh6oYP5wtYuzde0WxxI1FeAED6E/qEnelF
	 qhkOB0Mqw/kaa78z2NKMimeo5+SxIE4dWd1zfc8l5hq1czHNRj4tf9URaYnaITrSu0n0G
	 a7J9bMPck5SnRiaM9miaf+ZRG/mZk9wBsJ7LMI+aVVg2TAm4uj5ZQtJykavZjKJ2K1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046958;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jswktn0RztEFRjf9afA0jQbAmgA0pG7NgO4TD42cSsg=;
	b=y1WiznEyBIK87gyF2LWCGnQcj3gHGBp/Np11nPxZl4EIk+mJ7hDLqddl1CWcwjleQuhy
	 vkhpeNyO9I45v6WZN6Pl1zG/LOoZ+SYc/89joyO8R3k9PHqOJAKrEmFca+t5A29CckP1N
	 C2W37/JzUFVgNSkmpxw+8iVl403ABkda1hkwWvePtdiQXPP6XCMqYtNYU1WiYzUVagldp
	 ECbFlPTfXyYCNk2xwtElkQMkBRD4TjyGZyP2pYDLZv9+qgkpVRCjgHh4jS6ZKPNTURJED
	 GTyYbegvkcV7u2SW24k1rNryRTpg1dIx4dBAgxVy6i0VW5r+Magh2cRzx+4atUByBLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QLJo8FXG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 087BD606A31C;
	Thu, 19 Nov 2026 00:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QLJo8FXG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CB741F000C4;
	Thu, 19 Nov 2026 00:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046957;
	bh=jswktn0RztEFRjf9afA0jQbAmgA0pG7NgO4TD42cSsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QLJo8FXGIYQs6zvDS+kQkagIpGOyy9iVRrvsBOpn0u/cCOI2nIO8ka3Lgp6QUMPDM
	 fXywg9xqxk0+aPOtIuSbUeb2qJPS2BghR1rPVP+Rinc8ELT3WnbDtmhxxHyngOYZaw
	 h8MD1R4KUS4EKqqliAPk4xZIknKfK0VOauKaRPeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	"Brian G ." <gissf1@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1426/2857] nilfs2: correct return value kernel-doc descriptions for the rest
Date: Wed, 18 Nov 2026 15:41:00 +0100
Message-ID: <20261118150252.662233941@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

[ Upstream commit 343d4a33f26d048fde4b02cfc3681f766b3f1b12 ]

Similar to the previous changes to fix return value descriptions, this
fixes the format of the return value descriptions of functions for the
rest.

Link: https://lkml.kernel.org/r/20250110010530.21872-6-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: "Brian G ." <gissf1@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 7131aaa74bcc ("nilfs2: ignore non-fatal signals during synchronous log write wait")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/gcinode.c   | 24 +++++++++-------------
 fs/nilfs2/inode.c     | 12 +++--------
 fs/nilfs2/recovery.c  | 32 +++++++++++------------------
 fs/nilfs2/segbuf.c    | 12 ++---------
 fs/nilfs2/segment.c   | 48 ++++++++++++++++---------------------------
 fs/nilfs2/the_nilfs.c | 12 +++++------
 6 files changed, 50 insertions(+), 90 deletions(-)

diff --git a/fs/nilfs2/gcinode.c b/fs/nilfs2/gcinode.c
index 8cdb1dc76f612..1e7de19e58306 100644
--- a/fs/nilfs2/gcinode.c
+++ b/fs/nilfs2/gcinode.c
@@ -46,14 +46,11 @@
  * specified by @pbn to the GC pagecache with the key @blkoff.
  * This function sets @vbn (@pbn if @vbn is zero) in b_blocknr of the buffer.
  *
- * Return Value: On success, 0 is returned. On Error, one of the following
- * negative error code is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
- *
- * %-ENOENT - The block specified with @pbn does not exist.
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOENT	- The block specified with @pbn does not exist.
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_gccache_submit_read_data(struct inode *inode, sector_t blkoff,
 				   sector_t pbn, __u64 vbn,
@@ -114,12 +111,11 @@ int nilfs_gccache_submit_read_data(struct inode *inode, sector_t blkoff,
  * specified by @vbn to the GC pagecache.  @pbn can be supplied by the
  * caller to avoid translation of the disk block address.
  *
- * Return Value: On success, 0 is returned. On Error, one of the following
- * negative error code is returned.
- *
- * %-EIO - I/O error.
- *
- * %-ENOMEM - Insufficient amount of memory available.
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EIO	- I/O error (including metadata corruption).
+ * * %-ENOENT	- Invalid virtual block address.
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_gccache_submit_read_node(struct inode *inode, sector_t pbn,
 				   __u64 vbn, struct buffer_head **out_bh)
diff --git a/fs/nilfs2/inode.c b/fs/nilfs2/inode.c
index a20d52951f1ef..eaf4e61113afd 100644
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -676,10 +676,7 @@ struct inode *nilfs_iget_for_gc(struct super_block *sb, unsigned long ino,
  * or does nothing if the inode already has it.  This function allocates
  * an additional inode to maintain page cache of B-tree nodes one-on-one.
  *
- * Return Value: On success, 0 is returned. On errors, one of the following
- * negative error code is returned.
- *
- * %-ENOMEM - Insufficient memory available.
+ * Return: 0 on success, or %-ENOMEM if memory is insufficient.
  */
 int nilfs_attach_btree_node_cache(struct inode *inode)
 {
@@ -740,11 +737,8 @@ void nilfs_detach_btree_node_cache(struct inode *inode)
  * in one inode and the one for b-tree node pages is set up in the
  * other inode, which is attached to the former inode.
  *
- * Return Value: On success, a pointer to the inode for data pages is
- * returned. On errors, one of the following negative error code is returned
- * in a pointer type.
- *
- * %-ENOMEM - Insufficient memory available.
+ * Return: a pointer to the inode for data pages on success, or %-ENOMEM
+ * if memory is insufficient.
  */
 struct inode *nilfs_iget_for_shadow(struct inode *inode)
 {
diff --git a/fs/nilfs2/recovery.c b/fs/nilfs2/recovery.c
index ce30b51ac593c..b5207e4c50007 100644
--- a/fs/nilfs2/recovery.c
+++ b/fs/nilfs2/recovery.c
@@ -741,18 +741,13 @@ static void nilfs_abort_roll_forward(struct the_nilfs *nilfs)
  * @sb: super block instance
  * @ri: pointer to a nilfs_recovery_info struct to store search results.
  *
- * Return Value: On success, 0 is returned.  On error, one of the following
- * negative error code is returned.
- *
- * %-EINVAL - Inconsistent filesystem state.
- *
- * %-EIO - I/O error
- *
- * %-ENOSPC - No space left on device (only in a panic state).
- *
- * %-ERESTARTSYS - Interrupted.
- *
- * %-ENOMEM - Insufficient memory available.
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EINVAL		- Inconsistent filesystem state.
+ * * %-EIO		- I/O error.
+ * * %-ENOMEM		- Insufficient memory available.
+ * * %-ENOSPC		- No space left on device (only in a panic state).
+ * * %-ERESTARTSYS	- Interrupted.
  */
 int nilfs_salvage_orphan_logs(struct the_nilfs *nilfs,
 			      struct super_block *sb,
@@ -817,14 +812,11 @@ int nilfs_salvage_orphan_logs(struct the_nilfs *nilfs,
  * segment pointed by the superblock.  It sets up struct the_nilfs through
  * this search. It fills nilfs_recovery_info (ri) required for recovery.
  *
- * Return Value: On success, 0 is returned.  On error, one of the following
- * negative error code is returned.
- *
- * %-EINVAL - No valid segment found
- *
- * %-EIO - I/O error
- *
- * %-ENOMEM - Insufficient memory available.
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EINVAL	- No valid segment found.
+ * * %-EIO	- I/O error.
+ * * %-ENOMEM	- Insufficient memory available.
  */
 int nilfs_search_super_root(struct the_nilfs *nilfs,
 			    struct nilfs_recovery_info *ri)
diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
index 6e59dc19a7324..7416fb6e3fd4b 100644
--- a/fs/nilfs2/segbuf.c
+++ b/fs/nilfs2/segbuf.c
@@ -403,12 +403,7 @@ static int nilfs_segbuf_submit_bh(struct nilfs_segment_buffer *segbuf,
  * @segbuf: buffer storing a log to be written
  * @nilfs: nilfs object
  *
- * Return Value: On Success, 0 is returned. On Error, one of the following
- * negative error code is returned.
- *
- * %-EIO - I/O error
- *
- * %-ENOMEM - Insufficient memory available.
+ * Return: Always 0.
  */
 static int nilfs_segbuf_write(struct nilfs_segment_buffer *segbuf,
 			      struct the_nilfs *nilfs)
@@ -449,10 +444,7 @@ static int nilfs_segbuf_write(struct nilfs_segment_buffer *segbuf,
  * nilfs_segbuf_wait - wait for completion of requested BIOs
  * @segbuf: segment buffer
  *
- * Return Value: On Success, 0 is returned. On Error, one of the following
- * negative error code is returned.
- *
- * %-EIO - I/O error
+ * Return: 0 on success, or %-EIO if I/O error is detected.
  */
 static int nilfs_segbuf_wait(struct nilfs_segment_buffer *segbuf)
 {
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index a412abdfbbf3e..92631394c8d29 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -191,12 +191,10 @@ static int nilfs_prepare_segment_lock(struct super_block *sb,
  * When @vacancy_check flag is set, this function will check the amount of
  * free space, and will wait for the GC to reclaim disk space if low capacity.
  *
- * Return Value: On success, 0 is returned. On error, one of the following
- * negative error code is returned.
- *
- * %-ENOMEM - Insufficient memory available.
- *
- * %-ENOSPC - No space left on device
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-ENOMEM	- Insufficient memory available.
+ * * %-ENOSPC	- No space left on device (if checking free space).
  */
 int nilfs_transaction_begin(struct super_block *sb,
 			    struct nilfs_transaction_info *ti,
@@ -2286,18 +2284,13 @@ static void nilfs_segctor_wakeup(struct nilfs_sc_info *sci, int err, bool force)
  * nilfs_construct_segment - construct a logical segment
  * @sb: super block
  *
- * Return Value: On success, 0 is returned. On errors, one of the following
- * negative error code is returned.
- *
- * %-EROFS - Read only filesystem.
- *
- * %-EIO - I/O error
- *
- * %-ENOSPC - No space left on device (only in a panic state).
- *
- * %-ERESTARTSYS - Interrupted.
- *
- * %-ENOMEM - Insufficient memory available.
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EIO		- I/O error (including metadata corruption).
+ * * %-ENOMEM		- Insufficient memory available.
+ * * %-ENOSPC		- No space left on device (only in a panic state).
+ * * %-ERESTARTSYS	- Interrupted.
+ * * %-EROFS		- Read only filesystem.
  */
 int nilfs_construct_segment(struct super_block *sb)
 {
@@ -2321,18 +2314,13 @@ int nilfs_construct_segment(struct super_block *sb)
  * @start: start byte offset
  * @end: end byte offset (inclusive)
  *
- * Return Value: On success, 0 is returned. On errors, one of the following
- * negative error code is returned.
- *
- * %-EROFS - Read only filesystem.
- *
- * %-EIO - I/O error
- *
- * %-ENOSPC - No space left on device (only in a panic state).
- *
- * %-ERESTARTSYS - Interrupted.
- *
- * %-ENOMEM - Insufficient memory available.
+ * Return: 0 on success, or one of the following negative error codes on
+ * failure:
+ * * %-EIO		- I/O error (including metadata corruption).
+ * * %-ENOMEM		- Insufficient memory available.
+ * * %-ENOSPC		- No space left on device (only in a panic state).
+ * * %-ERESTARTSYS	- Interrupted.
+ * * %-EROFS		- Read only filesystem.
  */
 int nilfs_construct_dsync_segment(struct super_block *sb, struct inode *inode,
 				  loff_t start, loff_t end)
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index f9b10b4e22c01..013aea9dc355d 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -50,8 +50,8 @@ void nilfs_set_last_segment(struct the_nilfs *nilfs,
  * alloc_nilfs - allocate a nilfs object
  * @sb: super block instance
  *
- * Return Value: On success, pointer to the_nilfs is returned.
- * On error, NULL is returned.
+ * Return: a pointer to the allocated nilfs object on success, or NULL on
+ * failure.
  */
 struct the_nilfs *alloc_nilfs(struct super_block *sb)
 {
@@ -202,8 +202,7 @@ static int nilfs_store_log_cursor(struct the_nilfs *nilfs,
  * exponent information written in @sbp and stores it in @blocksize,
  * or aborts with an error message if it's too large.
  *
- * Return Value: On success, 0 is returned. If the block size is too
- * large, -EINVAL is returned.
+ * Return: 0 on success, or %-EINVAL if the block size is too large.
  */
 static int nilfs_get_blocksize(struct super_block *sb,
 			       struct nilfs_super_block *sbp, int *blocksize)
@@ -546,7 +545,7 @@ static int nilfs_valid_sb(struct nilfs_super_block *sbp)
  * area, or if the parameters themselves are not normal, it is
  * determined to be invalid.
  *
- * Return Value: true if invalid, false if valid.
+ * Return: true if invalid, false if valid.
  */
 static bool nilfs_sb2_bad_offset(struct nilfs_super_block *sbp, u64 offset)
 {
@@ -677,8 +676,7 @@ static int nilfs_load_super_block(struct the_nilfs *nilfs,
  * reading the super block, getting disk layout information, initializing
  * shared fields in the_nilfs).
  *
- * Return Value: On success, 0 is returned. On error, a negative error
- * code is returned.
+ * Return: 0 on success, or a negative error code on failure.
  */
 int init_nilfs(struct the_nilfs *nilfs, struct super_block *sb, char *data)
 {
-- 
2.53.0



