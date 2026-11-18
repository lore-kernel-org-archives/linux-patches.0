Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049974;
	b=Z5c+EwcT46+yMYow2E4aWAKo9gTZ+EQFnSJHWHdoNqhOtUDdtlSEBkRodngOi1eOKL8a
	 KoR5+h1P7s03QbFZ3hyEH7//59JPGls1JKejG9HoJGdpRolyIkAiw6tl0x++feylwyhi8
	 tH4GED5UtijwW4fn5yPstPSZyTZym6ww7gJ9pDs8Gk8ykdd4v1EWtzRxgmKdRu4QtV+VG
	 q5cXmRX4Ok8iNxILeahj56XeuC5eLyFs0xlPgJGWIGCeB3A+Du43EdKBoggjDDcRYTubv
	 iXwPQ8IAa9cVU2x+byoMqLW/dV3d1XehugNNOfLcXTdAdvdUayhrsoYaGjOIAGuqAsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049974;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=66fip3YsMm1AKFbrcILpL2Kj5orZW4cP/z2cXFEKgrw=;
	b=dwmwOjDRYdet5RJD05stbaB+DWnimQdauiF7GD3ObTVz7XIMqhzj4etQzPw/Nb1h/5Un
	 mw2/pK5azHUQ07bNZYBrhYTP2wPIhqLbsJxe6i9Xt+sJfnRtY8eR5+5B1auGjf/mjlutO
	 D88zQ4F8oM5AlsrxXXxZkE5lWljRvt9aQNi1R0Bq6vS8M0jAP0Qp95PXKh86z1bM+BCcQ
	 xsNKgB9MewtYcS4LDpGJULiBWP5JqDNrg0rXf7CoQ//PvHwkwqXruUcfhMvwMTDg+HoFQ
	 iYmxFby0MPhctn/erqcGjLpEpPgYttZiIKXEmAJ5OK++DodK2XmX+XYm7jN7xuhSx1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nMPRy03N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB5C606A320;
	Thu, 19 Nov 2026 00:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nMPRy03N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37B8D1F000C4;
	Thu, 19 Nov 2026 00:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049974;
	bh=66fip3YsMm1AKFbrcILpL2Kj5orZW4cP/z2cXFEKgrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nMPRy03NuP01oHCC/4LYagKmyN1fQXQqVoBk7F5/kPfdzbLJfmc1dil6x3Pmm3MBx
	 1F6/VxQKlpcssLGEIvge8T+q82kwnvDjy3MAdAJQPNKthty2o6Ni8dyO45XTabzzw/
	 QOMF1CTGWvU4cwjw0VUdXH2qVQkLB0IxgmPD01cA=
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
Subject: [PATCH 6.1 2536/2857] ASoC: qcom: sdm845: set quaternary MI2S codec DAI to I2S format
Date: Wed, 18 Nov 2026 15:59:30 +0100
Message-ID: <20261118150332.839143228@linuxfoundation.org>
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
index 6dca191ef3980..1c1bea388bea1 100644
--- a/sound/soc/qcom/sdm845.c
+++ b/sound/soc/qcom/sdm845.c
@@ -359,10 +359,12 @@ static int sdm845_snd_startup(struct snd_pcm_substream *substream)
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



