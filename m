Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 381281D63F3;
	Mon, 23 Mar 2026 14:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277694; cv=none; b=fsqc0Tjzi3H6rF8XbdyiBQu7xVaXlHaXOrcrxxxyEX4c4R0yA+Yo3bP9Xu4czjhn/79WPDiRL2WLUwsBpmQ0zWTGmreT0Tb0YvXr4zzCDkzsewy3rl/+w/eCW3iJh5gPrjqvvpFY2KxhThos+CZ+Q80xhJWv6RO10dPxfTvI10s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277694; c=relaxed/simple;
	bh=ktQLvzUqITeX+rZBoTTobys0URIbGoylUSpgZ2ksOWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WnTbNpEADQtH/0LFkwC5StB/pMD81+4qjsfZFLnayS4x5m9VdSDkulIHBw9qvkXCuTlZVZ/BKqsTEf/WNhQWoXPxHALC1UO3EqVe8IGid5oDue0VI7fArKPTnn+efnMlFOGxs4NPpkpTLvu7EtNY5VdPJw1L+taKan4IsaRw8P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E6tlbR3E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E6tlbR3E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B038FC2BCB1;
	Mon, 23 Mar 2026 14:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277694;
	bh=ktQLvzUqITeX+rZBoTTobys0URIbGoylUSpgZ2ksOWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E6tlbR3E4VDCFO5Dsuwm5R7XZ/UX2TFRYtOX4ihhAhlfx2Gr7nl7Ou3fYIGvYGPb6
	 HXGXj0naCaS185hWtFk7Tfxvp9ROCd5NNJBQob8TO2ZHhJh6imWIThvmPryz1Sy4h1
	 pd6p4e1eo4vFJnx5fgPxz+t25/Osu3ss3Zk6ItTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 073/567] mfd: omap-usb-host: Convert to platform remove callback returning void
Date: Mon, 23 Mar 2026 14:39:53 +0100
Message-ID: <20260323134535.633054991@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

[ Upstream commit 418d1e74f8597e0b2d5d0d6e1be8f1f47e68f0a4 ]

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
Link: https://lore.kernel.org/r/20231123165627.492259-11-u.kleine-koenig@pengutronix.de
Signed-off-by: Lee Jones <lee@kernel.org>
Stable-dep-of: 24804ba508a3 ("mfd: omap-usb-host: Fix OF populate on driver rebind")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/omap-usb-host.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index 78f1bb55dbc0f..ebc62033db169 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -816,13 +816,12 @@ static int usbhs_omap_remove_child(struct device *dev, void *data)
  *
  * Reverses the effect of usbhs_omap_probe().
  */
-static int usbhs_omap_remove(struct platform_device *pdev)
+static void usbhs_omap_remove(struct platform_device *pdev)
 {
 	pm_runtime_disable(&pdev->dev);
 
 	/* remove children */
 	device_for_each_child(&pdev->dev, NULL, usbhs_omap_remove_child);
-	return 0;
 }
 
 static const struct dev_pm_ops usbhsomap_dev_pm_ops = {
@@ -845,7 +844,7 @@ static struct platform_driver usbhs_omap_driver = {
 		.of_match_table = usbhs_omap_dt_ids,
 	},
 	.probe		= usbhs_omap_probe,
-	.remove		= usbhs_omap_remove,
+	.remove_new	= usbhs_omap_remove,
 };
 
 MODULE_AUTHOR("Keshava Munegowda <keshava_mgowda@ti.com>");
-- 
2.51.0



