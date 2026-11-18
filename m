Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021347;
	b=f+Ty8cI35OiAXvBCRDS20i+l9sw4YF8MT/4aGq6zWVW6utaOlWOVa8iirX4mtLbMv1sg
	 EyXUWt2AgElMnpoCAaC9XYCGtHyspOX+laepvqkvCGjcGL/ffCF5cvpPLn1bLUObL0AfU
	 kQq3rG5+7YHevIKi/GCzQXBTdIUmg8d+RAcYr51p/242aWFF5qy1oY0ajvlPAHzquqshV
	 o1q81wkeqh2xIQnut4aLBQF7xBLrBwBvCXCF77P3wbGQT71SGVD5F1/XFNpnCZtliP0uH
	 5ufylAZwQ3qm7C6aOqaBYfS7AyY2wLL2NPRmwKDCySohRRm8wBDrIRN3IxuQhZzuw7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021347;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I50jHlvl2gOdawAgRCVW7G5QpghqGevd9IgmBSN1es4=;
	b=hdFAPSIqfBSixW0sqqXPeecOfm/LJlGmVYLODMw1Yh7ZxG/b9a5Muo03cMATBaSK8V2X
	 dFKUPfuR7uf8nRU+eqdIB/vCM0uUS1dxEPQS4fe2mVp9F5gmSnsTlL6bGNEyZZ5WI4fOo
	 txAdb4tsKbaowdrq8d//+Jc9ESdSgHQ6csxvg4Ia1+z89L2VYncBNeovg9sLUh+L+ij1F
	 o7U1UZQnvrHdto5bkK7Z2Lya9kD8EWuD0zxE44II9Md5pcDqLJuFCfohn4u15w+k1AswB
	 tU0DhHIOtzwOHBF7+wn+q4A8m9YBBgUWnBgMmBWsWM7YJc68VyIP9uFGYGS15eVqn9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WtQVfV38;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98CF5606A31C;
	Wed, 18 Nov 2026 17:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WtQVfV38
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0A3D1F000C4;
	Wed, 18 Nov 2026 17:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021347;
	bh=I50jHlvl2gOdawAgRCVW7G5QpghqGevd9IgmBSN1es4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WtQVfV38Mjf0kHubWUe2CfFCBK9PVtuK/lirkqvOpc8UrMu1uUZU2YOta3xcVdIi+
	 ToLm/VpJg448BMTL/tk/NN5hMzt/0p/7T3tX1UGnDBC2J1E/Xg2CObOqmy1g30ws4/
	 0Q6/96YC+JfRasX3FZT3lkmUofFP6HpAsM/4oXFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Baek Kyu, Kim" <pocj8ur4in@gmail.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2234/2651] rtc: mpfs: Fix alarm register word order
Date: Wed, 18 Nov 2026 15:57:54 +0100
Message-ID: <20261118150405.942135991@linuxfoundation.org>
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
index 60596b0ea9d80..6616ca1f02c75 100644
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



