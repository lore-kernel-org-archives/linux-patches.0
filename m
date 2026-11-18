Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020745;
	b=KL8qGHe/SJhs3XvKHjJ6y2kQbf/gIO9DtqrTxHmCeao4z+HUHNsPHlpjabqcsH+oPqZl
	 kzQy3OE5IWVBPZnEde2rJumaHw9K0bYjYZWdyvkPlP1mu/F3YRibetpju8QGTGvOQ1RWI
	 5KX9VHPGl/Ebqmsy3PdXWhjftSf4hqcsTojUseN3jva5+N7jmNLcOJBMY9zJKTi07e9rB
	 YxAj4U7APdUw1QqztJ5UYFrMn93hG7Nv89P2j8jXjcIUqHPMD2sWIzbBh+b1Ou5YNMh/t
	 X8uVSueWE+4hSCmpg7l8yw3FoNI5if+rLfJyVWQ26cNXEAI4byeaZQ5bbfxX5Zo4EtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020745;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eJEys7RBMquaNAatwyLd9tB5Fg/R91uHE87Pu+GpWzI=;
	b=VmFZI1pa1PlogpXas82xoBeKqY33dVYntzH+UtjT6gthYfNbl4YbjESyycuPQzJvpvQg
	 v7bALRziQdPru3T4klfWc+6w4H+bnS+BXcfpGdGsMCia7xfGGe4mbk2o5wuGqQhEwEqnG
	 teer9Ar8go0xBRfeOQU44djv4g5hzOMNNKA9jROzwNBJLujcqwwXtQ4TVvyob2Yq0Rf9J
	 X8+HMfGC5bOnTjsyh8VaOm2BiqjbaMi9ZJdha3Xl2RItKTihxjVEfueh1y9n319xxazZw
	 1CGbl5Cd1IvuSqzL6I+78ZuOATsF0Xa5rw+qbpeSE5iJY99L1/DFMtTahmhE1gBwIdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z1mpZkPY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D23F60A2608;
	Wed, 18 Nov 2026 16:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z1mpZkPY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75A391F000C4;
	Wed, 18 Nov 2026 16:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020745;
	bh=eJEys7RBMquaNAatwyLd9tB5Fg/R91uHE87Pu+GpWzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z1mpZkPYXuZsd0+x8o8kodooOJGnlD0RA79B7Wxp3QNRsVuxAcA6jbovG2tD+euOl
	 u7+rKtxCRQet1Ltt0pFaL1X8VAGGEhW4Bty3d1rf25aXEXqbKikDG0iQsXdhA+3iWB
	 GRfd4RGmrY51RlRvDu7lXurSbdBml6Q0KxLUnq+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2062/2651] ASoC: codecs: tlv320adc3xxx: Fix definition of AGC Target Level control
Date: Wed, 18 Nov 2026 15:55:02 +0100
Message-ID: <20261118150400.295364427@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit 0a9efcb663b5a4d468cbb90de29c6dd3794af124 ]

The right channel AGC target level is in RIGHT_CHN_AGC_1, as on the
left, not in RIGHT_CHN_AGC_2, which holds the right noise threshold
and hysteresis.

Fixes: e9a3b57efd28 ("ASoC: codec: tlv320adc3xxx: New codec driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/09cad9ec9bb382e44cad079a680bdf0f6163567e.1792135144.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tlv320adc3xxx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/tlv320adc3xxx.c b/sound/soc/codecs/tlv320adc3xxx.c
index d7d958ecd8db5..f8b28562f8aaa 100644
--- a/sound/soc/codecs/tlv320adc3xxx.c
+++ b/sound/soc/codecs/tlv320adc3xxx.c
@@ -691,7 +691,7 @@ static const struct snd_kcontrol_new adc3xxx_snd_controls[] = {
 	SOC_DOUBLE_R("AGC Capture Switch", ADC3XXX_LEFT_CHN_AGC_1,
 		     ADC3XXX_RIGHT_CHN_AGC_1, 7, 1, 0),
 	SOC_DOUBLE_R_TLV("AGC Target Level Capture Volume", ADC3XXX_LEFT_CHN_AGC_1,
-		     ADC3XXX_RIGHT_CHN_AGC_2, 4, 0x07, 1, agc_target_tlv),
+		     ADC3XXX_RIGHT_CHN_AGC_1, 4, 0x07, 1, agc_target_tlv),
 	SOC_DOUBLE_R_TLV("AGC Noise Threshold Capture Volume", ADC3XXX_LEFT_CHN_AGC_2,
 		     ADC3XXX_RIGHT_CHN_AGC_2, 1, 0x1f, 1, agc_thresh_tlv),
 	SOC_DOUBLE_R_TLV("AGC Hysteresis Capture Volume", ADC3XXX_LEFT_CHN_AGC_2,
-- 
2.53.0



