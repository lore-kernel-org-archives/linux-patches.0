Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031947;
	b=Myf7azI5wDjrWr2Q8FFjuq8qdE4AtoD8XVvYcByEVxRQKcLGOH8wed05C2QzFSI+obh+
	 2sW++gaajkqpgWV0n9wnU//oYaX41uMrJ9Hi+d5e3SSC8dmY09zffUJ3OeoiUPVoW4Xq8
	 9866p/RSqoIeTgZVhiGtdwKuWPXZR9YLNRfFoC+t7EBGqcGjSgIUxMqsoXGGmYN6Sb1Np
	 koe7kFPiC8s24phOTKZhBmKrpYCybTLLcK8PBRt/I/63DqRpem/RmRX6hgs+Yn3akRzYB
	 2B0AqIwnnRHhs//CE1fh+huUWYqOoNwhlnw57FAa18j8iMOjdBGfcYepRNnCDiCKUxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031947;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yJkaqFRQ4nJkZo7Vn0n7vYBZG/1zN8Orc2pP1yHezeo=;
	b=gaJKLkYztK96DprsYKhqGLJBUQBImpBa8WsAfsE0ogYiJ2B6mliyna34m0MQqnn5go5L
	 /nM0PEXlZigwNhjteBu+8JgJvYe5fGRcr97J7IrNH+EkcepMHX7xY/GsZYjLWd7piKLTQ
	 rxZt9IRU6h7xYh1cOKCbOu5cHSEvksOobZ3Id51LpqGkWeXlof39Ku6SLbhYRYDYeEoXj
	 I+tsxlBXHooosCAweeTjfmn0WALroKUCDLlVQlEDzLOdvE849e7hM7j/uxhmfv+Is6f7y
	 VNpQ05MSkuf5tGhsTap9dMjRAOYTTiAB7/Qekpdlc18IXg89Fmiyz/5+gGYhUGNcPuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bZSftD2t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A279606A31C;
	Wed, 18 Nov 2026 19:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bZSftD2t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4A611F000C4;
	Wed, 18 Nov 2026 19:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031947;
	bh=yJkaqFRQ4nJkZo7Vn0n7vYBZG/1zN8Orc2pP1yHezeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bZSftD2ttZtI2FPMrcA+E9e12Z9nAe70v4tQB4Z4rNwrsMU3tNokR3Ny4PSMkXLH7
	 dynBp9j/kRWC4Tu/4cNGrxwR+NUmujIsu+6VoSrYm8IohfX70VWEPB9wISmQNROkIA
	 7oBkThvewlp6f6sVUNrh7CtFqiQOdlokoTdYQ/uk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1196/1756] ASoC: codecs: wm8990: Fix definition of LOMIX AINLMUX Bypass Volume control
Date: Wed, 18 Nov 2026 15:55:23 +0100
Message-ID: <20261118150057.471636220@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

[ Upstream commit 75e0b607e3456c9eb15dfb783984f814a89cbcaf ]

The LOMIX AINLMUX bypass volume (LLBLOVOL) is at bits 2:0 of Output
Mixer5, not at bits 5:3, which hold the AINRMUX bypass volume
(LRBLOVOL).

Fixes: f10485e79882 ("[ALSA] ASoC: Add WM8990 driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/87b3bfa7711b61d89c21044d02fb3242dd934385.1791959026.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8990.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm8990.c b/sound/soc/codecs/wm8990.c
index d44d671bd1ded..5c2f35676328d 100644
--- a/sound/soc/codecs/wm8990.c
+++ b/sound/soc/codecs/wm8990.c
@@ -112,7 +112,7 @@ SOC_SINGLE_TLV("LOMIX RIN3 Bypass Volume", WM8990_OUTPUT_MIXER5,
 SOC_SINGLE_TLV("LOMIX AINRMUX Bypass Volume", WM8990_OUTPUT_MIXER5,
 	WM8990_LRBLOVOL_SHIFT, WM8990_LRBLOVOL_MASK, 1, out_mix_tlv),
 SOC_SINGLE_TLV("LOMIX AINLMUX Bypass Volume", WM8990_OUTPUT_MIXER5,
-	WM8990_LRBLOVOL_SHIFT, WM8990_LRBLOVOL_MASK, 1, out_mix_tlv),
+	WM8990_LLBLOVOL_SHIFT, WM8990_LLBLOVOL_MASK, 1, out_mix_tlv),
 
 /* ROMIX */
 SOC_SINGLE_TLV("ROMIX RIN3 Bypass Volume", WM8990_OUTPUT_MIXER4,
-- 
2.53.0



