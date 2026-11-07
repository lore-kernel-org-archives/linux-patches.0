Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065101;
	b=Qa5uIFJtlBpu6yoVQgrofnnwTsmm7KmgyFXm3HpJBNY/fRA0h1sE1g15hXtUISDABvlA
	 qt5W/HaaajGVJV6Wq++sZrUtQeTRsGyQPDaSq279plqkZImD6nYt2dSvuiK3+iVU8gd5/
	 8XxpAhSIsbrbeuEHR13CYj5WpM1HkP7f7ZXdeaLx9gvnDXqK8vKuMVZyNQyfXs72hhlTT
	 bjkblyAyIVAHWzpFVvHbNFznYX5LVDvcEJY9Wvn+Ey+DdxU7w+ArLgjMvn4smM+b14yHI
	 YwpZJlungmcNvluGIL3/nYOzIWIITNsf4uIO2YG8FpzNikFV/CZY43vrsxabEdQ+JaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065101;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rVC5SnhXGVLjAIDBUNC2gvY1jiStxQs5vYG7I2M6x7o=;
	b=jRftt6XRtDmp9LyI0eZUrUiKQIvUOXk3lOfVJ8Sl+b9j13p+a3EGuhmLFNrryX4O7Zkf
	 3TIUulFwhzWD5dkl+ryhhrvs6uU+BvW5pueZHanJI2cyqx7YsXFiXylowArH06T8my/EO
	 wsB+zOj7LX8W9fXmYRYFuKvAyXQp0M5I3r3y9m/cis9iEH2+m3hRfN7msRGP9cgubJWnS
	 mKRKaobJUkY9fBa5wY8wXbuN0/2CeAT9YZR4NkUEkV2+oBT5omxDYUnugyKFpFufvyoKw
	 K9Z+E5ARsrhfX9xR97CK+rIiTnW+wQi6nHWSuRiTrFJAzzzio4ZfxBlusNTEi44OSHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U2xtntfu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD7F606A326;
	Sat,  7 Nov 2026 15:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U2xtntfu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FDDC1F0089F;
	Sat,  7 Nov 2026 15:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065101;
	bh=rVC5SnhXGVLjAIDBUNC2gvY1jiStxQs5vYG7I2M6x7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U2xtntfuU4xPJVASUTinlZD/CeWY0+38vsMUTEFDrLv/3y94MsP3cdww7Sstj0Qh4
	 OnOcpL5V7ewElFdVUA6TUeENKIHNF2PS7AsqUpsNJS46Pzt5WYIwN4K15YaZckLrti
	 4sbTpfYN3AoJrCieAJHMJIPEPh0/aMfhhVyZ3alw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Goergens <matthias.goergens@gmail.com>,
	Baolin Liu <liubaolin@kylinos.cn>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0933/1257] ntfs: hold the runlist lock while expanding a non-resident attribute
Date: Sat,  7 Nov 2026 08:53:49 -0500
Message-ID: <20261107135005.125818562@linuxfoundation.org>
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

From: Matthias Goergens <matthias.goergens@gmail.com>

[ Upstream commit 768c6f5fab58cefa65509dd34b946fdd1071746e ]

ntfs_non_resident_attr_expand() changes ni->runlist.rl while it
allocates clusters: ntfs_attr_map_whole_runlist(), the compressed
branch's ntfs_rl_realloc() and ntfs_runlists_merge() can each kvfree()
the old array.  Unless the caller already holds ni->runlist.lock, none
of this happens under it; only the rollback takes it.  Callers without
it include the write path, fallocate, ntfs_inode_attr_pwrite() and
ntfs_resident_attr_resize().

Those callers hold mrec_lock, and the write path also inode_lock, but
the iomap read side takes neither: FIEMAP, page faults, readahead and
splice read reach ntfs_read_iomap_begin_non_resident(), which takes only
ni->runlist.lock.  A FIEMAP running while write(2) extends the same file
can walk the array that ntfs_runlists_merge() has just freed:

  BUG: KASAN: slab-use-after-free in ntfs_attr_vcn_to_rl+0x19b/0x200

A reader that finds a vcn unmapped in the stale array also maps it from
disk into the runlist the writer is changing, which shows up as "Run
lists overlap. Cannot merge!".

Take ni->runlist.lock for writing around the part of the expansion that
changes the runlist and allocated_size, up to and including the mapping
pairs update, as ntfs_non_resident_attr_shrink() does since commit
91709ba5d6d7 ("ntfs: protect runlist updates with the runlist lock"),
and hold it throughout the rollback, where ntfs_cluster_free() requires
it.  The lock nests inside mrec_lock, as on the truncate-up path, which
already calls this function with the runlist lock held.  Where the
caller says it holds the lock (locked_ni == ni), assert that it holds it
for writing.

