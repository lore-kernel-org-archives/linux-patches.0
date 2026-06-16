Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27DFA3AE71F;
	Tue, 16 Jun 2026 17:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630035; cv=none; b=C5IdIt3JSo9MlVzuqdXqI5P8R3tRoYk29jwOqCvhQfQCqjhtFS8GOfGga2WdSVstesr904HpI1lfiiUXGICsC1NXUC8ec4Yu+Lvt+7zSRxBrS7p5z6zDEczKo1ppKVQAABqkctZ/5WR8gvoLPilioz4zlKYlpnZ/9t2tRGGT/Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630035; c=relaxed/simple;
	bh=6KMgABJ+1RtbnqzpmNDlZcblsUghVZEt4KRQ16flod8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dS1NZtk2pSchp5oOA4YLSXjjIATzslEFqsVZp98AzjBBbs61/TAu1YYi90my7QUT2U8fCTn9RAX8XwZ+zyJRID0bKo/zQD1uH4fO1O2N25O7H73z8gjz0majLg/xoXJapImQhdz8Et34rJV0L42JaIR1WW2YROz7lKbF8428Hzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LZ7rbee+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LZ7rbee+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F7341F000E9;
	Tue, 16 Jun 2026 17:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630033;
	bh=Gckf4jqNA5EurqrZO2MKmu0Y4aKEPIeqcRLC9jRh2vc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LZ7rbee+cG4zJ04xShf4mdejb8UIx2QttXMgzO0mmeq7X2Zg/8sNw8A/eqeSfyY2K
	 RTxBG7tMTTe29eaSgvo+R4hNefS8nzJnO2PqpQw9ww6NURh2SXTGL/zQ6AGbNQW+29
	 zQkpTgumWAqKP9Z8y1baqm22U4OIH0hnDkvVGmHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 398/452] iio: adc: npcm: Convert to platform remove callback returning void
Date: Tue, 16 Jun 2026 20:30:25 +0530
Message-ID: <20260616145137.774791053@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 5253a5cc7709688b9a000f7928bfaa3366d0af98 ]

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is ignored (apart
from emitting a warning) and this typically results in resource leaks.
To improve here there is a quest to make the remove callback return
void. In the first step of this quest all drivers are converted to
.remove_new() which already returns void. Eventually after all drivers
are converted, .remove_new() will be renamed to .remove().

Trivially convert this driver from always returning zero in the remove
callback to the void returning variant.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20230919174931.1417681-18-u.kleine-koenig@pengutronix.de
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: 0d42e2c0bd6c ("iio: adc: npcm: fix unbalanced clk_disable_unprepare()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/npcm_adc.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/iio/adc/npcm_adc.c
+++ b/drivers/iio/adc/npcm_adc.c
@@ -320,7 +320,7 @@ err_disable_clk:
 	return ret;
 }
 
-static int npcm_adc_remove(struct platform_device *pdev)
+static void npcm_adc_remove(struct platform_device *pdev)
 {
 	struct iio_dev *indio_dev = platform_get_drvdata(pdev);
 	struct npcm_adc *info = iio_priv(indio_dev);
@@ -333,13 +333,11 @@ static int npcm_adc_remove(struct platfo
 	if (!IS_ERR(info->vref))
 		regulator_disable(info->vref);
 	clk_disable_unprepare(info->adc_clk);
-
-	return 0;
 }
 
 static struct platform_driver npcm_adc_driver = {
 	.probe		= npcm_adc_probe,
-	.remove		= npcm_adc_remove,
+	.remove_new	= npcm_adc_remove,
 	.driver		= {
 		.name	= "npcm_adc",
 		.of_match_table = npcm_adc_match,


