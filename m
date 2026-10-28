Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212278;
	b=TYKuaIpclypgPCWz9jtqVqA2+BvssVgmn3yvi+dKebR9QmVOjPpQoXhuTG5vUBwVsYU5
	 lv81K2n1c6Xosum6LCqaFyCr5gr2yZ0HWcq/YHYR4se0OL89PvlWV7jjA/VK5BxL59NjG
	 kjNaGd8OCNfUW1uZE45ST+NaaP+nsE6gCzuJqGre55yr7f1ZBZ1Uy94wKoOHwV3wIXnz3
	 CKM3DPwv6DJ2xpkgdCKMtyVZtFl9CxT1GSUOr1zH4lsDyfAth39AJZiUzgryKk4wivmzV
	 xBUsr/HJVzFvozoe7T8TslRWE1O2GYa3qtj4LF/LafATU5KWV/XX/JxDuEKVtuS4p1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212278;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UwG2zPYhV4xAGmGSV5Ve5KOKiHrqP/wg++6UdBhiNpg=;
	b=m4+7LXv4/y96Ad4/SM8ouuZQFRU87+a3teJ5I7z8TyzLgfS0OIBv/DiK4o1LlmsvvEEz
	 oRWQ9FMCA+XSr2F2c5spW+N2j2o4N6HdeMgJf3X0cp9fVFkXDroyAfWie4Hb1XEDmMVQi
	 ECAefjqnqF1HnWOD3Nfyv8ZpnxWOdFZosxtkdJS3DIVf7/8zFsqe+ZdOQzhIcYtzabFAS
	 eycdem7AY333KK7/ZhRdkcQnvQlW/+KEI0WuRsA9Wf5EPaDOjrcITRWSx8EWmEHjZoUsr
	 7aIs//LbzuqqqFqCuDhEDmccyTmrpkXVeAHCdPFLSdgdb8WDpdUgaQ2ff/BWfPRMnIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jcfc4VLw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7657E606A31C;
	Wed, 28 Oct 2026 18:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jcfc4VLw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B48ED1F01825;
	Wed, 28 Oct 2026 18:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212278;
	bh=UwG2zPYhV4xAGmGSV5Ve5KOKiHrqP/wg++6UdBhiNpg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jcfc4VLw+FRWWG2qb0lCVoyA9sEexjlCPeLgmrTsluFzTRm/t7n/JFfsznyy5jw/t
	 A+Uxzqxu494ztD/vAzfJMSavOS/SX5UtypkQYEq/HaRbUYbgA/5XWKAhjMh3HR31c0
	 WCi/sUb0AUmRjt6iL9KNsxO+HZtNGTzrZ7KhaxbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0099/1887] rtc: rzn1: Handle unset alarm weekday in rzn1_rtc_read_alarm
Date: Wed, 28 Oct 2026 17:36:35 +0100
Message-ID: <20261028170501.486703455@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit 457b5dbce31209e65e1184716ed3af59cb1c0372 ]

RZN1_RTC_ALW is a weekday bitmask where bit N represents weekday N.
When no alarm has been configured, the register has its power-on-reset
value of zero.

rzn1_rtc_read_alarm() uses fls() to convert the weekday bitmask into a
weekday number. When RZN1_RTC_ALW is zero, fls(0) returns zero and
fls(wday) - 1 evaluates to -1. This invalid weekday is then used to
calculate the alarm date and can either leave tm_wday set to -1 or
produce a fabricated alarm date.

Treat a zero RZN1_RTC_ALW value as an unset alarm weekday and return
without calculating the alarm date. Move reading RZN1_RTC_CTL1 before
this check so that alrm->enabled is updated for both configured and
unconfigured alarms.

Fixes: b5ad1bf00d2c4 ("rtc: rzn1: Add alarm support")
Cc: stable@vger.kernel.org
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Tested-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Link: https://patch.msgid.link/20260821211032.13554-5-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
[ retained the ALME-only enable check because RZN1_RTC_CTL1_1SE is absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-rzn1.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-rzn1.c b/drivers/rtc/rtc-rzn1.c
index 36381385d2628..cf9154a62d463 100644
--- a/drivers/rtc/rtc-rzn1.c
+++ b/drivers/rtc/rtc-rzn1.c
@@ -193,13 +193,24 @@ static int rzn1_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	if (ret)
 		return ret;
 
+	ctl1 = readl(rtc->base + RZN1_RTC_CTL1);
+	alrm->enabled = !!(ctl1 & RZN1_RTC_CTL1_ALME);
+
 	min = readl(rtc->base + RZN1_RTC_ALM);
 	hour = readl(rtc->base + RZN1_RTC_ALH);
-	wday = readl(rtc->base + RZN1_RTC_ALW);
 
 	tm->tm_sec = 0;
 	tm->tm_min = bcd2bin(min);
 	tm->tm_hour = bcd2bin(hour);
+
+	/*
+	 * If wday is zero, no bit is set in RZN1_RTC_ALW. This is the
+	 * register's power-on reset value.
+	 */
+	wday = readl(rtc->base + RZN1_RTC_ALW);
+	if (!wday)
+		return 0;
+
 	delta_days = ((fls(wday) - 1) - tm->tm_wday + 7) % 7;
 	tm->tm_wday = fls(wday) - 1;
 
@@ -208,9 +219,6 @@ static int rzn1_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 		rtc_time64_to_tm(alarm, tm);
 	}
 
-	ctl1 = readl(rtc->base + RZN1_RTC_CTL1);
-	alrm->enabled = !!(ctl1 & RZN1_RTC_CTL1_ALME);
-
 	return 0;
 }
 
-- 
2.53.0



