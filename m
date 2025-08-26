Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AE0231B139;
	Tue, 26 Aug 2025 11:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208069; cv=none; b=Lcs6zHmPdLnuSFzuOcv2YueNj2dzzbewpxPbPIhTU+5q/ukNEp9xOfP2N9Ct+FKZkrSkqEnP9OPkfsSrQr+RMJfGxdi+a9dWQOmikO2ZnyqNAEahA0BR2ovfAvfihwv66+SRo21eYy0wgCI6cQ3HZhObe7/JcylER58JgCHUuEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208069; c=relaxed/simple;
	bh=8lKLTB5NWzoqx9N6liYTyG/+1TUueqRyIfqEiHf5YeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cc4iaK5DQGVOcn9TWH9zU6f9QWWzHORfaN5dc9+MbsGEbXU/83gcXxr+VDlgRsyVdK20ZyvPeGOuqA46jrgJZvifj7cPZg0Z4+SVDPRdK1OZlFNnIn5Xh0dVI3S9mhCqM/VaukgUPU1pzU5Eg6no431MLGjWJ/aC4nk3E9Wwhco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ADsVEX6a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ADsVEX6a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AA3FC4CEF1;
	Tue, 26 Aug 2025 11:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208068;
	bh=8lKLTB5NWzoqx9N6liYTyG/+1TUueqRyIfqEiHf5YeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ADsVEX6af5gU7h7Yv3MiQGGmbHcnymWrdXNqa467icnql8t0lR3HDF8otkmmdsYnD
	 ugqxra8KbYDqJJ6RnexcNxYh7tsKRlIbsKc4gkr+4xl0IP0SybH1J7ScwQnbFCoMEY
	 jgRNFP8NaY3NUVyXRkYQBVGltqqrge3xZG8arzDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Stefan Binding <sbinding@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 426/457] ASoC: cs35l56: Handle new algorithms IDs for CS35L63
Date: Tue, 26 Aug 2025 13:11:50 +0200
Message-ID: <20250826110947.817962003@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 8dadc11b67d4b83deff45e4889b3b5540b9c0a7f ]

CS35L63 uses different algorithm IDs from CS35L56.
Add a new mechanism to handle different alg IDs between parts in the
CS35L56 driver.

Fixes: 978858791ced ("ASoC: cs35l56: Add initial support for CS35L63 for I2C and SoundWire")

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Signed-off-by: Stefan Binding <sbinding@opensource.cirrus.com>
Link: https://patch.msgid.link/20250820142209.127575-3-sbinding@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/cs35l56.h           |  1 +
 sound/soc/codecs/cs35l56-shared.c | 29 ++++++++++++++++++++++++++---
 sound/soc/codecs/cs35l56.c        |  2 +-
 3 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/include/sound/cs35l56.h b/include/sound/cs35l56.h
index f44aabde805e..7c8bbe8ad1e2 100644
--- a/include/sound/cs35l56.h
+++ b/include/sound/cs35l56.h
@@ -306,6 +306,7 @@ struct cs35l56_base {
 	struct gpio_desc *reset_gpio;
 	struct cs35l56_spi_payload *spi_payload_buf;
 	const struct cs35l56_fw_reg *fw_reg;
+	const struct cirrus_amp_cal_controls *calibration_controls;
 };
 
 static inline bool cs35l56_is_otp_register(unsigned int reg)
diff --git a/sound/soc/codecs/cs35l56-shared.c b/sound/soc/codecs/cs35l56-shared.c
index ba653f6ccfae..850fcf385996 100644
--- a/sound/soc/codecs/cs35l56-shared.c
+++ b/sound/soc/codecs/cs35l56-shared.c
@@ -838,6 +838,15 @@ const struct cirrus_amp_cal_controls cs35l56_calibration_controls = {
 };
 EXPORT_SYMBOL_NS_GPL(cs35l56_calibration_controls, "SND_SOC_CS35L56_SHARED");
 
+static const struct cirrus_amp_cal_controls cs35l63_calibration_controls = {
+	.alg_id =	0xbf210,
+	.mem_region =	WMFW_ADSP2_YM,
+	.ambient =	"CAL_AMBIENT",
+	.calr =		"CAL_R",
+	.status =	"CAL_STATUS",
+	.checksum =	"CAL_CHECKSUM",
+};
+
 int cs35l56_get_calibration(struct cs35l56_base *cs35l56_base)
 {
 	u64 silicon_uid = 0;
@@ -912,19 +921,31 @@ EXPORT_SYMBOL_NS_GPL(cs35l56_read_prot_status, "SND_SOC_CS35L56_SHARED");
 void cs35l56_log_tuning(struct cs35l56_base *cs35l56_base, struct cs_dsp *cs_dsp)
 {
 	__be32 pid, sid, tid;
+	unsigned int alg_id;
 	int ret;
 
+	switch (cs35l56_base->type) {
+	case 0x54:
+	case 0x56:
+	case 0x57:
+		alg_id = 0x9f212;
+		break;
+	default:
+		alg_id = 0xbf212;
+		break;
+	}
+
 	scoped_guard(mutex, &cs_dsp->pwr_lock) {
 		ret = cs_dsp_coeff_read_ctrl(cs_dsp_get_ctl(cs_dsp, "AS_PRJCT_ID",
-							    WMFW_ADSP2_XM, 0x9f212),
+							    WMFW_ADSP2_XM, alg_id),
 					     0, &pid, sizeof(pid));
 		if (!ret)
 			ret = cs_dsp_coeff_read_ctrl(cs_dsp_get_ctl(cs_dsp, "AS_CHNNL_ID",
-								    WMFW_ADSP2_XM, 0x9f212),
+								    WMFW_ADSP2_XM, alg_id),
 						     0, &sid, sizeof(sid));
 		if (!ret)
 			ret = cs_dsp_coeff_read_ctrl(cs_dsp_get_ctl(cs_dsp, "AS_SNPSHT_ID",
-								    WMFW_ADSP2_XM, 0x9f212),
+								    WMFW_ADSP2_XM, alg_id),
 						     0, &tid, sizeof(tid));
 	}
 
@@ -974,8 +995,10 @@ int cs35l56_hw_init(struct cs35l56_base *cs35l56_base)
 	case 0x35A54:
 	case 0x35A56:
 	case 0x35A57:
+		cs35l56_base->calibration_controls = &cs35l56_calibration_controls;
 		break;
 	case 0x35A630:
+		cs35l56_base->calibration_controls = &cs35l63_calibration_controls;
 		devid = devid >> 4;
 		break;
 	default:
diff --git a/sound/soc/codecs/cs35l56.c b/sound/soc/codecs/cs35l56.c
index 1b42586794ad..76306282b2e6 100644
--- a/sound/soc/codecs/cs35l56.c
+++ b/sound/soc/codecs/cs35l56.c
@@ -695,7 +695,7 @@ static int cs35l56_write_cal(struct cs35l56_private *cs35l56)
 		return ret;
 
 	ret = cs_amp_write_cal_coeffs(&cs35l56->dsp.cs_dsp,
-				      &cs35l56_calibration_controls,
+				      cs35l56->base.calibration_controls,
 				      &cs35l56->base.cal_data);
 
 	wm_adsp_stop(&cs35l56->dsp);
-- 
2.50.1



