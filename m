Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062061;
	b=JWAw8844gnD3ch1IFcUPhKCN9CpRduxP9HoCCz24awM6GVphpCesxD9QoZYu7hXnR+2k
	 9/ImceR5jNFNBkyOHArIelJezvdtIDTQ7qqpTY1O7qNtDSkwGXvY86Qb8MLXWFT5+ev23
	 Nh6BjNmyNO4O2GGiSMsWM845hhlSmw16jCpcraE3yB9ScfafsjGexS8om1NOHlSBof0Q5
	 yJv6n1vTSvWf3qkOAAGO6c34Tr5kHERjGIEbNRVu5HZggNH67QzhnsMfr+JStIeRGnuQS
	 y9fuy4rzsplc5cJhahptPZZGALR2TYkcjJvZClSK+DI/w7jGD9oRRg3h8fpV6YNvPFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062061;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SEWoFJURn3lUM7+jNNMWfnpeV/99EzUXNYFWbPa15pw=;
	b=CAJS/vlhplFjkTspFXYeiC4fWtuAqLP+Kr5kvNrPp/c3j9cfiNYomJkKwjj8/2OKN4+I
	 lCljNFGnmLPcBOJtid7QDln+mdt2Uwbd+2fdJryhA66bjEMZeClW7mBGHvbFXTC+9jQxK
	 VyMFrItEuTfFKyhpMVVrW8gJr4z0TCx68tqvfaEdvN9YnevC/z3nOsFhsrgCptxlbYzXH
	 mZgcMO6QaDfxur2IMOPBiESP/PIl60Uydyrr+WfZtscZGoVc08zLJuaDPioLHB0v5vCx/
	 +uwJ5RvmaA5zXV1+Frt1xtKWf9QinZ5z/Yxn8/eKfzCnxrpDOBLR7HChpV4+gqnOdNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=De2N8S0D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35874606A32A;
	Thu, 19 Nov 2026 04:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=De2N8S0D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD25B1F000C5;
	Thu, 19 Nov 2026 04:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062060;
	bh=SEWoFJURn3lUM7+jNNMWfnpeV/99EzUXNYFWbPa15pw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=De2N8S0DYNVPmGzS681uR1sGlG6fCZ13vuKF5z7Q8JxhpbXDm8PCoT+HWAqpO7WIO
	 7JkfV601RBkbgCxIoIoYkOoBbDOnYdsQ16EKaV92ouEuS1O8GadVZzWOdKaBOb5za/
	 6zQg/pji3GM0NYPPOPD+2A/daiwnYm0lTXLlQczg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1733/1848] ASoC: cs42l56: Remove the ADC Mute Switch control
Date: Wed, 18 Nov 2026 16:02:51 +0100
Message-ID: <20261118150032.123428940@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index ee41b512a4fa3..9108b2503bc98 100644
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



