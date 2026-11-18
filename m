Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017177;
	b=g153rJ+l2muUVTogF1tupKiGWA9mNJXiXPlmT90CJSiwKyA/6WxeEe/06+eDDGm9sEja
	 6TZBUIl3u7/OUKnl5ZVGGAtsYzBOhpRaqkXbgmySXAAafVkPz+F/1MaH9XN12TckddaDH
	 9HcOVUsv6wbOtQfrqHpBxaxzJRrIDUWj5zsm3SW66L0axSLYsjZK01tMAgKkJaN3Shv9+
	 I95D5sTUmIxGKUNQL0mwET1sUqm5JNgH0RmgRvhVMZ6kk2Tuo9orpTMgZ0NX5klJcFJ1w
	 zdjkmQgK2+7EbgCjZ03JubXyI/Et1B7F90Bf97g2zfZT2p3vhdP5tdNHakG/9Bpmt7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017177;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DPaU3GGHsIMBRwyVBx9bAyHkO52NanKmIUGmGPsTm18=;
	b=tKu+CSvauzqyGh1PFyat9zr0v3OqvFkbIcGqC0/P+VWZgu8GMAoZE0APBvGGpvhQ6ve3
	 Gr4Ih4SaiSPCsMY4g8SfWOGUVwRt2NTl0no+cphntvCGsw1mJuDHsiZpPPb/xKWt6zgx9
	 CZN26IJ8jG4K1H1wxS19txfdS0NGrQq5fo1a+9q7l6nuNP2g9Qfbzl6BPGH0mkXlWE18d
	 iS5cucic24gjGtLm14Ok2tf+FSEUmng7ULLwfT5zgCTFdn0kQuu+UiLATkJCzcuuKQ7Mu
	 u1oDg6bScHxH56tQ3pU/mHj9up8PkgJiQJFX1xr+/QPZtDStjN3YULwQk3LS2lUhWsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1k1FEzkZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3784606A31C;
	Wed, 18 Nov 2026 15:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1k1FEzkZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 402FB1F000C4;
	Wed, 18 Nov 2026 15:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017176;
	bh=DPaU3GGHsIMBRwyVBx9bAyHkO52NanKmIUGmGPsTm18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1k1FEzkZZu7yU43b+W3SunVPSVyc3EwqdONPhhjrgMkgmkaetLlfGv4dRo8SCTseR
	 dR+QDSnP+ixuYPbc1H0+fKAEGFNiTdHuzXfnMmzGDbPdOUC3ny5rfg6ztlNMpBRIRD
	 +o2nPytfXaoR9M55OSnv04gY3TQDLA2ehCVs/D+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0792/2651] ASoC: es8316: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:33:52 +0100
Message-ID: <20261118150316.394466542@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 243d0c47e57a6af89d95aa451ef5fbf453983b1c ]

es8316_resume() restores cached registers during component resume but
discards the regcache_sync() result and returns success. A failed replay
can therefore leave the hardware register state stale without reaching
the component error reporting path.

Return the cache synchronization result. The ASoC component wrapper
reports a negative callback result and retains the established
best-effort resume state, so this adds observability without introducing
rollback or retry semantics.

The successful resume path is unchanged.

The issue was found by a tool we developed.

Fixes: 4bac47a7b2f9 ("ASoC: codecs: add suspend and resume for ES8316")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260902013256.93072-4-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/es8316.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/codecs/es8316.c b/sound/soc/codecs/es8316.c
index 24ec8b211cdba..4c33a243c1e1c 100644
--- a/sound/soc/codecs/es8316.c
+++ b/sound/soc/codecs/es8316.c
@@ -810,9 +810,7 @@ static int es8316_resume(struct snd_soc_component *component)
 	struct es8316_priv *es8316 = snd_soc_component_get_drvdata(component);
 
 	regcache_cache_only(es8316->regmap, false);
-	regcache_sync(es8316->regmap);
-
-	return 0;
+	return regcache_sync(es8316->regmap);
 }
 
 static int es8316_suspend(struct snd_soc_component *component)
-- 
2.53.0



