Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031467;
	b=WqiNhOOMfFvczhmLnSxlEfkLDuYs2fJr2SgufBxia+gjBFnKKUgRVl8Al4pt4UYczwFJ
	 nQc15AIppbgiVEwLrpKL5Jgy2Lkas03udPCCbZRvaz/WT6h3q9h/kF0QQbtb2ZOfW4muV
	 54SJzADV+3a50v7b9SRNxve0fS9pDjL4uqOiyTEiceV6c2L8yxvy7bR8lmghbNXgi1jXP
	 wpvRt8IVofqrdNFlK4gqlJE8zsFG1pRBI2ZkZ5fBSvQWrXeX10rRnBeiqD7+3NeA39jfO
	 ap5J4ThMF5RBqTEEC9+kBFQUAlAFPSDcCWwQk+APXHD9rGIBRUMGVPgyrLAHbJlsziw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031467;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xi4ChG+YcSF4FwE+yRmEkCGGrJ+NWxmT8DfxD+Qmxkg=;
	b=vejW4/m3vsyjOGP4DaKqd5/4il8413imL1oiLXvw86r9eUVaTba9rcHzMoWMfCq1XYM1
	 UQtFlmhdpNLVSNFC+zAbctgKBeYjP07+dR/RNH4Pj7TMP+pPobMl8d3HNGjsybdeXD5q9
	 pTj9G3CaXa+7sWfBL3dNTYGtzXZWV7HnnZAuFs0CTSdJCuGwh61YtxQexXrhEV/+TkeYT
	 nEjGAp5dZwuCSR4GnAN7FfAJolR8ThRuIh4pJH9uebKzTNSwokqDWHLt72ncOhWt39ort
	 jeKizPKC4C8gYVPScGqEQxHgZwmBKUSQVLfG/YImROa9n3fzgl83xjVZ5L6YjdkVI5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ui987uf7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F828606A32A;
	Wed, 18 Nov 2026 19:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ui987uf7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 819E81F000C4;
	Wed, 18 Nov 2026 19:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031467;
	bh=xi4ChG+YcSF4FwE+yRmEkCGGrJ+NWxmT8DfxD+Qmxkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ui987uf7OywEfXgSA2TxYy+2ZGtPi9bExWGGbDcRJVSssWmo+78UMFadHKQhmjlhB
	 RoIBGZwZPjyJBhygczPc3hhmy7ZA1FUSV6qLelzCFW+01vKVSHixgDzAkO5KuUgthk
	 ATBk2hsokDhfTHcbURLsHk7ZC3MHjmbh5E/z2n4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1070/1756] btrfs: dont use token set/get accessors in inode.c:fill_inode_item()
Date: Wed, 18 Nov 2026 15:53:17 +0100
Message-ID: <20261118150052.844330889@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Sterba <dsterba@suse.com>

[ Upstream commit e3df5141a4c1b85e1f6dc117f48fb634eb275f6c ]

The token versions of set/get accessors will be removed, use the normal
helpers.

