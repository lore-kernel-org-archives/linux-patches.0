Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026651;
	b=3XD5ESsF7cUM0NU4ym4rZtksYnbyAkC06LRQO5wwfgxhnvru4rjDEDTAQn4W40QfnCyy
	 ajxwbveepYjxJ2joOYTcSaP96S6MgaRmHR5UezZ+8sj3ArnA6Co35NRkv6XnDmcto/qT7
	 6fXOyrzex0oysMjx5NI15ua+evQGImAdESkJTCqTij6IytsyxMQoE/z86KckO78uO74Fp
	 XQQUYODD+3zoETgkLaJIhV1tlXxb4HqFDUmhbW+caNHXsrg54S3fm1eUZCqL6xMbejFkh
	 yoFQ/MA8xIt85pxh73yF11fKqsbLNsTB4Sn+kVCqHCRdBQ1fSJdkPjKUqsZIfwI4nAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026651;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Cgvz4Be+EKpZidlmatf5xXz84UN+d3EVh6AVLtMOwgg=;
	b=CSS33Jdj3dyCD8JsgJL3n5n225HyO3vEd39K0esWMK1acMWWm5FrHmGqeyFYdlmbeW8Y
	 6RpTFekMYSXTnqUKoFVmUhiZR7GpB/3e8ulhn7Y3+RvEUiukE/Vqp/R7LHXwVwkbwgF/r
	 3SXPc8tAJcDcARDIm0GHIxF9suGF3pX0ctrMdBbnA/IJeIAm//AoTjhmBkeLnU6WyemGm
	 fknJbGW/Gm3hN4iQcxaPdfO1B/e8v42C1htkZtw0c/c5CJU5I9dHuj7Cv/J/FUI/P7auk
	 S/DWr5RfP0fxc3yXZ9cVWbS4bCC+NXO97Pcm5+EK1nQRvqnfprkLtr+eauUCD2pPFLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QRSCTTFV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05FA0606A31C;
	Wed, 18 Nov 2026 18:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QRSCTTFV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E4411F000C4;
	Wed, 18 Nov 2026 18:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026650;
	bh=Cgvz4Be+EKpZidlmatf5xXz84UN+d3EVh6AVLtMOwgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QRSCTTFV0Prlnu8ud8f31J2K0LeJlofd/LB3YLX/MtVaz2R4fmiPy+Kb60g5hxCyh
	 FTPvJJItFG8fgR3ohAuydJbNULB3PzkXiMS0nhPpXg7XJ8MKTCiLNO2heI9roej3Qz
	 PzpXHNgfORODpXtKcLrZ4DBWtX3hXyoZgY8J2cQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1508/2151] ASoC: codecs: wm8985: Fix definition of ADC 128x Oversampling control
Date: Wed, 18 Nov 2026 15:54:03 +0100
Message-ID: <20261118150216.794541227@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 2e2d07193c41f..39b6f45b39173 100644
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



