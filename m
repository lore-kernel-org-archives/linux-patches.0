Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19CC526CE32;
	Mon, 13 Apr 2026 16:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097224; cv=none; b=EoFzyjPW6thzFGRLJlvSVsZWYaG264smH1LXJd2mCp53ngiqkNclp9NCtb+0Rra3UE5W1Dd0UabjlhIoryjNZAbKbmXs6YXkxdD6Ijh3vL5Xh8f97zdNu1UUlcbA80dKLohzX9FjU4NruzVaMOrUbLWv5RD0oIyJddQaB36TB/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097224; c=relaxed/simple;
	bh=GhbOVR7uJckPUV/6xUxe1KNwyyqSK/E9sMiHn/rq4e0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EgaNygy25CjW0MnkmAXhY3zTD1jp/RPKCfmlXgrQuFGuAt0XwPFnoO1L8eC10c3EkTNAvOQK/tl2Cu2rZe0WIUMEzg1+k2d0J6IndUMwoYi95X/Y7rS3WW22zXmp3OzVV7y95mcy8d5lnYavG8ZAUnAtH7O6hhG/Yd9lWKAJSFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LJx3KKyI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LJx3KKyI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A21B3C2BCAF;
	Mon, 13 Apr 2026 16:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097224;
	bh=GhbOVR7uJckPUV/6xUxe1KNwyyqSK/E9sMiHn/rq4e0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LJx3KKyIiCBTlcSaiQZJ630Evgz9tsW6v1MnEsEp50sHAknOGNvfQEb0gjMBf2+cZ
	 U6C9BcXgnS9XOOWeV9OgPyMYesdHjjQAZwPeC7q/+xvYcsPjHgaXrZqJdKbHKHHC/n
	 JKuLjm4pn1eEfhcCtFuxMYv8gZZLPXqLg7LidNvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 021/570] bus: omap-ocp2scp: Convert to platform remove callback returning void
Date: Mon, 13 Apr 2026 17:52:32 +0200
Message-ID: <20260413155831.213192607@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 854f89a5b56354ba4135e0e1f0e57ab2caee59ee ]

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

Link: https://lore.kernel.org/r/20231109202830.4124591-3-u.kleine-koenig@pengutronix.de
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Stable-dep-of: 5eb63e9bb65d ("bus: omap-ocp2scp: fix OF populate on driver rebind")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/omap-ocp2scp.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/bus/omap-ocp2scp.c b/drivers/bus/omap-ocp2scp.c
index e02d0656242b8..7d7479ba0a759 100644
--- a/drivers/bus/omap-ocp2scp.c
+++ b/drivers/bus/omap-ocp2scp.c
@@ -84,12 +84,10 @@ static int omap_ocp2scp_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int omap_ocp2scp_remove(struct platform_device *pdev)
+static void omap_ocp2scp_remove(struct platform_device *pdev)
 {
 	pm_runtime_disable(&pdev->dev);
 	device_for_each_child(&pdev->dev, NULL, ocp2scp_remove_devices);
-
-	return 0;
 }
 
 #ifdef CONFIG_OF
@@ -103,7 +101,7 @@ MODULE_DEVICE_TABLE(of, omap_ocp2scp_id_table);
 
 static struct platform_driver omap_ocp2scp_driver = {
 	.probe		= omap_ocp2scp_probe,
-	.remove		= omap_ocp2scp_remove,
+	.remove_new	= omap_ocp2scp_remove,
 	.driver		= {
 		.name	= "omap-ocp2scp",
 		.of_match_table = of_match_ptr(omap_ocp2scp_id_table),
-- 
2.51.0



