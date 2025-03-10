Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D0D17CA12;
	Mon, 10 Mar 2025 17:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629060; cv=none; b=LYxc1STwaVKa5jL87JHvw3gItZkYzv7tYohl9i+L9xgGBwmmYwi2H39YHbkuhREm9NCAYyKhuMCFd+jvwjRdhRqiwA8Be9T+/xVB4Qm1k82r0mIV9LTSc2q1eM6dmBk7U6IYVu77qqGNZU2tk2IQ/G+FW/Lte/KUxVIOnj2hS4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629060; c=relaxed/simple;
	bh=2y+JPXJCllDvFlYljIRcpKTV9u47XY1S/wHlp2IAeZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EJiVCXAXVS4gjSpR5E3Th4uJOBR3dKXM0nMlqzEydqPjZc4ya1GQu93hlsRxjM5SDHE6tebjFk2n42vaXIf0nn+ZoAZTSJ1ed5RVCJoq0v5omksmhpcmsLa7vp0cJ934+BqBQywbjn6tbwwTG246OTDmoYu9GcDfLJcxFvkmoLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=padyUTNl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="padyUTNl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42831C4CEE5;
	Mon, 10 Mar 2025 17:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629060;
	bh=2y+JPXJCllDvFlYljIRcpKTV9u47XY1S/wHlp2IAeZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=padyUTNloclcQdeEmuPbf+Ng94isAHWivxGXDxP+tA4oDZeJO1HbCZLTo5l8WrHO9
	 f1lSu0UXif5iRC5yv4tfJXZRPkA/v7ei/VcYMv8Ae+M5g0QmlQ7AuZYpftPRY8GMm5
	 7OfVUpJhr4v2C5TcWXDqJ0/zleX+BdIT0EkDelGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 146/620] mtd: hyperbus: hbmc-am654: Convert to platform remove callback returning void
Date: Mon, 10 Mar 2025 17:59:52 +0100
Message-ID: <20250310170551.367946923@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 59bd56760df17506bc2f828f19b40a2243edd0d0 ]

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is ignored (apart
from emitting a warning) and this typically results in resource leaks.

To improve here there is a quest to make the remove callback return
void. In the first step of this quest all drivers are converted to
.remove_new(), which already returns void. Eventually after all drivers
are converted, .remove_new() will be renamed to .remove().

Trivially convert this driver from always returning zero in the remove
callback to the void returning variant.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Acked-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Link: https://lore.kernel.org/linux-mtd/20231008200143.196369-10-u.kleine-koenig@pengutronix.de
Stable-dep-of: bf5821909eb9 ("mtd: hyperbus: hbmc-am654: fix an OF node reference leak")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/hyperbus/hbmc-am654.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/hyperbus/hbmc-am654.c b/drivers/mtd/hyperbus/hbmc-am654.c
index a6161ce340d4e..dbe3eb361cca2 100644
--- a/drivers/mtd/hyperbus/hbmc-am654.c
+++ b/drivers/mtd/hyperbus/hbmc-am654.c
@@ -229,7 +229,7 @@ static int am654_hbmc_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int am654_hbmc_remove(struct platform_device *pdev)
+static void am654_hbmc_remove(struct platform_device *pdev)
 {
 	struct am654_hbmc_priv *priv = platform_get_drvdata(pdev);
 	struct am654_hbmc_device_priv *dev_priv = priv->hbdev.priv;
@@ -241,8 +241,6 @@ static int am654_hbmc_remove(struct platform_device *pdev)
 
 	if (dev_priv->rx_chan)
 		dma_release_channel(dev_priv->rx_chan);
-
-	return 0;
 }
 
 static const struct of_device_id am654_hbmc_dt_ids[] = {
@@ -256,7 +254,7 @@ MODULE_DEVICE_TABLE(of, am654_hbmc_dt_ids);
 
 static struct platform_driver am654_hbmc_platform_driver = {
 	.probe = am654_hbmc_probe,
-	.remove = am654_hbmc_remove,
+	.remove_new = am654_hbmc_remove,
 	.driver = {
 		.name = "hbmc-am654",
 		.of_match_table = am654_hbmc_dt_ids,
-- 
2.39.5



