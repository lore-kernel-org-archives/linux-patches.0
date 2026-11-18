Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046708;
	b=QQnuzlno849DR+iORHUWoFCh3wcpaasLEXumSdSii5APgrDYvWrRc77n6zGo/Sxt9vWB
	 IWX7UqtqCDAej8CEISrV8PdyrdLcV9LWa/lDE6uhHynQQdLuIdq3C1pl4FUH1kGbSJeWK
	 2dfIycbe73nkbgjAUKyyuVw+Sc+WNL9AJ7IXsygLd2icg/SKL5m9i5CBhfkjhc+E1s+mp
	 xa5qGJBz+gVii7iOqM5GQhLyO3GumTGoUu3Zi/q/z0VBuW8BY4Y/D5PrARok5QXaIOgkS
	 DVu7adxX/Inpy6u7T81zKdoQl3zA2MjG0g7tuAr6XJ3BrJRsLfWdKDcIRaQYZD9gAVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046708;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Ga5i5C2tcmt6UrA8K056/EFMHHWndKAv7S9Jjq68sUM=;
	b=ISTFa9KzLusvvGNc2cZ2oRza5G7A76FhhuEkqUWIqvMOHMQAVwnkOBPSRg4h5P2DapId
	 I83pdfQDt7MmAovE44O1gLMpk9VH4Nv31LX7JUh3Ywckxz+hWPUr7WdId/TXRwWKEXtbK
	 dVFlWFTViHP85X2i1X66afs6FedBWBTGw/e14e2mxic8+0evLuNJjOFvl1gt6nWBG8byx
	 wd++rDENtEjRaxzKq+z4mAg8+XwEab8r4L7W9PAKWtq7fccafFjMpRNwqRJMwNwVBAZE1
	 DZYFvdyTj4kbmNjagxhwoAmtRHxCrfegdW+4v+9RAHQDJSpeU0vPafcsfPPyPfutj4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eC0Wkp1h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF413606A31C;
	Thu, 19 Nov 2026 00:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eC0Wkp1h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B9721F000C4;
	Thu, 19 Nov 2026 00:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046708;
	bh=Ga5i5C2tcmt6UrA8K056/EFMHHWndKAv7S9Jjq68sUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eC0Wkp1h2Y+vL1KC1WX9QGGyUnM0/xmlnkXAGHkh707xT7SXH+ZxdROx242U/Cdcv
	 g4HxGUFs0NnQzvr3Bq/R3b7FBE/8Hq3wKMWT4QFvkZU/b9NZIqkFVVwUqUSOeHTAzW
	 8bYJZPWgh6pvBZcWAu9eoUXCmpPrKfCeKrXbrYJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1375/2857] media: hantro_drv: Convert to platform remove callback returning void
Date: Wed, 18 Nov 2026 15:40:09 +0100
Message-ID: <20261118150250.888605742@linuxfoundation.org>
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

[ Upstream commit b9294ba9285e555e0e6daafac95704be4a9125c2 ]

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
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Stable-dep-of: 8e26d4c20ed2 ("media: hantro: disable runtime PM before hardware teardown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/verisilicon/hantro_drv.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/verisilicon/hantro_drv.c b/drivers/media/platform/verisilicon/hantro_drv.c
index 29baefc93628c..df81ca3903ca5 100644
--- a/drivers/media/platform/verisilicon/hantro_drv.c
+++ b/drivers/media/platform/verisilicon/hantro_drv.c
@@ -1183,7 +1183,7 @@ static int hantro_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int hantro_remove(struct platform_device *pdev)
+static void hantro_remove(struct platform_device *pdev)
 {
 	struct hantro_dev *vpu = platform_get_drvdata(pdev);
 
@@ -1199,7 +1199,6 @@ static int hantro_remove(struct platform_device *pdev)
 	reset_control_assert(vpu->resets);
 	pm_runtime_dont_use_autosuspend(vpu->dev);
 	pm_runtime_disable(vpu->dev);
-	return 0;
 }
 
 #ifdef CONFIG_PM
@@ -1222,7 +1221,7 @@ static const struct dev_pm_ops hantro_pm_ops = {
 
 static struct platform_driver hantro_driver = {
 	.probe = hantro_probe,
-	.remove = hantro_remove,
+	.remove_new = hantro_remove,
 	.driver = {
 		   .name = DRIVER_NAME,
 		   .of_match_table = of_match_ptr(of_hantro_match),
-- 
2.53.0



