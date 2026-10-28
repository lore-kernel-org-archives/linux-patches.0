Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214811;
	b=BHgUA+b5KS0Znc9ouuzYwgG2vreo1B4WQJB87Oq3KDn+Y9BH8D2e52DlrZYPR9HdPmH1
	 oH8UmI+Wa169NnI6OVcrgg61hUgYZ9jzMQY8w3NvfjP7TYQGb4P6Il+px7cQqw4PWRUws
	 MZ7TKCuWVnbRa1j+YKyGI/Dhoc12t36Kn5D0W4WBZibzl+H9QfVTWH9CcnzeyGC8ekuHk
	 gIM3jbD6LLBwQxfgrQWvjdl9Wb0gKF6yKXd+bkerDkoUcutzkREDtZ2zcUmljr6Z0fOw3
	 w6rwUZldpDPL7z6PcgVWiyMafLT51IhuVqBrmarLu0pU0LnCYINOaLQem5i17g/s5Cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214811;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w9Fd8XtFBfhItSooS3tvpJGHnF70Jrp4ArtwWCC/ybw=;
	b=WPqbopOMuEhu2doeZwAPOtD3R8Dpin2FgTZrcpFZ0vSiDVhuIstJgSkH4cIgtsW8FCTv
	 Aibcnv1pcz2Bjp4VGCNPo1V9dLpuOBqzBd7L4JvV91b2vN0wPjrYkXjvb5qV66g8gL4xg
	 nmOTsNkDDrh7fSnL4BfzIGeHT0nML4C90qnTCVvNaYxo55oXbmP760PKw9LkDbUFC9O73
	 cRD11Mv0Tajg9O/pplfE4EP3fcXcDRfwIcv/oTGG8cbvJv+VJN3Jh8tiPoeEblD7bP0RA
	 ZFMvLGh7owsrRaGUZ4DeYX/pXgQlrgAfFBdAm/QTg2SGs0zHlvaD0gjjOb2gHRMXqEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nGBxVf7V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC945606A33B;
	Wed, 28 Oct 2026 19:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nGBxVf7V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7AFD1F01825;
	Wed, 28 Oct 2026 19:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214810;
	bh=w9Fd8XtFBfhItSooS3tvpJGHnF70Jrp4ArtwWCC/ybw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nGBxVf7V2kcdvw4NMozwVWnWq5dqfeiWG4ia+KJ5X2VMq+ZddYdgwNOMz+//QQZPt
	 MxycMmHXEhgdRhBcE4LoWwQF4x4oHBsHDF9y/kpOjMJ8lEBYVY1PGcs4/W9SR+TpMp
	 crLY4Xw4AX48/Z+kAe/ZZRpQqrhb6Zo5kcMDPf1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Tinguely <mark.tinguely@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0988/1887] xfs: remove xfs_attr_leaf_hasname
Date: Wed, 28 Oct 2026 17:51:24 +0100
Message-ID: <20261028170521.893884254@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 3a65ea768b8094e4699e72f9ab420eb9e0f3f568 ]

The calling convention of xfs_attr_leaf_hasname() is problematic, because
it returns a NULL buffer when xfs_attr3_leaf_read fails, a valid buffer
when xfs_attr3_leaf_lookup_int returns -ENOATTR or -EEXIST, and a
non-NULL buffer pointer for an already released buffer when
xfs_attr3_leaf_lookup_int fails with other error values.

Fix this by simply open coding xfs_attr_leaf_hasname in the callers, so
that the buffer release code is done by each caller of
xfs_attr3_leaf_read.

Cc: stable@vger.kernel.org # v5.19+
Fixes: 07120f1abdff ("xfs: Add xfs_has_attr and subroutines")
Reported-by: Mark Tinguely <mark.tinguely@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c | 74 +++++++++++++---------------------------
 1 file changed, 23 insertions(+), 51 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 32d350e97e0f6..236291dbb427f 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -49,7 +49,6 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args);
  */
 STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
 STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
-STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
 STATIC int xfs_attr_leaf_try_add(struct xfs_da_args *args);
 
 /*
@@ -866,11 +865,11 @@ xfs_attr_lookup(
 		return xfs_attr_sf_findname(args, NULL, NULL);
 
 	if (xfs_attr_is_leaf(dp)) {
-		error = xfs_attr_leaf_hasname(args, &bp);
-
-		if (bp)
-			xfs_trans_brelse(args->trans, bp);
-
+		error = xfs_attr3_leaf_read(args->trans, args->dp, 0, &bp);
+		if (error)
+			return error;
+		error = xfs_attr3_leaf_lookup_int(bp, args);
+		xfs_trans_brelse(args->trans, bp);
 		return error;
 	}
 
@@ -1246,27 +1245,6 @@ xfs_attr_leaf_try_add(
 	return error;
 }
 
-/*
- * Return EEXIST if attr is found, or ENOATTR if not
- */
-STATIC int
-xfs_attr_leaf_hasname(
-	struct xfs_da_args	*args,
-	struct xfs_buf		**bp)
-{
-	int                     error = 0;
-
-	error = xfs_attr3_leaf_read(args->trans, args->dp, 0, bp);
-	if (error)
-		return error;
-
-	error = xfs_attr3_leaf_lookup_int(*bp, args);
-	if (error != -ENOATTR && error != -EEXIST)
-		xfs_trans_brelse(args->trans, *bp);
-
-	return error;
-}
-
 /*
  * Remove a name from the leaf attribute list structure
  *
@@ -1277,25 +1255,22 @@ STATIC int
 xfs_attr_leaf_removename(
 	struct xfs_da_args	*args)
 {
-	struct xfs_inode	*dp;
-	struct xfs_buf		*bp;
+	struct xfs_inode	*dp = args->dp;
 	int			error, forkoff;
+	struct xfs_buf		*bp;
 
 	trace_xfs_attr_leaf_removename(args);
 
-	/*
-	 * Remove the attribute.
-	 */
-	dp = args->dp;
-
-	error = xfs_attr_leaf_hasname(args, &bp);
-	if (error == -ENOATTR) {
+	error = xfs_attr3_leaf_read(args->trans, args->dp, 0, &bp);
+	if (error)
+		return error;
+	error = xfs_attr3_leaf_lookup_int(bp, args);
+	if (error != -EEXIST) {
 		xfs_trans_brelse(args->trans, bp);
-		if (args->op_flags & XFS_DA_OP_RECOVERY)
+		if (error == -ENOATTR && (args->op_flags & XFS_DA_OP_RECOVERY))
 			return 0;
 		return error;
-	} else if (error != -EEXIST)
-		return error;
+	}
 
 	xfs_attr3_leaf_remove(bp, args);
 
@@ -1319,23 +1294,20 @@ xfs_attr_leaf_removename(
  * Returns 0 on successful retrieval, otherwise an error.
  */
 STATIC int
-xfs_attr_leaf_get(xfs_da_args_t *args)
+xfs_attr_leaf_get(
+	struct xfs_da_args	*args)
 {
-	struct xfs_buf *bp;
-	int error;
+	struct xfs_buf		*bp;
+	int			error;
 
 	trace_xfs_attr_leaf_get(args);
 
-	error = xfs_attr_leaf_hasname(args, &bp);
-
-	if (error == -ENOATTR)  {
-		xfs_trans_brelse(args->trans, bp);
-		return error;
-	} else if (error != -EEXIST)
+	error = xfs_attr3_leaf_read(args->trans, args->dp, 0, &bp);
+	if (error)
 		return error;
-
-
-	error = xfs_attr3_leaf_getvalue(bp, args);
+	error = xfs_attr3_leaf_lookup_int(bp, args);
+	if (error == -EEXIST)
+		error = xfs_attr3_leaf_getvalue(bp, args);
 	xfs_trans_brelse(args->trans, bp);
 	return error;
 }
-- 
2.53.0



