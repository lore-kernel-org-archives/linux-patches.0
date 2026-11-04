Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831662;
	b=L7hTQYDHjNYRblSAhHQZXj4lgif5VCHYw4d13bF7dBkLqlam42KK/9XMlQxXBkUsw+JR
	 R7Z3bsJzlaUTo4cUJxWnC4ImdfSsLz1uv9bI9O9EwXKOLLpB+a1jBg44WygTjSPIV19ka
	 RqLtvFHqjvO+8xkdDFhpxe6RjOH3hQP9II1EMlgHzuAx9ozOm2H8bE1yWzbIj5iYzRkPU
	 5a26g1T212ZPjNW5Y/J1DwktgAb2PckuMvyhtEwCTUTvUTMLyVFJZqO02NRvq7JqfsguY
	 0NHN2zeDHYQlWi9DszJLdFxJeJvfPKPFLPsmEEJ45Obb7OEDdn89napPwohFzFAjgZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831662;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jdh7/+4i6SJXH6roQyIrp/V0gm7/58LuywgClQGm9lg=;
	b=sJDvSLit1EaCplf2fEswYvMu+9/svWev3xfngc2uCc8BaFLWIrcVG/uNtRljJ/yJDT0B
	 9GOUUlzX/miEZWtqN/awYRR+rzOcyaY6HdtWbuC16J56KeXLW4X8qFLQvpwzpZgltX7Kv
	 A6znlVRZMRVMFyAfI3w68cJNt34lOQEc+HJnhFV01Ntg0lzEWuYxKIjqD+RVnVBHNdCWJ
	 3ENngDzhuIev9TmumdhwoBly6GAhLreCD0sOSKfZsmDHpqxHkqmi1NqZRsFXHigWyR09y
	 cwweNJuqUroQree0FnUlEpySid2TyMYy7OjxvlixK7tRJn9GeeY4KOmngYgudQ0b4pg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qRQZkBV6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2845606B2D7;
	Wed,  4 Nov 2026 22:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qRQZkBV6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AB951F000C1;
	Wed,  4 Nov 2026 22:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831661;
	bh=jdh7/+4i6SJXH6roQyIrp/V0gm7/58LuywgClQGm9lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qRQZkBV6Gt3V+O1HgczGrWfCHfnzqC4Ad0iWp/IVCs28b5yEVcGwjLdAUAIJl2+BA
	 ISh/q8ShvI3uK0lUTLCZx+WvX0e1m8Ri9JG5pPXYKmTIq0x8U94SPY4TT7MieJxQWC
	 +xuWchm8p4QjVSsENioxNvb94yY8a1ePcbyvDTiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0802/1005] xfs: check fork type against dabtree block magic number
Date: Wed,  4 Nov 2026 16:08:55 -0500
Message-ID: <20261104211105.813131684@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
@@ -410,6 +410,10 @@ xchk_da_btree_block(
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
@@ -419,6 +423,10 @@ xchk_da_btree_block(
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
@@ -428,6 +436,10 @@ xchk_da_btree_block(
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


