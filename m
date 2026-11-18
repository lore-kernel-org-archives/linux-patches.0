Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020522;
	b=RTvdi6//eCTPlxmoJHsiOfvg1mCwwq3ACQOgwWXiIe20Xu62m0aRUVzIm8+KwnpijQFR
	 GFXTB02dmqXvM3tUTW7+SiFbDXPMAl/kD03T1i7wB04L4XsUscMXn71zRdk+9beiLBMEF
	 MLtRhW+qmoPB/B16hEMxyVND4bNtgYHeg1dUgJJ7pU/gRayP3S68b4y0EnDXb+duywJj7
	 /kA00SGf6MUprP2NET0f6k74kqs+4JsezikTdAH4gnMlbSR3Pdyzpe56opxtRXwJONI2Q
	 rMcB3cT84z0my71m+GMpVdd3i9tb0cjk3cmJsHKNlZiF0/iAZ7SHvVB4/O9mBxGHfsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020522;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O1tOIQ4BDpgFitdERjhkx8/Salstuml4vx8TG4JyV8o=;
	b=Wv7W8wGmC9tms8Hnsnli/Hkzbkt9iAk38TdPXYLizfW1mxKDOQUlivVB7D8hcRO4U2KT
	 koFyhcgU1g993YGojtitP+nJnADayAaKmQB24+5qRQqqKWVdy35iPRGg50MNyHy3N9q03
	 YI3J/xnUHzQkFRNl5wVZUq8FxwILJ2yiVoSsu8mqgK3ChNv1ocPXz2ye3DklUmg5kGDfn
	 tZkTbrcak06zsDs0NdJN/G2QPwaWL4ogZqpAZF4J8AQBqsQv3DUfALi+D86pA6KE0D+ou
	 Xj0GWm31qy+jdP6jG/DjnZsh1EA8fHPi4SLcVpWDrT7X2wkKKPJIuKYR6p3oFfQwLzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aiXZDf98;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 256C3606A31C;
	Wed, 18 Nov 2026 16:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aiXZDf98
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 757CB1F000C5;
	Wed, 18 Nov 2026 16:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020522;
	bh=O1tOIQ4BDpgFitdERjhkx8/Salstuml4vx8TG4JyV8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aiXZDf98XQEfE2BQ/bygvAkjl4zhZGMWe54TE//xwE2XtvdPaxtgc8+1UcRZ0YzE3
	 IJfpXTyXX3DCh6z6/Y2xY61nZg2foeOxZhbDQsFuvBlCNj+AinZDAztA3BELsXtiTi
	 +T5cjuh/QJKVY/4w8EbJBLDXLt9kFQfOOPjNlyyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Auer <mick@yoxcu.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1982/2651] ASoC: qcom: sdm845: Disable the quaternary MI2S bit clock on shutdown
Date: Wed, 18 Nov 2026 15:53:42 +0100
Message-ID: <20261118150357.760438642@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Auer <mick@yoxcu.de>

[ Upstream commit cef5d087d6813d4c15847d0b71ecbd6c47c5f1d4 ]

sdm845_snd_startup() enables the quaternary MI2S bit clock in the ADSP,
but sdm845_snd_shutdown() never disables it. After the first stream on
this port the clock stays on.

On the OnePlus 6 the speaker amplifier is on this port. After the first
playback the ADSP no longer power collapses: it slept under 9 s in 5
hours. With this change it sleeps again when audio is idle (about 40 s
of 45 s).

Refcount the clock like the other MI2S and TDM ports and disable it
when the last user is gone.

Fixes: 5caf64c633a3 ("ASoC: qcom: sdm845: add support to DB845c and Lenovo Yoga")
Assisted-by: LLM
Signed-off-by: Michael Auer <mick@yoxcu.de>
Link: https://patch.msgid.link/20261013204549.3115830-1-mick@yoxcu.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/sdm845.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/sound/soc/qcom/sdm845.c b/sound/soc/qcom/sdm845.c
index 6843ab8ba017e..a777b3b83775b 100644
--- a/sound/soc/qcom/sdm845.c
+++ b/sound/soc/qcom/sdm845.c
@@ -38,6 +38,7 @@ struct sdm845_snd_data {
 	bool stream_prepared[AFE_PORT_MAX];
 	uint32_t pri_mi2s_clk_count;
 	uint32_t sec_mi2s_clk_count;
+	uint32_t quat_mi2s_clk_count;
 	uint32_t quat_tdm_clk_count;
 };
 
@@ -365,9 +366,11 @@ static int sdm845_snd_startup(struct snd_pcm_substream *substream)
 		break;
 	case QUATERNARY_MI2S_RX:
 		codec_dai_fmt |= SND_SOC_DAIFMT_NB_NF | SND_SOC_DAIFMT_I2S;
-		snd_soc_dai_set_sysclk(cpu_dai,
-			Q6AFE_LPASS_CLK_ID_QUAD_MI2S_IBIT,
-			MI2S_BCLK_RATE, SNDRV_PCM_STREAM_PLAYBACK);
+		if (++(data->quat_mi2s_clk_count) == 1) {
+			snd_soc_dai_set_sysclk(cpu_dai,
+				Q6AFE_LPASS_CLK_ID_QUAD_MI2S_IBIT,
+				MI2S_BCLK_RATE, SNDRV_PCM_STREAM_PLAYBACK);
+		}
 		snd_soc_dai_set_fmt(cpu_dai, fmt);
 		snd_soc_dai_set_fmt(codec_dai, codec_dai_fmt);
 		break;
@@ -454,8 +457,16 @@ static void  sdm845_snd_shutdown(struct snd_pcm_substream *substream)
 				0, SNDRV_PCM_STREAM_PLAYBACK);
 		}
 		break;
-	case SLIMBUS_0_RX...SLIMBUS_6_TX:
+
 	case QUATERNARY_MI2S_RX:
+		if (--(data->quat_mi2s_clk_count) == 0) {
+			snd_soc_dai_set_sysclk(cpu_dai,
+				Q6AFE_LPASS_CLK_ID_QUAD_MI2S_IBIT,
+				0, SNDRV_PCM_STREAM_PLAYBACK);
+		}
+		break;
+
+	case SLIMBUS_0_RX...SLIMBUS_6_TX:
 		break;
 
 	default:
-- 
2.53.0



