Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035240;
	b=36leEWccqf/TTBHLhITZD/AoYeopMSpwiBJx1yKpDh5giVYTBZ/xlav/KfU7XSnUdR1F
	 1BCWKlCfPKMVy5VaOAOCvKwsIIllPmCWZ0ju818AEC9l5jMe4hT4AXg0SXmm3oCsE4qrp
	 xHiUtuwxAu7QBawWAe7hhzbCpIlvXdyfi1F1ZZlWbOS3nvBGQWXNtG6TREjXrvVYHkHr7
	 GLICYdoBa7sVkOU+0eMYMtOezHOgTUuj2bLnVkRhV6bbwl0335ozEh5lJCJW0ul243yaY
	 3n4+FlE/ob/vVHxm7sAV9Mp/vo3uwoGjsWkbNWFQ16XSqpl+aZaYW3s2c4Wmm/60evQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035240;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=22Ja4REWubf42pxfPGFA4G/juRB4e1+jsaMsbkCwvhs=;
	b=t7AgFz3pJcHnRFbFiq5w6TR7Hjm6nqdYTgddKgiLbZaSFiDnYe90XlYTO2JYt6j30BSp
	 kwbAXaKzUWZ3YF0MIqd2TIaz/8gZOh7wpvTxyk1L3t00PipLalqxvPoQ5AaKfPNa16GU4
	 XDdgIrXMVVX+TMuCLYIQ7/c+MVmGSlm0g8BT6m0Kiws+4Sfc+7eQsT192RUVZWIWyIL5A
	 EBuaOPzbDqRSvguospyX532eSi4dC1UVpQ+0y/NiFQvEvTLvI1yHWUOjZEbrrAaJKAG9u
	 pXO3lbLNh6wNu/Sm0tSFDbfPk/itmnhqgREgGrxjVy605RNQ8jNFuduELTZlqtnHJdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ImLq7Vqg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9754606A330;
	Wed, 18 Nov 2026 20:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ImLq7Vqg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23B9A1F000C4;
	Wed, 18 Nov 2026 20:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035240;
	bh=22Ja4REWubf42pxfPGFA4G/juRB4e1+jsaMsbkCwvhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ImLq7VqgkyMgcU+KyiUIuA9QAkKH74RO3Ctf5fEeeIpamb+NxcgEI5u5xeMH7e6VI
	 linl1iZeHMI2QG2SKyNLHyz7S6I3mHsSZj/GSM793twhMrXzKQ2q0na90e7REdsu4D
	 QnHvobrw6+l3XoxptyuhZF9ASi6+4GmUsbqKJRSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.6 0656/3318] xfs: check fork type against dabtree block magic number
Date: Wed, 18 Nov 2026 15:21:18 +0100
Message-ID: <20261118150337.720012788@linuxfoundation.org>
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
@@ -393,6 +393,10 @@ xchk_da_btree_block(
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
@@ -402,6 +406,10 @@ xchk_da_btree_block(
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
@@ -411,6 +419,10 @@ xchk_da_btree_block(
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


