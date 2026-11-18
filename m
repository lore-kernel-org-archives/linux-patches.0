Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021819;
	b=j6Hs7Uk71ESUu+HKkCeZ2dj71x6riKnvn4LlfZsxQiyoMHUc6u0Dp230zDN4SU1CdZXk
	 JP46yJMYHh/nMcbY9JjgN/gsBAGSZhdbNG+0NUlllWFB/V0QEL2N3j3Bq9QlqOG/dVCJC
	 si80ibJFKyGChDP1uoLd3kOT9Nf5eHNCMa6upb6uqlLwqEJ4A/XyJzbEP4xyza2K4bSBL
	 2zKDK4CTCv1qP5WE8Ru1MhZXaZlCXmw+SYotMy13lDRXAYLAQkIpaxdBajMw/ahN3JVPD
	 b9jnbpHsdV5zgRWsORk1cjnA7m22kosHYV+pdJfjqwvzZVMJneRVpjVa10z/uC97rzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021819;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c0poLMors2mpLuGM9V9JRBZfOLMOHz0G7sdgo6Hy5qk=;
	b=sTjB1uSBk7gStTr16/JyxQk5nlFLmY5oNgSdewe+O8ar6IIiwtR93m/Glbw3+iIjMsWz
	 oDFP9MUkH5DIx9L5EwoE3Avb3znFeVD832HuhHC5zUTv+H+Kol7Z73i0AzkSDLDPmA+0Y
	 2A8HWMDupf8ES76ZJUXKO/u3UpgLyV4HJcdwDD87bBuxMr8WyCHlRs3abxJTKUwQO5whU
	 /HnVPdjS7u8kQZPAApDu+tc9FhcLr0R3hNVukssvvJr4rqghzAh0tMNTdcIDCx4fAl9QI
	 ridda1cRQtnhVUlfm0M7ze+0EFjyT+FyS8JNlzWqwemNJ5A1GKnZ7eM6ib2Lq4GR1lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ZFMqX//C";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F8F6606A31C;
	Wed, 18 Nov 2026 17:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZFMqX//C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97ACB1F000C4;
	Wed, 18 Nov 2026 17:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021819;
	bh=c0poLMors2mpLuGM9V9JRBZfOLMOHz0G7sdgo6Hy5qk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZFMqX//CdXFS4v8GaZqhCalud/oGYDEfw6SkiMQeIH6fEm/+Gd5/+3LO/CP2UgTUk
	 DieKeevNq/TIO9Az/Ii4hsde4sYd896RBAU1N9djhrIGmGGubrqttebHkqzmaCg3cs
	 bRM42IxxIHDj5MxLVw+ICWE0d+1jXKfIwrpV5dkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Zhang Yi <zhangyi@everest-semi.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2441/2651] ASoC: codecs: es*: Modify the registers related to ALC RECOVERY
Date: Wed, 18 Nov 2026 16:01:21 +0100
Message-ID: <20261118150413.044661315@linuxfoundation.org>
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
index 32f39cdff79d8..61396671cf9f3 100644
--- a/sound/soc/codecs/es8326.c
+++ b/sound/soc/codecs/es8326.c
@@ -264,7 +264,7 @@ static const struct snd_kcontrol_new es8326_snd_controls[] = {
 	SOC_SINGLE_TLV("DRE Gate Volume", ES8326_ADC_DRE_GATE,
 			4, 0x07, 0, dre_gate_tlv),
 	SOC_SINGLE("ALC Capture Switch", ES8326_ALC_RECOVERY, 3, 1, 0),
-	SOC_SINGLE_TLV("ALC Capture Recovery Level", ES8326_ALC_LEVEL,
+	SOC_SINGLE_TLV("ALC Capture Recovery Level", ES8326_ALC_RECOVERY,
 			0, 4, 0, drc_recovery_tlv),
 	SOC_ENUM("ALC Capture Winsize", alc_winsize),
 	SOC_SINGLE_TLV("ALC Capture Target Level", ES8326_ALC_LEVEL,
-- 
2.53.0



