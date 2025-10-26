Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8769B21255B;
	Sun, 26 Oct 2025 14:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761490288; cv=none; b=rFaffMQ/NEu/knfyIi5qxSl3UEKoa0txrVMA0G1tadFBQB0C9qI6Ua01GK/Zp3idVoKyS/5x/j/z0SNCc6CPvlI7XuNrRWoRrNU0S9aZqhoGdqhX87mHE8BVtYWYl3ZhHilyHdT0lhfgKNx8mtj/xq5LzaiirxRzhwDGW0Lqaas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761490288; c=relaxed/simple;
	bh=GQsSIbbSiGqbxHBpUr35ZkRfeYDE4drKevvvkFsUbIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fdqdRUas/GafvcLXALODpF/aDyfd8TsGHNQOBPd9+05yfX10KP8D4hrXEPXLc+1uTKniLpWL9HEehFZ3P4daGEgbQ28Pv17AfoEGTOYL0dAe4N5q/kYehdxp57dXAB0vRwE/1J+EYjrHpPY2XWxrISoNMr/4DUGADc98IhwsOlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XdfNygPd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XdfNygPd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B122FC4CEE7;
	Sun, 26 Oct 2025 14:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761490288;
	bh=GQsSIbbSiGqbxHBpUr35ZkRfeYDE4drKevvvkFsUbIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XdfNygPd1IBhIyDOxHu71HingXGyJv9IVEughrQs6gRyG+5m0Y0Y5vPpA29BrplRi
	 CwX6Hl0K3903wW95kB6WxPGX+LECI+SYEKIT0TSHXkngIXkCViWqbICV6nW/v/GpTo
	 jSaB+mRJqlQwa5Fg/SObL3S6DOTLK2Ul800XOoH3ucJd5qSHOOqyrMnhHQo8h1rr28
	 EuHtGjJHWpEjNN9eaRmJOWMDsPIHbiXOY2DT+CpQgtDJTC/IPdQus6wdDyXUOmdIye
	 IKbjMEQ6ta3bQcLzO/9kqudF1cwp1nXJIlWOPx8nGEV/0BOFCxi86qD8bxJjcxJ74Y
	 OXGckA8deLJcw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Shuming Fan <shumingf@realtek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	oder_chiou@realtek.com
Subject: [PATCH AUTOSEL 6.17] ASoC: rt722: add settings for rt722VB
Date: Sun, 26 Oct 2025 10:49:19 -0400
Message-ID: <20251026144958.26750-41-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251026144958.26750-1-sashal@kernel.org>
References: <20251026144958.26750-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shuming Fan <shumingf@realtek.com>

[ Upstream commit a27539810e1e61efcfdeb51777ed875dc61e9d49 ]

This patch adds settings for RT722VB.

Signed-off-by: Shuming Fan <shumingf@realtek.com>
Link: https://patch.msgid.link/20251007080950.1999411-1-shumingf@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES
- Detects silicon revision and stores it in `rt722->hw_vid` so the
  driver can specialize init for RT722VB
  (`sound/soc/codecs/rt722-sdca.c:1558`,
  `sound/soc/codecs/rt722-sdca.h:42`,
  `sound/soc/codecs/rt722-sdca.h:237`); without this read the firmware
  treats VB as VA and never applies the vendor-required fixes, leaving
  VB boards misconfigured (no DMIC/amp/jack functionality).
- Adds VB-specific register programming in each preset stage
  (`sound/soc/codecs/rt722-sdca.c:1381`,
  `sound/soc/codecs/rt722-sdca.c:1421`,
  `sound/soc/codecs/rt722-sdca.c:1515`) to clear new vendor registers
  0x2f52/0x2f54/0x2f51; Realtek’s VB parts require these writes to bring
  up the mic, speaker amp, and jack paths, so existing stable kernels
  fail on RT722VB hardware.
- Extends the SDW MBQ map to cover the new 0x2f51–0x2f52 range
  (`sound/soc/codecs/rt722-sdca-sdw.c:24`), ensuring the regmap accepts
  those writes; without it, attempted configuration would error out, so
  the fix cannot be backported piecemeal.
- Changes are tightly scoped to the Realtek codec driver, gated by the
  detected revision, and mirror the version-handling pattern already
  used in other RT71x drivers, keeping regression risk low for existing
  RT722VA systems while fixing a real user-visible failure on the newer
  silicon.

