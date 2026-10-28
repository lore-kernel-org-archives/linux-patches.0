Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212885;
	b=qupAW2VjViMXaHbm0QMQVSRI0VjgbHcVeW2sTKf21Hxs30q3V2kLHdO2U3xJwLcvHUYx
	 Rrhpo7YhgTXYR7gIQVY3DPaKF8iacSZQln4LkzHXVsKQdF1dFCUwVHEbKhS8CnOGHzYgn
	 MqSDzqQGKkIGekv9n+xHIxtAlDSdWQ2V7BgJ+1LiQ936P/fEtSe9KOJd4/nu2yrjBwRZq
	 6zFRidOtK4Z6V2oh9bGXmTQB/gyBQr/1Jmshvo9Zp54DAPsNI3H1OvBCpcxceaRsznd3N
	 qzGQQBgWIsKn2p+p/lAgkeWGxtygHqz+ugubt7QIzrF2/XZtAT93JRG/MbnisDmNS4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212885;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=UYIFSzu0uAYgHHP4vByqHVfb+5wgmjcBNTKl11hlkyE=;
	b=bGDsU9vfOz3q3JwBBu5qxL82ThUeJEGz/oZ8Ai4bkBU4sPDB1h7HsNds/XZc07CXuVRU
	 N1t+NQIe0Dm54G2ub/iQc3rn4nakO00NrmmCfK9KyN+5JTQNnEAKMVCjgfguAB6cppuEd
	 FompDgcgLpRaMRXbu/OW56rI6vn2OPlKJXbUg9YnAQc1v6IdMSaWuMnJE1UV/M72J2/3v
	 STFkedJJnYiQ20tf1nuGoPSKnrUKg47lhCPoJDq01iQZF5WMl10J4MEq4tkKgFJnTRVoM
	 qv59ps+uVDiCtUEm2CJE76+1A0AVun/Rzdg1QdlsFY5WMoVBx/g5c5TM+9on0uK+i5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YMAOdLZO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9689E606A325;
	Wed, 28 Oct 2026 18:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YMAOdLZO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5F341F01828;
	Wed, 28 Oct 2026 18:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212885;
	bh=UYIFSzu0uAYgHHP4vByqHVfb+5wgmjcBNTKl11hlkyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YMAOdLZO7oRPq+2IYRR6gXztxzaXRZE2KIB8i685b7c7F+1muGarC8g6/AAf+V1Yd
	 2fAX6/Ji8cdmLl5ORCtn3gFE7fTb+z457wb3w2LsoNORCykdbWOFUNP84xnKv1PORH
	 1aSaOa6A6kB+EVKdR4QEscbu1izSPyUZ6dEd0BfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.1 0312/1887] mtd: spinand: fix zero oobavail when no ECC engine is used
Date: Wed, 28 Oct 2026 17:40:08 +0100
Message-ID: <20261028170506.328608668@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuno Sá <nuno.sa@analog.com>

commit 636fe10d8f3559210ff63108a208d39ea2e9c3bd upstream.

Commit 00c15b78b4b4 ("mtd: spinand: Allow the case where there is no
ECC engine") made the OOB free bytes count conditional on having an
ECC engine so that probing would not fail when none is requested.
However mtd->oobavail is still assigned from ret just after that
block, and ret is 0 there, so the device ends up advertising no
available OOB bytes at all.

mtd_oobavail() returns mtd->oobavail for MTD_OPS_AUTO_OOB, so a zero
value makes every automatic OOB access fail with -EINVAL. JFFS2 fares
worse: it keeps its cleanmarker in the OOB area on NAND and refuses to
mount outright, reporting "inconsistent device description".

No ECC engine also means no ooblayout was ever installed, which would
make the count return -ENOTSUPP, so install the same fallback layout
the on-die path already uses before counting unconditionally.

Fixes: 00c15b78b4b4 ("mtd: spinand: Allow the case where there is no ECC engine")
Cc: stable@vger.kernel.org
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/spi/core.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/drivers/mtd/nand/spi/core.c
+++ b/drivers/mtd/nand/spi/core.c
@@ -1276,12 +1276,17 @@ static int spinand_init(struct spinand_d
 	mtd->_max_bad_blocks = nanddev_mtd_max_bad_blocks;
 	mtd->_resume = spinand_mtd_resume;
 
-	if (nand->ecc.engine) {
-		ret = mtd_ooblayout_count_freebytes(mtd);
-		if (ret < 0)
-			goto err_cleanup_ecc_engine;
+	if (!nand->ecc.engine) {
+		if (spinand->eccinfo.ooblayout)
+			mtd_set_ooblayout(mtd, spinand->eccinfo.ooblayout);
+		else
+			mtd_set_ooblayout(mtd, &spinand_noecc_ooblayout);
 	}
 
+	ret = mtd_ooblayout_count_freebytes(mtd);
+	if (ret < 0)
+		goto err_cleanup_ecc_engine;
+
 	mtd->oobavail = ret;
 
 	/* Propagate ECC information to mtd_info */


