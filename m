Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028395;
	b=Vy6KncDxbhbYlsH+IHVxxiDQd+oh6c+lziQC0lflTVinLMNz0lyWfQ//iwCflZ8VuWsX
	 9KI1wPBMeh+kfvW0KDpiDXTArzf0qZXbAcdNRo5yGApk5GipWdn72q+ZQ33Eb2BsOgNya
	 RASFXwXQzgo7/5S5DP3jJ3usFOm/5LOUBE61LxDTRpWbHmeb9T6rrd+UcA7LlAdMM1vy+
	 U3R4MiFFTmjfHxoSQmXFOgc7WfGXqmAuKUJxjWg01jX61VtDZzkMmQwBXFZ1hMaAVxQGN
	 LAeopCju8Uun19yqOdCLnwQrwv5LaHGH+htONG+yUWGVBdes1gEa+X5aYfXCZvhT1Xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028395;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1p/ZoWW7XTAMl48WNI8jGV0COlu1+h7fSkVjhrbbeac=;
	b=uqiPlJaA/Ivg3mavfazf7f3jurl9tzdyqiSz5pj1LLD87X9G1RkADNJ59iTjs3qRCuk5
	 qEOMQCEes9yvVXIH65isBCaDaFmYWMWdlxBkJrCsUo8RontTwlhqWolsIrfgKi9Jv11tr
	 hNxGFhukhT0MiZ29rr2TrALZpcIuT89GQHO7oVCHE5mL9wG8kgtVaCovtbYsjBU/v4bp1
	 45y3OSqD95TpE6m0wYrX/BW6zk7QRyCQvy58dng8MbAh1CC8u5L56G9KhOKhn33HzJQ5j
	 W/dMHclbD32giHKnyzpdc/zSSAz+wwjmU0noazDt/ckNWkD0eJtcE6M77rtEAaEa6qA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rT8Tsq8i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71ADB606A32A;
	Wed, 18 Nov 2026 18:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rT8Tsq8i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C87311F000C4;
	Wed, 18 Nov 2026 18:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028395;
	bh=1p/ZoWW7XTAMl48WNI8jGV0COlu1+h7fSkVjhrbbeac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rT8Tsq8iwQLXb+6+nGE70Z7bG1Icls5VFVrC/TbpAHMFYSTW/140mWWaTW7E/iR7q
	 HBHicepIiv2tpWvYL7j6i2ZA/cR6jThxMSagIK8oxd2VWqkiGUssLpO4SGBcRwAspj
	 zXTI7hdTCWfsMNuIF10eIsL6u/l+7ijhniqtA4Mo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Imre Kaloz <kaloz@kernel.org>,
	Joshua Kinard <linux@kumba.dev>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2128/2151] rtc: ds1685: do not sleep in the power-off handler
Date: Wed, 18 Nov 2026 16:04:23 +0100
Message-ID: <20261118150239.202989762@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Kaloz <kaloz@kernel.org>

[ Upstream commit 21a829af60a7f5c7456f1f0ff9b6b0eff0ceb738 ]

Power-off handlers run from an atomic notifier chain and must not
sleep. Use mdelay() for the delay before setting PAB.

Fixes: aaaf5fbf56f1 ("rtc: add driver for DS1685 family of real time clocks")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/sashiko-outbox-169477@kernel.org/
Signed-off-by: Imre Kaloz <kaloz@kernel.org>
Acked-by: Joshua Kinard <linux@kumba.dev>
Link: https://patch.msgid.link/20261013120208.11268-3-kaloz@kernel.org
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-ds1685.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-ds1685.c b/drivers/rtc/rtc-ds1685.c
index 7f84ea02c4038..4c7629b1f51f0 100644
--- a/drivers/rtc/rtc-ds1685.c
+++ b/drivers/rtc/rtc-ds1685.c
@@ -1429,7 +1429,7 @@ ds1685_rtc_poweroff(struct platform_device *pdev)
 
 		/* Set PAB to 1 in Control 4A to power the system down. */
 		dev_warn(&pdev->dev, "Powerdown.\n");
-		msleep(20);
+		mdelay(20);
 		rtc->write(rtc, RTC_EXT_CTRL_4A,
 			   (ctrl4a | RTC_CTRL_4A_PAB));
 
-- 
2.53.0



