Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054536;
	b=Bzl7ZlmtAsd6VFKrUdR4CQH+UWfH3DzHEvqrofW9rcAJIW076xYobVrb7qbnGceDfN5p
	 SC6JwfSCrjmO+FRP+DKWJZg6uCvHnItV9e4ftO5kCjKx7PpU0uJWt0Qsb567r5QoQP6Od
	 wvn4SMVqPaIcrrOETT680xDu2tiS/L9qhMiIYBhNVRj7+CUgTMV8o+Ki+KW+VZePZrUdm
	 PgWpIUZY7gbLkDosU0uQ9kKzzHb59SweoI1C9HGcjZOVVOhKXGQUf45B2ZpwhvG7l4KIw
	 4M1BS20dHDxFBY7hMSr2+X0Iuwoc1O4zGCiY5pwDoDEpwFbIOKST3A+/FLoQ41GJc9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054536;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JfjyxeLPtg6+TVTLepaWkNa0Dx29xTi8aLuW+tcMFbA=;
	b=YPixFoxQrxGLtrp4X0Pv33Nr1DbgAZbrkO82aztRATP5Vgfr7iKB101pkGfImaHjJDSr
	 PsUBxo9YO+5QjAdsroRBZMWIvP+YO1w2CMVq8veIaQe8L261vnNBCXNd/VdEvCkzovr9/
	 k1Fct2h5klmYiNqG/KjmqlLkjJP29lTtw1W08V+Y2UF8uvxppMkmQk6+E23YtzgffTPjW
	 h252pkEAkDEPvNbBcJurlnU+xtBkAS1nmln5eJ1bVNGf2NOm16dHgAjU6YO+yfAHyScwo
	 BgFoUVhlnnFAXBsEm3Pz5I4Myjwsk2mPCCqjzCX17dtqXOEr3bKDIyXEMXyTowG6z5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="x/crRJ4q";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09AAA606A325;
	Thu, 19 Nov 2026 02:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x/crRJ4q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 633751F000C4;
	Thu, 19 Nov 2026 02:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054535;
	bh=JfjyxeLPtg6+TVTLepaWkNa0Dx29xTi8aLuW+tcMFbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x/crRJ4qAVnndqxCZZ/E+zZz6wR62vqSfJJj7eFoXSPv1p3qrFJ0ZHZyFvCHovit6
	 Sylk0Es36VglcJW9YDXYg9FqWxh9RUOOs7CGQSBwScdn2oTVlAa3R1XLeK9b3z9WR9
	 rNjiDT0r4sUyBj+jvBmAdbPkvnap+XnKMklfX/zI=
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
Subject: [PATCH 5.15 1309/2214] xfs: mark the inode preallocated for pNFS write layouts past EOF
Date: Wed, 18 Nov 2026 15:49:45 +0100
Message-ID: <20261118150103.873301727@linuxfoundation.org>
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
[ sashal: replaced xfs_fs_map_update_inode() with xfs_update_prealloc_flags(ip, XFS_PREALLOC_SET) ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_pnfs.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index 0bf547d730990..a8db739dd4166 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -91,6 +91,7 @@ xfs_fs_map_blocks(
 	int			nimaps = 1;
 	uint			lock_flags;
 	int			error = 0;
+	bool			update_inode = false;
 
 	if (xfs_is_shutdown(mp))
 		return -EIO;
@@ -157,7 +158,24 @@ xfs_fs_map_blocks(
 				end_fsb - offset_fsb, &imap);
 		if (error)
 			goto out_unlock;
+		update_inode = true;
+	} else {
+		xfs_iunlock(ip, lock_flags);
 
+		/*
+		 * Blocks past EOF that were allocated for buffered writes, such
+		 * as speculative preallocation, can be freed by
+		 * xfs_free_eofblocks() without breaking the layout unless the
+		 * inode is marked as preallocated. Mark it before handing them
+		 * out for writing, as for blocks allocated above.
+		 */
+		if (!error && write && !(ip->i_diflags & XFS_DIFLAG_PREALLOC) &&
+		    imap.br_startoff + imap.br_blockcount >
+		    XFS_B_TO_FSB(mp, XFS_ISIZE(ip)))
+			update_inode = true;
+	}
+
+	if (update_inode) {
 		/*
 		 * Ensure the next transaction is committed synchronously so
 		 * that the blocks allocated and handed out to the client are
@@ -168,9 +186,6 @@ xfs_fs_map_blocks(
 			error = xfs_log_force_inode(ip);
 		if (error)
 			goto out_unlock;
-
-	} else {
-		xfs_iunlock(ip, lock_flags);
 	}
 	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 
-- 
2.53.0



