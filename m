Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29191DDB1;
	Thu, 13 Jun 2024 11:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278657; cv=none; b=bJ8/w2wHJmWdpl7yUKj+pdqiffNEW0SZLRhsMgGH23HqXlELziWKe+ofCgRULTlwxbCZIIKMcvChdybNNGTna4CtJuBc9uRChaC0qYzO0213gZMLxJmgcFZ9ztnB9W1MLdS3YYNGH/0oKSAbBr5hoXeaDdKuuEDHZvo6r6tfbI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278657; c=relaxed/simple;
	bh=GO0nNY1AX4qun/0+ZCP0/L22D+uD44wje98yFF4uE0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m/g+bJmC9Nvmee/JJKZ5yTithymM+LRGmZFqwzUFhInTsFWiGwaSElASaiPrqcH89QDyyh4rX/VRmyMjhNdtvgKBlR8tR6xzYyc9K754fh6nLOoBgPhla6z8ugOgXfakvz1cXOCnxfrgB3X18xQtuwDff/dVcq7FpPTqhnLXeLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DyEV1SHH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DyEV1SHH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B371C2BBFC;
	Thu, 13 Jun 2024 11:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278657;
	bh=GO0nNY1AX4qun/0+ZCP0/L22D+uD44wje98yFF4uE0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DyEV1SHHwQUUTA9DyBYxI9cE+yDlh3hZi5kl46kt1EXDUgfLkois2G7IQmYkG6nWm
	 h0WPNoubOXTP4jUGtX1G0ulh4C+EVxZnhJxIeYUyXVBLE7ntytvNBBwhP/wgZuy9mt
	 r/gBW5uSkVbNQJGR6UHvHkR0LeW2PPMViurCblg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 026/213] HSI: omap_ssi_core: Convert to platform remove callback returning void
Date: Thu, 13 Jun 2024 13:31:14 +0200
Message-ID: <20240613113229.004890558@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
User-Agent: quilt/0.67
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 94eabddc24b3ec2d9e0ff77e17722a2afb092155 ]

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
Link: https://lore.kernel.org/r/bc6b1caafa977346b33c1040d0f8e616bc0457bf.1712756364.git.u.kleine-koenig@pengutronix.de
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hsi/controllers/omap_ssi_core.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/hsi/controllers/omap_ssi_core.c b/drivers/hsi/controllers/omap_ssi_core.c
index 6595f34e51aad..366117e51f418 100644
--- a/drivers/hsi/controllers/omap_ssi_core.c
+++ b/drivers/hsi/controllers/omap_ssi_core.c
@@ -581,7 +581,7 @@ static int ssi_probe(struct platform_device *pd)
 	return err;
 }
 
-static int ssi_remove(struct platform_device *pd)
+static void ssi_remove(struct platform_device *pd)
 {
 	struct hsi_controller *ssi = platform_get_drvdata(pd);
 
@@ -595,8 +595,6 @@ static int ssi_remove(struct platform_device *pd)
 	platform_set_drvdata(pd, NULL);
 
 	pm_runtime_disable(&pd->dev);
-
-	return 0;
 }
 
 #ifdef CONFIG_PM
@@ -652,7 +650,7 @@ MODULE_DEVICE_TABLE(of, omap_ssi_of_match);
 
 static struct platform_driver ssi_pdriver = {
 	.probe = ssi_probe,
-	.remove	= ssi_remove,
+	.remove_new = ssi_remove,
 	.driver	= {
 		.name	= "omap_ssi",
 		.pm     = DEV_PM_OPS,
-- 
2.43.0



