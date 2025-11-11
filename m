Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B9212D94B0;
	Tue, 11 Nov 2025 01:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825267; cv=none; b=lFGFHc8Mf4x5CFpcGe9Oasxgcmj8mCLhZvW+YmV7bVK9ZZ9pRw8s/R3A3m2uxulcodNBtxT0MnoYtBm3tVQVdMINLsaD/rzGUZQan8l1s8+9O8WKr19ePB4JClsGwz6gsuZm+v+pgJDvW1gKyKh5rzEd4LAbNJaP6/TeC8nPGW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825267; c=relaxed/simple;
	bh=QCdryK6mmrYVhoyEiXz+6DUnvrONH4UdEYnG0FQb4P0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rtfQ30QFcOBwqMYc8+0t2kt6PSXNm2ybzV0dnyXOUE7WGi1/PIMgCJ9MkPVvvKXQwvJHRb4mDRyckXU6l+RunZuMwBZ7iATId4n8BUghmzRAi4UsxYGRZTjlSP08M1OEFsc4XkJIRbWI82rx+orRUWAuvVVFviaipDsDQlvt7X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=foGv8qrS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="foGv8qrS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FDA8C4CEF5;
	Tue, 11 Nov 2025 01:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825264;
	bh=QCdryK6mmrYVhoyEiXz+6DUnvrONH4UdEYnG0FQb4P0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=foGv8qrSfNrEw+PqsI6za2OyJoZH/bXGH9ws7LFuzU/mfyjDFc7s+Kxg3v73yfeC8
	 iWyMIiGVJIUV4pYByfPtRly4saH6+lGJBp0QIlitgvQRiYo2ZbvHb4L/kwx3nS5nbE
	 3T5NMu2r14oTBO5+NgNcTyvZSDvvFZXmOaC75oUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuming Fan <shumingf@realtek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 730/849] ASoC: rt722: add settings for rt722VB
Date: Tue, 11 Nov 2025 09:45:00 +0900
Message-ID: <20251111004554.085930147@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

From: Shuming Fan <shumingf@realtek.com>

[ Upstream commit a27539810e1e61efcfdeb51777ed875dc61e9d49 ]

This patch adds settings for RT722VB.

Signed-off-by: Shuming Fan <shumingf@realtek.com>
Link: https://patch.msgid.link/20251007080950.1999411-1-shumingf@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
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



