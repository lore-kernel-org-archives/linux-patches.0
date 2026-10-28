Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208516;
	b=ky66033hGe9i2mQPddr49O/UE6j01NV6Jaq5DvRdtKObH3zAgx3mrnAuZa5WamxeEM21
	 YXL6zSIEkNcq8oc8fmaFDeJHaHIFwW7vJPm7A6BqJOV53Yws/OsmFX6ZcpzY4mx6FIwZl
	 J63lzHZCabRm97Uz95g0UbJDPoVl0x6m1EbDqHzknYTVLd5fPUvFLdSmOJ/TTg+XM/7fc
	 3Ygm+VLjCJ1lq5cxDPcU681qoBmYoCyKJer9U9hCxIRubygkw2pGDT/9oOygqtImNFMUK
	 UGmgfBTz7dc3kY9EnWQF4VbRsP+dm+jWCq5jdSkSGRS960DJ8ZFlFjpsDogZwaNGlzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208516;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x18o3Fl/9WQ8cIkyIESVkLFX90ZgmxnW/ZT9EOI+z0Y=;
	b=RqmNp4eRkQYxaHJGOmSJNJQDr1XjH92aA9mTzIUczbx12Azpc9YKrHHLsAQ+asAL8+Sv
	 xQJaiIJBkhfSq5qGGpYiNWwAFGjhBtosp7brORijPxJMqW4a/RvNhhNCzvfSQheKF8J/5
	 jlP5986VGYmeTHxrRdbmjeVFzMhmqpu2GtRQJci6gcH1WsewJ6RXqmGp7XgoRXa8VLWjr
	 Tusfs9mLh7S6XRDG4wV+YuJQROwVzuDvsSvkBHWAzmWaKMs/wz+28V38ODnuB2xF+Lq1U
	 1GMi+BgAXVJDAnOh8DrBYvhVkoaiBGNxFB9RevSc5a4Duj0FCpNeqwTSCRt1e7160pg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="b/RW7eJI";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 954C9606A31A;
	Wed, 28 Oct 2026 17:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b/RW7eJI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D7811F01825;
	Wed, 28 Oct 2026 17:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208516;
	bh=x18o3Fl/9WQ8cIkyIESVkLFX90ZgmxnW/ZT9EOI+z0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b/RW7eJICn7RgK/+P3vnirrHAZqA/c7dq7v3XmfT5ORqmBGgxXY2oUmLZ4mmtcf52
	 b/bwes6zgvnVBs/FATLLjUarjHqNl4r0l5pxTi03k+LaSwuXKsbJGYVmEoxxaVMja5
	 oTvc2PohvDQP7e5F6tEfzr5aWJh5EEn6zB+fFVe4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 104/516] watchdog: rtd119x: Use devm_clk_get_enabled() helper
Date: Wed, 28 Oct 2026 17:54:16 +0100
Message-ID: <20261028170005.982225708@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



