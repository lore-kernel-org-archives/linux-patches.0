Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034841;
	b=G6sK+4kME9f5ESpIb4Ju916KnMPj27Q5ZZ8QPkd9wFGr58EEwE6Vr0YK3YaaSnimneAc
	 UGdKEtWnAlbt5FGaP4BoJUayV1s2hiaFUIVt4oYxH5srPMWUfYGKwk600UaX/VJm2TLoy
	 KYybgR877q83CnAATwrAk/kWJN+mZG0BmUfNRBojKItb+vhh4wu1YjCj/z8LrgBY5yq43
	 7JHWgaA/pw1h9SL7oXBf7pwxReFMBQGrU7GrlDglDilyxG0YrtkwBbHUZqHBXvaNgh8IG
	 axilzBIfKWAOW6DpIg67+8LewLWRlGVuxhMn+WyvUPdA0Ol+2IivwnvHPPkQsi0ULHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034841;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6ozOOXy5D2hiFSq+umZDK7ixAmOj73NqCdFWIv0ivMg=;
	b=cblnpe7MPEF/SgKNW3TaRRHjknmBJmvQkGLNAdkoj7LUJe4JaE7Tt7nvnpDNqU04+W1v
	 9sGvtUHDK6sQB0QIOiGRbvK6eLDP2Udcb3RHkkKtsDtM4zK93IKLjbHpWr9Svln7LTveJ
	 gGAaeST3FFBnVau5evR078ETG3iFtp7bTI02YHTRcWsxO33shGII31jMESSWmrmIfffvG
	 m6pqybD/7XthtkdyaWGs4gKOgzJSPOnQpWYn9wUMqkYoYxo7EsporV7mhleOneFopaz5t
	 4vDDhmEos7Iai9ys5pfiu5pkcNWxJQ2elSCmB+G+fG4ZsKM/A/poPODc6qpIcKGUySA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YCcyCRcf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2223B606A325;
	Wed, 18 Nov 2026 20:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YCcyCRcf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7112A1F000C4;
	Wed, 18 Nov 2026 20:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034841;
	bh=6ozOOXy5D2hiFSq+umZDK7ixAmOj73NqCdFWIv0ivMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YCcyCRcfBCM6I78uayjWsjneaxuYCofJ0tiKgOdi/zN1eFLgr+6q+NViKquEHq3Wm
	 bY3lRCUCs5eSTZlMbzpVeEUlhD3lFRk1DK2TaEvp5Qg+2jWo0mw5zN0rI2pI6iOoBe
	 Qjm+EAqVqq9MZDwLECnsxhK9eH4wWwXmKmXWCc4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0486/3318] xfs: dont cross reference rmapbt with bitmaps if theyre incomplete
Date: Wed, 18 Nov 2026 15:18:28 +0100
Message-ID: <20261118150331.557897567@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit d7b92cbe566f6fe54368f62e4b515d9f80c43a18 ]

LOLLM points out that runtime errors (e.g. ENOMEM) when we're trying to
compute space usag bitmaps are silently dropped by the rmapbt scrubber.
We ought to flag that as an incomplete scrub instead of reporting
cross-referencing errors based on faulty data.

Cc: stable@vger.kernel.org # v6.4
Fixes: fed050f3452da0 ("xfs: cross-reference rmap records with ag btrees")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/rmap.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index d29a26ecddd60..19c21aa7296b6 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -484,11 +484,18 @@ xchk_rmapbt_walk_ag_metadata(
 	 * If there's an error, set XFAIL and disable the bitmap
 	 * cross-referencing checks, but proceed with the scrub anyway.
 	 */
-	if (error)
-		xchk_btree_xref_process_error(sc, sc->sa.rmap_cur,
-				sc->sa.rmap_cur->bc_nlevels - 1, &error);
-	else
-		cr->bitmaps_complete = true;
+	if (error) {
+		if (!xchk_btree_xref_process_error(sc, sc->sa.rmap_cur,
+				sc->sa.rmap_cur->bc_nlevels - 1, &error)) {
+			/* only set incomplete if we didn't set xfail */
+			if (error)
+				xchk_set_incomplete(sc);
+		}
+
+		return 0;
+	}
+
+	cr->bitmaps_complete = true;
 	return 0;
 }
 
@@ -558,7 +565,8 @@ xchk_rmapbt(
 	if (error)
 		goto out;
 
-	xchk_rmapbt_check_bitmaps(sc, cr);
+	if (cr->bitmaps_complete)
+		xchk_rmapbt_check_bitmaps(sc, cr);
 
 out:
 	xagb_bitmap_destroy(&cr->refcbt_owned);
-- 
2.53.0



