Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050244;
	b=OEJG4mEpvFsOmP8kMczBrJXyfwRzhWhRBwmd/UZtczO2KOne9X/jCu9nKBxsyTRwxWPO
	 VHAr5husmLo/s/bVxW47I4CEWWT4OqAjj3ffT+BkquX1FTNm0B/gKng7BGkT+PXzvDujZ
	 03wPeKS6q8FiPf/EdLjzM84nBrP+qWTB5qE4R2F9L/Vn+CY5t0gswmjpjUAV7DPHXjMLh
	 qqa9CCs/oDFTu5RsXT0RY2Ob6Yb5aHQCWt6Sao0pzIxZaemymCAz3erLYvoLTgCtV5b1T
	 x/bZumRS+yOMFcAagTTMxXs7lbxjWNAn0I79Bh0yiB5gfgjFRPDyMjwvWKBEszGnkEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050244;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aj5/B6i6U3CyGGL6bIpKoz22M1oPO5ejRPLSqyFp23M=;
	b=g6cCSZdgXlQ36cOStlKBs0rUTNnfAwux5ysYwQkbTbBHJqc182hbMDefEeNdLwdJeTJD
	 ZxKtPXuviL8hmApqR5jjjQGO9aoPVDP5mSJrldu5s7U7RICF2AHj4WQp7SdIjHT1N1u4W
	 ZQId8oLmDnF201y4pBXN5pjzRLLJtC5J2g6sbEU8ITSOU4V86Xnr6FPIuvHH+E1ppM1Nk
	 nT1eNltkFi6IJnX3CxsoxSEa05Mcy85YQy2XYuQp5JZ5QATxdSkDj86wTBuJqTBz7T4X/
	 +ZwZ58Sq1eXBQPMUKA91Os5GABARssMenKBxM4+kH//n2vAzXyKaFC1K9byUQsK8Ncg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o15Iz66d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A248606A31C;
	Thu, 19 Nov 2026 01:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o15Iz66d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA211F000C4;
	Thu, 19 Nov 2026 01:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050244;
	bh=aj5/B6i6U3CyGGL6bIpKoz22M1oPO5ejRPLSqyFp23M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o15Iz66dfaahCOOkWdpzzg9r0WSCFIANiAhmx8Mc+zdXH1KbXFU++JiPEEOGS6uIZ
	 qhLRNWlf1mzmAAfS7qjUjCrlu9ZqT3QqsAjt+C8AWuyN41WVRuAnUoHMbw4vKwW+bu
	 rWHYiECd9nFCsSw0ltBDvu0Q+AbZapqvA5KVOZ8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Baek Kyu, Kim" <pocj8ur4in@gmail.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2640/2857] rtc: mpfs: Fix alarm register word order
Date: Wed, 18 Nov 2026 16:01:14 +0100
Message-ID: <20261118150336.648322730@linuxfoundation.org>
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

From: Baek Kyu, Kim <pocj8ur4in@gmail.com>

[ Upstream commit d691a96370b6cd7e684e4da1c473c09df963611b ]

mpfs_rtc_readalarm() swaps the low and high words of the alarm time.
The RTC core reads this value during device registration to initialize
its alarm timer. This can populate the cached alarm and timer queue
with an incorrect expiry time, or leave an enabled hardware alarm out
of the timer queue if the decoded time appears to be in the past.

Read the low 32 bits from ALARM_LOWER_REG and place the masked high
11 bits from ALARM_UPPER_REG in bits 42:32. This matches the layout
used by mpfs_rtc_setalarm() and the low/high assembly in
mpfs_rtc_readtime(), so the RTC core imports the programmed alarm
time correctly during device registration.

Fixes: 0b31d703598d ("rtc: Add driver for Microchip PolarFire SoC")
Signed-off-by: Baek Kyu, Kim <pocj8ur4in@gmail.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://patch.msgid.link/20261019151024.2232338-1-pocj8ur4in@gmail.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-mpfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-mpfs.c b/drivers/rtc/rtc-mpfs.c
index e530b7868f999..5df44eaad24d0 100644
--- a/drivers/rtc/rtc-mpfs.c
+++ b/drivers/rtc/rtc-mpfs.c
@@ -131,8 +131,8 @@ static int mpfs_rtc_readalarm(struct device *dev, struct rtc_wkalrm *alrm)
 
 	alrm->enabled = mode & MODE_WAKE_EN;
 
-	time = (u64)readl(rtcdev->base + ALARM_LOWER_REG) << 32;
-	time |= (readl(rtcdev->base + ALARM_UPPER_REG) & ALARM_UPPER_MASK);
+	time = readl(rtcdev->base + ALARM_LOWER_REG);
+	time |= ((u64)readl(rtcdev->base + ALARM_UPPER_REG) & ALARM_UPPER_MASK) << 32;
 	rtc_time64_to_tm(time, &alrm->time);
 
 	return 0;
-- 
2.53.0



