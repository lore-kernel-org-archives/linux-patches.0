Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774428;
	b=ldJftN3Akzvz06ELBhXuIbuoGGIpoK4HT9ANXNxlEWZcDXFvD6R4OfAKP2kpXVDMEazw
	 2SI24YeUAbtY5H7dAwn0tBo3G/xd1VktwyDW9V+gr7CLloOYa7r0U+7OXHIS5pKTUhRl8
	 WRs06+uDXWwi7n6bDONsjAZizfqjFh8YfQsVQ2J8v79mTerXOHBlgXMx6rr0F34hsacUf
	 ZQ85do1ri3N5ZUiG3wOevPU1PTBmJD2T6S53KiJuenW4JBzi4IbOij+ixiDQpnHKdDnak
	 Xh9RHQ2MmLvLAywRVmV2q0Fz40gIoCS/52TpprFzodALyErGVmMJNI8NW00M2l4PNjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774428;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rl24X0vo622MkesUcU/PWFPtDAFUwUyBhnlbsePVSSM=;
	b=AcRJ5jC3LgbUjfDROROjfgl8Bo3+TpDW5u5ecGd+6RAXVj4iPBdmuvudcxU9PzzsDtR2
	 QTqNxCbi2xcVeCTFdogLaKa4G57x/kgusO+N9bv+8Ha4erCQOMPHH/HHW1y74Y4IkGjxE
	 O2wNLtUyv1UNqGevPkASY/KZscWnAKhxbRpztEWyq8eiLYiz7M4zzhD2JO3rcejxJ0nbN
	 lyWtPXXlQ6kE9VmTB/l/qxmqVeRn98DjNscGqEK9ao7tadkCT3xli+IWmEE072vXSBmeR
	 3rFRtDtQD+WPESo/Ahi5ihBtl1GYoaiHM50EgG3EXnpyIVcsEHN2E/nuAwR7BWoJooA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=weu18f6s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7493C606A31A;
	Fri, 23 Oct 2026 16:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=weu18f6s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C379D1F01825;
	Fri, 23 Oct 2026 16:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774428;
	bh=rl24X0vo622MkesUcU/PWFPtDAFUwUyBhnlbsePVSSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=weu18f6ssEBYnUz/I0b1oIkYNT9N+C8DZSp9TJCcA441qZtDYeP4hE9+XB6XihDsZ
	 BGDR6K0fA85abCY5kqsxg6FdersfC5iYdHIfojc9Jou3mPizlAUUbJe+rd5ojy0vI0
	 5DCg/Wg5SLYpNjzcokizag5mMkiHFkArLe79BFCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 036/242] ASoC: max98371: Fix the Speaker DHT Min Volume bits
Date: Fri, 23 Oct 2026 18:37:58 +0200
Message-ID: <20261023163714.633766309@linuxfoundation.org>
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

[ Upstream commit f7934340c56a84fc1b246ebf6b2e806d775f3b54 ]

Register 0x31 holds two 4-bit fields. The datasheet puts SPK_GAIN_MIN
at bits 7:4 and DHT_VROT_PNT at bits 3:0. The Speaker DHT Min Volume
and Speaker DHT Rotation Volume controls both use bits 3:0.

So setting the minimum speaker gain changes the DHT rotation point, and
SPK_GAIN_MIN cannot be set.

Move Speaker DHT Min Volume to bits 7:4.

Fixes: ca2cd6bc6663 ("ASoC: Add max98371 codec driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/20261008130953.2446692-5-sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/max98371.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/max98371.c b/sound/soc/codecs/max98371.c
index c8d4c68af5623..324270cc5cb26 100644
--- a/sound/soc/codecs/max98371.c
+++ b/sound/soc/codecs/max98371.c
@@ -166,7 +166,7 @@ static const struct snd_kcontrol_new max98371_snd_controls[] = {
 			0, (1<<MAX98371_DHT_MAX_WIDTH)-1, 0,
 			max98371_dht_max_gain),
 	SOC_SINGLE_TLV("Speaker DHT Min Volume", MAX98371_DHT_GAIN,
-			0, (1<<MAX98371_DHT_GAIN_WIDTH)-1, 0,
+			4, (1<<MAX98371_DHT_GAIN_WIDTH)-1, 0,
 			max98371_dht_min_gain),
 	SOC_SINGLE_TLV("Speaker DHT Rotation Volume", MAX98371_DHT_GAIN,
 			0, (1<<MAX98371_DHT_ROT_WIDTH)-1, 0,
-- 
2.53.0



