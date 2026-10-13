Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B16114F30F2;
	Tue, 13 Oct 2026 11:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892693; cv=none; b=eLcQwpNSfvTOxovPn57jmdRiJoIsCJy+xWEpmsRWxOpPccPVlkRvg1GbDEFvjDFioWZ1TK65XDmatagwiKv/AevCqXgsQD05qz+Qkpls/wI8eqWvZZlsQxqC2PGMsw9rklIm9BZXnpMDLEQ5UHh9Rzi4HmpV+9fOn3y6K+lT9wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892693; c=relaxed/simple;
	bh=sZmEkOa5iSAPmagminm7+J+ZAPrFxWrna9IcWJ9iOng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EXjO00dL1W2HlRTgjkZzFSF+u9ntYLpat81sqvJ2Hfogy6qHqFYKL+b7R9wGJqmRHWWJh5DO5WGqAMWJsCj6YLMUJ9S1FPkaIJe7dWMxm8xsiFXaORhf110YSyK16zfEWqwSeSHa+pwSr3nqptqqE5ijGZrSS5qyS+BPh8X9CMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jY4EkRfh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jY4EkRfh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4E361F000FF;
	Tue, 13 Oct 2026 11:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892692;
	bh=5rUz5ataM9le+2dwzMFF9hAj3OpSt4NeuoT5pbzCbn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jY4EkRfhFPsW+6x/8qCIh8UyFwx2Bp7c9sJlYf41CtVzwx1LW1m121lFt5Ufvm61+
	 OTiHrHzShhhPOTff5b/fP2MEgktN8BgeDdYB3JbB2I7tcHSrIkws5841I8WIvX74oA
	 1UH/yYJ/f1OVqYjcwPUzEmi7qqYE6fMCLd4sKy1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Binding <sbinding@opensource.cirrus.com>,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 256/281] ASoC: sdw_utils: Add codec info for CS35L62
Date: Tue, 13 Oct 2026 13:39:32 +0200
Message-ID: <20261013112901.354680991@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Binding <sbinding@opensource.cirrus.com>

[ Upstream commit 0306d211558196e051b83e067ee4c30e1b6f94a8 ]

CS35L62 is very similar to CS35L63, and uses the same driver, so we
can use the same configuration.

Signed-off-by: Stefan Binding <sbinding@opensource.cirrus.com>
Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://patch.msgid.link/20260715120135.939280-3-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 4b7f393a01f8 ("ASoC: sdw_utils: Switch CS35L56/57/62/63 to use OT25 DAI")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sdw_utils/soc_sdw_utils.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/sound/soc/sdw_utils/soc_sdw_utils.c b/sound/soc/sdw_utils/soc_sdw_utils.c
index 5266720e58b3c..2570f40673bdf 100644
--- a/sound/soc/sdw_utils/soc_sdw_utils.c
+++ b/sound/soc/sdw_utils/soc_sdw_utils.c
@@ -834,6 +834,35 @@ struct asoc_sdw_codec_info codec_info_list[] = {
 		},
 		.dai_num = 2,
 	},
+	{
+		.vendor_id = 0x01fa,
+		.part_id = 0x3562,
+		.name_prefix = "AMP",
+		.is_amp = true,
+		.dais = {
+			{
+				.direction = {true, false},
+				.dai_name = "cs35l56-sdw1",
+				.component_name = "cs35l56",
+				.dai_type = SOC_SDW_DAI_TYPE_AMP,
+				.dailink = {SOC_SDW_AMP_OUT_DAI_ID, SOC_SDW_UNUSED_DAI_ID},
+				.init = asoc_sdw_cs_amp_init,
+				.rtd_init = asoc_sdw_cs_spk_rtd_init,
+				.controls = generic_spk_controls,
+				.num_controls = ARRAY_SIZE(generic_spk_controls),
+				.widgets = generic_spk_widgets,
+				.num_widgets = ARRAY_SIZE(generic_spk_widgets),
+			},
+			{
+				.direction = {false, true},
+				.dai_name = "cs35l56-sdw1c",
+				.dai_type = SOC_SDW_DAI_TYPE_AMP,
+				.dailink = {SOC_SDW_UNUSED_DAI_ID, SOC_SDW_AMP_IN_DAI_ID},
+				.rtd_init = asoc_sdw_cs_spk_feedback_rtd_init,
+			},
+		},
+		.dai_num = 2,
+	},
 	{
 		.vendor_id = 0x01fa,
 		.part_id = 0x3563,
-- 
2.53.0



