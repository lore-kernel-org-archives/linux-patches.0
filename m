Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210649;
	b=SX09HwTBd7n4cjz0Ndq8DwvBlbzyobgnXxUpQifTwgkpXZeyFqDxwGDTIBFNlExwTsBT
	 vSg0tDKa/605EKQV1lopCpj+8h/U2f2Lcpo47gTs/B0JE0y3YG+Cn5gLn+j72ZFjuA5co
	 HmmCEm7ELuUccEb5adcAiAzMWJtQBJxAipQ1lbouS36HFdeY8SXHxs2nNSanW8/NwIrr2
	 8ow7NfBZxpxquawPHIvwrPwo4RBpVChSrT/KEHIWsD90ujv1/4KNPstwXzwIkkRR534WE
	 EOzzbm1KDmkK/1In4+hhS+Ie2B+Ayo0Wn3S26mG6//y6B/kGJITtTTHsPID/Am+tmDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210649;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+6uxG5lBo2Z4YoVzX/TthAjtOdOktGruciwCMuX11tM=;
	b=iaEQHeLzMxuOhyl+nvsGimIVOA1tn0Jt0I2tG6ab8W5PuGAZNir3dY0hoQvRDmOZoctl
	 0cBygPPu7C6ZF/1Ryc66V0B3uqEOLr1JRRy7BtB5Jz9q0/LlyAx3vfyB8Pt+Kmz7Lg+CV
	 9elgDANCTK8ksdBTQmwhHKJK1PDTQ4Kj5wgMkbO9FhTlFAf8sBa/hhzYaPedanhgw69Wx
	 QIPLFXtk9axkITmGCaBKMJ13L7q3ROY2bivj5+8TV8BO0/cWz7umIqOi1mSZ/g3hE0qCc
	 KMjmgGgaah9DfdaSIWPj/I2+UvVCiZkJTRXKX43h/2wCX4LEmDo/CduQlFqT7kMwGdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bv+5cOyw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B6E5606A31C;
	Wed, 28 Oct 2026 18:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bv+5cOyw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD8EE1F01825;
	Wed, 28 Oct 2026 18:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210649;
	bh=+6uxG5lBo2Z4YoVzX/TthAjtOdOktGruciwCMuX11tM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bv+5cOywYSyi3myFCz3ObF2+3YHHgHsnPL62lh/OoZBZbD1VCw/tbY2xMmpBOCBwT
	 wBKjYd7WMX03xeXdycdOlM0drA4uR8dkD8XA6KWsymYTirEZ4wnyjo8VxCHzFlOQdi
	 DXggw7pTmZ5n9gZ0C51hoIKb6dePPYda4izjy+4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 100/571] watchdog: rtd119x: Use devm_clk_get_enabled() helper
Date: Wed, 28 Oct 2026 17:54:07 +0100
Message-ID: <20261028170010.394545237@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 6cc0768ba6f5293a4435612164a2cfbf2edbd025 ]

The devm_clk_get_enabled() helper:
   - calls devm_clk_get()
   - calls clk_prepare_enable() and registers what is needed in order to
     call clk_disable_unprepare() when needed, as a managed resource.

This simplifies the code and avoids the need of a dedicated function used
with devm_add_action_or_reset().

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/14b521b821279bc5111dc80b55d0936c5767c737.1672418470.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Stable-dep-of: 5af7d2cbd20f ("watchdog: rtd119x: Avoid division by zero")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/rtd119x_wdt.c | 16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff --git a/drivers/watchdog/rtd119x_wdt.c b/drivers/watchdog/rtd119x_wdt.c
index 834b94ff3f903..95c8d7abce42e 100644
--- a/drivers/watchdog/rtd119x_wdt.c
+++ b/drivers/watchdog/rtd119x_wdt.c
@@ -94,16 +94,10 @@ static const struct of_device_id rtd119x_wdt_dt_ids[] = {
 	 { }
 };
 
-static void rtd119x_clk_disable_unprepare(void *data)
-{
-	clk_disable_unprepare(data);
-}
-
 static int rtd119x_wdt_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct rtd119x_watchdog_device *data;
-	int ret;
 
 	data = devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
 	if (!data)
@@ -113,18 +107,10 @@ static int rtd119x_wdt_probe(struct platform_device *pdev)
 	if (IS_ERR(data->base))
 		return PTR_ERR(data->base);
 
-	data->clk = devm_clk_get(dev, NULL);
+	data->clk = devm_clk_get_enabled(dev, NULL);
 	if (IS_ERR(data->clk))
 		return PTR_ERR(data->clk);
 
-	ret = clk_prepare_enable(data->clk);
-	if (ret)
-		return ret;
-	ret = devm_add_action_or_reset(dev, rtd119x_clk_disable_unprepare,
-				       data->clk);
-	if (ret)
-		return ret;
-
 	data->wdt_dev.info = &rtd119x_wdt_info;
 	data->wdt_dev.ops = &rtd119x_wdt_ops;
 	data->wdt_dev.timeout = 120;
-- 
2.53.0



