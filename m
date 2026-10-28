Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216880;
	b=PhjVbUyIFejRTja1kKlMqEei1CMIoaqM4xMDYAxjPGFxJKJgf01wrJl/jyJKSZNt8RfZ
	 F+7rV964TnC5y2PFjk3gg5LOdT1K15OPDo5OvYJpUPv8n1+Tm4ti2O8pGQRrhw8ZB/ayf
	 gCDNq0KL0fn7cr6d+21LiEHZjwVL2rDhbkOZoD9dL7FM6L3IkdQ3t+3W1EuzO9H9GXYMI
	 UVFE02SB+zComdBuQuoZQ5cmQGbsQo5ipoWX06hr0UHp9OrgEfeavbgrPA0jsnDGN9OMV
	 skLAKqYmOoJvpvSZd7tHJFv5odjOWhAqpEbzft0/6o+25uUgg+v7dIW+m0fK7t5lfQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216880;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=efDo30+jUys5DxXd64LRUz214YWY9uxXH1qKxDVVPkg=;
	b=U0Jo/k+0xMcd3ieHGLl27zYk18qmSpQUrFWw/0nhArhTPqErXyrAZ4AMWa+YQPDEPfsf
	 ZCwVQw5M7QkwieLkZZS7/P88d03HiU44He9xEjZ8iYT3fXW8/6wrjmepbn4WtzqvvCxTV
	 hqGPNAU/94Os0HtpSYh1O+W7vS1xI2l1lJWDadT596D1FlwiJ2yu4Umn8+GDpJCVr9SlR
	 rx7Bj1EMlq6wQXQH8+ouclq461Btst42hKvPwr/SWPFDpH6vCKEen+l7BPbA61nNHa4a1
	 shDaAqqFfo4/BNejzy7cxi/l0SFCfBZ6dcJP3l0BjoeEk79EQHtOeZzCg2Uaf/4iN5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nMJ4PW6E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D00606A31A;
	Wed, 28 Oct 2026 19:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nMJ4PW6E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 130431F01825;
	Wed, 28 Oct 2026 19:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216879;
	bh=efDo30+jUys5DxXd64LRUz214YWY9uxXH1qKxDVVPkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nMJ4PW6Ewai/mBzjt/qS8g70oKlVKlAdO7CtPgZCOumiAkWEklxllAAPc7rTBvGQA
	 SVMJ34giDulcnt5Et2Y8jnPN//wqlUChCoR7SgzG4QbVkK2z/K/dQeQVzNP8vPx2NU
	 zHWjKjXgtzrIUcgZmlY49fG4+bl94Qhn11IUAvGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1711/1887] ASoC: cs42l52: Fix the NG Type Switch bit
Date: Wed, 28 Oct 2026 18:03:27 +0100
Message-ID: <20261028170538.393418319@linuxfoundation.org>
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

[ Upstream commit 8b08b98796d2da103f2432550c14a7c687e72080 ]

The NG Type Switch enum selects between "Apply Specific" and "Apply
All", which is the NGALL bit. The datasheet puts NGALL at bit 7 of the
Noise Gate Control register. The enum uses bit 6, which is NG, the
noise gate enable owned by the NG Enable Switch. cs42l52.h names it
CS42L52_NG_ENABLE_SHIFT. cs42l56 has the same Noise Gate register and
puts its NG All Switch at bit 7.

So changing the noise gate type turns the noise gate on or off, and
NGALL cannot be set.

Use bit 7.

Fixes: dfe0f98b8d2e ("ASoC: Add support for CS42L52 Codec")
Link: https://statics.cirrus.com/pubs/proDatasheet/CS42L52_F2.pdf
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/20261008130953.2446692-3-sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l52.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/cs42l52.c b/sound/soc/codecs/cs42l52.c
index 90bf535fc5a52..cf3ca3978336f 100644
--- a/sound/soc/codecs/cs42l52.c
+++ b/sound/soc/codecs/cs42l52.c
@@ -273,7 +273,7 @@ static const char * const cs42l52_ng_type_text[] = {
 };
 
 static SOC_ENUM_SINGLE_DECL(ng_type_enum,
-			    CS42L52_NOISE_GATE_CTL, 6,
+			    CS42L52_NOISE_GATE_CTL, 7,
 			    cs42l52_ng_type_text);
 
 static const char * const left_swap_text[] = {
-- 
2.53.0



