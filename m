Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033295;
	b=BYYESCR+wUVZu/vJqoB8wc4Pr9aT7/uTMnL9svRZCWp1Ow/ecq7cY5dcLlaYUsrmYSMw
	 1F6isy+hcMRq7rFqxMsnBmxLgvxANdV2GsPBBvDY6AQ9AVoTIvno+D84mWU2shtKKDvEw
	 R2i3Z1wWmY1wOMAolFl22IbQ6Re/YYcrcF2Qhrwz4sqSG88Qv1+9vjIhIcrZmYQEvm43n
	 65PbeOnRIaPSNnkHJNFMw0AcUL4AgXAq3WEEY8O2HmwWSMu0x9ljZ5qFNK3jF9pF878NF
	 2eQu9y9UFLnl+k9ELsdWJIGq7jp0nmm+5uzMqJX2JnrC4jjNSNjDkNk2GMHfrMYQwmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033295;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IieWjkNHBysll3QpmLaXSQyh7IyWx2cgNpmJautlSME=;
	b=Dlc5e7l3EqKsTRhqbYKEjgip0xKdWzVwQe6PK0bHBOGaXOcbPUmHwPETCGXvtLCPqFCA
	 mGy1LC5fcqqUK28wEo0yQ+8MlRb8Aq0M+iGkAbBpQJwCmNWPdzNmZybMWRpdZGh7AhjjQ
	 4E45j3y63WsEGILfpSCiwVqq5+Z+535HPysORW2cPqE2CIT2/cJBmeOAfB472YYxuz1SU
	 13Rl1mpDdofAMNJOgdm4thOuWGBKKuQwrd3gaZT+dyoMZgl73H09GWBf/u+Lsyq+bWiBu
	 k84X5Qj1PgZm3gOjlyTlFTmMFesJIyabgMJXR3BUs7QVfbsY8roKOc9g/IiqmGuZfvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VxJsESeX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52ADE606A320;
	Wed, 18 Nov 2026 20:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VxJsESeX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6A3C1F000C4;
	Wed, 18 Nov 2026 20:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033295;
	bh=IieWjkNHBysll3QpmLaXSQyh7IyWx2cgNpmJautlSME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VxJsESeX6qvNgV/sRb2iQwNRxUBA3SuO5RJzEFwzKvLls0OTQkPaFcwrLv4iC/fSf
	 +RHpx/D+npa+RBMUykCzyY6oaocBo2xS0M78W6g4K4gm6Ps3l/HpttLdY5eSo8QctI
	 st5zoChQcqSIt1sk+RlOfDbGfIKLyXFaF6HRSCIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kaloz <kaloz@kernel.org>,
	Joshua Kinard <linux@kumba.dev>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1718/1756] rtc: ds1685: arm the wake-up alarm at power-off only if an alarm is set
Date: Wed, 18 Nov 2026 16:04:05 +0100
Message-ID: <20261118150117.989408917@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Kaloz <kaloz@kernel.org>

[ Upstream commit c2373bcd50d9654b76eac585c7c98105665b3321 ]

ds1685_rtc_poweroff() always sets WIE. The wake-up alarm then compares
the time-of-day and date alarm registers, which hold whatever was last
written to them, and a match powers the machine straight back on.

Set WIE only when AIE is set in Control B, and clear it otherwise.

Fixes: aaaf5fbf56f1 ("rtc: add driver for DS1685 family of real time clocks")
Signed-off-by: Imre Kaloz <kaloz@kernel.org>
Acked-by: Joshua Kinard <linux@kumba.dev>
Link: https://patch.msgid.link/20261013120208.11268-2-kaloz@kernel.org
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-ds1685.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/rtc/rtc-ds1685.c b/drivers/rtc/rtc-ds1685.c
index 38e25f63597ab..93f463a8251e9 100644
--- a/drivers/rtc/rtc-ds1685.c
+++ b/drivers/rtc/rtc-ds1685.c
@@ -1370,7 +1370,7 @@ module_platform_driver(ds1685_rtc_driver);
 void __noreturn
 ds1685_rtc_poweroff(struct platform_device *pdev)
 {
-	u8 ctrla, ctrl4a, ctrl4b;
+	u8 ctrla, ctrlb, ctrl4a, ctrl4b;
 	struct ds1685_priv *rtc;
 
 	/* Check for valid RTC data, else, spin forever. */
@@ -1397,6 +1397,8 @@ ds1685_rtc_poweroff(struct platform_device *pdev)
 		ctrla &= ~(RTC_CTRL_A_DV2);
 		rtc->write(rtc, RTC_CTRL_A, ctrla);
 
+		ctrlb = rtc->read(rtc, RTC_CTRL_B);
+
 		/*
 		 * Read Control 4A and check the status of the auxillary
 		 * battery.  This must be present and working (VRT2 = 1)
@@ -1411,13 +1413,17 @@ ds1685_rtc_poweroff(struct platform_device *pdev)
 
 			/*
 			 * The auxillary battery is present and working.
-			 * Enable extended functions (ABE=1), enable
-			 * wake-up (WIE=1), and enable kickstart (KSE=1)
-			 * in Control 4B.
+			 * Enable extended functions (ABE=1) and kickstart
+			 * (KSE=1) in Control 4B.  Enable wake-up (WIE=1) only
+			 * if an alarm is set, else stale alarm registers
+			 * can power the system back on.
 			 */
 			ctrl4b = rtc->read(rtc, RTC_EXT_CTRL_4B);
-			ctrl4b |= (RTC_CTRL_4B_ABE | RTC_CTRL_4B_WIE |
-				   RTC_CTRL_4B_KSE);
+			ctrl4b |= (RTC_CTRL_4B_ABE | RTC_CTRL_4B_KSE);
+			if (ctrlb & RTC_CTRL_B_AIE)
+				ctrl4b |= RTC_CTRL_4B_WIE;
+			else
+				ctrl4b &= ~(RTC_CTRL_4B_WIE);
 			rtc->write(rtc, RTC_EXT_CTRL_4B, ctrl4b);
 		}
 
-- 
2.53.0



