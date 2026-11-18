Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050163;
	b=jL0VgWzDwjp2SihuyVrZHU0YMdFs9o7InRMEUYHtStWJnHSeJJwpe+xSzg02xEgj2ux7
	 tCaaB5Zb2rgdT3gQVaBVnveQ+hodJ9CbzmzNCVKuNICdhPpxegmcKBPOLMlKKQg9t1VPO
	 GccwxQ9lQGctqNuuj0kAUKVBBL4R8lpVRH9Dn16o4p7cXoHEHROGsPQ/a9LttYvtDpE1+
	 JYmnNSD69bHn+RWV0Qm/VYxAoPgj71nt70GKXdt3Xm4YE5o1dVXJh5k7YgGEobmEQsjoK
	 lhlfNrmNUpc9JLhkDTGK3sv8eT8IUpwLVxPWx1vIaKqeheMh+buveCFFBsXUnscv5AA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050163;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lEoZEaa/ctMdT/8GfAmB5ctyTjK9Nu9Ff68A78e1Bx8=;
	b=m6lL0SvtCi/MIjbeb4OkLBAI7PqpdyQphUeVT5s28R0Dy0YVMoVe67NHEmJ9jmWcygEP
	 2AAMI3t/jKauLrZJYmdDSkvW5Wjknh6rGjsyfEKeRYHotez0e/VUxqQaGbBGWalQ4gVkw
	 jTrHylf0/1q7d4RLFle7DMPwDGDb9CU+GGOy36szv9x0Qqs1fSIOHMtKpxPXeVI6HfWyh
	 sErRmAx5lztct1qqeWLmqaWR2Q/kXewow3/LOZ5W0zDo7R4FrOKpn79za0I3sVMzft5Fv
	 99gYwdLMMoPJlc6h5sqFtkU/sRquwZap5HMcEt9OpsYbMsxrWmsMLdw6/R4ySEHZmcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dtEUEhzx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 931AD606A330;
	Thu, 19 Nov 2026 01:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dtEUEhzx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EADF11F000C4;
	Thu, 19 Nov 2026 01:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050163;
	bh=lEoZEaa/ctMdT/8GfAmB5ctyTjK9Nu9Ff68A78e1Bx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dtEUEhzxDEeoa/+ij69Co/vKa1ro2VNfpMazvxMtz395Jp5XSmCmEb0K7qezwqdDR
	 SxrZWJNpy9CLfBGnNrjZ9FQSw69XYSCllU1KfXozai3e4+pKjCuTF6fwwXMY+nzvSv
	 0OUCMg6NvGc5R3Ml3kZSxU4z8zBdMcqqfB6mgkcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2609/2857] ASoC: codecs: sta350: Fix definition of limiter threshold controls
Date: Wed, 18 Nov 2026 16:00:43 +0100
Message-ID: <20261118150335.516537887@linuxfoundation.org>
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
index b64ef956ef778..f978d9da4e208 100644
--- a/sound/soc/codecs/sta350.c
+++ b/sound/soc/codecs/sta350.c
@@ -507,28 +507,28 @@ SOC_ENUM("Limiter2 Release Rate (dB/ms)", sta350_limiter2_release_rate_enum),
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



