Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793828925;
	b=XtexPlxzhOgNNPs0I26cEZJMOddcnMzTb9RpG03WI6LbTj6DXOfNjpId6KMQqdOeJBFS
	 e7dQ0pNzdCBrukbmmtEq8nyKZenWXvQTBh2iFWTZo6ekhZuDfbp6UHpooYXA5KAk3SVV2
	 gYI2VKZda/b5vxM2+9Dy+YyVZbjeK2kZiyeqZ2PKoNFfqOAJZDqQ8UFZkWDjqt18ee2Pp
	 lepX5jDdJwNJEc5LDuKTZcJ75FnykMY5hdCH0YAoGptGBGr9Qjz4Q/krmC55VMEIBEsId
	 R9Is8gvvL/LeSuqJ/rA0scY4uyh0PPO5FSUcJ0hBPE3EnIqgFs/eXbvQPNmCVTEYXUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793828925;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FSe2lNlQpmeRwANfkDSvTuEo1n8P4vm5fhs40yKl/Ec=;
	b=O+20JTiN9AUS7q17hw1GBPnDlIwZt3DQGszyfcx32Jp+IWr0thTkBR3Hg628lmJJAFkw
	 zcWkOaZZLZy0/wtqtwAk4J7+g5mXKfLTvD8ELvUhxaJJHBxQqZAUvz8zDkkWLd0JkZMgq
	 IbI9wrnqdK1NyDodyCR0YpVwksvt8yYMVw64oEzH0VX5qbFKtBQ8NaW9Mm1htUkysQF45
	 KpkizbmZhbYu+IOTv2BHcbscpYeNoT7HeTP122SHFnjvJCeJGJvBKArue5aMgcEBycZwr
	 /HX3aGbNPnmtgNAoebSrd7R61sUVoftXkjsCVj3//ILTe8U669RDckYJGZsKzcRsy8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="iVQ+i/nl";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B522606EEBE;
	Wed,  4 Nov 2026 21:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iVQ+i/nl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 090071F000C1;
	Wed,  4 Nov 2026 21:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793828925;
	bh=FSe2lNlQpmeRwANfkDSvTuEo1n8P4vm5fhs40yKl/Ec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iVQ+i/nlh+CQ7h0E0IZ31wtLEo4klB0hqG9IxxQ4/m5lebOBxBZbAJRVC8R08edHc
	 IDurMhW5vN8NtEYzi9g2Oez/tBG1rGVu897tmynSbStH+bQFxxYSvV1z0PpAzfmv1C
	 /IaHy8+N2cn/PEGo+2pvaJ0uOjzKqyxnCIoxH30c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.3 330/547] xfs: cross-reference the primary superblock
Date: Wed,  4 Nov 2026 16:08:34 -0500
Message-ID: <20261104211047.605532149@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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


