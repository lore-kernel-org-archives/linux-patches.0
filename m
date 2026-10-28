Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215063;
	b=u8gM+66SomleJtVqFvnsya0aE60gZqZHeYIXMCJwHj57j/PIh/r3k2IJalmtuauYxU2N
	 a9faneKGoWa58OYLTIOx5HiEsUyCwYqRijfzqE/SsLdzOcY11XxKwcC2OBRyVuCnBljPp
	 M+23wGjdu3nCV2WJwpJsnakWkwdwa6msOvU4tvSPGDsDRj8HJQLJ57aDitCw0q2HtWRSl
	 1YfU+IItCI3CJj8gBFOKu78wZ7cbtvq3DTtNC5UnO898JpBNNyB4WNoKUCoqaY5JxmSGY
	 n+deLI6tx1um+1Uq4Crjf+ZWZvztbnLD5m0jUHjsEC3uVNGx1uu0sAwjSN4Sg+RC3TA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215063;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6rY+n4BhajpaJnjktk8Y+MiKo9Ge+tYkSxrrkJikobc=;
	b=qzGF6tv2i6qBbT+iT73K5ySOKOxKj3ptqZ2GBqVxLL1fnyAjyPD6F/8VIfQiHorgpUK+
	 0xhms0SJmCEaaS6lhUiVxq6AyOUAU3oTZErgZycfE4Oi2gcH6WtWJMzmp7sn+R01Y1Rw3
	 Jtmz1iY2GdibtiXfgDDsOC+Q8Juq+j/B/tp2D1F6oHC0QYUzQb+ITv4gqLNnYBrKdqbzP
	 5ZzVISNEMl2KKbNjed9G2/0KbH30/PPdRztH7KCzzsFF3QTvgGYwyn9TsMdAMw38o5vbs
	 85qnBDTfgxKdt7oLShiYxCbxlF+AlhQbBgMmDTS5HBtirngHIKrxb8KXrbrXiecUPzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="yBBV6/ZA";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB58E606A31C;
	Wed, 28 Oct 2026 19:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yBBV6/ZA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37DC01F01825;
	Wed, 28 Oct 2026 19:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215062;
	bh=6rY+n4BhajpaJnjktk8Y+MiKo9Ge+tYkSxrrkJikobc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yBBV6/ZAJfbSYjC6S2AN7J68X8/TWxH/PVOQUxoitlEi/JO1FY2byxVDa6lUQhFqB
	 cDBP3L7pSFJ/kJpg4c0KziDH63x8DgLMy3PGpjtjVn6XWtyvQ61QyamtEqF8poAz88
	 UygKZpKjrpvvgsOKXFgWEJ9R/Od5vkRb2gFtnsxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1078/1887] erofs: unify lcn as u64 for 32-bit platforms
Date: Wed, 28 Oct 2026 17:52:54 +0100
Message-ID: <20261028170523.936279598@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit 2d8c7edcb661812249469f4a5b62e9339118846f ]

As sashiko reported [1], `lcn` was typed as `unsigned long` (or
`unsigned int` sometimes), which is only 32 bits wide on 32-bit
platforms, which causes `(lcn << lclusterbits)` to be truncated
at 4 GiB.

In order to consolidate the logic, just use `u64` consistently
around the codebase.

[1] https://sashiko.dev/r/20260420034612.1899973-1-hsiangkao%40linux.alibaba.com

Fixes: 152a333a5895 ("staging: erofs: add compacted compression indexes support")
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/zmap.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/erofs/zmap.c b/fs/erofs/zmap.c
index d2d7fe826091f..c120de200eb37 100644
--- a/fs/erofs/zmap.c
+++ b/fs/erofs/zmap.c
@@ -30,7 +30,7 @@ struct z_erofs_maprecorder {
 	struct erofs_map_blocks *map;
 	void *kaddr;
 
-	unsigned long lcn;
+	u64 lcn;
 	/* compression extent information gathered */
 	u8  type, headtype;
 	u16 clusterofs;
@@ -41,7 +41,7 @@ struct z_erofs_maprecorder {
 };
 
 static int legacy_load_cluster_from_disk(struct z_erofs_maprecorder *m,
-					 unsigned long lcn)
+					 u64 lcn)
 {
 	struct inode *const inode = m->inode;
 	struct erofs_inode *const vi = EROFS_I(inode);
@@ -245,7 +245,7 @@ static int unpack_compacted_index(struct z_erofs_maprecorder *m,
 }
 
 static int compacted_load_cluster_from_disk(struct z_erofs_maprecorder *m,
-					    unsigned long lcn, bool lookahead)
+					    u64 lcn, bool lookahead)
 {
 	struct inode *const inode = m->inode;
 	struct erofs_inode *const vi = EROFS_I(inode);
@@ -296,7 +296,7 @@ static int compacted_load_cluster_from_disk(struct z_erofs_maprecorder *m,
 }
 
 static int z_erofs_load_cluster_from_disk(struct z_erofs_maprecorder *m,
-					  unsigned int lcn, bool lookahead)
+					  u64 lcn, bool lookahead)
 {
 	const unsigned int datamode = EROFS_I(m->inode)->datalayout;
 
@@ -316,7 +316,7 @@ static int z_erofs_extent_lookback(struct z_erofs_maprecorder *m,
 	const unsigned int lclusterbits = vi->z_logical_clusterbits;
 
 	while (m->lcn >= lookback_distance) {
-		unsigned long lcn = m->lcn - lookback_distance;
+		u64 lcn = m->lcn - lookback_distance;
 		int err;
 
 		/* load extent head logical cluster if needed */
@@ -343,7 +343,7 @@ static int z_erofs_extent_lookback(struct z_erofs_maprecorder *m,
 			return 0;
 		default:
 			erofs_err(m->inode->i_sb,
-				  "unknown type %u @ lcn %lu of nid %llu",
+				  "unknown type %u @ lcn %llu of nid %llu",
 				  m->type, lcn, vi->nid);
 			DBG_BUGON(1);
 			return -EOPNOTSUPP;
@@ -363,7 +363,7 @@ static int z_erofs_get_extent_compressedlen(struct z_erofs_maprecorder *m,
 	struct erofs_inode *const vi = EROFS_I(m->inode);
 	struct erofs_map_blocks *const map = m->map;
 	const unsigned int lclusterbits = vi->z_logical_clusterbits;
-	unsigned long lcn;
+	u64 lcn;
 	int err;
 
 	DBG_BUGON(m->type != Z_EROFS_LCLUSTER_TYPE_PLAIN &&
@@ -416,7 +416,7 @@ static int z_erofs_get_extent_compressedlen(struct z_erofs_maprecorder *m,
 		fallthrough;
 	default:
 		erofs_err(m->inode->i_sb,
-			  "cannot found CBLKCNT @ lcn %lu of nid %llu",
+			  "cannot found CBLKCNT @ lcn %llu of nid %llu",
 			  lcn, vi->nid);
 		DBG_BUGON(1);
 		return -EFSCORRUPTED;
@@ -426,7 +426,7 @@ static int z_erofs_get_extent_compressedlen(struct z_erofs_maprecorder *m,
 	return 0;
 err_bonus_cblkcnt:
 	erofs_err(m->inode->i_sb,
-		  "bogus CBLKCNT @ lcn %lu of nid %llu",
+		  "bogus CBLKCNT @ lcn %llu of nid %llu",
 		  lcn, vi->nid);
 	DBG_BUGON(1);
 	return -EFSCORRUPTED;
-- 
2.53.0



