Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774434;
	b=B0GNLDWoVukSRaqwbJVVlQVaWEX1phscPftHhnC+NAonU2mJ83F00VFk6KJrMmT5kt7s
	 VbnlcpOU2OWEnMfa2Ol3wyet6l0ldkyaNnong/s5GftUl6kYiA6SY8o/G3V/WaJvQsC1H
	 nIfSrOy6nuCiyO5GtgcrDpvd8btx1n+G5q7UrQPfnp9Ut1pDfZfMatGIFN53NfRpWD5mo
	 QHLPPugB+UKm2Q7RArDdei4547/lTiQ3g/oh1hR1yE2sVsm8+zKg3yvGf6DUn/uVtueJb
	 LzKCS82/wOE4vLwAuEUNc4ICdgtFxka626duFEWl3ACmilih7W/lUQjyu1CwEGNEVIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774434;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mYnlb5moLE0qUSVNFpKkDy4L8dTYUqgEaM0bHLCL2gE=;
	b=K9dus4WKf+SrEKNkOI4Xdb61BGvL/0DTxjh3JD/29wPROoS7AhJ84LgJ0mRtCTCOOMr2
	 9B8NAi1lDOni40bQ38xecVcHxfncAqITZcidll0egsUMRdgE1ndBHj5NSORyHpxpaC1GE
	 8XUAWXMwSYGjIddnnYgtN8GY0p84tI1VC/b8NG3yGdlfzhATV4b7HHNkoj8WH8q80DXQO
	 ivTn3kepVkP6WdUNK1wEbOaw6l6/helbg0IfNnGwK+/cKpLov1EeZ2kRcQeHlHg/a+lhe
	 0XcKwrJqBFw0AAUEcv42ElC6IsOEtRnGbBdJfJ9dBm1wTWrc0r7N/2zAMowpoe+GvaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k15OJPXs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B4D606A31A;
	Fri, 23 Oct 2026 16:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k15OJPXs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C38941F01825;
	Fri, 23 Oct 2026 16:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774434;
	bh=mYnlb5moLE0qUSVNFpKkDy4L8dTYUqgEaM0bHLCL2gE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k15OJPXsbcWzzVfdfjgnSD2ur/lj3rdiy6C79xRUynEYCs9x4RvhEYp/Gm1Yv5b4Z
	 sLSSX2AlNAwKdVGPn4f8MYyHY5HaOAkOz0Edz0ms5XKDEqCmAwckZjVDFHFBqSdVqQ
	 2Oe6JH7UxvRRLzhExNU6hvA/j41LoLmo77I2uF0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 038/242] ASoC: nau8822: Fix the 128x oversampling switch bits
Date: Fri, 23 Oct 2026 18:38:00 +0200
Message-ID: <20261023163714.680735951@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 830164e991a79..b4ae269873c4a 100644
--- a/sound/soc/codecs/nau8822.c
+++ b/sound/soc/codecs/nau8822.c
@@ -383,9 +383,9 @@ static const struct snd_kcontrol_new nau8822_snd_controls[] = {
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



