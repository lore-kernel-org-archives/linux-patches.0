Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051480;
	b=mMPR8By23mu+vff6VANzWD14h++N9dFuegb4z9L56l72+pLtqNFDN7QbJKspBSS2aES/
	 hUnZhRcOVVdYv94B15JVhFuvMzooZGt2OWlHp4FUiWtfgkdr8Sx63dNOShHkB9tCRMgp7
	 CXS7zurT7lqBXvAv38QQiA3i3kTBj+0/WewRQ5dsOchuWc87kFdksVQFhdNPGgG8hWlWg
	 vB8Tp6ZYiSL4lImfUsYcMpg/X7C1agiyF047UO3dOjnZeGPSC9MRfrMl6Ijba/pLkLQcL
	 I4gRintuOx6B1+lry4UOA8XRpsYbsuCzy8sxWemCQwononDTq4p/JiD2s6tuicxpoSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051480;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yUswpztDkaBbhQ/EozdUHv96yYip1zuxj8RcOwuAi3g=;
	b=sDKKo1V1bUJluiMGxmCTHdjLR9W1ouER7AhrOc4qdqcUppH8Md2a0C3q4dZMFJO1hU3t
	 oRKRVEFOqus45bMl1C4ANwqjXkZ+RG2yMdGxPNQNA6g36yJFKv0Xp1brqX2NYUPKvllfw
	 w/Z8BbeXaEq6J1WOO+meEUuCqQGZ5AZhoFdaqyOo9tbhyfmBzlVcQV7AORSBnbKaeJYCy
	 nh0ujnInGDKnsuXQE0zOwcDPYNiHghqSFlANpYUHDltVCWKDmNc/ps0ev17UOLUeDsFeM
	 etXQBbt3TDeMbiIG1LSuJglszQ5a8Sq+ZeH1Zkh7PbVPH37c4AGS/fy6G5zD34i85YQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="iu/IF/iW";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56F5B606A31C;
	Thu, 19 Nov 2026 01:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iu/IF/iW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF9BB1F000C5;
	Thu, 19 Nov 2026 01:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051480;
	bh=yUswpztDkaBbhQ/EozdUHv96yYip1zuxj8RcOwuAi3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iu/IF/iWlMQfe6OEraLY9rMgOwuVaIrQvuorf6YgWGXanYA0V35Mbk1PWW4grkpLZ
	 JZe+wJ/cUJYD4mdwdtFNavF8WsavfDvlt/0kLK69jT6bT20iO3gngozWslouIPGcHq
	 Gt8p1Kl0sNyyYtxxd+OF1DFsp2lWQ/3zlvTm0Hq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Leussler <robert.leussler@leica-geosystems.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0224/2214] rtc: ds1307: fix RX8130 wakeup alarm WADA bit for day-of-month mode
Date: Wed, 18 Nov 2026 15:31:40 +0100
Message-ID: <20261118150019.207669680@linuxfoundation.org>
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

From: Robert Leussler <robert.leussler@leica-geosystems.com>

[ Upstream commit 878d93aaa596a861dbc8d71f7c38e62a2e805f01 ]

The RX8130 wakeup alarm never fired when set via
/sys/class/rtc/rtc0/wakealarm. The root cause is that the WADA bit
(bit 3) in the Extension register (0x1c) was never set before
programming the alarm registers.

Per the RX8130 datasheet:
WADA=0 - Week alarm: register 0x19 is compared against day-of-week
WADA=1 - Day alarm:  register 0x19 is compared against day-of-month

rx8130_set_alarm() always writes a BCD day-of-month value to alarm
register 0x19, so WADA must be 1. With WADA=0 the hardware matched the
day-of-month value (e.g. 15) as a day-of-week index, which is always
out of range (valid weekdays are 0-6), so the alarm interrupt was never
asserted.

Fix by setting the WADA bit in rx8130_set_alarm() before writing the
Extension register back to the device.

This is consistent with rx8130_read_alarm(), which decodes the same
register under the same assumption (24-hour and day-of-month mode).

Signed-off-by: Robert Leussler <robert.leussler@leica-geosystems.com>
Link: https://patch.msgid.link/20260721081907.3518648-1-robert.leussler@leica-geosystems.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-ds1307.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-ds1307.c b/drivers/rtc/rtc-ds1307.c
index 03aa3f5ccdf5c..40fd2dbc273ec 100644
--- a/drivers/rtc/rtc-ds1307.c
+++ b/drivers/rtc/rtc-ds1307.c
@@ -656,7 +656,7 @@ static int rx8130_set_alarm(struct device *dev, struct rtc_wkalrm *t)
 	if (ret < 0)
 		return ret;
 
-	ctl[0] &= RX8130_REG_EXTENSION_WADA;
+	ctl[0] |= RX8130_REG_EXTENSION_WADA;
 	ctl[1] &= ~RX8130_REG_FLAG_AF;
 	ctl[2] &= ~RX8130_REG_CONTROL0_AIE;
 
-- 
2.53.0