For an $ATTRIBUTE_LIST whose lock the caller does not hold, drop the
lock again before the mapping pairs update: that update can resize the
same list through ntfs_attrlist_update_locked(), which returns -ENOSPC
when told that the list's lock is held.  Holding it there made punching
holes into a large fragmented file fail with -ENOSPC.

Fixes: 495e90fa3348 ("ntfs: update attrib operations")
Cc: stable@vger.kernel.org
Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>
Reviewed-by: Baolin Liu <liubaolin@kylinos.cn>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/attrib.c | 74 ++++++++++++++++++++++++++++++++++--------------
 1 file changed, 53 insertions(+), 21 deletions(-)

diff --git a/fs/ntfs/attrib.c b/fs/ntfs/attrib.c
index c5df913d3cbad..1f64680d5c8fe 100644
--- a/fs/ntfs/attrib.c
+++ b/fs/ntfs/attrib.c
@@ -4487,6 +4487,7 @@ static int ntfs_non_resident_attr_expand(struct ntfs_inode *ni, const s64 newsiz
 	struct super_block *sb = ni->vol->sb;
 	size_t new_rl_count;
 	unsigned long flags;
+	bool runlist_locked = locked_ni == ni;
 
 	ntfs_debug("Inode 0x%llx, attr 0x%x, new size %lld old size %lld\n",
 			(unsigned long long)ni->mft_no, ni->type,
@@ -4528,10 +4529,19 @@ static int ntfs_non_resident_attr_expand(struct ntfs_inode *ni, const s64 newsiz
 	 * clusters if there is a change.
 	 */
 	if (ntfs_bytes_to_cluster(vol, ni->allocated_size) < first_free_vcn) {
+		/*
+		 * The runlist array is replaced below.  Readers such as the
+		 * iomap read path hold only the runlist lock, not mrec_lock.
+		 */
+		if (runlist_locked)
+			lockdep_assert_held_write(&ni->runlist.lock);
+		else
+			down_write(&ni->runlist.lock);
+
 		err = ntfs_attr_map_whole_runlist(ni);
 		if (err) {
 			ntfs_error(sb, "ntfs_attr_map_whole_runlist failed");
-			return err;
+			goto unlock_runlist;
 		}
 
 		/*
@@ -4556,7 +4566,7 @@ static int ntfs_non_resident_attr_expand(struct ntfs_inode *ni, const s64 newsiz
 						last + more_entries + 1);
 				if (IS_ERR(rl)) {
 					err = -ENOMEM;
-					goto put_err_out;
+					goto unlock_runlist;
 				}
 
 				alloc_size = ni->allocated_size;
@@ -4581,7 +4591,7 @@ static int ntfs_non_resident_attr_expand(struct ntfs_inode *ni, const s64 newsiz
 				rl = kmalloc(sizeof(struct runlist_element) * 2, GFP_NOFS);
 				if (!rl) {
 					err = -ENOMEM;
-					goto put_err_out;
+					goto unlock_runlist;
 				}
 
 				rl[0].vcn = ntfs_bytes_to_cluster(vol, ni->allocated_size);
@@ -4628,7 +4638,8 @@ static int ntfs_non_resident_attr_expand(struct ntfs_inode *ni, const s64 newsiz
 				ntfs_debug("Cluster allocation failed (%lld)",
 						(long long)first_free_vcn -
 						ntfs_bytes_to_cluster(vol, ni->allocated_size));
-				return PTR_ERR(rl);
+				err = PTR_ERR(rl);
+				goto unlock_runlist;
 			}
 			/*
 			 * A contiguous ATTRIBUTE_LIST allocation keeps its mapping
@@ -4652,8 +4663,10 @@ static int ntfs_non_resident_attr_expand(struct ntfs_inode *ni, const s64 newsiz
 								ni->allocated_size),
 						lcn_seek_from, DATA_ZONE, false,
 						false, false);
-				if (IS_ERR(rl))
-					return PTR_ERR(rl);
+				if (IS_ERR(rl)) {
+					err = PTR_ERR(rl);
+					goto unlock_runlist;
+				}
 			}
 		}
 
@@ -4665,7 +4678,8 @@ static int ntfs_non_resident_attr_expand(struct ntfs_inode *ni, const s64 newsiz
 				ntfs_error(sb, "Run list merge failed");
 				ntfs_cluster_free_from_rl(vol, rl);
 				kvfree(rl);
-				return -EIO;
+				err = -EIO;
+				goto unlock_runlist;
 			}
 			ni->runlist.rl = rln;
 			ni->runlist.count = new_rl_count;
@@ -4673,11 +4687,28 @@ static int ntfs_non_resident_attr_expand(struct ntfs_inode *ni, const s64 newsiz
 
 		/* Prepare to mapping pairs update. */
 		ni->allocated_size = ntfs_cluster_to_bytes(vol, first_free_vcn);
-		err = ntfs_attr_update_mapping_pairs_locked(
-				ni, 0, locked_ni);
-		if (err) {
-			ntfs_debug("Mapping pairs update failed");
-			goto rollback;
+		if (ni->type == AT_ATTRIBUTE_LIST && !runlist_locked) {
+			/*
+			 * Making room for the list's mapping pairs can resize
+			 * this attribute list again through
+			 * ntfs_attrlist_update_locked(), which takes its
+			 * runlist lock.
+			 */
+			up_write(&ni->runlist.lock);
+			err = ntfs_attr_update_mapping_pairs_locked(ni, 0,
+								    locked_ni);
+			if (err) {
+				ntfs_debug("Mapping pairs update failed");
+				goto rollback;
+			}
+		} else {
+			err = ntfs_attr_update_mapping_pairs_locked(ni, 0, ni);
+			if (err) {
+				ntfs_debug("Mapping pairs update failed");
+				goto rollback_locked;
+			}
+			if (!runlist_locked)
+				up_write(&ni->runlist.lock);
 		}
 	}
 
@@ -4711,6 +4742,9 @@ static int ntfs_non_resident_attr_expand(struct ntfs_inode *ni, const s64 newsiz
 	ntfs_attr_put_search_ctx(ctx);
 	return 0;
 rollback:
+	if (!runlist_locked)
+		down_write(&ni->runlist.lock);
+rollback_locked:
 	/* Free allocated clusters. */
 	err2 = ntfs_cluster_free(ni, ntfs_bytes_to_cluster(vol, org_alloc_size),
 				-1, ctx);
@@ -4722,8 +4756,6 @@ static int ntfs_non_resident_attr_expand(struct ntfs_inode *ni, const s64 newsiz
 	 * dropping the lock: ntfs_attr_vcn_to_rl() fails a lookup below the
 	 * allocated size that falls past the end of the runlist.
 	 */
-	if (ni != locked_ni)
-		down_write(&ni->runlist.lock);
 	err2 = ntfs_rl_truncate_nolock(vol, &ni->runlist,
 			ntfs_bytes_to_cluster(vol, org_alloc_size));
 	if (!err2) {
@@ -4731,8 +4763,6 @@ static int ntfs_non_resident_attr_expand(struct ntfs_inode *ni, const s64 newsiz
 		ni->allocated_size = org_alloc_size;
 		write_unlock_irqrestore(&ni->size_lock, flags);
 	}
-	if (ni != locked_ni)
-		up_write(&ni->runlist.lock);
 	if (err2) {
 		/*
 		 * Failed to truncate the runlist, so just throw it away, it
@@ -4743,12 +4773,8 @@ static int ntfs_non_resident_attr_expand(struct ntfs_inode *ni, const s64 newsiz
 		ntfs_error(sb, "Couldn't truncate runlist. Rollback failed");
 	} else {
 		/* Restore mapping pairs. */
-		if (ni != locked_ni)
-			down_read(&ni->runlist.lock);
-		if (__ntfs_attr_update_mapping_pairs(ni, 0, locked_ni, true))
+		if (__ntfs_attr_update_mapping_pairs(ni, 0, ni, true))
 			ntfs_error(sb, "Failed to restore old mapping pairs");
-		if (ni != locked_ni)
-			up_read(&ni->runlist.lock);
 
 		if (NInoSparse(ni) || NInoCompressed(ni)) {
 			ni->itype.compressed.size =  org_compressed_size;
@@ -4756,6 +4782,8 @@ static int ntfs_non_resident_attr_expand(struct ntfs_inode *ni, const s64 newsiz
 		} else
 			VFS_I(base_ni)->i_blocks = ni->allocated_size >> 9;
 	}
+	if (!runlist_locked)
+		up_write(&ni->runlist.lock);
 	if (ctx)
 		ntfs_attr_put_search_ctx(ctx);
 	return err;
@@ -4763,6 +4791,10 @@ static int ntfs_non_resident_attr_expand(struct ntfs_inode *ni, const s64 newsiz
 	if (ctx)
 		ntfs_attr_put_search_ctx(ctx);
 	return err;
+unlock_runlist:
+	if (!runlist_locked)
+		up_write(&ni->runlist.lock);
+	return err;
 }
 
 /*
-- 
2.53.0



