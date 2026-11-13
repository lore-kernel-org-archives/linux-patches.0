Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590897;
	b=ijxjKtu/RKcgz/VqjbZqAbEv1Vlr1YVe74wndP0F0fy80TdoGcZqMcr4V5bhLWmDr1iX
	 pTWf5kN02tk48dOrptIXxpvacF4vzs474qDMzkGhDZaMucHbxud8QCY/4sgRbEAsx9WwL
	 QNE0yQD8Rqv3BttM+Bxaq3laN2WdM7Bf0ZjtAinXvwurJTp9xQtM2KYbqxT1ZQ4VtI6HV
	 eEaUtw0dPK+JZc1a10FJN/yPzPv4TrrHLP29KCG6lpv5gFIRBwTeilxiTgnmb1q38OI0/
	 Ud+A/FJLThkPq3llrd9Bzuwtwu2z4suU8rhjqCGi205JycrBmsyq6wu2gdcZSfICRug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590897;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iDzt7yhe61pPQznbsbIpZUyS9p/MeWNltomjK5KqYqk=;
	b=4amV54enAxQGelj/R2dqGhtCKuqoG5tT2uJqD1JPNkvipswioUvSp+JEuRmQCgspDdXv
	 4bjdguwfFY+8pxss0PuVEln5IuwrSUCpP3j018OptCpQaw3VLm8ZJ3Ah2E7ni1IqOmkzG
	 oe0kM/gzsXnyI5dBU7PsCzqIeVp1At1fFwMlMLheaZe7eyEt/h/Rmz9nEIt4ik3NYToBE
	 PKiqhXYVV3EGSAnKDA4hQCVpqxtmfeJzrCyVgWGR2a+0U1Ly4v3YTJ+FkYzDs3A/Q+i2t
	 q8JErme1i9E+TIkkJajGfHh99N5U+kSsFMCbNNVBalWFEVvRRmlQrXZWjMYHPCfoYcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ERV0yQzm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E638607EE64;
	Fri, 13 Nov 2026 17:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ERV0yQzm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B93B1F000C5;
	Fri, 13 Nov 2026 17:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590897;
	bh=iDzt7yhe61pPQznbsbIpZUyS9p/MeWNltomjK5KqYqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ERV0yQzm766+A5N+ZIPCEQzVcK9gr0JX0EjQXk8TdLryyzO8ldJ3NKNgq2eq5LjQf
	 SyHlDltbEkHYqOFSB4pu8LltnC+v7VKb61vPwU0XH0GmOyM4bMUldtggwo2+UTyz3w
	 PozDOKB9yfL6fPDDw9ZiX9GctyuskwtygFrJuELA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 088/670] mtd: rawnand: ndfc: use devm_platform_ioremap_resource()
Date: Fri, 13 Nov 2026 10:44:12 -0500
Message-ID: <20261113153814.894349536@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a2e2238339ec1..677d05d628a5f 100644
--- a/drivers/mtd/nand/raw/ndfc.c
+++ b/drivers/mtd/nand/raw/ndfc.c
@@ -185,10 +185,15 @@ static int ndfc_chip_init(struct ndfc_controller *ndfc,
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
@@ -210,11 +215,7 @@ static int ndfc_probe(struct platform_device *ofdev)
 	ndfc->ofdev = ofdev;
 	dev_set_drvdata(&ofdev->dev, ndfc);
 
-	ndfc->ndfcbase = of_iomap(ofdev->dev.of_node, 0);
-	if (!ndfc->ndfcbase) {
-		dev_err(&ofdev->dev, "failed to get memory\n");
-		return -EIO;
-	}
+	ndfc->ndfcbase = ndfcbase;
 
 	ccr = NDFC_CCR_BS(ndfc->chip_select);
 
@@ -232,13 +233,7 @@ static int ndfc_probe(struct platform_device *ofdev)
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
 
 static void ndfc_remove(struct platform_device *ofdev)
-- 
2.53.0



