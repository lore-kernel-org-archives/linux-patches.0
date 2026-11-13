Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590654;
	b=Xk99LjVs6TMTY8siazeVV6EfYjMEfzMvH2/kjC+72JCJX2kxOWIPjZBIIqbYLbgLTVKG
	 eRhz26VCjVJADtI4jnc8n9msl6Bk67ZDqHeIxiP8r0eoIVctFkslQsn2NNCM7fQXJB5AB
	 Ed523pjlhFxhA0iIMqeumAVYyQZ8SVRdlWoK12g/96yP6ftfeg3MXg9kxJbYJVtuktpZX
	 pTZ2EVeKE7oy3teC+IT2CglKv5pyoa1T2qxDCG85yfTmSvP9ra+k73a9A0qEorYWJpn34
	 hs74cM/Ew+r9ilaJXDaOkSBcwLEQ1tzjlWnN52D2EaXbVlhg+BMgwf1bQ7CJFVf2rWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590654;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dutCXrvq9TkcuCNtm9+hXTm09phjldWXSm1bPYvTeKY=;
	b=Vo3Gy2ww8MCBKLCjGMrvRWLTMKVZ8dazKyMNHSNdR/CI+fQxit30UTWp5tYP+TPqg/46
	 v0G9KYCVFzlBedPDr6tjabx5lcZdxotAlwmEF+oFjr51E7pJGjRPeRWGYweOMvN3NGBty
	 qOVj2FOo0iv/lGs63SHMm5y19H94d+r15zVlurrGf/Zrz+j06mfV0XyJy4IHbH5VtqwEU
	 YBdiP+FU9K9JWfmP0xkREJm2LcIbiU794wY5hIz06G1LavTjPgQJEovakusmyAtj4os/P
	 xGebIwIPt1xGIRrJWYAWaeNB/QIOYGmQBMMdOUSiU65wWrrreMRCAd3aWQf/j7NkV4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jQ9NTVkt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E04A606B211;
	Fri, 13 Nov 2026 17:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jQ9NTVkt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 398321F000C4;
	Fri, 13 Nov 2026 17:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590654;
	bh=dutCXrvq9TkcuCNtm9+hXTm09phjldWXSm1bPYvTeKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jQ9NTVktjjsfo3coSKsnsrL3mwEiXsi+h9mrEySEcbPe1v549kApelhjrnLQNAqii
	 THQzHz1vqjN6yNHD5kMTrNcMR1geawktBWiIXhsVf202NCk0TlfMw39+FaxCwyLnq5
	 mv9P7eh/y+jPrfAEODWP9+krFCbLpuY7t5BphmM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 556/686] ASoC: stm: stm32_i2s: Drop redundant error messages
Date: Fri, 13 Nov 2026 10:51:29 -0500
Message-ID: <20261113153840.419960472@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit a6cdfb6230944082e7be64f9166eed64656b1162 ]

Both devm_request_irq() and snd_dmaengine_pcm_register() already log
failures internally. Drop the redundant error messages and return the
original errors directly.

Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260720074044.87528-3-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 1b207c85551f ("ASoC: stm: stm32_i2s: request IRQ after regmap initialization")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/stm/stm32_i2s.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/sound/soc/stm/stm32_i2s.c b/sound/soc/stm/stm32_i2s.c
index 6ca21780f21d4..100a50a88d6d6 100644
--- a/sound/soc/stm/stm32_i2s.c
+++ b/sound/soc/stm/stm32_i2s.c
@@ -1245,10 +1245,8 @@ static int stm32_i2s_parse_dt(struct platform_device *pdev,
 
 	ret = devm_request_irq(&pdev->dev, irq, stm32_i2s_isr, 0,
 			       dev_name(&pdev->dev), i2s);
-	if (ret) {
-		dev_err(&pdev->dev, "irq request returned %d\n", ret);
+	if (ret)
 		return ret;
-	}
 
 	/* Reset */
 	rst = devm_reset_control_get_optional_exclusive(&pdev->dev, NULL);
@@ -1302,7 +1300,7 @@ static int stm32_i2s_probe(struct platform_device *pdev)
 
 	ret = snd_dmaengine_pcm_register(&pdev->dev, &stm32_i2s_pcm_config, 0);
 	if (ret)
-		return dev_err_probe(&pdev->dev, ret, "PCM DMA register error\n");
+		return ret;
 
 	ret = snd_soc_register_component(&pdev->dev, &stm32_i2s_component,
 					 i2s->dai_drv, 1);
-- 
2.53.0



