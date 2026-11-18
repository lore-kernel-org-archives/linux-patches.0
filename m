Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032204;
	b=U/hOjWMzHpc6DQdnCKGcxO5JTXyAEKi6fMCKEPDcuapiY86bGtDxeN9usTt+xQSRr8vd
	 DaMilfSpsBXU7V9HxW+xwZ456cq4YgTaZj97ZGW7LTsIVb3JMA96d4GEDvraaUzfEEqIv
	 1c6kTPYg4LVOWU42fSaGb0iR4f/PVJsCYpGmLuUZ4UZN5wFrds9uD25CTAKrt0dFJ4VpI
	 sjIDZanSCR/yGtjZi7EuoLIH+C1qVLfS5tOBoTMrPzrGi63HX/lpoqEJX+8Bt02mBfn/F
	 CEEw4jtXT3DR9vbsdkFoGNPjbkZMqjhCA3SBS4Tf35XLiT2e45u7N/8HXtlskqWIG1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032204;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Wet0RUPoRaQaawdUBjlSivj1L9pEDM4fl5bzA5xf4/A=;
	b=M6RZSc9ZDJb3whSRNmozse+CMRgKCEtwU2DFXT8tYanF+Y8vqY43XXx5WFLom+eeKBJU
	 +V0UsRP+1AJYcCR2MlveJ88VNI1mYR4v6O7ca3BzFAiOeXF8PVbfnjCfI/o00pOUvCqfP
	 kWyIkKCvXGmp3dqY847+0QoE0RFou/Lv/NteQ5QmR8golXRz8pNoEVp6B9vKhWzPVaOr5
	 X53n6QA1vJDlsFe9Q08FZtkh9Oqu7nHJEdrGTchU6oLRUX7aMY6dEoYyTXDB4Fys+y1tE
	 Lvq6pGRq6+U7Hyb5yFodC+1riypu1LunqAjh7ppfcy22lRLa4ZIdWJSk+owJAf2votA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ihx2h9P1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64EB7606A320;
	Wed, 18 Nov 2026 20:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ihx2h9P1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEB981F000C4;
	Wed, 18 Nov 2026 20:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032204;
	bh=Wet0RUPoRaQaawdUBjlSivj1L9pEDM4fl5bzA5xf4/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ihx2h9P1X+qs1QgvzABO8T3JiufhNPe2JNh2qMmppqN/bUGfQiF8Xhz1OJmBiadvK
	 vSETB2G9I5WJZtyxR+G5LQFZ4tCDnx/LiYxSi5t05zBXyuz04r+pWNo9F2hoPGRmzN
	 zxCMQACmj4Cw4Q3qqQLGc0Sz33vGD0HT7n/Gi7mk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Oscilowski <drgitx@gmail.com>,
	Casey Connolly <casey.connolly@linaro.org>,
	David Heidelberg <david@ixit.cz>,
	Alexey Klimov <alexey.klimov@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1288/1756] ASoC: qcom: sdm845: set quaternary MI2S codec DAI to I2S format
Date: Wed, 18 Nov 2026 15:56:55 +0100
Message-ID: <20261118150100.827776455@linuxfoundation.org>
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

From: Robert Oscilowski <drgitx@gmail.com>

[ Upstream commit 20c734cb678332883d317b17bf8fe7361648e170 ]

We configure the codec DAI format for primary and secondary but not the
quaternery MI2S path. Add the missing configuration to enable speaker
codecs on the quaternary MI2S like the MAX9827 found on the OnePlus 6.

Signed-off-by: Robert Oscilowski <drgitx@gmail.com>
Signed-off-by: Casey Connolly <casey.connolly@linaro.org>
Signed-off-by: David Heidelberg <david@ixit.cz>
Reviewed-by: Alexey Klimov <alexey.klimov@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://patch.msgid.link/20251115-sdm845-quaternary-v3-1-c16bf19128ac@ixit.cz
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: cef5d087d681 ("ASoC: qcom: sdm845: Disable the quaternary MI2S bit clock on shutdown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/sdm845.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/qcom/sdm845.c b/sound/soc/qcom/sdm845.c
index a233b80049ee7..0450be84ceef9 100644
--- a/sound/soc/qcom/sdm845.c
+++ b/sound/soc/qcom/sdm845.c
@@ -373,10 +373,12 @@ static int sdm845_snd_startup(struct snd_pcm_substream *substream)
 		snd_soc_dai_set_fmt(codec_dai, codec_dai_fmt);
 		break;
 	case QUATERNARY_MI2S_RX:
+		codec_dai_fmt |= SND_SOC_DAIFMT_NB_NF | SND_SOC_DAIFMT_I2S;
 		snd_soc_dai_set_sysclk(cpu_dai,
 			Q6AFE_LPASS_CLK_ID_QUAD_MI2S_IBIT,
 			MI2S_BCLK_RATE, SNDRV_PCM_STREAM_PLAYBACK);
 		snd_soc_dai_set_fmt(cpu_dai, fmt);
+		snd_soc_dai_set_fmt(codec_dai, codec_dai_fmt);
 		break;
 
 	case QUATERNARY_TDM_RX_0:
-- 
2.53.0



