Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018204;
	b=YcJiq/ysqQ3wMlD95J1aD/0f3q1H1vKuj4JQqb38LYlIEMU+yvq68UJJxbMttFyMfqbG
	 zKAXS3PhemIOheks9rHDZIMXSdvSs4p+bVcZ3A1JGFu4b9uls2doYd7fY/ArWvhLgdHk4
	 IJhrr43j67sT0x05Y7ojLw+L4xxAkyvWgfwLCzxGbNtKJutrobUGktkyD4Vpz0Qptm3mv
	 xBD61IrYTeUZqTZSFjaMaHwUjKi1S+Gu6lrHvaH4fSULKoPFsUC5BdtJ9PtFPedCk73KI
	 GU8YALJvS2XehQRhAU2Rw9aD/ucX0Bj40fLj8IempKnnHtNAIme35s3me9fGp2JyRog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018204;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=DdHQMHQKIkDAcAogmgQc2rDhgA7xepeVsHhTSCI+/M8=;
	b=Q2uuulORNjOPIoNggR59zi41Gc6tt2fupL7MTD44UFirIKYdUmeXCVlMnjMjVMM32kli
	 dztOWbXRfnlYPJ+QpozID5hQhP3Gle7aqa0PRhESamZbq0qDLP+yWCrWJMo00mDoSKYLY
	 v0o4PxJOsLiD7eJsuZG3BoIa7c6FiQZielRYCAzFMVEI2qEjZqqZMHQwRA9VfxBGy+wBd
	 NJiHufhyRd4JK0JQtsqY+kVWDzpggQcRfiFdbEZLjIMk75rXFuudCxhrbB/wbQniCl7v6
	 cAkPtbU6sNUWr3xF5CnDufQaxl7jRTZsZI8OrH2QbaGj2ldq/xeYeTFs8GKwJ+1w72Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WKFfxMjD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC093606A33F;
	Wed, 18 Nov 2026 16:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WKFfxMjD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37D441F000C4;
	Wed, 18 Nov 2026 16:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018204;
	bh=DdHQMHQKIkDAcAogmgQc2rDhgA7xepeVsHhTSCI+/M8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WKFfxMjDI1rFX1jRHpsdMTwYKhrzRJAturSauBquWo2dVP/3Rvm5wD3mSzDXFO4lK
	 63E9HcdS31wExXO4Ev5f1zXzYtC0EWUU0iUnpQwXUzk1N2LUPXDu2/gL50W8fp2fpB
	 MS8vLydR8reuoG+dv/D/T5pZGQM9KcbBLIlf9FaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Dalin <liudalin@kylinsec.com.cn>,
	Linus Walleij <linusw@kernel.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1157/2651] rtc: ftrtc010: fix integer overflow in time calculation
Date: Wed, 18 Nov 2026 15:39:57 +0100
Message-ID: <20261118150329.664414647@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 19e6333bfbab8..b29c96be40f4a 100644
--- a/drivers/rtc/rtc-ftrtc010.c
+++ b/drivers/rtc/rtc-ftrtc010.c
@@ -72,7 +72,7 @@ static int ftrtc010_rtc_read_time(struct device *dev, struct rtc_time *tm)
 	days = readl(rtc->rtc_base + FTRTC010_RTC_DAYS);
 	offset = readl(rtc->rtc_base + FTRTC010_RTC_RECORD);
 
-	time = offset + days * 86400 + hour * 3600 + min * 60 + sec;
+	time = (timeu64_t)(offset + days * 86400 + hour * 3600 + min * 60 + sec);
 
 	rtc_time64_to_tm(time, tm);
 
@@ -92,7 +92,8 @@ static int ftrtc010_rtc_set_time(struct device *dev, struct rtc_time *tm)
 	hour = readl(rtc->rtc_base + FTRTC010_RTC_HOUR);
 	day = readl(rtc->rtc_base + FTRTC010_RTC_DAYS);
 
-	offset = time - (day * 86400 + hour * 3600 + min * 60 + sec);
+	offset = time - ((timeu64_t)day * 86400 + (timeu64_t)hour * 3600 +
+			 (timeu64_t)min * 60 + (timeu64_t)sec);
 
 	writel(offset, rtc->rtc_base + FTRTC010_RTC_RECORD);
 	writel(0x01, rtc->rtc_base + FTRTC010_RTC_CR);
-- 
2.53.0



