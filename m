Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042155;
	b=m5NVtYiqQ4ESVptijgwyVq/nQKJLyrm0gycMsAu9VnC3HBcIYrSk1HP8ekJkr3bEaUUl
	 b3X1BBoh250TdA0/FidzMbQVKTvokETgjPe4n4Up1bVj6CL0kRtz+F4jV9kPlMiPJm04M
	 tRJOkIVvSBNVoYAStOi7/tdUa2TnG31ReIUNOVi2PYj1MQL/ACToDFPP2VbH/3OB5M5Kt
	 YgQyp3j4RzlHrHxk1xnUNXR0T9v/ULOUDDlE2UPz5Id9d2TWdU6ms9zUrlREYNxId4bRZ
	 nzqLSTajSGsxmVdAyUSEZACF5PJVfxU1GV57iNEv/vnLwNcQCNPfulPWQwQ0cEf5ZSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042155;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YaILK3CQLXntgsKyZxvfPTszdSEIS+okZjgetJTBg+w=;
	b=cr2PUSpGDszBwxvYU0YVSn1Mp++M2jlNl6VtrD6AMWeOrmyJ1SzRtXiU9+q7JLu2w+JS
	 OZ1ujYq3zaLOp6nu7y/6sUhINyGQp4NNUF7vp7MNZ+kdnaGq69EXXDto+RSa3/NrQY+Bj
	 fn4/e3Ta0sw0vzP4V19TLUg98DQOM2PQtxx154U5tbgZXqI+jinhj1wGxBxB2u/rw3uwl
	 Ooygp9StuntEkwdZJjQtGdCA4u5NUgG3PDSAnd2XmiZurxeH8fxNkG8fVPQKTlpZn/HDO
	 L0Uub1Lu/HEqMlfeobIXXCW/XyQropHL8GtMEZgrcqRowjtaNXgpvKY4v5Q3hxY3WNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GuhOshWM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ACF2606A320;
	Wed, 18 Nov 2026 22:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GuhOshWM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58B291F000C4;
	Wed, 18 Nov 2026 22:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042154;
	bh=YaILK3CQLXntgsKyZxvfPTszdSEIS+okZjgetJTBg+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GuhOshWM2ItRkk+ZSwJTOJcwm/g5vGvbt6DGSaFdBcwIUtBmbg4lntAaToDTgbdt/
	 oOwUazqP3ZSg3YuZW9lXXAtAn+9hxVXsDx7vaGHDoqfmfvoCc7rEq9/6Iqmx78gAkl
	 yt1Mzd8isY6rJZJbYJ9u5NPtCOZt1VJN1EZ7Tb/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3028/3318] ASoC: codecs: sta32x: Fix definition of limiter threshold controls
Date: Wed, 18 Nov 2026 16:00:50 +0100
Message-ID: <20261118150451.032108931@linuxfoundation.org>
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
index a15282b757787..f896edb3c5c3c 100644
--- a/sound/soc/codecs/sta32x.c
+++ b/sound/soc/codecs/sta32x.c
@@ -481,21 +481,21 @@ SOC_ENUM("Limiter2 Release Rate (dB/ms)", sta32x_limiter2_release_rate_enum),
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



