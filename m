Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050792;
	b=Nj7jjBILlrMWuncaVi8RA2FcypIOji2rJxcHs5Lajkh2Okcn/ZLYSxnvICAykLTzTX5f
	 oVjXYYPXS7t65lDtOzBeAy5cCp57vvQA5j2hkw/JaVW7+rDa0BEV3bz8Sd+t3riFBiwCI
	 92K4MQauLOS6qk4CnksQLV30bJx7ZRfDQGQNiBz5g9UKa+fAOr0m8oxHAdF3QTTMC+ImO
	 KHTUOFwDY3GXyU+5IRzz8XPcry5u+Ao+yXjCMb1pnXSeataN0tLCr9d2IX0D73XuFOOoQ
	 LcizjIUQinpnOAonMcvn0v5YarRXCwWLskNry7yCy/qiYm3Lw1Bgh9XdC19VEG4CGtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050792;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q32kPBpo93777xVDzmdY/PwT245VKh5sVjaixRBSn7E=;
	b=nEGpYLLDF0072MiyjGVtTIZ8jkFzsQVugBx857Xcg5+Wr/O1mSI6MvHiFnDP352NkNTC
	 PO1rYIpJTqkkfkXpwighVyv3JiFyn1XHZDUa/IcQTp2RJsuTKtb3A5MhM721sTzN5RFv8
	 yOilD3lNdhOYCbMKo8xm6QE0+f+g8x+RbG4qVjlfFyWnZnexchh6cDpD2/pOfROBNJ5eq
	 CxjMfHduJTT/9pW3fs5OGQSaiNjOUOBWKrMKQJ8Wn6+OzI+Q6RBavkIcWaujUATLai59s
	 T9kcQUad27xS1eogNPEpesVdMbRBv3RgLBx/dORk/5DjJ3o8DJvP1zBJRC0NOSV0PEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VsF8Ku3V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02E64606A31C;
	Thu, 19 Nov 2026 01:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VsF8Ku3V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 536261F000C5;
	Thu, 19 Nov 2026 01:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050791;
	bh=q32kPBpo93777xVDzmdY/PwT245VKh5sVjaixRBSn7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VsF8Ku3VxoyU+WIm8cJRPrKIJtYFGG66eyZnlIr3sWoiwI7dheFk+Ct5jSX7N4LEZ
	 8uMn97fVGMhxyHcbliWzf3FcwLfEPaGgsH92xTQODzv2O8HEkHpDpQNiJIaSTDH7FN
	 V2Xnglqz76UyZ3qIafsbppvp4kF31z6rd9X2P+28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kaloz <kaloz@kernel.org>,
	Joshua Kinard <linux@kumba.dev>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2833/2857] rtc: ds1685: arm the wake-up alarm at power-off only if an alarm is set
Date: Wed, 18 Nov 2026 16:04:27 +0100
Message-ID: <20261118150343.584486193@linuxfoundation.org>
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
index db7216f14164e..e9607eeeb349d 100644
--- a/drivers/rtc/rtc-ds1685.c
+++ b/drivers/rtc/rtc-ds1685.c
@@ -1372,7 +1372,7 @@ module_platform_driver(ds1685_rtc_driver);
 void __noreturn
 ds1685_rtc_poweroff(struct platform_device *pdev)
 {
-	u8 ctrla, ctrl4a, ctrl4b;
+	u8 ctrla, ctrlb, ctrl4a, ctrl4b;
 	struct ds1685_priv *rtc;
 
 	/* Check for valid RTC data, else, spin forever. */
@@ -1399,6 +1399,8 @@ ds1685_rtc_poweroff(struct platform_device *pdev)
 		ctrla &= ~(RTC_CTRL_A_DV2);
 		rtc->write(rtc, RTC_CTRL_A, ctrla);
 
+		ctrlb = rtc->read(rtc, RTC_CTRL_B);
+
 		/*
 		 * Read Control 4A and check the status of the auxillary
 		 * battery.  This must be present and working (VRT2 = 1)
@@ -1413,13 +1415,17 @@ ds1685_rtc_poweroff(struct platform_device *pdev)
 
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



