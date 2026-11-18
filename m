Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051778;
	b=es9MLlRaBECrTmPvAtgBy6X7bzX4AxfyEW2PRkVv3oA1Z40oz+u5y8teH0MeTmRmulaN
	 jGFiIKxBr24qsdvokuIr4Fptx4iwK6P+jRcoTZqBpqhiKpEDipwnzIqt2YcOOiUr+GZuK
	 TVncb2ZREwTmbZWF+QHhl7cchq6zAnxIL2V1GE5FNDlBLldcVkWXbHT92XQC4HrFmu/yg
	 7K+2oLh3K6fiTBvAvoyqxSmHWITudcr4ToLPytOrpbtjhPdyVlYUlddr+/b1YN6VkAKbK
	 TJ4ra7ul4lbYsXjOr3LPXczxpuqHeVLDMNChkvs0Z7aJAiyk1DYT4dHEgVznQTsxXDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051778;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gNKmeL3LIdBm8iM7AY3KDst9jp9AQqulN7MNyn4Xsu8=;
	b=fYgA8yHfjsY5WSzHiC+eRoBl/Y2+rQvgdVqCiNpF4AAMLJTMTbiyU6z0HaipYHO+oyNV
	 PfLfrtqSSwBx/EcGjtzrNRHtLd6JTetsJQl2fXSU84r9DOH2HN//9m5pHvDEc1wi/BlNg
	 UCi3AwDoNw4H2yE3YldosWpwk5dVH4y2fU3hLlL4fRAhCupPaA5xGOGlghAIPrgX0YVuM
	 n+OF/mz2pG4PO1URICoGVspGrZhlycg+AyOXsCxv0+GMsEbsMc3h0xiPWHsb18pXCoLMN
	 AkPqCJ/3uVl8lQ+CKNKfVwhSOPXZHGa2HMs+CTkBPmPUGz8rCTB2+Ep4qD5i1WwauKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s2bW3P9E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E36BC606A320;
	Thu, 19 Nov 2026 01:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s2bW3P9E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DF9F1F000C4;
	Thu, 19 Nov 2026 01:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051777;
	bh=gNKmeL3LIdBm8iM7AY3KDst9jp9AQqulN7MNyn4Xsu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s2bW3P9Em+g6II0wt5ONhNP5pKFgKF0iAurJlnlntfs4cEcqW7F1YeKTxKiVfyBCB
	 lo04jgZ09soF0uarIVcFmCVYiK7fEx9dIo2gR2V2o53bk2sbuDqKz5hYJyAuc6eJVj
	 lUJpvW01JJvc3gyxlxkNeI5YhFX29Jf+/CalN+LE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 5.15 0329/2214] xfs: check fork type against dabtree block magic number
Date: Wed, 18 Nov 2026 15:33:25 +0100
Message-ID: <20261118150023.485263706@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 43030b72a11a532e7e3c21ac84a8625425b4201b upstream.

LOLLM complains that we fail to flag dabtree blocks that should never be
associated with the file fork -- data forks can't point to xattr leaves,
and attr forks can't point to dirent blocks.  Add the missing checks.

Cc: stable@vger.kernel.org # v4.15
Fixes: 7c4a07a424c18d ("xfs: scrub directory/attribute btrees")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/dabtree.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -392,6 +392,10 @@ xchk_da_btree_block(
 				XFS_BLFT_ATTR_LEAF_BUF);
 		blk->magic = XFS_ATTR_LEAF_MAGIC;
 		blk->hashval = xfs_attr_leaf_lasthash(blk->bp, pmaxrecs);
+		if (dargs->whichfork != XFS_ATTR_FORK) {
+			xchk_da_set_corrupt(ds, level);
+			goto out_freebp;
+		}
 		if (ds->tree_level != 0)
 			xchk_da_set_corrupt(ds, level);
 		break;
@@ -401,6 +405,10 @@ xchk_da_btree_block(
 				XFS_BLFT_DIR_LEAFN_BUF);
 		blk->magic = XFS_DIR2_LEAFN_MAGIC;
 		blk->hashval = xfs_dir2_leaf_lasthash(ip, blk->bp, pmaxrecs);
+		if (dargs->whichfork != XFS_DATA_FORK) {
+			xchk_da_set_corrupt(ds, level);
+			goto out_freebp;
+		}
 		if (ds->tree_level != 0)
 			xchk_da_set_corrupt(ds, level);
 		break;
@@ -410,6 +418,10 @@ xchk_da_btree_block(
 				XFS_BLFT_DIR_LEAF1_BUF);
 		blk->magic = XFS_DIR2_LEAF1_MAGIC;
 		blk->hashval = xfs_dir2_leaf_lasthash(ip, blk->bp, pmaxrecs);
+		if (dargs->whichfork != XFS_DATA_FORK) {
+			xchk_da_set_corrupt(ds, level);
+			goto out_freebp;
+		}
 		if (ds->tree_level != 0)
 			xchk_da_set_corrupt(ds, level);
 		break;


