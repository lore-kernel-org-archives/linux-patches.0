Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060175;
	b=P0cR6YS1ZzaksrJ/GcAUiRp2gkHNxFTW1qEI9UGDoya+vXUwRSTWe2K8mHi9lVXGVANI
	 Q+m38+mfHefRI+nLghr8GBMN3Q0tPqdd9GxRoP7IAcXIBKUawenck0GiBqvRHrase7UXe
	 p6rkjRtOyCvv5sgcBmtnMJmFfm+ZLiyyFbfJplnMH8Vp2AmUv9VsHdPODsJelJ1920DHt
	 wPeoJ3633u0o57C9Dylxve4r5pJwX0dlDPdOxlBkzUzIvPfETk1gOCbGkRuUhSiQDCZKf
	 O116ocZohEjFnUHyM3ZdEuVS/F6/rlIQDt/K0Txi5BykCK2X2bY+dN5ITIsNdvCHZkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060175;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t7rp6ntX1NNLPjw0xuKA8gBEZDPCPouQO1oab5bMspA=;
	b=MIwg1GLshdCazBAfjPhsgdrH1Hf0BA7BLg82K62iSIJlrq82/qzGP34hmrjFXoXlyOxG
	 2iDaSeVrEtmyWMEbCpcX+Ebw7QINJa/C5tlKv3EuCiCR2aiY4qydWzSmesmxmbNOJno/3
	 ZMh6isXUDwllH+dqHPD2H5RdGbtTOGt7UVhfzzVFNgjFJL0919/9WnQsCAkfhE0bRTtMV
	 wtyiY27uyEuaSvJDfIix/vKxb9Rwh1YbfINgxDDH4qLsJ61JBB2KLxIJvoqAyv6mu0qWs
	 aAuRH7vozNcuBReVbqL7pBMM1WUEqBxxMsL1ytQxtnF5QBNDtQVnth8zPcsbFwt9zVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="iDlGSR/C";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E3C5606A320;
	Thu, 19 Nov 2026 03:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iDlGSR/C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0E831F000C5;
	Thu, 19 Nov 2026 03:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060175;
	bh=t7rp6ntX1NNLPjw0xuKA8gBEZDPCPouQO1oab5bMspA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iDlGSR/Ca+s2q/k+Ke5Ll70lNjuPTI3rv62IGCzVq0GLV1mAD1l4Vc18+VZRN1BCw
	 4jSRPRpzQqluyijKAi96Ctou4uSvaOEKXVDrYdHRRl4tNWyJC6Yywbn58FmS6Rk1+v
	 eFHGuVwpfqR+ZSGPWNUyehTBRKvyEvZ/gcbZeDTE=
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
Subject: [PATCH 5.10 1103/1848] xfs: mark the inode preallocated for pNFS write layouts past EOF
Date: Wed, 18 Nov 2026 15:52:21 +0100
Message-ID: <20261118150005.451277407@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: replaced xfs_fs_map_update_inode() with the existing xfs_update_prealloc_flags() helper ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_pnfs.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index e02a6b84c609c..931080dc64d3c 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -91,6 +91,7 @@ xfs_fs_map_blocks(
 	int			nimaps = 1;
 	uint			lock_flags;
 	int			error = 0;
+	bool			update_inode = false;
 
 	if (XFS_FORCED_SHUTDOWN(mp))
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
+		if (!error && write && !(ip->i_d.di_flags & XFS_DIFLAG_PREALLOC) &&
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



