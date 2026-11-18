Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023261;
	b=4jdOjBZ29UzJMbkNRSdoQj+B89kM3V7fXvNHyk20JXlEXt0vfRvEo8TRIVumRD1MIn/k
	 3ZMevDGjklGKK5SxaA8NqLhYTGh3gcyFEYNXFiiJ5Hv+I0COLnlkkFqqUfzOG71QvN8tT
	 NR6Asb99i6qTjyUcziko1w4RLPi2eMwJ3dwVBqhlExobXhyI9CRu86Xy5Xne535tsYggn
	 qvuxJ2TkcFEjTi0RmQ93LcNZsfx25wqBEBypERPOTy8tcziFGsTJotjO1eLS1rdJsf4Df
	 rMpZ/bUHK2PG0jJwRBqeuhqXnkyiaKHfEqRCW4hjhe/18STgOv71hdCVNL7gv5DD3cQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023261;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u970YrW/OqX6OqMR7A8FaWPweq+myhcGxOOLmBTBu04=;
	b=GQYeBobOgJ4912NnmPZQ5fqk+ecjaUKlNJqMMZKh6jktlGTmRcxLwe7fF/+30nzka6su
	 hcIQ1zdCogaioW0xo4xurp5pIQ4oB1t4ztPkNVc2FYLYlnOJxv4nzDS6AWI2RQQxRk9u5
	 8fRvifyrmcDbrMpX3/WH1fNxxyrlf0iL1ZsGm543o+rI2jsyOhAPa1or3EXeey7Cvs85m
	 bwTssgUmGVjPxU7kIUZz2BAZc83pDSiD0urtvUj76XUGu13kAsvTV41b7c4FjgeANwWug
	 OuO8VY8Wg7NtDzvrqLzL5aiF5W+6MWK2jm+FDQSXXj1400s1q9JA/WZ4GuNWhLepLKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QGpedsCG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 845FB606A31C;
	Wed, 18 Nov 2026 17:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QGpedsCG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D63481F000C4;
	Wed, 18 Nov 2026 17:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023261;
	bh=u970YrW/OqX6OqMR7A8FaWPweq+myhcGxOOLmBTBu04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QGpedsCGCIj3dqOZh2Xb2CcW8DPWtD5DCmjPg23BWfDNsHGyTs10pcFqkFGhFdlqf
	 sJyQgkBk4PtkRI31Hd9jRUzlXkIerdeFl4rVkCgHUcSyLwW5V+Az+nSriamgR3mOch
	 fOczrkC6DgXTihyq74hzbY+/Fcip4LYl6sXB5UOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0307/2151] ASoC: nau8822: keep regcache offline while supplies are off
Date: Wed, 18 Nov 2026 15:34:02 +0100
Message-ID: <20261118150133.098675571@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 9c343445b349422bddebb4cb9668c246bc6f08de ]

nau8822_suspend() disables all codec supplies and marks the register
cache dirty, but leaves regmap in live I/O mode. Resume then attempts
the cache replay without first leaving a corresponding cache-only state.

Enter cache-only mode after the regulators have been disabled
successfully, leave it after the supplies are restored, and stop the
local resume sequence if cache replay fails. Do not power the codec back
down on a resume error, because deferred component resume remains best
effort and continues after the callback.

regulator_bulk_disable() restores regulators already disabled by the
same bulk operation if a later disable fails. Only publish cache-only
state after the whole power-off operation succeeds, so the regmap state
continues to match the hardware state on either outcome.

Fixes: 1e3cb6c321be ("ASoC: nau8822: new codec driver")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260830141828.34419-1-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/nau8822.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/nau8822.c b/sound/soc/codecs/nau8822.c
index 978d44ea76eb0..6ca83ad95321f 100644
--- a/sound/soc/codecs/nau8822.c
+++ b/sound/soc/codecs/nau8822.c
@@ -1061,10 +1061,14 @@ static int nau8822_suspend(struct snd_soc_component *component)
 {
 	struct nau8822 *nau8822 = snd_soc_component_get_drvdata(component);
 	struct snd_soc_dapm_context *dapm = snd_soc_component_to_dapm(component);
+	int ret;
 
 	snd_soc_dapm_force_bias_level(dapm, SND_SOC_BIAS_OFF);
-	regulator_bulk_disable(NAU8822_NUM_SUPPLIES, nau8822->supplies);
+	ret = regulator_bulk_disable(NAU8822_NUM_SUPPLIES, nau8822->supplies);
+	if (ret)
+		return ret;
 
+	regcache_cache_only(nau8822->regmap, true);
 	regcache_mark_dirty(nau8822->regmap);
 
 	return 0;
@@ -1074,7 +1078,9 @@ static int nau8822_resume(struct snd_soc_component *component)
 {
 	struct nau8822 *nau8822 = snd_soc_component_get_drvdata(component);
 	struct snd_soc_dapm_context *dapm = snd_soc_component_to_dapm(component);
-	int ret = regulator_bulk_enable(NAU8822_NUM_SUPPLIES, nau8822->supplies);
+	int ret;
+
+	ret = regulator_bulk_enable(NAU8822_NUM_SUPPLIES, nau8822->supplies);
 
 	if (ret) {
 		dev_err(component->dev,
@@ -1084,7 +1090,10 @@ static int nau8822_resume(struct snd_soc_component *component)
 
 	fsleep(100);
 
-	regcache_sync(nau8822->regmap);
+	regcache_cache_only(nau8822->regmap, false);
+	ret = regcache_sync(nau8822->regmap);
+	if (ret)
+		return ret;
 
 	snd_soc_dapm_force_bias_level(dapm, SND_SOC_BIAS_STANDBY);
 
-- 
2.53.0



