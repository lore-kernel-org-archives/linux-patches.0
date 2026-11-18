Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053775;
	b=U33Nl8CgZx3fzhqZd719Tdl9QVIE9NAKdigIgCSrkxG+idxz4yDzzNRigSomV1dEqq1G
	 2lqiYgCjvjuvCD4UGg8xlcro4dUY8ZnEEcjrqVyOO4+Zf/1vxQgAYgLTDrh7VMMpvnAnR
	 ch8EiSZpwX4OVWuQeepsBqLyVeTnFfQ8jPWrD04IexlbPY1uuukA6dvnWRpIUO7BkS4+v
	 /Qicc1WazQKG9+yKixJE4PqG3pzvJ2iiZKuMvD/15UV08yqc3m+i0+5Y7+ARESl0eBL2z
	 2eCtOrTq3s4rIeeoPCkntH2aI9xUmRZu4r6PuqQgOkHhJ4FIPRFwTfuq1FPSS9OiTxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053775;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n7AAKeGcwiLX/L0/AcKo6XKlfNyRBJX9cZHgn1K9MHE=;
	b=hXy3/op++MNgvEv+mMNYNkTOrta15VMe/qaVzj6bHn/dljuegOJhhd9irBZKNBVDeAOo
	 F3M0mCXO4+SvDDMf5zg7Wr2PPH8NjeuK7VjeAT+Kehe9MMxHTvgoYPSVzMGU/EJEgnqpJ
	 /U3WQYkHgIt4ZdgEK0hXupRlQ3Yq9uYppmBUur5q4V4uJO5pbcufMuSdAp/OEwr47feF2
	 IJpSam+Vx2d16zgyW827+RZISiAxo/iwuW+V0AMsuqEIURa8fVVWu/JKdo3bYgiQa46ht
	 OyhdMMLK6xaz87hdGAV0NySabKWKCyYvdRdsCHKie5GBrg/DTUJ/Nd3GDMusGWguJ9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oBmVbpfP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B7C4606A31C;
	Thu, 19 Nov 2026 02:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oBmVbpfP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B0FE1F000C4;
	Thu, 19 Nov 2026 02:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053775;
	bh=n7AAKeGcwiLX/L0/AcKo6XKlfNyRBJX9cZHgn1K9MHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oBmVbpfP34KWaDoTs/yw+1NzmCaXqdEJalR+k6Q9wvs1b8Xz7hjjCGcsznkNmF0Hf
	 ITKbSIwjZhSos2wkS3g0ttfUmkxm2ztYk7MVTOdLftDu1DmxFyzOsMJ4QSU1L8i8Tk
	 jKAs6ygfOtk+N89xkz3NDjS1isy/dvFAXmHq6lbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1039/2214] ASoC: stm: stm32_i2s: Drop redundant error messages
Date: Wed, 18 Nov 2026 15:45:15 +0100
Message-ID: <20261118150053.918872140@linuxfoundation.org>
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
index cd91d59ce227a..2f277e5390ddd 100644
--- a/sound/soc/stm/stm32_i2s.c
+++ b/sound/soc/stm/stm32_i2s.c
@@ -1077,10 +1077,8 @@ static int stm32_i2s_parse_dt(struct platform_device *pdev,
 
 	ret = devm_request_irq(&pdev->dev, irq, stm32_i2s_isr, 0,
 			       dev_name(&pdev->dev), i2s);
-	if (ret) {
-		dev_err(&pdev->dev, "irq request returned %d\n", ret);
+	if (ret)
 		return ret;
-	}
 
 	/* Reset */
 	rst = devm_reset_control_get_optional_exclusive(&pdev->dev, NULL);
@@ -1135,7 +1133,7 @@ static int stm32_i2s_probe(struct platform_device *pdev)
 
 	ret = snd_dmaengine_pcm_register(&pdev->dev, &stm32_i2s_pcm_config, 0);
 	if (ret)
-		return dev_err_probe(&pdev->dev, ret, "PCM DMA register error\n");
+		return ret;
 
 	ret = snd_soc_register_component(&pdev->dev, &stm32_i2s_component,
 					 i2s->dai_drv, 1);
-- 
2.53.0



