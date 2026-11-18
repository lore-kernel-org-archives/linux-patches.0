Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046414;
	b=WD6GH8HDEiVwgY0JIf2GkREdamy+qMxK4INoKd/o9T+W16kGYlnNAsewRfGvnt8RHnkq
	 kUckbqCHI2AMSd5mejvTH3kkX1dX/W5j7B04e5Ys3fry7co0j+K4Qs+9L4cu9d63r1+Sa
	 nDZw+dHIarMRvXn6SR8d4A6iDTvbeDcqPd2vm1UTZMIZ84dUCrqmX1AfkEQnf4afsobvA
	 fJG9kH2nX7TNQhhiL+jwd18zXvbhXdpB1HeRB1D/cIfNhhPgYHvtccDu0wvmVIqA/z/Cw
	 6SPiYBmeZVSvRhJ/mHVZPZkCyyz3XpSCmk+FwJ3dur4RDwih9hVOP7yCKPvcAgX13cQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046414;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oJx1mB6XsTDdoAchzwkVue97k/TFX0B97jajWpN9GFQ=;
	b=4LtwwZ+C65OXCBK+7Qa09EsYvMeG61/1GGFZu/hwmnBPVtWiYzNeOOpIYJdtivWkywuR
	 +wsKv08O1oSU/Du8cARfp1zG0DQCXcYP5Tty37DiHtFk8JNm8I7Cnr3Tzmul+gDzMQJbp
	 Y8MUOVRaqsVi3pBx1UXCXKhtMtmC1Nr1SsDYbYJEXT6rrBIyALJ591/2evrn/fL1CUqWP
	 ztWRrWRI+aqlVaqmxt/MkKKl8eFtQZrhGEqU9UPq/Fzype9PRgYGnQ3I06ipw3fOuidvS
	 SCDf+HaYWfM8seHS6dWkAWWcAlBDm7BfMSMhV+qtUqn02x0yF79dqyT51WVnIQ3C4Nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sQqoh3xL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A04060A2612;
	Thu, 19 Nov 2026 00:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sQqoh3xL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 799471F000CA;
	Thu, 19 Nov 2026 00:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046414;
	bh=oJx1mB6XsTDdoAchzwkVue97k/TFX0B97jajWpN9GFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sQqoh3xLXQ9n8Q0FZjCh21+5UyDE8CmArfOGHWfCOiaDDzaU1w2QVQUl2hxxxWlj1
	 yKVKzzUzC8h7EikTDsD6khL2NIi5Z/s1nsnp9IoB/g3ZFg+wj8iVB9Rp5m1uPIdFzt
	 7hKQLs02Ule4zE3q4jomQ7iEI0WhgkNhA2D7srPk=
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
Subject: [PATCH 6.1 1272/2857] xfs: mark the inode preallocated for pNFS write layouts past EOF
Date: Wed, 18 Nov 2026 15:38:26 +0100
Message-ID: <20261118150247.317926253@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index 38d23f0e703a8..d74133c3d784d 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -101,7 +101,15 @@ xfs_fs_map_update_inode(
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
@@ -126,6 +134,7 @@ xfs_fs_map_blocks(
 	uint			lock_flags;
 	int			error = 0;
 	u64			seq;
+	bool			update_inode = false;
 
 	if (xfs_is_shutdown(mp))
 		return -EIO;
@@ -194,20 +203,27 @@ xfs_fs_map_blocks(
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



