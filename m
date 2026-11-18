Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059511;
	b=iFnoioe3wKRrak87Z1qvmS/23drtuupsuP5qXpGtp3H4eq+Dftf79nCdpt5Scub3P8Uk
	 3OWcPvgHSyXtdtZgqvkY1mCjzdOq//7D/Y7fWh2rLW8mcf4LBMF6pwYyP1HUod0dSgg2R
	 6/KFbsrynGk3OELoohKYiJ22WzLuEgFT/e2OeTXayioFDtJGnl5dnie554JsxYSHrP9FV
	 yhr52dWaROIhgF8PwA8hJzGxxG1BZDuFGYVYTWDzeEIlLA38wicokiiM9SQYuXzvSNKp3
	 +NMRdbAY6v/PXznobTa8Oh0Z1tKaKvCJE1Bx/BhXQK4eA3ltG9LTHYHD5cMCO57tUNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059511;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=53J2EzP2PkYDp2zscHzn6TGPmXho99OL6Ps9BeL3LJ4=;
	b=5SRA2klFiRRxTzD00YOb8dA8tYSDRQT0lPtxwxoWVAvJqxT1BKAl9Qx0mhXlwk1LX4sh
	 l5ljYbrQEUXedzLoTdXFB0fTtocPwkRZGAnU1EFxm/QL7DPHvteUCTa1Jj1K2ycETHAaZ
	 ExawC6uSQWa0VpFwBF8R3s/LIk4dZ64C/oP8huMpH7o1/l/0cciNGtYhcW5mNWqMTUJg8
	 gVJTg3jzY/qPAHmVctXILamF8Tr6DCdGBcLGJNW/J4l+fF6lqCXFBer0kGw3fI+6B3T3j
	 GLRDq1XWOtxgbI2djo37yxzO/qiKcUK9B1zHitEeVugMGzOq0JXi280CVE4NiajkMMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="J/HkZP+v";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6550F606A320;
	Thu, 19 Nov 2026 03:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J/HkZP+v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB7C41F000C5;
	Thu, 19 Nov 2026 03:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059511;
	bh=53J2EzP2PkYDp2zscHzn6TGPmXho99OL6Ps9BeL3LJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J/HkZP+vW70ivS0P+1Ia6tIqsnACA0gc/H3PNDRghXDbwXM7FqYdj6OndMeBECV+V
	 cMynu/P4B9I3tBC6E3Ht45D2LUzco0hKw2KeFd6jgLlRfYx122VSXzvIz9zUf/MuDr
	 6yPItH2RZaoqHqF6XE3TcbdSCNXs+9kuKHUVW1nE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olivier Moysan <olivier.moysan@foss.st.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0868/1848] ASoC: stm32: i2s: remove irqf_oneshot flag
Date: Wed, 18 Nov 2026 15:48:26 +0100
Message-ID: <20261118145952.799644076@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index bc369d064e48a..7a2a0b6402528 100644
--- a/sound/soc/stm/stm32_i2s.c
+++ b/sound/soc/stm/stm32_i2s.c
@@ -854,7 +854,7 @@ static int stm32_i2s_parse_dt(struct platform_device *pdev,
 	if (irq < 0)
 		return irq;
 
-	ret = devm_request_irq(&pdev->dev, irq, stm32_i2s_isr, IRQF_ONESHOT,
+	ret = devm_request_irq(&pdev->dev, irq, stm32_i2s_isr, 0,
 			       dev_name(&pdev->dev), i2s);
 	if (ret) {
 		dev_err(&pdev->dev, "irq request returned %d\n", ret);
-- 
2.53.0



