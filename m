Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041911;
	b=Da5l35XiMtqijEYlQA6NmSnylHAEwbFKDM4HzbtMBYW2WGVWU+b3+ylbtd1TVUfRAdbr
	 mdf+wQbAXma7/SQszjihidRf7q26p96Ru3DsMkjdltFO84XGUlRh1+biYda2Bpe36CTP5
	 MKJd/mhOsCWOkh0Vpzmqxlh+4wBo5bjdRGO14NRpgbaOmzBAEfyU2ox/GO4VfXPq758HF
	 MPgrs7+ee/qNinktdahURV1NhdZAmruTMk0BjAZnmB1gdtD//A3mYuTeF1dbf1uVENwWW
	 cY2tgn1/GAAIYPoKrppvFWuM5PxyI1I7qzDAkfqCbIswQnF8ZQ5hVdSd99OvP/8U77w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041911;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MKgREBjsz/qKtPPK5nimDhCIMzM8ENxLtlRhHOVl9MU=;
	b=X6bSlImtZ//X6AHfeWHvKHK3qThmhJBrRWvZ7tY4OEZzX+aSmf+N8L//4g8uVVVHDl/G
	 fvUjmNaj7jWLY6aD9eaz03Af5dlyWdqQKFoATFdloL596cpzs3oXrRXa+cw1NM0KxEfPW
	 XOoX14Q6cZnKAtT5O1gyFzExnMoLlbanUCodW4IxR7ECLLTYkir7lKWzrnBipC21G3kL2
	 3BD+9ByE498QoJ8AXyr93p3/z96H02cXRJQVggASsLCvIayzAub/yFPeS7Oq+K2ANxRvW
	 RoPwPNQhpfAw6NEtkgnWLLf6CXbTNU0NIpKd3aTFn/x8TetiUV2eSxfVSLz1HAtDHaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=taBndo8m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F88606A31C;
	Wed, 18 Nov 2026 22:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=taBndo8m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C08D1F000C4;
	Wed, 18 Nov 2026 22:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041910;
	bh=MKgREBjsz/qKtPPK5nimDhCIMzM8ENxLtlRhHOVl9MU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=taBndo8mSKH9fZGOjA59yXCoomSMtaR+9NiaVMnHxTfENhOnyZre5UeAwga0OQ3P3
	 MfD3WQrJh17/wVLxN953iCO/4jDWBvU8y1htQ2SO4HHdjMqH6v9Qllern3+HTj2uwy
	 J6X8RxuNQ7y9qkwei7Cf8KoNA+vuFW1xDXI+uTyc=
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
Subject: [PATCH 6.6 2941/3318] ASoC: qcom: sdm845: set quaternary MI2S codec DAI to I2S format
Date: Wed, 18 Nov 2026 15:59:23 +0100
Message-ID: <20261118150448.582478809@linuxfoundation.org>
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
index bb5353a4c1e2c..462ed48cf5e01 100644
--- a/sound/soc/qcom/sdm845.c
+++ b/sound/soc/qcom/sdm845.c
@@ -372,10 +372,12 @@ static int sdm845_snd_startup(struct snd_pcm_substream *substream)
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



