Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E3A7477982;
	Tue, 16 Jun 2026 17:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632395; cv=none; b=LRxpscK2kUksDlPDwtKFL2dryyBteoDnyL3D9tYuauZbnH9z5cSfNJdX1MVPDNjHHdsVz1EOOkF8auTDM6B/R8uHb1g32cjX8pWAx9HPVlfPrZNVFfbsXURrWvp/nVrpWntEJIBZ3CglPBDetmROT1MASR25zDYeNb9XPop1s0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632395; c=relaxed/simple;
	bh=sY3dyfwm9ZhumK1dRDxQ9iaRs7YobNa8tUk6hZXISxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rHQuZ8AW7pVtMfapeX07m8rL6FniUDhkTgNutEvPhg6PwWlZLjTiqVxUv0LQM6iB03u3gymWTGiMwMNyg11MMU54fTQjVsTSX9oHO8L3z9VswEZEVoTBTk7CA87UzT7bt4VkmPEsu4icPyVL24Gql7+l73+kEmm/9GImEEvYUsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N7PFFCX0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N7PFFCX0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C0141F000E9;
	Tue, 16 Jun 2026 17:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632393;
	bh=kZeK0fC1P/PV2+icHu4G5y2Zp72g45t+yGqs5diSj1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N7PFFCX0B856ueG5+zMKAyjCA5fD8wIF/WUyDKZE0ys1pENsXYaV0m8RXHDcwdav+
	 QdBZ75bLR8DS7pnhTiS9Girro+rwItpVeTTvnxEU3Sg7K10fskTE3WSNc2Ft1+DbuH
	 WkCwaNCNeb7rtpPa04e5JoCuCMA/AHKNbheGWkTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 401/522] spi: uniphier: Convert to platform remove callback returning void
Date: Tue, 16 Jun 2026 20:29:08 +0530
Message-ID: <20260616145144.829010164@linuxfoundation.org>
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

[ Upstream commit 1b13d196d2813dadc1947940dbd4aaad6ae21c02 ]

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is (mostly) ignored
and this typically results in resource leaks. To improve here there is a
quest to make the remove callback return void. In the first step of this
quest all drivers are converted to .remove_new() which already returns
void.

Trivially convert this driver from always returning zero in the remove
callback to the void returning variant.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20230303172041.2103336-84-u.kleine-koenig@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 0245435f7772 ("spi: uniphier: fix controller deregistration")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-uniphier.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/spi/spi-uniphier.c
+++ b/drivers/spi/spi-uniphier.c
@@ -775,7 +775,7 @@ out_master_put:
 	return ret;
 }
 
-static int uniphier_spi_remove(struct platform_device *pdev)
+static void uniphier_spi_remove(struct platform_device *pdev)
 {
 	struct spi_master *master = platform_get_drvdata(pdev);
 	struct uniphier_spi_priv *priv = spi_master_get_devdata(master);
@@ -786,8 +786,6 @@ static int uniphier_spi_remove(struct pl
 		dma_release_channel(master->dma_rx);
 
 	clk_disable_unprepare(priv->clk);
-
-	return 0;
 }
 
 static const struct of_device_id uniphier_spi_match[] = {
@@ -798,7 +796,7 @@ MODULE_DEVICE_TABLE(of, uniphier_spi_mat
 
 static struct platform_driver uniphier_spi_driver = {
 	.probe = uniphier_spi_probe,
-	.remove = uniphier_spi_remove,
+	.remove_new = uniphier_spi_remove,
 	.driver = {
 		.name = "uniphier-spi",
 		.of_match_table = uniphier_spi_match,


