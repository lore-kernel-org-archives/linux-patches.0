Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031838;
	b=caALopOV8qxQa/C+Gl+C3aRJIvhHD1T9IHSSXWn5CKjD+GTecJe6yzSEiW5HDxQqwWRH
	 Ep68NFKYotSClVTcl073S6SSahjf3vZfty+6bC/+fToDKOZSVaRnR/ZupbaszsiAu6xHI
	 oHkdKTDlIHSlvO88JBMj0DOVmu3EoxPb2fR1L5CTivzDFAoaZKfHPx0wS6VovhX8HK1kB
	 g+RaD9HZtAKgNe203IK2eZmpAPxxQqYv2C5Od4/P0BEjmemAtxxDfqmkoHv8NlGFOmZP8
	 fZKqPpwB2r3z9Y4GwjuA+kABs5rQnz9muDURbY+EUknhquEZYnWTjxdbWW6IPYQFiPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031838;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HizwdUSCHV5Zd4pv2R+Rl8s9dt+vo9fwmRW7HxnxMb0=;
	b=sk0ciJTQ5HM9cdgpOVyVAUAOnJB24ztTNxljQym5mV9lljaL5QVT3cAC9t6qJZI9lIEj
	 F07++vdZ06DlsiF4c7UnvVaaGVKV4qTLjoxzFOpqwmknKnPCH146oLgLsozD6m95UYKK6
	 UFojN8V4+H86jC6xW5ZCDrBunjijp05JhKckhd0PYxxI4hluu8w3J0XYgbyjSQOVdL3oQ
	 mM3ggbZv+WPYty2Cj2uO8GsLNzp0aCgJFFNisxcirtB19VmdKdVZJFltnmC/xLnvgjM4K
	 bWkhMzoeqIY7sCs0jwd89PUtvEp47U+VR6ct7vPdcnthtQmgABPZr6RQu8u5rjUdsVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=th2USZlL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28180606A325;
	Wed, 18 Nov 2026 19:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=th2USZlL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 407A61F000C4;
	Wed, 18 Nov 2026 19:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031838;
	bh=HizwdUSCHV5Zd4pv2R+Rl8s9dt+vo9fwmRW7HxnxMb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=th2USZlLRuRbF/u/mkvZjxtU+qp3xjDqfrwQWjb5X4ZWBLEzKSxnN5s4LMVmkm6Ot
	 O1dqV46kLV3Td2FMWxJjOxkx8IIr5ZxB5Vf120CMXMtAcVsa5utJdj8dkyLzW5L1JQ
	 mWKAc/GfwuIyxA4qDOW4ROO4cyY9JvZaYSyy6Yj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1200/1756] ASoC: codecs: wm8985: Fix definition of ADC 128x Oversampling control
Date: Wed, 18 Nov 2026 15:55:27 +0100
Message-ID: <20261118150057.613314267@linuxfoundation.org>
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



