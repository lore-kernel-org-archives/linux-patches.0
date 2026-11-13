Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585721;
	b=ywsqSTAO/z9Atd28j8eNmoe1GktFtcENBgHn5QrSV4fKoVdYk/BVWwtR3mPg/Jt4Jjvy
	 Wecucld4b4CCjiZ3Cydrovj8Froo2xIKvkbBQds1h5yBd5i415GWx7bJ43F/8Nfpqk1Tj
	 QGdIg6Ca9uY0ks1utPd5wEt0odk8rA8MTi3wQMe+KuEo7h6vH9ru77xikeWPxMKAXSpX9
	 HzeUCKMJbnZk/BZXaoEHh1lNDsta6E9WaTkXbCVyZ4EWolzPFkoWpFgnLd0/qgePunGxT
	 dS5eoOdjMZqCs4a32HXkDLya453Tt1yt/RZv7OmsxVZF8kbHNQ3h6Sf5DGzFGGM6yVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585721;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0fGw8dGxrhSsKdo8FVl36BmT8dbKDNJTIZv72Z92Yqg=;
	b=Dt7FUXQ4cN+s9ac624BGl9THWBlMgxyswZ2Kz+XngXsyACr3O1PHqxyWDy80xmEa4b8O
	 BjjXpaov8C4kPF2qnGv+cil4BNK5JdhlHh6DNzPDIo5Xyx2NwIHQnvtQEpk16HR8c/LaS
	 J48OMScY1LE1UHCzFk2Cdo5pGiWJDqegURVRkwWiw0+92GSYs3kMiv0Iy6DHqMYlOnKr5
	 r+47JhOxtNIDNtnVx8cD6Vo4sByKtvRpMmGU5woe1CAS5mX32GXpAPTBtKYiMrOfv30B5
	 +avxT+cFQSgyA+A+XIjmWc+Jgd8cOgq8PYbESfijWLwgMJOqOHx63f0YpZ07jeviFiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rx2eyXT1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64A5F606A33E;
	Fri, 13 Nov 2026 16:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rx2eyXT1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14D951F000C4;
	Fri, 13 Nov 2026 16:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585721;
	bh=0fGw8dGxrhSsKdo8FVl36BmT8dbKDNJTIZv72Z92Yqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rx2eyXT1QZ4r9nSXELQF0qL/YNPZxGFemWDvFTlGtQXF5NsFSv3A3WD3yqX0VKO1F
	 ygH6W1d0n5pEEnF6Q8KPwDayLgclDwxGC8048/EQVTfeSIW19MJEIZzgjw+mcVfjjO
	 5rnGVO9EvSHoIe5XOvCVy4Z+r7QsIoya4JNaVQwo=
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
Subject: [PATCH 7.3 281/507] xfs: mark the inode preallocated for pNFS write layouts past EOF
Date: Fri, 13 Nov 2026 10:49:45 -0500
Message-ID: <20261113153804.657060333@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index ab385617003a2..a9f0b472f3076 100644
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
@@ -134,6 +142,7 @@ xfs_fs_map_blocks(
 	uint			lock_flags;
 	int			error = 0;
 	u64			seq;
+	bool			update_inode = false;
 
 	if (xfs_is_shutdown(mp))
 		return -EIO;
@@ -221,20 +230,27 @@ xfs_fs_map_blocks(
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



