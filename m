Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055703;
	b=hMlyq7qOLo/YKh/Qtblz+dnpwLyYxPIl1WZfOTjdq9KuxXX+ZQukh0rQsn3DUWJzykWA
	 1i/LWsSFDnQPAWAtX1kn/LfSpFjx9KvLarz6E/4UVGKlKYidHcYZaNAWGU5bV+rOb7MCN
	 2IB8H+LyGxnMaCPhpvJzGVL7LSy5tREJ7AdnO0dTe4Ou0xkh1KsNeoM55iuJ2jBkB4FYu
	 H5W1ISG11gyuxaVhIB9iTi+z0chSF5+vfYdRHR/oRNfBu86WUoUc0GDAL9ZR6hog7uzYd
	 Y8fSIbVEG8g25LSnqSq9uqYdq9jBdT9Nwdocefja+IewwPEhFpLlb0+gIoi1oujNFxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055703;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1CYH6NTUFRnZOsu9j8qU27mj8R3db7hEFd07HFrzD4Y=;
	b=2AvVzihAOfc1qKEd2fa39AeTTBb3b4N8wsNmOGiHySHzs+1ERioor5eRjzxYEVvuvPvL
	 couaMKhs7AZCYnngbWZ+VviVgnNXQMQj44ehjluZvcBtZBGLqQpUhaJq+mSdM+XaLo5BY
	 0mXJ2w0IfwLfByLN/wjnbFIUPi+Jv8gTZtGWGmoaOqBmcQ5v6bWcfmqeAW/UkvDXM0gY5
	 3TDtwozRWjtDXVd97cSpW+Medl8HA7CN6reknRA5uBtsdGqg/yzEglRRwVQJ58QX8mn84
	 M0RkKyHH+5oJoqtvev8bQg+JVJMOlhl3ODk/HVU9Cdn6aoGGKLv5Igb2l0K8+0sP5AQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W440+NUV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8673606A32A;
	Thu, 19 Nov 2026 02:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W440+NUV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09EB51F000C4;
	Thu, 19 Nov 2026 02:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055703;
	bh=1CYH6NTUFRnZOsu9j8qU27mj8R3db7hEFd07HFrzD4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W440+NUVU8e8gI90HAYi0ug4XeQUXgtmBQyqDsnhfeRc8XcoSjWAvlfEepd+C6r7p
	 2CwDr3qz3KFIrYNIcMjjbt8lUBOTrjyEOGdlzaZ9bSjkPyjfxzu55meG4kZ6K8s0zx
	 J8JGGYhUOPh45DMiHhvDApuV+WcTdpw1p5pX71t8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Andreas Kemnade <andreas@kemnade.info>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1684/2214] rtc: bd70528: properly enable wakeup
Date: Wed, 18 Nov 2026 15:56:00 +0100
Message-ID: <20261118150119.200366039@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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



