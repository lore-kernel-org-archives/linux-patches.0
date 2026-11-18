Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056655;
	b=FVLgtf+LC+8xDYigxHt3XcT9zqWvDBsFHLYaBtRJFA6YEhYnZLwyBAMEcogvsYd6Eskg
	 lTn2bgjq+Bejor4QqKlujF9gGqNcjjMdlq/4rDKP3ZjqLBVGkP+GN5zbddzz3pp6E/Ssg
	 1PBWlPSKske3eG7pxpX/AHecwU+ZFUOajGOfuq/JXOEIv/jDKcUijkev3sey2K4RYCvtr
	 A4GIr6xkm5HNkjE+/k86/F+vPFOyOJZJ3SFtllJ6uLSfyFNvhiDAwX44WTvkahLgaiRcn
	 sd3ykqiX5znFjgEGCSXM+qXxUFuoqipKoSAkbtONcEiFvutiw2kywngLjB3g5cjCUnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056655;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SKpm7pPcUbCg804/5+OzO8RWE8z4kYO1oKPMzLlTESc=;
	b=XcNxxETqk0MCyHvA65BweXimE2SnRkFrunF8iTYUIAorsm0y6/5CQhad1tpVKwG+NeFR
	 HXK5a5Hl/yHnizrDx2QKgzp21wiqLSxh19kRrSFabThnX6Kys327Dcn4K04AuTqITI3Oi
	 ndpeZJ+QA5U1Bl7KqGLDqZsnsK8GuIat5B7yYZQIURtrZDY0/5fhxes6Pp3+GgWmmEXMh
	 h6id4acR5bAGX6yKfKYD53SCtTih1EF7UPirui252QSpfrNsC1aJInIwllBKIgU9LQ2PW
	 fiDhk0ZvolJceFFIMmZ8X6awbZaAFIgt4JJ6nBz021Na07/eT28g0nLR+jJWUeDvWcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="gmwgkgU/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61ADB606A320;
	Thu, 19 Nov 2026 02:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gmwgkgU/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B137E1F000C4;
	Thu, 19 Nov 2026 02:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056655;
	bh=SKpm7pPcUbCg804/5+OzO8RWE8z4kYO1oKPMzLlTESc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gmwgkgU/GRXu31s8lmRlf2D3hlQHhXTcAsjT1lS7N4wdg54g6GFXRqYmuT1GYJD61
	 z8gVRoop44he290xYK8tLWmCmI3ZWKlLUUiQz8CqVHBdzfzclUMVYzf+SknepnfDNX
	 urzmoqJiT08rjDnhMeiXBDqtNyDr17usL1AVabqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2064/2214] ASoC: cs42l56: Remove the ADC Mute Switch control
Date: Wed, 18 Nov 2026 16:02:20 +0100
Message-ID: <20261118150133.222099217@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit ff404ef11b975baf38c4472c51a6674c239e8021 ]

The ADC Mute Switch control writes bits 2 and 3 of the Misc ADC Control
register. These are the ADCA Invert and ADCB Invert bits, which have
their own controls. The ADC mute bits are bits 0 and 1, and the DAI mute
callback already sets them.

So the control has never muted the ADCs, and nobody can be relying on
it. Remove it rather than point it at the mute bits, so the ADCs are
muted in one place only.

Fixes: 272b5edd3b8f ("ASoC: Add support for CS42L56 CODEC")
Suggested-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/all/atXh3Br+fuH83S0q@opensource.cirrus.com/
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20261019124022.3410793-1-sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l56.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/soc/codecs/cs42l56.c b/sound/soc/codecs/cs42l56.c
index 7e75b98a40059..bac26ea6729fa 100644
--- a/sound/soc/codecs/cs42l56.c
+++ b/sound/soc/codecs/cs42l56.c
@@ -387,7 +387,6 @@ static const struct snd_kcontrol_new cs42l56_snd_controls[] = {
 			      CS42L56_PGAB_MUX_VOLUME, 0, 0x34, 0x24, pga_tlv),
 	SOC_DOUBLE_R_TLV("ADC Volume", CS42L56_ADCA_ATTENUATOR,
 			      CS42L56_ADCB_ATTENUATOR, 0, 0x00, 1, adc_tlv),
-	SOC_DOUBLE("ADC Mute Switch", CS42L56_MISC_ADC_CTL, 2, 3, 1, 1),
 	SOC_DOUBLE("ADC Boost Switch", CS42L56_GAIN_BIAS_CTL, 3, 2, 1, 1),
 
 	SOC_DOUBLE_R_SX_TLV("Headphone Volume", CS42L56_HPA_VOLUME,
-- 
2.53.0



