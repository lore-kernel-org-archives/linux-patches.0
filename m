Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053772;
	b=tKe7rCl5msvFTDAmLQnnYAe27XCNolIE+poS6s5jKEYTs7BnoQhnNXRWw3OJ9FqlhnjW
	 XNK9/rFWoMVDNQcaEl1cukoQaHM4rMDZD+b3Wo79KYmb1m6ILPOCsmc8N3t2NEnNq2A9D
	 1gnuuOCw+A17K6Cky/Z12u7qRVit8oAyZ7nzhygbpkC5/bPsUULb71dIxM/hvVG1WSTFW
	 4M+S3BUyil0JzL9KnBzehpBG9GMonYMJjKg8kB59HyNnZif1EUSs6zFvXZg5cbk5OiqwP
	 KrE6NigshkFWz9zJAG/p0XCMPgtCZD46b3OZvjbOFt2zkGHdfj7xcuoIULurwNZntKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053772;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ku9JBFPnU2RK/1dR4G8Cf3JhNA6u9u+2Ocdwf7jtZf0=;
	b=K1rPLuoYdq9xbbYuxZ/7liMcYS169QLxaupp+8Jcu5cxc4UTAgq7s8hqNzE9gwMIxJVx
	 SSWslRYLB2aTo2MXHZ2A69tt85LB1x5rNI3DLVdTDaE+Tc1u4au8Y4KULtv0RXJz0fN9G
	 DHX6sD5p8snMpNhjCEWeNnTLoMj/dCGCxmQiuRHL8Rn3Ut/3bLfClgdPudhDZlMe6YWDi
	 LyEL5SPKENI142pdInawgh9gDncsJzq9fB/SS11rfSbO7u/aQNhNJqogjXKtFSm3WcF3F
	 xIaHk0NHTOl2N9iBXA5kHj0pfKWmy/3GBbAhdREP7twgXQ+yPcOIfH7Z2R57Eaama1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EeqMCk6T;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61ABF606A320;
	Thu, 19 Nov 2026 02:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EeqMCk6T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7C761F000C4;
	Thu, 19 Nov 2026 02:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053772;
	bh=Ku9JBFPnU2RK/1dR4G8Cf3JhNA6u9u+2Ocdwf7jtZf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EeqMCk6TeyiAfg2d6f2MASuYizVl5BEXAtw1a8HY94tupEG4hmH75H2GCjvIL0bd8
	 kLFdduDwee6QMOwOw86tOVrp+97q55sbVMMcfuyh/ow627CeYs49tr5OkrNS46vBAA
	 vHRMwgs6iOesZPLbDw33hrcgKOpyPltxaP8jbe0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olivier Moysan <olivier.moysan@foss.st.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1038/2214] ASoC: stm32: i2s: remove irqf_oneshot flag
Date: Wed, 18 Nov 2026 15:45:14 +0100
Message-ID: <20261118150053.884987044@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olivier Moysan <olivier.moysan@foss.st.com>

[ Upstream commit 7c0f8f1462c9edeaa202a2cbea1bde0960434b09 ]

The IRQF_ONESHOT flag allows to ensure that the interrupt is not
unmasked after the hard interrupt context handler has been executed
and the thread has been woken. The interrupt line is unmasked after
the thread handler function has been executed.

The STM32 I2S driver does not implement a threaded IRQ handler.
So, the IRQF_ONESHOT flag is not useful in I2S driver.
Remove this flag to allow the interrupt routine to be managed
as a thread in RT mode.

Signed-off-by: Olivier Moysan <olivier.moysan@foss.st.com>
Link: https://lore.kernel.org/r/20221110084406.287117-1-olivier.moysan@foss.st.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 1b207c85551f ("ASoC: stm: stm32_i2s: request IRQ after regmap initialization")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/stm/stm32_i2s.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/stm/stm32_i2s.c b/sound/soc/stm/stm32_i2s.c
index 08db73c2ed782..cd91d59ce227a 100644
--- a/sound/soc/stm/stm32_i2s.c
+++ b/sound/soc/stm/stm32_i2s.c
@@ -1075,7 +1075,7 @@ static int stm32_i2s_parse_dt(struct platform_device *pdev,
 	if (irq < 0)
 		return irq;
 
-	ret = devm_request_irq(&pdev->dev, irq, stm32_i2s_isr, IRQF_ONESHOT,
+	ret = devm_request_irq(&pdev->dev, irq, stm32_i2s_isr, 0,
 			       dev_name(&pdev->dev), i2s);
 	if (ret) {
 		dev_err(&pdev->dev, "irq request returned %d\n", ret);
-- 
2.53.0



