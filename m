Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621517;
	b=lbh4KwldnGErxabIicwc777tywadgvEdWJxx2JB6QlIMLioRf37rg6DKhHHvKdCQmp7+
	 1KJBD4sQvzFw5N+B0PKLm3CaQA21GQtnXcyGWWHY80Qu5xwmSBNVRS7rKz9WyovHh23Hy
	 Asb1EhFy/rI6KrL1Q4AtO+1iSSPR3OebbOIA6ux0U2zBgOr4Qew+wH/K6DrZnQb7TrgrO
	 oxzkUXqPUiMkfiDOrAuUt7f3kB8/QfuWPZ8tl6AXSjzP/cav6ip2aOUYUGpTGWbfr9vDe
	 6aByd3ErBGp6J/TX63TAmH0Mbr8wWxaQ4BS4LI0jDxIUwMRsyvpq4k7Ve7cNGzu8Zhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621517;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EyC3qnjQyDrS668BU2bnjeWHiV3JcygDUkpIJVpc0t8=;
	b=Dje4ydthY5EhlTlcBxE6xu0KtMFO8d2qDD+1cUPQuuvmGBLX3UpNMwckaLw94sVpm/W5
	 0iqICtD1NR1LkBAxj7GCLD9dnCRhu3dvaqiw5D3wPu3EjGBpvCkc6jhAOI/Ig77onQXvF
	 hxAVunIZEnILxF0UuwOeEnptGhS5E0OYvouc+A8nCAVIkZW68R6VBMgG0jPeMPqtg1Sez
	 7bNtTjULGfcpE/WMYGQyEC+ofqE6rEfe3u/+YXb1zIKqE6EIUzU73vpH98LhgPFdJV9gL
	 56O7eSzqBEDZSMzdqKdwyQmD8JQ7Jy9s6G8hxKc4yfGaXIbPdI7QggOGXaq2o4Stvcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KVHdGxbs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A604606A323;
	Wed, 25 Nov 2026 15:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KVHdGxbs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAFF61F000C0;
	Wed, 25 Nov 2026 15:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621517;
	bh=EyC3qnjQyDrS668BU2bnjeWHiV3JcygDUkpIJVpc0t8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KVHdGxbsgbaQaqIrK2UPE3hK2AYlv3EVMO8ot45cd/rF6OT9qZgtMOMGgl9eD9SUm
	 x3Vd+Zp+ewOHWoazbVvRYJBbKNmYG4GZMAVuEeVJ1/9X/pjxifFuTyDrvx6zCbz+yV
	 lU1GBccDETpy+o6vS1LGlxFlC6TjWoHG6Zlb9sms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zohn Ni <zohn.ni@rock-chips.com>,
	Sugar Zhang <sugar.zhang@rock-chips.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 248/990] ASoC: rockchip: spdif: Add support for format S32_LE
Date: Wed, 25 Nov 2026 15:26:55 +0100
Message-ID: <20261125143827.900410395@linuxfoundation.org>
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

[ Upstream commit c43ec509019842c0b836e858dc486c216b51b087 ]

Treat 32 bit sample width as if it was 24 bits using only the
24 most significant bits.

[I've merged the channel-swapping fix from Zohn Ni into Sugar Zhang's
patch introducing the problem in the first place]

Co-developed-by: Zohn Ni <zohn.ni@rock-chips.com>
Signed-off-by: Zohn Ni <zohn.ni@rock-chips.com>
Signed-off-by: Sugar Zhang <sugar.zhang@rock-chips.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Link: https://patch.msgid.link/20260203-rockchip-spdif-cleanup-and-bsp-sync-v2-8-4412016cf577@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 67a7e2073909 ("ASoC: rockchip_spdif: select REGMAP_MMIO")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/rockchip/rockchip_spdif.c | 22 ++++++++++++++++++++--
 sound/soc/rockchip/rockchip_spdif.h |  8 ++++++++
 2 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/sound/soc/rockchip/rockchip_spdif.c b/sound/soc/rockchip/rockchip_spdif.c
