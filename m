Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063210;
	b=StMc7qJlvLG/htKLxI+WaOQyMaCcpZ2q0rgU6bTj4rfXxpjYrFXcRW/xnzlnKqRwMZrx
	 VJoL6j2MxVO904NrvGzABGmKi8n+9ASiOObnA/FkZGg6fj5swKTfLuch/L2UK6PhHL5Xq
	 Jy4C+l+2cflTbRIOYeaXwEO+PYmDOxx/tmrsENj4RdMdVNkVef1/85kQ3znm19g8ifLaw
	 /oviG3sTQlpsIW4LPa8s81SXmvRl5mJo3sgwMWl07ZK9Na/RvHVR3eDl7Tpv3dtURyfEh
	 5KD9Oy8rM0vXlgwgpIHbVmBQQcMgnW1MUFeaoWhrr+g8dj5TAsLNZNVSHLqiNpWv2+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063210;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+DQf3Dibk9nsXnBOt+LHc7QBzkgCdv+/s9WR9Ry9cTc=;
	b=ppbVkeRpfQzh2LH9ORAqKmsXEQnBg0VCxFpSJOm6f1gRMkyoGwPQghry+NiTPwO+mMTq
	 nM9r+WaxZfodQ3ifcGNqpUXSOMIVOs+BFb50O5ZQaNVBdOC6Ico3ViEUUVc97bcHbutrf
	 eEuDVbMH/Y+gL8y8HIpYQPxBJUe8ddk82EqlIZrF2SOLpIZob5ClL9496Sqak7UBIj5I+
	 JCmJ2l0tdDcWNXZ/ZLlExkIu420TPADKbd9qfwqddQIBB1Rwhpg3+JN/ohjP2Jn+cPXDS
	 src2k4cGG9Vk/3vARxDDQmzEaZb76/RqF7JNwVa4ekD4yKYR6wp2XcvmUjrtXBchUIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PxOrCFqG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9B02606D805;
	Sat,  7 Nov 2026 14:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PxOrCFqG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EBE81F0089F;
	Sat,  7 Nov 2026 14:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063209;
	bh=+DQf3Dibk9nsXnBOt+LHc7QBzkgCdv+/s9WR9Ry9cTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PxOrCFqGyaz4YvM5K+4XjeAOxM2lBMzvetqLGYMRKGJstM4MlXvfOLlhQy4K70aTA
	 dmLAkZyxb0nNEGTiEtue1teDxIE4QYHRMo6SP0xwD83vaeuCrjf49N66o7NF2jw/sB
	 r6cUADnsJEni2PsJ66Ob8XSLQH2J4YIXhc+w/hnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Monakov <amonakov@ispras.ru>,
	Jan Kara <jack@suse.cz>,
	Daejun Park <daejun7.park@samsung.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 421/869] ext4: dont report delalloc data as a hole on indirect-mapped inodes
Date: Sat,  7 Nov 2026 08:51:43 -0500
Message-ID: <20261107134907.766881558@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daejun Park <daejun7.park@samsung.com>

[ Upstream commit aed43f47e1edeee1454eea86006a8c09480e5ed3 ]

When a plain lookup finds no block, ext4_ind_map_blocks() sizes the hole
it reports by counting the empty subtrees under 'partial' in the on-disk
indirect tree.  That count knows nothing about delayed allocation, so a
range holding delalloc data that has not been written back yet is
reported as a plain hole.  The extent-mapped path does not have this
problem: it trims the hole it found at the first delayed extent before
returning it.

ext4_map_blocks() consults the extent status tree before it calls into
the mapping layer, so a query that starts exactly on the delayed block
still finds it.  A query that starts earlier does not, because the hole
reported for the earlier block already spans the delayed one.  On a
4k-block filesystem, lseek(SEEK_DATA) from offset 0 on a file whose only
data block is at logical block N and is still dirty returns:

  N = 0..11      direct blocks                 N << 12
  N = 12         first single-indirect block   N << 12
  N = 13..1035   inside that indirect block    -1 ENXIO
  N = 1036       first double-indirect block   N << 12

Blocks 12 and 1036 survive because the query lands on the delayed block
itself.  Blocks 13..1035 are swallowed by the 1024-block hole reported
for block 12.  fiemap loses the same data for the same reason.

An ext3 filesystem mounted as ext4 hits this during ordinary use: ext3
inodes stay indirect mapped, while mount -t ext4 turns on delayed
allocation even though mounting ext3 with -o delalloc is explicitly
rejected.  install(1) from coreutils uses SEEK_DATA to locate data in
its source file, so installing a sparse file that has not been written
back silently produces a destination of the right size holding none of
the data:

  truncate -s 1G img && mkfs.ext3 -F img && mount -t ext4 img mnt
  echo | dd of=mnt/src bs=1 count=1 seek=64K
  install mnt/src mnt/dst
  cmp mnt/src mnt/dst        # differ: char 65537

Reconciling a hole with the extent status tree does not depend on how
the hole was found, so instead of open coding it a second time, split
the delalloc handling out of ext4_ext_determine_insert_hole() into
ext4_determine_insert_hole(), which takes the hole the caller located,
and call that from ext4_ind_map_blocks() as well.  All the special cases
and the comments explaining them stay in one place.

Two things change for indirect-mapped inodes.  They now cache the holes
they report, as the extent-mapped path already does: ext4_punch_hole()
already puts EXTENT_STATUS_HOLE on such inodes, ext4_map_blocks() and
ext4_da_map_blocks() already handle a cached hole, the latter by
replacing it with the delayed extent, and consecutive hole entries
merge, so the tree does not grow with the length of a scan.  And when a
delayed extent covers the queried block itself - a race, since
ext4_map_blocks() found nothing in the tree just before - the hole is
now reported only up to the end of that extent instead of in full.

