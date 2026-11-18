Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050094;
	b=mJ2p61j0YfbehVrJ9Omo7W2ZBEQzG29gNqclLe8k1ttXxfuGveNTYGj3izeiXtArQeI2
	 5RQDbYIGxhzVd8OkIomnFs+/cMOKd4GXqxEuTDUi7KgxIYA3l0FFoeMszY9C4dt82SAol
	 7H9+fmn9s7PFBmhxjmIY//Kw/6Iczqk4Mc3JXxy1BW27i9iedXzvDv+80ubPbS84qRPYV
	 V+Qx5EuGdmSyy8IMhumBiCZVRvtklGf49a92G+w/K+rIrWq5QwUhPqx7aSENhdOczpaEe
	 UH7wTWWkIvCcuQbCT/i99SQVOhk1C9dOr1KT3OXDW3QbdP4g1LtSy+P4E05EuqU360A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050094;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GaCKhQY0T3XZSzmHYPzP69A0SDj5kynPwur4iHDCO/k=;
	b=dQIMcoAvPqT7CG369ZBc9ij50dv1GiYy7XwOyeXCc02CFQaCjFNPeV44wotIlSWbfWHA
	 80hnskEDp+YVIiurTmi6wksbShPupqkH+nbFrpZKwQCw9c3qDyNHgzWR+qY0CKfermv30
	 m8eE9JftYmVdvucpwKxANpAo+ju9/xYV5RuXSErXE6l5hvDtX+mmb/P08Cm9ukAw/DkTf
	 +SjmTwzGBzvB7NVnknPA2GVruDGyE4TGkLzkT4hTg1VJmGE7uyJtz13pZSA0+ntbE9it+
	 DH59opWwNe64H0rq2rwrxOBUcVSGOQetNJW/kfm9ZjqrOs2j4W7UZfhE7JxIvYbl12g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tRVlAd+L;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E70606A338;
	Thu, 19 Nov 2026 01:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tRVlAd+L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 987361F000C4;
	Thu, 19 Nov 2026 01:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050094;
	bh=GaCKhQY0T3XZSzmHYPzP69A0SDj5kynPwur4iHDCO/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tRVlAd+LI8D16vstU8YM3CJn3VGz/aRb2NWz3Q3VXEZCL7kkmlU2aUYgTN+GO4evz
	 swBQNWvGLIw7trUQDSopDyNfIlvXlupTWduE6agg6qLHjVwOaMgRMYvqXQPGjylSCu
	 ltUfPnQG7GlgzCKkoJDNvSav/udFG//SunYtBRys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Klimov <alexey.klimov@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2535/2857] ASoC: qcom: sdm845: add handling of secondary MI2S clock
Date: Wed, 18 Nov 2026 15:59:29 +0100
Message-ID: <20261118150332.805420148@linuxfoundation.org>
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

From: Alexey Klimov <alexey.klimov@linaro.org>

[ Upstream commit 8bfb66c75cdace542dabe87841152614fd5b8d91 ]

Add handling of clock related to secondary MI2S_RX in startup, shutdown
and hw params routines. The handing of MI2S_TX and SEC_MI2S clock is
already there so this requires only placing SECONDARY_MI2S_RX in the
correct switch-case choices.

Signed-off-by: Alexey Klimov <alexey.klimov@linaro.org>
Link: https://patch.msgid.link/20241205023344.2232529-3-alexey.klimov@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: cef5d087d681 ("ASoC: qcom: sdm845: Disable the quaternary MI2S bit clock on shutdown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/sdm845.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/soc/qcom/sdm845.c b/sound/soc/qcom/sdm845.c
index c2295891394d1..6dca191ef3980 100644
--- a/sound/soc/qcom/sdm845.c
+++ b/sound/soc/qcom/sdm845.c
@@ -207,6 +207,7 @@ static int sdm845_snd_hw_params(struct snd_pcm_substream *substream,
 		ret = sdm845_slim_snd_hw_params(substream, params);
 		break;
 	case QUATERNARY_MI2S_RX:
+	case SECONDARY_MI2S_RX:
 		break;
 	default:
 		pr_err("%s: invalid dai id 0x%x\n", __func__, cpu_dai->id);
@@ -346,6 +347,7 @@ static int sdm845_snd_startup(struct snd_pcm_substream *substream)
 		snd_soc_dai_set_fmt(codec_dai, codec_dai_fmt);
 		break;
 
+	case SECONDARY_MI2S_RX:
 	case SECONDARY_MI2S_TX:
 		codec_dai_fmt |= SND_SOC_DAIFMT_NB_NF | SND_SOC_DAIFMT_I2S;
 		if (++(data->sec_mi2s_clk_count) == 1) {
@@ -361,8 +363,6 @@ static int sdm845_snd_startup(struct snd_pcm_substream *substream)
 			Q6AFE_LPASS_CLK_ID_QUAD_MI2S_IBIT,
 			MI2S_BCLK_RATE, SNDRV_PCM_STREAM_PLAYBACK);
 		snd_soc_dai_set_fmt(cpu_dai, fmt);
-
-
 		break;
 
 	case QUATERNARY_TDM_RX_0:
@@ -430,6 +430,7 @@ static void  sdm845_snd_shutdown(struct snd_pcm_substream *substream)
 		}
 		break;
 
+	case SECONDARY_MI2S_RX:
 	case SECONDARY_MI2S_TX:
 		if (--(data->sec_mi2s_clk_count) == 0) {
 			snd_soc_dai_set_sysclk(cpu_dai,
-- 
2.53.0



