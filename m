Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D95B4C3A0;
	Mon,  8 Jan 2024 15:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dPS68nEm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD3AEC433C7;
	Mon,  8 Jan 2024 15:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728365;
	bh=rzEB0b+K99K8eyyvQkF/AFFXoQHrvUM6i4aGKVnbXT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dPS68nEmJNdYxSn6vq3aCbQz/uEsWTkuNQu5T51ZEzo5p+9ehawvbdQpVUmZgWehc
	 35t+XVIF8prfxLTFjbU+7yVv1VunPod2+UMkFebRUil342SSw6VfrwEvekEIWoYsZC
	 5f5DgYeBb6fDuri7PKBRizAQo/2zhPX220wZIPxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eugen Hristev <eugen.hristev@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 026/150] ASoC: mediatek: mt8186: fix AUD_PAD_TOP register and offset
Date: Mon,  8 Jan 2024 16:34:37 +0100
Message-ID: <20240108153512.476860205@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108153511.214254205@linuxfoundation.org>
References: <20240108153511.214254205@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 094402470dc23..858b95b199dcb 100644
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



