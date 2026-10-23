Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773852;
	b=ELvA4RxMbcMUZAEdhhg9laa3ihBt78BGE3GS9K25aGTrPQ5eHhAxQAbERjK39Kfjv98N
	 GG29QJ7pVIroPHQlbrgyXzruKTsg70XQw7vhgg1d1jQX7NwAlJZXObkECkK31DCGBYNhY
	 zd8pOK1u5kHvwrEoYfdDueXPdZSbzQZGoNVeST7y8hRckv9g5UUM8A7Yxwcp9d9kxpp3f
	 KPLofUqlRsTcMsrIpqUV9uWnn3yge7wSgyENzizVnp4K7Oj0sdMpbfkYRCLefchRohsaB
	 DIDseHv/4qLIN6n7YH9Hn8gt/55sGdeSGT7VDKO+WCFI9Nr4EVMjCuLFRwJgtYUKt1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773852;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5eJRSQ4Orp/gNhFs97HpxuJbh02iLbBM7NbIwul5fKM=;
	b=k30PgfYYySBNoJ5hcVBaH5MfgplOzn6asqx3w3Ak7UnEuHCKpIWgjdq4SxLC3V9d7oEl
	 H4nbTyMlHArE2mN8soMCBEELWEbSjpY/M0BNW2oIsIcfgvRm1zfXOos/dNwX6Sviodwi5
	 6n/tPRDoso+nXvtD6i6nqY0WKDPfnbDPvoDiv3Bk+wzTYcwVstG+2eqlI1J56xNfw9XFU
	 mV46xhw36xPyJjtRynH6KuZ6ja3kv77cRxaJKQtRU9xBkcWvj+Zcb3CqT20B/Sr2JQN2A
	 Jy0KvUwCzVzMuLH2Y8beHOU5crnl8kA2QpvMUIYk0y5rmD0nd+snI+HqgATddWlAQbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=whqOiJ52;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C1D0606A31E;
	Fri, 23 Oct 2026 16:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=whqOiJ52
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E85E1F01828;
	Fri, 23 Oct 2026 16:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773852;
	bh=5eJRSQ4Orp/gNhFs97HpxuJbh02iLbBM7NbIwul5fKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=whqOiJ52q91A9gI9BcK0nxxPCJxPoAQbkB9Qw59AVekiOAKC5/JGQnwVMR3ZJ65vK
	 Ia2wgNiau383k9DrXDSyTZYCoCeMqb2hj3dK8joj90DIMq3nVP1S9hEktSztEJA+3K
	 RqeBr8oPf6VMM9gwkiOz+E/HYTO18vptIPQxobow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 037/193] ASoC: nau8822: Fix the 128x oversampling switch bits
Date: Fri, 23 Oct 2026 18:35:14 +0200
Message-ID: <20261023163715.080737781@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 15d6f8d01f782..1386ba6041998 100644
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



