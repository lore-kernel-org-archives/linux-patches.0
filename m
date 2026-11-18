Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027341;
	b=l9ga5+nFXEo48mG/2LHBqD98pFqFG/uT60zMR8S32jecO1c5l5dkNHC+K67QQwcwpGL0
	 2eF4MSSeEEZpb3z9/miTjAiZIcHke8nyeqOkJNPUtMJ7lvfjtL/45rkxdFvPBeT9iozMe
	 wktpxnTmSDMDiKJ9xBhQGboiCkz2IFCGza/Rvkv7EngXoOfaGIlNvbRg3MY9u1XQN8+Z+
	 z7tyV8FCRMTYUo4clYAKdyOJWZ9WavS2EuZcP+YGwi65H25rygRhrONeuM/YijcFBbg4w
	 lv8iqmHqgONCYOHFaLUtfjcBieMHDu09iJF1wyERrIY9TArThfoKqtU5mSpw3+nwdBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027341;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pMcLspIJpYSLaoO9xSTGu0ls0Afgqb9nouV3GnHAOro=;
	b=pVwnOTAFOV1IvZoyf6orLVgaaW5ofxd1ZUfrApU//bblzcxmo/UTWJbPo/F6S0NgMTjN
	 hBhKT5IEtNh9GXaBss300WR60RDaAMTOvRI0M46XAzUeDHON6KCgTHs+CphIgx4CUSaxm
	 ys27lb2VsbbtFjcGX7irXDxE7gAHgJ2BHkUchCyGdMXkhTrPNFFZtqtEp7omutouqS0Zk
	 BAgBMtyTGhk7xaqP3LlWJRvuqiUNwhWOCRgWqRyQuYPyAY4jVQti5aipxNKJOmwgBz5u0
	 nmXZhHgRZAJjxwU7z82QOuV8OHCsbVCTCpfiXecrG+sr1rGtFh3w4D2U0E9o1pfkgfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BbgpJjWk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E71E606A33B;
	Wed, 18 Nov 2026 18:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BbgpJjWk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B747D1F000C4;
	Wed, 18 Nov 2026 18:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027341;
	bh=pMcLspIJpYSLaoO9xSTGu0ls0Afgqb9nouV3GnHAOro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BbgpJjWko8YMukti26xK8RBXT7V2bvrjkLePSUK6UHJfXZOmR2zGqPUiVBZ8Puz/u
	 tuKjjn8Fo85aysaHDKa+Z110xI1MNIVcnpITGU+fwgLf4PdF7gu6/7hlz2fiCgW+GQ
	 EvqccR78Xpp6rB2kipLbfx+NiVeq5t+8Am7w/YQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1755/2151] ASoC: codecs: sta32x: Fix definition of limiter threshold controls
Date: Wed, 18 Nov 2026 15:58:10 +0100
Message-ID: <20261118150225.781780784@linuxfoundation.org>
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

[ Upstream commit e06bf60ee5bffa9eeacff0bf8b03d4572b04f67d ]

The limiter attack and release thresholds are the two 4-bit halves of
one register, so their maximum is 15, not 16. With 16 the controls on
bits 3:0 also write bit 4, which belongs to the other threshold.

Fixes: c034abf6e503 ("ASoC: add STA32X codec driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/179118fc7680b2b872d1f917b7fd21f54a73a6d8.1792135145.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/sta32x.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/sound/soc/codecs/sta32x.c b/sound/soc/codecs/sta32x.c
index 1c3e94fffe79e..739813d051dfd 100644
--- a/sound/soc/codecs/sta32x.c
+++ b/sound/soc/codecs/sta32x.c
@@ -510,21 +510,21 @@ SOC_ENUM("Limiter2 Release Rate (dB/ms)", sta32x_limiter2_release_rate_enum),
  * two different enum definitions; provide both
  */
 SOC_SINGLE_TLV("Limiter1 Attack Threshold (AC Mode)", STA32X_L1ATRT, STA32X_LxA_SHIFT,
-	       16, 0, sta32x_limiter_ac_attack_tlv),
+	       15, 0, sta32x_limiter_ac_attack_tlv),
 SOC_SINGLE_TLV("Limiter2 Attack Threshold (AC Mode)", STA32X_L2ATRT, STA32X_LxA_SHIFT,
-	       16, 0, sta32x_limiter_ac_attack_tlv),
+	       15, 0, sta32x_limiter_ac_attack_tlv),
 SOC_SINGLE_TLV("Limiter1 Release Threshold (AC Mode)", STA32X_L1ATRT, STA32X_LxR_SHIFT,
-	       16, 0, sta32x_limiter_ac_release_tlv),
+	       15, 0, sta32x_limiter_ac_release_tlv),
 SOC_SINGLE_TLV("Limiter2 Release Threshold (AC Mode)", STA32X_L2ATRT, STA32X_LxR_SHIFT,
-	       16, 0, sta32x_limiter_ac_release_tlv),
+	       15, 0, sta32x_limiter_ac_release_tlv),
 SOC_SINGLE_TLV("Limiter1 Attack Threshold (DRC Mode)", STA32X_L1ATRT, STA32X_LxA_SHIFT,
-	       16, 0, sta32x_limiter_drc_attack_tlv),
+	       15, 0, sta32x_limiter_drc_attack_tlv),
 SOC_SINGLE_TLV("Limiter2 Attack Threshold (DRC Mode)", STA32X_L2ATRT, STA32X_LxA_SHIFT,
-	       16, 0, sta32x_limiter_drc_attack_tlv),
+	       15, 0, sta32x_limiter_drc_attack_tlv),
 SOC_SINGLE_TLV("Limiter1 Release Threshold (DRC Mode)", STA32X_L1ATRT, STA32X_LxR_SHIFT,
-	       16, 0, sta32x_limiter_drc_release_tlv),
+	       15, 0, sta32x_limiter_drc_release_tlv),
 SOC_SINGLE_TLV("Limiter2 Release Threshold (DRC Mode)", STA32X_L2ATRT, STA32X_LxR_SHIFT,
-	       16, 0, sta32x_limiter_drc_release_tlv),
+	       15, 0, sta32x_limiter_drc_release_tlv),
 
 BIQUAD_COEFS("Ch1 - Biquad 1", 0),
 BIQUAD_COEFS("Ch1 - Biquad 2", 5),
-- 
2.53.0



