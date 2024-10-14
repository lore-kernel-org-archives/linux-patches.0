Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE8B61C3F26;
	Mon, 14 Oct 2024 15:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919608; cv=none; b=H/It7VzpD7m1qZbHkxSQ4uCKrznIbfW/sCQIQw91u9EP1onSh3F2EbZsdfxRfEAR/33389HjAUiVt9h3tCJ8k3i+7EjmW8cqR3tSr6VlFpxYrySFvAghdR4cGU1uZBIJXvm30uycVa+6CsteEtelfBZQPk2r4k/0xaYkixiq+MI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919608; c=relaxed/simple;
	bh=JgoZCu5Q6iGRY0D8qn/QEoGHtZMR5kUB2CwVV3TPtzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PPJTSoiVgDY6xp79VllEoQxHFyQpAeFy+gQkaV2rL6nv+i3MFAiuHjXTRHWA8A1xuxt1Ixmrk3aeabbokDDl9wDmehX1yHgFjJokr06G4Cbp/QJMmFpIhd/IUw1HZPXHmN5AQvNz7HaOyVt4MuaYGfUsk9MOmDXsA3wWgSplM1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2iEbmaVb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2iEbmaVb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FB75C4CEC3;
	Mon, 14 Oct 2024 15:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919607;
	bh=JgoZCu5Q6iGRY0D8qn/QEoGHtZMR5kUB2CwVV3TPtzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2iEbmaVbAe1zgi+MgOMzKufnK+R+MUbUFajYobbxEF8OSnG146kApDdZZWutIsVck
	 rvTPu049ELcRGdHwNziPp28JMo3JdtqJMhVZoZrRbIMf8VTaK1pXxN9BwRKWYq7wJu
	 0jAJWln70yfw50ZOr2wz6yJYouE3p2CTCbBqZrdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"linux-erofs@lists.ozlabs.org, LKML" <linux-kernel@vger.kernel.org>,
	Yue Hu <huyue2@coolpad.com>,
	Chao Yu <chao@kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH 6.1 655/798] erofs: get rid of z_erofs_do_map_blocks() forward declaration
Date: Mon, 14 Oct 2024 16:20:09 +0200
Message-ID: <20241014141243.783321537@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Gao Xiang <hsiangkao@linux.alibaba.com>

commit 999f2f9a63f475192d837a2b8595eb0962984d21 upstream.

The code can be neater without forward declarations.  Let's
get rid of z_erofs_do_map_blocks() forward declaration.

Reviewed-by: Yue Hu <huyue2@coolpad.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Stable-dep-of: 9ed50b8231e3 ("erofs: fix incorrect symlink detection in fast symlink")
Link: https://lore.kernel.org/r/20230204093040.97967-5-hsiangkao@linux.alibaba.com
[ Gao Xiang: apply this to 6.6.y to avoid further backport twists
             due to obsoleted EROFS_BLKSIZ. ]
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/erofs/zmap.c |  242 +++++++++++++++++++++++++++-----------------------------
 1 file changed, 119 insertions(+), 123 deletions(-)

--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -7,10 +7,6 @@
 #include <asm/unaligned.h>
 #include <trace/events/erofs.h>
 
