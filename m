Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621520;
	b=zPhj7W11ayS+z9o04fA0HbKdpa3cTWeW3B75B1HKExlGZ3ag/qWf/+QatLH5hqSrks8w
	 VCrihrYgov4LtlQ/D5lOCKHcgXmSzMyaASxreUTj4tH9YqxTHwCdRkV63g4IZ57KKfMtr
	 hkc+oxvgjOUtOERZktkR8ZAnVeSYgAsFNyEMgtYXUwDMX8oJvtSJ3cjD0wIBkVBP+s1cy
	 VwiANMosE2KNdIJQJ9suX6hm+xK31H6XarrfKJDtoOORdS/j5pbv9acAavy5psasQcyO1
	 TlcaZYMMRgrmPGWGF0AUsJ0H3C9iP16MMxczFiAQIgo4zU0wDKKcmanlTyAs3027X/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621520;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HhaqfqsDi28Op87W7vW9x7I2jg0KBR4NfpujH5No+eA=;
	b=HicOKGpcTGIhEaU3aTljDVAWHAS0lDpUy+RbqqqTo2YYK3aiRlT7TBOzmQVoQ9A0raLs
	 G2o27b9gN7r6APEkloUvuW93Hp4UADAJi+vBx1rgSsMLWxKIPZHQvNo8OvytlupbR8iH9
	 +dqdlJW443yvVhKMgX2/uLk5D40yIRhZgE9WitfYvqVQoa1CmtnhbghP5S6RFNV6r8biX
	 DcEInHEU6g4tO11J29VCM5TAk1B077LMrBf6RJP1obU4HAFwQ775/JyHpNyBCIYv1I58k
	 lvyW6cAGPOEMYocY/RJKSKM4ranX9EeU9NIWPCOJIb3oFtaEjMyX0YyF5zunyqCRAtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UrOa+z58;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 935B9606A32E;
	Wed, 25 Nov 2026 15:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UrOa+z58
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 852C91F000C6;
	Wed, 25 Nov 2026 15:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621520;
	bh=HhaqfqsDi28Op87W7vW9x7I2jg0KBR4NfpujH5No+eA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UrOa+z58P/ASoiNE6sQ67jGxk8RNxWrT8kqZ1Akrmyr1BRC6rEcdu6Z0W8XqZCdUh
	 VIEAAY2svpHmCTQJ8MskTeImbcm5sR6/eBxYnU6GbKRPo/0oczLsNecKwOLqNfjaRD
	 xTMVrVr3Qw5kKm7R5tSJSZPDw7HR7BAhprxmf7IU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sugar Zhang <sugar.zhang@rock-chips.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 249/990] ASoC: rockchip: spdif: Fill IEC958 CS info per params
Date: Wed, 25 Nov 2026 15:26:56 +0100
Message-ID: <20261125143827.923435522@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Sugar Zhang <sugar.zhang@rock-chips.com>

[ Upstream commit 07a791020be9b190d4a57b5ee823ede1e98df493 ]

Add support to fill IEC958 channel status information.

Signed-off-by: Sugar Zhang <sugar.zhang@rock-chips.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Link: https://patch.msgid.link/20260203-rockchip-spdif-cleanup-and-bsp-sync-v2-9-4412016cf577@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 67a7e2073909 ("ASoC: rockchip_spdif: select REGMAP_MMIO")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/rockchip/Kconfig          |  1 +
 sound/soc/rockchip/rockchip_spdif.c | 45 ++++++++++++++++++++++++++---
 sound/soc/rockchip/rockchip_spdif.h |  8 +++++
 3 files changed, 50 insertions(+), 4 deletions(-)

diff --git a/sound/soc/rockchip/Kconfig b/sound/soc/rockchip/Kconfig
index 625390ee4ad6f..aba9a518d3b26 100644
--- a/sound/soc/rockchip/Kconfig
+++ b/sound/soc/rockchip/Kconfig
@@ -45,6 +45,7 @@ config SND_SOC_ROCKCHIP_SAI
 
 config SND_SOC_ROCKCHIP_SPDIF
 	tristate "Rockchip SPDIF Device Driver"
+	select SND_PCM_IEC958
 	select SND_SOC_GENERIC_DMAENGINE_PCM
 	help
 	  Say Y or M if you want to add support for SPDIF driver for
diff --git a/sound/soc/rockchip/rockchip_spdif.c b/sound/soc/rockchip/rockchip_spdif.c
index 7acc6408a5245..be84b226827e7 100644
--- a/sound/soc/rockchip/rockchip_spdif.c
+++ b/sound/soc/rockchip/rockchip_spdif.c
@@ -16,6 +16,7 @@
 #include <linux/mfd/syscon.h>
 #include <linux/regmap.h>
 #include <sound/pcm_params.h>
+#include <sound/pcm_iec958.h>
 #include <sound/dmaengine_pcm.h>
 
 #include "rockchip_spdif.h"
@@ -27,7 +28,25 @@ enum rk_spdif_type {
 	RK_SPDIF_RK3366,
 };
 
