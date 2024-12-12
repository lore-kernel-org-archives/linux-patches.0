Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA7F422968E;
	Thu, 12 Dec 2024 15:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019035; cv=none; b=CNH9kO6TnSL9rfeDWjR61dw9e0O31SA+5xIObkGY9w/5A3V+IVcKOIWFEybWtdFGOCOCmSpaNXlECVL1v0H+9ujGLo9uOnc8IZSgZ6mpgxtiZaEq7n4YCDyejB8Sbtch8OqYbOaaAVGTlhc21aL79X41VupK3gS07+0iGIu3Shc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019035; c=relaxed/simple;
	bh=FLpTvpEu8RkwM8Fv+DsdWp0q5bYbKsw3Y+dkgAm1Fqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TfEofzMIMRFen1T6M2qFGDxwH0MJ6KGcl9InqfLmjIMLvT8c5jCcTwrEXvmUp8RW0hJNNan/aDCZWz2iCvA+V3xE5+O29j44lCSXqxywJmJPPLmgzUk3pWivZUaglzz/B/+GhzAJrHkW3JeDDOU2EKbq2+sC78kVmuVHG2x6F+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OXLLiz6H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OXLLiz6H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1771AC4CEDD;
	Thu, 12 Dec 2024 15:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019033;
	bh=FLpTvpEu8RkwM8Fv+DsdWp0q5bYbKsw3Y+dkgAm1Fqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OXLLiz6HC4PBbw0yiDWCFP0NeBUNFZeT9H0LedSuen4693FWN7/PH7PSvnrR7RNfC
	 YO9/ix2cT1YT1ZD9x1EqgbEocNYXH0wA45jhrC7463Tszq4K0PVaF2kmfRWeA2F8BE
	 mL9/C8V7rbTfU1vrucwAQ7ptxZkaiG0BIUajr5Pg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 092/772] spi: spi-fsl-lpspi: downgrade log level for pio mode
Date: Thu, 12 Dec 2024 15:50:37 +0100
Message-ID: <20241212144353.745563414@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit d5786c88cacbb859f465e8e93c26154585c1008d ]

Having no DMA is not an error. The simplest reason is not having it
configured. SPI will still be usable, so raise a warning instead to
get still some attention.

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Link: https://lore.kernel.org/r/20230531072850.739021-1-alexander.stein@ew.tq-group.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 003c7e01916c ("spi: spi-fsl-lpspi: Use IRQF_NO_AUTOEN flag in request_irq()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-lpspi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-fsl-lpspi.c b/drivers/spi/spi-fsl-lpspi.c
index 7d016464037c3..b9e602447eca5 100644
--- a/drivers/spi/spi-fsl-lpspi.c
+++ b/drivers/spi/spi-fsl-lpspi.c
@@ -908,7 +908,7 @@ static int fsl_lpspi_probe(struct platform_device *pdev)
 	if (ret == -EPROBE_DEFER)
 		goto out_pm_get;
 	if (ret < 0)
-		dev_err(&pdev->dev, "dma setup error %d, use pio\n", ret);
+		dev_warn(&pdev->dev, "dma setup error %d, use pio\n", ret);
 	else
 		/*
 		 * disable LPSPI module IRQ when enable DMA mode successfully,
-- 
2.43.0



