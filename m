Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032207;
	b=4Kt59iLEKbnZnPoAX//L/wGipoulNpBJyARXF4MQISpqEAsjNagZlab97bc1/v1Ly6h9
	 5MMvieXZGQ/EuFfog5erUnr1VPVCHKOsUC1OUckFat+Yf4nN+qxmg+CjYqazQvy6Di2ca
	 dajCrkT/asaAuoyD0HlROjChftMf+ed2X8Ifop1SFmR5xaRWttvpC75yNGHnsisX8K5Rb
	 fBElnDw/+b+BEEv2E6V9gO2tb1oNuIK96fA7Xo1qTw/DIZfg7JolRyJ9OrTM9VSleShW7
	 mLCzQslxcjAMBg762DG9RTtH1pl3AEVhoq5Qo9Ck/HTKG8yB/yTbRwjYIWjIwtozZ1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032207;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UYt037bZBXi8gK7lpu1+x72Tzm4rgUgPWaDXwisIhKk=;
	b=Jjk4tZlF1e4MozYPDEJ6PJ2pr9nde4UaekRY4/FKyXziJZJartVE+BOACQFDGgSdSbaP
	 sxMLKWPhjv5c/zk9OpJuSPIj2jhfqhyU969fkYZUeXwXDC3fXDHzV/s0t1yYI4sk0Oe3Z
	 hd6NTVfnDtaKP1T+4XnUFUp7F3g4wtzz+Vzo0GtOFCm/oILADUVE33GspPhsanAa4HdSo
	 HLqtLGLlZafUtpgFfyWkIT6nULEo096TvpL++wJKkXbEWQdRNE66V1fRwLVgvwaDai6Vq
	 wkAVjNOP5aabsjhhsMpANkCfcylyrLMxrjKA6ah0IAmzHzKRbklhf1oXxupX7AxYZug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZxcdsuBU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B392606A31C;
	Wed, 18 Nov 2026 20:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZxcdsuBU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EB811F000C4;
	Wed, 18 Nov 2026 20:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032207;
	bh=UYt037bZBXi8gK7lpu1+x72Tzm4rgUgPWaDXwisIhKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZxcdsuBUA3j7S3sGFRPkXqZRNXUyJx3dhanuL79QMXBcW8gbR/RB+9ezeQ8EdSR3S
	 lQ2qQ68yFjvEqM6cwjEAOJ95PF1DFYJkFdu+UQuVnFjC1shx3mgRBCiF9NLPDgbgB1
	 2K1qO1/gL95kyeIA0Bxnm/04xP2yQtuKzZLxke4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Auer <mick@yoxcu.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1289/1756] ASoC: qcom: sdm845: Disable the quaternary MI2S bit clock on shutdown
Date: Wed, 18 Nov 2026 15:56:56 +0100
Message-ID: <20261118150100.870857435@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 0450be84ceef9..77229d9048ee5 100644
--- a/sound/soc/qcom/sdm845.c
+++ b/sound/soc/qcom/sdm845.c
@@ -39,6 +39,7 @@ struct sdm845_snd_data {
 	struct snd_soc_card *card;
 	uint32_t pri_mi2s_clk_count;
 	uint32_t sec_mi2s_clk_count;
+	uint32_t quat_mi2s_clk_count;
 	uint32_t quat_tdm_clk_count;
 	struct sdw_stream_runtime *sruntime[AFE_PORT_MAX];
 };
@@ -374,9 +375,11 @@ static int sdm845_snd_startup(struct snd_pcm_substream *substream)
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
@@ -464,8 +467,16 @@ static void  sdm845_snd_shutdown(struct snd_pcm_substream *substream)
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



