Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048862;
	b=SOO5Zvw5sgrPbnsoZRbDQodlHLSIrXumUImIXN9JQwf2w3Wdjj72i8Nn9oUPqA+7Wvxb
	 I2RLOJVylWoErRkdfHPWxpQm9mmM0iifi1mIBvHuuCpFDRNq7t3mbQXnbernvLHF+1wSp
	 yuLixw2wsA0ChHGD8iFx0GLaXjpZc2SJRwqP7GKQcEqf+aq+nbDlMqw+6IY/SoGsMwdl2
	 CQ3BmD+29D1xnKQBS8f2uXU7iT85ZnBCO+lrP53/yBTr53MmBKaKK7786QSTM8cIvKWQW
	 iSNEwL4A9PKbjVkxaMuqjCpn5Wh2hFWdUqJ7XTQyl2qu0JOBij1B2cMe/fUh+ySP1ZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048862;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aFTgSxgWgHABNtLTZO7RpnbJH4wEtgvnvWjCZvs4400=;
	b=W9vaj72Hy+jkWkrtBCuZz6tQdCKMXOXLkzmNOcu+G1u05/Ekrprd/h5e0NRa9VGfgpYI
	 +aqTYpXHnhYDAYHpPWvI9EGvP523Gem/tcWbTuM7DoR4X9Im+kfCcCoTnE4ZhglYCfP7i
	 nUpOEM34E7JfwEpguZFhvnkmbPNwHASUBYL9OizAITDqPOaz1oBPUAmvW1skeEUE+FIAg
	 jp2/5O1M82TjkkuL9bY9N/mKGCMsuAaBTgNYM0oqOHHdrQDtaf2NrNLEVqf51GYW5oGiG
	 mw9WkXMuPWG5AImorll1DZvIt8oG1WyQ0i4plmiNkAo2gFaJ9gjExyg88lAHdDNqGBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J9OBoMHc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB566606A320;
	Thu, 19 Nov 2026 00:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J9OBoMHc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35A901F000C4;
	Thu, 19 Nov 2026 00:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048862;
	bh=aFTgSxgWgHABNtLTZO7RpnbJH4wEtgvnvWjCZvs4400=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J9OBoMHcXv6Kuv0ncTRJ4COY3prJZxudn635WbmXHI6Pb/ugIZEZiJ/KqC9LfXjjZ
	 zqizT0lvMrFqfgP29UTe4fMBJ0NCvzsyK9k2JclBvz16seVl2nhCqifJFPQrOEv+xs
	 Jjdg4flFWXt84VVVuXuntJwz2HPSUkdMio50VgQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Andreas Kemnade <andreas@kemnade.info>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2146/2857] rtc: bd70528: properly enable wakeup
Date: Wed, 18 Nov 2026 15:53:00 +0100
Message-ID: <20261118150318.667771376@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Kemnade <andreas@kemnade.info>

[ Upstream commit cb8a6249236fd970fc3418d5d2b27dc37376f3ff ]

Wakeup on RTC alarm now only accidentially works when wakeup for the power
button connected to the same PMIC is also enabled. Fix that by properly
specifying the wakeup irq.

Reviewed-by: Matti Vaittinen <mazziesaccount@gmail.com>
Fixes: 32a4a4ebf768 ("rtc: bd70528: Initial support for ROHM bd70528 RTC")
Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
Link: https://patch.msgid.link/20260922-rtc-bd-v3-1-7f2580c55d58@kemnade.info
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-bd70528.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/rtc/rtc-bd70528.c b/drivers/rtc/rtc-bd70528.c
index 59b627fc1ecfa..7f10f2f4f468b 100644
--- a/drivers/rtc/rtc-bd70528.c
+++ b/drivers/rtc/rtc-bd70528.c
@@ -10,6 +10,7 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
+#include <linux/pm_wakeirq.h>
 #include <linux/regmap.h>
 #include <linux/rtc.h>
 
@@ -318,6 +319,10 @@ static int bd70528_probe(struct platform_device *pdev)
 	device_set_wakeup_capable(&pdev->dev, true);
 	device_wakeup_enable(&pdev->dev);
 
+	ret = devm_pm_set_wake_irq(&pdev->dev, irq);
+	if (ret)
+		return ret;
+
 	rtc = devm_rtc_allocate_device(&pdev->dev);
 	if (IS_ERR(rtc)) {
 		dev_err(&pdev->dev, "RTC device creation failed\n");
-- 
2.53.0



