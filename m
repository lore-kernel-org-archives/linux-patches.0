Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020160;
	b=N9RRsnFxYgrNdpsFBv8H7Ydhz9I1w9ZErBKXW5o91mxjUX1RW6WEH0+JvjUjBKdIIUUo
	 d1QQ986rxQUwnJLFDfJXSkTsTRl5ny4Q9djnIAZsGnYe9qiz7jOdXlVfJTKuNW6HOIyhz
	 lc1mVrg0ng9mIrM0KBFabBZbNP6lXOoEqzoCSwpDTge0QNNXwOMr6kowX/WSmR+/jtQH5
	 CtIZiVtY4gW3igtTM25JbKroezyVbIHXr0NsaAia4ngk1a7+N3j9Sa7zmSTEJLWy1AOLE
	 tj2ezYH93KJtBoy3JRoifxxQw4DHyDtr06ubtaua9hJ0v/CwnJU4AWFuYZUM7Xf7Y9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020160;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w+GEcJbOe4GqSoqsL0/EvTR5Ol+N0B7iH+szMhHvVqI=;
	b=BsltrmPqzyjGKE9vl6P/N5s1RxVHvtRhcAQ2k5aQIxBPhWi/oQMuXgQd2GDMq1eX9eJL
	 F2GNIylDRMW6ivlO6gPK7lDOUKceWTpveWOSkx8XoAmAXsOHhvaSYUIJhryNqNH+N+hQK
	 2NwSDfj1wqmYdD9BqSRLXZaNm8m/WW8NMw+lx1XcL/K7mFS8B2TEoqAd+rfbIxgaZwd0f
	 Ds+bDKtOHno86oexQ+8T0iYgOr3dED1+X1FK/fSWeIihuQm0UeL9nTcpbiXvROCQz1CK2
	 SNBfoBK4itn8kG1piAH0UyZWPuIWe/YZjv9rMABx5EHChj0wFfrom8lKsU5YQp4Anig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=StSqiAWX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A030F606A31C;
	Wed, 18 Nov 2026 16:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=StSqiAWX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F28881F000C4;
	Wed, 18 Nov 2026 16:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020160;
	bh=w+GEcJbOe4GqSoqsL0/EvTR5Ol+N0B7iH+szMhHvVqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=StSqiAWXhQu2eo3xwUCT6pasFvUzxd7k/A2ne2DvlfHIczcECXOln78etpC453Ym+
	 aXCyV2aHoc1UoRailCXG9W/cGhXahOzbMf4pMUalXcoY+O16D0c25XQ24zw8vsydG8
	 SEhbcRnINDy+ffMvkIjjWJifseSD67WGezZjGyK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1853/2651] ASoC: codecs: wm8985: Fix definition of ADC 128x Oversampling control
Date: Wed, 18 Nov 2026 15:51:33 +0100
Message-ID: <20261118150353.742528500@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit a747ec6e12cf7a71e42567a479af18b930890d9d ]

ADC 128x oversampling (ADCOSR128) is at bit 3 of ADC Control, not at
bit 8, which is the high pass filter enable (HPFEN).

Fixes: 6d6f8b832705 ("ASoC: WM8985: Initial driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/00ae032401aaad740b61d664c861b72d2e5ed520.1791959026.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8985.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm8985.c b/sound/soc/codecs/wm8985.c
index 2a64d5a851da8..f400f528321db 100644
--- a/sound/soc/codecs/wm8985.c
+++ b/sound/soc/codecs/wm8985.c
@@ -327,7 +327,7 @@ static const struct snd_kcontrol_new wm8985_common_snd_controls[] = {
 		8, 1, 0, pga_boost_tlv),
 
 	SOC_DOUBLE("ADC Inversion Switch", WM8985_ADC_CONTROL, 0, 1, 1, 0),
-	SOC_SINGLE("ADC 128x Oversampling Switch", WM8985_ADC_CONTROL, 8, 1, 0),
+	SOC_SINGLE("ADC 128x Oversampling Switch", WM8985_ADC_CONTROL, 3, 1, 0),
 
 	SOC_DOUBLE_R_TLV("Playback Volume", WM8985_LEFT_DAC_DIGITAL_VOL,
 		WM8985_RIGHT_DAC_DIGITAL_VOL, 0, 255, 0, dac_tlv),
-- 
2.53.0



