Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048589;
	b=j7oRYC5N5YkSee18gDX9IcA1CxnDOUXrLqx39fyuB4CrtJhM0f7p/bpqvH6Lo9ldchdz
	 LY6Z7ce5m2DQ36cnCFXGd5L2unt2ZgvjMVoj6yrfIc411H5gRuLLIt2pdvvNLW0v/EcXQ
	 +QRp94zlApnJkT2wxy61DyrNY5LVn1m28DV2iwI03qlx1q2DjuamwCcdbHrGkY1oDH3ln
	 nsayqvGYh2cY9wZjXF5tskqPczzsJtZ/RRtmS0ZsHrsPHfGDs/f0TTB9DFK0QC2zfz0m5
	 UnCV333KEpPj0MhnVhWcOI7Ic3yrls5T23PR0/gpxAweTphKrojs7soBhDNRmFqiX6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048589;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9OTVpjqdqbseeH2HDjikoqX3lfNi8zd8pbWCFnnyA/M=;
	b=fHeztB6I5vWQNf+8kn48twsjp/t+vkrLKcQeT0a0MMXIl7KoT9GyamoMtsFnSpGbA2pp
	 zAW0NbFvaNfpj1lN2Bny+zonH9r/k5diqReL5Tq5wn5PBPNGOdbeY85GU23AmF/a4/36o
	 IjIjm7syfFSyKurwoxUeixBUGkhTqzGDih59e4L9kO5UCZdhVJ1azJsmPFlllqolulNEe
	 SNJ9SwOEgHVNOcj/tqsnsoEL8TYbfMfgLRVt1M7QptxcuVT4MiCB2L+WYwNVvZ4+sU26F
	 D8dI9BO/8T+vC+7wo5/T0sFS7i6Za/TBNBWT0yQoq5NrjB+NbQT4Q0y+uepYOxKW9Vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jtreuspy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22FF606A320;
	Thu, 19 Nov 2026 00:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jtreuspy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FB781F000C4;
	Thu, 19 Nov 2026 00:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048588;
	bh=9OTVpjqdqbseeH2HDjikoqX3lfNi8zd8pbWCFnnyA/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JtreuspyDtKU7He5X31Jj+HkKImI236vR1vFgMZVf0o7X41o+NUveUIjOxhg/zSlz
	 geLPm8voC6AJFq/9I0W2mfmzuTH+k5uOw7Ly+GWKMtUdqcyOTfgaOMWSgf9ijQHhSk
	 y9Aqc75g/AVP8B8O0Iig010BCc+PdVJltZqR8Uis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2049/2857] ASoC: rt1305: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:51:23 +0100
Message-ID: <20261118150315.195854057@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 30858325aa90380c6bcdde605214f1ebdbec568c ]

rt1305_resume() restores cached registers during component resume but
discards the regcache_sync() result and returns success. A failed replay
can therefore leave the hardware register state stale without reaching
the component error reporting path.

Return the cache synchronization result. The ASoC component wrapper
reports a negative callback result and retains the established
best-effort resume state, so this adds observability without introducing
rollback or retry semantics.

The successful resume path is unchanged.

The issue was found by a tool we developed.

Fixes: 29bc643ddd7e ("ASoC: rt1305: Add RT1305/RT1306 amplifier driver")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260902013256.93072-9-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt1305.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/codecs/rt1305.c b/sound/soc/codecs/rt1305.c
index 5b39a440b6dc1..e90014501ef28 100644
--- a/sound/soc/codecs/rt1305.c
+++ b/sound/soc/codecs/rt1305.c
@@ -898,9 +898,7 @@ static int rt1305_resume(struct snd_soc_component *component)
 	struct rt1305_priv *rt1305 = snd_soc_component_get_drvdata(component);
 
 	regcache_cache_only(rt1305->regmap, false);
-	regcache_sync(rt1305->regmap);
-
-	return 0;
+	return regcache_sync(rt1305->regmap);
 }
 #else
 #define rt1305_suspend NULL
-- 
2.53.0



