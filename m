Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025119;
	b=K5rJ4XGz6XvmyOtgk0l734I1EgPtZm7j+r97njLCT4i6yq87YtYgSG9uty2pbEJaNwrI
	 aUtu5hwKP7Hu9MlG/zlfYPXt7QWFzjjTtBcLC4ARI/pCG0C8qqBRvO2CEADQxZTWmCJKp
	 B42Gd2ucthueMQ1kez5FvLLbF3yA8in9nc0VWx2rB2KjZpB7XAR8RyQfAB4JbPC1iKzsm
	 9f8ftuijrwyQ4COF8vXNUXsNQ6dCw240mRG2HbGeSrbl869onR880Cn0EaUItiVR4KueI
	 BmQn9u/j4EYB5su0jmg1PBoCyQqy9gTLqnERjULumqFu8rHkD0FvUuM7QnFxeM1bKmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025119;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=9CAtr5YdDc2pLWKcfVwbneAGcmv+nxuXQY0Ki6O6bqo=;
	b=LJV1qQ7F9dNgb99hb1WjD1SJv4WyQQ83epgrahJGg3CktCBh0igE3+nvLBA2Q3eD5g9e
	 vMdE34J7FiXSw7kKlYAVJ6ZvGw+ils6NcW5c6xahVKbSLUMH/Qt5whUng6CJlAdBA+EF4
	 QA5aZNqd8X4xLWICvAeKCs1WLmfU45rOIEuf70NV+wSFcnNHy2dg7tQ6u6SXAgzgnGBx+
	 4WDojmiGyakDofMz0RpUzSjdVNIEEOMC3jeGFZCumrtbjlvjfkciMahG/tkJoPPu9Rf1X
	 CHGs+3Nilijn+B7QFCPsqUZF+5M02dywBQk+3CTWshqqdS/CSt+sEQHxGbbjdEX3Zmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JzL7ddKT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24DF4606A339;
	Wed, 18 Nov 2026 18:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JzL7ddKT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5422C1F000C4;
	Wed, 18 Nov 2026 18:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025118;
	bh=9CAtr5YdDc2pLWKcfVwbneAGcmv+nxuXQY0Ki6O6bqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JzL7ddKTBjWrPgv/0Wddi1E0oTFM2CzgB9NKxvhh3SRjFqdWZFdxnqtlH/4bSxtL+
	 DQCF9Qvskv6ffbUhZHZ3FRRh+Qn914PR22IAvKSBfbPFxeiWV3+3dokHNv/BpGAFbI
	 S9j5bJ7UH7cQ01aajQlf1yAMvwJzzkktDFo5pT0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Dalin <liudalin@kylinsec.com.cn>,
	Linus Walleij <linusw@kernel.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0965/2151] rtc: ftrtc010: fix integer overflow in time calculation
Date: Wed, 18 Nov 2026 15:45:00 +0100
Message-ID: <20261118150157.666650707@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Dalin <liudalin@kylinsec.com.cn>

[ Upstream commit 32f04694fa87b8ac9fa58f9ceb2dc6cbc476e2a1 ]

In ftrtc010_rtc_read_time() and ftrtc010_rtc_set_time(), all
variables (offset, days, hour, min, sec) are u32. The expression
"days * 86400 + hour * 3600 + min * 60 + sec" is evaluated in
32-bit arithmetic, which silently wraps around for dates beyond
approximately year 2106 (U32_MAX / 86400 ≈ 49710 days).

In ftrtc010_rtc_read_time(), perform the addition in 32-bit
arithmetic first to preserve two's complement wrapping for negative
offsets, then cast the result to timeu64_t. In
ftrtc010_rtc_set_time(), cast individual u32 operands to timeu64_t
before multiplication to prevent overflow in the right-hand side
of the offset calculation.

Fixes: 1d61d2592c1f ("rtc: gemini/ftrtc010: rename driver and symbols")
Assisted-by: Sashiko AI [static analysis]
Signed-off-by: Liu Dalin <liudalin@kylinsec.com.cn>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Tested-by: Liu Dalin <liudalin@kylinsec.com.cn>
Link: https://patch.msgid.link/42C8FBD59AA34EA9+20260827080320.3351155-4-liudalin@kylinsec.com.cn
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-ftrtc010.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-ftrtc010.c b/drivers/rtc/rtc-ftrtc010.c
index 2f610a0fc6e9b..c989574b1fbc6 100644
--- a/drivers/rtc/rtc-ftrtc010.c
+++ b/drivers/rtc/rtc-ftrtc010.c
@@ -73,7 +73,7 @@ static int ftrtc010_rtc_read_time(struct device *dev, struct rtc_time *tm)
 	days = readl(rtc->rtc_base + FTRTC010_RTC_DAYS);
 	offset = readl(rtc->rtc_base + FTRTC010_RTC_RECORD);
 
-	time = offset + days * 86400 + hour * 3600 + min * 60 + sec;
+	time = (timeu64_t)(offset + days * 86400 + hour * 3600 + min * 60 + sec);
 
 	rtc_time64_to_tm(time, tm);
 
@@ -93,7 +93,8 @@ static int ftrtc010_rtc_set_time(struct device *dev, struct rtc_time *tm)
 	hour = readl(rtc->rtc_base + FTRTC010_RTC_HOUR);
 	day = readl(rtc->rtc_base + FTRTC010_RTC_DAYS);
 
-	offset = time - (day * 86400 + hour * 3600 + min * 60 + sec);
+	offset = time - ((timeu64_t)day * 86400 + (timeu64_t)hour * 3600 +
+			 (timeu64_t)min * 60 + (timeu64_t)sec);
 
 	writel(offset, rtc->rtc_base + FTRTC010_RTC_RECORD);
 	writel(0x01, rtc->rtc_base + FTRTC010_RTC_CR);
-- 
2.53.0



