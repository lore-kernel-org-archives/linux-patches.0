Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018042;
	b=Fq8FxC88JwFrllreQRUv6eTrL8GqPNHrm4e2jq1oiiaO1u0WC/R+7lzjaYsIYK8vKTvn
	 Wj4CLv+rcpk+NO5RTTCfaHhrXN8ZdRmKCtQ7RhNJ4g5nhQ/enuUf4FTHpqABCaAqrRj0E
	 s+5Vt4BtbY/l46l9Md8Bh4gxWmkMkTWRAuDXvG5vKYZVSLPXJMV5t4F0akUzj5LmoUs+v
	 RP0090x0Ix9NiHb77OJI0ltYL3tezChEqDKrj3QtJCGtWODVgloDJqD0y7icyrIlYK0B+
	 qFb/FUe9xlmZPeK4wVvtDQvxZJexDqSovaDGAS6qyiia0RfsFZytVKVMhkmaluzKbIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018042;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pRoVAjh3ODPi9V7qbD1NkoWnxdYex3hDxnJwycXq1z4=;
	b=vMhOmWQT4RQTnQ/8Ouy/5grVIezRKDZVuvj/IBUfRj2l1bRTzJb4ORl/AAGsLslqKHzu
	 h6jpXIRtHH/O3LK80JLGrbMycpyX68ACdFWFhuJJbIXTgqtBk4GW68MQRVlTxgHNpI2r5
	 UzFS6zpTpUd+MbqxtobuHpMGp83wvahBDi05OVs8PIR8UtLeJVKj8ZO/I0os3csXuKwyk
	 8kC7gnKAQGksOwsLxnv/0UVuT01wKkSofxvKHDpN8x0niQa+Po05AM4R56pI6Y117/Swy
	 8BtHC4vNxiWexR6MKzYVBt6PjnM6FaFvtecgQ3SYJFTvCl4SYCYAHMufI65RtpXDUvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AS9+e5SL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34FE2606A320;
	Wed, 18 Nov 2026 16:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AS9+e5SL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67E551F000CD;
	Wed, 18 Nov 2026 16:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018042;
	bh=pRoVAjh3ODPi9V7qbD1NkoWnxdYex3hDxnJwycXq1z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AS9+e5SLCqTbjkdYBtE9n421F9dku1YtJcYFt2ODaFxRWt0iIMt/NLrR6VC7s0Rbx
	 S+Xyb4YdZOnol4bKVtPAZv61yy4uLM1GBdSpzOFT3CsF1JBCYunlGYxdyvQt3WBnC4
	 HorwrVRg3g23PZSFz3KN/zzsg9Q/8wf/5X44g07U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Dalin <liudalin@kylinsec.com.cn>,
	Linus Walleij <linusw@kernel.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1100/2651] rtc: ftrtc010: fix clock resource leak on probe failure
Date: Wed, 18 Nov 2026 15:39:00 +0100
Message-ID: <20261118150327.597612129@linuxfoundation.org>
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

From: Liu Dalin <liudalin@kylinsec.com.cn>

[ Upstream commit c60478875a445dee1206aad6285c18cd8c91f7f2 ]

When devm_rtc_register_device() fails, ftrtc010_rtc_probe() returns
the error directly without releasing clocks obtained via
clk_prepare_enable(). This leaks both extclk and pclk resources,
which may prevent subsequent probe attempts or module removal.

Capture the return value and jump to the error handling path to
properly release clocks via clk_disable_unprepare().

Fixes smatch warnings:
- drivers/rtc/rtc-ftrtc010.c:189 ftrtc010_rtc_probe() warn:
  'rtc->extclk' from clk_prepare_enable() not released on lines: 183.
- drivers/rtc/rtc-ftrtc010.c:189 ftrtc010_rtc_probe() warn:
  'rtc->pclk' from clk_prepare_enable() not released on lines: 183.

Fixes: fdcfd854333b ("rtc: rework rtc_register_device() resource management")
Assisted-by: smatch:2.0 [static analysis]
Signed-off-by: Liu Dalin <liudalin@kylinsec.com.cn>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Tested-by: Liu Dalin <liudalin@kylinsec.com.cn>
Link: https://patch.msgid.link/AC51B5F2C5FFEBB0+20260827080320.3351155-2-liudalin@kylinsec.com.cn
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-ftrtc010.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-ftrtc010.c b/drivers/rtc/rtc-ftrtc010.c
index 98fa0f5183035..512790bc3f2b5 100644
--- a/drivers/rtc/rtc-ftrtc010.c
+++ b/drivers/rtc/rtc-ftrtc010.c
@@ -180,7 +180,11 @@ static int ftrtc010_rtc_probe(struct platform_device *pdev)
 	if (unlikely(ret))
 		goto err_disable_extclk;
 
-	return devm_rtc_register_device(rtc_dev);
+	ret = devm_rtc_register_device(rtc_dev);
+	if (ret)
+		goto err_disable_extclk;
+
+	return 0;
 
 err_disable_extclk:
 	clk_disable_unprepare(rtc->extclk);
-- 
2.53.0



