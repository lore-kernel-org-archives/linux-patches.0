Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062271;
	b=FwUOcHCcKhKw/Ocmz7ffV8YkEOewaHcI0BBA8ElqRztqZWJObRhMIZ07rj6t9pntYaMx
	 1qn3p/eJwvRXtF9pbhBdp64XRERIyx70X53MsnYGos6Ye7bnvWFraxB9KttayGGGmj86w
	 EG7022C8BzxQ/4dDZz1nSXqxuzV3Jnsrai0xx+j13WqMQl7radx950ZGOj2yxG9drVnAS
	 ukdou24f9JErJ5xR6DJTs0NcAzdSGNaA2FrrfdXIHInopIXx4Lkhz+OfLKwZvYSk/x0K9
	 zY0PzK8I8xe3YRFn65S3CCiw85VnTgfoXTdvgViSkkZJffEc7R3qtCCoQJHJWSknkIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062271;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qgsdHsuJyOfDmGw5n3d0NIN8e0RFty5QNWlrG7MTW0Y=;
	b=G6tnJ2lfuatgrB5G1DAbbFiHUBsdIDszKCsxShKoFb9SSzd+92SnGYtm6qd4MCSWN9Xl
	 39K4t/oIi1PPVvdch1vcukHYpJDuwchz4VpBzr7hCNpo4ux+K6tExhfRbLZtKkFAygeD7
	 DBW6htwbVLR0Jv94ASf/OwhWW9YnjNlsMW5yUhE374kMf1XN4nD1D58qXkdRv1GnyJL0z
	 b2LJ8195K6sWznJz+GDLnhs7n/QOSZi1c2XRvm1TE/uCOT/r/p+t3vgWyVkt7qpyEDB5S
	 bEhRCBBVtjPOa1kC2WdzQT7dr+cW6jKGkjWmX7Waw1uPZsFkdP12NEb7cAGsN6OdJ+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fyt5xlNd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C60FE606A32C;
	Thu, 19 Nov 2026 04:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fyt5xlNd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 272461F000C4;
	Thu, 19 Nov 2026 04:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062271;
	bh=qgsdHsuJyOfDmGw5n3d0NIN8e0RFty5QNWlrG7MTW0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fyt5xlNdcACkdd1P0fZBxljh0kJjyrVyreJt4LQHA0+rQX2LkyfEEWhgCbHTIz1sF
	 XuYWjsq+PgCEKk8PQ9rKNOOc23Pshqcm1S3LQbn6Dtv5c6JcVeZT01NAyHo94tu7Pq
	 zqBRzV2d8dz2K4bmT0GPwq8bwK8KyiWMAYJSKOzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kaloz <kaloz@kernel.org>,
	Joshua Kinard <linux@kumba.dev>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1822/1848] rtc: ds1685: arm the wake-up alarm at power-off only if an alarm is set
Date: Wed, 18 Nov 2026 16:04:20 +0100
Message-ID: <20261118150035.961960558@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 98932ab0fcaba..a2a8959f13b42 100644
--- a/drivers/rtc/rtc-ds1685.c
+++ b/drivers/rtc/rtc-ds1685.c
@@ -1379,7 +1379,7 @@ module_platform_driver(ds1685_rtc_driver);
 void __noreturn
 ds1685_rtc_poweroff(struct platform_device *pdev)
 {
-	u8 ctrla, ctrl4a, ctrl4b;
+	u8 ctrla, ctrlb, ctrl4a, ctrl4b;
 	struct ds1685_priv *rtc;
 
 	/* Check for valid RTC data, else, spin forever. */
@@ -1406,6 +1406,8 @@ ds1685_rtc_poweroff(struct platform_device *pdev)
 		ctrla &= ~(RTC_CTRL_A_DV2);
 		rtc->write(rtc, RTC_CTRL_A, ctrla);
 
+		ctrlb = rtc->read(rtc, RTC_CTRL_B);
+
 		/*
 		 * Read Control 4A and check the status of the auxillary
 		 * battery.  This must be present and working (VRT2 = 1)
@@ -1420,13 +1422,17 @@ ds1685_rtc_poweroff(struct platform_device *pdev)
 
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