-#define RK3288_GRF_SOC_CON2 0x24c
+/*
+ *      |  7  |  6  |  5  |  4  |  3  |  2  |  1  |  0  |
+ * CS0: |   Mode    |        d        |  c  |  b  |  a  |
+ * CS1: |               Category Code                   |
+ * CS2: |    Channel Number     |     Source Number     |
+ * CS3: |    Clock Accuracy     |     Sample Freq       |
+ * CS4: |    Ori Sample Freq    |     Word Length       |
+ * CS5: |                                   |   CGMS-A  |
+ * CS6~CS23: Reserved
+ *
+ * a: use of channel status block
+ * b: linear PCM identification: 0 for lpcm, 1 for nlpcm
+ * c: copyright information
+ * d: additional format information
+ */
+#define CS_BYTE			6
+#define CS_FRAME(c)		((c) << 16 | (c))
+
+#define RK3288_GRF_SOC_CON2	0x24c
 
 struct rk_spdif_dev {
 	struct device *dev;
@@ -112,8 +131,20 @@ static int rk_spdif_hw_params(struct snd_pcm_substream *substream,
 	struct rk_spdif_dev *spdif = snd_soc_dai_get_drvdata(dai);
 	unsigned int mclk_rate = clk_get_rate(spdif->mclk);
 	unsigned int val = SPDIF_CFGR_HALFWORD_ENABLE;
-	int bmc, div;
-	int ret;
+	int bmc, div, ret, i;
+	u16 *fc;
+	u8 cs[CS_BYTE];
+
+	ret = snd_pcm_create_iec958_consumer_hw_params(params, cs, sizeof(cs));
+	if (ret < 0)
+		return ret;
+
+	fc = (u16 *)cs;
+	for (i = 0; i < CS_BYTE / 2; i++)
+		regmap_write(spdif->regmap, SPDIF_CHNSRn(i), CS_FRAME(fc[i]));
+
+	regmap_update_bits(spdif->regmap, SPDIF_CFGR, SPDIF_CFGR_CSE_MASK,
+			   SPDIF_CFGR_CSE_EN);
 
 	/* bmc = 128fs */
 	bmc = 128 * params_rate(params);
@@ -267,6 +298,9 @@ static bool rk_spdif_wr_reg(struct device *dev, unsigned int reg)
 	case SPDIF_INTCR:
 	case SPDIF_XFER:
 	case SPDIF_SMPDR:
+	case SPDIF_VLDFRn(0) ... SPDIF_VLDFRn(11):
+	case SPDIF_USRDRn(0) ... SPDIF_USRDRn(11):
+	case SPDIF_CHNSRn(0) ... SPDIF_CHNSRn(11):
 		return true;
 	default:
 		return false;
@@ -282,6 +316,9 @@ static bool rk_spdif_rd_reg(struct device *dev, unsigned int reg)
 	case SPDIF_INTSR:
 	case SPDIF_XFER:
 	case SPDIF_SMPDR:
+	case SPDIF_VLDFRn(0) ... SPDIF_VLDFRn(11):
+	case SPDIF_USRDRn(0) ... SPDIF_USRDRn(11):
+	case SPDIF_CHNSRn(0) ... SPDIF_CHNSRn(11):
 		return true;
 	default:
 		return false;
@@ -304,7 +341,7 @@ static const struct regmap_config rk_spdif_regmap_config = {
 	.reg_bits = 32,
 	.reg_stride = 4,
 	.val_bits = 32,
-	.max_register = SPDIF_SMPDR,
+	.max_register = SPDIF_VERSION,
 	.writeable_reg = rk_spdif_wr_reg,
 	.readable_reg = rk_spdif_rd_reg,
 	.volatile_reg = rk_spdif_volatile_reg,
diff --git a/sound/soc/rockchip/rockchip_spdif.h b/sound/soc/rockchip/rockchip_spdif.h
index acf64986a2e09..b837b1f8d57f3 100644
--- a/sound/soc/rockchip/rockchip_spdif.h
+++ b/sound/soc/rockchip/rockchip_spdif.h
@@ -21,6 +21,10 @@
 #define SPDIF_CFGR_CLR_EN		BIT(7)
 #define SPDIF_CFGR_CLR_DIS		0
 
+#define SPDIF_CFGR_CSE_MASK		BIT(6)
+#define SPDIF_CFGR_CSE_EN		BIT(6)
+#define SPDIF_CFGR_CSE_DIS		0
+
 #define SPDIF_CFGR_ADJ_MASK		BIT(3)
 #define SPDIF_CFGR_ADJ_LEFT_J		BIT(3)
 #define SPDIF_CFGR_ADJ_RIGHT_J		0
@@ -64,5 +68,9 @@
 #define SPDIF_INTSR	(0x0010)
 #define SPDIF_XFER	(0x0018)
 #define SPDIF_SMPDR	(0x0020)
+#define SPDIF_VLDFRn(x)	(0x0060 + (x) * 4)
+#define SPDIF_USRDRn(x)	(0x0090 + (x) * 4)
+#define SPDIF_CHNSRn(x)	(0x00c0 + (x) * 4)
+#define SPDIF_VERSION	(0x01c0)
 
 #endif /* _ROCKCHIP_SPDIF_H */
-- 
2.53.0



