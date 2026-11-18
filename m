Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041493;
	b=cUXz+DKjRhz0skYTHpNkxZK8M8oKn+EJqJJDYO3ACsugZA6DQO8wJD1zp8X9eceqN7PN
	 nhttfng5vw+JzcJ6oFbDbbAKObNatpQARkMHJZikB3zbN7fnrHHvd79K8iJ9Pjm4H5D03
	 FyMn1f8TExFsgJKB4miy3WRSMVvLk3DU3Ttr8wBCoKumyHLcj1YNqA99UGUeugZByq7Bq
	 +L8gxEBhbF6ZBn+XF64Kn5AYLP1CybxJeEeQd2SUbs8McghUs9tANAj1xA/8dR/3vKKfR
	 aLIxZHRRtRCyaVnlGnpgpIihd5a5M4ZOciiyjCFfitZJntNF0/8Sm5AfZwwQRicYOpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041493;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6Hy8VWxkCdicaSSGcUq0yvmIDJNKyXwQLyBJdgwrexY=;
	b=5D5dSn8wS+WiWGu6QUs/XjtXiAEzUCjXwAP158zgR2fKtDffpugMQbO9aKdZYCxkcWEm
	 tHGHO4o1YjoJkeda4xA1OfJcVAC9Kk7Fu9thnHLBwsLpHFY3b2hiwyj4unyCfPGk3X78K
	 sY9YXa/KpIVu70vp3NxqIbzZnLKRGs7IHssdhySP8nwE8VQQKOGhAa2+Km/e3aYYth6f7
	 DhHrbyd93xTfzdSLgbmGzhfd7gVZhEY8XrObn52M1+ZyxRGSKoHenNYV74QzEKELAGh2G
	 eFZwGVFs3CB9PZrKMjoPRWJ/q4ru3dbuHfJ0W7Y4kjjRCXfdqZ306w9f1dP/uvJAeyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TlE9AGec;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B43C606A980;
	Wed, 18 Nov 2026 22:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TlE9AGec
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD7961F000C4;
	Wed, 18 Nov 2026 22:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041493;
	bh=6Hy8VWxkCdicaSSGcUq0yvmIDJNKyXwQLyBJdgwrexY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TlE9AGec4JhEW0VwZr78mf/isMNKkVIfrIiKrp/YbNModxjovM6EsrYl+70kRBLRH
	 DTchtrzhA0/LeTtBZebNJT5E3Pm5q8fJjmUC/PZJ6k+IY77zpmEDf9ph2uN7gJCsD8
	 P5k1emVn/M6ikEpzoPmdDjIMhaUJlyKcnYXBTIYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2832/3318] ASoC: atmel-i2s: use optional API for gclk
Date: Wed, 18 Nov 2026 15:57:34 +0100
Message-ID: <20261118150445.590406632@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d6ac5a2d067b6..3b9aba680d68c 100644
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



