Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053134;
	b=KLt6H8NjrFqleRnoHQMmc0QBhrj5bpUnuo2PeVpeFee8XWaDtTGgIe0Ygwmm9sDX9Fx5
	 5lOFbcAvGJRdqy7PgdsrzVoPx3BwXZgkNIfRz+d+RND246JVSlcElmSzwoaNGF+bMHapa
	 EpyamzvdLTZy4JYhy1xX/AzK43l79p0DPDMgBzvpA0ITyeyWoyP4VeUw56l3oc5WDNa5B
	 gSQ1tTmlUADuz/PSVHua1arMvZ7BgwG98R4OFVrQyh5suT3EBB6B41cFsloUitGybNfDK
	 9An1Dj8+EnS7bFIAiEpNr1xk9DqseiQQgt6v5II8T+HJf4qrRCC1B4jEZxGK49IcSmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053134;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CRLMDcVfjZcTwoLrFLAZycNPIo76j5L3IA2UxBKn4PY=;
	b=roGTel1PMHQ5/irYSNbalK9YCVSx2uDVRL6tMtc6CiLYZ8gZa8GUMU7+E41p9PM9Skh4
	 to7+rjSTn/Bsdep5rpfkUGjQA0oj0ezLp5SHffDhlbBfPB2COau1om53vcxoDC6uh7B/s
	 mHL2FiDjSpMu+misiN5LmLQSDD9kNqnMj5VjDmfpqWA12hVOlfT51L5Vt3x5o6UJQNbUU
	 SLOaNkYCXp2VAvAXuLg5lMVEriA9BKtGQHAFESk23H8mZjYmVhfsbl/c1V9WQdoqeUWC6
	 JTRigPuF/jvwVFFHIN+3jTawrwqtPOZuabWsQvqEO9/GQkwmjdtgcBZi4bp19l9bZTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="2L/smaBC";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D40606A31C;
	Thu, 19 Nov 2026 01:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2L/smaBC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 428D41F000C4;
	Thu, 19 Nov 2026 01:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053134;
	bh=CRLMDcVfjZcTwoLrFLAZycNPIo76j5L3IA2UxBKn4PY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2L/smaBChQdXKwLJlxEQgSq0+RlLIw+nHdV2dSxDjJWxD2C6v+lG3jbmRroFoWTmw
	 ZWoTwNfGxSJxVBsxMtDrKWoSOAtZGlNU/+pNLQdLNDTVMENzYn1eYwNf4eSCK+IzlC
	 M3iYypC7+f0rFL2pOQhVDbjQuBqxmk7iIxJqg8mo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0811/2214] mtd: rawnand: ndfc: use devm_platform_ioremap_resource()
Date: Wed, 18 Nov 2026 15:41:27 +0100
Message-ID: <20261118150043.901880593@linuxfoundation.org>
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 0d66f9895f286d2fab396a71e6efeb95c4a7e5a6 ]

Replace the open-coded of_iomap()/iounmap() with the managed
devm_platform_ioremap_resource() helper. This fixes a mapping leak on
driver remove (the old code never called iounmap()) and simplifies the
error path by dropping the manual cleanup in ndfc_probe().

There is no overlapping memory-region concern introduced by this
change: each supported board DT describes a single ndfc node with a
unique 0x2000 register region, and the EBC parent uses dcr-reg rather
than a MEM reg resource, so the newly added request_mem_region() cannot
conflict with an existing reservation. Distinct chip selects map to
distinct 64-bit physical addresses, so CS instances do not overlap.

Fixes: a808ad3b0d28 ("[MTD] [NAND] ndfc driver")
Cc: stable@vger.kernel.org
Assisted-by: opencode:hy3-free
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/ndfc.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/mtd/nand/raw/ndfc.c b/drivers/mtd/nand/raw/ndfc.c
index 3172ab459c9d9..23321b9e2bf15 100644
--- a/drivers/mtd/nand/raw/ndfc.c
+++ b/drivers/mtd/nand/raw/ndfc.c
@@ -194,10 +194,15 @@ static int ndfc_chip_init(struct ndfc_controller *ndfc,
 static int ndfc_probe(struct platform_device *ofdev)
 {
 	struct ndfc_controller *ndfc;
+	void __iomem *ndfcbase;
 	const __be32 *reg;
 	u32 ccr;
 	u32 cs;
-	int err, len = 0;
+	int len = 0;
+
+	ndfcbase = devm_platform_ioremap_resource(ofdev, 0);
+	if (IS_ERR(ndfcbase))
+		return PTR_ERR(ndfcbase);
 
 	/* Read the reg property to get the chip select */
 	reg = of_get_property(ofdev->dev.of_node, "reg", &len);
@@ -219,11 +224,7 @@ static int ndfc_probe(struct platform_device *ofdev)
 	ndfc->ofdev = ofdev;
 	dev_set_drvdata(&ofdev->dev, ndfc);
 
-	ndfc->ndfcbase = of_iomap(ofdev->dev.of_node, 0);
-	if (!ndfc->ndfcbase) {
-		dev_err(&ofdev->dev, "failed to get memory\n");
-		return -EIO;
-	}
+	ndfc->ndfcbase = ndfcbase;
 
 	ccr = NDFC_CCR_BS(ndfc->chip_select);
 
@@ -241,13 +242,7 @@ static int ndfc_probe(struct platform_device *ofdev)
 		iowrite32be(be32_to_cpup(reg), ndfc->ndfcbase + offset);
 	}
 
-	err = ndfc_chip_init(ndfc, ofdev->dev.of_node);
-	if (err) {
-		iounmap(ndfc->ndfcbase);
-		return err;
-	}
-
-	return 0;
+	return ndfc_chip_init(ndfc, ofdev->dev.of_node);
 }
 
 static int ndfc_remove(struct platform_device *ofdev)
-- 
2.53.0