There's additional overhead of the token helpers that update the cached
address in case it moves to another page/folio. The normal versions
don't need to do that.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 08f750d9f893 ("btrfs: fix off-by-one end offset check in report_setget_bounds()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 60 ++++++++++++++++++++----------------------------
 1 file changed, 25 insertions(+), 35 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index f1d9aa14c8286..e4d0f87344fab 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3988,45 +3988,35 @@ static void fill_inode_item(struct btrfs_trans_handle *trans,
 			    struct btrfs_inode_item *item,
 			    struct inode *inode)
 {
-	struct btrfs_map_token token;
 	u64 flags;
 
-	btrfs_init_map_token(&token, leaf);
-
-	btrfs_set_token_inode_uid(&token, item, i_uid_read(inode));
-	btrfs_set_token_inode_gid(&token, item, i_gid_read(inode));
-	btrfs_set_token_inode_size(&token, item, BTRFS_I(inode)->disk_i_size);
-	btrfs_set_token_inode_mode(&token, item, inode->i_mode);
-	btrfs_set_token_inode_nlink(&token, item, inode->i_nlink);
-
-	btrfs_set_token_timespec_sec(&token, &item->atime,
-				     inode_get_atime_sec(inode));
-	btrfs_set_token_timespec_nsec(&token, &item->atime,
-				      inode_get_atime_nsec(inode));
-
-	btrfs_set_token_timespec_sec(&token, &item->mtime,
-				     inode_get_mtime_sec(inode));
-	btrfs_set_token_timespec_nsec(&token, &item->mtime,
-				      inode_get_mtime_nsec(inode));
-
-	btrfs_set_token_timespec_sec(&token, &item->ctime,
-				     inode_get_ctime_sec(inode));
-	btrfs_set_token_timespec_nsec(&token, &item->ctime,
-				      inode_get_ctime_nsec(inode));
-
-	btrfs_set_token_timespec_sec(&token, &item->otime, BTRFS_I(inode)->i_otime_sec);
-	btrfs_set_token_timespec_nsec(&token, &item->otime, BTRFS_I(inode)->i_otime_nsec);
-
-	btrfs_set_token_inode_nbytes(&token, item, inode_get_bytes(inode));
-	btrfs_set_token_inode_generation(&token, item,
-					 BTRFS_I(inode)->generation);
-	btrfs_set_token_inode_sequence(&token, item, inode_peek_iversion(inode));
-	btrfs_set_token_inode_transid(&token, item, trans->transid);
-	btrfs_set_token_inode_rdev(&token, item, inode->i_rdev);
+	btrfs_set_inode_uid(leaf, item, i_uid_read(inode));
+	btrfs_set_inode_gid(leaf, item, i_gid_read(inode));
+	btrfs_set_inode_size(leaf, item, BTRFS_I(inode)->disk_i_size);
+	btrfs_set_inode_mode(leaf, item, inode->i_mode);
+	btrfs_set_inode_nlink(leaf, item, inode->i_nlink);
+
+	btrfs_set_timespec_sec(leaf, &item->atime, inode_get_atime_sec(inode));
+	btrfs_set_timespec_nsec(leaf, &item->atime, inode_get_atime_nsec(inode));
+
+	btrfs_set_timespec_sec(leaf, &item->mtime, inode_get_mtime_sec(inode));
+	btrfs_set_timespec_nsec(leaf, &item->mtime, inode_get_mtime_nsec(inode));
+
+	btrfs_set_timespec_sec(leaf, &item->ctime, inode_get_ctime_sec(inode));
+	btrfs_set_timespec_nsec(leaf, &item->ctime, inode_get_ctime_nsec(inode));
+
+	btrfs_set_timespec_sec(leaf, &item->otime, BTRFS_I(inode)->i_otime_sec);
+	btrfs_set_timespec_nsec(leaf, &item->otime, BTRFS_I(inode)->i_otime_nsec);
+
+	btrfs_set_inode_nbytes(leaf, item, inode_get_bytes(inode));
+	btrfs_set_inode_generation(leaf, item, BTRFS_I(inode)->generation);
+	btrfs_set_inode_sequence(leaf, item, inode_peek_iversion(inode));
+	btrfs_set_inode_transid(leaf, item, trans->transid);
+	btrfs_set_inode_rdev(leaf, item, inode->i_rdev);
 	flags = btrfs_inode_combine_flags(BTRFS_I(inode)->flags,
 					  BTRFS_I(inode)->ro_flags);
-	btrfs_set_token_inode_flags(&token, item, flags);
-	btrfs_set_token_inode_block_group(&token, item, 0);
+	btrfs_set_inode_flags(leaf, item, flags);
+	btrfs_set_inode_block_group(leaf, item, 0);
 }
 
 /*
-- 
2.53.0



