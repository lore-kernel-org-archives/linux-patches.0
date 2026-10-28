Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209319;
	b=AwP37D0w3SG/YDNBCAUATOgUjQP9oDC+pNynZ1WHDRhYJH4cc0vFlc5TgxTYAk7YgkyZ
	 VlfOMDj1n8jXB0JbfavdlALxewN1XyIw6omwqYNznge1D/qnxMnTE1asQzQsGoU8iN0Zn
	 nN88BX+ZfxWaqqIulCsFTl0SVNVsHdUACbXdz5cdpk0Zv2O8nfuQ54Us+UztQJlm0o5Tl
	 QRwssN9xR1/j2WasL+yBDqN+8BlxhuHBUMEKw2wyKYDEd9x/zf6mcUcu5etzPFid5TUjV
	 +t9qsnv1T17QsIntDvbQss48LZV7i1cnYnGSJ7czhBPMHBMDk2XTcKrjMFo9KQ+UpTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209319;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kWFA7o1t2qaa7sEVsy2dwFXdslOJu6cUPP3fykVQSXM=;
	b=KV3Gd4/VOpkES+Xna+0DLiffHaTrMmWotH0g66k8s51BacETqTkMJL+0rK5z1tWrlpx5
	 4+lFu57+aZnh1Ud4w/Ei63iO4xlF7BaOhSFA1ECgN3dO4pTtkkPnb0Uei5AYqHOfVETmi
	 UY11j3Eyzr/Lw5QpJP+FiLlYtS4tuV0wY/24GYQl891aD7BKf1cSEwXTQOmaM5QVkyxsQ
	 TurCa+RAQ1Hxm4xsK4yUT6kXm7VUEFHypLDbuh1HHQibIvEx2PgJ/YPzOn3kYnK+fvjHx
	 eRZc2WYphHlWuVqRQmcSxsk92t5T9EdcE/o8WNVWTJe02fIDpacgWP0bfzz98lSq8sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d8vJ8V32;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7630606A31A;
	Wed, 28 Oct 2026 17:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d8vJ8V32
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCB881F01825;
	Wed, 28 Oct 2026 17:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209318;
	bh=kWFA7o1t2qaa7sEVsy2dwFXdslOJu6cUPP3fykVQSXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d8vJ8V32/kL54jH0dBzsRPKIBksfqZ/aedoZ3JNZBhPnA+/uB8uf5o6qFN0Xtq1CK
	 0Zx9QxQL295BZY9tiz+NYDr7Opw5s/YzfsuliCHdGbvRE/3gg11th0S9A9jgB55jzD
	 Z9Ur7RJWOyJIvCSBIye67xRn1zC2d9f9votL6mY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 430/516] ASoC: cs42l56: Put the Limiter Cushion control on the limiter register
Date: Wed, 28 Oct 2026 17:59:42 +0100
Message-ID: <20261028170013.673214119@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

[ Upstream commit 203436d2aeb7093290459e344e1912a418a6ebfd ]

The Limiter Cushion control writes bits 4:2 of the ALC Thresholds
register. Those bits are ALCMIN, which the ALC MIN control owns. The
datasheet puts CUSH at bits 4:2 of the Limit Thresholds Control
register, next to LMAX, which the Limiter MAX control already uses.

So setting the limiter cushion changes the ALC minimum threshold, and
the cushion itself cannot be set.

Use CS42L56_LIM_THRESHOLD_CTL.

Fixes: 272b5edd3b8f ("ASoC: Add support for CS42L56 CODEC")
Link: https://statics.cirrus.com/pubs/proDatasheet/CS42L56_F2.pdf
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/20261008130953.2446692-2-sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l56.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/cs42l56.c b/sound/soc/codecs/cs42l56.c
index 3c5ec47a8fe64..ee41b512a4fa3 100644
--- a/sound/soc/codecs/cs42l56.c
+++ b/sound/soc/codecs/cs42l56.c
@@ -449,7 +449,7 @@ static const struct snd_kcontrol_new cs42l56_snd_controls[] = {
 			0, 0x3f, 0, 0),
 	SOC_SINGLE_TLV("Limiter MAX", CS42L56_LIM_THRESHOLD_CTL,
 			5, 0x07, 1, alc_tlv),
-	SOC_SINGLE_TLV("Limiter Cushion", CS42L56_ALC_THRESHOLD,
+	SOC_SINGLE_TLV("Limiter Cushion", CS42L56_LIM_THRESHOLD_CTL,
 			2, 0x07, 1, alc_tlv),
 
 	SOC_SINGLE("NG Switch", CS42L56_NOISE_GATE_CTL, 6, 1, 1),
-- 
2.53.0



