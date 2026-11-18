Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024935;
	b=iDbh+u/SJ6DNGIUBJ1FLsOxo2khtUj2Ob2kkfzdirnFgeV6gtvTiLNNp0Ieezu+T796w
	 5yJDnhez3f/ZulZ1Pc7+tyLu1bjC3yvOtwc54+m8pVJJwWif1XdQCLLDrlavzYuggxEj2
	 xks7Xfa8NzYblIo6+DBeZtieCV+SLIueCTxEFyzOksrfwYvdwNXqerGNh4HiBXRd/E+4i
	 Pq9ZqI9TLnfqJnzSB7J40cjf0dpFAt8AuXmctX0DMVgRJ5iM84zZq/Gt2mu0hezjkJLRu
	 /ylLAt6NHgT+0kKgJiSx0ugDXZ+hiMFU+8VIV3as5KiuXzumDatic5DGeRe18t0P4sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024935;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RyN+nxtIAXJRK2EcWSuZ2PzO+aBWj5LYoEIoNtfDtOc=;
	b=hJIUF67BcNnzrEHfojDUQ7T/2APF1TA9xwkHfJgg1z6qkNRknsOxYw4bmn1FXOn3/8qL
	 xo7BSRZIw0hJu9mzcpIrip1wn4RJGJErYf/SUutye6OalLXBAeVGhROCVp+nF/XOQlbAO
	 fOTmip9t2jd38LM6B9fjyNehe382rVrhPoVkyN9j30GOBKsQl/KwcghH3WvqRqJrdaHss
	 hLh+ENXj9+yqVmjw4ZOC60IH0qZ2wfEx2i0l7HszaV7w9PIaoSgoRcuZMG143HYehD+ba
	 Zvx4R/IWGu9PTVZ1WrSHZvl0wC5fnj1OvWaPo3qO/d5VTdqQfy2fWBlcul/zqlHwiAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hc9ooAhN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A10606A31C;
	Wed, 18 Nov 2026 18:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hc9ooAhN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D239F1F000C4;
	Wed, 18 Nov 2026 18:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024935;
	bh=RyN+nxtIAXJRK2EcWSuZ2PzO+aBWj5LYoEIoNtfDtOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hc9ooAhNqmg6wWDSOTYC7iLUletGeTR/et3I6GSB8wcrp7aSGPQBIBV+ufVI8LwDC
	 VlfyBKg8IPST/2NMN9gHYBdhW/rfrJ1VHF2HIeecNnyJpkHY1ZWmWnTXcjLoMkOsPk
	 wuHPAn36G5P1WskGK3khFFrkYPRiNdptGQIEFe9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Andreas Kemnade <andreas@kemnade.info>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0900/2151] rtc: bd70528: properly enable wakeup
Date: Wed, 18 Nov 2026 15:43:55 +0100
Message-ID: <20261118150155.077931711@linuxfoundation.org>
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
index 954ac4ef53e83..82e0c1044cf04 100644
--- a/drivers/rtc/rtc-bd70528.c
+++ b/drivers/rtc/rtc-bd70528.c
@@ -10,6 +10,7 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
+#include <linux/pm_wakeirq.h>
 #include <linux/regmap.h>
 #include <linux/rtc.h>
 
@@ -315,6 +316,10 @@ static int bd70528_probe(struct platform_device *pdev)
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



