Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061615;
	b=zerdEkpYu/+jz9STt9b5I1hJpc69K1b9YSZ7fuvrOW5kyOy3cbHAgaKajo9HK4uRPnrQ
	 jA2RG5Buyb5kH2PRV7frLs0tnjq69qm/0mHdbIxWLdtcFuJK8zror4iO+gbrtf2aIksW6
	 GT7+RLdNprip0Nv0aN5rM2ZPBD+ZhB6/bpGFA7Ac1e+1miWayhAGQh1/Up4YruTnhqHIU
	 tpMmi4aBil7xB+Axrxc9vMPVlT8fcCE7C/VSfc0hI5P4jQ8ZdklbpY7T8W9AWQrNFpRUT
	 hjizAecVi3p5Gv8yd0LzFk0kiE7/X5u+BhJTRPEwPjrUPhoa5E13LtVZ/4UnIPLw77A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061615;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B3nDVphg8+v2BOLMRSSIm/1GVf4512imwIA2bkesX7Y=;
	b=QLLQ3y2rhicD8OcrFM1tyo7I9kNNDSnCO/aHxEYKusKWIm3EL84tj0P/4Egamjb62lWK
	 a4U/BRNmR5SXnPkosp1HPv9ygRwX+tRI/cj1jOTFpF2FhecQ0thoWUALOkXkXOlFG5fvR
	 Nt6u8ntFUe6cjc1MPfwmjVLCxMz83xa+D1EGpcUQA5spuKrR6q1PhYEO/trjibm/xd3IR
	 YVGECMLhh0HnttQrTFAHq1dGmDXIA+vyQtHdM8ht+uoeOCKyhrfVtn8AG911MUOp/LCIO
	 uX77qIbX0E81UJdNLPv+7tlz6PGOnucGyYP2lkmDzkdQrvDJcN49Sn+mKyMkEiSdEJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VY+lIP3o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2483160A2605;
	Thu, 19 Nov 2026 04:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VY+lIP3o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7843E1F000C4;
	Thu, 19 Nov 2026 04:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061615;
	bh=B3nDVphg8+v2BOLMRSSIm/1GVf4512imwIA2bkesX7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VY+lIP3osiE4I2evG8BuAJhVEutHKfs0h/T0F1HkMMS884FXKRa8wqEQzUflRT1HK
	 y7Q9aIobvYrlM5L4nf8DJFqUASTkf0G39W2OfXO11Sq7a6tEb3IRsWqn3MnqJhYP6+
	 8QFOxGk8bCP+avXu5xwFvnkl/06AbQZedReaNB1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1616/1848] ASoC: atmel-i2s: use optional API for gclk
Date: Wed, 18 Nov 2026 16:00:54 +0100
Message-ID: <20261118150027.176234314@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 8fdfe8230e160..393b7b5a7d701 100644
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



