Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051809;
	b=kw0pCeZxrP5ucP9dowBFUDHK7wnwbE7gBt5oKqoiwC07T1cXV8DUlDclz1pb09Mpqf8h
	 qoKlwb7+jQk5sHCWL/Ijwu8um+u1VOaCaQM5BU44rAplx4TChppsDb5153jmWG1gJcurM
	 k9q5WU1mrdbEvBqhHAcODD1a+/8sbSQ41fNFMoy5GcwErApp4h/280TZYmVDpQYpsK9U6
	 ZXFhJiTYHrIfomgpaRiSjY0QnPE2ILQsCbXsrXXantO0jn4bkFMO8zayRDF0ZbBPMBObp
	 tBFTbzF5ztpxRQZcXaQjChWsUE93f2nhRzLp0YRHx2MeNzy/nfMHkHGa9rkdLZYGl5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051809;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jOxF0QRYInQ2Nhw9ykAJvSfjXyM70nEeLFWM598od2I=;
	b=PZ6nSCAoHWQK67FqpPDCujOxErj6SKAUmfOe/a+q9p2pMMGEstpc2LhDfCIhgIcBqV13
	 7zjpMTCOeh0fYHQw8p/+CsoEsLueLqPTLAhFJxaxl5PJRAH/2bGqUU4Mb7Zy/xmiAVgkO
	 gpSIg9PdSLJD0JscOEbRHEv01jXAvCd6zUKYpJaQa/LGNFT3sVaLw6LawyPz8wJwmcQDA
	 gTiCDcIN+37/nm087j1GEbe+VSnMSKDddwAu8EP4bPL3moCQc+ZZOC9FEaFglrDBhPDXU
	 oUid1ifKNVLyvcwORvgARpGz+rfmUU7pT1HP250jvZol1lWL01PGfb1RMnZ6vn8DSKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dDA8GDLe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2AA8606A31C;
	Thu, 19 Nov 2026 01:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dDA8GDLe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08DA91F000C4;
	Thu, 19 Nov 2026 01:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051808;
	bh=jOxF0QRYInQ2Nhw9ykAJvSfjXyM70nEeLFWM598od2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dDA8GDLeAQ1Kjl5iCETzBG5+V3SEcKmvzRlS2PvR5PbcLoPS9tmOEHeHczW75MZRr
	 RuX5t+1svVsIW2BVpz/yJqc7rA3PBtN2QxH5iTzJ3Dpf2xSLP9kNGCjqTBtgSNsq3P
	 /m9jzwBtWJeck/n5LdMmuNCb+aJylFcRYG/WmVVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 5.15 0339/2214] xfs: only written file data blocks can be shared
Date: Wed, 18 Nov 2026 15:33:35 +0100
Message-ID: <20261118150024.179762546@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit 634b63baf05062988456a0bd5df2696c14ea2949 upstream.

LOLLM noticed that xchk_refcountbt_rmap_check (and its rt equivalent)
will count any rmap owner towards the shared count.  However, the only
blocks that can be shared between xfs files are written file data
blocks; and the only blocks that can have single-refcount entries are
COW staging extents.  Fix the checking code.

Cc: stable@vger.kernel.org # v4.16
Fixes: dbde19da963706 ("xfs: cross-reference the rmapbt data with the refcountbt")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/refcount.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -112,6 +112,18 @@ xchk_refcountbt_rmap_check(
 		return 0;
 	}
 
+	/*
+	 * The refcount btree should only have records for written file data
+	 * blocks or for COW staging blocks.
+	 */
+	if ((XFS_RMAP_NON_INODE_OWNER(rec->rm_owner) &&
+	     rec->rm_owner != XFS_RMAP_OWN_COW) ||
+	    (rec->rm_flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK |
+			      XFS_RMAP_UNWRITTEN))) {
+		xchk_btree_xref_set_corrupt(refchk->sc, cur, 0);
+		return 0;
+	}
+
 	if (rec->rm_startblock <= refchk->bno && rm_last >= rc_last) {
 		/*
 		 * The rmap overlaps the refcount record, so we can confirm


