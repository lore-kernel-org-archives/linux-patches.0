Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063148;
	b=e8o2622BobyZZh7IgP/zGWA/+lLhEnEpz+9Oevm52xX/90WEmC/S4uwTq/XNlYOy6qLx
	 ZK26W8Y7srSjHqariImKSQcrLfVQ6s/BjNqFaMv7WeiZcV/G90O8tOArDzeAmCURWNMsA
	 c2dTPuOoxtSiT05TBYSgyfSbZoiDWBT0YbMNp07wt99N/Q6a/k1VfNrPBPTacSNNezXK1
	 2242HZ6CSjZkUmdOtAkD99vEMSSbmWQ3K4iO94cZ+yBWyFjqucSzGcJV+BzIkBF5YUd+V
	 8FmebkiuzmqoU/0l48D1TTOewCP8lrR+qGH+XI3fgfe7f+f+jhHTB7LlWIBI47Sd3Uw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063148;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ms0P2W0vDGKAi68i1ALr9HVZGlAQCDAUq2PCcStJALs=;
	b=y5i6GvxHSuPEYLuLvL2g7Eztwen8EVyq62sezAFiGfDM/qcurNybiPm7wBqq7XmZmRQZ
	 9bu6yevjpyiODAyvFw7yTPjRNSvaiFjVlJVbgDJLWL04bcKkD3Bw342yWlYvemfzRZbRl
	 O7GuoJkC1NsJPyNqpygpxCqZBJI1onBeEDJMf4Eg8DsArZWbbzEbTvV9I7yAqn6OlNQQl
	 Q7mOUJB1xnnpKtFf8eiUntTo9KQ2/GypQiNKMbeZRLxvxwktSMvrtnjSteVjiGwriuI7+
	 B+g6NO5R1somGult1GOulj/AIQ3qCJZwyz4GRUpFA0inpAdHFAWteeN1VUwyejL8fnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="mx9mJuf/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A87F2606D81F;
	Sat,  7 Nov 2026 14:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mx9mJuf/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 535331F0089F;
	Sat,  7 Nov 2026 14:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063147;
	bh=Ms0P2W0vDGKAi68i1ALr9HVZGlAQCDAUq2PCcStJALs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mx9mJuf/EHoPzYoVEdPoogFoUXXgVVNcaYON2mH2r5rKxnf9B+Un0ZqxENjXv00DG
	 w+H9UvNOeoYtxWwb+V5Mi/XOvpBCE5ofPHk7NV0wzqHvyYc2Hv+KF5+5VzEuoMbrry
	 QaZ7hBTgaZ3v8lWPGYQzIbxVGMjc/DJSGNw8fgt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 373/869] xfs: cross-reference the primary superblock
Date: Sat,  7 Nov 2026 08:50:55 -0500
Message-ID: <20261107134905.530168404@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index 5b8d66b20159e..80de731070f47 100644
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
@@ -106,16 +105,12 @@ xchk_superblock(
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
@@ -125,6 +120,9 @@ xchk_superblock(
 	if (!pag)
 		return -ENOENT;
 
+	if (agno == 0)
+		goto out_xref;
+
 	error = xfs_sb_read_secondary(mp, sc->tp, agno, &bp);
 	/*
 	 * The superblock verifier can return several different error codes
@@ -430,7 +428,8 @@ xchk_superblock(
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



