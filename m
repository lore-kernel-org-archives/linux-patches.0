Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8550C4BA96;
	Mon,  8 Jan 2024 15:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m2qi4wf4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1C97C433CA;
	Mon,  8 Jan 2024 15:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704726644;
	bh=RTGFR1R1ycPC/MEJEmSWX2lcDC1oKiV9f5qGG6sPHx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m2qi4wf4wIrB4yOMs59SXUASvVhGPONzlKvQhFOeh5BfiNnp3maDRxLXmKwNOELEi
	 Ei2FjEFFnE5EuoLhh/h/PxWe3L3SZa591MIRUAZLbstYujXngXlGQTPtROJ+pd8o1T
	 ysZ2Jb4i4RFUlMuSVqkZLhJpsHzG3l6i+kIyrXpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eugen Hristev <eugen.hristev@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 033/124] ASoC: mediatek: mt8186: fix AUD_PAD_TOP register and offset
Date: Mon,  8 Jan 2024 16:07:39 +0100
Message-ID: <20240108150604.498479809@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
References: <20240108150602.976232871@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eugen Hristev <eugen.hristev@collabora.com>

[ Upstream commit 38744c3fa00109c51076121c2deb4f02e2f09194 ]

AUD_PAD_TOP widget's correct register is AFE_AUD_PAD_TOP , and not zero.
Having a zero as register, it would mean that the `snd_soc_dapm_new_widgets`
would try to read the register at offset zero when trying to get the power
status of this widget, which is incorrect.

Fixes: b65c466220b3 ("ASoC: mediatek: mt8186: support adda in platform driver")
Signed-off-by: Eugen Hristev <eugen.hristev@collabora.com>
Link: https://lore.kernel.org/r/20231229114342.195867-1-eugen.hristev@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8186/mt8186-dai-adda.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/mediatek/mt8186/mt8186-dai-adda.c b/sound/soc/mediatek/mt8186/mt8186-dai-adda.c
index 247ab8df941f7..ab61e597c9a0f 100644
--- a/sound/soc/mediatek/mt8186/mt8186-dai-adda.c
+++ b/sound/soc/mediatek/mt8186/mt8186-dai-adda.c
@@ -499,7 +499,7 @@ static const struct snd_soc_dapm_widget mtk_dai_adda_widgets[] = {
 			      SND_SOC_DAPM_PRE_PMU | SND_SOC_DAPM_POST_PMD),
 
 	SND_SOC_DAPM_SUPPLY_S("AUD_PAD_TOP", SUPPLY_SEQ_ADDA_AUD_PAD_TOP,
-			      0, 0, 0,
+			      AFE_AUD_PAD_TOP, RG_RX_FIFO_ON_SFT, 0,
 			      mtk_adda_pad_top_event,
 			      SND_SOC_DAPM_PRE_PMU),
 	SND_SOC_DAPM_SUPPLY_S("ADDA_MTKAIF_CFG", SUPPLY_SEQ_ADDA_MTKAIF_CFG,
-- 
2.43.0



