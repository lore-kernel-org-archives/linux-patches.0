Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046963;
	b=XtvkfGvv5wVHPyGnmJqhHyahIpCJzv5VbvgZT9brahV9XmVk/3d/Ps3I+MvYWPQ/XXhE
	 FG+dNy1TUXr+Ssmg6jKV/nXMW53s1ln1ASsnKwcd2KDAGVPOliyS2QkCCLm1r8w/iyQjI
	 o5hjeca7NuwZ3NQhffEi59c0/VeS6Lf4mM+9/+RIwDoGbk1eJUQrZw3TT7ZjP50tkjRTj
	 CYDS+D8F92387AjvhpwvwHHon6uQmSLhy45wENZxKTKKDce0pJtNSLKvYeCXymaZhO3eu
	 sNDPfcyIBmRI4I67wQ1G8zQUb5A1AKRdyK5UFlEXHexE0DdljK/F7lNH1LeTBhCBpzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046963;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/WCvFodSKPN3xq/AocNFqEVcCpTybshJWQBi4kxq/lI=;
	b=k9sc3sopGVWI4FPluLqEA7/9g7LSnkzJl5Se4QciO4dST+rx9D+/IsuxoTAyUMU/6Pi5
	 oSYyzfylQq8pa3f2HusfttJ+qZefQYNXcOH7AMHQcc57zOCs7RnJ6V2T/NsDY5FVzNiaM
	 F6bJqnL57JmG1TIpsghMlYSYov2f1OEVDdbU8Ubz7IFse+8KqanePkwjmo7m4HzBlDxMe
	 vLr+u/H/kRpGW526GRAw90Op8V63yJSXyQGUR/b0Bclppcaof7ce5771oVEc4Tsvk2rV1
	 Ae8eMbhLVxkZgP6Yr41cmL1NB+OjRIoOod00BJCfwhgW6r0dRCHz1LDVN95OhStmhCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1u+rtczB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951F2606A32C;
	Thu, 19 Nov 2026 00:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1u+rtczB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE5541F000C5;
	Thu, 19 Nov 2026 00:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046963;
	bh=/WCvFodSKPN3xq/AocNFqEVcCpTybshJWQBi4kxq/lI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1u+rtczBPvFQjDN3yzScdIH6Mj1x406P7QO+8+/qEM4q7IdWHDIatZ078ST+bqRJk
	 wbXNRkk56Q0l4gzJFZb/KG8Zx/uo2gCjwtPRfaYA3uRYHWt8bbQDoI6sf/uc8qRCYr
	 NYEXeLThBYF0Nz8DMZqNIRhMbniu7tvm6gGXXE1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1428/2857] ASoC: stm: stm32_i2s: Drop redundant error messages
Date: Wed, 18 Nov 2026 15:41:02 +0100
Message-ID: <20261118150252.732636421@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f3dd9f8e621cc..c52613365d679 100644
--- a/sound/soc/stm/stm32_i2s.c
+++ b/sound/soc/stm/stm32_i2s.c
@@ -1079,10 +1079,8 @@ static int stm32_i2s_parse_dt(struct platform_device *pdev,
 
 	ret = devm_request_irq(&pdev->dev, irq, stm32_i2s_isr, 0,
 			       dev_name(&pdev->dev), i2s);
-	if (ret) {
-		dev_err(&pdev->dev, "irq request returned %d\n", ret);
+	if (ret)
 		return ret;
-	}
 
 	/* Reset */
 	rst = devm_reset_control_get_optional_exclusive(&pdev->dev, NULL);
@@ -1138,7 +1136,7 @@ static int stm32_i2s_probe(struct platform_device *pdev)
 
 	ret = snd_dmaengine_pcm_register(&pdev->dev, &stm32_i2s_pcm_config, 0);
 	if (ret)
-		return dev_err_probe(&pdev->dev, ret, "PCM DMA register error\n");
+		return ret;
 
 	ret = snd_soc_register_component(&pdev->dev, &stm32_i2s_component,
 					 i2s->dai_drv, 1);
-- 
2.53.0



