Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216885;
	b=HG0sGbMhK5jJGUfSfozgIHRxAvVw5BEjSiAkjcRmYUE1hit4M4rtN4MndWCv7v4EBNhT
	 0nnN+q0dxq8HcOAgLgVXEvT7r8Xw1iivkpg2uhDwlT+rTEK0UaGgvSceTjpRyT03rCzGX
	 ExkGrCAM/HmX7jU0k6qamAJRRIVJiC/fKRLX/4duSC1nic1HVLW1DhVT06nY6VvjGvxH5
	 nFygnOkgixE591CXT4nI5WXWFr7SxseXJiSCzBLEOY7Rt+On0agdxPjD/vRqfevNR4tFU
	 3+GMh3Ya7NKAc1+HBHlYs/2khCdsnzYPeKR7Mc+41rpq4aG2/RByDbeDIbRZHB5YsAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216885;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IB3nJaRi/EODmIQCjJuIfNPcBaQnQhO05CZ1kRSFXoo=;
	b=EnP0kr0aiyDOiak+V2E/lwei9rsCtQIOYP51ECgUKsrrQgICaoUEZzfpqF17tNKg0KpF
	 sqZQqhvUhSOgqgoX7pmhqlwh/I4lTYrq5+Aywixa9t5gKKaZdYnVXWwfyG9FgmA3dk/Bx
	 4mhB2knfRjMG4kRxKdQgEtyixeIpytvXtDP96V+8sMGoTgB7NtwgfTzGsQbpvlaHOH6UF
	 l+oge4E5vwnyb2x42qIyRT2xSg7voqsnI1kVJzza7BcqyExCkqoRTnXoRj9jgeBb57shA
	 y+BhP7AfVrPysWpI53R1WtfujwsQWbIYDfuPYYiVhQs99zLKpDNlCfdX/rXmpsXWtPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="A/ftt2Jf";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65CEA606A31A;
	Wed, 28 Oct 2026 19:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A/ftt2Jf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0C441F01825;
	Wed, 28 Oct 2026 19:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216885;
	bh=IB3nJaRi/EODmIQCjJuIfNPcBaQnQhO05CZ1kRSFXoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A/ftt2JfHO3Z6QVd1Dfnl1GHzFbpYt2OU0eEft/06hAnKZrP5zY3S43pvt2+MaoR+
	 i9uUxvF3bBdvCBUrSyNDZt0cisq/DNR2fERzh3iGFJn05ZAff6Lg+TQ5Z2Ze2SCLoi
	 gIiBXpNbfBN4ngmZd6YQkUSbkxxAzNA+veaTQkF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1713/1887] ASoC: max98371: Fix the Speaker DHT Min Volume bits
Date: Wed, 28 Oct 2026 18:03:29 +0100
Message-ID: <20261028170538.438293974@linuxfoundation.org>
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
index bac9d1bcf60ae..ce6bfcbf34372 100644
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



