Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028084;
	b=dUD6tP6HlLDTFPLFbfWl+kB7NwImDhGlpeXypoKbJAwq4fwmAv/A2f8IB1rsxeJCLzyL
	 /Bk16dSBWq9zgnd/O/AdoExEWHlB+lGDuhxeJjcSTukkL9ou7StQo/Ne2EhhSTNLYKwyF
	 vJxxkmcgaokCJQr8UeVisV2b/c8t2hBtObYsZ92yRApmKW5xafKZ+mSa1fW+4jqrADDjA
	 QzLhe4QldYlLg7uKsWyEwpUecCYg3q/waCOR/SXAOwriAtKf05bDTa/YZ9TU858lB+MpM
	 F25dzf8P4b+BXluNHoK34t4iivgvSMzYGIMtVdiEE65saAeUpNQzQfgGZckS31fIh9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028084;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VWDmf2fsLb+k8I4c9zA7O5E5usXS39v23lzZawVZaz8=;
	b=wAjajKDwVTI8nOrska9k9t/JYe69z+6fl5knLEOq4sRXnSiPRQuL7gapYjsXASsifx/e
	 kN7XqHYlpxBKTgATYS7JLohzeIkMVVl/cwi5dFU+/4q08ErGWaJ4RUSKry/1QWS7FJjmd
	 0gsVVeW05GfZTErpAmgXOH4Kb2jJcebCCnO/teWf3ao/InCRwPb9UCsNMvKTycpwNZNVe
	 dQg7nrCk/jHvUBNL2ys/FmmhjTkwE6UachVBm4g8DXT6w9c+9lGYW9oQqNBTv3C/a3Pj1
	 a4IXvDiV/IaYDv1Y4fkMAMeuGSfsL4rIoCcqh3Lc/cB7y3avyePY7ggNl5R8IXNpxwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wJ8Accju;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2DF606A320;
	Wed, 18 Nov 2026 18:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wJ8Accju
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFDD11F000C5;
	Wed, 18 Nov 2026 18:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028084;
	bh=VWDmf2fsLb+k8I4c9zA7O5E5usXS39v23lzZawVZaz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wJ8AccjuDq8JT4gBq8FN5r2rAoisGZtjMopSF3e1Dc1tOgo5Vi8m9vt1H95h9lJ9O
	 CmD6L2/fmaQzz0OxAW5Dzmy2gaYO0V8xk9YPbLu+Y5scjfLjdvkEa+8iI7UcSPltbN
	 5gbrVd4kdq44saylhPgV9XESVdNduGljWS/iCwUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	"Gaddipati, Naveen" <naveen.gaddipati@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2019/2151] ASoC: xilinx: formatter_pcm: Fix read-modify-write of AUD_CTRL in hw_params
Date: Wed, 18 Nov 2026 16:02:34 +0100
Message-ID: <20261118150235.284511413@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 3b54e739273752b370e49b09976da152fa3b802c ]

xlnx_formatter_pcm_hw_params() does a read-modify-write on XLNX_AUD_CTRL
but only ORs in the new data width and active channel values without
clearing the old ones. If hw_params is called more than once on an
open stream, these fields may retain bits from the previous configuration,
resulting in an incorrect sample width or channel count.

Clear both fields before writing the new values, and use FIELD_PREP() so
the values cannot spill into neighbouring bits.

Fixes: 6f6c3c36f091 ("ASoC: xlnx: add pcm formatter platform driver")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Reviewed-by: Gaddipati, Naveen <naveen.gaddipati@amd.com>
Link: https://patch.msgid.link/20261023102818.523331-1-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/xilinx/xlnx_formatter_pcm.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/sound/soc/xilinx/xlnx_formatter_pcm.c b/sound/soc/xilinx/xlnx_formatter_pcm.c
index 4d90e96a677c9..0f7cb911eb4e3 100644
--- a/sound/soc/xilinx/xlnx_formatter_pcm.c
+++ b/sound/soc/xilinx/xlnx_formatter_pcm.c
@@ -6,6 +6,7 @@
 //
 // Author: Maruthi Srinivas Bayyavarapu <maruthis@xilinx.com>
 
+#include <linux/bitfield.h>
 #include <linux/clk.h>
 #include <linux/io.h>
 #include <linux/module.h>
@@ -57,8 +58,8 @@
 #define CFG_S2MM_XFER_SHIFT	29
 #define CFG_S2MM_PKG_MASK	BIT(28)
 
-#define AUD_CTRL_DATA_WIDTH_SHIFT	16
-#define AUD_CTRL_ACTIVE_CH_SHIFT	19
+#define AUD_CTRL_DATA_WIDTH_MASK	GENMASK(18, 16)
+#define AUD_CTRL_ACTIVE_CH_MASK		GENMASK(22, 19)
 #define PERIOD_CFG_PERIODS_SHIFT	16
 
 #define PERIODS_MIN		2
@@ -509,28 +510,29 @@ static int xlnx_formatter_pcm_hw_params(struct snd_soc_component *component,
 	writel(high, stream_data->mmio + XLNX_AUD_BUFF_ADDR_MSB);
 
 	val = readl(stream_data->mmio + XLNX_AUD_CTRL);
+	val &= ~(AUD_CTRL_DATA_WIDTH_MASK | AUD_CTRL_ACTIVE_CH_MASK);
 	bits_per_sample = params_width(params);
 	switch (bits_per_sample) {
 	case 8:
-		val |= (BIT_DEPTH_8 << AUD_CTRL_DATA_WIDTH_SHIFT);
+		val |= FIELD_PREP(AUD_CTRL_DATA_WIDTH_MASK, BIT_DEPTH_8);
 		break;
 	case 16:
-		val |= (BIT_DEPTH_16 << AUD_CTRL_DATA_WIDTH_SHIFT);
+		val |= FIELD_PREP(AUD_CTRL_DATA_WIDTH_MASK, BIT_DEPTH_16);
 		break;
 	case 20:
-		val |= (BIT_DEPTH_20 << AUD_CTRL_DATA_WIDTH_SHIFT);
+		val |= FIELD_PREP(AUD_CTRL_DATA_WIDTH_MASK, BIT_DEPTH_20);
 		break;
 	case 24:
-		val |= (BIT_DEPTH_24 << AUD_CTRL_DATA_WIDTH_SHIFT);
+		val |= FIELD_PREP(AUD_CTRL_DATA_WIDTH_MASK, BIT_DEPTH_24);
 		break;
 	case 32:
-		val |= (BIT_DEPTH_32 << AUD_CTRL_DATA_WIDTH_SHIFT);
+		val |= FIELD_PREP(AUD_CTRL_DATA_WIDTH_MASK, BIT_DEPTH_32);
 		break;
 	default:
 		return -EINVAL;
 	}
 
-	val |= active_ch << AUD_CTRL_ACTIVE_CH_SHIFT;
+	val |= FIELD_PREP(AUD_CTRL_ACTIVE_CH_MASK, active_ch);
 	writel(val, stream_data->mmio + XLNX_AUD_CTRL);
 
 	val = (params_periods(params) << PERIOD_CFG_PERIODS_SHIFT)
-- 
2.53.0



