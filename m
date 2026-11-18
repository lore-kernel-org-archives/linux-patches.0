Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034270;
	b=5c6iBnwa1DuudMtY2KaPzfG7oxOHxeNe2DWN2G/r69mgkCNYHczOzlE7I21YGVNEo50m
	 +mLYSaiXxbJZ5qn0YcOChf11Ae2N7vcGsVy6r/u+9IMvUJd20xqFY1N8+tFksJNaz7+v7
	 QGucJMgYSJjC2vZquSTUSQUKnkyqLIGSG1w2OYeYe27ISAq/OfvKJAdK06KEBsB1/cDZZ
	 4aMEpgx9msSsizNJ+wut/pMM/a4veE1w9o60R41tBwZISt6j/K/K3uyDLjAnko8U1GMQ4
	 WfA7gVc6GKICKLOx6Hhvn4Zk/KucqSDYvGFEKCTslFD3AQ4+VFL6j/gi5PIayAhnXYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034270;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+HprZ9esfZz5YgjL+ctZnNG9NrufZ1KmTEWn+dvcpS0=;
	b=qr8w9HqsVn9vCPO1g4xZIIF4L1xWXLrU9RIt4UbFbbgjNcZBYRSaB4CTic+3Xcc5KB2Q
	 y4t8zLAw0adV99Ou4qCpDEuIRvwQgqPptX0O8gvVnuj0Z7U137ROMyDMGhjf1Q1+4rELa
	 EPjYjKcKUSV0OnlAa28rvt5qcT8HLMi47eOax+QwWxZEyZScPJjJUufBWf9UKvcdy3T/i
	 A9REHb3/xg+nAAMBjNuMkjiWwA0uLN2QeGCoTVDXdlnuJ4O2T1gQt71oeg3EWlLMzhrHF
	 PTlDXCLZ3Cvm6RjvGp9WbhXlHYDVXxiYQN8OGfAs2XxInNyCbOpmVExgJ9BlKuWfFXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lk6BUDfX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19EF9606A325;
	Wed, 18 Nov 2026 20:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lk6BUDfX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D1C41F000C5;
	Wed, 18 Nov 2026 20:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034270;
	bh=+HprZ9esfZz5YgjL+ctZnNG9NrufZ1KmTEWn+dvcpS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lk6BUDfXvLHHMPBh9JR8DMVK5mE7X3abU3+yipxPOwm6IPYQMSfqwcNgH/GIs7zdc
	 nG2B6VFMP1g9GQTrljJ2jdBVKI0i5S0unkV6yQPL6oCxDmADM50nCIyQVxKeDTK1pf
	 FntNFON0Wgnk1JD/O+V6eavsEPk2kyUynimlGoEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Leussler <robert.leussler@leica-geosystems.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0310/3318] rtc: ds1307: fix RX8130 wakeup alarm WADA bit for day-of-month mode
Date: Wed, 18 Nov 2026 15:15:32 +0100
Message-ID: <20261118150325.094909101@linuxfoundation.org>
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
index e7ba52cb54120..4ccc71439b88e 100644
--- a/drivers/rtc/rtc-ds1307.c
+++ b/drivers/rtc/rtc-ds1307.c
@@ -657,7 +657,7 @@ static int rx8130_set_alarm(struct device *dev, struct rtc_wkalrm *t)
 	if (ret < 0)
 		return ret;
 
-	ctl[0] &= RX8130_REG_EXTENSION_WADA;
+	ctl[0] |= RX8130_REG_EXTENSION_WADA;
 	ctl[1] &= ~RX8130_REG_FLAG_AF;
 	ctl[2] &= ~RX8130_REG_CONTROL0_AIE;
 
-- 
2.53.0



