Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020032;
	b=Acuo80l/SixmOt0iJsjAy/fZj/GbQSVlhUOsR0s+z0+cQf6SdhyuTgZiKG8JCvgsWx6F
	 JDtiMvtz/nAeved+3WPca7ee5PiOKcU4DGYoQa0c7QiaheTxKRwBwQzPJe7G3UA4wmyZx
	 GbxZqcQz2rZEH5u/B23vrIBnh+LWTxEsperI4jytaVEDI99XQGM7qb7SWth/SA1T3R9/B
	 qUSCK72S0iK/o5/wANu8q3SX4x/a6zYtkCwY4+km7xeu7/xqfukpTmh9PiQ5/IvdRmdgu
	 P4UvSttLDlIk0yy9hyvlhtVLVybn4RAIfx5iMK0UGnqw4ZED7Sdu6d92SHu4AicoJVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020032;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5yj5OU+yeFqt/n66TL9+Zdw7grw8cVgsPlc4DB+O8Lg=;
	b=dAQexzyFB4jOemV8dd3wo09RgB+mjUgwoZm5TGNwO9k4T7pYTjkDCFYef+Ei0C9KcbRu
	 eq0jzAo/AbIOA8N9HSZiml4sFlV4F/r5UpGpalrBwRxI6mXgeDINq8QQZ9zDA4KS8z9W3
	 5QxHl/2EpLfcKc67yLiaXp1XcCPEl0oldidEDY5VSaLyYqNR5u3EzO1Q5h91q9fL1yAwF
	 Bj7w8i1oSymrc7Dctt2BF2ncAnk3uOLwk0Zsx2XgbgMrTJ99LT+YW5u+4gupdXivUni/j
	 t0VQedfdGyfq1qykQC0YRkzpiqouDHHOkNDRf7JMaCKViFyG8eo/9UrA9JAoaDdJxdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w3GUQqrR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B592606A320;
	Wed, 18 Nov 2026 16:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w3GUQqrR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B78E41F000C4;
	Wed, 18 Nov 2026 16:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020032;
	bh=5yj5OU+yeFqt/n66TL9+Zdw7grw8cVgsPlc4DB+O8Lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w3GUQqrRj8DMkFPHrpoS4g8kPsYQKHEJwRl0jndmMpuw5IDFUgqNo6rBKavP8t0HN
	 a1BA0Y8mSD99NQW5NS2rboGm46w/h1Mvqamnb1jNxUhwuRHo7IT6++0BGGbfgZmwsV
	 7IkKQk5AEdXUGiu1S5n0aVzvq2TAZD9lSrTrBwzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1790/2651] ASoC: atmel-i2s: use optional API for gclk
Date: Wed, 18 Nov 2026 15:50:30 +0100
Message-ID: <20261118150351.771461435@linuxfoundation.org>
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
index c52d048449f8f..6ca230f8adc81 100644
--- a/sound/soc/atmel/atmel-i2s.c
+++ b/sound/soc/atmel/atmel-i2s.c
@@ -670,13 +670,10 @@ static int atmel_i2s_probe(struct platform_device *pdev)
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



