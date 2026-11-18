Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026954;
	b=pQkzU71cpLTqzsVyc6ut4YKfvTYS8XkDNYs9N1Rpd4BxMDcpJ+DfeRSFei5Vd9WOiIda
	 udFfwIB483MkA1Ibq/Rctj31uNwSziRL2qI/P4dpypENKxrue8TBmAe2RB7pJbaPZFxw9
	 FNftg1e4rT8n1Mmx2lR1NJ/D1i8vEKsij0m0EiN7zHx9al4ve5rFY516F1KZsc510l5Ee
	 I4RlpnjqxOWARKHS5ImxYniDf4vDtYrdqf1oYTtSKYx/EH/+kJzHTVD5UYLDEy8v/BqBE
	 wf341CPUrZLBYYxvHDQKvPDiF1Qan0+dS2GtsdJpQpAoLdFnweJLX9VrOy0CeBqdNYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026954;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ckWSaoMeZ/6twwASvIDGNaDq94v0sAQ3e34NVVkTwNo=;
	b=WkyHz4luMAXgaS7vaWL7iFpD6REVetzyXu4la4magVlaxuTNyDjWiXpo3/lhzbmQuuj/
	 tidUpgE5sLr8G36veccPYYlYhFz/MSY+d1Yk8rN1vFWBxUHq8BafbruLloT9L2Doad1ZV
	 VCI4++MsogSQvHUg4koPVSLTuCTlQrBvPSRjv531QcGNrIcn6Wam59BWvUvK87C/8xnWB
	 34xw8HaQI65c5wClDqxCJ5GKRDSjW4O10xSEu8BH7Ldj9snbl1BfVNyjV0VzrwCUvSrE1
	 TdGaUruhKXdTg9Ej99pIbHbQtYhU9gRL3PYxAJRpdQhk+2PpJE4xsaVK98nMT8j9EyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z1UR80Vd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A733606A32A;
	Wed, 18 Nov 2026 18:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z1UR80Vd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E08F21F000CD;
	Wed, 18 Nov 2026 18:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026954;
	bh=ckWSaoMeZ/6twwASvIDGNaDq94v0sAQ3e34NVVkTwNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z1UR80VdhECbfxw6jg0QuU4n5mQKVgEzbs8g519ibVgmrmMc4ya+idiNTfqvyEaPE
	 7be11QpP6+QaSQ4Vdft4qzY2tZxuM/VajZ4yA4WpJ0c9dvBJI9sn8Uum5Re2Xq+VOZ
	 pDcAsl2M3bfmONOpntbEj2UpfEA4rSI95i8Z9shQ=
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
Subject: [PATCH 6.18 1618/2151] ASoC: qcom: sdm845: set quaternary MI2S codec DAI to I2S format
Date: Wed, 18 Nov 2026 15:55:53 +0100
Message-ID: <20261118150220.819320218@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



