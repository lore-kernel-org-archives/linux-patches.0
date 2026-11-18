Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026516;
	b=s3/7GSpBEl3yZ5ebXnucG0dOYo+Q2GGiCDr3oDdrtVRRUT6K84shlbsPbUD968GRIKM4
	 3/ik+ZgPq+P7O+fE1kVZHqVIW8d8NE64yBZ520+ZxQc3qPELHUnV7xW0Mz3bkBlUB4s/X
	 MNiCepG5vH3aDbruS+gyjyWmvUmGAANVP7AhaCxSYlrCebmKwoaM9WmT9Jsv0lWDLQMJB
	 7Z1VDC0UDEmEOnYevGDvaj73DRRCmSIfibbY+m/+Jw8gmGfqCKKFoDc5Z0rpkQ9QgeHWl
	 glTSLzXbRlbZd4ty/G+iooNYhPNsN+0SptmvpXdI5+H9DWnPkPx+uhj0rhbAGyY1Ktg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026516;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d163kNtQTjY96Gs5JyJwLZug6DbVR+iM77qNFmorfoA=;
	b=pb54cQtPkFcrGjUk2FaNpsQVqf9RakDtT5Fe9bMNufYs/nHvxAJ/Hymr28pSqW3PPjZ5
	 31eI3Mb9L7k8R5IR1w/bIhNPVpmaAd6aJDObWs7CFe3bjqr9yCCombe0kP3rdo2nA5wcc
	 VRr6EnO+yT3v8LvV6UyzBtvQuJ9dg2XwDnHDEDZbMI/2kDggklD3f8VBhtEs3rYkG1NZI
	 /P9JloOBBRdkmSBDI/oFwUyzXYgjsOBjUlxtCxanUKJLurOniS3Rg1oJmKYdovWdGJwiQ
	 wf86Tq94iTsv11kPDC+reqZRjv3LAB4QBRgRcN1aLmbP4iuPXyUVoPogJxImZkYisbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="11+x/koq";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E441A606A31C;
	Wed, 18 Nov 2026 18:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=11+x/koq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42A5E1F000C5;
	Wed, 18 Nov 2026 18:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026515;
	bh=d163kNtQTjY96Gs5JyJwLZug6DbVR+iM77qNFmorfoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=11+x/koqFxzaDLHZ1hy7DgNxpHoEJDN28IZidi4p3exd0CJyIuhiSSij7DPkjQlgA
	 /f0cr0bGDDLfVrPm/XylqCTtlZwaBRC3wYCdBJci909abZqKG0ZN4unfzCHxD9KNKR
	 66AJZojNzgqnIaqND3AvAASFJCT5WCeFZ9eQN2+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1461/2151] ASoC: atmel-i2s: use optional API for gclk
Date: Wed, 18 Nov 2026 15:53:16 +0100
Message-ID: <20261118150215.129261433@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit b431a055fb7688c0d3725fa3c55aeef852991178 ]

The gclk is an optional clock according to the device tree binding.

Use devm_clk_get_optional() to handle the optional gclk directly.

Unlike the existing code, errors other than -EPROBE_DEFER are now
returned instead of being silently ignored.

Fixes: 73ad0df57290 ("ASoC: atmel-i2s: Remove unnecessary audio PLL clock (aclk)")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261002043856.97295-4-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/atmel/atmel-i2s.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/sound/soc/atmel/atmel-i2s.c b/sound/soc/atmel/atmel-i2s.c
index 3135445805ecf..eb219223ece20 100644
--- a/sound/soc/atmel/atmel-i2s.c
+++ b/sound/soc/atmel/atmel-i2s.c
@@ -666,13 +666,10 @@ static int atmel_i2s_probe(struct platform_device *pdev)
 	}
 
 	/* Get audio clock to generate the I2S Master Clock (I2S_MCK) */
-	dev->gclk = devm_clk_get(&pdev->dev, "gclk");
-	if (IS_ERR(dev->gclk)) {
-		if (PTR_ERR(dev->gclk) == -EPROBE_DEFER)
-			return -EPROBE_DEFER;
-		/* Master Mode not supported */
-		dev->gclk = NULL;
-	}
+	dev->gclk = devm_clk_get_optional(&pdev->dev, "gclk");
+	if (IS_ERR(dev->gclk))
+		return PTR_ERR(dev->gclk);
+
 	dev->dev = &pdev->dev;
 	dev->regmap = regmap;
 	platform_set_drvdata(pdev, dev);
-- 
2.53.0



