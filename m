Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209333;
	b=5g2lu+81X2Iw98gkXk6RSMtS2PwiY6DuFKLq8QUUm5ZLMU8USHIGpElm2j90REFivOIl
	 J8cYV9VZmoOw1tatmRpjB5e0x/hWahqj0f1XX/LpS+tlRw3b0QK1yidhytkNftx1E3HA8
	 fcHEySrWt0GCHpNCUNznsmVaPsD8xZicihJgk9Pp+065cQ59kHc0+s1cmswsGa0/IPHIH
	 SvnDmpw1LNYERm2aYtM0u+Mc4KnEBZqSaqIHWJuJZ1Xobx/xcBjAFWqTipo0oYz2AhkF5
	 c1mqfLhO4kAKYpcB2q6tnr/A+7MwEiFGtdbGLqq17KsRrFsahO2jgq2enrwyhWvUofA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209333;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CdCkyZ93ab5oKNgb9XEOgzNA+AWQVF71HyGuR8RXaik=;
	b=jRSn6JpBUDibVrNiIn3toOWNmTEYW1YBbZRvMG3e1zH1XLmgANHDlKx9hUDQdigoOJ9L
	 oh1WCbCssIV88BccIV/k+pzdHwMG6FxUwvLzR3OHZa5XZ9BmuIU8FXgoxIzNQ6LSNTif1
	 JwrRgA0Qj/cuk8AxBVLyIZEDHiYl2cbUPQ6kSETxPBd93CxCnSl7pA92iVPO+ghsP67qf
	 RHusKkYPX/8udofv5wHuBiDCur3lWLUq727mDSxH4BSkayvIhbVm+DXyPedEjdsaWLld0
	 auus3wPmI64bO+u1ENcQOGq7Lnxk+c/v+SUpembWLyh7eI1/g931SxVSDb89m/H0jZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ull2vxo2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9482606A31A;
	Wed, 28 Oct 2026 17:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ull2vxo2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 076A61F01825;
	Wed, 28 Oct 2026 17:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209332;
	bh=CdCkyZ93ab5oKNgb9XEOgzNA+AWQVF71HyGuR8RXaik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ull2vxo2l3RLUwD35fXgZf6yjjH/YlshxxlAJJFXRggw/g3R588ctI2B3TOrxYQKR
	 GRyMxEmTEJ9XdnCPNILXBwXOff8Ag3fdU5XADywGBQOdWjONJy8QZIIWwtOhoyTUxd
	 0QWHcvvYwklb+B8B/DgK2roQablGnF+OutOShrxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 435/516] ASoC: nau8822: Fix the 128x oversampling switch bits
Date: Wed, 28 Oct 2026 17:59:47 +0100
Message-ID: <20261028170013.789614883@linuxfoundation.org>
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

[ Upstream commit 4db45fc1da3d62d0fa6e8f1e457ae92e8741ed07 ]

The DAC and ADC 128x Oversampling Switches use bit 5 of R10 and R14.
The NAU8822 datasheet register map puts DACOS and ADCOS at bit 3 of
those registers.

In R14, bit 5 is inside HPF[6:4], which the High Pass Cut Off control
owns. So turning on ADC oversampling changes the high pass cut-off, and
the oversampling bit cannot be set. In R10, bit 5 is reserved, so the
DAC switch has no effect.

Use bit 3 for both.

Fixes: 1e3cb6c321be ("ASoC: nau8822: new codec driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/20261008130953.2446692-7-sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/nau8822.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/nau8822.c b/sound/soc/codecs/nau8822.c
index 4ce15cd9ed020..f647835c3b8f1 100644
--- a/sound/soc/codecs/nau8822.c
+++ b/sound/soc/codecs/nau8822.c
@@ -379,9 +379,9 @@ static const struct snd_kcontrol_new nau8822_snd_controls[] = {
 		NAU8822_REG_RIGHT_ADC_BOOST_CONTROL, 0, 7, 0, boost_tlv),
 
 	SOC_SINGLE("DAC 128x Oversampling Switch",
-		NAU8822_REG_DAC_CONTROL, 5, 1, 0),
+		NAU8822_REG_DAC_CONTROL, 3, 1, 0),
 	SOC_SINGLE("ADC 128x Oversampling Switch",
-		NAU8822_REG_ADC_CONTROL, 5, 1, 0),
+		NAU8822_REG_ADC_CONTROL, 3, 1, 0),
 };
 
 /* LMAIN and RMAIN Mixer */
-- 
2.53.0



