Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9F34206C;
	Mon,  1 Jul 2024 18:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719858420; cv=none; b=Sb1GOVs0uBy53jR4ZYjpgeAXyYpS22Yr3zt0rcuh6Uvo0pTpmKBhwOCfCjkm/Lp+9hgdzxYeP/3GDUvhOUtHGU1nSQ+2RIVcHcvZBdnERoQ6onJBk661OsQqWi356XwUsP+udwSzaMMk19vy/jypYFaVF4+Ec9EcrpDFhyW9Lmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719858420; c=relaxed/simple;
	bh=wDmAHasbwyDrav/gjz/1HfTelzHzs8MHoUaZv+UsTFU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=PYZSkYWEt8NrH5SewHqC/ORHKzM8l35ynza+dZ5jJbyChKJj25NmLkkJDb28c/8JsOoddUsrwNMKiTwT1+r3mkFqw3MFwdZAjdLPlAyHjUq3vxkhSEmsZqX1D6/8aO09TKOy0O+KhHg2um+jLLkHwoDAesw2u0B32mjC4mPcNjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ImT+Hj/5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ImT+Hj/5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8271C116B1;
	Mon,  1 Jul 2024 18:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719858420;
	bh=wDmAHasbwyDrav/gjz/1HfTelzHzs8MHoUaZv+UsTFU=;
	h=From:Date:Subject:To:Cc:From;
	b=ImT+Hj/5dJ6/oeZzaMtoDUKPqVouhuQg5ZghBti5V/Zb9CIbeYILdEXNobBZR7OZM
	 6/F3s18gDPLwS+5+BU46R/28U5CRFYH300eR7xtiMYAZ6jFeY7nFfgWsfVAwRLdB6X
	 L/LaGyvl6O+1EiVdU4/vyUMtUjWrHEldxrMEU0AN5YmlcUoUP9slhUx4qFk8hMaG6m
	 aTI03n62QvpZUZzHSI6aaIrdrn6ji1Owb0G2Db7Q8mpLPwCXlE6AX/u4fqVLerKtMY
	 sAB8NKe6T8mPqmCt3Uljd1pNc6i9Y9ufOs9XP1MJgXuc8Uf8FvuA8V0JexnQMJid5H
	 Vd0gB9q7jZAOw==
From: Nathan Chancellor <nathan@kernel.org>
Date: Mon, 01 Jul 2024 11:26:38 -0700
Subject: [PATCH] ASoC: fsl: lpc3xxx-i2s: Include bitfield.h for FIELD_PREP
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240701-lpc32xx-asoc-fix-include-for-field_prep-v1-1-0c5d7f71921b@kernel.org>
X-B4-Tracking: v=1; b=H4sIAN30gmYC/x3NXQrDIBAE4KuEfe7Cai39uUopxeimXRAVJUUIu
 XuWPn7DMLNB5ybc4TFt0PgnXUpWmNME4evzh1GiGixZR1cymGo42zHQ9xJwkYGSQ1oj41KamlN
 818YVjaM439zFW7qDrmmo7f/T87XvB2yNv3N5AAAA
To: Mark Brown <broonie@kernel.org>, 
 "J.M.B. Downing" <jonathan.downing@nautel.com>, 
 Piotr Wojtaszczyk <piotr.wojtaszczyk@timesys.com>
Cc: Vladimir Zapolskiy <vz@mleia.com>, alsa-devel@alsa-project.org, 
 linuxppc-dev@lists.ozlabs.org, linux-sound@vger.kernel.org, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2810; i=nathan@kernel.org;
 h=from:subject:message-id; bh=wDmAHasbwyDrav/gjz/1HfTelzHzs8MHoUaZv+UsTFU=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDGlNXz7XTWQI3vX8Z+WFtsqwSZJCPwvOnNXlsv5SxPirZ
 kJz3ErpjlIWBjEuBlkxRZbqx6rHDQ3nnGW8cWoSzBxWJpAhDFycAjCRDdUM//PUFujO11fQ/po4
 a/MK4bnLf+Qp95d/YJv2suyfgmVs0VGG//XZ6ayv2O4oq+azrayL5L9ReDj6jHw/e+utz4FWN97
 q8AEA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

bitfield.h is not explicitly included but it is required for FIELD_PREP
to be expanded by the preprocessor. If it is not implicitly included,
there will be a compiler error (as seen with ARCH=hexagon allmodconfig):

  sound/soc/fsl/lpc3xxx-i2s.c:169:10: error: call to undeclared function 'FIELD_PREP'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    169 |                 tmp |= LPC3XXX_I2S_WW8 | LPC3XXX_I2S_WS_HP(LPC3XXX_I2S_WW8_HP);
        |                        ^
  sound/soc/fsl/lpc3xxx-i2s.h:42:30: note: expanded from macro 'LPC3XXX_I2S_WW8'
     42 | #define LPC3XXX_I2S_WW8      FIELD_PREP(0x3, 0) /* Word width is 8bit */
        |                              ^
  sound/soc/fsl/lpc3xxx-i2s.c:205:34: error: call to undeclared function 'FIELD_PREP'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    205 |                              LPC3XXX_I2S_DMA1_TX_EN | LPC3XXX_I2S_DMA0_TX_DEPTH(4));
        |                                                       ^
  sound/soc/fsl/lpc3xxx-i2s.h:65:38: note: expanded from macro 'LPC3XXX_I2S_DMA0_TX_DEPTH'
     65 | #define LPC3XXX_I2S_DMA0_TX_DEPTH(s) FIELD_PREP(0xF0000, s) /* Set the DMA1 TX Request level */
        |                                      ^
  sound/soc/fsl/lpc3xxx-i2s.c:210:34: error: call to undeclared function 'FIELD_PREP'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    210 |                              LPC3XXX_I2S_DMA0_RX_EN | LPC3XXX_I2S_DMA1_RX_DEPTH(4));
        |                                                       ^
  sound/soc/fsl/lpc3xxx-i2s.h:70:38: note: expanded from macro 'LPC3XXX_I2S_DMA1_RX_DEPTH'
     70 | #define LPC3XXX_I2S_DMA1_RX_DEPTH(s) FIELD_PREP(0x700, s) /* Set the DMA1 RX Request level */
        |                                      ^

Include bitfield.h explicitly, so that FIELD_PREP is always expanded,
clearing up the compiler error.

Fixes: 0959de657a10 ("ASoC: fsl: Add i2s and pcm drivers for LPC32xx CPUs")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 sound/soc/fsl/lpc3xxx-i2s.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/fsl/lpc3xxx-i2s.h b/sound/soc/fsl/lpc3xxx-i2s.h
index eec755448478..b6657853017a 100644
--- a/sound/soc/fsl/lpc3xxx-i2s.h
+++ b/sound/soc/fsl/lpc3xxx-i2s.h
@@ -9,6 +9,7 @@
 #ifndef __SOUND_SOC_LPC3XXX_I2S_H
 #define __SOUND_SOC_LPC3XXX_I2S_H
 
+#include <linux/bitfield.h>
 #include <linux/types.h>
 #include <linux/regmap.h>
 

---
base-commit: 55f0a1fa6ea4e339c797e9a3292ca0caa4ab3885
change-id: 20240701-lpc32xx-asoc-fix-include-for-field_prep-140db845a209

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