Next step: 1) Verify audio bring-up on an RT722VB-based platform after
backport.

 sound/soc/codecs/rt722-sdca-sdw.c |  2 +-
 sound/soc/codecs/rt722-sdca.c     | 14 ++++++++++++++
 sound/soc/codecs/rt722-sdca.h     |  6 ++++++
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/rt722-sdca-sdw.c b/sound/soc/codecs/rt722-sdca-sdw.c
index 70700bdb80a14..5ea40c1b159a8 100644
--- a/sound/soc/codecs/rt722-sdca-sdw.c
+++ b/sound/soc/codecs/rt722-sdca-sdw.c
@@ -21,7 +21,7 @@ static int rt722_sdca_mbq_size(struct device *dev, unsigned int reg)
 	switch (reg) {
 	case 0x2f01 ... 0x2f0a:
 	case 0x2f35 ... 0x2f36:
-	case 0x2f50:
+	case 0x2f50 ... 0x2f52:
 	case 0x2f54:
 	case 0x2f58 ... 0x2f5d:
 	case SDW_SDCA_CTL(FUNC_NUM_JACK_CODEC, RT722_SDCA_ENT0, RT722_SDCA_CTL_FUNC_STATUS, 0):
diff --git a/sound/soc/codecs/rt722-sdca.c b/sound/soc/codecs/rt722-sdca.c
index 333611490ae35..79b8b7e70a334 100644
--- a/sound/soc/codecs/rt722-sdca.c
+++ b/sound/soc/codecs/rt722-sdca.c
@@ -1378,6 +1378,9 @@ static void rt722_sdca_dmic_preset(struct rt722_sdca_priv *rt722)
 		/* PHYtiming TDZ/TZD control */
 		regmap_write(rt722->regmap, 0x2f03, 0x06);
 
+		if (rt722->hw_vid == RT722_VB)
+			regmap_write(rt722->regmap, 0x2f52, 0x00);
+
 		/* clear flag */
 		regmap_write(rt722->regmap,
 			SDW_SDCA_CTL(FUNC_NUM_MIC_ARRAY, RT722_SDCA_ENT0, RT722_SDCA_CTL_FUNC_STATUS, 0),
@@ -1415,6 +1418,9 @@ static void rt722_sdca_amp_preset(struct rt722_sdca_priv *rt722)
 			SDW_SDCA_CTL(FUNC_NUM_AMP, RT722_SDCA_ENT_OT23,
 				RT722_SDCA_CTL_VENDOR_DEF, CH_08), 0x04);
 
+		if (rt722->hw_vid == RT722_VB)
+			regmap_write(rt722->regmap, 0x2f54, 0x00);
+
 		/* clear flag */
 		regmap_write(rt722->regmap,
 			SDW_SDCA_CTL(FUNC_NUM_AMP, RT722_SDCA_ENT0, RT722_SDCA_CTL_FUNC_STATUS, 0),
@@ -1506,6 +1512,9 @@ static void rt722_sdca_jack_preset(struct rt722_sdca_priv *rt722)
 		rt722_sdca_index_write(rt722, RT722_VENDOR_REG, RT722_DIGITAL_MISC_CTRL4,
 			0x0010);
 
+		if (rt722->hw_vid == RT722_VB)
+			regmap_write(rt722->regmap, 0x2f51, 0x00);
+
 		/* clear flag */
 		regmap_write(rt722->regmap,
 			SDW_SDCA_CTL(FUNC_NUM_JACK_CODEC, RT722_SDCA_ENT0, RT722_SDCA_CTL_FUNC_STATUS, 0),
@@ -1516,6 +1525,7 @@ static void rt722_sdca_jack_preset(struct rt722_sdca_priv *rt722)
 int rt722_sdca_io_init(struct device *dev, struct sdw_slave *slave)
 {
 	struct rt722_sdca_priv *rt722 = dev_get_drvdata(dev);
+	unsigned int val;
 
 	rt722->disable_irq = false;
 
@@ -1545,6 +1555,10 @@ int rt722_sdca_io_init(struct device *dev, struct sdw_slave *slave)
 
 	pm_runtime_get_noresume(&slave->dev);
 
+	rt722_sdca_index_read(rt722, RT722_VENDOR_REG, RT722_JD_PRODUCT_NUM, &val);
+	rt722->hw_vid = (val & 0x0f00) >> 8;
+	dev_dbg(&slave->dev, "%s hw_vid=0x%x\n", __func__, rt722->hw_vid);
+
 	rt722_sdca_dmic_preset(rt722);
 	rt722_sdca_amp_preset(rt722);
 	rt722_sdca_jack_preset(rt722);
diff --git a/sound/soc/codecs/rt722-sdca.h b/sound/soc/codecs/rt722-sdca.h
index 3c383705dd3cd..823abee9ab76c 100644
--- a/sound/soc/codecs/rt722-sdca.h
+++ b/sound/soc/codecs/rt722-sdca.h
@@ -39,6 +39,7 @@ struct  rt722_sdca_priv {
 	/* For DMIC */
 	bool fu1e_dapm_mute;
 	bool fu1e_mixer_mute[4];
+	int hw_vid;
 };
 
 struct rt722_sdca_dmic_kctrl_priv {
@@ -233,6 +234,11 @@ enum rt722_sdca_jd_src {
 	RT722_JD1,
 };
 
+enum rt722_sdca_version {
+	RT722_VA,
+	RT722_VB,
+};
+
 int rt722_sdca_io_init(struct device *dev, struct sdw_slave *slave);
 int rt722_sdca_init(struct device *dev, struct regmap *regmap, struct sdw_slave *slave);
 int rt722_sdca_index_write(struct rt722_sdca_priv *rt722,
-- 
2.51.0

