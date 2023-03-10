Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62EAA8820
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:52:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5B5DC4339C;
	Fri, 10 Mar 2023 14:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678459925;
	bh=OQP5N8N26CM8/YoXTaCEiLPv8c1O8CRX1Q8EbwkqysM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pKu4hAmUlP+kKuKqYV8tA+AuLMJmOTf9ToqQCaJWB+puoapl/nFRg04ndjo7qGMZF
	 CTmX3v/q7Caseb377S+XzPfyUyi82hdjVEENQpPyZW8b13aotTPYEbFDCh7BMlzWAN
	 WCTPL98NUQonV55c11ixW9On3iqOEJbJ6Mc+rwYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Iuliana Prodan <iuliana.prodan@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 166/529] ASoC: fsl_sai: initialize is_dsp_mode flag
Date: Fri, 10 Mar 2023 14:35:09 +0100
Message-Id: <20230310133812.635269526@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit a23924b7dd7b748fff8e305e1daf590fed2af21b ]

Initialize is_dsp_mode flag in the beginning of function
fsl_sai_set_dai_fmt_tr().

When the DAIFMT is DAIFMT_DSP_B the first time, is_dsp_mode is
true, then the second time DAIFMT is DAIFMT_I2S, is_dsp_mode
still true, which is a wrong state. So need to initialize
is_dsp_mode flag every time.

Fixes: a3f7dcc9cc03 ("ASoC: fsl-sai: Add SND_SOC_DAIFMT_DSP_A/B support.")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Reviewed-by: Iuliana Prodan <iuliana.prodan@nxp.com>
Link: https://lore.kernel.org/r/1673852874-32200-1-git-send-email-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_sai.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
index 3e5c1eaccd5e7..6a5d2b08e2713 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -230,6 +230,7 @@ static int fsl_sai_set_dai_fmt_tr(struct snd_soc_dai *cpu_dai,
 	if (!sai->is_lsb_first)
 		val_cr4 |= FSL_SAI_CR4_MF;
 
+	sai->is_dsp_mode = false;
 	/* DAI mode */
 	switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
 	case SND_SOC_DAIFMT_I2S:
-- 
2.39.2



