Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831667;
	b=rBKPKsGu+WS/mPg/FC0RqfXvaYc4emk5DI/59E0Y2FoBYcnZ9Op2O3+IHybylHa/Ipcj
	 XjoE1xww0UpdvQjl1dBeEkRjE0yQP6YGYofQ5OPFMbSGtkIGOtVTrcN/nvKkixgyA2uoT
	 d1lbRK6/7YJpjfJ+w2UNbQV7NuH513oHbL1/cRIyxeKC5I7UxotDiwGbuc6mByXe/K+kR
	 LgxE1UhRhaHNnI6gR3+XljEId5w1j+Mdq1yUa3i/t62znrlTWWURSuXNOiqVW3vGJc6sw
	 +Oe8xGfQPyFAw4/Lr37sooqs1VjLCmp5LqZDHKE7dF/5ACQMJNQ5KVxS1aPVchTQcEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831667;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aBcwvGSubynjDky2WdFTyRnvkUlGNart3TubPVtG6HM=;
	b=iRFHYAxiOnzgwkbM1H+aQTYsRXc7WOkpne8geddW7IHNaec3sdiC0ByilFLGLwbz/HM1
	 pgcerutskcLa+IdUPAxTb8JP6CnqdCpCWzO0Q3L9ZiWFCDYaf8oPvsA6i6ez8LQ0vpEiR
	 MIjvYsLI+wD8/9pyzkGDkf73IHr6FVXSApPFEluTiYAVFE39i/TALVURH4Zwp74+5sKsr
	 QC5tIiHp6OScq6Wc/J7pqLOf3QzL2fQK04QudVG76XFOcunP06nxPDhZVKHIaAj4mi3If
	 sDyOXWdLLE+rPENA5GjEgE43mDwpUAUAkNkKkqUuDqpl9bYwNfkEVY+5uEQAzfCcbhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PQJjCG5R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50DBF606B2FE;
	Wed,  4 Nov 2026 22:34:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PQJjCG5R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E22611F000C1;
	Wed,  4 Nov 2026 22:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831667;
	bh=aBcwvGSubynjDky2WdFTyRnvkUlGNart3TubPVtG6HM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PQJjCG5RpNnpUbndQDaV6inkqi5VnLD27n7tbd/dT7JPGUBuvwS2N4eY0npneArVn
	 h0qQsaNqAVv77lUPuLXJB1Fjb/WTK0p/XbOrCGQckdDFEXSgoLSSF8vJaVnEfsTNSG
	 2dTyX3gtXCAmae3MRy32mwJ9ve+VgwHFau/GruUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0805/1005] xfs: cross-reference the primary superblock
Date: Wed,  4 Nov 2026 16:08:58 -0500
Message-ID: <20261104211105.901372401@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

commit 0c61016006ab08f8346f9e7b1e38559bd4ea499e upstream.

Make sure we cross-reference the primary superblock against the rest of
the AG 0 space metadata.  Drop the unused @bp parameter of
xchk_superblock_xref to avoid complaints about uninitialized variables.

Cc: stable@vger.kernel.org # v4.16
Fixes: 52dc4b44af7419 ("xfs: cross-reference with the bnobt")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/agheader.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

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


