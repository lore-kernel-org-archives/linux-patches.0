Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027473;
	b=Rdc5nD8ius3LTHaV2gOkwhWFjZ7wtewmLZrP6AShEKhpGJy73Mw3XuYE+aOhR0m5Zan4
	 WIOKInticuMLJ3J0Qjl2/eLZaHFAUiLYXFYFU5RssxxhV5PzkxpPwFo01Ddb4ecZnGMsV
	 aDEVztDxf+csE9cQ9ylxYrwBN/oIA7UUSuttYS4PjRMBjsLfcubXPcln61iuCTdEpeBq/
	 LsVZr7u8v6IRm4PswUC0cCAHU1wButjXL37ur2rpgipOLcIsWYAGHvpJM+/xRpSOo+yK3
	 cusJzIzNkTK1MJxxJbBI052jcho8ZCUapbK4s1NqJOF8nh5+NA8YvZqMe7C6rLuyzpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027473;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cgUu+Qevvv8nFLjt6U+aGsF+h1PaDWPp+uFTN9nOXz8=;
	b=hxycM5lWrEuZob+5o3FAHfpn2jN8YZEIxDvjEYavxxTzGvNetUIsQKAjn96S66f8nZ7V
	 wpBh8zOooTom5RBhiDbt2AnSPqAIATwDaJbpKUS3dxyWBYC8TaCu/sYoUetZpebEhmVaC
	 rq5Mk+onLV8684qRLw4TyYqcqTZ63RjYd1uFTzQCWT3iBtLrWuAl+2WIGMGPvDDWAO5nS
	 imXo7RkEKLhUPwBh94SnU7VxYXDRH32++7WC/vLW4IVVsLNM0oVu+t4ZZ/syILefaPfXZ
	 qsGLgnE55hV/y93k1A2+fsUqwy/d76+MKNzPCYn8NSr5OTQoVQHAokU7zBcDMcFchzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=moMuOa2A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 390F4606A33E;
	Wed, 18 Nov 2026 18:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=moMuOa2A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 906461F000C4;
	Wed, 18 Nov 2026 18:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027473;
	bh=cgUu+Qevvv8nFLjt6U+aGsF+h1PaDWPp+uFTN9nOXz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=moMuOa2A67y1hcoy0YAspoSZXRlwdhHx/Kz695+tbQdmROFlwn3kXDdKSNPMcibaX
	 lxpSFrQcCIx6HGtJacmry0TEPbi0JYNm0v7z8qnwl/31nwsonEyV1pL7TMzV2IGIPP
	 d5GtDKlEdMAeP9UCnhcSCzd0K0vm5Hrptv9b6PMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Baek Kyu, Kim" <pocj8ur4in@gmail.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1802/2151] rtc: mpfs: Fix alarm register word order
Date: Wed, 18 Nov 2026 15:58:57 +0100
Message-ID: <20261118150227.449112020@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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



