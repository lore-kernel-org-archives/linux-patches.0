Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD635254852;
	Tue, 29 Apr 2025 18:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950194; cv=none; b=TdP14Q6+xn2o61pXiIjpAcPitaik3M3QBwFFn4LvaGzrO3+/7+XKAcismqt4lIdnZYvlAL/wW5KoVHlO7Zu9eXeGqdSfsCogHDQWE5M5lIDpwVicMaevUHyWsB+8f4dfpKbCxKXw+wRuVJ7wiRZ1t8LrmsNiD7ng7Qa0sFEhtU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950194; c=relaxed/simple;
	bh=VqTAeDTdrmI9Z1zsplwXpG3REpmtc8ThdgGr5LN1Rm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FNqtbV6219tCsnledgBwvUPO30d52DWi6rU9RVGJxeGuwXzKIo/Sb9S2sRYoKFaKIYj/X+NA+/+tzzuIHAeycN20DMtOwev7etqbL6tXttzZ4RagcB0Du389LhJMs6+9bVJBZKlZhBpILWMrjEwUqw9vwrtEtAWyIyqngZf/+b4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KYg9v6kS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KYg9v6kS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1629C4CEEA;
	Tue, 29 Apr 2025 18:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950194;
	bh=VqTAeDTdrmI9Z1zsplwXpG3REpmtc8ThdgGr5LN1Rm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KYg9v6kSxxzUA3NXNKY1PYpvjgW6X4POwzVVvpozsfDbSsfeGInPexkM4Sg9x8z8k
	 HR8lhtXykzVwwUlW41rP0usGapxur5LDc0YaIqF4bFjRwT5wESmJA+DcgKHOB2CnUg
	 VmXsdeTrI2lOugV2gcj31Ck7sXe+MzJCPQOnALrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 018/204] ASoC: qcom: q6apm-dai: drop unused q6apm_dai_rtd fields
Date: Tue, 29 Apr 2025 18:41:46 +0200
Message-ID: <20250429161100.172590931@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit bd381c9d151467e784988bbacf22bd7ca02455d6 ]

Remove few unused fields from 'struct q6apm_dai_rtd'.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20240430140954.328127-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 3d4a4411aa8b ("ASoC: q6apm-dai: schedule all available frames to avoid dsp under-runs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/qdsp6/q6apm-dai.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/sound/soc/qcom/qdsp6/q6apm-dai.c b/sound/soc/qcom/qdsp6/q6apm-dai.c
index def05ce58d176..5573802e480ba 100644
--- a/sound/soc/qcom/qdsp6/q6apm-dai.c
+++ b/sound/soc/qcom/qdsp6/q6apm-dai.c
@@ -70,14 +70,10 @@ struct q6apm_dai_rtd {
 	unsigned int bytes_received;
 	unsigned int copied_total;
 	uint16_t bits_per_sample;
-	uint16_t source; /* Encoding source bit mask */
-	uint16_t session_id;
 	bool next_track;
 	enum stream_state state;
 	struct q6apm_graph *graph;
 	spinlock_t lock;
-	uint32_t initial_samples_drop;
-	uint32_t trailing_samples_drop;
 	bool notify_on_drain;
 };
 
@@ -721,14 +717,12 @@ static int q6apm_dai_compr_set_metadata(struct snd_soc_component *component,
 
 	switch (metadata->key) {
 	case SNDRV_COMPRESS_ENCODER_PADDING:
-		prtd->trailing_samples_drop = metadata->value[0];
 		q6apm_remove_trailing_silence(component->dev, prtd->graph,
-					      prtd->trailing_samples_drop);
+					      metadata->value[0]);
 		break;
 	case SNDRV_COMPRESS_ENCODER_DELAY:
-		prtd->initial_samples_drop = metadata->value[0];
 		q6apm_remove_initial_silence(component->dev, prtd->graph,
-					     prtd->initial_samples_drop);
+					     metadata->value[0]);
 		break;
 	default:
 		ret = -EINVAL;
-- 
2.39.5



