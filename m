Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4159F156C76;
	Wed,  5 Feb 2025 14:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765714; cv=none; b=qhySeFsbfBbpbNTbie6PwO9W2jRYhKTEKOT+YsPKEonVEVBFW+vC4SE2BnfZFnSeEXABzCwXg8kUPAHIp7YR94ZQB1wEqjwrY+A25k6eKUIrnlfDk3PR6BlpIEkXz/RALqlWgWTEBcUAPF5QVqGky5/nBS38apqTFKJ6binhJcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765714; c=relaxed/simple;
	bh=P4bqZLSvZrfmvwjRexe1l61wq1vLZFB8KqxxDEcieLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BCyci2BCzpw4Ty2emEa20R6XAIcBaZ9xXGiqRrLUymvl3seEecnd2goq1k7qpZvkIADq2cWylHl62f8UhdjtR98WNSDDkmc2E5P9MMXKd4zpWg0oxwMfZL9wMlR0XMc+QdGOgV9I5kTfXrdipDB6zFLt8qUI6c0pXhuvTMyB720=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pJ8T0rrx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pJ8T0rrx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 350CCC4CED1;
	Wed,  5 Feb 2025 14:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765713;
	bh=P4bqZLSvZrfmvwjRexe1l61wq1vLZFB8KqxxDEcieLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pJ8T0rrxLPp5diRKgifd30CToD2copLXYS7NtJVNXN+dLyFT9jt4c8Eeqn5GDP8vO
	 Tq0h5+g4aHB0J0r/pkuhjpFCwNZh15XMdYAVviCj/DpY2dqezIv7IG6pFmRkpCm6r/
	 UtK3yz5MHDDtmH6HtvjsX6bhwOIEGIzv4ZH+QzxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 292/393] mtd: hyperbus: hbmc-am654: Convert to platform remove callback returning void
Date: Wed,  5 Feb 2025 14:43:31 +0100
Message-ID: <20250205134431.485341156@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



