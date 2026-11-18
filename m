Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037307;
	b=GwEc3kcZqdxerUy5ytSP5xFfSUi0kvFlq3HiDv0DEHBr7U49ObgH/nwJnW0w8+oxJCQD
	 aCoR/woN0yH+bNbkrBRQIT2NW7ahZ0LkJridU1QjBz37knYOhABuzo4IWPE4U+XstwXay
	 KT6J6tl7DQu2jo3AmA3gYGX41P/97hGY8z9cA0MrcVJqYVSGbzMiyWRFoTyF81uJfAF8O
	 4gY1EsxSTrZJ/RHJ0TmvpBC80EHVNxQp4ej3Fs20xprUjvSYVayr8T0qpX/A1hzNo1SYp
	 wTJYIaTCrwPg/6HEVia2C9MNtr3p9D0zg2AENQj/poNPkokzZIc+qrSwxZ0fkd7u+qw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037307;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E15pnptI+eVs3rTNYQ1tleO5RB+JYMg2manPcxcyy8U=;
	b=On1C7FTHCnqyq7Wy4TyXBKT3xD9UWdfipZir9gS0mCZgYezpG1ovvb7S2CEJtoZi6Czc
	 pEW+byTahaYdUT8IXlA1qOk9dBdA7wN+a/WesaIvJLrZH09WQLUSwlg4RH1QKm0RLiN7z
	 nL9XWvR5zjBnG2i2ZPSF/Fq7Iee58Mjh6ZTvZmkEntznqdxmkzbP8B3adIxKfBi3K6u63
	 1y2w+7fAr9X9+u1hgPb194HqinDkbSwjTH0iiXyZhFYe4zeTNSBQEZU8/Ah/iGUflChMZ
	 pdLg2tWHb9LmLF8Aw5lK/qE78PKpnxYoKX86LIvt+2gYDMhAQUrc0ZFoGr9+yVDa0/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=snUe0Puk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF35606A31C;
	Wed, 18 Nov 2026 21:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=snUe0Puk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 980801F000C4;
	Wed, 18 Nov 2026 21:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037307;
	bh=E15pnptI+eVs3rTNYQ1tleO5RB+JYMg2manPcxcyy8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=snUe0Puky3XzjI93hDV5vz0A20FVOpeDzgjzAA0x5JLk7kuiPNX619lujfJ5ohuPG
	 Ciw8IEXfFeOqEzkcr96w93Y8310Q37gdkaGGviY/BrR1eDJVUqyViE9F6U3ktRM1cn
	 DORc1GmXus1IDAUPtYdJtVIVEQoFE5tXpS3xzyV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1360/3318] xfs: bound da-node entry count against the correct geometry
Date: Wed, 18 Nov 2026 15:33:02 +0100
Message-ID: <20261118150401.252494007@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1efd45076ee2a..7869b3f5c19b3 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -1671,6 +1671,19 @@ xfs_da3_node_lookup_int(
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



