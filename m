Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061680;
	b=l4Mw5P6Lk8VzYTPV+bLiSduEpAB+qbNOqN1xsNDASR1Y5O+azMV43pONZ6aA9wi6LAVE
	 +3nnxl3NXyYd+0JtZDJ/msa6FMRIhpTE7gpuTHFK94iyZBT9RAt2r0rVm3mRddmuiuGkx
	 ZP2CF6JRaT6n4B9pN5QdjyjMsOHIdmzANbdPh9PCz35ePg6JFQKBja4gZ5Mv8qQS8kz8W
	 s5s0ERzOvRN8+lg4NmIKdV94NmPz+wN51fxGSAXma7YNhfSwA9yUUIoHv2si3mJLkYUBI
	 LgxwVk9K9yjKYoUPxLhanRE8DhcGhp/HJCVwQ00HWyNYSLlsFImMJcWoLXBv5b6oH9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061680;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cB7LMLizNmexMKoEzFGV2+FYf26ayD2swAzalKasjMY=;
	b=G7lEttScFa5Wz7II3JczLIBkFy/CTnRUY3Zh4O6MiUbOc4JeZMdaGfHzV2Hkx1hwKBTe
	 Tqkifn0vsw+oTrzilsil3tX3yMQaGnwAnEt2Yk1yrrOOHRHMUY28eDz+tDUBIyCyBdBTT
	 uyfrxxzvJ+0d906cRUpvQdqEcKGz5HDhGY5/Ky3fdSqGHblZlM48/esOoqC+52oYkUAqV
	 wo8H5SEsVWf7zxjZ4Vn8ZZo/LXp1vl75BwjqgmOmT0pW/aFpcmoJyoF1ldAw77lII2eii
	 id1g8GX18eNhzGVUsU38ubadmOGklciHT+22MRUnGAQVEI+sY4CeYgZeL04yRhxVa7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="iZy3eEp/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3486F606A330;
	Sat,  7 Nov 2026 14:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iZy3eEp/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA4D41F0089F;
	Sat,  7 Nov 2026 14:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061679;
	bh=cB7LMLizNmexMKoEzFGV2+FYf26ayD2swAzalKasjMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iZy3eEp/Vjvrw85zgZIkg8X5zxyK2UmtNSbk5CJvV4/6s6c8hHWs9I7hAl+XTFxiM
	 7LVwqMiPj42/EDEhzt99w1Fsl0fh3nn72jznCYhF0JH7umsd9Gu+MYaU9UIKVBUIvL
	 hlgpbPBMl/vk9DiHxDxY7efvQmGfu3Gjtul5/qkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 0731/1536] xfs: bound inode fork length against the fork size during log recovery
Date: Sat,  7 Nov 2026 08:45:47 -0500
Message-ID: <20261107135018.037555085@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>

commit 9232301894a06e664d8de2da97175cf98419bd16 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_inode_item_recover.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -468,6 +468,25 @@ xlog_recover_inode_commit_pass2(
 	ASSERT(!(fields & XFS_ILOG_DFORK) ||
 	       (len == xlog_calc_iovec_len(in_f->ilf_dsize)));
 
+	/*
+	 * The recovered inode is verified only after the fork data has been
+	 * copied into it, so bound each logged fork region against the size of
+	 * its fork now, before the memcpy below can overrun the on-disk inode.
+	 * The DBROOT/ABROOT cases already bound their copies against the fork
+	 * size.
+	 */
+	if ((fields & (XFS_ILOG_DDATA | XFS_ILOG_DEXT)) &&
+	    item->ri_buf[2].iov_len > XFS_DFORK_DSIZE(dip, mp)) {
+		error = -EFSCORRUPTED;
+		goto out_release;
+	}
+	if ((fields & (XFS_ILOG_ADATA | XFS_ILOG_AEXT)) &&
+	    item->ri_buf[(fields & XFS_ILOG_DFORK) ? 3 : 2].iov_len >
+	    XFS_DFORK_ASIZE(dip, mp)) {
+		error = -EFSCORRUPTED;
+		goto out_release;
+	}
+
 	switch (fields & XFS_ILOG_DFORK) {
 	case XFS_ILOG_DDATA:
 	case XFS_ILOG_DEXT:
@@ -507,7 +526,6 @@ xlog_recover_inode_commit_pass2(
 		case XFS_ILOG_ADATA:
 		case XFS_ILOG_AEXT:
 			dest = XFS_DFORK_APTR(dip);
-			ASSERT(len <= XFS_DFORK_ASIZE(dip, mp));
 			memcpy(dest, src, len);
 			break;
 


