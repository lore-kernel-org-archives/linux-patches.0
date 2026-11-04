Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831729;
	b=uxr1uR0Nxq13AlOBlZRMGS3DgvumquxPAe13hGuHAKvLJEp/tIMLKBCp/Rutc/rZj6AA
	 7NfSIB2TChAE9VrV8o6gmIrXAAiBirXrCl2RirFeg8S0ruLBrjvWCIpIV7wIxstqkJdf3
	 QMV2pKroRXpMLpQhrGYF98Ft+LArQ2JvuyUTi1syIeIwKVWoPM5ivu9WIl9X5vHBhPNYq
	 wRRTgS8sF9W20ky4HPteJx5ibvHOSZosAE2AfPYn3+Vq0ko34Dahh3mjj1mMW+t5mUW0k
	 5cHyMW0/ZRPaCjvbI3PKP++2DLspgPKEmTpopeWTGHC2wo2w0/ZDlcw2luMG6QVAM4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831729;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RAMHVeuCUUWTZf1Bf1xnU70Ki/zXzzX9Uj6C/aLj5wk=;
	b=rOjsVdqDx4qC4X/K/7UiKMUFN4Z5yWh8Akc+Sswt3uMMuDomI6wZ1kzBHz1oh8pi6SnZ
	 s+3dEhmIc960Z36mTwGQ+AohDTMFp5CXJSXVqgRpgJwLvD/C4Ds3j9vzBapzroYMQ0BxM
	 HRQe9WXIr6CDWUXIheJXJQOmct8kzA5B/BR9Xy89N8LwBoyAQpK2Z4aKl4usom8cQodKB
	 9+Un38tSzs98RIVOQaubufdjbibexVjHOiT2E9l6lAmI1mp5c/W66tdZiRuXU+2Kx4KsL
	 SnHP/1CqhPqjeoorir2+ef3PH3QVP8N/hfJrIVMLpLUKliH/iI3bGbRd0YKNu6I7jIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jny7C9y+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79AB2606AB21;
	Wed,  4 Nov 2026 22:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jny7C9y+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 149231F000C1;
	Wed,  4 Nov 2026 22:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831729;
	bh=RAMHVeuCUUWTZf1Bf1xnU70Ki/zXzzX9Uj6C/aLj5wk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jny7C9y+MoTT9wo0ay74cpn66LeHryWLGFu26yWaTfo6V6LKgnrXOrQ8wQtsyELep
	 ZD7KjB0GzYlKTE4NMm68cfjD4KEBmR+MxsB/Ri5waavIwwY9EqSxWusATYNdPd8ck0
	 3ZPDQSGLuMfybhiJ7j8TZVP+m0chg73zHdPvVntA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0842/1005] xfs: check for termination during rmap btree walk
Date: Wed,  4 Nov 2026 16:09:35 -0500
Message-ID: <20261104211106.906092579@linuxfoundation.org>
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

commit 1fc241cdeab276dc6c3ec14840faa706ed7712ff upstream.

LOLLM complains that we should check for a fatal signal *every* time we
walk a record in the rmap btree as part of rebuilding the free space
btrees.  Fix that, and improve responsiveness to ^C of xfs_scrub.

Cc: stable@vger.kernel.org # v6.8
Fixes: 4bdfd7d15747b1 ("xfs: repair free space btrees")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/alloc_repair.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/xfs/scrub/alloc_repair.c
+++ b/fs/xfs/scrub/alloc_repair.c
@@ -227,7 +227,10 @@ xrep_abt_walk_rmap(
 	void				*priv)
 {
 	struct xrep_abt			*ra = priv;
-	int				error;
+	int				error = 0;
+
+	if (xchk_should_terminate(ra->sc, &error))
+		return error;
 
 	/* Record all the OWN_AG blocks... */
 	if (rec->rm_owner == XFS_RMAP_OWN_AG) {


