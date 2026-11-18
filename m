Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022369;
	b=yJex1gpGVAXtCzm1Z0Q5X4z6v5j22b8RNOybLgGQR4cj4E0gyUvHRDjQatRJ6eJkogis
	 M60DI8hp+TCJ7U97UXAudCIJOlpfOrFx1KwUTsMzHibGYaGi5IozQmXIMrg+/UkGA7gAR
	 olkp9nnkqQS570oHucSbdEBEx90a/fca1T4nGsNR9TIMLseG2KwsJmy5zEsnIT3nltq9w
	 X7gTGaWIo+UiLaIQ5jFNtL9TCRXdS1WnKROxXVx59YWaZLYiB6V7nPxY8A//wGNFb+eUI
	 tacJ8qRE/LCetqGFSCJneb5DUTvjB0yipx6LLfp9l6nL5QZqMh/1Ga/yR23RpUJ82Zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022369;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nrL2PNKL0iyAISW2ln+FnS2P+iE9Ftn2e3OJ0J2ODv4=;
	b=Xuh2xpSH6jNhS2jTdWMs8C5u0s16jyzAM7B9cgfkoiRUuDZCOPDD5TasERlvzIOqRSHM
	 hRbqMBKhrbjfBTk1GcMRz70h+c2Z2MLL6USe/DdVvHEQHiJM4DYPY0bEPfxgNczayh95H
	 AmeOmj+wT+cI5XN+2ADKJbRBXkDWcw+4vlDCrFOPRppEWfGbY4XrUroTQiTIHMJGi1RaO
	 KR83mC7KOv04kXFv3hRxDdgvc+QAikxHG1mUG/HwPy2Wf6mAf4lvHaaWp7nShcgsnhmeX
	 kiKGmufznqBGZAp1EacX+Rz/mryM2jD7Fqj8vZlge25RbnfZEzLtWIogv3Dl9HnGZdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0kb1z3+4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C9C606A31C;
	Wed, 18 Nov 2026 17:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0kb1z3+4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D87F81F000C4;
	Wed, 18 Nov 2026 17:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022369;
	bh=nrL2PNKL0iyAISW2ln+FnS2P+iE9Ftn2e3OJ0J2ODv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0kb1z3+49y6lYz2iw+L9ALPV+tQMrV8QSrmGgc4+AmqNoF14XJtVLrIYudGvVUQL8
	 Ab6BT3gDccX6vpN7kGtrWWMOpIdd9R5ewhDnb0Wmmft7RS5FC17qTa9LH1mohVudGV
	 p4Gu8G4Dsac8hSRjj+iAM1wdPcI6M2usiOHXNL40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kaloz <kaloz@kernel.org>,
	Joshua Kinard <linux@kumba.dev>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2638/2651] rtc: ds1685: arm the wake-up alarm at power-off only if an alarm is set
Date: Wed, 18 Nov 2026 16:04:38 +0100
Message-ID: <20261118150419.098377580@linuxfoundation.org>
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
index 5fc8e36b1abf8..94c89333c5d5c 100644
--- a/drivers/rtc/rtc-ds1685.c
+++ b/drivers/rtc/rtc-ds1685.c
@@ -1367,7 +1367,7 @@ module_platform_driver(ds1685_rtc_driver);
 void __noreturn
 ds1685_rtc_poweroff(struct platform_device *pdev)
 {
-	u8 ctrla, ctrl4a, ctrl4b;
+	u8 ctrla, ctrlb, ctrl4a, ctrl4b;
 	struct ds1685_priv *rtc;
 
 	/* Check for valid RTC data, else, spin forever. */
@@ -1394,6 +1394,8 @@ ds1685_rtc_poweroff(struct platform_device *pdev)
 		ctrla &= ~(RTC_CTRL_A_DV2);
 		rtc->write(rtc, RTC_CTRL_A, ctrla);
 
+		ctrlb = rtc->read(rtc, RTC_CTRL_B);
+
 		/*
 		 * Read Control 4A and check the status of the auxillary
 		 * battery.  This must be present and working (VRT2 = 1)
@@ -1408,13 +1410,17 @@ ds1685_rtc_poweroff(struct platform_device *pdev)
 
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



