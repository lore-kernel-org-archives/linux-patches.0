Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041566;
	b=Ds+Yn3TVHu2HkeQMuACidlRcgGDdJ/vmlWjRoc/QqnaPuSg5pjaVWc95nCEhCCF8CbF6
	 GMUGckgjKQnYIbo3BD7ugh5369KYArn57PEXVrty8XH+MoEKSk4Wb89wRuO8tM05LNp0i
	 lItEsShLPrmFxynNeny1xZBBVM5zhhahqqpxgJC+bqbhNVVYSdmL13XPWYdmhMw1bTtKU
	 z52S9lhen7Y1CV4R2shT5V1f8aqLJA37AxH4u/4d4nIDLWuKUO1G5gWQDlyGwCIol5L8x
	 VuWXVOYucZIP87oleHsBUJd3tyu7GI0vWDb/VF13GT6TsM9fB8npEDq498zVI9TjVtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041566;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qFDQjrsy5xIOgVJ7Jx9vBmWAt6ulLUVXPwNED0Vhkx8=;
	b=UNvDgFtOBTwFvj9B/BFJ1ajxBe6aHlO6mvyPIahq9i2B3LjQMzfacNVz/N7DjCiDDFwN
	 qi0hDISBei7gNuaA2cscDYA0S911aVOP/azEtyIX+BjYaJeqawml1B5M3IfXF94CT+urh
	 UnrFPKi6pAZe4XYQfyrnTLaX3Amko3iXMlMu0zpHyYGcrb0aFxhrWGGdSmCVPhy6kxFPC
	 5+xjLrhwzaWGtej8MiMdARy+3oh/7JFi4UlzNMNwHEDiWLiB+scg4zoOpb7chzX7UmsK/
	 i15JlVS0GXxI7LPR13mw3spd4njXv7GmOsuF+T9ePL1T3KE+yu+a3wB0o2WoJTgEicA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RmGZCRpR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D7FA606B628;
	Wed, 18 Nov 2026 22:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RmGZCRpR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 641081F000C6;
	Wed, 18 Nov 2026 22:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041565;
	bh=qFDQjrsy5xIOgVJ7Jx9vBmWAt6ulLUVXPwNED0Vhkx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RmGZCRpR757AN5BSWb9uA7rmK/Tsu/7iYL6YPE2GTzVb6Js1YA/zp7G6vt/9vNzcr
	 BbBvymr0tvhHAFFR1VFVTfDW7bnGJsT5wV601k506quL+V5O71AoFV7YmWKTxgDvea
	 /7t9bDfn3n48ROKjfmM3EJkQFD2RUdn3e9Z3vH9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2860/3318] ASoC: codecs: wm8985: Fix definition of ADC 128x Oversampling control
Date: Wed, 18 Nov 2026 15:58:02 +0100
Message-ID: <20261118150446.386467038@linuxfoundation.org>
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

[ Upstream commit a747ec6e12cf7a71e42567a479af18b930890d9d ]

ADC 128x oversampling (ADCOSR128) is at bit 3 of ADC Control, not at
bit 8, which is the high pass filter enable (HPFEN).

Fixes: 6d6f8b832705 ("ASoC: WM8985: Initial driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/00ae032401aaad740b61d664c861b72d2e5ed520.1791959026.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8985.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm8985.c b/sound/soc/codecs/wm8985.c
index 8606e0752a604..351c649e42fd9 100644
--- a/sound/soc/codecs/wm8985.c
+++ b/sound/soc/codecs/wm8985.c
@@ -327,7 +327,7 @@ static const struct snd_kcontrol_new wm8985_common_snd_controls[] = {
 		8, 1, 0, pga_boost_tlv),
 
 	SOC_DOUBLE("ADC Inversion Switch", WM8985_ADC_CONTROL, 0, 1, 1, 0),
-	SOC_SINGLE("ADC 128x Oversampling Switch", WM8985_ADC_CONTROL, 8, 1, 0),
+	SOC_SINGLE("ADC 128x Oversampling Switch", WM8985_ADC_CONTROL, 3, 1, 0),
 
 	SOC_DOUBLE_R_TLV("Playback Volume", WM8985_LEFT_DAC_DIGITAL_VOL,
 		WM8985_RIGHT_DAC_DIGITAL_VOL, 0, 255, 0, dac_tlv),
-- 
2.53.0



