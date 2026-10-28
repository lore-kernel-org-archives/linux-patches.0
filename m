Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207482;
	b=q3GMbPNnrW2M1kEE4YJAREb4OUnENPuWlz7SfQm5ZKLurZhffQhIrbtBegGADCkihex3
	 U/I6fjuAc4Vkvvvt1zHgHgnbXQl1RHgzFR3DU7DNtzdRJLdepLTs/6+6WV8tBg6fICm/f
	 fY8/xv3L0iJJejb4UUfKCQiNoqk37LeEDe/Nco84xLnFcy20z3wHCZ4h8XpdEz56atXUQ
	 PUaGEPO39pkmEHnx6+uQevFtHwBLUV+lNv4yM3Um6rKp9qktY0oRWe9rooA/PfDdBSdzp
	 +JcKspYiwrVj+c3KL7VZlKctXpfEJxXOSbbj9e1bgxH5Exq/noBV7T4m4apLtqlO9dA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207482;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g7FWjra4VXNJrl2d9MwzhsuU5N6iGVaGKnnnruZy1H8=;
	b=LlC8y27yVXnLKOlHbKJp1AQFtgNdmxKiipqGRsm3zGitGieYDjguFWgj5Y/2T3Xup7yG
	 fFTgo67Jgnjl8tUnmXVzKY5mR3fr7d4eIs7E1MDts3IKFjO7Tpazwe0g1M+B17fevts0A
	 B/dN4luxeOAwB5jFRYUh/e5myV4rdJUIsiSUJzImlvfDD0Pz5EVdselDzq7hQniRrtVfX
	 XQ0epJdxtLkrQb8eqg4UNx3Ak0ohf9S0yBGuUVByTOYEaOeWdtxYrct82ZHnQtIO+Z1nI
	 62YD3C8pTXTu6rmeoZqfekbdoPoQXfY/kkWrdBJJcup6WkANUhaO/yRceFcaJlBp+TA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z7WtlMBD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A5A606A31A;
	Wed, 28 Oct 2026 17:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z7WtlMBD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0DA91F01825;
	Wed, 28 Oct 2026 17:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207482;
	bh=g7FWjra4VXNJrl2d9MwzhsuU5N6iGVaGKnnnruZy1H8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z7WtlMBDFOMm8SF0VbRlItcHzZc3CMfoNk9TaJhoEEiAWHDRVKsGFqb/Gv2Jv+ZT2
	 epRhdAYill//iw1zh1SETh14ejMtgvEg1EsYtgRpUGXmuZN34jMtidBt3kja4Xwo8y
	 N5cO49CrcMOYrSSLfBPl3trX9fgs6VDVxZEeWfDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 031/247] ASoC: cs42l56: Put the Limiter Cushion control on the limiter register
Date: Wed, 28 Oct 2026 17:57:14 +0100
Message-ID: <20261028165948.104225884@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index aaa10c459b52d..0058ce2d55e83 100644
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