index cf6935dc40f2b..7acc6408a5245 100644
--- a/sound/soc/rockchip/rockchip_spdif.c
+++ b/sound/soc/rockchip/rockchip_spdif.c
@@ -123,21 +123,38 @@ static int rk_spdif_hw_params(struct snd_pcm_substream *substream,
 	switch (params_format(params)) {
 	case SNDRV_PCM_FORMAT_S16_LE:
 		val |= SPDIF_CFGR_VDW_16;
+		val |= SPDIF_CFGR_ADJ_RIGHT_J;
 		break;
 	case SNDRV_PCM_FORMAT_S20_3LE:
 		val |= SPDIF_CFGR_VDW_20;
+		val |= SPDIF_CFGR_ADJ_RIGHT_J;
 		break;
 	case SNDRV_PCM_FORMAT_S24_LE:
 		val |= SPDIF_CFGR_VDW_24;
+		val |= SPDIF_CFGR_ADJ_RIGHT_J;
+		break;
+	case SNDRV_PCM_FORMAT_S32_LE:
+		val |= SPDIF_CFGR_VDW_24;
+		val |= SPDIF_CFGR_ADJ_LEFT_J;
 		break;
 	default:
 		return -EINVAL;
 	}
 
+	/*
+	 * clear MCLK domain logic before setting Fmclk and Fsdo to ensure
+	 * that switching between S16_LE and S32_LE audio does not result
+	 * in accidential channels swap.
+	 */
+	regmap_update_bits(spdif->regmap, SPDIF_CFGR, SPDIF_CFGR_CLR_MASK,
+			   SPDIF_CFGR_CLR_EN);
+	udelay(1);
+
 	ret = regmap_update_bits(spdif->regmap, SPDIF_CFGR,
 				 SPDIF_CFGR_CLK_DIV_MASK |
 				 SPDIF_CFGR_HALFWORD_ENABLE |
-				 SDPIF_CFGR_VDW_MASK, val);
+				 SDPIF_CFGR_VDW_MASK |
+				 SPDIF_CFGR_ADJ_MASK, val);
 
 	return ret;
 }
@@ -231,7 +248,8 @@ static struct snd_soc_dai_driver rk_spdif_dai = {
 			  SNDRV_PCM_RATE_192000),
 		.formats = (SNDRV_PCM_FMTBIT_S16_LE |
 			    SNDRV_PCM_FMTBIT_S20_3LE |
-			    SNDRV_PCM_FMTBIT_S24_LE),
+			    SNDRV_PCM_FMTBIT_S24_LE |
+			    SNDRV_PCM_FMTBIT_S32_LE),
 	},
 	.ops = &rk_spdif_dai_ops,
 };
diff --git a/sound/soc/rockchip/rockchip_spdif.h b/sound/soc/rockchip/rockchip_spdif.h
index fcc28b6c4f586..acf64986a2e09 100644
--- a/sound/soc/rockchip/rockchip_spdif.h
+++ b/sound/soc/rockchip/rockchip_spdif.h
@@ -17,6 +17,14 @@
 #define SPDIF_CFGR_CLK_DIV_MASK		(0xff << SPDIF_CFGR_CLK_DIV_SHIFT)
 #define SPDIF_CFGR_CLK_DIV(x)		((x-1) << SPDIF_CFGR_CLK_DIV_SHIFT)
 
+#define SPDIF_CFGR_CLR_MASK		BIT(7)
+#define SPDIF_CFGR_CLR_EN		BIT(7)
+#define SPDIF_CFGR_CLR_DIS		0
+
+#define SPDIF_CFGR_ADJ_MASK		BIT(3)
+#define SPDIF_CFGR_ADJ_LEFT_J		BIT(3)
+#define SPDIF_CFGR_ADJ_RIGHT_J		0
+
 #define SPDIF_CFGR_HALFWORD_SHIFT	2
 #define SPDIF_CFGR_HALFWORD_DISABLE	(0 << SPDIF_CFGR_HALFWORD_SHIFT)
 #define SPDIF_CFGR_HALFWORD_ENABLE	(1 << SPDIF_CFGR_HALFWORD_SHIFT)
-- 
2.53.0



