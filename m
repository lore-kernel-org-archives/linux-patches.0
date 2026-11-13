Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591422;
	b=2wlzjpPKItLUSHfZy6j3h9hU0gvyFKO6uTPX32L+MV9aU8/DP5wKgJRgkEfMPw/XT3sE
	 035K3SaOrtMhGLvyujLQDJHKdH7Ybgwm68PcHvcA00Cv/h9fMjvqm5T+5i+nPpkn83x5T
	 CuiPg5gvfwlZqVJkdTFaG93kA4sDCg8RcWwAnulPqWEmVx3QW8UvG5eMMJKDUPCR5mBa3
	 PVr8n0B8CnoGCCBRli4kcsHjjT6tu5wgzalIVNvoAJ5nCTzUfB0r9q3VOEgxDczcAC/FW
	 ppZKIVH9EVr4SLFRzZnKHfNSe0XfnA0fgCCLbq7e2Ac/SPQghKlnKgotbbBOr+k5oBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591422;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i0WairUZPCRPuUEOze2+wNSrFzh+m7EzMP9qGAQigF4=;
	b=VfzSNHmJBMiJVWjbqJUG2XfE8FeF3NFCDytLSb8nycIUwEnNofBMpUSugYygyPE+oX5c
	 jB4VpHC05DJlNEsEcZUqDY2V1FS8rRRVk3e2RgjiHWYxgU317AHUjQRB4M3kBggJFSna0
	 XDRLc9VYuoy42Iye+3QwVqjYcHO3giRGE0/+sYJmBxVAoj0GuKg7jypRIsUoMrBxBSkBQ
	 h9vr86CUSxrqIHVWzi6hMFk8X+oU2/Mccegy1pHTWzqmEdfhQlMc0hGVYeyxfWIhgRudC
	 VIvWDJP7CGEltslp0MQ8CJhlyAYDVVimj4LG4+U8Im2ZnkTgPJT5O/drLEOYpPLj13Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HrQEsUfk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 994716079D6B;
	Fri, 13 Nov 2026 17:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HrQEsUfk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43E071F000C4;
	Fri, 13 Nov 2026 17:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591422;
	bh=i0WairUZPCRPuUEOze2+wNSrFzh+m7EzMP9qGAQigF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HrQEsUfkTw/jzIql1iO4XIxrkzsP5LNdbCmq5uTFAQ1wy9U1DVTTUXXWSI8ATZKNk
	 bIVs1ojdq++qaahdCgXvwfWKfqGxemjYwiT1Hx5fN1ZGKmV4o+dj71m7TwhIXeGPpp
	 wW4RBut6Y16A0BjV6LMETsoGL/CAlHRHtKHDq/1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 514/670] ASoC: stm: stm32_i2s: Drop redundant error messages
Date: Fri, 13 Nov 2026 10:51:18 -0500
Message-ID: <20261113153829.360334691@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
index faa00103ee7f1..5b15b8fb87c39 100644
--- a/sound/soc/stm/stm32_i2s.c
+++ b/sound/soc/stm/stm32_i2s.c
@@ -1076,10 +1076,8 @@ static int stm32_i2s_parse_dt(struct platform_device *pdev,
 
 	ret = devm_request_irq(&pdev->dev, irq, stm32_i2s_isr, 0,
 			       dev_name(&pdev->dev), i2s);
-	if (ret) {
-		dev_err(&pdev->dev, "irq request returned %d\n", ret);
+	if (ret)
 		return ret;
-	}
 
 	/* Reset */
 	rst = devm_reset_control_get_optional_exclusive(&pdev->dev, NULL);
@@ -1133,7 +1131,7 @@ static int stm32_i2s_probe(struct platform_device *pdev)
 
 	ret = snd_dmaengine_pcm_register(&pdev->dev, &stm32_i2s_pcm_config, 0);
 	if (ret)
-		return dev_err_probe(&pdev->dev, ret, "PCM DMA register error\n");
+		return ret;
 
 	ret = snd_soc_register_component(&pdev->dev, &stm32_i2s_component,
 					 i2s->dai_drv, 1);
-- 
2.53.0



