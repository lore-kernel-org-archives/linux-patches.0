Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030515;
	b=aX7zJOxEdNb/7VembRO589eKzIwrhhMfjINGvqGQK1NqtDEbl97jp4vnmphqLmoRdPbj
	 SOruIKX4KvdcXO+W2cWsaz7gu6UiW5EhJZ/B8QKgiRKUZ2gLMtDyG/gBvHV5Gzd9ptEAh
	 UmpDcN94+vsjV6bdHdXNgE3VAotEZBlslKmE7OO7CScwvQapHCHFw23gsVNpa49/lkwoV
	 sLWt8qTDd6n/6wtHS5ac8SfFbgMnsNcY5fcQlEH8VXjSIF1osMU8x48mztmfahhn11HYP
	 TiR43E/glXnClDZfyL2b8agumNmY7Nhhsv8wYOMNRfx5EMgARdty4rfmMWi0LFhsWrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030515;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cHQvXEwfF7Zk/gJbqfAeKkDJuCYzXq0xdJ7qNFIp7y4=;
	b=odnEvzgNlsN+HeE5ksky5bCd3E+UkbP6Y4GpPjP4s2OJD50LH8yXF2PPjULhy/G54m6C
	 X/h9swCt66yNrAba8YUmW+L3FPN7VOMwt5D6JN+RyQIPlxl1/YBhU2yNN8ix7RS47p2Vy
	 ysLSXWqLFpBHuOz8FDyhvg0Y5lC3kDAXcq8+zYOJJz57Z0xU/9GJc8YclV+2Qkp/x/Kql
	 vV0d4IT+mn+PMKo+vyce0ic14Vq40YX9VX1BNgIm3yh1/umr+zf+8hQBfSyK23cade6z4
	 Gtbwy0pqxDrsXUHO/WiujZ11SGHvUSkunVnDNYqB7Y31GF5mZsldRNZ956jmHT54shA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ruSyMbur;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50560606BB50;
	Wed, 18 Nov 2026 19:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ruSyMbur
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1B071F000C4;
	Wed, 18 Nov 2026 19:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030515;
	bh=cHQvXEwfF7Zk/gJbqfAeKkDJuCYzXq0xdJ7qNFIp7y4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ruSyMbur/vaoMNS3qZH+x5vDfb7+BKsqWXw67Al7wCg/DJM/EgT2utaJr5lTm1UD2
	 3uVfUZwVPfoY5I0FoPMmc2GFDCiQve8lKyydo56AAKmvrdOHXhGuIQGs9gSdgueicB
	 Mfk9n+D1bPEN2OLmfPPHdyAskof/6OIPV5cs7kVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Dalin <liudalin@kylinsec.com.cn>,
	Linus Walleij <linusw@kernel.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0730/1756] rtc: ftrtc010: fix clock resource leak on probe failure
Date: Wed, 18 Nov 2026 15:47:37 +0100
Message-ID: <20261118150038.730659770@linuxfoundation.org>
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
index 02608d3784958..f398d6dc85ae4 100644
--- a/drivers/rtc/rtc-ftrtc010.c
+++ b/drivers/rtc/rtc-ftrtc010.c
@@ -181,7 +181,11 @@ static int ftrtc010_rtc_probe(struct platform_device *pdev)
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



