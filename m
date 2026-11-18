Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030512;
	b=5bLSftPFao11bKNSE6v3e+U8nWuYAIEyfyF8V2wLKfOP41fFehsH1bJ1Z/vbqmtY+gIG
	 nAr7tr9wcvPswwO3V7AAHX8iV3Fa9BpYgJBQ+1Sc1qIkeI3D17JiueP3GZRPT8VyqlXBm
	 Iqq9457sZniNzsIUjKYkY+1FAvX4wyS/4bH+9YDK6Pkvkxiyr24vGZxmy+/XPbcDhmWyK
	 p/pHfzumumkuv5mQZC0H3vglPCPmOda47RA40jEW+IlljPc59OACqy8nB0e6X2fW9MeAp
	 EWESNaF4uxTQ+JChGmmroM/+x8CQhSlBSDHOCW/AL7y024M2xX6wyHeem2n4Xfm81Lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030512;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=XLrx4ElEexT9bpVJR/F9AFgcIGwKBhwlm3x9Sd9DhaM=;
	b=pE4oIizfMrVGvkpkE4tSx4j+bV0CYaRWbtwgt9mde+pLteK2s1uH9chYWa15VPRpZeYJ
	 eRIAxBiVrD9/xxTTEVcQYQ2sAGPNJrE7YYMsovUPMvmhPnoaE8pQT/V/U6s7N14D5REor
	 8b/s09SrZNmhSyfCzlfqh/U9wBrWtNZ9YNdgpKG4WlzyyDc1vhQq0DzqVv0jBvaYGbSuu
	 jU4MCDAZC2dIaBX9r88s4qIfRZERsobAD79AvNvIsHq4hJIXQo5QwKcv35/7/9zkT/ZYI
	 XM2StRvL9AB6UQgGRTklkp7+0vdGirpKwKl5Zs8CJ0uIDe/0N+lxtWh5Ygat25Kwb3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XhNax249;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E985606BB50;
	Wed, 18 Nov 2026 19:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XhNax249
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C27931F000C6;
	Wed, 18 Nov 2026 19:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030512;
	bh=XLrx4ElEexT9bpVJR/F9AFgcIGwKBhwlm3x9Sd9DhaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XhNax249Kqu62HO9zKZw23JIiHSRdAcpK785P2fta2F5acXFmfOVc9QCzPG7mZokc
	 dYSK7n3kVXUx/J1SI+5XkjKYayFXYjD3fxrk86XLmM4UQYx+5Niix4qPZw1Wv4Hif9
	 qmjTUmoK7UD5zAFWn3ZUMcfsZWoXqUPgwnVA1ClU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0729/1756] rtc: ftrtc010: drop needless struct ftrtc010_rtc::rtc_dev member
Date: Wed, 18 Nov 2026 15:47:36 +0100
Message-ID: <20261118150038.695189613@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: André Draszik <andre.draszik@linaro.org>

[ Upstream commit a55d44807b63f171f8079d770c9d82fa87046cdd ]

The memory pointed to by the ::rtc_dev member is managed via devres,
and no code in this driver uses it past _probe().

We can drop it from the structure and just use a local temporary
variable, reducing runtime memory consumption by a few bytes.

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: André Draszik <andre.draszik@linaro.org>
Link: https://lore.kernel.org/r/20250304-rtc-cleanups-v2-6-d4689a71668c@linaro.org
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Stable-dep-of: c60478875a44 ("rtc: ftrtc010: fix clock resource leak on probe failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-ftrtc010.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/rtc/rtc-ftrtc010.c b/drivers/rtc/rtc-ftrtc010.c
index cb4a5d101f537..02608d3784958 100644
--- a/drivers/rtc/rtc-ftrtc010.c
+++ b/drivers/rtc/rtc-ftrtc010.c
@@ -28,7 +28,6 @@ MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:" DRV_NAME);
 
 struct ftrtc010_rtc {
-	struct rtc_device	*rtc_dev;
 	void __iomem		*rtc_base;
 	int			rtc_irq;
 	struct clk		*pclk;
@@ -113,6 +112,7 @@ static int ftrtc010_rtc_probe(struct platform_device *pdev)
 	struct ftrtc010_rtc *rtc;
 	struct device *dev = &pdev->dev;
 	struct resource *res;
+	struct rtc_device *rtc_dev;
 	int ret;
 
 	rtc = devm_kzalloc(&pdev->dev, sizeof(*rtc), GFP_KERNEL);
@@ -160,29 +160,28 @@ static int ftrtc010_rtc_probe(struct platform_device *pdev)
 		goto err_disable_extclk;
 	}
 
-	rtc->rtc_dev = devm_rtc_allocate_device(dev);
-	if (IS_ERR(rtc->rtc_dev)) {
-		ret = PTR_ERR(rtc->rtc_dev);
+	rtc_dev = devm_rtc_allocate_device(dev);
+	if (IS_ERR(rtc_dev)) {
+		ret = PTR_ERR(rtc_dev);
 		goto err_disable_extclk;
 	}
 
-	rtc->rtc_dev->ops = &ftrtc010_rtc_ops;
+	rtc_dev->ops = &ftrtc010_rtc_ops;
 
 	sec  = readl(rtc->rtc_base + FTRTC010_RTC_SECOND);
 	min  = readl(rtc->rtc_base + FTRTC010_RTC_MINUTE);
 	hour = readl(rtc->rtc_base + FTRTC010_RTC_HOUR);
 	days = readl(rtc->rtc_base + FTRTC010_RTC_DAYS);
 
-	rtc->rtc_dev->range_min = (u64)days * 86400 + hour * 3600 +
-				  min * 60 + sec;
-	rtc->rtc_dev->range_max = U32_MAX + rtc->rtc_dev->range_min;
+	rtc_dev->range_min = (u64)days * 86400 + hour * 3600 + min * 60 + sec;
+	rtc_dev->range_max = U32_MAX + rtc_dev->range_min;
 
 	ret = devm_request_irq(dev, rtc->rtc_irq, ftrtc010_rtc_interrupt,
 			       IRQF_SHARED, pdev->name, dev);
 	if (unlikely(ret))
 		goto err_disable_extclk;
 
-	return devm_rtc_register_device(rtc->rtc_dev);
+	return devm_rtc_register_device(rtc_dev);
 
 err_disable_extclk:
 	clk_disable_unprepare(rtc->extclk);
-- 
2.53.0



