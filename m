Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F79381BA;
	Wed, 23 Apr 2025 14:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420025; cv=none; b=gh46eY/alAhsrsL9VmsHot4MnhFI4pEfq/5P16xvEXLOxw2lZKET7NnicgYOFRARTT1TGUWryb5YPO1oxqTvxCDeCdNpy7JbosiM6BDDMv07/BGTo9qfgD6p4swHZQQsv2MfyIFnA+tvT3d7ajjF8VnRzpeAdMNkgrOuCFY7Kfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420025; c=relaxed/simple;
	bh=oBvIUfxGT4dqbgmrxgBrlpKR03+KLrwz2IsxQSucC1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fxotM0H34NL8IqMfEDSPAaBPLYO+1IfvDgqEEDT5Sw4cA7/Eh4jhcSM3iI0OWqh6xpO3q1kLWH78BRSS0NZnldt08JemulYHp8TDpvvnG5w3RDjOjcM+kOD3Nf2dNidI3survlNSkNg1UIN8ddnw0NSzmsf/3cwYLsMdcax4C24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A5uRsX8Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A5uRsX8Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A9CAC4CEE2;
	Wed, 23 Apr 2025 14:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420023;
	bh=oBvIUfxGT4dqbgmrxgBrlpKR03+KLrwz2IsxQSucC1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A5uRsX8Y3ci3IB5NEA4shWM0aYCLlDW+wphcUQcotWJrNclid4eKDYPo1BDrGwVXg
	 8FcsoEOc4YI4wMqjBMC4x33UqAC2j0RaR8VVM4TyJHG7Jzf+Jm7vxlJqMhFLOAv/Wm
	 CiG31C3fuKHplADniMI2FAya05ck7bO7IEBftHcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Kobuk <m.kobuk@ispras.ru>,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	Evgeny Pimenov <pimenoveu12@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 093/223] ASoC: qcom: Fix sc7280 lpass potential buffer overflow
Date: Wed, 23 Apr 2025 16:42:45 +0200
Message-ID: <20250423142620.907389767@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

From: Evgeny Pimenov <pimenoveu12@gmail.com>

commit a31a4934b31faea76e735bab17e63d02fcd8e029 upstream.

Case values introduced in commit
5f78e1fb7a3e ("ASoC: qcom: Add driver support for audioreach solution")
cause out of bounds access in arrays of sc7280 driver data (e.g. in case
of RX_CODEC_DMA_RX_0 in sc7280_snd_hw_params()).

Redefine LPASS_MAX_PORTS to consider the maximum possible port id for
q6dsp as sc7280 driver utilizes some of those values.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 77d0ffef793d ("ASoC: qcom: Add macro for lpass DAI id's max limit")
Cc: stable@vger.kernel.org # v6.0+
Suggested-by: Mikhail Kobuk <m.kobuk@ispras.ru>
Suggested-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Signed-off-by: Evgeny Pimenov <pimenoveu12@gmail.com>
Link: https://patch.msgid.link/20250401204058.32261-1-pimenoveu12@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/qcom/lpass.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/soc/qcom/lpass.h
+++ b/sound/soc/qcom/lpass.h
@@ -13,10 +13,11 @@
 #include <linux/platform_device.h>
 #include <linux/regmap.h>
 #include <dt-bindings/sound/qcom,lpass.h>
+#include <dt-bindings/sound/qcom,q6afe.h>
 #include "lpass-hdmi.h"
 
 #define LPASS_AHBIX_CLOCK_FREQUENCY		131072000
-#define LPASS_MAX_PORTS			(LPASS_CDC_DMA_VA_TX8 + 1)
+#define LPASS_MAX_PORTS			(DISPLAY_PORT_RX_7 + 1)
 #define LPASS_MAX_MI2S_PORTS			(8)
 #define LPASS_MAX_DMA_CHANNELS			(8)
 #define LPASS_MAX_HDMI_DMA_CHANNELS		(4)


