Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049848;
	b=v2oymY7kaCMZ3CCumg+Z1Uu0EblTFB0jZqZ8yIhUA2iuK6+FdQSXzoztV59K4UJ8BMww
	 M9n7Kb0qGewCps0g2p0I5CsLLrQ9bVLkKuHUK4YsM36qnHft59+15c8ILJhkvLpheGgNB
	 7ZQgJxZN4P27GQ74DGflIy5B2GfgawvFWKrvzUYCvvIxyyPg/V6vwiueqeEAFJgs/r4HG
	 4sCCFo1AKdFxJZUeB46Osnxx+Z7okb+e7Q4iPsOPBPNsEc2cS+GWeayqHkBicrbxPVZjr
	 uaxIk8wX46ZANRtZpSf7+DBj/TKLV3TLaMk/mFLPvfhBy9LWCYlf7i5o9vhAXSxn0bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049848;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=knDt2C9YBg2Iyyswb03RfXCtPLpAnWx+fYtPugPmKRo=;
	b=lQIltkqT0evt/WYeZNynUNsR7fdQx4WbAJ0BbHGRLHxM1DBkqT9ecSx5QL4bCAQf5l+H
	 lX7b8cRzPJ1PYUkos63BS9RCzSzUKt0fcGcFPAjHJryE+XdSWla92ECWIoM5/2Y6jgo+u
	 B9DkaP20pKmXRwymq34IVO11+jfgmbqd5EPx1Db9p2G4gtgAkrT3KjBZzcOcFq7ymE8+O
	 rYEepPvZds4EvCuZ3ZC5Ef2bQUgJVe/B3EzejOclS2FKtbZg8mqwBWHQ/wGOzQvbwFpxr
	 dXfRn8tdIa9lLL6ywZPsp2TqtjF7OTWcjU2w7DxGsK+DEydHCewh8eugzsl0yvG80CA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ubbPcm8X;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC2F8606A320;
	Thu, 19 Nov 2026 00:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ubbPcm8X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A4041F000C4;
	Thu, 19 Nov 2026 00:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049848;
	bh=knDt2C9YBg2Iyyswb03RfXCtPLpAnWx+fYtPugPmKRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ubbPcm8X+7Rj1uHdLHmCfPXyS2EAz1I/d2kxS/484feijITbs4K2GGCoGYXj2I8m4
	 DdO2hJ0WWU4fPJZdslehqD4646ReV0SOfcMHqGSnBG36+FOJ/7c7prW5H1gEHL52K7
	 xh1tQqb2A+G5QSDMm+r/4mNEYKAGgiWBODM9r1gc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2447/2857] ASoC: atmel-i2s: use optional API for muxclk
Date: Wed, 18 Nov 2026 15:58:01 +0100
Message-ID: <20261118150329.677097107@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit be952abd69c1f2c845e42e72147751e4c910cd81 ]

The muxclk is an optional clock according to the device tree
binding.

Use devm_clk_get_optional() to handle the optional muxclk instead of
handling the missing clock explicitly.

When muxclk is not available, devm_clk_get_optional() returns NULL.
clk_set_parent() returns 0 when passed NULL, preserving the existing
behavior.

Unlike the existing code, errors other than -EPROBE_DEFER are now
returned instead of being silently ignored.

Fixes: b543e467d1a9 ("ASoC: atmel-i2s: add driver for the new Atmel I2S controller")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261002043856.97295-3-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/atmel/atmel-i2s.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/sound/soc/atmel/atmel-i2s.c b/sound/soc/atmel/atmel-i2s.c
index 7e48dd40a13a3..a6f61f0d1a85a 100644
--- a/sound/soc/atmel/atmel-i2s.c
+++ b/sound/soc/atmel/atmel-i2s.c
@@ -585,21 +585,15 @@ static int atmel_i2s_sama5d2_mck_init(struct atmel_i2s_dev *dev,
 				      struct device_node *np)
 {
 	struct clk *muxclk;
-	int err;
 
 	if (!dev->gclk)
 		return 0;
 
-	/* muxclk is optional, so we return error for probe defer only */
-	muxclk = devm_clk_get(dev->dev, "muxclk");
-	if (IS_ERR(muxclk)) {
-		err = PTR_ERR(muxclk);
-		if (err == -EPROBE_DEFER)
-			return -EPROBE_DEFER;
-		dev_dbg(dev->dev,
-			"failed to get the I2S clock control: %d\n", err);
-		return 0;
-	}
+	/* muxclk is optional */
+	muxclk = devm_clk_get_optional(dev->dev, "muxclk");
+	if (IS_ERR(muxclk))
+		return dev_err_probe(dev->dev, PTR_ERR(muxclk),
+				     "failed to get the I2S clock control\n");
 
 	return clk_set_parent(muxclk, dev->gclk);
 }
-- 
2.53.0



