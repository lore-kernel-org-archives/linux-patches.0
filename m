Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038392;
	b=udbpzevCPcxoCAxd4eEAeyHNRj7BLtaCxhex9NOPlQrAsBLzMI8dyZ/5rcHfMGicQBw8
	 NobFbBsTKSzOUlgnnyn+uSPlESdTHv89Qz/zpUHSuVGXMKMgIogQQt3qFnpG41HXsXvwv
	 uroJXjvsYQNwMW3/wLZO/n00BSmSrvDmXUqW3PdS8gdsXB4Pvkzi/vMnKSqm1OLTME10d
	 DPrpM+u2bjcima3JVo/9VhSYb0jUDCTwREj53K2H8CW7WGnnSReaOGhZWvM/bfENcSutr
	 BoMHBZlssNuiBW+jBA07muzIUNIVTyj46MlrPPlY54CCbR7DcMi6+pG2daOHokFaaCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038392;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=gZrW7OOGa0jv3pSHkkLCvB/cDG63MH0V1kWawicDqi8=;
	b=SCQDfOSNm8YWIWj43uZGDTTn5OWvpkj6BR0M9Mf4tKwKpmJ3BQyT2pqCHImidslgVgoV
	 4L9NxBaeJqqkJkBGTbYbsQb3qpqDPH9U6GT3Jjw20yMaxq2XhaP4/nkLjLg7+IeYwq4ep
	 uwD/NLGwhWbMTjsGT2zH6KOrb1Lnp1FXbWWcxHOhagaPESnDiWxpLWj+k+bOn3jAFzqU5
	 acJ18Tkyn6pa/gxlyGGo+NTrBip+aXrDzIzyLoBzRQBS3sPU74vKGN4T8YInQAfRFWFnY
	 0ypJLCycrAOGGWq2uBJ1JTQ+rYsbHKgZl4bY6B3sX+xL2fR1xHSLggH/jH9JJUb97Hw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Mp2iibca;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6C1A606A31C;
	Wed, 18 Nov 2026 21:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Mp2iibca
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19B311F000C4;
	Wed, 18 Nov 2026 21:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038392;
	bh=gZrW7OOGa0jv3pSHkkLCvB/cDG63MH0V1kWawicDqi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mp2iibcaIgFQgutnvHHoq1unEpiJHnZLyXubjwgaEQ5bPJhlaMqoamEzbPoZyLq95
	 GqmmeMtF8KEj4x2TVWDjLUM/r0FH7vf5vrcnnqzmD1j8dyKsyGCgTIC/q7bQCDepjT
	 /tzDheTb/gO4qH9l8yzNHukP2Ta7ze+TWV8o72ik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1727/3318] irqchip/imx-intmux: Convert to platform_driver::remove_new() callback
Date: Wed, 18 Nov 2026 15:39:09 +0100
Message-ID: <20261118150413.676567025@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6d9a08238c9d0..cdd6c47e589d3 100644
--- a/drivers/irqchip/irq-imx-intmux.c
+++ b/drivers/irqchip/irq-imx-intmux.c
@@ -282,7 +282,7 @@ static int imx_intmux_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int imx_intmux_remove(struct platform_device *pdev)
+static void imx_intmux_remove(struct platform_device *pdev)
 {
 	struct intmux_data *data = platform_get_drvdata(pdev);
 	int i;
@@ -298,8 +298,6 @@ static int imx_intmux_remove(struct platform_device *pdev)
 	}
 
 	pm_runtime_disable(&pdev->dev);
-
-	return 0;
 }
 
 #ifdef CONFIG_PM
@@ -354,11 +352,11 @@ static const struct of_device_id imx_intmux_id[] = {
 
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



