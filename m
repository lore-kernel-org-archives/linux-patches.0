Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B87C73D34AD;
	Tue, 16 Jun 2026 17:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632310; cv=none; b=o5v0xMQKXPC0Z4u8k1PCW/yuRtNAhLp4fBV+MMH/DelDVD5JisX0TZq2oloC4lDhjZqV++Z+YulYQ3hzu6W5CJstciSATKo5eqc1ml7UGEliJ6NxNPq+ePVyyXAkSsLqyBDy/r89pmYwcQ4DoDsbN3qAnNtzCTL8N0SNYJjBWns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632310; c=relaxed/simple;
	bh=rOttF4f5XdRixOqR/jVRnYiCrj4kAsNj4WyW50ke9rs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eKdr5MQO173jpALHkOoRgDBSVZKySzQg7E1Rxn73faEJ86hLPD1/26JUbjU9wN6tRkt/+l/nMQ72FWBB+d8EgwId+ehVnTDY0+5q9qegZcmjXFU2DLrpitsH9VNUG5zlewK6cwH3KjcqV3El6733cwR2nfjau6LwjEBwxH0qKQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LRMLVqjc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LRMLVqjc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BA9E1F000E9;
	Tue, 16 Jun 2026 17:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632305;
	bh=eqrcO9gQx07lGREdc57TL6+wiOkDr4jE/xoN71KioYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LRMLVqjcNmx/DAXKDBMXMF61vxWBoj7xhYY0HG+naC1+MH9v0e5O5ZPSTIS3FEmtU
	 XMWhS8yXFs3Zkv7lxG0ztZKLx135vPCuAWNU/AbwUC9sHqjQrWtqw9p1/dEIIkE2v+
	 iwdNS7cU41QLuvye9oKkNOh695L4u6kFv7kemExo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 386/522] spi: spi-ti-qspi: Convert to platform remove callback returning void
Date: Tue, 16 Jun 2026 20:28:53 +0530
Message-ID: <20260616145143.853949297@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 2f2802d1a59d79a3d00cb429841db502c2bbc3df ]

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is ignored (apart
from emitting a warning) and this typically results in resource leaks.

To improve here there is a quest to make the remove callback return
void. In the first step of this quest all drivers are converted to
.remove_new(), which already returns void. Eventually after all drivers
are converted, .remove_new() will be renamed to .remove().

Add an error message to the error path that returned an error before to
replace the core's error message with more information. Apart from the
different wording of the error message, this patch doesn't introduce a
semantic difference.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20231105172649.3738556-2-u.kleine-koenig@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 0c18a1bacbb1 ("spi: ti-qspi: fix controller deregistration")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-ti-qspi.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/spi/spi-ti-qspi.c
+++ b/drivers/spi/spi-ti-qspi.c
@@ -909,21 +909,22 @@ free_master:
 	return ret;
 }
 
-static int ti_qspi_remove(struct platform_device *pdev)
+static void ti_qspi_remove(struct platform_device *pdev)
 {
 	struct ti_qspi *qspi = platform_get_drvdata(pdev);
 	int rc;
 
 	rc = spi_master_suspend(qspi->master);
-	if (rc)
-		return rc;
+	if (rc) {
+		dev_alert(&pdev->dev, "spi_master_suspend() failed (%pe)\n",
+			  ERR_PTR(rc));
+		return;
+	}
 
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 
 	ti_qspi_dma_cleanup(qspi);
-
-	return 0;
 }
 
 static const struct dev_pm_ops ti_qspi_pm_ops = {
@@ -932,7 +933,7 @@ static const struct dev_pm_ops ti_qspi_p
 
 static struct platform_driver ti_qspi_driver = {
 	.probe	= ti_qspi_probe,
-	.remove = ti_qspi_remove,
+	.remove_new = ti_qspi_remove,
 	.driver = {
 		.name	= "ti-qspi",
 		.pm =   &ti_qspi_pm_ops,


