Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053115;
	b=CmS2sci/jI8F8FBgf7jxFg4eS3O/Gzr17Eh7AwnSQuxnFxzETUcQlFhIdG6f3yNoQFY/
	 RDb83aXjPvkfIbL+i73Us2M73YL0ze3U9CRCAaUhNsHWjkeo520/HPLluHv/0Xszwgk5u
	 9CH4fusqCohMVtPJYP0T6wKZkFyIgMmeA2NvIDuJQKyhhdS0LIr6f+PtjAxvC5P5MNAeA
	 d5z9dyW2iogxlpqJAzWqYK3/bLq5n0pSlZfX38Cj00E4urHW5+DT6DwGUlHUgqYjQE2Ut
	 APCCDRLhX2GYZqqTO+cY32r7h7sSRMMm68YIYknR7BQR3VUDnQ3/adqly4sPYyC7jWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053115;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0WRRiTD/iyZoQdsFqZNToQcCxZJdIEoLK9DmGi+lWG0=;
	b=vB2gGNx6aA2OcLIDck0ShXeuwpxzc9cikrkK3ui5VcFESUWVKDZ7kKfVR26xBjBg/uMw
	 HWmIErpRVARw0kc5Kv6ad6eUjS2RGZxPJBCn7uthYCT/vBL49aTWBnFBEvo411oYfsmxi
	 qaTe1mO6sloXSfWbeenydLlE9ltPiuMeMKA3CRPZAFGorVqRkjENaMf7N3nAMMmzKm1Jm
	 I+eTtEMdQC1CYPUYp6UaBtCtaMHwH6JuYdDlIs+oUVpe5W6qnrzXe+q4b9vDgFTwHk3Kt
	 /7VSdbc0KJ3oRcISLvdg46+/YWd6A09/YzmbJplM5u1AkF9PzcCTya1fWsAvJZDqokg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WSWhCjmt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2EEF606A320;
	Thu, 19 Nov 2026 01:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WSWhCjmt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 110621F000C4;
	Thu, 19 Nov 2026 01:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053115;
	bh=0WRRiTD/iyZoQdsFqZNToQcCxZJdIEoLK9DmGi+lWG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WSWhCjmtCUj4WPT08Y611JdJQxOPmVtjQG5g5BFmiWLa+MwH9tBDCJMENHQ72YGD4
	 GlT6hlN9T00Ihdfo5mSp0R9+hX+TPt7DN5r8PG+vcQhrW+RchnrXvOLPTKhsd8LrU6
	 LQwOBLjXsVJ3iGRGSx0coX52XcGAVR7yI4ndCgY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0805/2214] xfs: bound da-node entry count against the correct geometry
Date: Wed, 18 Nov 2026 15:41:21 +0100
Message-ID: <20261118150043.697044957@linuxfoundation.org>
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

From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>

[ Upstream commit 3df5e5aaa3bc0913236c48ab29b7df3a785aa29f ]

xfs_da3_node_verify() bounds the node entry count against the larger of
the directory and attribute geometries because, as a buffer verifier, it
cannot tell whether the block belongs to the directory or the attribute
tree. When the directory block size exceeds the fs block size (e.g.
mkfs.xfs -n size=64k -b size=4k), an attribute node buffer is a single fs
block that holds only m_attr_geo->node_ents entries, yet a crafted attr
node may claim a count up to m_dir_geo->node_ents and still pass the
verifier.

xfs_da3_node_lookup_int() then indexes btree[] up to that count during
its binary search -- an out-of-bounds read via getxattr/listxattr on a
mounted crafted image.

The buffer verifier is the wrong place to tighten this: it has no fork
context, and the transaction-less read path used by getxattr does not run
xfs_da3_node_set_type() either. xfs_da3_node_lookup_int(), on the other
hand, always runs on that path and holds args->geo, the geometry of the
fork actually being searched. Bound the entry count against
args->geo->node_ents there, before walking the entries.

Fixes: 7ab610f9e0f1 ("xfs: move node entry counts to xfs_da_geometry")
Cc: stable@vger.kernel.org
Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
[ sashal: Omitted the xfs_da_mark_sick() call because the helper is unavailable. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_da_btree.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 9ac99912e7a54..ef0dbca2750bc 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -1658,6 +1658,19 @@ xfs_da3_node_lookup_int(
 		} else
 			expected_level--;
 
+		/*
+		 * The node verifier cannot tell whether this block belongs to
+		 * the directory or the attribute tree, so it only bounds the
+		 * entry count against the larger of the two geometries.  Here
+		 * args->geo is the geometry of the fork we are actually
+		 * searching, so reject a count that would walk btree[] off the
+		 * end of this node buffer.
+		 */
+		if (nodehdr.count > args->geo->node_ents) {
+			xfs_buf_mark_corrupt(blk->bp);
+			return -EFSCORRUPTED;
+		}
+
 		max = nodehdr.count;
 		blk->hashval = be32_to_cpu(btree[max - 1].hashval);
 
-- 
2.53.0



