Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043589;
	b=4B+U1RuNlz8oH9y4qZ70pYhzzRlOxUrFi0DyBfc7yvm/sYzvbPAS4tcA2S7nHiX+vpeg
	 nv0N1zMSWfGUkYUrPpQSL8vJrg5AYZF6TAfbCKLvY3Atp5/1rk1n3DTvp6rk9gTZkT6V1
	 3uRRaeq0zg5fRKjt1FWrGIRQ8buXExdXs1MpR2PAPHZJtJ29ABJh6/oRJcLR+DG31oI6b
	 xxg5B1I/TTBDONJER1EdcXanYzPVdONtQHgyGJSPFm4jUg+UUL/AkatjiC4241/wNCPbE
	 xGueG3zMmZGSniA30Me7qsb503rnfPyoNDKpdEWfy+rBHOogI6AvHhe3XCQjIDhBD3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043589;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1rz1pXeGWfLTfJxvgc0646OiuZMC3BCGVptTBtK+AWQ=;
	b=UCA7WWpPD3UVKfbNgzuto1qGOPrcx5Xq3dSmlea8e0w7oi024OoF3tzT1pSVY5zF+KXw
	 /2RkM6FNMBuDZK0sM/01b9B0Rh18nftumJVefqE+FTlJA8/XOL7IfmlPICegMDoD3Ja3I
	 fPDPHPl8UBAR6MH2bENg5czeCl4u24GxPL/h4CqqwCwSz9Yc6Ga/IO43VuUSdjjdQRq3i
	 MQp7X7mXh+YYeYb79KEHzRLL40QqHIFiERC89yU6ZishLXVsQDAHg3+bA35VE3B1ceE6I
	 E+yv5jj70BDexm2BKrAyduup1tr3iqRzHsIXs3BuX0oFbqumHRlXe74QlgMXm40Hjog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jnBPJWY3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59261606A31C;
	Wed, 18 Nov 2026 23:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jnBPJWY3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55C941F000C4;
	Wed, 18 Nov 2026 23:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043588;
	bh=1rz1pXeGWfLTfJxvgc0646OiuZMC3BCGVptTBtK+AWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jnBPJWY3yeNxv/oLCLwyT109SbCqG8Pjt4CFxhYERbt452Ipww7l4RQ49vUar2+hW
	 fsu43UFU1p2/WOsEgGjctq6XSF9NcJy+u8NgNXPH2B34guj4yFvqoKUzgcexeZ4XDu
	 7qntSCDHmzvmqzhdkfGKMnWDMQmI/6tpiuDlcdsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Leussler <robert.leussler@leica-geosystems.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0263/2857] rtc: ds1307: fix RX8130 wakeup alarm WADA bit for day-of-month mode
Date: Wed, 18 Nov 2026 15:21:37 +0100
Message-ID: <20261118150210.903594409@linuxfoundation.org>
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
index 00a83d543cab2..8824a72a1aea7 100644
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



