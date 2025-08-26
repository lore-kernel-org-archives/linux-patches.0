Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A2C1FBCB5;
	Tue, 26 Aug 2025 13:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215050; cv=none; b=rfCV95Kw7ns49LeFbZuQcWznGmfgmw9nIvpXPlsDSWdbaqfdgemoyxU7PZfC1QnJ/hDWYCeDSBSAVLC6Y89ozYH2HyCOWsMwb8EH2vIfKl7Oxq/jAbdjEXp5jU0wU0bAsWrPhwO0H9u4O62DLOja6enMsyV+GKLiu6cRACO54vA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215050; c=relaxed/simple;
	bh=8DmDjkmxwXi7Mc+ucl/71i7B/AFBC74HsRmWIBRu5e4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cU5LtHCYloK8YO30dT0NcPUlSYyclq6qNjTh+UJxu4Ho5jGXFihKeqaa/rhiXsbOdJuVaGY/jjhVc2KZGumAAzcD5eUz3ESEqSMlIgEzysbb40p3y5QByFXEie3pv/as4K02Nff6PRW9D2ymXjK8d7nukjt8cUC8C0fmknGf+/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0fJCsiJM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0fJCsiJM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A140C4CEF1;
	Tue, 26 Aug 2025 13:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215050;
	bh=8DmDjkmxwXi7Mc+ucl/71i7B/AFBC74HsRmWIBRu5e4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0fJCsiJMiKDvBcFkk0qxlLugfXMT9LtqXmMcaQrFHbV9yFUDTjwSBEjJzlNug/CF6
	 on5h0vi1LANq2k2G9P8DTKyE5OUv0FMSfecgoWo2gQAyMR/Rh/YmrJH4Z/dT86gD/c
	 GvGOMD5XzJUqzvUP4o+3j1bYA0PpPu+VfFjMGgKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 369/482] usb: musb: omap2430: Convert to platform remove callback returning void
Date: Tue, 26 Aug 2025 13:10:22 +0200
Message-ID: <20250826110939.950567802@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -471,14 +471,12 @@ err0:
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
@@ -610,7 +608,7 @@ MODULE_DEVICE_TABLE(of, omap2430_id_tabl
 
 static struct platform_driver omap2430_driver = {
 	.probe		= omap2430_probe,
-	.remove		= omap2430_remove,
+	.remove_new	= omap2430_remove,
 	.driver		= {
 		.name	= "musb-omap2430",
 		.pm	= DEV_PM_OPS,


