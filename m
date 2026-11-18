Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032495;
	b=lVmDh5NRPJjcsMqK41/yqTDdct0WBp+XNicyBG2MGm/bGyOVHiQ49cyRYBwCcgG7H8dE
	 TUX3//LktHSnSPSV6fFEqUUDI2rS+cPsxYXYvMBSBDNCiv/znC87g1DmQWA8AhFYx+Psp
	 Ypq/6BaaWGrD7nbqjdfIdJt0Ub91QLDOKp0ZWlOJbXLE4Y0w3tZMzY1ny4rOhjIkvsOjX
	 HLCnxWW2B+zInvetny7XeRpcplkP8sa/xo8A2XablddtQgIvDPqJUZizF4JRS8HWivT7q
	 iVP7U/X0sNJu3/NNR0+D/X79IBOTopzSQFS8OFT5oczyCZtaANsRVIA/5JvzT3KSCAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032495;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5HjHlRmh09WJOWaLmykhcMPp1n+7uP06GOY9FLebHas=;
	b=jn/Z/or+jIxLFnVGEQwoBr2oJHetPHXcP/FyGwk6mhAAF27l56E9oNEwDXr41PUK4y0q
	 NTH9DJ+FQcQqrD+cePLdLLmQa0tfZ7KVq6cA4H9a7MxsX4Y6wKb/LAaDA9wOVBY3MvCE8
	 CbcXt3qqGHYcwV0VnxwJfbu9JLSCXY2wd/mEq1g6eIbemWOmAm6j1R6xuKKK9Qo3HEXnJ
	 L30JDC//iEZT1Lwz0Hm93YxjPZlHxvIW8lVris+mFhuN5DesVPrAsR7t1bZJMm8DGPzzX
	 JdQKUeiDGsarl1Z6ABTKAn40y8o7vlE4TLXWZ9uWEAp3foKdqpwatmkTF5wU+QJ7GGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PnY2Fzvi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9998C606A85A;
	Wed, 18 Nov 2026 20:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PnY2Fzvi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA96F1F000C5;
	Wed, 18 Nov 2026 20:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032495;
	bh=5HjHlRmh09WJOWaLmykhcMPp1n+7uP06GOY9FLebHas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PnY2FzviaUvvxdmm6ZO1Z/ZoICRRLfUTGUXWZF0wUyn7oMcHW3Zwhidvda4OqeEyP
	 WDAJKRjxLJj/SJNImCfCVW/HRHpM5SGUbwNP+N71LzHoBBkjiKKlQHLfGOatill8Ny
	 /aTLSShU+KL4KVpJUUOU7JCwIt/vy/1Mkl6yvLUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1433/1756] ASoC: cs42l56: Remove the ADC Mute Switch control
Date: Wed, 18 Nov 2026 15:59:20 +0100
Message-ID: <20261118150106.233557394@linuxfoundation.org>
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
index 0058ce2d55e83..f7e9c0fb23b71 100644
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



