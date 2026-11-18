Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042138;
	b=5VRKT1JvrjSd4wWD8aM2S1DQaXOFzPGq5pmdl3iWZili7PZs9UFY8cPhtNHi6XlPxcGH
	 uKiereEQWzCkjnipjFu4kGOdKFTXN333mCEVKsbtngXi6zGdJfFKTz9mTFGxfHHSQPk5M
	 C4M/qy4KvRIHBS799cm5Y6WUOqGwkrdHP3CZmIZd4sqRyVIADJtH+TeYSd+YSW4s4P45U
	 19BVS/xm/2i71Cqse6J/J111l+TxztKzst5rDVWVtHql0Yn0onjxhQNK4xbt/2GKNSm+L
	 fNg45Yzi9BEn2GmNOJsu2l77n5kvqCVjDH20CYJwISwqQ0u6GfeOtsm+eNJnmxP3W9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042138;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Sp0/tD4hDjdyAE81zrPeK0YZswJcA1h8jPNWjOAcEaY=;
	b=O16oUnlV92GFCL9/FgF5HuqnVC3ySjnV/yvE7Cwm8mvdU6TVH7WH3ZhknfF8gLFNnD3N
	 Fg1LLSq89yrjJVNLIGS5NW2mr5kWAcbEtM90capC8pUmtHZgEY27l6+tU9yzGE/cmprmi
	 o1FDpv9X1EmrkeQP5WY9N0mo7sAeQOV3YTff7tfiPh33PxV0o0rgNBz0CxsdSoVmPUMf+
	 /COIl52nMO8VUJDSClehApBpkysYkz/xNnu5L8mDAL9nt28eDaWwflDZSzL9w3MqxdiYz
	 IkMAf8zbWySq1fv8l/hcT+m/nxQqyADrSmyedFeZ0zUFgZW3fkM7CVmzEJRhosbhNKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XlrmPwhe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 589B7606A320;
	Wed, 18 Nov 2026 22:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XlrmPwhe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADBC91F000C4;
	Wed, 18 Nov 2026 22:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042138;
	bh=Sp0/tD4hDjdyAE81zrPeK0YZswJcA1h8jPNWjOAcEaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XlrmPwheCnYEn8IN5aDNJQVgtkLL3ho+IisXlG4Qd6nP2bLoHgrPSRHA0DtQPnNVU
	 bbFtcfJIrppNEQDc+s4L2darkm/z7HfXHrMUQ8c5XCDIpILapeJd8wnhfHy8koa+0n
	 mnlnyCqd3azmw5/PlhueUchgiZwCEoWCqoZnvwkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Baek Kyu, Kim" <pocj8ur4in@gmail.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3062/3318] rtc: mpfs: Fix alarm register word order
Date: Wed, 18 Nov 2026 16:01:24 +0100
Message-ID: <20261118150451.983021310@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8335e8c7357e9..783a7246876ad 100644
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



