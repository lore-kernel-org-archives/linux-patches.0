Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027344;
	b=AUh6/rCivkfr2J43jSHfHYf8MO+IX10zY1nscX8U/W6UlessXEPqrrLCwsn2NC3TZnGx
	 LNsDW4HwJd5tiswFlz+D/s2YY3sDpYmNkNnto5qr6XqLY7hlGcyx0KW07KBBV5BBn+zfQ
	 vHVxv3djG8YEjWHemXV/eYJz0DDA2A+Yw9eFYXa1sYR1nzWyoLjlEFrx4Eb3lJg6FYvU6
	 U1QPFRFk8cpq5Z6Pe6x12Vsih5RTBFnHa+6r3RrSWLqfZoPHUhVNhzlI8rh7/EeIW0GgI
	 Rarvq8szVpzkc/pGuOxQeXIfRu+MKvSgmCaOM4ZFIBg7313aYZqDIbvL9skII4QCBEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027344;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sYHqHT6BTm52HMRJwSCk1wP2ItQ2ezBf+Pd34RgwLPM=;
	b=H1NvTPl/EoEIK5ikM0/uDEVU7lnPae3xyYQMb3LoD1LnJlBqS0rOlo65JNj/PbH4ZPji
	 bIrDf4NI3E0zNbuQMQai/PqBgC0lALtL5LP1pvGIZqydXxiAssfoS9kb1aB/kBc1lfIeL
	 HHf6mknfGxm/ve6kijzVswl5lGEqfdN3qIqVO7KRUaLFmd+4ZQM3+V7ly24P2qKf1irPY
	 6dwUvpA0JgQNCvC0PlpySQfKx2iEV5cHweKP6VuYllT0nW1aMdYsvqcX/UhDPPGzNJFu/
	 z+s9CNk2Er/SV8cuer3V2rp6hiHvfXVyr99njXvpdYLtwalXKI80hKHGzt6QdWyyYyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vU9G8u6W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A6660A260B;
	Wed, 18 Nov 2026 18:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vU9G8u6W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7667E1F000C4;
	Wed, 18 Nov 2026 18:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027344;
	bh=sYHqHT6BTm52HMRJwSCk1wP2ItQ2ezBf+Pd34RgwLPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vU9G8u6Wpc+JCE/UQh/VPGJ6Uv/3YExvqFx3vA+en/3XHuwNuFFtj5twMnZPdTF4g
	 R7sn9m/QdtjCVTXtsC2jtgj2wos9BPwkb0JPCpv9l6iP6I/ZuTD6xAkgiPWplAA1Z3
	 evKsCmB0S1w5qRF9ddWTmfubgUgFaqK29VaVqSt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1756/2151] ASoC: codecs: sta350: Fix definition of limiter threshold controls
Date: Wed, 18 Nov 2026 15:58:11 +0100
Message-ID: <20261118150225.817022400@linuxfoundation.org>
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

[ Upstream commit 77623752c156763d7a80414afe5b769ba4532bd3 ]

The limiter attack and release thresholds are the two 4-bit halves of
one register, so their maximum is 15, not 16. With 16 the controls on
bits 3:0 also write bit 4, which belongs to the other threshold.

Fixes: 2439ea1f0f8f ("ASoC: sta350: Add codec driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/d65a21665a1e0d63dec174dd3691bd97764b8ae0.1792135145.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/sta350.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/sound/soc/codecs/sta350.c b/sound/soc/codecs/sta350.c
index ee67b13ab35aa..73b1d4bba1233 100644
--- a/sound/soc/codecs/sta350.c
+++ b/sound/soc/codecs/sta350.c
@@ -506,28 +506,28 @@ SOC_ENUM("Limiter2 Release Rate (dB/ms)", sta350_limiter2_release_rate_enum),
  */
 SOC_SINGLE_TLV("Limiter1 Attack Threshold (AC Mode)",
 	       STA350_L1ATRT, STA350_LxA_SHIFT,
-	       16, 0, sta350_limiter_ac_attack_tlv),
+	       15, 0, sta350_limiter_ac_attack_tlv),
 SOC_SINGLE_TLV("Limiter2 Attack Threshold (AC Mode)",
 	       STA350_L2ATRT, STA350_LxA_SHIFT,
-	       16, 0, sta350_limiter_ac_attack_tlv),
+	       15, 0, sta350_limiter_ac_attack_tlv),
 SOC_SINGLE_TLV("Limiter1 Release Threshold (AC Mode)",
 	       STA350_L1ATRT, STA350_LxR_SHIFT,
-	       16, 0, sta350_limiter_ac_release_tlv),
+	       15, 0, sta350_limiter_ac_release_tlv),
 SOC_SINGLE_TLV("Limiter2 Release Threshold (AC Mode)",
 	       STA350_L2ATRT, STA350_LxR_SHIFT,
-	       16, 0, sta350_limiter_ac_release_tlv),
+	       15, 0, sta350_limiter_ac_release_tlv),
 SOC_SINGLE_TLV("Limiter1 Attack Threshold (DRC Mode)",
 	       STA350_L1ATRT, STA350_LxA_SHIFT,
-	       16, 0, sta350_limiter_drc_attack_tlv),
+	       15, 0, sta350_limiter_drc_attack_tlv),
 SOC_SINGLE_TLV("Limiter2 Attack Threshold (DRC Mode)",
 	       STA350_L2ATRT, STA350_LxA_SHIFT,
-	       16, 0, sta350_limiter_drc_attack_tlv),
+	       15, 0, sta350_limiter_drc_attack_tlv),
 SOC_SINGLE_TLV("Limiter1 Release Threshold (DRC Mode)",
 	       STA350_L1ATRT, STA350_LxR_SHIFT,
-	       16, 0, sta350_limiter_drc_release_tlv),
+	       15, 0, sta350_limiter_drc_release_tlv),
 SOC_SINGLE_TLV("Limiter2 Release Threshold (DRC Mode)",
 	       STA350_L2ATRT, STA350_LxR_SHIFT,
-	       16, 0, sta350_limiter_drc_release_tlv),
+	       15, 0, sta350_limiter_drc_release_tlv),
 
 BIQUAD_COEFS("Ch1 - Biquad 1", 0),
 BIQUAD_COEFS("Ch1 - Biquad 2", 5),
-- 
2.53.0



