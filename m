Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021018;
	b=W+KsmUvmi7KmvKzW4XULxWrLEoBMtbW5JsSKRl4Mf8wzqXXkLnZx/U5KjKqTMx8jnJ7/
	 v++41VdHdeYQcSz7dMQHPV6pHWs8N3v8nRzuknsMD43oO25FWqYxOqVHevrtkFjGRUv2j
	 hayvqYFKdT3Y8ivIUSp9Ql+mMpqhjt6zBKILPdQab1KQ8jYJbTwsphBBWc5WaE+6DvglS
	 biqZRGvmcxqypschOmQeUjT/tBDoRcY/xOZXctUGLVTXO+qwZOwMMndLwGoEzDjh9dImP
	 q8ymjbbszvA+arWHo+hvr99Tzr0CyNKCXzUlNw4rZ2MpDNuEfyku+sI7At5i5dvXE7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021018;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cll3ZLLQV7PczLU5pEiAgwqTgtgtMXHoty126mqG+IE=;
	b=3cqa5OFfdlb1KOxfCyhlffTACZlfaH6bz8uWeJKEEs4ejekl22/LuvfvrbsA7tqjj229
	 wa1YEaXtxM4tZJsTrykqYE8ZG4wW/Gooqr98FtpSC4eaXShqUgpkFke4Nq1EhSxDQgg0m
	 Ri3GSmsfvSjZV+uJRld3fUB1ckQwe4N1YGOuoamDb/GtjVk8lc/G7XujFlmMjVuX1oOCW
	 dycQ5/CCVizd+BWXwOUmWd6MIAiGuTzPvKGCo27aBINBG3GatYQS2ar3NEbPsHQ06F+0e
	 rshV40jQ4perenv2cjJK48wTYsOYNw3Exs8F0KetCBLhcMUIJIf92EfgIIjXR8lgg4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tAq5TMCQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B71606A31C;
	Wed, 18 Nov 2026 16:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tAq5TMCQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C7181F000C4;
	Wed, 18 Nov 2026 16:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021018;
	bh=cll3ZLLQV7PczLU5pEiAgwqTgtgtMXHoty126mqG+IE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tAq5TMCQgssstl8FLCiW/xFTCNivL1Eu7gUa9VcZ2DoOXXPsVul/rgzitllr/XkLx
	 43VR6YXtFyS7BS5Szn9zKbD2wqOYjj6RV3Gf1QAUT/hfGajse2VDo7tmWCrkaiFB92
	 4kM1fQFLkG6+lWjzp5c99/nsLVXUkA5zpovD2ZlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2141/2651] ASoC: tlv320aic32x4: Fix definition of TAS2505 HP Driver Gain Volume control
Date: Wed, 18 Nov 2026 15:56:21 +0100
Message-ID: <20261118150402.944222413@linuxfoundation.org>
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
index 9e0e4aa2b09c4..1695441a1f202 100644
--- a/sound/soc/codecs/tlv320aic32x4.c
+++ b/sound/soc/codecs/tlv320aic32x4.c
@@ -1063,7 +1063,7 @@ static const struct snd_kcontrol_new aic32x4_tas2505_snd_controls[] = {
 	SOC_ENUM("DAC Playback PowerTune Switch", l_ptm_enum),
 
 	SOC_SINGLE_TLV("HP Driver Gain Volume",
-		       AIC32X4_HPLGAIN, 0, 0x74, 1, tlv_tas_driver_gain),
+		       TAS2505_HPVOL, 0, 0x74, 1, tlv_tas_driver_gain),
 	SOC_SINGLE("HP DAC Playback Switch", AIC32X4_HPLGAIN, 6, 1, 1),
 
 	SOC_SINGLE_TLV("Speaker Driver Playback Volume",
diff --git a/sound/soc/codecs/tlv320aic32x4.h b/sound/soc/codecs/tlv320aic32x4.h
index cfab6f8ce5acd..d0c2e1002e99e 100644
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



