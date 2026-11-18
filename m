Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031736;
	b=wr+2N3tCysgF5V5OjAfayz2yfZVwakeBxTF88GKm8W7XBsHg0LaDgmWE+FOkUYTPAliM
	 gxftt2JTlDSUWofNeoUETP3ixhk8t2YTRY+Q14LIthV+m2WF4F+eUWZUFWe1Lymhb2WV1
	 1nNkYPoipQp0W7r5T5khtjlK6teaAYaLy3V/hpKFBOo7N3e8A6Gz9Cg8sCUFhwenO77Z2
	 s9lupJQoGTbe1rY9mmf16hNyaH/PmuoQhuARBPv+zglCjnARbi7h60ir8WhSrFUMtEGB/
	 3o/ybpg25k3rTkRGhY6iLcEoryIv6gIC9/XrET9ocjx8f+cica6Ouya1M+tPAs8vMMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031736;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xTxeNL060ajK/kP35KUIJygypLpJtmp/l0v5JSe9850=;
	b=uNtjwEfLZrIf55DEJ57EucspDYRuRIK2AYEpbr8wJqSpGWpfaKMx75zzLA1m9XQNRai4
	 VLPJQazUJjnNxgbJT+ZBYiOzE8veOk4DKZL676IxKsyQyrI4QvLtsmsb3hAigdBkFwMK/
	 G8JL8+8kihs1w0FKqQiiOgvL3i2k0mWeLjg2cZH54qnwXKJQW3QT2eLtNAnRY+OARAnmt
	 1uldo9f51tDl07TIJo6EruqL6rS1Z+oisT8YoNfBze/BqCFb+uqrpGOhRIKfrNwkLixIH
	 3nH3dRlnXvXf3lIbldHaJVd5DMrbctTKJPboZBTinCQgALF7IktUB+ca6pXoJ7dAmkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FefAT9MH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EDBF606A31C;
	Wed, 18 Nov 2026 19:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FefAT9MH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ABEC1F000C4;
	Wed, 18 Nov 2026 19:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031736;
	bh=xTxeNL060ajK/kP35KUIJygypLpJtmp/l0v5JSe9850=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FefAT9MH85LEojj9OvMmkDqiQJUeVZTfLtCoUOZfeGbe0DzJBjrZIGJqi+S+m8nTH
	 S5VS8Q88PNUkiCCax6Qhdg6wZFCyXlMiQTebcRd3e63L0U68CLd8JDkvfQP5FzP+O3
	 93HT2QzdfG/maiHreVTt/4AqjqaXPpVbiRsAAm98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1164/1756] ASoC: atmel-i2s: use optional API for gclk
Date: Wed, 18 Nov 2026 15:54:51 +0100
Message-ID: <20261118150056.329346369@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