-static int z_erofs_do_map_blocks(struct inode *inode,
-				 struct erofs_map_blocks *map,
-				 int flags);
-
 int z_erofs_fill_inode(struct inode *inode)
 {
 	struct erofs_inode *const vi = EROFS_I(inode);
@@ -29,125 +25,6 @@ int z_erofs_fill_inode(struct inode *ino
 	return 0;
 }
 
-static int z_erofs_fill_inode_lazy(struct inode *inode)
-{
-	struct erofs_inode *const vi = EROFS_I(inode);
-	struct super_block *const sb = inode->i_sb;
-	int err, headnr;
-	erofs_off_t pos;
-	struct erofs_buf buf = __EROFS_BUF_INITIALIZER;
-	void *kaddr;
-	struct z_erofs_map_header *h;
-
-	if (test_bit(EROFS_I_Z_INITED_BIT, &vi->flags)) {
-		/*
-		 * paired with smp_mb() at the end of the function to ensure
-		 * fields will only be observed after the bit is set.
-		 */
-		smp_mb();
-		return 0;
-	}
-
-	if (wait_on_bit_lock(&vi->flags, EROFS_I_BL_Z_BIT, TASK_KILLABLE))
-		return -ERESTARTSYS;
-
-	err = 0;
-	if (test_bit(EROFS_I_Z_INITED_BIT, &vi->flags))
-		goto out_unlock;
-
-	pos = ALIGN(erofs_iloc(inode) + vi->inode_isize + vi->xattr_isize, 8);
-	kaddr = erofs_read_metabuf(&buf, sb, erofs_blknr(pos), EROFS_KMAP);
-	if (IS_ERR(kaddr)) {
-		err = PTR_ERR(kaddr);
-		goto out_unlock;
-	}
-
-	h = kaddr + erofs_blkoff(pos);
-	/*
-	 * if the highest bit of the 8-byte map header is set, the whole file
-	 * is stored in the packed inode. The rest bits keeps z_fragmentoff.
-	 */
-	if (h->h_clusterbits >> Z_EROFS_FRAGMENT_INODE_BIT) {
-		vi->z_advise = Z_EROFS_ADVISE_FRAGMENT_PCLUSTER;
-		vi->z_fragmentoff = le64_to_cpu(*(__le64 *)h) ^ (1ULL << 63);
-		vi->z_tailextent_headlcn = 0;
-		goto done;
-	}
-	vi->z_advise = le16_to_cpu(h->h_advise);
-	vi->z_algorithmtype[0] = h->h_algorithmtype & 15;
-	vi->z_algorithmtype[1] = h->h_algorithmtype >> 4;
-
-	headnr = 0;
-	if (vi->z_algorithmtype[0] >= Z_EROFS_COMPRESSION_MAX ||
-	    vi->z_algorithmtype[++headnr] >= Z_EROFS_COMPRESSION_MAX) {
-		erofs_err(sb, "unknown HEAD%u format %u for nid %llu, please upgrade kernel",
-			  headnr + 1, vi->z_algorithmtype[headnr], vi->nid);
-		err = -EOPNOTSUPP;
-		goto out_put_metabuf;
-	}
-
-	vi->z_logical_clusterbits = LOG_BLOCK_SIZE + (h->h_clusterbits & 7);
-	if (!erofs_sb_has_big_pcluster(EROFS_SB(sb)) &&
-	    vi->z_advise & (Z_EROFS_ADVISE_BIG_PCLUSTER_1 |
-			    Z_EROFS_ADVISE_BIG_PCLUSTER_2)) {
-		erofs_err(sb, "per-inode big pcluster without sb feature for nid %llu",
-			  vi->nid);
-		err = -EFSCORRUPTED;
-		goto out_put_metabuf;
-	}
-	if (vi->datalayout == EROFS_INODE_FLAT_COMPRESSION &&
-	    !(vi->z_advise & Z_EROFS_ADVISE_BIG_PCLUSTER_1) ^
-	    !(vi->z_advise & Z_EROFS_ADVISE_BIG_PCLUSTER_2)) {
-		erofs_err(sb, "big pcluster head1/2 of compact indexes should be consistent for nid %llu",
-			  vi->nid);
-		err = -EFSCORRUPTED;
-		goto out_put_metabuf;
-	}
-
-	if (vi->z_advise & Z_EROFS_ADVISE_INLINE_PCLUSTER) {
-		struct erofs_map_blocks map = {
-			.buf = __EROFS_BUF_INITIALIZER
-		};
-
-		vi->z_idata_size = le16_to_cpu(h->h_idata_size);
-		err = z_erofs_do_map_blocks(inode, &map,
-					    EROFS_GET_BLOCKS_FINDTAIL);
-		erofs_put_metabuf(&map.buf);
-
-		if (!map.m_plen ||
-		    erofs_blkoff(map.m_pa) + map.m_plen > EROFS_BLKSIZ) {
-			erofs_err(sb, "invalid tail-packing pclustersize %llu",
-				  map.m_plen);
-			err = -EFSCORRUPTED;
-		}
-		if (err < 0)
-			goto out_put_metabuf;
-	}
-
-	if (vi->z_advise & Z_EROFS_ADVISE_FRAGMENT_PCLUSTER &&
-	    !(h->h_clusterbits >> Z_EROFS_FRAGMENT_INODE_BIT)) {
-		struct erofs_map_blocks map = {
-			.buf = __EROFS_BUF_INITIALIZER
-		};
-
-		vi->z_fragmentoff = le32_to_cpu(h->h_fragmentoff);
-		err = z_erofs_do_map_blocks(inode, &map,
-					    EROFS_GET_BLOCKS_FINDTAIL);
-		erofs_put_metabuf(&map.buf);
-		if (err < 0)
-			goto out_put_metabuf;
-	}
-done:
-	/* paired with smp_mb() at the beginning of the function */
-	smp_mb();
-	set_bit(EROFS_I_Z_INITED_BIT, &vi->flags);
-out_put_metabuf:
-	erofs_put_metabuf(&buf);
-out_unlock:
-	clear_and_wake_up_bit(EROFS_I_BL_Z_BIT, &vi->flags);
-	return err;
-}
-
 struct z_erofs_maprecorder {
 	struct inode *inode;
 	struct erofs_map_blocks *map;
@@ -732,6 +609,125 @@ unmap_out:
 	return err;
 }
 
+static int z_erofs_fill_inode_lazy(struct inode *inode)
+{
+	struct erofs_inode *const vi = EROFS_I(inode);
+	struct super_block *const sb = inode->i_sb;
+	int err, headnr;
+	erofs_off_t pos;
+	struct erofs_buf buf = __EROFS_BUF_INITIALIZER;
+	void *kaddr;
+	struct z_erofs_map_header *h;
+
+	if (test_bit(EROFS_I_Z_INITED_BIT, &vi->flags)) {
+		/*
+		 * paired with smp_mb() at the end of the function to ensure
+		 * fields will only be observed after the bit is set.
+		 */
+		smp_mb();
+		return 0;
+	}
+
+	if (wait_on_bit_lock(&vi->flags, EROFS_I_BL_Z_BIT, TASK_KILLABLE))
+		return -ERESTARTSYS;
+
+	err = 0;
+	if (test_bit(EROFS_I_Z_INITED_BIT, &vi->flags))
+		goto out_unlock;
+
+	pos = ALIGN(erofs_iloc(inode) + vi->inode_isize + vi->xattr_isize, 8);
+	kaddr = erofs_read_metabuf(&buf, sb, erofs_blknr(pos), EROFS_KMAP);
+	if (IS_ERR(kaddr)) {
+		err = PTR_ERR(kaddr);
+		goto out_unlock;
+	}
+
+	h = kaddr + erofs_blkoff(pos);
+	/*
+	 * if the highest bit of the 8-byte map header is set, the whole file
+	 * is stored in the packed inode. The rest bits keeps z_fragmentoff.
+	 */
+	if (h->h_clusterbits >> Z_EROFS_FRAGMENT_INODE_BIT) {
+		vi->z_advise = Z_EROFS_ADVISE_FRAGMENT_PCLUSTER;
+		vi->z_fragmentoff = le64_to_cpu(*(__le64 *)h) ^ (1ULL << 63);
+		vi->z_tailextent_headlcn = 0;
+		goto done;
+	}
+	vi->z_advise = le16_to_cpu(h->h_advise);
+	vi->z_algorithmtype[0] = h->h_algorithmtype & 15;
+	vi->z_algorithmtype[1] = h->h_algorithmtype >> 4;
+
+	headnr = 0;
+	if (vi->z_algorithmtype[0] >= Z_EROFS_COMPRESSION_MAX ||
+	    vi->z_algorithmtype[++headnr] >= Z_EROFS_COMPRESSION_MAX) {
+		erofs_err(sb, "unknown HEAD%u format %u for nid %llu, please upgrade kernel",
+			  headnr + 1, vi->z_algorithmtype[headnr], vi->nid);
+		err = -EOPNOTSUPP;
+		goto out_put_metabuf;
+	}
+
+	vi->z_logical_clusterbits = LOG_BLOCK_SIZE + (h->h_clusterbits & 7);
+	if (!erofs_sb_has_big_pcluster(EROFS_SB(sb)) &&
+	    vi->z_advise & (Z_EROFS_ADVISE_BIG_PCLUSTER_1 |
+			    Z_EROFS_ADVISE_BIG_PCLUSTER_2)) {
+		erofs_err(sb, "per-inode big pcluster without sb feature for nid %llu",
+			  vi->nid);
+		err = -EFSCORRUPTED;
+		goto out_put_metabuf;
+	}
+	if (vi->datalayout == EROFS_INODE_FLAT_COMPRESSION &&
+	    !(vi->z_advise & Z_EROFS_ADVISE_BIG_PCLUSTER_1) ^
+	    !(vi->z_advise & Z_EROFS_ADVISE_BIG_PCLUSTER_2)) {
+		erofs_err(sb, "big pcluster head1/2 of compact indexes should be consistent for nid %llu",
+			  vi->nid);
+		err = -EFSCORRUPTED;
+		goto out_put_metabuf;
+	}
+
+	if (vi->z_advise & Z_EROFS_ADVISE_INLINE_PCLUSTER) {
+		struct erofs_map_blocks map = {
+			.buf = __EROFS_BUF_INITIALIZER
+		};
+
+		vi->z_idata_size = le16_to_cpu(h->h_idata_size);
+		err = z_erofs_do_map_blocks(inode, &map,
+					    EROFS_GET_BLOCKS_FINDTAIL);
+		erofs_put_metabuf(&map.buf);
+
+		if (!map.m_plen ||
+		    erofs_blkoff(map.m_pa) + map.m_plen > EROFS_BLKSIZ) {
+			erofs_err(sb, "invalid tail-packing pclustersize %llu",
+				  map.m_plen);
+			err = -EFSCORRUPTED;
+		}
+		if (err < 0)
+			goto out_put_metabuf;
+	}
+
+	if (vi->z_advise & Z_EROFS_ADVISE_FRAGMENT_PCLUSTER &&
+	    !(h->h_clusterbits >> Z_EROFS_FRAGMENT_INODE_BIT)) {
+		struct erofs_map_blocks map = {
+			.buf = __EROFS_BUF_INITIALIZER
+		};
+
+		vi->z_fragmentoff = le32_to_cpu(h->h_fragmentoff);
+		err = z_erofs_do_map_blocks(inode, &map,
+					    EROFS_GET_BLOCKS_FINDTAIL);
+		erofs_put_metabuf(&map.buf);
+		if (err < 0)
+			goto out_put_metabuf;
+	}
+done:
+	/* paired with smp_mb() at the beginning of the function */
+	smp_mb();
+	set_bit(EROFS_I_Z_INITED_BIT, &vi->flags);
+out_put_metabuf:
+	erofs_put_metabuf(&buf);
+out_unlock:
+	clear_and_wake_up_bit(EROFS_I_BL_Z_BIT, &vi->flags);
+	return err;
+}
+
 int z_erofs_map_blocks_iter(struct inode *inode, struct erofs_map_blocks *map,
 			    int flags)
 {


