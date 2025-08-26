Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85DFB350D40;
	Tue, 26 Aug 2025 13:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216760; cv=none; b=Lc6wbHipDu6RBFBK6SwhNatZh1wxycYYTlqNaYqlt+uROnmmJkFnbw0EEh4nGcvaZswoCKdXN+7n263XqqgkvzGeo55vafa8kWmgQtw+gr4HydNf/bYwLbfyzXQPxCSwfP95vx58a10St6odKNmcI6T7OaXDv87LgRp2h7QKWCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216760; c=relaxed/simple;
	bh=lQFahW76rZ2vEPZildkvEVqkEEYNV1A5jBFpnwtj9JA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J0oGYvvzwPwIrtUUwa9AXVaazNE6j3ByeDU3lFgtb42U+8ajKufElR9VNiUp8XpaFJIaceg5AAraRK5yvzaK4Rf89vVxFKVQ9b1SR8KBIyvALIz4hw2jLt05bj4Q1aimnSSg5nFCFC4rQmI3M3wmD5MPXP6AZhU/Zf+GsYcHWXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dyy85reW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dyy85reW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B960C113CF;
	Tue, 26 Aug 2025 13:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216760;
	bh=lQFahW76rZ2vEPZildkvEVqkEEYNV1A5jBFpnwtj9JA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dyy85reW4I//lqAvTyLGKp+CqkWan6cGQDiYwspLHrUmfkTmgXws87jS3YCnFMMZR
	 k/VluK+uyE0GThAytU/YtizDNfPkRfS/UoG0TW1Kr9hQEOf/Snm67cP2b7jZN+kgdP
	 QJlO7FG84fe8WE6wEEGs8S3jvogfVLYyLy82XfkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 532/644] usb: musb: omap2430: Convert to platform remove callback returning void
Date: Tue, 26 Aug 2025 13:10:23 +0200
Message-ID: <20250826110959.696386040@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

[ Upstream commit cb020bf52253327fe382e10bcae02a4f1da33c04 ]

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
Link: https://lore.kernel.org/r/20230405141009.3400693-8-u.kleine-koenig@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 1473e9e7679b ("usb: musb: omap2430: fix device leak at unbind")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/musb/omap2430.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -435,14 +435,12 @@ err0:
 	return ret;
 }
 
-static int omap2430_remove(struct platform_device *pdev)
+static void omap2430_remove(struct platform_device *pdev)
 {
 	struct omap2430_glue *glue = platform_get_drvdata(pdev);
 
 	platform_device_unregister(glue->musb);
 	pm_runtime_disable(glue->dev);
-
-	return 0;
 }
 
 #ifdef CONFIG_PM
@@ -574,7 +572,7 @@ MODULE_DEVICE_TABLE(of, omap2430_id_tabl
 
 static struct platform_driver omap2430_driver = {
 	.probe		= omap2430_probe,
-	.remove		= omap2430_remove,
+	.remove_new	= omap2430_remove,
 	.driver		= {
 		.name	= "musb-omap2430",
 		.pm	= DEV_PM_OPS,


