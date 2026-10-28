Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210207;
	b=aM/1EO3jYT7pQGZ/OlEjEFkpeOPJj/FirIJ2qGlPRNpi3vUkvUm1gKc7JsWjMDHwQJW3
	 6My1VNMLHGj5DcC1+m1664t6pIVsOZTIsu5XUgG0PXImAm9R/zuSnA4V3Q83/zRxDX3dr
	 ApwbbYVbR3wzIUi75hrnQkaVt1gSzrzoJEK9E6hgBWbK7N6Kl716X20YdN/3IoqbOTIOK
	 VpXXdRrGj99RNoUxlak1vJTEx0r7c01cLVGhz2Q+TORyiY97I/vhTRZ+0TaSlbg4INMM/
	 +MQ3nNWlY5EZQfwEMPvBwE22hBxMnodEg4DLhaxsOJA2bFOEIIkqrBtQNw9kwIZYcuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210207;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+Vh6EV9pEuaenBngxJ3mfW8TakQk3/POOH5QpbPz79I=;
	b=TILw9ILvhn2J1l9Le0nRzbxPTg+PQfhbd9N8nKNI2RxEVtFOTzUFFcP0fECFZwtx2f+Q
	 4CBs0mq0O2eqZJ1S6WqsnYACMd4a/4AKuCIVpAUsbA0ajdaOrdKF5QaAYfhXpDUHUiqgT
	 Gy+zge5s/ITt7FEbUpNBpwkpWOqLIUpALiGrw/3UU90+tqwwPPE+r7Yl0N/lH4nHqDgse
	 cDPEg5s9p1Gg83X0VS61s7LiAd4ygkeWK4flRAVgWwVHlbXCqJimHXmta53gCauNxK4f5
	 kbasmgC3V1B0XQwtj0KM20yr8EOp/VqBoQUA7pJObfOG/4Ix6drd8YmefiFikQ4qNbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RQbebdJG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81D40606A327;
	Wed, 28 Oct 2026 17:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RQbebdJG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 987041F01829;
	Wed, 28 Oct 2026 17:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210207;
	bh=+Vh6EV9pEuaenBngxJ3mfW8TakQk3/POOH5QpbPz79I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RQbebdJGwGLSuYTNnsY0Lw80avW1txCF+ReIW0BW8qVLAEVbc7ImxR4f35r5nk6/W
	 zchK/r+sjLyJYPsEiFfq8P3Pnfq5xn8S6ATUrG7w+mGf1VYpbGluIYwIZMNvZLdJca
	 SwZ+7SYjO+BufciWNdBSth49/Eb5sgE1NkhZT7DM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+837bcd54843dd6262f2f@syzkaller.appspotmail.com,
	Yun Zhou <yun.zhou@windriver.com>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 115/168] xfs: dont hold buffer locks across sync transaction commit in xfs_sync_sb_buf
Date: Wed, 28 Oct 2026 18:00:51 +0100
Message-ID: <20261028165945.808933066@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yun Zhou <yun.zhou@windriver.com>

[ Upstream commit 41a28c865d1d5843f8cb9e0af17a8f4d9e2961ff ]

xfs_sync_sb_buf() holds sb/rtsb buffer locks across a synchronous
xfs_trans_commit(), which flushes the CIL push workqueue internally.
If shutdown occurs during the CIL push, xfs_buf_item_unpin() needs to
lock these buffers to fail them, causing a deadlock:

  setlabel:          holds buf lock -> flush_workqueue(xfs-cil)
  CIL push worker:   xfs_buf_item_unpin -> xfs_buf_lock(same buf)

Remove the xfs_trans_bhold() calls so that commit releases the buffer
locks normally.  After the sync commit, re-acquire the buffers via
mp->m_sb_bp / mp->m_rtsb_bp for the on-disk writeback.

Fixes: f7664b31975b ("xfs: implement online get/set fs label")
Reported-by: syzbot+837bcd54843dd6262f2f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=837bcd54843dd6262f2f
Cc: stable@vger.kernel.org
Signed-off-by: Yun Zhou <yun.zhou@windriver.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
[ sashal: Omitted realtime superblock changes because the existing code lacks realtime superblock support. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/libxfs/xfs_sb.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index f4656d17121eb..279e174fba8ac 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1150,26 +1150,23 @@ xfs_sync_sb_buf(
 	struct xfs_mount	*mp)
 {
 	struct xfs_trans	*tp;
-	struct xfs_buf		*bp;
 	int			error;
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_sb, 0, 0, 0, &tp);
 	if (error)
 		return error;
 
-	bp = xfs_trans_getsb(tp);
 	xfs_log_sb(tp);
-	xfs_trans_bhold(tp, bp);
 	xfs_trans_set_sync(tp);
 	error = xfs_trans_commit(tp);
 	if (error)
-		goto out;
-	/*
-	 * write out the sb buffer to get the changes to disk
-	 */
-	error = xfs_bwrite(bp);
-out:
-	xfs_buf_relse(bp);
+		return error;
+
+	/* Re-acquire and write the sb to disk. */
+	xfs_buf_lock(mp->m_sb_bp);
+	error = xfs_bwrite(mp->m_sb_bp);
+	xfs_buf_unlock(mp->m_sb_bp);
+
 	return error;
 }
 
-- 
2.53.0



