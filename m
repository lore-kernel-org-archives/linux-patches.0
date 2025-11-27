Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043F3334363;
	Thu, 27 Nov 2025 14:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255544; cv=none; b=R60a5vfPQFwgKmJCB+Hs9r3L7nq8jexXyMmggS+KpBcHIZBp4SOlsB162cuTea3Rq/yA+VrTQExPUeZgPBYjFRT3zGAUZt4+//k9G6ilaMMTFfg8FqTXNRFmurtIL8nO6hxN0/5w2U9teXTqBQ2QzL1U4IDd1/UlH+j/lGQqXlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255544; c=relaxed/simple;
	bh=iwSSfd6taaiAkVLl6Q4zJsiaywsQo2Pr2T3OrYyDYX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z2vTgqORcPtcAl2x/qtu7c8Ho9NojT2y2an6CgSipfAbCtJ91tzhcDKZjgsNCNiSg4YbnZ9EVSFcxGTDyQF0DUzEw+JPdoLtj8Ru1G5Oi/0F4/y2RVIlnDkK8ldYaAVHkGDaIXGkjWZW8Cxn9EUzfBVoL8ypbPHs/PpqMvtBUr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DItABDy3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DItABDy3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CC7AC4CEF8;
	Thu, 27 Nov 2025 14:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255543;
	bh=iwSSfd6taaiAkVLl6Q4zJsiaywsQo2Pr2T3OrYyDYX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DItABDy3H6e14n95wc8/mbkwfiKTfyayw7/SlAJWTlq4rkHWm32trXNR81SzwR3wB
	 JOsqTygHjM6xq597B3CeSMEUqYmNpCOdzWz59Atcyov74fy4s5YYoyAhBbgA+ITr9R
	 xmebFT/6nFce+R3vjay2MF6MGmHbAxiUYiGe5+IE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Laurentiu Mihalcea <laurentiu.mihalcea@nxp.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 6.17 008/175] reset: imx8mp-audiomix: Fix bad mask values
Date: Thu, 27 Nov 2025 15:44:21 +0100
Message-ID: <20251127144043.261349129@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurentiu Mihalcea <laurentiu.mihalcea@nxp.com>

commit 997c06330fd5c2e220b692f2a358986c6c8fd5a2 upstream.

As per the i.MX8MP TRM, section 14.2 "AUDIO_BLK_CTRL", table 14.2.3.1.1
"memory map", the definition of the EARC control register shows that the
EARC controller software reset is controlled via bit 0, while the EARC PHY
software reset is controlled via bit 1.

This means that the current definitions of IMX8MP_AUDIOMIX_EARC_RESET_MASK
and IMX8MP_AUDIOMIX_EARC_PHY_RESET_MASK are wrong since their values would
imply that the EARC controller software reset is controlled via bit 1 and
the EARC PHY software reset is controlled via bit 2. Fix them.

Fixes: a83bc87cd30a ("reset: imx8mp-audiomix: Prepare the code for more reset bits")
Cc: stable@vger.kernel.org
Reviewed-by: Shengjiu Wang <shengjiu.wang@gmail.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Daniel Baluta <daniel.baluta@nxp.com>
Signed-off-by: Laurentiu Mihalcea <laurentiu.mihalcea@nxp.com>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/reset/reset-imx8mp-audiomix.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/reset/reset-imx8mp-audiomix.c b/drivers/reset/reset-imx8mp-audiomix.c
index 6b357adfe646..eceb37ff5dc5 100644
--- a/drivers/reset/reset-imx8mp-audiomix.c
+++ b/drivers/reset/reset-imx8mp-audiomix.c
@@ -14,8 +14,8 @@
 #include <linux/reset-controller.h>
 
 #define IMX8MP_AUDIOMIX_EARC_RESET_OFFSET	0x200
-#define IMX8MP_AUDIOMIX_EARC_RESET_MASK		BIT(1)
-#define IMX8MP_AUDIOMIX_EARC_PHY_RESET_MASK	BIT(2)
+#define IMX8MP_AUDIOMIX_EARC_RESET_MASK		BIT(0)
+#define IMX8MP_AUDIOMIX_EARC_PHY_RESET_MASK	BIT(1)
 
 #define IMX8MP_AUDIOMIX_DSP_RUNSTALL_OFFSET	0x108
 #define IMX8MP_AUDIOMIX_DSP_RUNSTALL_MASK	BIT(5)
-- 
2.52.0



