Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 300C8285417;
	Wed, 23 Apr 2025 15:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422333; cv=none; b=H2aF6+7RNAA0TeqNGUH0znxSYgt6m8lzrM2IRLGqt772Fiex5y35OYvkrncYXjlso8XlF5rU8OJhWSXih2Es8VNuwT3/ZnjySj6WwcWFFbEo4CBwMFVENRoR7e4wSQ06jVxQZB9ZXt1XzYX9vDquGe0N3IFyjYr95eiCOVJWDWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422333; c=relaxed/simple;
	bh=3UEkPG2inAvztLOd6gr+r2PfSewiDZnHJ3vwUQyN5hU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kl3wH7zjlOEYLDOHO5JktlWXHfLvaxGU30QGo93FXW6gRkcg+gpO3bYYEgjkSf35Bdiap0b5iY5EWVFZHebtZdiYTOfWslazXz87Whsji6nv4DGrD/qgyjRXOjKsIiX80f1JKuHnowL5+0Y7xDmiPaD8Iu8mkr2trsacKeUBF24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R7pxcYN2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R7pxcYN2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2314C4CEE2;
	Wed, 23 Apr 2025 15:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422333;
	bh=3UEkPG2inAvztLOd6gr+r2PfSewiDZnHJ3vwUQyN5hU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R7pxcYN2DtZ/1olICc5n8lwU6DRnu+GPnEZ05CLXT9hRNmYy6ukFKZNlK2rPZP13H
	 A5GFBQ3S7QfNgWDQN5qX+DNg72EetQz6eWKWnwRXkOU77cOQtNl6DN1Esnz0Xyb+jS
	 MFifC1oCmvv4ZiuHmQfFHXZJJsajlwh56tz1oPZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Kobuk <m.kobuk@ispras.ru>,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	Evgeny Pimenov <pimenoveu12@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 304/393] ASoC: qcom: Fix sc7280 lpass potential buffer overflow
Date: Wed, 23 Apr 2025 16:43:20 +0200
Message-ID: <20250423142655.893124399@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


