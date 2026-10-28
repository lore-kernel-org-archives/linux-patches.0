Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217352;
	b=qGaT/Uuztrl6IcyeSgSNPfP2wd0WqAyq63KCaJN6Kch6r+BWG9bOyI0hzQj40yr44uIR
	 GxIalDdlFrrNMeAkFELBxX9QRwXnmDoh3D5+nZltNt2ZV74+4gs+preaIw7BAAh+PqtI2
	 ZLfBM1/zY7os4XtDGHih6SG2/mUhREt+WxtxhRbEJjUecBAYDIhic3r6bw7Gh2tLe3mcs
	 TwWSiY/8jBG6al3Dkbc06YjnV/vFHtCt76oeHtuw1YIBvf8Gi/5qFAxdtD23KIxvD//Jw
	 nSKjz4GlXHhaSmJGzzNmUDgyq9L+V3/m+hJ3l79sjsn71RNFSDCKTGBSJT4xOIviIzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217352;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hLJO/y7kY5Hae4ctSF0JBTDUbb2WugnNZVH5d8ZK1OU=;
	b=h6D8SNkv2Z/ud9ung+SNT5mjYMcLio8jUgbNs1auqZ3tv6KAEUqsNWVPOVvSDEc158w+
	 tiYbxpjIm2LWbiVP7QLWTU4eidWVHsjBQjjWsTBnVYhqDJ1g057V+enHIA4g9nCLgUWQY
	 RqjhEtbHvVSwpzi1Ado9uX6mDPadyVp66CuoMDhEygDvRV84mlraKLanW6BT7VUr+w9cY
	 cPtNW2dlkyMdeEmF3wIBrDZOjS5Hkjgy2RtQeqAIEvsKYgmN3/EIq2gvobywq9Zru0Y5S
	 NIiV0zv/OncaS+W2NwTyxpZVb7pdypDGVqy5xIxwQ75NPkvC/NmNChvde0ome2wh8aA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cr2pDfqa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18830606A31A;
	Wed, 28 Oct 2026 19:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cr2pDfqa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E6231F01825;
	Wed, 28 Oct 2026 19:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217351;
	bh=hLJO/y7kY5Hae4ctSF0JBTDUbb2WugnNZVH5d8ZK1OU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cr2pDfqaBKGzPQWSeRYL4ONnUHSCdD1wfpfl9DPyjmKEY1gqNwjMyMm7DoJSGVi4n
	 4xHjm1kJGPQb/e7AG8Gfy5jy4hvWzDYTlAh9FjNH/7y41x6uh5Lqj/vpXHyLMmSvUT
	 u8w/qDOXI2vSaLBHGPd37Jn0pCumC6oitnsucfB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1872/1887] ocfs2: use correct endian in ocfs2_dinode_has_extents
Date: Wed, 28 Oct 2026 18:06:08 +0100
Message-ID: <20261028170542.055461948@linuxfoundation.org>
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

From: Joseph Qi <joseph.qi@linux.alibaba.com>

[ Upstream commit c9dff86eb78a4b6b02b1e407993c946ccaf9bfb4 ]

Fields in ocfs2_dinode is little endian, covert to host endian when
checking those contents.

Link: https://lkml.kernel.org/r/20251025123218.3997866-1-joseph.qi@linux.alibaba.com
Fixes: fdbb6cd96ed5 ("ocfs2: correct l_next_free_rec in online check")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/inode.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/ocfs2/inode.c b/fs/ocfs2/inode.c
index 10c2759e16e85..3d96cc7fc5070 100644
--- a/fs/ocfs2/inode.c
+++ b/fs/ocfs2/inode.c
@@ -236,13 +236,15 @@ struct inode *ocfs2_iget(struct ocfs2_super *osb, u64 blkno, unsigned flags,
 static int ocfs2_dinode_has_extents(struct ocfs2_dinode *di)
 {
 	/* inodes flagged with other stuff in id2 */
-	if (di->i_flags & (OCFS2_SUPER_BLOCK_FL | OCFS2_LOCAL_ALLOC_FL |
-			   OCFS2_CHAIN_FL | OCFS2_DEALLOC_FL))
+	if (le32_to_cpu(di->i_flags) &
+	    (OCFS2_SUPER_BLOCK_FL | OCFS2_LOCAL_ALLOC_FL | OCFS2_CHAIN_FL |
+	     OCFS2_DEALLOC_FL))
 		return 0;
 	/* i_flags doesn't indicate when id2 is a fast symlink */
-	if (S_ISLNK(di->i_mode) && di->i_size && di->i_clusters == 0)
+	if (S_ISLNK(le16_to_cpu(di->i_mode)) && le64_to_cpu(di->i_size) &&
+	    !le32_to_cpu(di->i_clusters))
 		return 0;
-	if (di->i_dyn_features & OCFS2_INLINE_DATA_FL)
+	if (le16_to_cpu(di->i_dyn_features) & OCFS2_INLINE_DATA_FL)
 		return 0;
 
 	return 1;
-- 
2.53.0



