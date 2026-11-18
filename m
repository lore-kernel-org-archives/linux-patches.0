Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042445;
	b=j6chmgyxUp25bflHPRw22M0PAsY1SwCmoTnUn7NEPN7ho6v2fDbnBZlfgB/PBJjNvLXO
	 birzfU3GM7sD9Stf/KlK0rWnLDrQlZVVQyIi1M1LpEFZgS+obCB1QwMyir6le/atx2hsf
	 wujxg9PgldHAtk2fWG2D7gW+S6oJEKj4vu489qnr9Su1Pl18nHQt0zvqlhM6uuF+RLqXP
	 pZPxAA+xXTYHzQSIthk9cXkxkSliRIUNDsaz5I+Zrxzcq/XVSmVg62wZTMx8zeAiy1OvK
	 hmMGY3P/tEIIGioPuxlo9GK19dudVWl6s+BNP0/4izDi7IoleTUgea5dw0vPPo38ZXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042445;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Hl37rViWO+GSB6Gk84OZikcr++j6j4lrCA4NMMSr/BU=;
	b=PDBssiOvsaE3QZ30kff4JgObZcsWDG6QS76Fd7UeAn5awrRHfkQr9Mb0XjZN29ZlD7kJ
	 PvhaA3n0KHNJZCg14RC6VCD24AyARk+YkMcSsabwfz7FlGkcvV5DTHfc4ginvaTJAoYuJ
	 DbfqD7irDbRlHLEH2pHbaK6FuXNMVH3emilHSCzK1qNWEKVSSaLU1RUoLtV8e/tsSF4Jw
	 AZ3iWfvcUO1jP/jtqFrBi9MrIJy4wXxSvjHSK7ePlqBhsc61LrneMTOXJewrzWsqYMAu4
	 xk3HTpVvc5ETeYyOKPxscHJAuMkWtG4CNej7VTuuRVB2qcW6HbPS9suKNMVAx3Jv3KQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rlTCguoW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7020606A31C;
	Wed, 18 Nov 2026 22:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rlTCguoW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 101571F000C4;
	Wed, 18 Nov 2026 22:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042445;
	bh=Hl37rViWO+GSB6Gk84OZikcr++j6j4lrCA4NMMSr/BU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rlTCguoWvL0JwhrJFIu0DMj45BFNxzNXL4OmI1BkCjc1RLMu/33HmJ1TxFAI+eO6G
	 JNsqAlkKTB2zGxCugg+/3LhQTkfFWgQ1LgYDu+FfCLZrE2Aq5Y59JIxCdFAja4njk5
	 FraNa1eaEjn90DsczOyJNQFDdL/sLHSWygurV67c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Zhang Yi <zhangyi@everest-semi.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3174/3318] ASoC: codecs: es*: Modify the registers related to ALC RECOVERY
Date: Wed, 18 Nov 2026 16:03:16 +0100
Message-ID: <20261118150455.049013350@linuxfoundation.org>
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

From: Zhang Yi <zhangyi@everest-semi.com>

[ Upstream commit dd64271fe1b935252cf454a72a558cbdb7be57c5 ]

The register related to "ALC Capture Recovery Level" is ES8326_ALC_RECOVERY,
not ES8326_ALC_LEVEL.

Fixes: 5c439937775d ("ASoC: codecs: add support for ES8326")
Reviewed-by: HyeongJun An <sammiee5311@gmail.com>
Signed-off-by: Zhang Yi <zhangyi@everest-semi.com>
Link: https://patch.msgid.link/20261026054837.13618-2-zhangyi@everest-semi.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/es8326.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/es8326.c b/sound/soc/codecs/es8326.c
index d2ed0f41af4b6..d12f7bbb25652 100644
--- a/sound/soc/codecs/es8326.c
+++ b/sound/soc/codecs/es8326.c
@@ -96,7 +96,7 @@ static const struct snd_kcontrol_new es8326_snd_controls[] = {
 	SOC_SINGLE_TLV("ADC PGA Gain Volume", ES8326_PGAGAIN, 0, 10, 0, adc_analog_pga_tlv),
 	SOC_SINGLE_TLV("ADC Ramp Rate", ES8326_ADC_RAMPRATE, 0, 0x0f, 0, softramp_rate),
 	SOC_SINGLE("ALC Capture Switch", ES8326_ALC_RECOVERY, 3, 1, 0),
-	SOC_SINGLE_TLV("ALC Capture Recovery Level", ES8326_ALC_LEVEL,
+	SOC_SINGLE_TLV("ALC Capture Recovery Level", ES8326_ALC_RECOVERY,
 			0, 4, 0, drc_recovery_tlv),
 	SOC_ENUM("ALC Capture Winsize", alc_winsize),
 	SOC_SINGLE_TLV("ALC Capture Target Level", ES8326_ALC_LEVEL,
-- 
2.53.0



