Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057855;
	b=W5EZ70bdYXcnLqXusbROVeWEaIiPEyIjAXp6tPuNKuVzC+Ct/wd9Imof2u9+/Bu45vWI
	 6lMpljTsv3mK9k9r0tfunT3LPWCjX2HGGjHC2DKwObr2fj3/0G8F5usdf2mGPlmCoukzx
	 tXzS74B66Si0HWrphFjpHymdQcpYkPbkT/iRkgkPB70tXTLTpTpa26Co4+Q7hatq7tT4t
	 EeKAINzcdI6ggappkoVYM161e/SIn09nzbe77eQdvp11v9JtU2L4BpcThh8he0YFqEoDG
	 GeSkFzVBnovaHJpc2BVSFlG0Kvy3m+UZ5rzjqAZzoxhmIknptiry14PGkhJRXvf9w2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057855;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bCTLPA5pHJL0U+uKSHczuI9ZcGfy6W/gzyWcTTHBvLU=;
	b=1wHPg/kLLv9IY5ofWwNqbGyNq3bP7ZputtE5iUKIK9Nd00wUeft/0vP/PAdTHC4qQvI4
	 JjFxUUKOtRtn6ELVxLgAvNxwOypgixGy/pRyyKYHO6TbYXN2hMtFVwRCkqmQaGWg6KhSz
	 wShQM4hSvVWFFxFUK8cvc2mndMWUfRax//eGBzjnhtMKCteZ/fcj8orFjrzqvQbXNWyJa
	 CIp8zcWCc+FryR1FAd91uoKmGiZQ0iQPjxrqGoLCNK+XKWbBnwENoKt8ZNZ4uEXBFyUJC
	 f1aJLQMrp6yonJabtzJHXBHbhT8T//BLRRBsbDI6hDL9olHMrjWaW23JREYDdAao7uw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wRceHb6x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EFB0606A32A;
	Thu, 19 Nov 2026 03:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wRceHb6x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E29CE1F000C4;
	Thu, 19 Nov 2026 03:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057855;
	bh=bCTLPA5pHJL0U+uKSHczuI9ZcGfy6W/gzyWcTTHBvLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wRceHb6xV7en/OdPM0fUjzMzdCMeWZGGuuBksJSLvGOWvKj6zDK+PdvPbHDTl+EeA
	 sZGnQm4Jl7zfwEyET6ArN2qIBX/8gMHxxNJFKMMKrayUH6jCOxgS1nmFfcih69fRRo
	 sApkthtfY9ZKYGTMvxE5XhAnvrdRZZdbOpD7d900=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 5.10 0279/1848] xfs: only written file data blocks can be shared
Date: Wed, 18 Nov 2026 15:38:37 +0100
Message-ID: <20261118145923.882111656@linuxfoundation.org>
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


