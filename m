Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209925;
	b=Hr0izkYxtGZ5xhh4AFt2Ha4j6/R8ReZZ2Ks7OAocXB67y62ebCGLBPtckIJdv6wdk9CZ
	 QQANY6u8bZROvAJJkBja91eKgTkBvCTQmkmhbHhiECU8CT9pBY0kmIeT+A4U6dh44P7T8
	 E7Hlq3Iwem/aaJ0VDZNz/nSFna4dIVa+IlSTn+OyFg6/d2eUesb6MUbCtQUQgTD4L4Cje
	 heKRB3Jq/+NZaMEZClYBqyQYZj6Kch5aF/rTAkzJShTLlSsvtI6eQpQ05qjgwBQN9QKXE
	 Twn4gkgFW/b7RGLdoGwcl7CgpkmNQvspN7991cGonqiGa7rEHwH2CEmdKqfu0BSsnYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209925;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p+DXNsJa9wn0Vc1mzBAsmEI8QQLxZodPjSu/r91vBVY=;
	b=5Kfg+CxWewlDdsstyZ9gVGFlRsStJgFQQesXdhNZ2JpRM9l5VMp3XeBJVVJHiLIDPrqi
	 jdcCvjOakw0v06aGNzMAlFgLIllKP5IwiskF64y4RhHvhLRkdyl1YZ8bHJgKSGBsyMH4i
	 /+HsRMg+akz7C1FeuFvZjBJutWshSYwfzr4/ep5KOvz8zgWziPqg2hay6pUeScfchU+cl
	 itVCPY7meGXTdlFPWNCKGI1APtqSjzzJP8vOvnC8ggZVn/oGCoZ9LQ8uEgJW1jfO+nW0r
	 2BnxTIy1ycwy26TnCVDmJW/53rNFR7rl6T/6VbJZQ6VYLSQXy30t43q2ekfxO97d8fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="MKgZlJ/y";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B0E606A31F;
	Wed, 28 Oct 2026 17:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MKgZlJ/y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA36F1F01825;
	Wed, 28 Oct 2026 17:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209925;
	bh=p+DXNsJa9wn0Vc1mzBAsmEI8QQLxZodPjSu/r91vBVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MKgZlJ/yFAkPqGqofiee+EeiGONTM0skAaCaJsl7Z6sW2P1rRq2s/wOP84DH17p12
	 T0zrnDAkPPIq1N3QNcd93NByMk+0APMhl3B+Cw83EwhujjVNz8C5dTrynx23aPkPRX
	 whqx2y5WU1OmNjAVKnhV1UQRiJ5u4qEp1ZJVyI+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 016/168] ASoC: cs42l56: Put the Limiter Cushion control on the limiter register
Date: Wed, 28 Oct 2026 17:59:12 +0100
Message-ID: <20261028165943.481314433@linuxfoundation.org>
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

[ Upstream commit 203436d2aeb7093290459e344e1912a418a6ebfd ]

The Limiter Cushion control writes bits 4:2 of the ALC Thresholds
register. Those bits are ALCMIN, which the ALC MIN control owns. The
datasheet puts CUSH at bits 4:2 of the Limit Thresholds Control
register, next to LMAX, which the Limiter MAX control already uses.

So setting the limiter cushion changes the ALC minimum threshold, and
the cushion itself cannot be set.

Use CS42L56_LIM_THRESHOLD_CTL.

Fixes: 272b5edd3b8f ("ASoC: Add support for CS42L56 CODEC")
Link: https://statics.cirrus.com/pubs/proDatasheet/CS42L56_F2.pdf
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/20261008130953.2446692-2-sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l56.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/cs42l56.c b/sound/soc/codecs/cs42l56.c
index 1714857594fbe..e04e174f449b8 100644
--- a/sound/soc/codecs/cs42l56.c
+++ b/sound/soc/codecs/cs42l56.c
@@ -449,7 +449,7 @@ static const struct snd_kcontrol_new cs42l56_snd_controls[] = {
 			0, 0x3f, 0, 0),
 	SOC_SINGLE_TLV("Limiter MAX", CS42L56_LIM_THRESHOLD_CTL,
 			5, 0x07, 1, alc_tlv),
-	SOC_SINGLE_TLV("Limiter Cushion", CS42L56_ALC_THRESHOLD,
+	SOC_SINGLE_TLV("Limiter Cushion", CS42L56_LIM_THRESHOLD_CTL,
 			2, 0x07, 1, alc_tlv),
 
 	SOC_SINGLE("NG Switch", CS42L56_NOISE_GATE_CTL, 6, 1, 1),
-- 
2.53.0



