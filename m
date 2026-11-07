Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062211;
	b=cKkXKRkEXA7jVy74SxdPPajkdBZWjUe8nb5yYX7ox0KzZS9zp/aSXf0PnOqpQcBj5ffw
	 igszc9cHrM5vKrgaFT2jG0toE1T9g47OX+HBLLhcEPFSYp48G/pYOQKan+af7cEIjPr9Z
	 xd8KOchAD9VcCuGojaXAV/XU9E/x7VfY0koF0400Y38boqjc3QmhWf6CylO+I1KAWd8q0
	 KTIymlqVM65AEijKOwO8fBGxaMxIj1cvBktUrFaDx1ECzxOt/SxBSYpgMkbrO79JzKtsb
	 kYeYY8EF9xiEXhB0ostbhGiCvK2GEHtEO9CNYBD9/8jk846t93UiZwaHo0MzrckmgqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062211;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=32SSMh34WSkEOW+5aWSAFQDhc/eZOOvZPMtfZyPpT5I=;
	b=4GUDsLSGxSuCPEUrQyFXhxXoFqgrMGtUGLfr8rXa3SPKSs/ViPLR6rPvYawcwUZuIwjz
	 qmiBg54/HcU5zfe6k7ujdBR9S5/LrG7tRwkorQyXzHna00ZEAIAOE6cimTGtQoxDIWSQa
	 PR7pXp3V0kc6zup1+W2C1IZFG+A/HW589OY4TK6CLvaPaEuuUL9vpUfKsBqPbMZcJtt1y
	 JHV5FZ0QS1Ad3klV3NUyF69BxPjIfTeqizj9+Mk9uv+W+434fzdr9/yEurMFx+9mPefry
	 vLznDkPT6WQ+s+9M3kyKbe40Oj3Zp3UwH/+TBqPcm3MkcXCZxx189mMHDwEzWa6BZsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="RVvi/Za6";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D64C606A326;
	Sat,  7 Nov 2026 14:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RVvi/Za6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE3521F0089F;
	Sat,  7 Nov 2026 14:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062211;
	bh=32SSMh34WSkEOW+5aWSAFQDhc/eZOOvZPMtfZyPpT5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RVvi/Za6kxj7MNDVoEilgKMNfAKP/74i7FdX/Ak8/p1BsXJ4IAnnR7SOlyUw6TBnI
	 EyGaUmuqC0M5GYAcikGcvLOwLHom9aT2T9HvqpP3S9YxFvhRsVNAOGrWtxjMklPA3u
	 da+kaeopSnhsKi7Rul6IF1er6ZGyN465HfGZVMWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1166/1536] xfs: cross-reference the primary superblock
Date: Sat,  7 Nov 2026 08:53:02 -0500
Message-ID: <20261107135030.481498271@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit 0c61016006ab08f8346f9e7b1e38559bd4ea499e ]

Make sure we cross-reference the primary superblock against the rest of
the AG 0 space metadata.  Drop the unused @bp parameter of
xchk_superblock_xref to avoid complaints about uninitialized variables.

Cc: stable@vger.kernel.org # v4.16
Fixes: 52dc4b44af7419 ("xfs: cross-reference with the bnobt")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/agheader.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 938885a391632..c9c0a6149e8a9 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -35,8 +35,7 @@ xchk_setup_agheader(
 /* Cross-reference with the other btrees. */
 STATIC void
 xchk_superblock_xref(
-	struct xfs_scrub	*sc,
-	struct xfs_buf		*bp)
+	struct xfs_scrub	*sc)
 {
 	struct xfs_mount	*mp = sc->mp;
 	xfs_agnumber_t		agno = sc->sm->sm_agno;
@@ -102,16 +101,12 @@ xchk_superblock(
 	struct xfs_dsb		*sb;
 	struct xfs_perag	*pag;
 	size_t			sblen;
-	xfs_agnumber_t		agno;
+	xfs_agnumber_t		agno = sc->sm->sm_agno;
 	uint32_t		v2_ok;
 	__be32			features_mask;
 	int			error;
 	__be16			vernum_mask;
 
-	agno = sc->sm->sm_agno;
-	if (agno == 0)
-		return 0;
-
 	/*
 	 * Grab an active reference to the perag structure.  If we can't get
 	 * it, we're racing with something that's tearing down the AG, so
@@ -121,6 +116,9 @@ xchk_superblock(
 	if (!pag)
 		return -ENOENT;
 
+	if (agno == 0)
+		goto out_xref;
+
 	error = xfs_sb_read_secondary(mp, sc->tp, agno, &bp);
 	/*
 	 * The superblock verifier can return several different error codes
@@ -381,7 +379,8 @@ xchk_superblock(
 	if (memchr_inv((char *)sb + sblen, 0, BBTOB(bp->b_length) - sblen))
 		xchk_block_set_corrupt(sc, bp);
 
-	xchk_superblock_xref(sc, bp);
+out_xref:
+	xchk_superblock_xref(sc);
 out_pag:
 	xfs_perag_put(pag);
 	return error;
-- 
2.53.0



