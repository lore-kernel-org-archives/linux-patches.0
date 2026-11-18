Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040595;
	b=VytLBQpDV6CpdR2jVsNcjoetyxMVSTcI4HDLl2Tvou0QfOfeBA3Nv2BQ1dQmTGM0g7Pg
	 i3xR+T9njHHvq5eF9XeVEQsxHnBFcT+Tuwy7/ilU4a+TCPQNuLFa0eVUahCyrIyDSsFD2
	 rY1fJmOP4J4m5HdaHQ7x9Pu8KznDgq0vUPQbmNm2/K7s16bonIFJRrkqWDSU7hf/0Mjs1
	 aYitf8omWLeyYXRtSns7e1sG6FjajjjWNCgMaqHNO4Zr7sUd5obLjpANXKVPsyhN5teSd
	 i5XtOs7ee/5ChxMz4P0K4jSa3t5G8f0Aa5DeYtdW/zphGsmrusX90bSb74EuGgbBjPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040595;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=jGnECW5XxDno7kYd7VD4mm+3kNFukgZk8PLji8PUzQs=;
	b=0RduZPfdhbBVBYT2Ww1A3S8DX3nJWVXb1Ea69cLz2vjGhiFQ836TjGlReEku99u84uyP
	 cTLQbdvA30Sl8b7wU5tYBmhwPSJ40Ndo1YfmDNX3KaLnjxhNgMrwwx6zIlHFnmi+M1Ibw
	 w4a4PoRuN8JPVSVKtfZEDhT+XEI1dRqGkOuyPyjsb2APO9kMU1KdMBi/F94fkIorvIA2p
	 H6+4sXBTOdoJaddgINKYOVECy2ccpZwBxcb2MXUVqkHHDE+41RQPdqLIC24Cf6DAdkn67
	 NKv0Cc3E45QJsiLttGeXPdARUz+X74TmxDAMq7hAD8K2LbN3P8sIFFSA0gNw8hLquWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z4ktaMrB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8E5606A320;
	Wed, 18 Nov 2026 22:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z4ktaMrB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DD521F000C4;
	Wed, 18 Nov 2026 22:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040595;
	bh=jGnECW5XxDno7kYd7VD4mm+3kNFukgZk8PLji8PUzQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z4ktaMrB6zhOJ4BPAmO3AAz4+qnKo/PUZvQX+3P+MoC3N0Ui51/en3DwpQlmv6/gZ
	 LlKyUvzDSa+uWk0ebY7OuoGtZyjTHqzMV8knNevvFBXzdrbpR6vAlrKqXzEJC3wtWq
	 4Fb/C56WON+L5Vr4qePyjJgjS28uCdjCQg1bxD28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Dalin <liudalin@kylinsec.com.cn>,
	Linus Walleij <linusw@kernel.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2514/3318] rtc: ftrtc010: fix integer overflow in time calculation
Date: Wed, 18 Nov 2026 15:52:16 +0100
Message-ID: <20261118150436.799446743@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index fb66228039b8b..29c2441c5927e 100644
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



