Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057947;
	b=QWHNSpqTcaX/JzoJpB+snyyJ0azXp/AnPvqS6kMBmPl3q0BEB0UfnTfeIWoRcMAOkEUh
	 8eP+SBXf5BDNdztw1U3674W11L5E2mifXMca1w4RNRSV3Fnq2Akeg7A0+UmTnQ19JTN4a
	 8MqKXXz0EOsFarCZR3rV9mywjLLNd1TP/xCatnmRQTkiAfeF8ntJ+t6tCbLRL7RxptawX
	 eBqa5tv2Le7inpbK7By/e4SQW7myNS1bGo5lyaenqEEI5AN9vpuA6E7EpAx6diYOys/F6
	 Q6t8Rkv1F4fbMbW4pcl7itdxKS24y3AUNL1lJnnlkQvrDjSLBdhK5aH+uLIDL2JHuyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057947;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZcPJhaXRb39yNTgORFuf201eSiaMyzdWgVlb+9kSM10=;
	b=IRNGDQE5PSQisb7GRUs0h1jCVcUzTTMYva7SAZmo2kY++jpfoDYHLSAziHCOKgp9e9Wa
	 CFwXes2MHVJp8MX9CsVjlV1ng7dBAWvChlk8XLEO18TjjYaUCC+8mRHz0fteWUXKxYK2g
	 j4oyPVIkYBakqn+uWpn0X4dhyzSRKXdhrIWLH066te2gKz7HC6FE6Mv+XE6NYz3HGxVDI
	 WQejF6Y2HAS32mheshSowcubnG+/Txe0s7bOV8lQqN4JLCDz9TF9wOYekR+ENCyisOHT1
	 /jJGnz4cAnRsDPLn45ZmcfILbNdSLGjME9fxmTthjEMAyIDRGbb8vsbC8HhvMXwmc5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zacn2ss6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ABA7606A325;
	Thu, 19 Nov 2026 03:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zacn2ss6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4B421F000C4;
	Thu, 19 Nov 2026 03:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057947;
	bh=ZcPJhaXRb39yNTgORFuf201eSiaMyzdWgVlb+9kSM10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zacn2ss6zCxoh6R7jJyVmrtaL0pKN7hjeI+3TUb1RPkRV/yr/UhKfCsp2tPdM6M0U
	 tAwwGua94k7rgIVLTURmlkSTZ2JCuhodVzwikHFyRwIBSWGaZJp4tQmDswUXiBVP7N
	 bWCrNwu31f/oA4QuWpksf9zv7lowMb3MXg9ZOXHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 5.10 0270/1848] xfs: check fork type against dabtree block magic number
Date: Wed, 18 Nov 2026 15:38:28 +0100
Message-ID: <20261118145923.602584363@linuxfoundation.org>
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


