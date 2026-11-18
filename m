Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056697;
	b=MOJf17ktzaoXB9alwwXuiFIl3wPy37Jp3OrdQzOMuCr6dPfmpXhONC2j9/hWPsBHD8li
	 tUmMvghMCB+PxbV0/qW+WKKnp2w7Tgxa/z83buymGNwcu0KV9giyY/6w8T4xuYUiNT9Ws
	 xEQJy0MSds8zFKixj/Qh7zIf+N+o5zBDtl2Xht5jIE/SN+B8fa8pxfsz76wL129P+w9Tj
	 rvgYH9iziFa30QQ5BA7ZUXqutwKRjO5edqhuFas323MDIRRN/4K3IScl8bclyem/ektMj
	 9GTUwP/lZOfCAWHC0Y2eox0vq1X/B8M1RZ9Hvk5vFiT/2pTY5YL34zkyWQG+/dGbJdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056697;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EBHVRFlny4Dt+mnjbi/PmABxOOpz/svgU+uhZe8S/A8=;
	b=u87oeE4Qj+3haIPltKJUMdji+Z/p5W2CCP6NpnEAnxlA1/GpJLO8JEFXUH/T4K1lfdSN
	 DoyPoIG4INCEOQmgLz2CrJW1TfqbBj8yrl53kDEOiJwJm+xQoPsY22OxVD7r/3FcXHGgt
	 b2xpCK2QQ8ulOm0xsCQqcgLnY44els82rTsw4NwI+gqRmBQomhPJL6n6OJDv7Bb0+0eEO
	 TEnYWyRH/mGSEgxUuuBi0NM68LXVl+/yigcqBLttxTdGW8vBj7hzzHMtBZ2h07RRxYpEW
	 4BDAeqDVL92zr1rzcnW/VcjT2lT9fpHaRcWcrGwpdDx/Jc7YQWECZ/qH99CI+2D8OLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g+VPXnKo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61D80606A31C;
	Thu, 19 Nov 2026 02:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g+VPXnKo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFEFC1F000C4;
	Thu, 19 Nov 2026 02:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056697;
	bh=EBHVRFlny4Dt+mnjbi/PmABxOOpz/svgU+uhZe8S/A8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g+VPXnKo8JGjFj4OhyQqKAudw1kZkZff6SvEgcBPqcRbmmDmZ+klKfFIRWgbOCBO+
	 91ncczXrKkh3ZNy/RYsyc80/fGA7uuXgc8p5wNN7Se6RUNuPcTFImRf5og0uQpesuP
	 6a7/Rb4NFG3nct3BNz2IzPBVAWcoMH3POeKxPWI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2039/2214] ASoC: codecs: sta32x: Fix definition of limiter threshold controls
Date: Wed, 18 Nov 2026 16:01:55 +0100
Message-ID: <20261118150132.298344404@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index add3af887515f..7bc570ba96fb5 100644
--- a/sound/soc/codecs/sta32x.c
+++ b/sound/soc/codecs/sta32x.c
@@ -484,21 +484,21 @@ SOC_ENUM("Limiter2 Release Rate (dB/ms)", sta32x_limiter2_release_rate_enum),
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



