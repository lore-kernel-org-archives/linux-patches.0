Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209934;
	b=gtrv1Q2MZzz1epPB9BKiLRbkekiIPNfPfkvBXjb0eVWocvSq4kY600c+E2n1olNCgTEs
	 JNgVW0e9F9pgWsewR4HCJBgel9HS/jZMYjfkYkRvjMH2jXYQbn+3mYldDQ3HWZDafqQY3
	 ujqvXzdTpJLdt8bOq2Yc65pxFt28Z0Gdgm1Q/RmeSjnh8a9DcN3KDlyvAS0366bPcwY0f
	 iOGtV3tPz9WICa1jsVjp71m4MhLXL4IrijYsKjXRQ9cUFuh/Fo/DCnZO40Xts+hpZYzj7
	 CNz3o4LYoLqsqGMODX1PAUgz77lLzbgqE6vMiQF2+4P1akS3lL8khUrHqYmBsDbwOiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209934;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PTFRHW69uBvutftIr9hhz1A2JY9z73TXeOAPFaCyQfc=;
	b=1DcbcFiSorUqHzHuGxGdiAyqvlVLD3AdBr1f5ChpFmneGxKWbZutaocMDhfmJtYYtQ2T
	 7sTNsaBCYKAFyno2vSjMooer63sP6jIqsrZkSB6ZUpQzNDs+OVj4pcQC9wskvv1rrZves
	 bkHBY7vAm3bYrJytK4MG9wS+Mt+n0s3wo1NVbaMQE5e/JwuNRlJnb7Qzbp/MX7hzEUKD7
	 cVATILAdmwyQ2tm4/W9lkJvnvb9HJMDH1Ukkg5vlOU/XyZISkzUklDW3fqBIfD5nmIasa
	 Lukj+Yqnw5Pa+Ug/MZxUgSgoMJOw2mH/NiNdayodoEcixHYyliLA4QqQAC+IANSq7AA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lCJUzhnS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE464606A31A;
	Wed, 28 Oct 2026 17:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lCJUzhnS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A4E11F01825;
	Wed, 28 Oct 2026 17:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209933;
	bh=PTFRHW69uBvutftIr9hhz1A2JY9z73TXeOAPFaCyQfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lCJUzhnSJB8NQdpW9GY6ptdr4G7cOUU37l9LIEwE/dE2l7hmfRoyOEvj7x4nxnoKO
	 xoH9VhyN46J9QPTJzNhOf1n0GOkB63Kzt0f/615Maf4NbHj+m0XKKp8lJ4IB1YR/Ch
	 +hhOyjJp5QTDiIJuf/L5uwcRPFQu+xP9IXGmrZLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 019/168] ASoC: max98371: Fix the Speaker DHT Min Volume bits
Date: Wed, 28 Oct 2026 17:59:15 +0100
Message-ID: <20261028165943.552450118@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f0e49179c38f6..d0e7efce80968 100644
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



