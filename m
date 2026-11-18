Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037343;
	b=eyxJu20N8R4SJF6jDjlrMAiEzJLBA2iBhKx10YN9XTUeugT3gVtLDuwxzSZaZVAmkADw
	 KRVv9AXKIF0uj+DVhZMEyjfAHIOz2T7Es4YkqyTmL3wxBmx47qkRGq91h7Ruuq80+JtiG
	 t1qFD6QX/p7Qq84VSGkAxNDnRp+LDmLExbKMcEtb67e9d3Fb5e+W/3I9wWu5zr7fUGSeK
	 Rbvk7XzugofjT4V0SNnhmGD9MDK1Zq+6lO0bZRAG2e7kEZ+Skw/FslCGiFyOsM2XaWzuq
	 wa0xD/Jd0HCgRyJQuVPePisZX94s4SPP6AzQWHR9wcKD/yq9UOOQ6DPGm/odvH10mlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037343;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NqANzGg0C0tamy/etOtxidZX+PJhHPmCghDSw3aEMzY=;
	b=IVAmaucgx7xy+DjfSO7JqVpaMslJmwAuUYnRMbS6RNSaSizMJbowKfV2bm+Z8nIhLHmq
	 xPvjRculwzQQoknv6dLv4Z6PxB2UflcxPjNMePMOJvni0HnpjaYlhsaMaedDfz25sFRZ0
	 XjF36sSsTZQIqmtE61C55ciCEMxj0V50nU0kXwjvsN9zfX1qU5zgKT0hM2xlr/XF3ItQS
	 pBnjOXPpg3GqClReM91ZQeRFlVB6oXCgZvQfIY2GTr8QFHu5os3nvR8woBEIrayLyZXal
	 CwZU2erBPzw0KxN5SDiXImvnVfxpOXT7pWpq4HcUsG7z7WPAEuUy7/sOBJN50Q9JqLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="C/CPUDRf";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53CC60A2616;
	Wed, 18 Nov 2026 21:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C/CPUDRf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1D841F000CD;
	Wed, 18 Nov 2026 21:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037343;
	bh=NqANzGg0C0tamy/etOtxidZX+PJhHPmCghDSw3aEMzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C/CPUDRfySRXbWzXNZk2H73jyPLUMKQNkqtRTPyPB7TstWZcDQDE3G4GlYAKD2c6q
	 Ug/KkJxB+h98LVW1hPY9KVciDPdZds5uh7whDiCPPCKQnlIv8CpRFlJ48YQN8Tqe4H
	 K/wuQBz7INv/6uHTapMgyYMwXRwR+BS57ANKT2WA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1370/3318] mtd: rawnand: ndfc: use devm_platform_ioremap_resource()
Date: Wed, 18 Nov 2026 15:33:12 +0100
Message-ID: <20261118150401.598772468@linuxfoundation.org>
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



