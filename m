Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042149;
	b=qjq9qR6NkyOCAMF/gwGMiZVNdZXj0PjTdKOl6gXcqmmUWf2qANA4+o9AdMNGtm6xGd3d
	 mQV5bnCyQ0ZjORzdR5p6fzRTxeNmNvNW/LolYfKPeLhptFtrWdwtNSegMGHgdsiwm6smt
	 Fig5GE1XGWMSQB32Tq+wH/3sPku17efR3C/vEs3h6Z/09w3CMS/CIKBDCD7EoDQbxwK3J
	 uk1aShas9oMfj8asWdS2WF7HEO1OGwSZvFcSOwGj7dHJ0deQzl8iORZR2OOY5jbdJJjWw
	 NqoA2KK6Dz4bk0ZiyK+OqbyPY1mJCx7LzTa+h8KsS4M6Zj3VKk/0HXuK8u1cc/QdXmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042149;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZCNNGPqbvMNaP7AV8VXtZxsnm0A6hm5+DukO1cppJvA=;
	b=KeiPuu2NIPiBgD80x25hZrZPTzyLqmR7Y3vOg0LHUEpDQV3lMnUo/D9Ig6i4wQEgAbNv
	 CmK3ya7X89ETHjgXZVHAy26zvn1x4dOSNVV2SLbQ4jBOpuwVMGjCwwML/ayt+7fHGCyEy
	 LGRSEdejYM4VOzgdc3mIyiZAbcE0ndKa+HM+zLYBof8YziYppS1Wq+VcqbI1+HU3/C4O3
	 wZpIpLDNy+fVRCetmwF/5GHAuxTLRP0Nk3Fi7TwmY3URnPQa/r/5RGsK1X/5PoEKULWCM
	 XlDTsJicXeZqZUWsHRDe0VKp26fNtFws2XkdzkEA7hIo2HtUzScg7+aUbMKNReOWdIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CJovHVTV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50735606A31C;
	Wed, 18 Nov 2026 22:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CJovHVTV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A61791F000C4;
	Wed, 18 Nov 2026 22:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042149;
	bh=ZCNNGPqbvMNaP7AV8VXtZxsnm0A6hm5+DukO1cppJvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CJovHVTVmz/f9zkRg9uCyrexFC87YTsUQKNzRyBO960ovKFQ+u6pquKNsGvsWoOX1
	 Co7yzU88aRaMEeNt9eAD/W9M22VFYVU2BOFzNiJuJKrzqOde48G9whusqHI+43wwmp
	 FHJQbKBstLRSl8+khUFMQgq/US2PByHQWk2O/DVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3065/3318] ASoC: cs42l56: Remove the ADC Mute Switch control
Date: Wed, 18 Nov 2026 16:01:27 +0100
Message-ID: <20261118150452.075084533@linuxfoundation.org>
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
index e04e174f449b8..1e38f653cafb9 100644
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



