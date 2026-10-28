Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211416;
	b=2xZDfJRP0UidX3QgGlb2L8zkwYmBIZdjcCAN286f/pufnYHAR1Tts2xXOzvZzgIoTlVJ
	 Zkiybt1dW7GDncqnllc+n99tx4Yfn0kpW/mgg+DTe2+b3cgsUzgulNaYVpAisWGy2mOGA
	 DGFRHaOHSZqXksnUFlUl09rBJqFukwrXOot5aPt6t+G1x4AwHsEC8Do+xy/d51yiudapA
	 rkIY7cSyyn/qUVDc+5uN2svtfVcM5RDuCdIRzAYnm8cmFJ3IQdhV8oVcEtIJgQpYp+BW3
	 BQrMblpsyKlpygPLssOlqTh3LJaBoQfvZ09vbJZMHZ5GoV7qzFcLCKMarOB+rV8IiaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211416;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=03bluHOT/AurWayAtV+5hMMww4AyCfB5gFAsCpBi8+k=;
	b=k4+0HjLVdGo7WK0lX0xUI390mFS7dxgYzu73NlH6sd/R+4e4OSGMzmDqK2Ri/iRmIaMV
	 aptx38x1uiesxsVvA73JaDs7Vqe8WvCK2cX4UUow6xJYVal0D1mHn1Yt5Pth2IXCpQdyN
	 n5E35+egqReNSirUbZ/mx/GwyWakRDNMvPZJCOVAvH1nKkW49MdhiP7syro1sC2EdySdL
	 6QhTHagRQQF9NmHkxSriTg3lBwDDWR0G1w+9p6GE/B8sTK903mb8QzYOuzHGrboPMDYo+
	 4YQm7PXxz4QkhR/35FJIQMnTE9ha+QmgpVgMidbCYbwE8/vessZnLdOuDJ+fdyCO6aA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1r80dc9D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AE6C606A31D;
	Wed, 28 Oct 2026 18:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1r80dc9D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CAC21F01825;
	Wed, 28 Oct 2026 18:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211416;
	bh=03bluHOT/AurWayAtV+5hMMww4AyCfB5gFAsCpBi8+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1r80dc9DT1bsL/EeHsmJPQRx+UynodoSDpExyrRJ/QXFEGTBgmnTGB4+0cvxVK8pw
	 o+lBrVLA+8fv/P6eaPTUS52WeNoBY6dg0MPUGQsL/w9TfwhAR+974en+oVisVnB5Fh
	 yWAc/UyJCwq3qfvFa85hDqDXLCq7pc1DCsUE3pZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Han Xu <han.xu@nxp.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 324/571] mtd: spinand: Enable QE on all dies
Date: Wed, 28 Oct 2026 17:57:51 +0100
Message-ID: <20261028170015.693315241@linuxfoundation.org>
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
[ sashal: adapted to spinand_init_quad_enable() computing enable internally instead of accepting a boolean argument ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/spi/core.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/nand/spi/core.c b/drivers/mtd/nand/spi/core.c
index 0adb15c5fd0ad..ef8b0d9accb9e 100644
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



