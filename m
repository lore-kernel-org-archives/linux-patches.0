Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207542;
	b=KiL0rb1m1lZstktu1MehPcrsQEhaGTrGSQrHsESRWieG1LnhuD7JuLFVPtPERZ3ccVOv
	 nqpeu0qEcEK17ZIaJSS2EJxfiaMbc9M69q+3eNsSQd4VSDkrzILfsnPpV82KVfqXGPmLx
	 lMYq3JayTGdvURZwCfLOhFPyuEHt2Y2Xg85mAlOZMkd/tVwB3LH+KaqRylHngL6MgWLXs
	 KyhovMCbRUEInQnQSM0Qxtz5MsNFJSqwvaMqkgbEufp+k9UhoLvYGfAxGoDOXBtSe9QWH
	 nSbMxno+f69VdqCij5aHfUGL0IXdG5W2FkbywU0VWteq/Ev4d17XKC2OwABURlTaNXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207542;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dH79CdqsXHB5ef+S2iHUEcadib0AR1haMoGiWcSlDBY=;
	b=yQE5JnqpN99CZnOR07uCAcfXtSNwcZmHZS5hTRxz/M8LUQ12wBZ8RVoLHb+0Qayhvo8H
	 1kPXmSpim9Gx6ETaN5Ydd3EW1wja+6kwms+eaMIOxfUAQ8+UFzMSl8OeW9mUuLoSPitXK
	 wrT51ec/AmLiSKbMG6LztQ1IPLF3t1l+T3e0GtP6Td8iuMok8ukfUk0lOqCf1GmaOenLe
	 KZULOt0QZ7GYQHJbgZd+F/jz70/bW7qQTNnFMg83kfwUSIfxHSqEXQrsIqqKAvGf/ysme
	 LjXuRr7WCLv583YBdetMk6z+aVt+C+i+1KTu6Dd1mJYCWGBZOJzTrEdxIfZD0InnRaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M8OuLqOc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73864606A31A;
	Wed, 28 Oct 2026 17:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M8OuLqOc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C32781F01825;
	Wed, 28 Oct 2026 17:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207542;
	bh=dH79CdqsXHB5ef+S2iHUEcadib0AR1haMoGiWcSlDBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M8OuLqOcUBgtOdnUoobrpL7wvuWzL7zTjOj7nOOYm1xo1LHMrJA88sqKafpTZT3/Q
	 96VYRAv23Cy0ZpJowjN8J5Z/QHQncRzbFU1kvGbE9mFBYNqQydgx+j9eYRhU+/+wtJ
	 LLOZ4Du/2dx+Z/laYBYieP2MGySjcF8xqNciw9lY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 036/247] ASoC: nau8822: Fix the 128x oversampling switch bits
Date: Wed, 28 Oct 2026 17:57:19 +0100
Message-ID: <20261028165948.222406647@linuxfoundation.org>
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
index fd4a96a12060e..dcf317ec97512 100644
--- a/sound/soc/codecs/nau8822.c
+++ b/sound/soc/codecs/nau8822.c
@@ -380,9 +380,9 @@ static const struct snd_kcontrol_new nau8822_snd_controls[] = {
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



