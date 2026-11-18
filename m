Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061055;
	b=eq9r3k3vENQfqDmYW49ErL5FhBFAMYlZkWWKb9g4dTIWzhWoMl40A+FkHarTCARrwzOn
	 EpXo3KkvlL0ejfUiAaq9dCz1xW4vBBdE4pTLArTl940CaI3zLL91CgKfg3JP4TZd7pgWy
	 INbZpQ/9VHBL6bBlq85rVGFaX4swB2HPBvQ4Zf5DYFHN4nEbKBfFeCWWtbgs6FYuR10/H
	 lmT3fjC13QuLXvRE8CH2mmhnuG12L3Pl4NDaKJPYAiMmZmXsHhsvkY/o1kUMIniMi8D5L
	 JUHX0Wp6h5dZyUMNluPuaMt8da+hkBHVgBouf5XyiDKcYLcI8idAgDUdEgVoCAPbdwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061055;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zUSyHZdwU4GsOyJ7Czk2wv60l+YYTTLXfWdN/xLCZFY=;
	b=vBmOh0amNuZpkpYVQp6WHOXgntI3hU3VEzUJjrVDEiHIgKY+D9kiYOMba2Zamio4hdO1
	 qWnrMpbdGVvLrs0mOMATUzNvvpPsculAzm2iH3hP+wkW2VQYfSEsrF1cI0jsYKa2HVndp
	 zHvdYDpAl10LypaNpL8mZytIM1FDg4fp5iBVsUOtstgs4qkTp/7+jYf6G/G5zRdnpI5wr
	 likjVLbNVaEmg86xkp7A0Tr+sJsQuqJroZjhdJx+fazbfNw/2mOr67wMFgS5819jSvPoX
	 e0Eo8aD0ogFbtEbljNrTZ9b6pZtEkmj6t+o/fJFuOYTgr5fAj9pI+KBOGbZdI4uqzKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MviL3YmT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7752B606A320;
	Thu, 19 Nov 2026 04:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MviL3YmT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD8401F000C5;
	Thu, 19 Nov 2026 04:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061055;
	bh=zUSyHZdwU4GsOyJ7Czk2wv60l+YYTTLXfWdN/xLCZFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MviL3YmT5ZYPNDEpZTEAS0/An15WMeECu/Y9otwGRGQAKev3FA913DyavuuI03MyU
	 3p7mvL3BS/FzLoBy1ktn7Lib+aTpOnCD1JgxJc0YkOH/sxWmQqvsuxBlj3ZvuvsUTY
	 Sfp7Zytn4uycLeB1NjBlqab7l4RDLewH+6XwP6Zs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Andreas Kemnade <andreas@kemnade.info>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1415/1848] rtc: bd70528: properly enable wakeup
Date: Wed, 18 Nov 2026 15:57:33 +0100
Message-ID: <20261118150018.728317459@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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
index 4492b770422c8..1d738e17d0760 100644
--- a/drivers/rtc/rtc-bd70528.c
+++ b/drivers/rtc/rtc-bd70528.c
@@ -10,6 +10,7 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
+#include <linux/pm_wakeirq.h>
 #include <linux/regmap.h>
 #include <linux/rtc.h>
 
@@ -572,6 +573,10 @@ static int bd70528_probe(struct platform_device *pdev)
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



