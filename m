Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAD201E51FA;
	Mon, 23 Jun 2025 21:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714021; cv=none; b=dWkPbczJ+jBmtl9GKLH82BaRP8nuOM4DYn+jFzIHNmx8JYdqArMadgxwkBrMXik0azt5OWPcixAJeFaEU+/moCLr3+yslkBmUf8Vcy+E6CtBp3NsdwFeHYlwDiGeSQJSrf8s919JpJnMaG8vCuApo/J05o6Q7jxpwLuHNV1059I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714021; c=relaxed/simple;
	bh=zakGU79XHIONbvY9wDo34uS7I+h8QN9pUDJ8/SpmmbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jO/22uGCCmx1m7AxTQzzCizAo6cOGNZOoiMyfQQvVlMfC1Cargv9op7MQGEONrfcIFiAy0crmvP+6tcL68KAHi2NpLrMhi8MnU+PdW4P9gLYe8fpnSttUwbr8gJdT5wZgPSQDYGdEsQsyOFdRPP/h4TFZS7T6DGwrYpMtlRB488=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t0SF94eK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t0SF94eK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81461C4CEEA;
	Mon, 23 Jun 2025 21:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714020;
	bh=zakGU79XHIONbvY9wDo34uS7I+h8QN9pUDJ8/SpmmbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t0SF94eK2q/jIXUv685+Oy5wz+AXgupfec8ByW3XFlJQLZuZLtSKEVfBbRTD3bQUH
	 9l6PBdZGypwpLOgkYKRpxIL25CZPQG53cpt2KCwEU6+vzd4xumV8iJNaUuSu1QpFqV
	 ZbVm6OVMSrU1sGr/x5Dw4JKeBDMQU5eH04z/bigM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 076/414] ASoC: codecs: wcd937x: Drop unused buck_supply
Date: Mon, 23 Jun 2025 15:03:33 +0200
Message-ID: <20250623130643.980235456@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit dc59189d32fc3dbddcf418fd4b418fb61f24ade6 upstream.

Last user of wcd937x_priv->buck_supply was removed in
commit 216d04139a6d ("ASoC: codecs: wcd937x: Remove separate handling
for vdd-buck supply").

Fixes: 216d04139a6d ("ASoC: codecs: wcd937x: Remove separate handling for vdd-buck supply")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://patch.msgid.link/20250526-b4-b4-asoc-wcd9395-vdd-px-fixes-v1-2-0b8a2993b7d3@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/wcd937x.c |    1 -
 1 file changed, 1 deletion(-)

--- a/sound/soc/codecs/wcd937x.c
+++ b/sound/soc/codecs/wcd937x.c
@@ -92,7 +92,6 @@ struct wcd937x_priv {
 	struct regmap_irq_chip *wcd_regmap_irq_chip;
 	struct regmap_irq_chip_data *irq_chip;
 	struct regulator_bulk_data supplies[WCD937X_MAX_BULK_SUPPLY];
-	struct regulator *buck_supply;
 	struct snd_soc_jack *jack;
 	unsigned long status_mask;
 	s32 micb_ref[WCD937X_MAX_MICBIAS];


