Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830990;
	b=Jj2XIjnsFVFBkEJr83BjUcLHg4LILAZgGr+gnSfz+cbCtZOgT3xFIxtU9huGJGS67CeX
	 aY5PseZXVNhYTL3BSBbQaqbcrTHnNzE1tBFNBPqW3rQj04I38C1DP4gFvSC4MZoFA/pRC
	 Z1QzK+q1bInEmWR8zDiA8WfGUg43zAKh+rY0zvjL6xBhuSCLiYjQyf6HEiuGVDmLm/y8F
	 bQNCJ3X8uUAm1otOx2ZTwAbJRk/hvG6Cgd3K1UuQGVSzDyLRVl+UGptpIiv/kYb8QEN7N
	 Z8AzOEUo120RUdUTUbLe04lCe/Cg9SkJEvr9zvAXbjTG5svbyCabg8Swu7ZK8F6avrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830990;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WQ4ssdT16px5J68S9MTn0j6WSArJRmSITwAZZF+Sjqo=;
	b=1pfOhQgJqHaxGvLCfrd2wrPinG+nvLz+/o0/a1AkHKiqPsR4E5Wgq4z1oIykLYEpxZJR
	 /pgawGskd3g2gaitzhFAQ2BgaBjpAV2nBGvexpD3b5bvzln0BWVbhISkcG/UCM/xyJv+c
	 g4EG7y8+7qlmJd7gvGJ0V3l7pc1+55Hd8dlvolqXid9mRXzS+Zo/RIjLfVhisd5qpWkBQ
	 zdkkyENvSbnwz7d7sWFabiEEgZWpiMNGpmjrbAa+6ASICw+vYB35ccLfeyztJiklaXKj5
	 Al27ItqqWTSoi+L1yCIR4JklRH5mtck9y7EGJlCJ8Ost71J8SpygirgLagAa7+yBIvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mZ8nRL2E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71B3606AB3E;
	Wed,  4 Nov 2026 22:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mZ8nRL2E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 837B81F000C1;
	Wed,  4 Nov 2026 22:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830989;
	bh=WQ4ssdT16px5J68S9MTn0j6WSArJRmSITwAZZF+Sjqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mZ8nRL2EvZtlJvBRV/B/grQoTeTFevfpU3wkNDrvZwPpv95+W5RDu5XRNh9Hrp1ue
	 s1dSfmc3CQaGni1+amlNLpPom0yq9wXa7TuS2HEQAjhgTZaGPpqEEYXdRiQOU+DIec
	 b0duknFjDgcLEeQ9JYbrQMjMdmrLZjyfJ9kYHsO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Leussler <robert.leussler@leica-geosystems.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0442/1005] rtc: ds1307: fix RX8130 wakeup alarm WADA bit for day-of-month mode
Date: Wed,  4 Nov 2026 16:02:55 -0500
Message-ID: <20261104211056.454048204@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
index 9ba5958ca7a6e..d9a8e5045e37d 100644
--- a/drivers/rtc/rtc-ds1307.c
+++ b/drivers/rtc/rtc-ds1307.c
@@ -662,7 +662,7 @@ static int rx8130_set_alarm(struct device *dev, struct rtc_wkalrm *t)
 	if (ret < 0)
 		return ret;
 
-	ctl[0] &= RX8130_REG_EXTENSION_WADA;
+	ctl[0] |= RX8130_REG_EXTENSION_WADA;
 	ctl[1] &= ~RX8130_REG_FLAG_AF;
 	ctl[2] &= ~RX8130_REG_CONTROL0_AIE;
 
-- 
2.53.0



