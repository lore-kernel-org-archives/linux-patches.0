Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032201;
	b=qqUtnACP1JzlB3iGLdh3tPY60Dy26PAgRLmZrWk1uW82bj9PfpB7VXXR+Hl4jiqacqSr
	 YNH93KbBOqT2iGYeuVm0EaaL/b2XCObN87/HR4AzGB3XulOtxik7Oho3+xd/BDFYIHlxm
	 YJFfSWCrnuC2pRYitdOeCZ0bXbfTRsa3yKQ/7+rtc/q8HlK0PL/NseOHbQdC0aYgcAqQE
	 aB4dpmINx7BNDpw8BKXrUjGRAX79Ph77JzwYOrrgVM/Q2VA6GOEqEqS8HpGPsF2bhzyVl
	 7aYZcCvrEfJugAA8ubFSMOQlhzKWkqQJXmUt5ZBckZnMsPZYAeyfNrh01aoJL9o2i1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032201;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eH2YJI8rRbtUgs7Rrwz5AStvEr4G7R0ByIXDtNDuBR4=;
	b=UTyLNwbyEvpDru265Z3yRagTl5aUxcxN1jeiDsUeYuZS0rEsE2q+xY6+P678w/cIhL3Y
	 QyQkIktJTlM/PoQiQjTU8cP8Oo5V3cVbXsplzRh8ENxXejJTh2HmDOWdWvwr4ut7tbblf
	 0kn+c77GQv1M1rzXeiAr0480wz2M+9wcAYPtwql8fpE6iETIIw3JHMB14QtPw/W7h9Xq5
	 IW0LQC8VFjg7G9myAWW4gDhGGLFFRpjhBG/dMZH19EoS/XOhsgDVTVvT9h2zfhgILU41s
	 6Lfx3bE9/pogSZ0qDzWRkBb4JX6qiUQNSOEjLBBXVzMkm4VqE2vnC8WWhIq0IlNKARA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xCtdtprb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A4E5606A31C;
	Wed, 18 Nov 2026 20:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xCtdtprb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F33581F000C4;
	Wed, 18 Nov 2026 20:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032201;
	bh=eH2YJI8rRbtUgs7Rrwz5AStvEr4G7R0ByIXDtNDuBR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xCtdtprbyH16IStPYKlfJIYYaI70ENq0S7IPY7ZfEeLn0xhCBQQJ+iNe//9zlFqAW
	 5wsuDxCmRq33ZCQyGQj4pIFxnH5CrrnFASEOvqLMXB9rQZqQ9/2kurdhHTOVT8K0Cf
	 saLiRtdomBy1zcKx7a2QeSu5wy74xQcHPf4J645w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Klimov <alexey.klimov@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1287/1756] ASoC: qcom: sdm845: add handling of secondary MI2S clock
Date: Wed, 18 Nov 2026 15:56:54 +0100
Message-ID: <20261118150100.790302449@linuxfoundation.org>
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
index 314ff68506d9f..a233b80049ee7 100644
--- a/sound/soc/qcom/sdm845.c
+++ b/sound/soc/qcom/sdm845.c
@@ -219,6 +219,7 @@ static int sdm845_snd_hw_params(struct snd_pcm_substream *substream,
 		ret = sdm845_slim_snd_hw_params(substream, params);
 		break;
 	case QUATERNARY_MI2S_RX:
+	case SECONDARY_MI2S_RX:
 		break;
 	default:
 		pr_err("%s: invalid dai id 0x%x\n", __func__, cpu_dai->id);
@@ -360,6 +361,7 @@ static int sdm845_snd_startup(struct snd_pcm_substream *substream)
 		snd_soc_dai_set_fmt(codec_dai, codec_dai_fmt);
 		break;
 
+	case SECONDARY_MI2S_RX:
 	case SECONDARY_MI2S_TX:
 		codec_dai_fmt |= SND_SOC_DAIFMT_NB_NF | SND_SOC_DAIFMT_I2S;
 		if (++(data->sec_mi2s_clk_count) == 1) {
@@ -375,8 +377,6 @@ static int sdm845_snd_startup(struct snd_pcm_substream *substream)
 			Q6AFE_LPASS_CLK_ID_QUAD_MI2S_IBIT,
 			MI2S_BCLK_RATE, SNDRV_PCM_STREAM_PLAYBACK);
 		snd_soc_dai_set_fmt(cpu_dai, fmt);
-
-
 		break;
 
 	case QUATERNARY_TDM_RX_0:
@@ -445,6 +445,7 @@ static void  sdm845_snd_shutdown(struct snd_pcm_substream *substream)
 		}
 		break;
 
+	case SECONDARY_MI2S_RX:
 	case SECONDARY_MI2S_TX:
 		if (--(data->sec_mi2s_clk_count) == 0) {
 			snd_soc_dai_set_sysclk(cpu_dai,
-- 
2.53.0