The indirect path passes hole_start == lblk, so the "delalloc extent in
front of the queried range" case cannot be reached there:
__es_tree_search() never returns an extent ending before the block it
was searched for.

With this the sweep above returns N << 12 for every N, while the
nodelalloc and extent-mapped controls are unchanged.  generic/225,
generic/285, generic/448 and generic/490 pass on ext4 made both with and
without the extent feature.  generic/286 and generic/436 pass on
extent-mapped ext4 and are skipped without it, since they need
fallocate.

Fixes: facab4d9711e ("ext4: return hole from ext4_map_blocks()")
Reported-by: Alexander Monakov <amonakov@ispras.ru>
Closes: https://lore.kernel.org/linux-ext4/594c17d9-c00f-e485-96fb-cedf27ce3aa3@ispras.ru/
Suggested-by: Jan Kara <jack@suse.cz>
Cc: stable@vger.kernel.org
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Link: https://patch.msgid.link/20260827084829epcms2p6ecc0c39a71d0c3eebf9cb1ade77314f6@epcms2p6
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/ext4.h     |  3 +++
 fs/ext4/extents.c  | 26 +++++++++++++-------------
 fs/ext4/indirect.c | 17 +++++++++++++++++
 3 files changed, 33 insertions(+), 13 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index ed546c52ebc32..9c67a2c28faf5 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3809,6 +3809,9 @@ extern void ext4_ext_tree_init(handle_t *handle, struct inode *inode);
 extern int ext4_ext_index_trans_blocks(struct inode *inode, int extents);
 extern int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 			       struct ext4_map_blocks *map, int flags);
+ext4_lblk_t ext4_determine_insert_hole(struct inode *inode, ext4_lblk_t lblk,
+				       ext4_lblk_t hole_start,
+				       ext4_lblk_t hole_len);
 extern int ext4_ext_truncate(handle_t *, struct inode *);
 extern int ext4_ext_remove_space(struct inode *inode, ext4_lblk_t start,
 				 ext4_lblk_t end);
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 21fba12520a8e..80d41be515644 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4160,21 +4160,19 @@ static int get_implied_cluster_alloc(struct super_block *sb,
 }
 
 /*
- * Determine hole length around the given logical block, first try to
- * locate and expand the hole from the given @path, and then adjust it
- * if it's partially or completely converted to delayed extents, insert
- * it into the extent cache tree if it's indeed a hole, finally return
- * the length of the determined extent.
+ * Adjust the hole [@hole_start, @hole_start + @hole_len) the caller found
+ * around the queried block @lblk if it's partially or completely converted
+ * to delayed extents, insert it into the extent cache tree if it's indeed a
+ * hole, finally return the length of the determined extent starting at
+ * @lblk.  @hole_start must not be behind @lblk.
  */
-static ext4_lblk_t ext4_ext_determine_insert_hole(struct inode *inode,
-						  struct ext4_ext_path *path,
-						  ext4_lblk_t lblk)
+ext4_lblk_t ext4_determine_insert_hole(struct inode *inode, ext4_lblk_t lblk,
+				       ext4_lblk_t hole_start,
+				       ext4_lblk_t hole_len)
 {
-	ext4_lblk_t hole_start, len;
+	ext4_lblk_t len = hole_len;
 	struct extent_status es;
 
-	hole_start = lblk;
-	len = ext4_ext_find_hole(inode, path, &hole_start);
 again:
 	ext4_es_find_extent_range(inode, &ext4_es_is_delayed, hole_start,
 				  hole_start + len - 1, &es);
@@ -4342,9 +4340,11 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 	 * we couldn't try to create block if flags doesn't contain EXT4_GET_BLOCKS_CREATE
 	 */
 	if ((flags & EXT4_GET_BLOCKS_CREATE) == 0) {
-		ext4_lblk_t len;
+		ext4_lblk_t hole_start = map->m_lblk, len;
 
-		len = ext4_ext_determine_insert_hole(inode, path, map->m_lblk);
+		len = ext4_ext_find_hole(inode, path, &hole_start);
+		len = ext4_determine_insert_hole(inode, map->m_lblk,
+						 hole_start, len);
 
 		map->m_pblk = 0;
 		map->m_len = min_t(unsigned int, map->m_len, len);
diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index da76353b3a575..50c567123b42d 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -586,6 +586,23 @@ int ext4_ind_map_blocks(handle_t *handle, struct inode *inode,
 		for (i = partial - chain + 1; i < depth; i++)
 			count = count * epb + (epb - offsets[i] - 1);
 		count++;
+
+		/*
+		 * The count knows nothing about delayed allocation, so let
+		 * the common helper reconcile it with the extent status
+		 * tree.  Only when the lookup really did find a hole:
+		 * ext4_get_branch() also returns a non-NULL partial when it
+		 * failed, and caching a hole for a range it could not read
+		 * would answer every later read from that cache instead of
+		 * retrying.  Clamp the count first, a subtree can be bigger
+		 * than the logical block space when the block size is large.
+		 */
+		if (!err) {
+			count = umin(count, EXT_MAX_BLOCKS - map->m_lblk);
+			count = ext4_determine_insert_hole(inode, map->m_lblk,
+							   map->m_lblk, count);
+		}
+
 		/* Fill in size of a hole we found */
 		map->m_pblk = 0;
 		map->m_len = umin(map->m_len, count);
-- 
2.53.0



