Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040533;
	b=hoDkxJNgGoMVj3xCEWIQxRA9327oV8+AshWwYDjfiqqv46wlCXSWU/P+NaxAub3YSLhn
	 4h8h2YUJnaarJTNZNU9QzMXz3pHaO1fVyJxDN2HGBlHCPvkLY9KqwA9REUAJF9TaHLPaV
	 rqaPemRVlhd40fQAc9DsAOmXqV7JpEr0q1HcTdBWvQn/0L5T1/A1diCyJ54Mp6WEJexBo
	 CX2UyaVLu4TtrZjgPvH4g5Aw862e4JaTO2keTPiSywaOvbbUKnJKOh7I1DIlpgekevr1h
	 Sw5AbHoDrwbC1pzQORemdBF562NqAww/ZUJLJsXhr/izXzd8zcOBEVakCjRFeuFdnqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040533;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=65G8595Y42VImopO4ZHtHImenS/Kz0c+859A2suJuGQ=;
	b=Zw9DnTWfVWPGJENUtJ5rQaiSK2NwALvm0O0WeYpz7KpqfzvSNitg4XtNYsMQeQ1E9xoK
	 jn8ZdMTjZEhnGwqW9ENkcO1d/o4DsF92mDdzDbxEa8VIyhAR7e0SdR2/2R5eMvN+Ov8I6
	 KTYvoDfl5w7qIBJ174+ho9qnIwnvJSJGowgqLw413Vv7579PAujS/Cey3A+cJybT/uya6
	 hBUStmyWPlzga+smwwqAsQck7CAojVmYk+I2mjuSgdpvKgXgVXwB7Sdp1zELWLLzr5fcj
	 kiil8AtYHE9NC0Xig9RQZ9pSWR7a/X+pCw/DdecbfwOxKVZ1ZROM4T/+0NQcT347d6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W2W11ZPS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8403606A32A;
	Wed, 18 Nov 2026 22:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W2W11ZPS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49BAF1F000C5;
	Wed, 18 Nov 2026 22:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040532;
	bh=65G8595Y42VImopO4ZHtHImenS/Kz0c+859A2suJuGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W2W11ZPSFMnh9mJnpNYapP1YHU5LtIYTtd0GJBMNqtYMBPIsRZHKl6pqn8R6Gm0dr
	 pNGWksR3a4+cH1YClEKhKoEDPvrM+ZhxKYk76XYlmGroMCfdwFQSAYod1eiPPVuxJF
	 uZPDlnTEV2cd3uEcAkkg9K3foKj35mQykKDfzYEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2489/3318] rtc: ftrtc010: drop needless struct ftrtc010_rtc::rtc_dev member
Date: Wed, 18 Nov 2026 15:51:51 +0100
Message-ID: <20261118150436.063784202@linuxfoundation.org>
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
index 8bfe7378f6533..84483e311b782 100644
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



