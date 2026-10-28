Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211721;
	b=Yh679sdE8hDnp8nfJTqbbg1dVr2GGcvPjH9yOGbRkG2/pPbSl4FzY52rIlOU8ZkqzVA4
	 eYpKYGwtH5GLFQSI/KI8Rpp6HQS9Z75jy1aH3C61BXlgoOBDV2hAL1zhWnol2H1eM7IUA
	 bwZ6fow1sOTpqkh5abFyt+6CcKyH8yq8WVAp2YVf6cPg5arQdlK44QHJqYNt8kauePrqP
	 HR/ru4+l/hHR1gWix1mWjQfBNVQKauSwuo/c2G4sfRGDm88GZ5H67Kswblcbhr6xIThxG
	 yqz6YRDaIUK2Q/UUpqQ7iF3G8cKOwm3mJ5LSEeTrFSxSUwSg1IdG9hxKf3VwCKvBGTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211721;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EMinwZHB5VyTK38bK2oKOosB08Q9jh7XZMZRK5+EVI0=;
	b=oCfwSa431MYPv916CoNVUcoosKp4TN1KGI3lV0faciT8x9PCSpdALeIcf4ZKrct4d8pm
	 mEh5bOZbbS6DI7FaIrupn6MHkLtMci4fjU4TN4wHrBcD2UbLb/wOPM0+52cbXzCy972pg
	 dTAguCW/yZ+KdTDqoVtdz3IagqgtJP2ZDS5mp/nYSBSMdBQ7UKOKUuhukRBO1Bn6HlSDI
	 KxxTvCjnf/6HwMefhI6886RzkifYUk+8V8L6y6IkswdL6FzRsTml1/M5HyD3TR8pKIPpO
	 qq+OSLFEzOj9EdJR/YMrX4YAAhVt1dwy86D4EnDmZZyj8XK9+Mp0Wg+KS0sZZ7EYjfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yWHdrx5l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5EE60A3822;
	Wed, 28 Oct 2026 18:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yWHdrx5l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0126F1F01825;
	Wed, 28 Oct 2026 18:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211720;
	bh=EMinwZHB5VyTK38bK2oKOosB08Q9jh7XZMZRK5+EVI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yWHdrx5lO+hXRtkwIDa8WKFy/SsG+nYuLY9184l3PUwu2iVoilDTd2YX2O/g/0cAO
	 AEzqQePzcE7PtsyhKjg/ojIjFvnhuB5Dh1PetCUKEuq0CN8nY1JHbObDZHnj6B+0GJ
	 O8kZnP/N2MnGR+cDp+rXvO/FPIDqauuiEjb/2mrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 478/571] ASoC: wm8978: Fix the 128x oversampling switch bits
Date: Wed, 28 Oct 2026 18:00:25 +0100
Message-ID: <20261028170019.365470263@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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
index 7091e1a9d5168..8ec48019f5b81 100644
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



