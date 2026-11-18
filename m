Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059514;
	b=HW4rPAJ8/IFEtH0P8LknTbw4jtowbjrPuf75OtDjMao7MkNI1MWW6i5AAODndcHoTws1
	 uKE+QHIU/7atVjyR7f0zYDZRjyqclEC4zSW4GguN52qUkokFQHy1cvZds24i/Yyo28p7Z
	 1QHMospXdMtQvmXSwfy2HjF5HBvFYzoglF59cQeE7m+YORso8tJ8nDEnrY/yUODBb0FP0
	 o3D1EbsZVxzmpFihRadHeA7b2CuCycJgcPupaY9MwYivQRtN8pPdoS+wJCuUN844cyc/K
	 Uq3SZSHz+7uhtHXsf0JqYNIPEoRp9U0LLkcWPtvFBKbYyrUd0ZPqsBwcm6w8maHq+wQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059514;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dJyGCzqQS1Pjy8TTpk5FUF6zftvta2fkzDKb35eiWIA=;
	b=PrpXwQVUty0E3WPqJQ2zKWN+/aOYraagR08blcwHfouvWM5QjzYNR1L6a3NfOhelbnjM
	 kuqHK6vsUWgciuorm0kyPlh5IRAoagxgtB1sskACi0oMfyXl+1seubirhT8ZTvYj95fni
	 F2PVETgDahX/NSo78sXO7gcMeIGlNQ0kd9kVxKShQp34XoZPBfDyHTKxdLbZyc9dfDvmf
	 CQuPjmMorikygoqosh+leWfK+kzka/waAWIyzw75rb1pHgLIWSmWqYMZrpDrI4eQ0KCcx
	 nfbStXlN2ZWwGsHFPtPcdzV5UjzSP17fUu1M2bF8wY4HvRFuvONvdes0HK2a5+bEFEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gTB9e+kq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38EA9606A335;
	Thu, 19 Nov 2026 03:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gTB9e+kq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BC621F000C9;
	Thu, 19 Nov 2026 03:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059514;
	bh=dJyGCzqQS1Pjy8TTpk5FUF6zftvta2fkzDKb35eiWIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gTB9e+kq/AnATyXICT8bQxfuI1GaA8QVegetigfjsPkwmZQ6yv/Qad6+CCTmsf3o6
	 UbrV+M3HxcB4qFBVxRypKdKe5jSxYKZdOLXB2eg5WdSxjI/qoSc1JlavG71DUiAb+M
	 gP06hBuF7b8VO2RCIkfM4eD6WKKgEfzv+ttefzXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0869/1848] ASoC: stm: stm32_i2s: Drop redundant error messages
Date: Wed, 18 Nov 2026 15:48:27 +0100
Message-ID: <20261118145952.835382779@linuxfoundation.org>
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
index 7a2a0b6402528..4a6869d535d4f 100644
--- a/sound/soc/stm/stm32_i2s.c
+++ b/sound/soc/stm/stm32_i2s.c
@@ -856,10 +856,8 @@ static int stm32_i2s_parse_dt(struct platform_device *pdev,
 
 	ret = devm_request_irq(&pdev->dev, irq, stm32_i2s_isr, 0,
 			       dev_name(&pdev->dev), i2s);
-	if (ret) {
-		dev_err(&pdev->dev, "irq request returned %d\n", ret);
+	if (ret)
 		return ret;
-	}
 
 	/* Reset */
 	rst = devm_reset_control_get_optional_exclusive(&pdev->dev, NULL);
@@ -914,7 +912,7 @@ static int stm32_i2s_probe(struct platform_device *pdev)
 
 	ret = snd_dmaengine_pcm_register(&pdev->dev, &stm32_i2s_pcm_config, 0);
 	if (ret)
-		return dev_err_probe(&pdev->dev, ret, "PCM DMA register error\n");
+		return ret;
 
 	ret = snd_soc_register_component(&pdev->dev, &stm32_i2s_component,
 					 i2s->dai_drv, 1);
-- 
2.53.0



