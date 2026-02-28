Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8C533F38A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301180; cv=none; b=OoyqMngFcgw8Q2RtJgpCa0UXdq9Hjd8goGW1JGnANUDnw2VApTTl5El1pbLQ5BE/KxH+/wRP1W3l0nER4F19xe/mQqZ/xdyLE4ksP0F+uckvhFpmSntUyBKYqYWKoRTuzlw5kk+furJvKdE4nnEco4ImagRCpPZDZY4lWHSh2IU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301180; c=relaxed/simple;
	bh=neWF+2LZdaQ2MOhn1PQjNr004MV0PkZmv2RD8jGWMRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cnSWOlQP9QkH2+dqLXz6xMYUWqO8KKhCTT0DcK4obzHymEsj8s6CUw9uF0TNEDhezT4DdybOjIkfqCBGhRBuwCaay6kYpu6oea5elNgf2nehHJEEMzAF0l41XR1jDTx3w/RZqXfeDVQHTQGZmfQUlVWtAYs8o+N+dKdnpWA+Bas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eM13319o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eM13319o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EC7CC116D0;
	Sat, 28 Feb 2026 17:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301180;
	bh=neWF+2LZdaQ2MOhn1PQjNr004MV0PkZmv2RD8jGWMRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eM13319oOFZQ31QyPn9xyPRKs3Fe7TH2RcXKX0uaynguGpjVlETQUw9fWvFjlA/cq
	 WPo76MI+Pj4ABEfpmsVOeo1cX/MgD3B0Kt3WhJWm3SmwlJYWiFH+5lMOq/cyv+nBbo
	 4A+6nKBZZR3Tfz7hxQ+YQ+Zkmp2S4u6xaicrHqvc3YSC4FtfXDD+j3wFZqveOpr52S
	 JuDgXrn8+FSuxXBQPmHHq12EWjSDSzh9lDD1RvMfw6W5ETuotkplOJU6s+xnq7qwyS
	 wc6UyBhkguAlsSsVx2lnYoObSvthTFoZC0lPALD0wz6SlzKv5dAhcAt6fYrAv6z+8t
	 Fm+kttTedW/EA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Oleksandr Suvorov <cryosay@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Frank Li <Frank.Li@nxp.com>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 349/752] watchdog: imx7ulp_wdt: handle the nowayout option
Date: Sat, 28 Feb 2026 12:41:00 -0500
Message-ID: <20260228174750.1542406-349-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Oleksandr Suvorov <cryosay@gmail.com>

[ Upstream commit d303d37ef5cf86c8c3b2daefd2a7d7fd8ca1ec14 ]

The module parameter `nowayout` indicates whether the watchdog should ever
be allowed to stop, but the driver currently ignores this option.

Pass the `nowayout` parameter to the watchdog core by setting the
WDOG_NO_WAY_OUT flag accordingly.

Signed-off-by: Oleksandr Suvorov <cryosay@gmail.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/imx7ulp_wdt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/watchdog/imx7ulp_wdt.c b/drivers/watchdog/imx7ulp_wdt.c
index 0f13a30533574..03479110453ce 100644
--- a/drivers/watchdog/imx7ulp_wdt.c
+++ b/drivers/watchdog/imx7ulp_wdt.c
@@ -346,6 +346,7 @@ static int imx7ulp_wdt_probe(struct platform_device *pdev)
 	watchdog_stop_on_reboot(wdog);
 	watchdog_stop_on_unregister(wdog);
 	watchdog_set_drvdata(wdog, imx7ulp_wdt);
+	watchdog_set_nowayout(wdog, nowayout);
 
 	imx7ulp_wdt->hw = of_device_get_match_data(dev);
 	ret = imx7ulp_wdt_init(imx7ulp_wdt, wdog->timeout * imx7ulp_wdt->hw->wdog_clock_rate);
-- 
2.51.0

