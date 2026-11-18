Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049799;
	b=ABSS4YhPfwIJm5ATBqpgDkMWuDP+Q+PXR3eCVrPKfw9YkQ1CJwqSyzj/d/GgwzQU8zCn
	 n0hZNJI9aQ0k2RUGOIYrS33hcDawXt54ITurLrcnoaqlFZs2wgyVD4pKFZMBCNckC2+EF
	 HtjiOGLEQUsEurROPAhcojdXHmmZ+vxqtLwR/5OLMFl9C2GkIGfPXx+IITe0+YVn/Xp3U
	 9FZFswHkuycSVPPibZqVWwoG2uGiXMvy7piYAcEOzkulXv7oFO+7ZlJEYAddB9dW01Okq
	 cF6Umjm7LLI6yCxzIahjvgJl69X3Up8QNFurFZS+NJwara+ncbQ03ZR869jsW7DmesA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049799;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1zXSVNA//I1dx3nem2VM8mkNf+jRqNTz72FOtP6LBfU=;
	b=BzEOiGYRJ3VIQVTUnCLsdptSRFTuOyYlKJUS9KnNimGhC3fkAOgRDx5+Kmmjq7O9OQXE
	 WaMg6NuXV2gBLkcbfqTTOr1wudKpbuIuLEJY49QKELVeDbOMZnlNMp3EFeNKwcQ6ASRQ8
	 uFpCzO2IOztOdDy4T5IPWUa5vw8ur+FQ36qbXy4XZtuv98EJMK4orraj8fb98efcXi6XD
	 8F8uuNUQbzcWpH8hBjekzyYhyI4aazDtCaqqBgtytTjSAqwZNT+eT8bT0g4YiLhHLjFxQ
	 dOaB6xyQMwSxaeZKTCUs6ESzjvurVGw3nqLY6vv3pgyiBybUbNDD57ksTW1JQjZ4wdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="N0/GQjCF";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12560606A320;
	Thu, 19 Nov 2026 00:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N0/GQjCF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 313D81F000C4;
	Thu, 19 Nov 2026 00:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049798;
	bh=1zXSVNA//I1dx3nem2VM8mkNf+jRqNTz72FOtP6LBfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N0/GQjCFKbC04WSJvqcwdIBqoM39VA4YRK0VsAMZdjeN1eMMASKFhcMjV4mI0BNVf
	 cTFQGiTvXS7kfaUjaQ7MPPFdVT3BbvrGjnHXduX5SNxg9PruILJtynrbZ5RyheHlG2
	 Q6xxWrJgfxNAsT5/k+Zp35jZjDUsZRgi9uuvpt88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2479/2857] ASoC: codecs: wm8510: Fix definition of ADC Inversion Switch control
Date: Wed, 18 Nov 2026 15:58:33 +0100
Message-ID: <20261118150330.819915763@linuxfoundation.org>
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

[ Upstream commit 22d50113078dfbeff0d005d64fd9cc680249831c ]

ADC polarity is bit 0 of WM8510_ADC, not bit 0 of WM8510_COMP, which
is the loopback enable. wm8974, which has the same register layout,
already uses WM8974_ADC for this control.

Fixes: 5d421516670e ("[ALSA] ASoC: Add WM8510 driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/6ada61df8c8fc97ffb1623e74f6742ca498032fa.1791959026.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8510.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm8510.c b/sound/soc/codecs/wm8510.c
index e13f9780a111b..1667d403859f0 100644
--- a/sound/soc/codecs/wm8510.c
+++ b/sound/soc/codecs/wm8510.c
@@ -135,7 +135,7 @@ SOC_SINGLE("Master Playback Volume", WM8510_DACVOL, 0, 127, 0),
 
 SOC_SINGLE("High Pass Filter Switch", WM8510_ADC, 8, 1, 0),
 SOC_SINGLE("High Pass Cut Off", WM8510_ADC, 4, 7, 0),
-SOC_SINGLE("ADC Inversion Switch", WM8510_COMP, 0, 1, 0),
+SOC_SINGLE("ADC Inversion Switch", WM8510_ADC, 0, 1, 0),
 
 SOC_SINGLE("Capture Volume", WM8510_ADCVOL,  0, 127, 0),
 
-- 
2.53.0



