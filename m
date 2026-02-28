Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7565346FA0
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302240; cv=none; b=INilOXtQG936SvNGgo7UZzd5Vt/2Dc6S9VTjQuiDUUV27JDE1ZnmCfYlfBzwv2EfCyFrE4Te/rVvZyRme+k354QFrfkjB543xoMcfJPOb/tvY5SnzOBqjtT7ABzO5Okq07mdzOd2MQ8xQN0ZwyN3R/UD3439twQC6WIiwdxJEaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302240; c=relaxed/simple;
	bh=HQ4tIRf1tsKLjUa8K6jwg7ruQLLdjFIAL6z7N4DuP0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NOZlraywVakGQeWxvG7c692g8InAPNYXv0d0BxpehIw13xyAqjXm5wVfM5GRkOA7RYzmEwlmczFG97RvCWsbdwzu4NEgoDptUZk3y6lAreABOk0jEECBvENdL9BgVgBR1Mn3BGpxA3/GdFwiHuV7bvyqyKuVQphi8ync6z8C8Dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FMlnuN25; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FMlnuN25"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38ACDC19423;
	Sat, 28 Feb 2026 18:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302240;
	bh=HQ4tIRf1tsKLjUa8K6jwg7ruQLLdjFIAL6z7N4DuP0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FMlnuN25iNsTDpKW7uAOmDqIeJFa7T3Woxpgj7PFRGDVgfHQ2hCrRlcjsv/hxqf/r
	 QZIA3V+NH6LJYs9U5B5unpGOLEkueHETrJEoY3y4BCSbutv3UrHHz0oqQPIfDecje/
	 fAevx9ZFgFHjBiBLBDtUbLdpxJ3nghFYmzJOUen85XPiqB7J/l+zhHESm73yIu7PMy
	 buN6fzwrhbtQ1DdFRv4NKlzsyov8C3wZ4ug0dSlNpxxp+oWMc4YI3sXPagSm8E1NIb
	 TfL+oUBGjpaDYlxNzgsVDoBFLo1jCa6KYgXJ76TdH7IozZVnbCh/C8jD8IflJyv5Us
	 elIoLlPvNVPQg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 252/283] dmaengine: fsl-edma-main: Convert to platform remove callback returning void
Date: Sat, 28 Feb 2026 13:06:34 -0500
Message-ID: <20260228180709.1583486-252-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit fa13c3ef3f45bca5a1474755dac57bfaf28ef61b ]

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is ignored (apart
from emitting a warning) and this typically results in resource leaks.
To improve here there is a quest to make the remove callback return
void. In the first step of this quest all drivers are converted to
.remove_new() which already returns void. Eventually after all drivers
are converted, .remove_new() is renamed to .remove().

Trivially convert this driver from always returning zero in the remove
callback to the void returning variant.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20230919133207.1400430-13-u.kleine-koenig@pengutronix.de
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: 666c53e94c1d ("dmaengine: fsl-edma: don't explicitly disable clocks in .remove()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/fsl-edma-main.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/fsl-edma-main.c b/drivers/dma/fsl-edma-main.c
index eccbcf67951fb..7dedd85d74d9b 100644
--- a/drivers/dma/fsl-edma-main.c
+++ b/drivers/dma/fsl-edma-main.c
@@ -669,7 +669,7 @@ static int fsl_edma_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int fsl_edma_remove(struct platform_device *pdev)
+static void fsl_edma_remove(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
 	struct fsl_edma_engine *fsl_edma = platform_get_drvdata(pdev);
@@ -679,8 +679,6 @@ static int fsl_edma_remove(struct platform_device *pdev)
 	dma_async_device_unregister(&fsl_edma->dma_dev);
 	fsl_edma_cleanup_vchan(&fsl_edma->dma_dev);
 	fsl_disable_clocks(fsl_edma, fsl_edma->drvdata->dmamuxs);
-
-	return 0;
 }
 
 static int fsl_edma_suspend_late(struct device *dev)
@@ -749,7 +747,7 @@ static struct platform_driver fsl_edma_driver = {
 		.pm     = &fsl_edma_pm_ops,
 	},
 	.probe          = fsl_edma_probe,
-	.remove		= fsl_edma_remove,
+	.remove_new	= fsl_edma_remove,
 };
 
 static int __init fsl_edma_init(void)
-- 
2.51.0

