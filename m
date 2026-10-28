Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213135;
	b=e8NpmNvJNYVVPdj+oPGDd9wLzrcO9vh479GKn/3/qPvCy8KrnVKBJ+5aRUwRDKeSAEKH
	 gM4Btjy2sc1x2TFe1Z2fRqVsIItjH70iN5CKMR31qtoBERpYYrkVDYvbl1YZsUXkwychA
	 UHhOArKWS1oUGkOoWRXKy/hXoBvSwZ9YN0BiNK8arRojJA4AguZCHteiVo2PfasqfWsvG
	 s3K9XPCXxD/omnR7m9ahCSbNswqBX4P45FR+DdPsApdMEaTY4G7tU1Ka6a6ZMJxacWAIG
	 fcA5JBmx7LDuots4cpme826sb72c0dsqGNQyIQop/R7OF2Tcv3cBykz0ltwYG72If2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213135;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=C1yfPK5pAj6WDIP5KSR4Kk8ZprRC5cLu6pswyJ/CVsY=;
	b=kqGUnNBgsKekGsLXCQwEeSeoO4GIxUdZnX43FjCUiRdeA/v+UFgqc3Wm3QJCVvCQ9uc+
	 iM0kf8K5MTzqpMaWokeOuWFJ2TWAUYW2snS0We2oQEbZ2FquTXOezDOlZlaefV6R3YICk
	 D7ZkFSaKf91bLM779IXpWzviFQoqhPqfijdgfEHCtoNxrpere+bdluZ2CCDrR2Usz2vpq
	 fTcaHnRrpDH2vSa8ESEn3a26egNMyTa216p9vsK5ZO97eVCsp44x6AEleMkHbj89wSJ5r
	 6KtD4WVbJz0AIOWcUFcFvDPS3qVntiXpd6KiqySlQYQkj4OTUvFYlcNcujiwhhj57sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yD19L+C6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E1A6606A31D;
	Wed, 28 Oct 2026 18:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yD19L+C6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0CA91F01825;
	Wed, 28 Oct 2026 18:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213135;
	bh=C1yfPK5pAj6WDIP5KSR4Kk8ZprRC5cLu6pswyJ/CVsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yD19L+C6Pp4Pwyata4C2WbOJNZsUso+Qs/muKSjE/Z/MIuwmrMRN9+ColzZVzYUYw
	 zwQIgBQKHJ5e+/Z3AERlBp0EvHhODa12G/kpkFrWBYAw5/PZfBqyxI3ayIDw5Xr1Si
	 GOBIA/RPb/YQTfZQJd82tMWsmaC3N6mv3FI8jsq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Han Xu <han.xu@nxp.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0400/1887] mtd: spinand: Enable QE on all dies
Date: Wed, 28 Oct 2026 17:41:36 +0100
Message-ID: <20261028170508.334744978@linuxfoundation.org>
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

From: Han Xu <han.xu@nxp.com>

[ Upstream commit 63d6cace2c4a7f36c1cb44f1bb5e0f3ef19e5c7f ]

The QUAD ENABLE (QE) bit is stored in a per-die configuration
register on some SPI-NAND devices. When a device contains multiple
dies, updating the QE bit only on the currently selected die can
leave the remaining dies operating in non-quad mode.
 
Iterate over all targets and update the QE setting on each die
during initialization to ensure consistent quad I/O operation
across the entire device.

Tested on ISSI IS38SMW04G8B.

Fixes: 7529df465248 ("mtd: nand: Add core infrastructure to support SPI NANDs")
Cc: stable@vger.kernel.org
Signed-off-by: Han Xu <han.xu@nxp.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
[ sashal: adapted spinand_init_quad_enable() to use its internally computed enable flag instead of a parameter ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/spi/core.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/spi/core.c b/drivers/mtd/nand/spi/core.c
index 15c54d61cedbd..17d9c5ea26701 100644
--- a/drivers/mtd/nand/spi/core.c
+++ b/drivers/mtd/nand/spi/core.c
@@ -179,7 +179,10 @@ static int spinand_init_cfg_cache(struct spinand_device *spinand)
 
 static int spinand_init_quad_enable(struct spinand_device *spinand)
 {
+	struct nand_device *nand = spinand_to_nand(spinand);
+	unsigned int target;
 	bool enable = false;
+	int ret;
 
 	if (!(spinand->flags & SPINAND_HAS_QE_BIT))
 		return 0;
@@ -189,8 +192,22 @@ static int spinand_init_quad_enable(struct spinand_device *spinand)
 	    spinand->op_templates.update_cache->data.buswidth == 4)
 		enable = true;
 
-	return spinand_upd_cfg(spinand, CFG_QUAD_ENABLE,
-			       enable ? CFG_QUAD_ENABLE : 0);
+	/*
+	 * QE is a per-die setting on some devices. Program each target
+	 * individually when enabling or disabling quad I/O mode.
+	 */
+	for (target = 0; target < nand->memorg.ntargets; target++) {
+		ret = spinand_select_target(spinand, target);
+		if (ret)
+			return ret;
+
+		ret = spinand_upd_cfg(spinand, CFG_QUAD_ENABLE,
+				      enable ? CFG_QUAD_ENABLE : 0);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
 }
 
 static int spinand_ecc_enable(struct spinand_device *spinand,
-- 
2.53.0



