Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064444;
	b=mEX0AkBDy6+qP/m3WacY2tEfxfl5xmoM/kf8Yuko3Kz42f6QbI7sRqVUWyOaAp8LceY3
	 oy6w3dt5kNomO39RcO4JqoKGKdzVieUzmqlNo0r9gat8OQD4Yh3xAI7g4w7glKsxLk6xZ
	 tSmOA0f07Nq+qOQ3rNdCLC71a05g0/Z+K0AAT4WMyQMblTSnWgPN4DT7eCDzeaiuj+fW7
	 3VCKraX+2GtnRf3QEl3Jdx/sar+CO+rZy28TXqRagCv7ngahHUuMhr3/vVJPwYSrG1ics
	 8IIZV/bjNDyyCpopPxSK6L6y00F+sArlZ7FN9JRy2CBVuCLli+s1eIETQI5E/Df4t2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064444;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iBNmAIXyatOVoKvLerGxO79AAaRrcaJTHN3fSKRipTQ=;
	b=quXjL82/aGmeh7RxDIgTeJnh7YMNAJHbpjWTky09SpfscEvgZbLoXxOEq6YimJBLc4Kr
	 sJr3VV3qz7bWbiKV9RPQiVNQUMTk4I/CMOTtQUg/UixClLE/GhDhTCyBhsbpNVxBSOVEQ
	 DyOqdW/uhaa+DSQ3YcLu3i5ujebFROY3E/NeWbTGI+xnDtgNM0r/Cqy/qkYiyrC4yAr8r
	 875wlUy0oyALFeyGM9ul+cySa6tR2DCt6UUsYGp7vH9xMS9DcQp1yXbnCNFta6+ErZ5tV
	 JxXPFENo1FpsWL+iI6baoUGES3N50fz2tSx883wIwavnWFis0XnTKUlJK3OQxM2slvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LvyfoLQ3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28786606EEAC;
	Sat,  7 Nov 2026 15:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LvyfoLQ3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8DD91F0089F;
	Sat,  7 Nov 2026 15:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064444;
	bh=iBNmAIXyatOVoKvLerGxO79AAaRrcaJTHN3fSKRipTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LvyfoLQ3JgoqnCiIyPnUsCoQG5IDifdixYySK+ky8vT7xMYKRGvmud1as5aaOeCmf
	 +1rKhPdyXw99EAGm/kPtMPcxV4vS5hwCdDyeSnXZw/5KaCTVAPzbqo2U4m9Hlbn6MV
	 kGCcScDrAZtR5Eh5h/HP/RbJ66aa6YZjFN3BoTxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0489/1257] xfs: cross-reference the primary superblock
Date: Sat,  7 Nov 2026 08:46:25 -0500
Message-ID: <20261107134952.948037317@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index fa5d32ec020ae..1dff6cb1b9362 100644
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



