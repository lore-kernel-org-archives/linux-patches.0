Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055443;
	b=fJ7dxFczrKawjKpyOadtOzNuFsTQBVnVk5XrV9MKRvQAJMDkwPDGNqYO3YQj8ysc21k/
	 LQaGLpt6lKoO3Si1lW9jeU0GKKXLiLBFPtbbArzavkPVf96ZWFUAdMO2Fx6W0QAn+Xtnt
	 XZQOdbY5dRW9rhb8VgYD0RGci4DHm9ttPyVfDi8Il29yT16bPd3w03zYP3CUE6b8FK6Ue
	 gmPRzWIhst1Ot6YzZe/xuOdO+upLEvyaYnF7qAxgguGumxZjim6sSQgHeihLDlTWYDV0R
	 vkGLeXgD6yE6F9Fr+oa44iO4J1de+3vU4LkU9y6e3ckE+bKV6lIaSlWVJytRU8OY1LA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055443;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cUIpqNjQjLPkcD5c3Ewg3SB1t0tZDvKphjkbQpp+SJs=;
	b=S63QdbgSMH/aFUinw0fnkaxIVSrI8F4i2V6PiOKdxlmPx06day6zRhxOZjr7Aj1Gnmy3
	 y2SF3d0Q6ziE3CQG8pMQH3Le3xG42erBL5lE9hmSotTVgB2mnUYNkgoCzMVeWdbYoByKc
	 v5fS3KLq7o0Y4Jdq3HId/QrtzWG8+ViIrVEB+UnU1T0cdFKpTHfGhytqdY1wq+LcJi1Vu
	 uyjmkRmyLQ2d55rZc9TmWVsW/pAMH6R+aCKc/q4Vrl9Of9rRDVaMvGZGJOo15glGwoXqI
	 YrZ8AGF2PKMowKcuSlgi0Yo+a4V2cxxWRC1HIEROCxw0NyExf4xo0wpt4kh5xDRAYyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mEV2qzpf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31966606A32A;
	Thu, 19 Nov 2026 02:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mEV2qzpf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87A2B1F000C5;
	Thu, 19 Nov 2026 02:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055443;
	bh=cUIpqNjQjLPkcD5c3Ewg3SB1t0tZDvKphjkbQpp+SJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mEV2qzpfZAYUplTbgNCqRMXcYyEBx9Lswx3Y8f4OBsbni8c91/R06F2k1+B7HJKZF
	 JQx4q+XyT2vMZO1HP37ujUlWauEKDKuSUBoIEH9+WtBdTCFKIF89puhQPi4eHxg0qF
	 Y2pomOWOzjHdyEiMvd5Kf7BI1xKTKs3RkPyoH/88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1596/2214] ASoC: ak4642: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:54:32 +0100
Message-ID: <20261118150115.816923028@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 7142c34ed92fddca7038787b8695d22c661dc6ec ]

ak4642_resume() restores cached registers during component resume but
discards the regcache_sync() result and returns success. A failed replay
can therefore leave the hardware register state stale without reaching
the component error reporting path.

Return the cache synchronization result. The ASoC component wrapper
reports a negative callback result and retains the established
best-effort resume state, so this adds observability without introducing
rollback or retry semantics.

The successful resume path is unchanged.

The issue was found by a tool we developed.

Fixes: a3a83d9a7cb0 ("ASoC: Add ak4642/ak4643 codec support")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260902013256.93072-3-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/ak4642.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/soc/codecs/ak4642.c b/sound/soc/codecs/ak4642.c
index c49c58eeb4763..df1d68a3cabbe 100644
--- a/sound/soc/codecs/ak4642.c
+++ b/sound/soc/codecs/ak4642.c
@@ -533,8 +533,7 @@ static int ak4642_resume(struct snd_soc_component *component)
 	struct regmap *regmap = dev_get_regmap(component->dev, NULL);
 
 	regcache_cache_only(regmap, false);
-	regcache_sync(regmap);
-	return 0;
+	return regcache_sync(regmap);
 }
 static int ak4642_probe(struct snd_soc_component *component)
 {
-- 
2.53.0



