Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050166;
	b=M4iSRudfHAciMXjmA2oDx4otrTBWcbJHySi1D4WrFTk22mqDbkoBfelLSfaDcdLpcvOi
	 ONKzsp6nmeWWFJp/RxUF1r2vcjGIqHKfWlRZ5L2RDOQRJffoKVB+Rmbs8p09RqdaFHvmg
	 chUJ1wRfwBa5JofdF1hRlTcJHii8Gw1WFNrKdg2AKou4+BPw4vSJHU2GnDItptuTokY6E
	 VTpSiI5n1IaLAZSA0tfB/u6E8Ohck1/d1Qh4hBsuDunctQRvwvkpRFKHZhxOauTy4zA/9
	 sq+NUXZPiloGL8KwMhChkCgU7h9+qfgEWojOpy0HcO02IDIUha50lXk+HuIuDDKHLHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050166;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RpQudfYZ5bLdeGDSjC4aZxlnFNfuQ9ZwywQihlhY+0A=;
	b=uwHamVA+VWKS5q67XwSlPNgZSsO17xmfj8xqfWY9u6/CC/u6+AwdlZqLzobszI88EHpw
	 2VBPjr2pC4LgP+mPUTMP+nxEwxQgbcsCcuUEJ6DW7sMSuh5Gw5j9PATHbvrtSkJScgZsW
	 vrsDtxvmDhxTDUpFAxuN2NfKcUDVaN46f6tslhIeaJlKbDmm22uK1vNW1n9bRFECnd1PB
	 IsXA8vqDCTzFC+isttNfQBmF+HTWpAXfhzMLrkncj9AXL59gYMz29+3kTIFc2jOnqG961
	 Vrxo6cNEKthGopza/T8VRDIt2MfH9OpZzTtUfMrGXXcqMIMozyJLs16J67pUuNL/nhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XNEZzPHV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A7160A2600;
	Thu, 19 Nov 2026 01:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XNEZzPHV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB0641F000C6;
	Thu, 19 Nov 2026 01:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050166;
	bh=RpQudfYZ5bLdeGDSjC4aZxlnFNfuQ9ZwywQihlhY+0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XNEZzPHVKe1NETNO/7fTri6tEARcHjkuJCnDNRcEahINSE+Zw1gIzyD+7qCkxPfNY
	 Ej7Z78vwqye9MSUMt2SdgZCrY05kwJBGx0sMEZauve9jxQeTQkTjBqG01IBI98lIxp
	 nlt0kHpoPEUjZTV4dTb+5aJmcctabLbtHlxF7e1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2610/2857] ASoC: codecs: tlv320aic32x4: Fix Wvoid-pointer-to-enum-cast warning
Date: Wed, 18 Nov 2026 16:00:44 +0100
Message-ID: <20261118150335.551565150@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 66de320b0214a60095287ba1afa09e870d8cdbe5 ]

'type' is an enum, thus cast of pointer on 64-bit compile test with W=1
causes:

  tlv320aic32x4.c:1352:18: error: cast to smaller integer type 'enum aic32x4_type' from 'void *' [-Werror,-Wvoid-pointer-to-enum-cast]

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20230815143204.379708-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: f28c09b7e62f ("ASoC: tlv320aic32x4: Fix definition of TAS2505 HP Driver Gain Volume control")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tlv320aic32x4.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/tlv320aic32x4.c b/sound/soc/codecs/tlv320aic32x4.c
index ffe1828a4b7ed..6829834a412fc 100644
--- a/sound/soc/codecs/tlv320aic32x4.c
+++ b/sound/soc/codecs/tlv320aic32x4.c
@@ -1349,7 +1349,7 @@ int aic32x4_probe(struct device *dev, struct regmap *regmap)
 		return -ENOMEM;
 
 	aic32x4->dev = dev;
-	aic32x4->type = (enum aic32x4_type)dev_get_drvdata(dev);
+	aic32x4->type = (uintptr_t)dev_get_drvdata(dev);
 
 	dev_set_drvdata(dev, aic32x4);
 
-- 
2.53.0



