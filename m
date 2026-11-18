Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049727;
	b=AJyFvMt+ENWBC8ruyf1TUxmjY1qiOX43AP62knAJDGgkWCJHx2traZhq0kDcG5pveaMP
	 q9C4avE0kJpcUq0jp5ULoD76aMCYG3sGejr+4XM98YrLDCrnc+oHO7JFgUA0tQjIxzqwv
	 ZwoeGVHoJipz4lrRULymdRKm8goxGe/l5JkdBGiB33ZZbsnSiiGnNWIcIwR0be2NOhg8E
	 2U9c4+KKRZGVkQWQy+9STb/C3iM3TqMgvn++L/DXolYgVWpZ4OidcqIQAdBD6la2Rt1Tv
	 3ESvBiZSC06L6CZKtSGfAFUaBe/4eJ27V8Hl/9vHTeY13oWX7hcU6sRoXld6Xi58VeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049727;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CqmaNFycJdXsIT49o0e0JrNonAkXjdOy7EOJLSrDVSU=;
	b=RQiy4QMf7RuMFEoYwl/jYMk8ulX0XMOZRlGuP80jEOwZzxWlZsrXCQ6uDGqb8C025+3O
	 E+w4rZatOxKm+wqSZ/zZvKUv4vEY++JHoV7LatkXKDoGghUyA7ZBoz/ZOwGz/aBLbXr3P
	 PD+vqRPVsxNg8B60d47UVeHKMFx3k9lKna8lYVHskqW+/kr+xmd7xPSjeJSqibi1j+v0w
	 3+o9PMGWFFezGrOeBtpgCtqyROjCkK4dnxR25On+dZJG4dAEnUK1XjKe78swMskZrC5o9
	 UKq5zZyaCqLwc+wk5tKWvE23ttK9lWI8kT535XOpqgJRSTRKy6GxFVoVyJ28QCy5Gow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jp0TOWV3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80978606A325;
	Thu, 19 Nov 2026 00:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jp0TOWV3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3ACA1F000C6;
	Thu, 19 Nov 2026 00:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049727;
	bh=CqmaNFycJdXsIT49o0e0JrNonAkXjdOy7EOJLSrDVSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jp0TOWV3kBJp3wesFVgy+QBeWJCxpyzzuEn196LGA9vWsSdCcmRsFD8epull8uWQJ
	 4YBvgE2PhvgC4m7gHEdf/dxj0PRvYp05Mky+4UQOflskxLJDYI8Q5ovEUiZ1ICcWi3
	 +OUWyO+eqoIXdDPiUvg0Sismj/y2CISPRgluGY30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2448/2857] ASoC: atmel-i2s: use optional API for gclk
Date: Wed, 18 Nov 2026 15:58:02 +0100
Message-ID: <20261118150329.712056673@linuxfoundation.org>
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
index a6f61f0d1a85a..8ee48cbe42d74 100644
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



