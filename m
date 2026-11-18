Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058906;
	b=jVr2jlpbp9fgR2mWg6ORl2xBIv+/LfS7VlVxJiJobTRjyGN5t1wDLpqdA5FwrxK/KABQ
	 6QIaZiMdLccoifJY3EHR0LB7VBKJ6cHs/crjOiAT827dc2z44kvxg62MaCjmN6E9cTA9M
	 Ypyh7o2Le68PXSRp46GJ8WuRQqYaL7D09HNvNkUpcN7Qu9UK9SDlqTjuIW47c+j16az4D
	 0/dMOUckICKi1f+UXWUmPySkKpPbT+GVRsvXHPq7LxqAYbH2gkMucOCRIVbVYpscU0Ukv
	 sfmHJCfXaobPlpdF8hHlpEEpTN1lwCSsMJnQZ5NbeQ5dH6KjgQABt0luftfUlNSelMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058906;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DDu8dfFlqfBaXgkQ/rvXG+s+8xa5/Q9IUtZY0UGzkhs=;
	b=05As32s0XQd1NlNChd34ttULGkirZYs750RREh8gG3bK6f5J+2CIBlXKR5YFz5+nq1iH
	 hHcwDzdz2TmI6zcciMkKNr92o/dj6U6vaQJZtqP2vBj6BBTgDu2MBK1DW06PFdOLm/Int
	 xP7czXUbzKEgU3iaKz3ntZSwKqCHzoZqba+I508mD3ftOjpIU7GC3okG7Pb+p097nLPGw
	 J2yY5e2ODJ6R2wA+kGx6IBchhA/Ez0q09NwCcpSA2knlxXm17la9w5HmbQCvHzF0kMSRl
	 vZUeqV+fZjEmc8xYI38iA3FS8vOdBNRUZ3VbT1F5DspOAPG3VsmDzdCwGh/2GYFNfOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JP1S4wSL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C02F606A326;
	Thu, 19 Nov 2026 03:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JP1S4wSL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A8E1F000C4;
	Thu, 19 Nov 2026 03:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058906;
	bh=DDu8dfFlqfBaXgkQ/rvXG+s+8xa5/Q9IUtZY0UGzkhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JP1S4wSLYPv83ceKoaavt17bzC61knpqJqfK5j/Q+PXxZnmHbqM+7/M+8mFovxdNc
	 ZcJR1fIObaV1sCrG4Ya+geqDVVAwLmdlSHvfK2/x469YWXFKZq8qgNu5FoapCAuhaG
	 Qhv2bmArUVEdEHTg/rP27OAqSsfQ4n8tN5ukOE7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0652/1848] xfs: bound da-node entry count against the correct geometry
Date: Wed, 18 Nov 2026 15:44:50 +0100
Message-ID: <20261118145943.099202094@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 08871fa84419b..8300d67ae007f 100644
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



