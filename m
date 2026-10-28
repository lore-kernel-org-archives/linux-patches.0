Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209330;
	b=QyTjddOAuKoXRWnmy52fAmH1Gp1IaTfJzJ/2iV51+shs8A5f88xxVdqPG9vHrcl1UqS6
	 fEgALJP1lvKXOQfY1nZyf/NEt8qVjdLiERRR0R4+HEvoB/43DFma/A9Jjv1WQ4QBQAcSf
	 8TmeVp1obxDhnhGv1LyRDx4kXIMp9h0mqB6n2AmnqaEEbtqX2YrFfMQVAe4SU5NCJ/8NT
	 KZarTY7CVyd9qBXaIHE0+ULrT1NPQTa9zo/E+ayJkfF450uPJ/GJP/KxIqscAHFYqWwYo
	 y/6Gjdo8kRahJD+zXrjEK8g09IqrRxXSCELAJBnJY3H6BmcyWkGUjAY7w8HPxBfC/mA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209330;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gSgMXT0RoxbGx/vWHbOxbYIu4szB6kOHMb9g6rUJYZU=;
	b=DmUairIaCllOL98lZtJtsC0NUxJLmrcfjnN0PKyJ0p115x/cAvP7xeRDCKnXdLIe4EO+
	 rcePMIQ9StUIGNjJWKBDs7AscrBempe6nnJX86oQAm7Jn7cYO1oGbxKDYbbkrBlR4/pK7
	 a3z75rUpjDPkS63bbwBW3yoUMB7qUMmueiasYbLipfCn+KOV10veN0bzt29RF7uwt4zLd
	 npC3vM8i68to2TQUQQuomFysswW0Ps2eGuBOyXQ7qEI7j3Q0VoO/pRTzU3XSvXYWvdwHE
	 NVf1L9aBiaAbo4LTZGm5ZJPIdAjCO+XNyszvK8mFuuDTuskXBddEXnKDnriVdAkWT7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2sj+cLKG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE273606A31C;
	Wed, 28 Oct 2026 17:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2sj+cLKG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D0C21F01825;
	Wed, 28 Oct 2026 17:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209329;
	bh=gSgMXT0RoxbGx/vWHbOxbYIu4szB6kOHMb9g6rUJYZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2sj+cLKGZZ3jgwnJQsZagCje9arp6nHKg/2u2kiWYq0ABWGUfrnnUn0mNoKdypQBW
	 DsMQ92bEpULm2YiGTcAE8q2bCL8djQwBEUlRBkSrepNa/KIqWW467+vxZ4eeMefyYU
	 TnhArEyolhsEuD56+7GVwwRlGLqmimUKkrNxIDpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 434/516] ASoC: wm8978: Fix the 128x oversampling switch bits
Date: Wed, 28 Oct 2026 17:59:46 +0100
Message-ID: <20261028170013.765897427@linuxfoundation.org>
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

[ Upstream commit d0567ca9a2faa33efbe5ae84ef7b86423a93bffd ]

The DAC and ADC 128x Oversampling Switches use bit 5 of R10 and R14.
Table 66 of the WM8978 datasheet puts DACOSR128 and ADCOSR128 at bit 3
of those registers.

In R14, bit 5 is inside HPFCUT[6:4], which the High Pass Cut Off
control owns. So turning on ADC oversampling changes the high pass
cut-off, and the oversampling bit cannot be set. In R10, bit 5 is
reserved, so the DAC switch has no effect.

Use bit 3 for both.

Fixes: 823dba519122 ("ASoC: Fix broken bitfield definitions in WM8978")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/20261008130953.2446692-6-sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8978.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/wm8978.c b/sound/soc/codecs/wm8978.c
index a7acb89817159..5cbbff7df7d35 100644
--- a/sound/soc/codecs/wm8978.c
+++ b/sound/soc/codecs/wm8978.c
@@ -255,9 +255,9 @@ static const struct snd_kcontrol_new wm8978_snd_controls[] = {
 
 	/* DAC / ADC oversampling */
 	SOC_SINGLE("DAC 128x Oversampling Switch", WM8978_DAC_CONTROL,
-		   5, 1, 0),
+		   3, 1, 0),
 	SOC_SINGLE("ADC 128x Oversampling Switch", WM8978_ADC_CONTROL,
-		   5, 1, 0),
+		   3, 1, 0),
 };
 
 /* Mixer #1: Output (OUT1, OUT2) Mixer: mix AUX, Input mixer output and DAC */
-- 
2.53.0



