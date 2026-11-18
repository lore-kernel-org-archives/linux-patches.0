Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061894;
	b=ZxpWWCTZCqDpLE1WhkzaxqG9vHEc+gWUITWeZ4NmIv9Nq3obD4q+QahYYlsDCVzYAYhn
	 Ayi3By7F9vKV5b+jhb6buYCgyus6ogJoKnxxoTf5GSOqK6kVVZy/j7t8fs9WfqDzRWbEM
	 iB3eC3sn4Zl1+2HF6sD5bsfABerQ5k1MhvbWfNFhlwhVrqGWSDpEmp7zIvfzJoqUSx5IR
	 GomaI3KN8aefN06VTgtXA1VwsvQxkXTqETSdwKKH3TkcQUeLQXdWJ5boFkpVLVCb3PkoJ
	 JGELxeCYIX9GRJBXTGggBR/eh8StqbITKKVgjDqCvoXohF6U3x7mMgEgWs/3zIdsp8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061894;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9oDp7o0Ftj6lSnC1ADiBEgvA+uagT3/gf7SvIdKBbxQ=;
	b=5IF2wKRmLoUHPDTttCGXSMiOyvfI8SLp3W/0cFH2zh7aXhCjwh6tRyotVe6lOzm/KAEO
	 AjzDwHOOysScrk8uluhhPQgKmCzyVXDLlnSbWVgpNeNPeRH/dyQckaFmK48PUuWdNodpk
	 XN+rqdXDmACHs24iuihCMpgHjG61MQWFjt7EEGrbSH0G2IPjlfe25ADSBI+X3/pfZ3pmX
	 GHY+QB2dfHG60AvPqzqYdbwqh0+45GtXBTwhCmLP+hPK3wIKN0ivXDbB3s+RMf0UgEoTZ
	 i/L8rXtnlPENCtCnY/a/Mn5RjdO2n7hpWzmGMwx/A+VlfpYTCD0rk5Imm/aW6XF62Pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MfUTTgiC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E4B606A325;
	Thu, 19 Nov 2026 04:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MfUTTgiC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DE991F000C4;
	Thu, 19 Nov 2026 04:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061894;
	bh=9oDp7o0Ftj6lSnC1ADiBEgvA+uagT3/gf7SvIdKBbxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MfUTTgiCGJ5HCGKeLKTmPoog+3U3zaK0j5LC5GYGtu6fdCnTmy7jasLontagrnYPV
	 eaVLcA5uRjqdo2KgD2q+PFEA7+eeACY6C8tPmvybnLrE2cGU4N4HVteQ9eHHI0WVKH
	 KpxPstaYfK0uUPAK6oH+/PHFOhFBomtiPaDR+2BA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1715/1848] ASoC: codecs: sta350: Fix definition of limiter threshold controls
Date: Wed, 18 Nov 2026 16:02:33 +0100
Message-ID: <20261118150031.471214805@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index cc9c64bfd4147..7909fd83d0c12 100644
--- a/sound/soc/codecs/sta350.c
+++ b/sound/soc/codecs/sta350.c
@@ -510,28 +510,28 @@ SOC_ENUM("Limiter2 Release Rate (dB/ms)", sta350_limiter2_release_rate_enum),
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



