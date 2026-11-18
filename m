Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040488;
	b=O2/9h5+9Z6nb0+2XbFG2dTu5NPFyIkRmBpBeomrd4T9stkAvWE5MY9fOTAS+Fpu9vdKD
	 xOKT133jg/19aGoaU/IF81Ax9Hv/59HEtU9kPDsYU+wxPYO4Nlhqk5CCbtheEL+CjFBY+
	 ffawCJ/6oaguesXZIfskxRa4O6AYvyCY9qyf4frXIODy7rb17XRlwv3nU4KeHe/BhO7+q
	 6tXIcpM1tlZwIIUeKoeu40Ja0FD/SYS39DoDuplgZTkUSqWrTZXh9463i1bxw4aMfrauC
	 FI8nrd/A2fT8AEi5PXkAwPOB6QeZN+l1jM8bDPyTzpq6GzKZ0AgTL8obLFY57//q9/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040488;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0MrMUIi4g6Nb1CM/2dQfoFlnkX4IX10lCva3ICFnpGo=;
	b=AhlUPjnFgoqW6osPT12mpBPkwNHG1JDAgPCkGYyWujFzxsYqOlDyHUMV+bVBxSAkt8xy
	 Lg04jlWgO3cnLaW4jEq6/R/0PeAvwRG9uW7Cnsrh1vEBac/rOU02xVZS46Khv5M27VM4U
	 fLMJqhm7Hh1mCw/rwZ1CQ7/byp1LDR50mPAAELbLtQi+LtKLuuUY7n4FoZsXA+eNzQOiu
	 qezFwO9H54zmFQRY+qmkXPO4EgN59uOovTWE8TbCpInmiZKaKsnuj8VRUTX7H18H1w6EM
	 MfDglJPnQ0GhbpC91ZXlf7kGSv042+vBtANMmNBEikpRxUK0S1iLtuyetvla+1dsYAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LyGZzBl8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB06606A31C;
	Wed, 18 Nov 2026 22:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LyGZzBl8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30F841F000C4;
	Wed, 18 Nov 2026 22:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040488;
	bh=0MrMUIi4g6Nb1CM/2dQfoFlnkX4IX10lCva3ICFnpGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LyGZzBl88pqZqQArVSCyL7/2T6NoMLbg3HFG336ZzsRdomg4ICNxt0AeGhApLEvkk
	 Dgk6jMBRPVDaQNMQaP9lt6PWWBJ/2CMx86+4OpGlgq0RI7fltmRasoOaYGbsXbM0FG
	 yTABGBG0K530lgWvfpNqRmb4lsHWJHqn08oFYSSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Andreas Kemnade <andreas@kemnade.info>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2475/3318] rtc: bd70528: properly enable wakeup
Date: Wed, 18 Nov 2026 15:51:37 +0100
Message-ID: <20261118150435.658356156@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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



