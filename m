Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050183;
	b=Niw6PJ5xz/n1reRvJmieiEmmpK7St2mspN1PhLW9c5aetg88Y96OB9Jz+yB0LY4g538A
	 vG023zInY2x4qEzFWQ4matPX5qJvtq2hQVYYUyhgt+QTNkKsQH1XowGU+vvH6l8Ns6tOJ
	 g4ymUBDFV8PQCRcNHiJjMO/HQP39UJNQoyB9MgSLddzIsjFHAcCFW24T3orAJNTDhB6Hl
	 JjqNcYYD7Gw2zKdfGYyVp9IHjF/P+wbPLkUHCpAy2vd+k1kTp0XUvB8s9kp8ntbFnrRPJ
	 RHLgpWYtWrgItWr7CkXcN6PG6xQW9lu8PqrCsLFUVlx8DVyDeblOnrRp7xunx3OZE6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050183;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=87/+c40Y/iOYQHzYG3C/jtzhf9gFsogBLc+A11Urfjw=;
	b=gbhwAi6IJF6zH0nAJZttV1FfDgP3LY/Wuvfb1cngfxpD2KAIRJYcuClHTP0DOy0RI5Lj
	 41BRinslTpi6wHD35qYTEhL28VoHeLS/7NnEiOfhfJ5bxXCojdr9u2rtKS2b3QiJFq5h2
	 StsUVH6Z4/D9zrFbVCH4DG6MY/x/e3cvcE9so85ALpIPF7EJlCY5ZqBZco20kRxUk3A5L
	 kutnpuMrtehctrBbO9AZFlRJ/EPuJ0ss9mCAJobNDrShWJL9+YOUPBDwXXzYGNdAcbRab
	 vSTmiAlvTUra2UAQrtD/ZpTZ3HAIo7bmRqnffhwB/gwMT7eL0VjQjXiLDVDWFfCi32A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R8MiFuOJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB04606A32F;
	Thu, 19 Nov 2026 01:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R8MiFuOJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 922E41F000C4;
	Thu, 19 Nov 2026 01:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050183;
	bh=87/+c40Y/iOYQHzYG3C/jtzhf9gFsogBLc+A11Urfjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R8MiFuOJlyGVo5pAOWUo/yI3Q4T+ZQCIEXUqdEn6DCf3SUHsCUdUQrJfxtzuKfdLW
	 xZ08UcxmXNUi9uNBCEFZZQv6uRfuyH4I3iKj9N2Xmk9v7wNE6v4SsZyIa/6dhZHOa+
	 d/hK6d3YHhOZ0Dx6Vin9CcvGN1ZURZMemXQfP3cA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2616/2857] ASoC: tlv320aic32x4: Fix definition of TAS2505 HP Driver Gain Volume control
Date: Wed, 18 Nov 2026 16:00:50 +0100
Message-ID: <20261118150335.768616178@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit f28c09b7e62fb5ead65bdfab93012a86d64b6540 ]

The TAS2505 HP volume is bits 6:0 of page 1 register 22, not of
register 16, which holds the HP driver mute (bit 6) and gain
(bits 5:0).

Fixes: 2169d6a0f072 ("ASoC: tlv320aic32x4: Fix TAS2505 volume controls")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/e50b88689e8efd353ee597a6692ab4db30aa63e7.1792135145.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tlv320aic32x4.c | 2 +-
 sound/soc/codecs/tlv320aic32x4.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/tlv320aic32x4.c b/sound/soc/codecs/tlv320aic32x4.c
index 895ff39f32ae3..7298971a5251e 100644
--- a/sound/soc/codecs/tlv320aic32x4.c
+++ b/sound/soc/codecs/tlv320aic32x4.c
@@ -1067,7 +1067,7 @@ static const struct snd_kcontrol_new aic32x4_tas2505_snd_controls[] = {
 	SOC_ENUM("DAC Playback PowerTune Switch", l_ptm_enum),
 
 	SOC_SINGLE_TLV("HP Driver Gain Volume",
-		       AIC32X4_HPLGAIN, 0, 0x74, 1, tlv_tas_driver_gain),
+		       TAS2505_HPVOL, 0, 0x74, 1, tlv_tas_driver_gain),
 	SOC_SINGLE("HP DAC Playback Switch", AIC32X4_HPLGAIN, 6, 1, 1),
 
 	SOC_SINGLE_TLV("Speaker Driver Playback Volume",
diff --git a/sound/soc/codecs/tlv320aic32x4.h b/sound/soc/codecs/tlv320aic32x4.h
index 3bc6ae355ea81..9652920773077 100644
--- a/sound/soc/codecs/tlv320aic32x4.h
+++ b/sound/soc/codecs/tlv320aic32x4.h
@@ -94,6 +94,7 @@ int aic32x4_register_clocks(struct device *dev, const char *mclk_name);
 #define	AIC32X4_LOLGAIN		AIC32X4_REG(1, 18)
 #define	AIC32X4_LORGAIN		AIC32X4_REG(1, 19)
 #define AIC32X4_HEADSTART	AIC32X4_REG(1, 20)
+#define TAS2505_HPVOL		AIC32X4_REG(1, 22)
 #define TAS2505_SPK		AIC32X4_REG(1, 45)
 #define TAS2505_SPKVOL1		AIC32X4_REG(1, 46)
 #define TAS2505_SPKVOL2		AIC32X4_REG(1, 48)
-- 
2.53.0



