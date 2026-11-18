Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056189;
	b=uccnf2ojaEef8bysVGZb6dJcgelUF3ZkPgfzySxvV4viNTT5vc9HBjpimvstlyR43zko
	 Ba590EoXhMPTNQr3pdh0GgYF96Onq+KsnsMV6zLCx+w1DsfRELsWGM61X7iY7gakkOIwM
	 4KF0256aCbc49esuu3JPJX1jCAdyHx3z+02CuRChhm6b3WMXF3qaW3LMp9kkUZPE9FWm3
	 rNF7uJmJOpvw+YCnNaqjKbq2TwTttKffA5n2/fVddGmCJgrnDbXVeW5K4nzk7GwvDLpDF
	 lxogApBSCuNFtibge5NpryZZAuqEqwK18sZVRBdLKtDmZ401uwsx8mIN4fwL8EDbE+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056189;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jLDnjp+Oe6D8IF8e5CVMb2QDElewjVv3kP1niLhGD4c=;
	b=eBymmf2MbcYgY/WiiVsLi81RzwZhxq6afv2G1CXqWZ2YBNtOyXqCUPXVe4i4TQxfRLcM
	 xrcJAdMe+Qug81E80Yn7/nS4SX1+3i3CiTtztQ7MDnyzoRJvUkoTGmP2e7qnq7kBzqEaa
	 rKgKkVLGR+w/cTPARTFl/4xKdRok+oGYwmHI82BAmV/zSztK6PK/ed0bUmnLzuH/zLKvk
	 NxRuXmByczYNxbnzyJmlTAYlrkcZelHtZjt7YuA6U9Rt3X+qyVhatKD2gZlrj/vVt4rrZ
	 nnzIzukFyRxstXoYEBGlEkEx/vvxWgLutscJD+CN4zX0FuCcOUhbN1iynbsPY+G7d3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pEncgVje;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68550606A325;
	Thu, 19 Nov 2026 02:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pEncgVje
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C49C1F000C4;
	Thu, 19 Nov 2026 02:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056189;
	bh=jLDnjp+Oe6D8IF8e5CVMb2QDElewjVv3kP1niLhGD4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pEncgVje8tzJoaz7s2IzvHRWiTvM0YsTZal+dtdZvV9okdQeeDAgONZp+OY3VmXS9
	 TWfPOS2rOL2FeMVyJ6tr7UJVoi/vIYFgtYXy0eH2HtJ6Jf2I8Q6MYt3ge/Phb/XwY5
	 VYZkIizXpKD+ak5+stGqB0pkoBWJptlLMtAEVRac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1897/2214] ASoC: atmel-i2s: use optional API for gclk
Date: Wed, 18 Nov 2026 15:59:33 +0100
Message-ID: <20261118150127.054733515@linuxfoundation.org>
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
index c753d45ce9480..7bfc0f418e330 100644
--- a/sound/soc/atmel/atmel-i2s.c
+++ b/sound/soc/atmel/atmel-i2s.c
@@ -665,13 +665,10 @@ static int atmel_i2s_probe(struct platform_device *pdev)
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



