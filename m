Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042055;
	b=CmIeOvouEEE45T7QpWxWePl88S/7WzdnKaBwwClhJp5Mvb9nzb3HMB2x0I8fAXptPeME
	 GobrNRp75MtsKDT1AfWB3gbIpZOgodfl3q2jToxdeuKVR2aPwrubLCuCQxmlehBWrIUlY
	 kETFGXlmpuJjaKCl27Zdcs30IO7l1VRFJ3jzQQoAc16NMVDO0bXFYckXJ+IlPU0+RcNlI
	 5hQXiDy1pGeJAx9jxAvO5tIGyun7ARjSfpOD3nl3ITfRxap5cymkhqycihlzsEcnKS1Km
	 E90pj4ZtzvFkkVxkKNw+SHDuNWPwyGo6p9ZqXuYEhPffQ9YenCbmsfI4Cer4ZgXdO1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042055;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QqZ7MO6q204fKjXWWPOuTlqhmlHzkaSRTRB5Qumwmt4=;
	b=P27PKr/vLcIbwIbimA6AyPLmEWC5cwtjlIyJiQRrZZg00xyJo+GyMfMm/y3EYAVi/0lN
	 jh3qs1c1KMH0SQEhHHdLSQG2H/zNYcZjjsrbXBihLUQzBdBBTWTqapKduXNtTcKNyyz3b
	 sp+bQU7hNnCLbctAw1ttTf1NWmqp0k+HPOgxP3+Ig0G2HTjHAdAvugf7Db4WF8AC482cr
	 1xxYcdw1SHCzhWViraJrlf3k+OOi2f7HwJ0D//jkoCkoQChZmBCUAoP7FmHf2R3ueCFOn
	 otMm2xlN+N/c8N6uMkwkIJzZZRNMDJrQCiaEZHdCbZH4IePGxy4DVC17tS2aaH+tPZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PsXqxlTF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA67E606A32A;
	Wed, 18 Nov 2026 22:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PsXqxlTF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 049DE1F000C4;
	Wed, 18 Nov 2026 22:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042055;
	bh=QqZ7MO6q204fKjXWWPOuTlqhmlHzkaSRTRB5Qumwmt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PsXqxlTFa49iQC8LqQ+kYfSJD/7Q2+p+EuiTiux4uYzBsoOjJT5CqUudnpE4Tr+mu
	 zf1OOLnmj8MIfkBzfyc3AlN1IdRLXN2luAGJAKjJpLJnHk29lHmGADxZfWVKZ+d9pn
	 g4a7g5frI3fTWezO0IPhq0gzGeoHpMBXVgCMKT2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3035/3318] ASoC: tlv320aic32x4: Fix definition of TAS2505 HP Driver Gain Volume control
Date: Wed, 18 Nov 2026 16:00:57 +0100
Message-ID: <20261118150451.225745607@linuxfoundation.org>
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



