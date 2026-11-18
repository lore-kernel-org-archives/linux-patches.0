Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048904;
	b=iLZ2+sSidN1PBdWnvJ4DsOK6oLbaFXywjgVUDYVAjdyXdTAtAUUMD+P/d/e6TfCP3f7X
	 7b0jd6kJsbTkK4hdnVUI8KmVphdqwjrgTznUSiuB+CxF5evUaXl3ZRPAn77tHReqCgcxk
	 EnukYho+8U88GMygrcBh2rErzqfRMksyVn+R1lQIbQqkJj5MBYwh6zoKx9dis6deCUKvO
	 KTbZ90facQX/Cw2luK0slLhYSeYZA+/LNaG3cV/XA70LdNyVLWZ1pRENuXVQK1Lwh7M3e
	 769Vmtp9ILsWJsZ+7EnfY30wXG8tRvRws6Tyesccvc06AejPVxvkXpqcmjednQtq+Zw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048904;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=oxM1IjOg/9faWjBrO/VoTgKcvs6w0PwF7SdJHe7beBY=;
	b=vvzaTeeKGi7mDukF34QV92kAtBmNWhReBbbygX/rAOG3PPUP2PB/KMbyYFz85cg6AwQL
	 UPehvzsFVmdY9woRcU+7/fgeDwnmAcGWsvY7MA98zMNmID1JkDLnzoPJFG1MehcMnwCBd
	 KmKavgzZCE99/wiG84KRtXn1iHO4HLsCYvOiszrhmDQaTGyy/o7YJgydPd3zpedILB4ca
	 T1nLDzFqlBGZblBL9pUGVKw/pwr2OEVfF1p+OaOKxxkkPlUxu0BZrhfDAWR8W3vKNsGxS
	 oE9rW3Ti9+8/DgVKTBaOJJvShuVQ9XNbozucZrq1UploHPOnRpuTd0JM276igIyyS+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L1iwf80c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE6C606A31C;
	Thu, 19 Nov 2026 00:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L1iwf80c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AD761F000C4;
	Thu, 19 Nov 2026 00:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048904;
	bh=oxM1IjOg/9faWjBrO/VoTgKcvs6w0PwF7SdJHe7beBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L1iwf80cmTDBpKIkw+5cghuFrN6L546WZf+sZaeBPvdbnCNf+L6AsKoXPhk7IN/Fd
	 iZ61UThvEBwDpwJdn8qEV/M445zicgwFE58816kjv+qyd0t4h4y1hQBdRhtceNlN+g
	 ruAAUgw2YPUexi2ofpK5SXcyUybLhXVANIQ4GDp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2159/2857] rtc: ftrtc010: drop needless struct ftrtc010_rtc::rtc_dev member
Date: Wed, 18 Nov 2026 15:53:13 +0100
Message-ID: <20261118150319.132088226@linuxfoundation.org>
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
index 25c6e7d9570f0..14858d2faa2a7 100644
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



