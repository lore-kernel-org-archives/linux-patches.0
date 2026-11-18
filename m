Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047084;
	b=cXBABSDlQD5dBJbRgigmJ3Nq6tqyrgx58XnS9r5Oit/uvs6jwc/L1bfR4wDrsShjOKHL
	 FXV2Nk9/hoQYhcpvTFYYVdaMi+2a2aApp2CLvaX5I5u8IuRjMr6dGyIWnmlM0z5nmYHvE
	 M0+Tbe6/HqfXlE8tNDIhCFMHhLqq4JWVzt1eMCb5R1+I2iZ+WkFTA6Q+Lc6PlLWsq1M68
	 7XVeICJj6S5gNDtOpyAcCostIHTxY10G4T7beWYWmSj7APX+50RPpuHoDSoHO3XkTzBZ5
	 Lq/KNOvPmbqCmKRTtU0eOp87L2dGooAdHRbehOaL3dHy9ryHpvgt6Bj62ajWiTkANPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047084;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=tUf22j6uKss9wdpDSOBJ7+1eB3aPL1ivF17WbdMr6nw=;
	b=OV8D+/gXkL2BRfzQMD+JnZyveuLEFXSwZlunoT+reIue338DJJeONX2aKycopQjDtWbU
	 fuxx67req0zHe4PsEBPsY6MjfwNWVMTPZgkuohpuxw6TqQI2/pPJDbynz4sGAwLdf7Xrg
	 eMm/0M3OL1eEpOKclGDdqZiib5Ie5WnJ+HE0+LlqysvDsbyciola4x+YpbvK39B8gTPXY
	 2cVOm3VOO8nr90IYjQV/NlhTC4AUHgkS8KJ1NUjEcYgLA45bv4RF+jloYmMoOMIfk2fCl
	 9ci4vgEwfhonCQ4bArGd+05TLjNMx2FEehAYaCxu10FXntJburFNUn3nBnKxDwu9/1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xDwWBDk5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 593EB606A320;
	Thu, 19 Nov 2026 00:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xDwWBDk5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8D971F000C4;
	Thu, 19 Nov 2026 00:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047084;
	bh=tUf22j6uKss9wdpDSOBJ7+1eB3aPL1ivF17WbdMr6nw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xDwWBDk5pNaAn8ifHzatHknSALBrDRzXNMAA+8mtC9Qpxdc50jBXrY6iQZUSgkIHB
	 jXGgLlKqeQTqBqzyEIpDy9ekuNWWOkxT+AbW+m/OLF4ZAjhHZhWCS2x+D9D6WFQ+KN
	 F7P2u68IroHOC5cUY7+JVsKn/moZjNlD6Frdiusc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1472/2857] irqchip/imx-intmux: Convert to platform_driver::remove_new() callback
Date: Wed, 18 Nov 2026 15:41:46 +0100
Message-ID: <20261118150254.312884154@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 984e5c7b8d7bac9efd3818e06dcf1f7aab7701b2 ]

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
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/edeee074956dd943d3c67da894a01dc5f0d33bd7.1703284359.git.u.kleine-koenig@pengutronix.de
Stable-dep-of: b167c1a30e9e ("irqchip/imx-intmux: Fix runtime PM teardown on remove")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-imx-intmux.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/irqchip/irq-imx-intmux.c b/drivers/irqchip/irq-imx-intmux.c
index 80aaea82468aa..c7bf73dcb7a10 100644
--- a/drivers/irqchip/irq-imx-intmux.c
+++ b/drivers/irqchip/irq-imx-intmux.c
@@ -281,7 +281,7 @@ static int imx_intmux_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int imx_intmux_remove(struct platform_device *pdev)
+static void imx_intmux_remove(struct platform_device *pdev)
 {
 	struct intmux_data *data = platform_get_drvdata(pdev);
 	int i;
@@ -297,8 +297,6 @@ static int imx_intmux_remove(struct platform_device *pdev)
 	}
 
 	pm_runtime_disable(&pdev->dev);
-
-	return 0;
 }
 
 #ifdef CONFIG_PM
@@ -353,11 +351,11 @@ static const struct of_device_id imx_intmux_id[] = {
 
 static struct platform_driver imx_intmux_driver = {
 	.driver = {
-		.name = "imx-intmux",
-		.of_match_table = imx_intmux_id,
-		.pm = &imx_intmux_pm_ops,
+		.name		= "imx-intmux",
+		.of_match_table	= imx_intmux_id,
+		.pm		= &imx_intmux_pm_ops,
 	},
-	.probe = imx_intmux_probe,
-	.remove = imx_intmux_remove,
+	.probe		= imx_intmux_probe,
+	.remove_new	= imx_intmux_remove,
 };
 builtin_platform_driver(imx_intmux_driver);
-- 
2.53.0



