Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053024;
	b=Vdxly9ubHEhxd/zOlfAKV7lxuEmRL80PJgvtqDoCsDjsvbEohvomyUQ2gXYClzaUyNyg
	 LtVwjx9+bWVXLMaK8UKc631w45tFPp+o2eTXYEcLCzbCvlGpyKiPYzQelF8yFY2TVs9sS
	 XcgNSQ1uix3whiIa9PdIy1CPWCrf/zwldWikbueaLwAhhTpejj7zrbALdmTiY1D5MggiR
	 W8b/HQDgOLJJeRe8wHSgLwY/6BHYmIqf7fAlrP9VivWU1gA9tPLdu8CaQeK5fHRq6tv46
	 gWv7W2nVl/8Zme5WwWVK5f1xKaf73UPTwz3vNn3tC/XTwvrh+W5p2e7OUvCnV4MEtgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053024;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i9JJRsGX5WUS+kw5TReV3cdYpTsj0ZDBsaV/rjj6Ok8=;
	b=OPLPX9cAVwpnrbq60OGJBWORCCntuIV5XgYt7LWI5BxVglD9GjQuRdO/eaWDnfFsaFdR
	 B/h7rT+9tMZdKoiisVErO5hXHoeYTO9B0ef7PJWbC1ucKmUCf9t5aeSilCFsVAs1jp+kH
	 GhDGnd6ogsLcjd5rC0/67Kpc5unB2CvNvSaLCeZOXNWUEYF/xv5XSwDu8cpBOLVNZPaTi
	 AIuJwP05YN78J0smyP3wpcR5nrpZQCJUUpn84vuoNBvCzQLEj9IKgZoebCOvltW984mFB
	 Vy0+4UdTVgy2z8xN1oYE6ipXQ44OkPbupUe2pUqHPP0tfr5FbAdciFBr6GnkIezFWkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="CPd/xhWZ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C955606A320;
	Thu, 19 Nov 2026 01:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CPd/xhWZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CA221F000C4;
	Thu, 19 Nov 2026 01:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053024;
	bh=i9JJRsGX5WUS+kw5TReV3cdYpTsj0ZDBsaV/rjj6Ok8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CPd/xhWZztlh8O3OTUqCosHUpxnT3ieOhshp3md8vK3pDCzJu8b7U9UOuOxh2Mx0V
	 SCm7XZpQuvp3Tu1rpk2IrSOwDbfTMyQy3b1Q7syZsW/sGuZ3QPT7ezrng9j+sdgaXN
	 YCLI0DrqbFx811K59r3KqQugsiIdWWLUK7ZALeFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0771/2214] xfs: bound inode fork length against the fork size during log recovery
Date: Wed, 18 Nov 2026 15:40:47 +0100
Message-ID: <20261118150042.518215451@linuxfoundation.org>
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

[ Upstream commit 9232301894a06e664d8de2da97175cf98419bd16 ]

xlog_recover_inode_commit_pass2() copies an inode log item's data/attr
fork region into the inode buffer using the on-log region length without
bounding it against the fork capacity, e.g.:

	len = item->ri_buf[2].iov_len;
	memcpy(XFS_DFORK_DPTR(dip), src, len);

The only guard is an ASSERT, which is a no-op on production kernels
(CONFIG_XFS_DEBUG off), and xfs_dinode_verify() runs only after the copy.
A crafted image with a dirty log can therefore drive a heap out-of-bounds
write at mount time. The XFS_ILOG_DBROOT sibling already passes
XFS_DFORK_DSIZE as a bound; the DDATA/DEXT and ADATA/AEXT memcpy paths
did not.

Bound each logged fork region against the destination fork size before
copying it, and reject the log item with -EFSCORRUPTED when it does not
fit. Because the recovered inode is only verified after the fork data has
been copied in, the checks are done up front, before any memcpy into the
on-disk inode.

Fixes: 658fa68b6f34 ("xfs: refactor log recovery inode item dispatch for pass2 commit functions")
Cc: stable@vger.kernel.org # v5.8
Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
[ sashal: Changed two iov_len accesses to i_len to match struct xfs_log_iovec recovery buffers. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_inode_item_recover.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index 239dd2e3384ec..2e82ee4b404b5 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -403,6 +403,25 @@ xlog_recover_inode_commit_pass2(
 	ASSERT(!(fields & XFS_ILOG_DFORK) ||
 	       (len == in_f->ilf_dsize));
 
+	/*
+	 * The recovered inode is verified only after the fork data has been
+	 * copied into it, so bound each logged fork region against the size of
+	 * its fork now, before the memcpy below can overrun the on-disk inode.
+	 * The DBROOT/ABROOT cases already bound their copies against the fork
+	 * size.
+	 */
+	if ((fields & (XFS_ILOG_DDATA | XFS_ILOG_DEXT)) &&
+	    item->ri_buf[2].i_len > XFS_DFORK_DSIZE(dip, mp)) {
+		error = -EFSCORRUPTED;
+		goto out_release;
+	}
+	if ((fields & (XFS_ILOG_ADATA | XFS_ILOG_AEXT)) &&
+	    item->ri_buf[(fields & XFS_ILOG_DFORK) ? 3 : 2].i_len >
+	    XFS_DFORK_ASIZE(dip, mp)) {
+		error = -EFSCORRUPTED;
+		goto out_release;
+	}
+
 	switch (fields & XFS_ILOG_DFORK) {
 	case XFS_ILOG_DDATA:
 	case XFS_ILOG_DEXT:
@@ -442,7 +461,6 @@ xlog_recover_inode_commit_pass2(
 		case XFS_ILOG_ADATA:
 		case XFS_ILOG_AEXT:
 			dest = XFS_DFORK_APTR(dip);
-			ASSERT(len <= XFS_DFORK_ASIZE(dip, mp));
 			memcpy(dest, src, len);
 			break;
 
-- 
2.53.0



