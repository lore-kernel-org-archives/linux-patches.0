Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216891;
	b=v/4hUcl7sfn1uf0b7jOS1wbgJB+5RL9ikroLdKep561B6HWfMguAX7nRfDKZTkXDqp4l
	 Y1y+/Gbo7BxyOJ5bPkLpH94zzycaX6ZpexaOV6RT3MTXx/8+rs3zho28pwgAcq2S/fRz/
	 7HcrjW9xGq6vbheK176gtg5Kc+SMTufGV5nPRc3BN9plou/i51yj05nYXER9CF8C8I0ih
	 mu0sWby7Aj05UOUGcLQbxRNxPsovfVPdME75rGOpuCdxLv6JUXmlY2P+yNwYT0i3kzqWB
	 5WvW+K7hRy8WQuO2H4fJimPq3GAFAWqkxOUkE7wukLTBND9xoAOsKa+dFK566M6g8Qw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216891;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cD5NloULiGsQ1M8uwnzUsFBszrBNP7i+w3r9gpmeFgY=;
	b=qfNE0RLht+CbrA1tRrz/jdstD/lSHE5EGzdYhbvCpqQV2CAVZl9s+xU6QW0whi0I3a7l
	 vnx0V0w9VAOZCv4hS39L67a+lC3G0tnRvgf9elsmm982eMNpqM6d3+FlRJ1kHRrwaCxyW
	 Z/Vtzpq9QmlQN8svUNDPWDacKVeaQmxFSnMtVF3rTta3wW1EAxmVQ98on+rO2WmQK+n4S
	 4hhpkY9hvonVvUM0mBxOthgeXXwr6UavH2tB0rmwa8eqGgOu3CpNLjueMSNr1gkNwLTo2
	 Ro34vTzif5S7ZJ98Z4FXf9/pG44ZPj5yI94y2dhX380Gnl3CdvCGl0y0bMgrW9DfYsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LC2iwTBT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EBA1606A31C;
	Wed, 28 Oct 2026 19:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LC2iwTBT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6034F1F01825;
	Wed, 28 Oct 2026 19:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216890;
	bh=cD5NloULiGsQ1M8uwnzUsFBszrBNP7i+w3r9gpmeFgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LC2iwTBTVJ8lk/mPlCJF7Mnmg2GWueKVdEAg5CnRw2axvrpCMzl5Y8dk+TT0rtnx3
	 XCEi5HziTwh1jjo1RgVZZUkV7ErnQVmgmJePDxMlhEyAhC9I1StJ5H9mTVd9yK7jwD
	 mXcSNzlPtDWv7bjmab905oRsd12H5eoCwumd4ACY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1715/1887] ASoC: nau8822: Fix the 128x oversampling switch bits
Date: Wed, 28 Oct 2026 18:03:31 +0100
Message-ID: <20261028170538.484688758@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
index cd5053cfd5213..3670da4885840 100644
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



