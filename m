Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015586;
	b=kBsmeHd9BMcQYXb3xLU0hsN/20pQ0SuGezkcSK+eCw0oapZdVp0UUqCBpNcwbiyB0L8K
	 X95oA3hJxpp1ZCjKzcHT/ZHXL06SEwPTsKXnloQIhyisjc4631/z3yrvoluN51UuO4T94
	 NKQ1TOREZ1w2xL/nPcGi1DwOEPmsCl2hwbsgVB+FUI0VpHzeYirkBe4N5i0B/gUYsVfHs
	 jyCdQly+nPYl9nDx1zITlUvZHpsvs93axj5P7mODExi0jwlM4zyO4Ea4GNaPQd8/hpYrQ
	 7RZa/lSsHghqHyp7veBlwl5PlgbLTIoi84kbpEylIpDAnQbXqo5UcEDVVfzODtX2Ywg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015586;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ID5CjipBeL3gENdUjoq0nkSdZjrOrR09ou92C+dYKFY=;
	b=5F6ShEnF/FCrFd02emSmRJ1denO9vKz5MxgwdT2A5jhPkmrmBg8Fh/U8Wx03JMvliof/
	 7A92pzppDrv/pKmeW3RZAeZVmZm/TeaEL5IKP0+EZ8v0iOMUQ5w81xS1Qr4gMOwFqSuBb
	 dJC5nEBIDoqOIfHN0ZjalPxAiX1MN59mDLPbrMgGlXQydoD8WXLffvwiAtmGbN2FXgoB7
	 1anRNn01qmhqmyHbDjIbezBCr2YvUObR90A5H846ZeWt+oLijX/D/Xag4/+Ke/03qaTXU
	 H0bJ58Ys3+e7yoW9IvIS+MhbEWtUbAmYxzIdKnQfnBQQlzaKEniZfxS219klvRQKCeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="0+Z9/PZO";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72488606A31C;
	Wed, 18 Nov 2026 15:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0+Z9/PZO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 375DF1F000C4;
	Wed, 18 Nov 2026 15:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015586;
	bh=ID5CjipBeL3gENdUjoq0nkSdZjrOrR09ou92C+dYKFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0+Z9/PZO9i3fefWnKjQ99hIgXkb7GnIpaBtHlkRLBqBlgx50ZBBH8oP1A9rL7djzm
	 fyle0lyZM75c4RsSo48KthHoG/aruBWdjGkIDZqwU3GelPN1Lp0Ig/0bXRNsG+V1Cy
	 1KAVHoGzKbpiWcc7yOGHEpLrqrLVqSdmJwQ8D9Eo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Hilliard <james.hilliard1@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0226/2651] mtd: rawnand: sunxi: propagate user-data allocation errors
Date: Wed, 18 Nov 2026 15:24:26 +0100
Message-ID: <20261118150256.004051784@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Hilliard <james.hilliard1@gmail.com>

[ Upstream commit 8696502b0aa96bcbb1f1e78ae117726378823ae8 ]

sunxi_nfc_maximize_user_data() returns -ENOMEM when its per-step
length array cannot be allocated, but the caller ignores that error.
The NULL array then makes sunxi_nfc_user_data_sz() report the fixed
four-byte fallback, which is not the layout that the variable-length
setup calculated.

Return the setup error so an allocation failure cannot silently select
and validate a different OOB layout.

Fixes: 54dcd6aa69db ("mtd: rawnand: sunxi: introduce maximize variable user data length")
Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/sunxi_nand.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/nand/raw/sunxi_nand.c b/drivers/mtd/nand/raw/sunxi_nand.c
index 89fe3c0379f74..5c4c027071a07 100644
--- a/drivers/mtd/nand/raw/sunxi_nand.c
+++ b/drivers/mtd/nand/raw/sunxi_nand.c
@@ -2072,6 +2072,7 @@ static int sunxi_nand_hw_ecc_ctrl_init(struct nand_chip *nand,
 	int total_user_data_sz = 0;
 	int nsectors;
 	int ecc_mode;
+	int ret;
 	int i;
 
 	if (nanddev->ecc.user_conf.flags & NAND_ECC_MAXIMIZE_STRENGTH) {
@@ -2172,9 +2173,12 @@ static int sunxi_nand_hw_ecc_ctrl_init(struct nand_chip *nand,
 	 * The rationale for variable data length is to prioritize maximum ECC
 	 * strength, and then use the remaining space for user data.
 	 */
-	if (nfc->caps->reg_user_data_len)
-		sunxi_nfc_maximize_user_data(nand, mtd->oobsize, ecc->bytes,
-					     nsectors);
+	if (nfc->caps->reg_user_data_len) {
+		ret = sunxi_nfc_maximize_user_data(nand, mtd->oobsize,
+						   ecc->bytes, nsectors);
+		if (ret)
+			return ret;
+	}
 
 	if (total_user_data_sz == 0)
 		for (i = 0; i < nsectors; i++)
-- 
2.53.0



