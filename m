Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041913;
	b=11MwXDW7Riw5kzTR5yND8Qw01mBRDW7u9GMxR8KAA3Tnq8/RF+yAqgz0/FNdxim4YEXY
	 jMN23+7IQ8RJQVOe4T10/Dg7ZypUio/S/xaL7XBCACzeZf4clr3oUTz+P25ujl01JgQcI
	 2DEKwYg3QYmFr3B1BDkAHWuzzI2F3yOoKYDQnWEUqKPOFjdCcLqa4ur9HAM1GaCaEwA0d
	 iYWOa93sHge8JtVUmnITOaHS/SYwXbLPCovAUA32sIJXK9V0+snBNJZ4V8rh1FP54MqrW
	 Qc2ISez5EEbhQzw5GHBB9ALAjwyNl46qhAeGGIE9tlM5AIzVjrPhU6miXJvuUM6pj+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041913;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qUBQwKDulxk72L0RDHlOMYQ98aA0r1+FY6rWJ1jAT5o=;
	b=YLA6PuBJ/5JcVUGm8i9xhW30xa7tCENYcQw9rSYAp+hhMZJ+vopIxU6pyOKdK+SXl6WA
	 I5r0AtmJDabQtzyqD+awvhzKCSxVIEN9FWvJ1Wz35lxZjTK3pmCouuZ6HM05f0trXH96E
	 +bZ2Z8FeL0LLFEGgqQuEcvK8pstdmkq45llS6J3cGtX8UZc10LPdaETCwumpOpb9g6Tab
	 N4c0C4R+0bemr1n2/1rbpk7EJgoqnmmHjcQv2xPhbWOvUEJmlu9qfqPANcuOnPFGu0mIv
	 9hPTKfP8nmGGh5Fumn8Ogltwa7C79EHGC0v92XZjzrsXQb7U3Q9D8oJrgrgt5dVR8PA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NXnwxbWN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C46D3606A32F;
	Wed, 18 Nov 2026 22:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NXnwxbWN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D31271F000C4;
	Wed, 18 Nov 2026 22:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041913;
	bh=qUBQwKDulxk72L0RDHlOMYQ98aA0r1+FY6rWJ1jAT5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NXnwxbWNAd1NlH20pzK/D0fLGllRr7/MSNCXw/LVfj/hvtPA7dDGhcpW/W5YvqODx
	 6XDmcnNj+yjmiJlShofnpGr0kMc9YsOE4+0zHX2PbWNYKWDrx7WhYtjBptKMKahyLd
	 zvhXLLDwBBGI8S0CepmDGt+UGckOVM5RwJFzUe8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Auer <mick@yoxcu.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2942/3318] ASoC: qcom: sdm845: Disable the quaternary MI2S bit clock on shutdown
Date: Wed, 18 Nov 2026 15:59:24 +0100
Message-ID: <20261118150448.608679969@linuxfoundation.org>
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
index 462ed48cf5e01..37712713b980c 100644
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
@@ -373,9 +374,11 @@ static int sdm845_snd_startup(struct snd_pcm_substream *substream)
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
@@ -462,8 +465,16 @@ static void  sdm845_snd_shutdown(struct snd_pcm_substream *substream)
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



