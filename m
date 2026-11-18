Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041908;
	b=Nw3I7qJV1n8xrRGFNkO/ofBXEIOfs8+vaA80SBaVJB81CpEaFVSq/5Olsgr6BYSlA19d
	 81+Nf3B7nQvdtxQyfij+EwBOJ8UPWFdefgqWRFGhYTrz64+LwGFlBwHIHtI8NGYPm4lDy
	 KkDRYxjXVKdMDWAMljindCzp/ZQJTt+5MqpXIPJ+WXq7TfSH6RiMoPNjyK4femIBKdb7I
	 0idlYRa2gXXCBr40tFiPXGRJfMGdzJLT4wkKu3uwHEeMoA9zmdTOyiDQDkUFCMx0WAkR9
	 kvO7uIBrlKdHM6xG8rTycF/bL/IULZbfbhpOxQSg+Kw4TH2hvyL9Ikr5OP579MlaYEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041908;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H6Kb28bnRw27r5+Z4iW/YA+F1CvNzgJcOLCl8h9oOcs=;
	b=tURXRt3RsxxNgd0LCt+0kvVE8gJA7xPbuAeUfmOjJpeMvWQOkxKT8MdXCF6m4T3WuMqs
	 +vR2DUieU4InaNPJrWRC/ppUZuU7Bd+5jifS74ZvjHIppCUt3H057Eln2MwlgQsrM0+/F
	 Eb2MeV3DlfyVcmUftxsKBt7CqZ/rUEFlS4nI7/ISYznhq3SeYZXPDSQPmNrOnaLf4nm0a
	 LonqfxdV6jOJD9WDSF3bRguFX9wHsevOT4mXs1zYoj1dvjlcnT3/AWpovIahlyUCP++cb
	 uGrYbXY1DJMDrsABQM7YOkZF8rfuapApawJIxHCxeis+r7tFBCaVJO/oHcR9p577d0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SbgJjLvn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32FAE606A331;
	Wed, 18 Nov 2026 22:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SbgJjLvn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 427691F000C4;
	Wed, 18 Nov 2026 22:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041907;
	bh=H6Kb28bnRw27r5+Z4iW/YA+F1CvNzgJcOLCl8h9oOcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SbgJjLvnLrVeoipS2/iLxcNLUwzPZi5g9abL4m7sZZ59ZJ/PJfjcmvbpycBUrXbqg
	 k1cUzFxJwwx1nRIHWOn/FZV8uNvMEmSClVg0xWPMuzCg1Qrvz/+ss7g2lyknt/v2BY
	 dCuCk0G8unmSl1D9403zBvwyl+gzdOu/Wg3z8Ty4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Klimov <alexey.klimov@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2940/3318] ASoC: qcom: sdm845: add handling of secondary MI2S clock
Date: Wed, 18 Nov 2026 15:59:22 +0100
Message-ID: <20261118150448.555103852@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 39d22304ce43f..bb5353a4c1e2c 100644
--- a/sound/soc/qcom/sdm845.c
+++ b/sound/soc/qcom/sdm845.c
@@ -218,6 +218,7 @@ static int sdm845_snd_hw_params(struct snd_pcm_substream *substream,
 		ret = sdm845_slim_snd_hw_params(substream, params);
 		break;
 	case QUATERNARY_MI2S_RX:
+	case SECONDARY_MI2S_RX:
 		break;
 	default:
 		pr_err("%s: invalid dai id 0x%x\n", __func__, cpu_dai->id);
@@ -359,6 +360,7 @@ static int sdm845_snd_startup(struct snd_pcm_substream *substream)
 		snd_soc_dai_set_fmt(codec_dai, codec_dai_fmt);
 		break;
 
+	case SECONDARY_MI2S_RX:
 	case SECONDARY_MI2S_TX:
 		codec_dai_fmt |= SND_SOC_DAIFMT_NB_NF | SND_SOC_DAIFMT_I2S;
 		if (++(data->sec_mi2s_clk_count) == 1) {
@@ -374,8 +376,6 @@ static int sdm845_snd_startup(struct snd_pcm_substream *substream)
 			Q6AFE_LPASS_CLK_ID_QUAD_MI2S_IBIT,
 			MI2S_BCLK_RATE, SNDRV_PCM_STREAM_PLAYBACK);
 		snd_soc_dai_set_fmt(cpu_dai, fmt);
-
-
 		break;
 
 	case QUATERNARY_TDM_RX_0:
@@ -443,6 +443,7 @@ static void  sdm845_snd_shutdown(struct snd_pcm_substream *substream)
 		}
 		break;
 
+	case SECONDARY_MI2S_RX:
 	case SECONDARY_MI2S_TX:
 		if (--(data->sec_mi2s_clk_count) == 0) {
 			snd_soc_dai_set_sysclk(cpu_dai,
-- 
2.53.0



