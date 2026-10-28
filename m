Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210652;
	b=CdSYkilbOhqgH61nU7hMjO3God96+8uz3WfnvLGQgocntn6xUdYewUFgBK10KFDGy3GC
	 ubdg5KKE1rszm2h9d63TlNKw2No9/g9D1W6JhaObPb09/yLlP6+xc8i53YHI0WFw81K1B
	 ljPsoeyAUbmqswpoxW4vaQmwJHufWwD2IAy7Z3UUPaCSyr+F50IMIqPZvBOskQ3uTCc4T
	 GZkRF0J11SDv674WQWNQ1w+lKIGrl8ZE3So41LQdhXNkb5HmaUUnqP0GyjR4ZrBmeRfY/
	 qhGMwRIuPDBc6bbuXBbF0SdaMeTDci8j73Ysx5+uWVqMsDiQyHB1tV7viWWBXsGTe6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210652;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Er0AWsksXYgCaTM/QrTZcep46ZaylcFvvAMeIYj+foQ=;
	b=qA8D8LS6XebqU1s5BxWTGjYuosp8CBEbpyAnr//kZlWz9RJ/X8zQByYN1pFOGrqY/gSk
	 q/PHjayjbEFd6Sp/vkqHmXVnZs/et3/ZGdx3AOzQvvQ6MbdgEyEop/xfLmMkiIxAsAs92
	 OdBE1mv8LXeFvfg5fYwR+uk8GtR4Zk7sYmcjlHwKgHb7t5IhOH9K+1CYNKW0Y5nf8NPSl
	 +aq8SnMK5/tyGXPrp8uFUirIzRVZQT4cIlHn9vi/ab+5N0YQvcCHCpzGR5EqvEbV9C0cJ
	 72ESlGc5dN1qQRqBPyc91nlaQO43xKRO7/Xy8lyTHYhv2hsie1S4UJNKc73nfeVSFZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CBc1UJ0P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63624606A31D;
	Wed, 28 Oct 2026 18:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CBc1UJ0P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B10311F01825;
	Wed, 28 Oct 2026 18:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210652;
	bh=Er0AWsksXYgCaTM/QrTZcep46ZaylcFvvAMeIYj+foQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CBc1UJ0PMfD2PLNFn6k808NFzq9oLR1kixOTcUTGAQPs3cparDWPhx7/eQePaNnS4
	 ebAFYZoeWcXySoP5p97x6DuuCxBr/+wg8/ijpSlCTfpYB8vJH4/JchTKtHh4WTQKGP
	 ieQCgJ2Ll1so7zg8FGlkaMdp3NGZYfNeHCgg4tyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 101/571] watchdog: rtd119x: Avoid division by zero
Date: Wed, 28 Oct 2026 17:54:08 +0100
Message-ID: <20261028170010.418303234@linuxfoundation.org>
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

From: Tzung-Bi Shih <tzungbi@kernel.org>

[ Upstream commit 5af7d2cbd20f893def03c8310a460ade66a5d822 ]

clk_get_rate() could return 0.  Avoid a division by zero panic.

Fixes: 2bdf6acbfead ("watchdog: Add Realtek RTD1295")
Cc: stable@vger.kernel.org
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Link: https://patch.msgid.link/20260913064851.8239-3-tzungbi@kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/rtd119x_wdt.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/watchdog/rtd119x_wdt.c b/drivers/watchdog/rtd119x_wdt.c
index 95c8d7abce42e..e963be4df8c4e 100644
--- a/drivers/watchdog/rtd119x_wdt.c
+++ b/drivers/watchdog/rtd119x_wdt.c
@@ -98,6 +98,7 @@ static int rtd119x_wdt_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct rtd119x_watchdog_device *data;
+	unsigned long rate;
 
 	data = devm_kzalloc(dev, sizeof(*data), GFP_KERNEL);
 	if (!data)
@@ -111,10 +112,14 @@ static int rtd119x_wdt_probe(struct platform_device *pdev)
 	if (IS_ERR(data->clk))
 		return PTR_ERR(data->clk);
 
+	rate = clk_get_rate(data->clk);
+	if (!rate)
+		return -EINVAL;
+
 	data->wdt_dev.info = &rtd119x_wdt_info;
 	data->wdt_dev.ops = &rtd119x_wdt_ops;
 	data->wdt_dev.timeout = 120;
-	data->wdt_dev.max_timeout = 0xffffffff / clk_get_rate(data->clk);
+	data->wdt_dev.max_timeout = 0xffffffff / rate;
 	data->wdt_dev.min_timeout = 1;
 	data->wdt_dev.parent = dev;
 
-- 
2.53.0



