Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050006;
	b=18zxYfuQyyP3JlZZyNGkKmjHJ9tHll1UxWyDxoGeu2SqlaXCNsoWdOitaEsRB6Jps/4I
	 teOzcrGNUrU+zJHPDzOX2CG0DuYaeRLIPlmKoI33sOQ8cG+er4cE/PtXOM4f4a7OFJ7UT
	 HALMc15Defz9atC3HYal/rcAkcPjq0O5D2JdE3DZ3HG+EFd2Md2RY4hFJKEGh9E58EyTS
	 zIzEKuWVxnokDZUkYt5Wk7yqGCCbVlrOYth5XTQTj9SHaf8c7FU547HChC+0lVqlDBkHb
	 v5LoMV2tgvr6RCCJDZyDEpV6J1imwtkL//byjSSd2xE3fIVOeMdldY2y2o1qZXx02ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050006;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=64iw44gN9J4HGFOFnYo+M8Qd6P4ll1tT6dyakbc99PY=;
	b=PLb8tmANQBY8bnXI86uXCcn3I6bKO2O+VBQDlbcCf3t82XNmVcrEdUvvb1S7IzetLWuZ
	 cyuS3u4o/ab74frNPbulNHRtixofbGmb5zsYpFTrqdZ/jqqWfPQTTSSThPkq/l3K0aBvq
	 ioW8YRs0iQxgDFhRWX1UHQ6vdM4h2wbuZP/nP+63ssFp0CJ2o+sKmbfbxgdPWEYLhMlMw
	 k5W5w4klUuExtm4bJkymA/PnlvAr1PvGj720sRIhv7YUbwkcS8YKlUlG4dK7wLcoGHI+C
	 AvERlA6Gy+qXJlCk1r30Ex6VK7JURuTdYOu19Dj4pdWeN8Vz9Kpj2WJ3VPrMm/Xtpig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FgonZn0W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20E2F60A3839;
	Thu, 19 Nov 2026 01:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FgonZn0W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 756171F000D1;
	Thu, 19 Nov 2026 01:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050006;
	bh=64iw44gN9J4HGFOFnYo+M8Qd6P4ll1tT6dyakbc99PY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FgonZn0WHSmE/9eyqj7ZELg6LMPWjMbjZ8wzW9qEwK+Dh+hXqa6G9lJDkMudrqCbq
	 Nadeh9We6ppqA24yaF8OYajDXQ9jWoQ9vMdk/9kUuT+YQCmgwCSPy7iYO+qBhhn0h5
	 KfW4DjU3AF3EgAxwSq08rHA0zGVJC2pGuQt1IGe8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Auer <mick@yoxcu.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2537/2857] ASoC: qcom: sdm845: Disable the quaternary MI2S bit clock on shutdown
Date: Wed, 18 Nov 2026 15:59:31 +0100
Message-ID: <20261118150332.872867811@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1c1bea388bea1..c1521f34c0792 100644
--- a/sound/soc/qcom/sdm845.c
+++ b/sound/soc/qcom/sdm845.c
@@ -38,6 +38,7 @@ struct sdm845_snd_data {
 	struct snd_soc_card *card;
 	uint32_t pri_mi2s_clk_count;
 	uint32_t sec_mi2s_clk_count;
+	uint32_t quat_mi2s_clk_count;
 	uint32_t quat_tdm_clk_count;
 	struct sdw_stream_runtime *sruntime[AFE_PORT_MAX];
 };
@@ -360,9 +361,11 @@ static int sdm845_snd_startup(struct snd_pcm_substream *substream)
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
@@ -449,8 +452,16 @@ static void  sdm845_snd_shutdown(struct snd_pcm_substream *substream)
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



