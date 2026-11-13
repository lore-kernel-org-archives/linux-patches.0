Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590384;
	b=oftcIyv73wnFkkoeIhx2z3EWTmzmUiTSMbAbMxkYe+vmiDjzkBCAuZspoyZEsuO6iE32
	 Fl0F+UrthH8IVaNs7X/fO+qzFQum5dTyqpMDuUwi4S04IOMw0YHBrRktKJ1bUyjsKSQcW
	 kTg9le7tZdhb4Qg6TPg5kuMYSMqYPxEtxxy3TZf/d0oskfz0fVT8L5YZF6JgN5mfAH/Q8
	 cKjwNKUiTCuj84KmRabxwV7dgF/lYv6Pcq71r64p7hvWfDhdyBwSmkLsqonjCdOg6aWei
	 OrHJiS8OrmAcA70K/ZSafaCIy4naehLSCJe2JVymAi2sZRhWuDX3pEZeg/3vxpFEcKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590384;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gorjbV6YWVYw9Z1Pffw0UsQIcWS2b0vGQdWkASRdLpk=;
	b=BfUq8FaZrqP9jjlbZJh4S0hNnzq2Gt0pWvZCUhHjEEdKzV1H8CAMxEHAue0E/RC9zR5g
	 WW6YEiRx8IYZ8YtLu4X5z2n3IR1aAp9i1s/uSFV8HSWGbN084TjL1gC+nAq+32EUSGh+4
	 Z+A8DsDYIydKWarkicdg/STEs+ydIrmDOP0+AaUtMAGbllsSkVHZF+1qtTkL807pV+A+s
	 HM5uKtDZk4CZAcHzDv5DnXF2183Loacs16A5a95+WnUGG7kE7byBaMNN3AV6EAKhS8BqO
	 kG4zXT7Qm6WDl0VmnHB2iSy/Wd1atNW+qEBi2F6NQsPTCWavMDlO/kePTqhpdYC52rg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MekjiUXj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C05460A2616;
	Fri, 13 Nov 2026 17:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MekjiUXj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EB7D1F000C6;
	Fri, 13 Nov 2026 17:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590384;
	bh=gorjbV6YWVYw9Z1Pffw0UsQIcWS2b0vGQdWkASRdLpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MekjiUXj+Z3FUYjli3DxmUlJRaeJYPztIGH/JtV/yWX7XoEX3I/HNRlUtQUQmXCF2
	 ZrG31c2HrLFHNXg6E0cgSNnbD5daVPa8EI1rH+AMQVcTdoMAoEiFsKLUS1DTqkruqC
	 CWee/S52O1HrzVaVIq5qKUcpF8Lislo16uyHDtGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>,
	Daejun Park <daejun7.park@samsung.com>,
	Christoph Hellwig <hch@lst.de>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 354/686] xfs: mark the inode preallocated for pNFS write layouts past EOF
Date: Fri, 13 Nov 2026 10:48:07 -0500
Message-ID: <20261113153832.913123244@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daejun Park <daejun7.park@samsung.com>

[ Upstream commit 8b8e265991556d99b6d721697f148975a7c68767 ]

xfs_fs_map_blocks() marks the inode XFS_DIFLAG_PREALLOC only when it
allocates blocks for a write layout. A write layout past EOF can also
hand out allocated blocks, such as speculative preallocation. blockgc
then frees them under the layout, and another file may get them.

Mark the inode whenever a write mapping ends past EOF.

Fixes: 527851124d10 ("xfs: implement pNFS export operations")
Cc: stable@vger.kernel.org
Reported-by: Chuck Lever <cel@kernel.org>
Link: https://lore.kernel.org/r/4de5356f-bc4d-4f1a-9c81-fce09b1b46fd@slotpi15m67
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_pnfs.c | 34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index 1b0b739571612..ef08f0f619f70 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -110,7 +110,15 @@ xfs_fs_map_update_inode(
 	ip->i_diflags |= XFS_DIFLAG_PREALLOC;
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	return xfs_trans_commit(tp);
+	error = xfs_trans_commit(tp);
+	if (error)
+		return error;
+
+	/*
+	 * Force the log so that the blocks handed out to the client are
+	 * guaranteed to be present even after a server crash.
+	 */
+	return xfs_log_force_inode(ip);
 }
 
 /*
@@ -135,6 +143,7 @@ xfs_fs_map_blocks(
 	uint			lock_flags;
 	int			error = 0;
 	u64			seq;
+	bool			update_inode = false;
 
 	if (xfs_is_shutdown(mp))
 		return -EIO;
@@ -203,20 +212,27 @@ xfs_fs_map_blocks(
 				end_fsb - offset_fsb, 0, &imap, &seq);
 		if (error)
 			goto out_unlock;
+		update_inode = true;
+	} else {
+		xfs_iunlock(ip, lock_flags);
 
 		/*
-		 * Ensure the next transaction is committed synchronously so
-		 * that the blocks allocated and handed out to the client are
-		 * guaranteed to be present even after a server crash.
+		 * Blocks past EOF that were allocated for buffered writes, such
+		 * as speculative preallocation, can be freed by
+		 * xfs_free_eofblocks() without breaking the layout unless the
+		 * inode is marked as preallocated. Mark it before handing them
+		 * out for writing, as for blocks allocated above.
 		 */
+		if (write && !(ip->i_diflags & XFS_DIFLAG_PREALLOC) &&
+		    imap.br_startoff + imap.br_blockcount >
+		    XFS_B_TO_FSB(mp, XFS_ISIZE(ip)))
+			update_inode = true;
+	}
+
+	if (update_inode) {
 		error = xfs_fs_map_update_inode(ip);
-		if (!error)
-			error = xfs_log_force_inode(ip);
 		if (error)
 			goto out_unlock;
-
-	} else {
-		xfs_iunlock(ip, lock_flags);
 	}
 	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 
-- 
2.53.0



