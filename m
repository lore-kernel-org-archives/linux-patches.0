Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2E527FD49;
	Tue, 16 Jun 2026 17:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632678; cv=none; b=L+DufnhpNZExV9rpwcd3JiiZtnezhaS6V2CcaybWg51dlqkvzw9TIiW1b6uubUGlyHkVd+U3jy8WJ2ZMfFHgWOOHyby0r08ZjYlXMHhRHjfhnvLNxaSi6LZX2ye8sYUUcRSbAgtwqqzKBIMlTlBt21OHs1NjD2sjLk9J/p32RiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632678; c=relaxed/simple;
	bh=ArrOjWhZlk+sasEziEL5alM19TI5ski+CmT9h2sD/iI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TUXYbGqhI7Gzu0Lm1N9PimTuzXNTEo+KFLwx81h44/tt/Vi/YSKGfbaPjh9InFpzdFpIV0FBIrSWWGkPMmcHr0KPmjwOOgpEHQaVdaMehMLJjfTA32m9NTyEACF7TxQLTkGATeloIiW4DDn8PM+j1JCsu5on1cC44ZQkYbpO0Eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gly7Sn0M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gly7Sn0M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5861F1F000E9;
	Tue, 16 Jun 2026 17:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632677;
	bh=A0zRbY5oNAIeRVHcFnNKmuolzVTIA1Av1aYgiVqn7x0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gly7Sn0M1gpeBCtJHEOVZHDyHvj8Vs18G3Tq7OAt+Y8aSKs7ypb7wEXMU1X29vzN/
	 zTt1V6YTB9rpinLHlMB/bqgKvEeS/jo1kOTrrbKZJRD5WdwCfrpZieXx27TMf91FTy
	 R/LaqCvTulxn3cH+xcqr4b2nMOPXBSjpggrwx4wQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruan Jinjie <ruanjinjie@huawei.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 457/522] iio: adc: fix the return value handle for platform_get_irq()
Date: Tue, 16 Jun 2026 20:30:04 +0530
Message-ID: <20260616145147.279460849@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruan Jinjie <ruanjinjie@huawei.com>

[ Upstream commit c09ddcdd4dd32ee9768dc233ead4b3d726f26d38 ]

There is no possible for platform_get_irq() to return 0
and the return value of platform_get_irq() is more sensible
to show the error reason.

Signed-off-by: Ruan Jinjie <ruanjinjie@huawei.com>
Link: https://lore.kernel.org/r/20230727131607.2897937-1-ruanjinjie@huawei.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: 0d42e2c0bd6c ("iio: adc: npcm: fix unbalanced clk_disable_unprepare()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/bcm_iproc_adc.c |    4 ++--
 drivers/iio/adc/lpc32xx_adc.c   |    4 ++--
 drivers/iio/adc/npcm_adc.c      |    4 ++--
 drivers/iio/adc/spear_adc.c     |    4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/iio/adc/bcm_iproc_adc.c
+++ b/drivers/iio/adc/bcm_iproc_adc.c
@@ -540,8 +540,8 @@ static int iproc_adc_probe(struct platfo
 	}
 
 	adc_priv->irqno = platform_get_irq(pdev, 0);
-	if (adc_priv->irqno <= 0)
-		return -ENODEV;
+	if (adc_priv->irqno < 0)
+		return adc_priv->irqno;
 
 	ret = regmap_update_bits(adc_priv->regmap, IPROC_REGCTL2,
 				IPROC_ADC_AUXIN_SCAN_ENA, 0);
--- a/drivers/iio/adc/lpc32xx_adc.c
+++ b/drivers/iio/adc/lpc32xx_adc.c
@@ -173,8 +173,8 @@ static int lpc32xx_adc_probe(struct plat
 	}
 
 	irq = platform_get_irq(pdev, 0);
-	if (irq <= 0)
-		return -ENXIO;
+	if (irq < 0)
+		return irq;
 
 	retval = devm_request_irq(&pdev->dev, irq, lpc32xx_adc_isr, 0,
 				  LPC32XXAD_NAME, st);
--- a/drivers/iio/adc/npcm_adc.c
+++ b/drivers/iio/adc/npcm_adc.c
@@ -244,8 +244,8 @@ static int npcm_adc_probe(struct platfor
 	info->adc_sample_hz = clk_get_rate(info->adc_clk) / ((div + 1) * 2);
 
 	irq = platform_get_irq(pdev, 0);
-	if (irq <= 0) {
-		ret = -EINVAL;
+	if (irq < 0) {
+		ret = irq;
 		goto err_disable_clk;
 	}
 
--- a/drivers/iio/adc/spear_adc.c
+++ b/drivers/iio/adc/spear_adc.c
@@ -311,8 +311,8 @@ static int spear_adc_probe(struct platfo
 	}
 
 	irq = platform_get_irq(pdev, 0);
-	if (irq <= 0) {
-		ret = -EINVAL;
+	if (irq < 0) {
+		ret = irq;
 		goto errout2;
 	}
 


