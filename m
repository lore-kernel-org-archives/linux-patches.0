Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032486;
	b=HZ/rUDoim/r0QPA+Rv2A46vAZ1ou5EyqqH5tKv5wgfqvPqU6VlWl1LDq6U6t4q6yxF8y
	 4ITyBJ8DiQzGxRnoW78tA2QdRzIVil1adRpqqpmC5diO4Ttloji1bb21FnRIRvE6zpPY8
	 Y6izk+rTcVpmwwYbR3ZVRERW/ndMB03qYS7U1QTH9u+gqoSQorc2ibbLEv0mrPDOaSew2
	 SQMKc3/ZKNbQG3ixMhASYX2I4CGCyyQXhSsbIeqbjyBwVHdxEKRNF6i6Oj19jTh1UWBzD
	 OGn+i23KHB3J+DL4ulYO8TZS/CFsNtpd0EJUV4REywOPELUYKp4mOmoLxfU2SBaG5BA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032486;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EKYJLjKrilLE4IE8+lKvWrKtJwirQGe8Gx3zSLwiy6s=;
	b=SI6RK+OJ6kDpxbDY/hamPtjrEya5B8J8AMBk8wL30lvnqm5DxdYVltSkqDp6lfOkVRkS
	 8q9JvfsWPKGU8e433SbbNp3M0Cbxg1RXbT02HK3HsSBuvG3u0na2Qpsa9vv0o/29q9D8S
	 w19AONMQM8MrGNHZNUqqSjb4Y5eYv3bl9mNuXdWQJTCxBYhLL2WpjNRb+svk8CzJ1azxW
	 v2O+gOXObVqRJ/Dh6uSE1So04hzdZa7UMZrGa3a3Jcwe5xc3TfDYHIVYwrLcw+EPhz6sw
	 G+adT3DhTiYtJiaPIak0IYucgyFV8UMEGW+vG61Yd+wztCK5rEZ9U3n4CchQngDuFNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LYuJrccR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA25A606A84B;
	Wed, 18 Nov 2026 20:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LYuJrccR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37F8D1F000C4;
	Wed, 18 Nov 2026 20:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032486;
	bh=EKYJLjKrilLE4IE8+lKvWrKtJwirQGe8Gx3zSLwiy6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LYuJrccRvrQQnkMarjlobcszDerwvo9PpY7+4mHcAXDCWwqSV3NpQTjCuXEnHQdFp
	 ec+YwnKROVy2SRyGhWZ7fBxeQaP1x2vLaYmee9m+ank8yP/MyRg11EXJFnzkzjUarT
	 pNUD8O4prSPOqbQrUW/OIVJRR9NKpu+3uShUPyzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Baek Kyu, Kim" <pocj8ur4in@gmail.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1430/1756] rtc: mpfs: Fix alarm register word order
Date: Wed, 18 Nov 2026 15:59:17 +0100
Message-ID: <20261118150106.125992511@linuxfoundation.org>
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
index 119f37386eb5c..fba23547b94da 100644
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



