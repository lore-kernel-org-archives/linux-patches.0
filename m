Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211027;
	b=tI+hXMkgfHOeSeXFzWlQOmsxrRDqAF0ajYi2oHaG7/ljD6+wNTsrt3yMjRbTw1xx4cBf
	 lXoX1X6X/7rx0elcQTd5Q9yFeyoQoSh5jjB3PzmXWsGFJUPafkTWW9QmsSdXN9bOU+jbN
	 uqsH6VUfuL4ZloWQ+TYbraukAXfi2y7BPMpPgDIfos63tnRWKrNjjLYuiOYHxDvi56+Te
	 TZ8u7K+YvvvKd+FOnurGufK7AD3823XcupXTePkbBjqtu3PoZuVeYHYO7vdP/942+xupX
	 FLu8UboEDo8MyUAyDKv3cU1PXoBA9a1+/q8y/QmY6t9DMkp+4g+3S45cv9lbzIC2i1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211027;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=eMp0E1zsXeJFTDlUS3keOM81xz06oJ3VWbZ46WPZP5Y=;
	b=NLJwKPUFaHrkf5EXhiJ/gbkk4KoS+GaXJK4oNkurA7wE0CeHSGKcu28kyhqJcyoLGB1l
	 k2UPVjGq7O58ItqTqj6ZJpFXGLAF7wkNZQA580i8VarMa6HcDZAbE5txtxI7HjQac9GFs
	 egcpra1rnb/WyEJVQl8fTDlnT0W/ukfX0N+lmz2lXdAjNrjapWW7AFYkpNbm+O/ttXwsF
	 JXvibSWir+do328MqCFL45uWEQEcnd6CWTVMDgzyeOKYFVxBhHQG7HwWCOLTClcqm8BtL
	 y7ODREJYbvFYW+E8bB1pPItzYpoZ/1OFue3yCN3qeADB9pSajWhG+sML5Kgxg7XPRdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F2NM9Q9O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 332CA606A32A;
	Wed, 28 Oct 2026 18:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F2NM9Q9O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8224F1F01828;
	Wed, 28 Oct 2026 18:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211027;
	bh=eMp0E1zsXeJFTDlUS3keOM81xz06oJ3VWbZ46WPZP5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F2NM9Q9OThe6JjiIMkbXgxs2ms4yFrwRZK6/uSAP1VnWjVHk7iESfqNlJCBKScc7q
	 p4hhuFvRXj9mNlDhdPYSbnvnzlXvGMNos/ESEibt1JlYPjscBrjw24n7Ob06ENhmfY
	 pCNHcAd4mhKe4Dj+dOJ8pZoWx4eyDXo+ME4fN6D4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.15 234/571] mtd: spinand: fix zero oobavail when no ECC engine is used
Date: Wed, 28 Oct 2026 17:56:21 +0100
Message-ID: <20261028170013.558724021@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1241,12 +1241,17 @@ static int spinand_init(struct spinand_d
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


