Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031855;
	b=V01rT3o820/Qk+nNiaeiG+pfTaWM/v/1ShfH0OgLTeATuyJmRSm/FkbLMu4D7NfrXAuk
	 22mdb1GftIr/UtVPqDVOnEkxzzUFCSCCuyIx6PwN0gxgenFqThFVtVjlTIap1F+I9jmLQ
	 g237cFb9Sk70f7lNzXNegzF9tR4jIzyfi/JWmXu2JHm6R0OK91TdrRu5UbLSmTh0G/0uw
	 zdpFlBG8FUj2azORbFIi5B3n4x8gv8vycULxk3Pyf+zM/0L11QNHdiiHsD/pXXxY6pRWJ
	 sk74DDOtqLhq9XsfW+dK8kPI2vb1FdPzGZMDSUEfp+rCCx6BZzZHDwbkqtgC4mtFMrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031855;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9sokXbrcvnImzkmefzexmbOfiWMIZNuoO52MOfs6MxI=;
	b=GhkfD0fXJqKogseSd+a3wPo55vtm9qzhd2vozi0rgRpiQAI6lUgiiUCCm2VcKJzKdTHw
	 aIhn9rowKywtdqyKJ3JjZFmmW16FVvapsW8lRDQC4VbNBXdtOkzAGYJtsADyqKBwpOsPR
	 /ALcdeG1SSvbPBe+yhKSaKux0YRUNJExt0SFHrvrGtwD9HO82XHzkdaNhw9lbe9bkX3gi
	 ub1DAUy8cDYbALzezhiWl0OFVPT/mkljUU2iH+AsmXxhlG2qcJTqPZTA4gBq5hAGsjfCR
	 KIeHUeBjliGIqSeUKJ/qgPoPQ6Fz0RTuz/teRLj/iat8+7R7ZYP8L9dumipTSGXo06g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z7kG7RbY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29097606A31C;
	Wed, 18 Nov 2026 19:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z7kG7RbY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FDCD1F000C4;
	Wed, 18 Nov 2026 19:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031855;
	bh=9sokXbrcvnImzkmefzexmbOfiWMIZNuoO52MOfs6MxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z7kG7RbYLjaswmyWkdhbdEU7s29OdIWStwES5Nj2bhVQVJwaX8eg5IRKrsWtBcCuU
	 kscvZTrQGLxrHDHEtlMusjocI9LoCjNAEbLvLdxtTe8QqmHR9F8vOunpSWvt87U49K
	 HtbboNPnlrns2xNqXp2rvH0WCOseCubGmBqnEolY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1206/1756] ASoC: codecs: wm8750: Fix definition of ALC Capture NG Type control
Date: Wed, 18 Nov 2026 15:55:33 +0100
Message-ID: <20261118150057.831493858@linuxfoundation.org>
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

[ Upstream commit 8c299077c787c151c5c88928467d8e8d85cebdb7 ]

The noise gate type is wm8750_enum[7], bit 1 of WM8750_NGATE, not
wm8750_enum[4], which is the 3D upper cut-off.

Fixes: abadfc928a27 ("[ALSA] ASoC codecs: WM8750 support")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/ce530dfb932d9e8def75059ab9d669360adc76e8.1791959026.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8750.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm8750.c b/sound/soc/codecs/wm8750.c
index cae97fa3bcb04..bf24455dea778 100644
--- a/sound/soc/codecs/wm8750.c
+++ b/sound/soc/codecs/wm8750.c
@@ -171,7 +171,7 @@ SOC_SINGLE("ALC Capture Hold Time", WM8750_ALC2, 0, 15, 0),
 SOC_SINGLE("ALC Capture Decay Time", WM8750_ALC3, 4, 15, 0),
 SOC_SINGLE("ALC Capture Attack Time", WM8750_ALC3, 0, 15, 0),
 SOC_SINGLE("ALC Capture NG Threshold", WM8750_NGATE, 3, 31, 0),
-SOC_ENUM("ALC Capture NG Type", wm8750_enum[4]),
+SOC_ENUM("ALC Capture NG Type", wm8750_enum[7]),
 SOC_SINGLE("ALC Capture NG Switch", WM8750_NGATE, 0, 1, 0),
 
 SOC_SINGLE("Left ADC Capture Volume", WM8750_LADC, 0, 255, 0),
-- 
2.53.0



