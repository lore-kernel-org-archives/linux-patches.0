Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053985;
	b=C59OJ/EB57ICil7iTXTQHIMTik1k2jtGyHZsJQEk+WgOTNI0MeDxqSHJzMZqyYDlGT6o
	 nKomKIlGXYQqEtKR0wfR/YcIz7M8Qegbr9qnLp7W+7Yx0sYX1I8hEQ2MyOcRLZbd+d3Zf
	 z7f/oOCn0fZ17yHKGJMIa7Ea7zPhhadYqakiOAtSKC54M4qxVJLowIVeu7vndX9GLDFQT
	 h4ZYWPCQDQRjrIOPOaeoACYfKRYl79jp13c1O9op4Xe5RjJ3dEdupd3llBOrj2FXzB+ij
	 4jwcW14d1Lra4gq/ma9/+A5IQaf92jEgOYEYpMt63qIthwa3aV658SVGTGhwLR06rVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053985;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=zCTsl/N6S/WYPYsM+/IOQ5ZSSe/yTl0fDmKod1RYw+w=;
	b=1wTFkxnJVahtX9ukCifge7tXuOqIe/OjwBOu4iQ9xNtkCkIAChLnhIYAIQPy66CNisBB
	 Bv3iG1gx0ChZ5x2nK/V2w+tTiQg6fCjWJtk86ZOATDL3zY19KLfWe6tbts+ls9roKp4lm
	 MfvhPQReCQY/UxbtzjA3Tdn74DXU55lNm5ouIKAQFGFiZnCYQUhZcYVsuqZN8CMBJ8Hh4
	 3xcoDRn/Zvd0OkfY22pb66u4AfFqmOQmN+a6+OWeuDmFbC9utBHkfh2iORyNIHaGwfb1Q
	 JeA45/gmIJPIfQRk2eiOekzR7V3E7sa2bp6+B+2j2N3jZ/ROh+QYJB4MrD8kzvjCjOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AzF9NqrY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58FBA606A31C;
	Thu, 19 Nov 2026 02:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AzF9NqrY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA6621F000C4;
	Thu, 19 Nov 2026 02:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053985;
	bh=zCTsl/N6S/WYPYsM+/IOQ5ZSSe/yTl0fDmKod1RYw+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AzF9NqrYyTs9dDI6EA0RIBquqZWCTyxpkwrmGpTBmVqhavDFy9yxgyGauKdEe9mzQ
	 VO5iRKQxLDsygXk0EtWvwDS07dmdIT8ms9okJZLcOGxQP8+jJRb9aBjomOPZSBQZ3g
	 An9cDgIIJrrS+PBKlDEeH2mPxIMb7S2fQTPw2S4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1073/2214] irqchip/imx-intmux: Convert to platform_driver::remove_new() callback
Date: Wed, 18 Nov 2026 15:45:49 +0100
Message-ID: <20261118150055.193354261@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e86ff743e98c3..45d2ac494a82d 100644
--- a/drivers/irqchip/irq-imx-intmux.c
+++ b/drivers/irqchip/irq-imx-intmux.c
@@ -283,7 +283,7 @@ static int imx_intmux_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int imx_intmux_remove(struct platform_device *pdev)
+static void imx_intmux_remove(struct platform_device *pdev)
 {
 	struct intmux_data *data = platform_get_drvdata(pdev);
 	int i;
@@ -299,8 +299,6 @@ static int imx_intmux_remove(struct platform_device *pdev)
 	}
 
 	pm_runtime_disable(&pdev->dev);
-
-	return 0;
 }
 
 #ifdef CONFIG_PM
@@ -355,11 +353,11 @@ static const struct of_device_id imx_intmux_id[] = {
 
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



