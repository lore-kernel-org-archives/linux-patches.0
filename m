Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061114;
	b=T98Z+DF30M8uAjswHbXomPDv0GE3bj8cf3JL2aoWOhZA3eOfj3OVXgfD2lNthJXJLv3c
	 9xXtxn7sxlzgWPfIH8heRP/OvAOJwBMMGpszPI+9s+8q2huAXG1xVeoNCNwxQPNYXgWGW
	 Fy2r6N3rL+8muJyrhhuGsd+AInADO9utTbES6UQ+eRBuanSwzg0ulL/kDlHz37thO0RGQ
	 Aug0NiO6fSnUBerHMNnD/nkkz5EMCEwjyuYc9K1z+l36HAIRenMqFE5l0lNLF+TzkfGpe
	 nyEzbECjN2P5zhfhOyQ/kFug4OL6BZlRnzFwaqRxuCrkSnzxV8i0yDvAtqBE7sX8H9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061114;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=vs03wnNHLKmxJ2MmTSUKuvtgHh8oUwpJZ4RaGPmQQNE=;
	b=yNsLbd7FkOkeqLgqaSl9GeBcDDEDqZUlsXxlyx0M+ozyYEGtliyqlGVsd9FGCXkuNzrR
	 9u3hdmY0LYEq3X+AvvaVJenkk/M5lOH9zaCpsfy9EZhAM4+ClAHOx9SQ5Kt1fg/aIM+QO
	 X70GkKhuYC7yPPcdBriiAUCq5ntKlffrs6QUnTDqXh7rjDcCR26pgaCnxhIV2t5XkJsgr
	 Ju2Mcvsvq3qHiM7/Sd/L8LMKkanVJFja6bZIp4/+dhh8TPIaMOyIxpc8oYqFFDQw55HuR
	 OVZQR0rqQctdqjSQ3bZCBHAqQScse8EqqouNqjCYPbO6Tghlp1cn46qxLP7zqHzEW3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q4b51CUE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00412606A32A;
	Thu, 19 Nov 2026 04:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q4b51CUE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 547EA1F000C5;
	Thu, 19 Nov 2026 04:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061113;
	bh=vs03wnNHLKmxJ2MmTSUKuvtgHh8oUwpJZ4RaGPmQQNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q4b51CUEeavzDRdfCLdVSIQuXcScwNwE/kgSF1In0pGcuftmA8gwoYqeAN6oaqffK
	 7itzPkpPKMnpQp/jtopUvp/XpVPHUJYB2pLYk2AnS5pYgD2capiNhfjaaLPxuzeJJ0
	 aokpLgBwO7kyqQLjin1T3kKC6nVOJGK7n5AWgHJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Dalin <liudalin@kylinsec.com.cn>,
	Linus Walleij <linusw@kernel.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1437/1848] rtc: ftrtc010: fix integer overflow in time calculation
Date: Wed, 18 Nov 2026 15:57:55 +0100
Message-ID: <20261118150019.653880835@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 0919f7dc94a34..8f63dcfbba378 100644
--- a/drivers/rtc/rtc-ftrtc010.c
+++ b/drivers/rtc/rtc-ftrtc010.c
@@ -74,7 +74,7 @@ static int ftrtc010_rtc_read_time(struct device *dev, struct rtc_time *tm)
 	days = readl(rtc->rtc_base + FTRTC010_RTC_DAYS);
 	offset = readl(rtc->rtc_base + FTRTC010_RTC_RECORD);
 
-	time = offset + days * 86400 + hour * 3600 + min * 60 + sec;
+	time = (timeu64_t)(offset + days * 86400 + hour * 3600 + min * 60 + sec);
 
 	rtc_time64_to_tm(time, tm);
 
@@ -94,7 +94,8 @@ static int ftrtc010_rtc_set_time(struct device *dev, struct rtc_time *tm)
 	hour = readl(rtc->rtc_base + FTRTC010_RTC_HOUR);
 	day = readl(rtc->rtc_base + FTRTC010_RTC_DAYS);
 
-	offset = time - (day * 86400 + hour * 3600 + min * 60 + sec);
+	offset = time - ((timeu64_t)day * 86400 + (timeu64_t)hour * 3600 +
+			 (timeu64_t)min * 60 + (timeu64_t)sec);
 
 	writel(offset, rtc->rtc_base + FTRTC010_RTC_RECORD);
 	writel(0x01, rtc->rtc_base + FTRTC010_RTC_CR);
-- 
2.53.0



