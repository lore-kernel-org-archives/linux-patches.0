Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017945;
	b=5Lru3RRdkHh6E57t/1Hg8zYjChEGT9hOj5DK5kbr3XA2j52krP/43h7OtxxFqzEJdFmD
	 b78O02NjxJlWn7MYO4s1k1xVHhxizS7rGkvO94xcB1b2rI8qMigMWwQ++uFANhkFnN27X
	 98yJe0XVskMTNMirsadLbdGnl/0QOD9oLLaHvbY0gMXiKl8raO3uW05nVmAM6MvpPohkX
	 f0+Q3wv5rj0eQgzFD3DbFVWMg6yHqDMKDDNOcxwF/7dXrSP1HDuvwDNF/03ln7tJ4gaPD
	 o0dmYtlH077Dk/CH0ikG3IZ8xL372MYLayA0R9wB/a2SRB9rlt4/QOqAKpYqkxAOr7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017945;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cVha+yU3srOs0LIyxNPLv+1O8kz9L+e58qXrBNLmHuo=;
	b=1eP84fFkNjv/IBfb+ReePv4s807nsvt3KUzhVloybYrqkSzJ4PiorREa6i39BrqYGsxA
	 oHLd9d4r6qBPESE+Th7KMIPhrUPaJJEpntaNbtAu4afWuzmhfV82RmEepokkaaPldRE7d
	 ohoxAbe9T2tAlbJtavKKcGavT7rMPb0DCzlw3p6ZV7BTAuxMHNkGlNOcFby4o5m8DBcJv
	 YyHU9nkpzmDGc9hIGBZ0i96j13/3+6kOXWJjyXPHVRZqkxHw4n+9/yzjWtdrrhm9uey/i
	 3RLgxKHh0oU2Rkcwztow2YlGBWEJcd/ZSyZrYkbDzB8URibLurkHCux55kcYvqYahHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P4nRtVvw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACC34606A32C;
	Wed, 18 Nov 2026 16:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P4nRtVvw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FE6D1F000C4;
	Wed, 18 Nov 2026 16:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017945;
	bh=cVha+yU3srOs0LIyxNPLv+1O8kz9L+e58qXrBNLmHuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P4nRtVvwwMDLtA3nCi+z+Fj0HBjyKYGpvNL+qWh1OWu5wlkrfu8Gn7vlzzsx/H3Nu
	 NZpvjArqtUfOWuleNdQ4ZhhfVBuMRgfrXuEFrUthAm2PEC4iJyt90aBnfTmM/uEBUE
	 PjsUvsT/4FdpqAIKCJ9OqIfjqLr2zBgqBRFdeyjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Andreas Kemnade <andreas@kemnade.info>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1065/2651] rtc: bd70528: properly enable wakeup
Date: Wed, 18 Nov 2026 15:38:25 +0100
Message-ID: <20261118150326.321861340@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 482810b61495d..a58cf85bc1beb 100644
--- a/drivers/rtc/rtc-bd70528.c
+++ b/drivers/rtc/rtc-bd70528.c
@@ -11,6 +11,7 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
+#include <linux/pm_wakeirq.h>
 #include <linux/regmap.h>
 #include <linux/rtc.h>
 
@@ -321,6 +322,10 @@ static int bd70528_probe(struct platform_device *pdev)
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



