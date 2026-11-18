Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021135;
	b=ga46tWK6/dQqvaZpUKkXPfqjJYSa3EfcsMLLAyncdw38csSaDtA5Vvjd/aE9rU2WcnaF
	 rZFdFBMbacasoRB+Hi68+JU4MSiqVGQb5ndj/wP1a1pdp8TTHh19nMGLPmwVp0uENFE1V
	 ABvcByM7d5PzuP+jpIwBJYp8Nmjxbz7TR/3nimME0g2y+QU9MSfmr9NPYjLOBX1KPCzF+
	 JgFAOowRnQxEb/VJGIxGG2KNpdEMXU0K6QUK37ovy/oRnPHd0L6xOPxGmEBOx0f/N0ez9
	 m6GKr2jOBp39rHi8licJ+uVrbOwlDGBdkYjTwfQWiKlmSUFd3x0S3RoQtfV7SJoyXNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021135;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Z1E8Eb4VCXSBOvihiCdGWSsAEAaPRUhxdOC1EM+Y4ao=;
	b=SkIFmbpKFr+KCUC7euVAlCV0idomTj+IIgVVoDPdnSjpsyM8dDZ7TJmSgYuE1CHZ3V9o
	 uG9InS7kbThU5SIbgOi5d/f20F8Z0u6V4SjAneh6K6keT3CnEMUDltnp0NIGbroGV5j8b
	 6ELgaYFAb7CJOzctXwzjcli6oXDdQfNlkCkX+YI32CMtRUCMDwGXhRQD7GveRRkQxaFle
	 IxviGnv92Liqi6K0iSIEkI/ee+ZII1G1aNnGhxvl4oZtMy1JwDSmb/Fva0muj2Wf5N9RM
	 0cKSRIRofHPqgnOo7s5sMBa1FNRJp7tw8f7d6nhWvpYOjeae9jFkNj2fVnF2nxnrwvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dub+Zzv2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A6B5606A31C;
	Wed, 18 Nov 2026 16:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dub+Zzv2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 885501F000C4;
	Wed, 18 Nov 2026 16:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021135;
	bh=Z1E8Eb4VCXSBOvihiCdGWSsAEAaPRUhxdOC1EM+Y4ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dub+Zzv2l7QTCRumCMzUvmkjWFzypmgR96DnPUk9WHWRYp3v3Lstf7+QHcP6t+AVC
	 IMjCgVQQgF6DkNc1ndyuoFmHUPrXraIlr2uztAjtKnGJ9IYO8ZIiXZc3iJYIEltogb
	 cgKPPuyQG4N3Oyxj7tjOLCKBwWQOHenERHEqatLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Weso=C5=82owski?= <marek@wesolowski.eu.org>,
	Baolin Liu <liubaolin@kylinos.cn>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2200/2651] ntfs: fix directory lookup on large-page systems
Date: Wed, 18 Nov 2026 15:57:20 +0100
Message-ID: <20261118150404.904151066@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Wesołowski <marek@wesolowski.eu.org>

[ Upstream commit 3581ef455875aead551f9b92fd1e82c8e6fe3fe1 ]

ntfs_lookup_inode_by_name() copies PAGE_SIZE bytes from the index
allocation mapping and applies MST fixups to that entire buffer before
selecting the requested INDX block.

When PAGE_SIZE is larger than the NTFS index block size, the USA count
belongs to the smaller INDX block. post_read_mst_fixup() therefore treats
the PAGE_SIZE call as not applicable and leaves the update sequence words
in place. A directory entry crossing a sector boundary can then be returned
by readdir but missed by lookup.

Select the INDX block first, apply the fixup using its actual block size,
and propagate fixup failures before validating the block. Report fixup
failures through ntfs_error() so the configured errors= policy is applied.

Return -EIO when post_read_mst_fixup() detects an incomplete multi sector
transfer, since this indicates an on-disk metadata integrity error.

Reproduced on arm64 with 16 KiB pages and 4 KiB NTFS index blocks. The
affected entry was visible in readdir but stat returned ENOENT. Both exact
and case-insensitive lookup succeed after this change.

Fixes: 0a8ac0c1fa0b ("ntfs: update directory operations")
Signed-off-by: Marek Wesołowski <marek@wesolowski.eu.org>
Reviewed-by: Baolin Liu <liubaolin@kylinos.cn>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/dir.c | 9 ++++++++-
 fs/ntfs/mst.c | 4 ++--
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/ntfs/dir.c b/fs/ntfs/dir.c
index 09b890b41c4a9..173ba95c0dfd7 100644
--- a/fs/ntfs/dir.c
+++ b/fs/ntfs/dir.c
@@ -331,7 +331,6 @@ u64 ntfs_lookup_inode_by_name(struct ntfs_inode *dir_ni, const __le16 *uname,
 	}
 
 	memcpy_from_folio(kaddr, folio, 0, PAGE_SIZE);
-	post_read_mst_fixup((struct ntfs_record *)kaddr, PAGE_SIZE);
 	folio_unlock(folio);
 	folio_put(folio);
 fast_descend_into_child_node:
@@ -352,6 +351,14 @@ u64 ntfs_lookup_inode_by_name(struct ntfs_inode *dir_ni, const __le16 *uname,
 			   vcn, dir_ni->mft_no);
 		goto unm_err_out;
 	}
+	err = post_read_mst_fixup((struct ntfs_record *)ia,
+				  dir_ni->itype.index.block_size);
+	if (err) {
+		ntfs_error(sb,
+			   "MST fixup failed for index block vcn %lld in directory inode 0x%llx.",
+			   vcn, dir_ni->mft_no);
+		goto unm_err_out;
+	}
 	err = ntfs_index_block_inconsistent(vol, ia,
 					    dir_ni->itype.index.block_size,
 					    vcn, COLLATION_FILE_NAME,
diff --git a/fs/ntfs/mst.c b/fs/ntfs/mst.c
index 7f9faad924adf..cc6363413449d 100644
--- a/fs/ntfs/mst.c
+++ b/fs/ntfs/mst.c
@@ -19,7 +19,7 @@
  * magic of the ntfs record header being processed with "BAAD" (in memory only!)
  * and abort processing.
  *
- * Return 0 on success and -EINVAL on error ("BAAD" magic will be present).
+ * Return 0 on success and -EIO on error ("BAAD" magic will be present).
  *
  * NOTE: We consider the absence / invalidity of an update sequence array to
  * mean that the structure is not protected at all and hence doesn't need to
@@ -71,7 +71,7 @@ int post_read_mst_fixup(struct ntfs_record *b, const u32 size)
 			 * Note that magic_BAAD is already converted to le32.
 			 */
 			b->magic = magic_BAAD;
-			return -EINVAL;
+			return -EIO;
 		}
 		data_pos += NTFS_BLOCK_SIZE / sizeof(u16);
 	}
-- 
2.53.0



