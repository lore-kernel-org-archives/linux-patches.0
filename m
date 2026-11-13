Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585357;
	b=l3R4l/pDevtWgbUSnfGWmIdwoJ8mPV6JjYlCgKMA6Hvi2By7H3yZ2Mmf26DQ6wvMSuhC
	 haw9m92WCm2fxj00lP7+GfGzhG6wuCCeHUgCgZLNpgNz+6QQ1cL2ERp7HWjuABJg0AgTV
	 RC4tHIW9L92Zs/zw+O6kr2BxOK3RYbwEUnjXX2rLrtBNPaXmDs75JmUTK1pYqaITu1iCf
	 ptArvSRdFQDCnBQidMNsyi+IT9laFHW8+2fSUdsqUUVL7usk6tzlOhBpjX07a+Eta942Z
	 egzUZ5mFozSaSzkYT0n41DqJ7Hm48vVCpv307ymKuOa9/pDWg0liiA4ZdNgQW5/OqRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585357;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TjT8dCqX6MYHskeW71gtAvKqddabJt+JgHI4mkLrCwI=;
	b=olyUQH9FcjAv4y3W1K2i1S2wMXNnNqW92nOXpDPN89OFSLUyPF3+6P0mRxF7YwYOXk5M
	 w7F+1InItBNSnZUFSXOLsdcBPwlSHedJ6e5zG14ovK8pvcsCxALmaQD9aCd30HqeSkQJy
	 UJonn6TRhNw1iK7kfQa6rUYlB8U7cTZCkTrZvo2fHaPbA+CI4q39lKSC1hFRyBHV4yzWP
	 /zEflLgBFFQwXImZ5xorY/7msw7k/R0ttIbWgxReI99eYkfn9Ir+Qz/9ogk5HUAn2Xspo
	 Fc7dG4q9pxUq8J2hAoHWGl1BehsYw4s+Mswh8/ySzDMaXu/p0cvL3bOw2PSSiB/HI/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m0hfaG4+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC649606A8A8;
	Fri, 13 Nov 2026 15:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m0hfaG4+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7623E1F00925;
	Fri, 13 Nov 2026 15:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585357;
	bh=TjT8dCqX6MYHskeW71gtAvKqddabJt+JgHI4mkLrCwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m0hfaG4+1jSvdBt1aMVfQ3+hugiO3m/9GHKI6hGDZrktauZkglKsTM5S+7x99M2vH
	 ILy16Pl2z5xwFNxdNjkNfP6b14vUhDACnlMC8SlT4SPy8OzNsrSwrYTBBsWX0qQAhH
	 5IRNEjBO6+nqSvL0KRGpJTW9g8GdyQSOmgSxakTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 037/507] xfs: forcibly reset quota timers when upgrading to bigtime during repair
Date: Fri, 13 Nov 2026 10:45:41 -0500
Message-ID: <20261113153754.801155682@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit 780212c8d8105eadb5f56b4c7aafb94937755582 ]

If we decide to upgrade a dquot to BIGTIME as part of repairing it, we
should zero out the timer fields so that they are re-evaluated and reset
in bigtime format instead of letting through whatever was in there
before.

Cc: stable@vger.kernel.org # v6.8
Fixes: a5b91555403e3a ("xfs: repair quotas")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/quota_repair.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/quota_repair.c b/fs/xfs/scrub/quota_repair.c
index b6a270010b8b6..3be56d73dd665 100644
--- a/fs/xfs/scrub/quota_repair.c
+++ b/fs/xfs/scrub/quota_repair.c
@@ -346,6 +346,8 @@ xrep_quota_block(
 	bp->b_ops = &xfs_dquot_buf_ops;
 	for (i = 0; i < qi->qi_dqperchunk; i++, dqblk++) {
 		struct xfs_disk_dquot	*ddq = &dqblk->dd_diskdq;
+		bool			was_bigtime =
+				!!(ddq->d_type & XFS_DQTYPE_BIGTIME);
 
 		trace_xrep_disk_dquot(sc->mp, dqtype, id + i);
 
@@ -354,8 +356,21 @@ xrep_quota_block(
 		ddq->d_type = dqtype;
 		ddq->d_id = cpu_to_be32(id + i);
 
-		if (xfs_has_bigtime(sc->mp) && ddq->d_id)
+		if (xfs_has_bigtime(sc->mp) && ddq->d_id) {
+			/*
+			 * If something was broken with this dquot and it was a
+			 * non-bigtime dquot, we'll grant everyone a fresh
+			 * grace period by zeroing the timer field rather than
+			 * try to interpret what might be garbage.
+			 */
+			if (!was_bigtime) {
+				ddq->d_btimer = 0;
+				ddq->d_itimer = 0;
+				ddq->d_rtbtimer = 0;
+			}
+
 			ddq->d_type |= XFS_DQTYPE_BIGTIME;
+		}
 
 		xrep_quota_fix_timer(sc->mp, ddq, ddq->d_blk_softlimit,
 				ddq->d_bcount, &ddq->d_btimer,
-- 
2.53.0



