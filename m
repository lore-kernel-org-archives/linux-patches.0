Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18CEC27FD42;
	Wed, 23 Apr 2025 15:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420622; cv=none; b=rCZBd8BCO5uz+CDeP7ppkHjo/3JYpOFCL/cqLbLC6kBhEGkEz7eui7Lfpqgt7gBYpTxiWZ2cXV1xdOZPRFTFhYtj+4nFthVo6oXbns8HHWPPGBOxQRAd6jc+Ts9xbGG4B3E+gqAK6YrBbkp6sXOQzj4ngsTJ/QHIO/K4WrsOVIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420622; c=relaxed/simple;
	bh=SV4zwGMKOwGRU0vSMxlgLm/yqbYYWrWC0w1Ge/+znZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S/glHVSVeyCEkmQnuk0jBDP79kcINfFiJJVBkuU41Wc+AVapOiqJfEbcBijFCEwfJ4nVbZZRGh0loy0Yrloj5QQD7m5Yt8NT0SkEbvw9scKhunHpESTZYFlDPUXML/sM7gZMkF4A6JfQvA5YXWUgr05JKhn/RFqXJX7yz/bXBRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zwDoTwWP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zwDoTwWP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CB82C4CEE2;
	Wed, 23 Apr 2025 15:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420622;
	bh=SV4zwGMKOwGRU0vSMxlgLm/yqbYYWrWC0w1Ge/+znZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zwDoTwWPJZTsbBDGTIOdUBcIxq63hMcPSnpaRsKMRTzEVXvnG41EcJ4lAnqFLUdR9
	 G1GMDx+tgDxVLS+WEkfiUpavoNsp9+YQqFAF9slwcdTCmoGmCcu0FVSQcNkvsJuDfX
	 22Sn22I//jaCFVvi/qXSqOTCq6tw2hP3KiGqonUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Kobuk <m.kobuk@ispras.ru>,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	Evgeny Pimenov <pimenoveu12@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.14 108/241] ASoC: qcom: Fix sc7280 lpass potential buffer overflow
Date: Wed, 23 Apr 2025 16:42:52 +0200
Message-ID: <20250423142624.994714797@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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


