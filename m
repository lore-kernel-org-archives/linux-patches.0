Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015805;
	b=vrkzjZcYuuQned4utAXlR+kGh9tqSBylKKE/jYWPEt1Tz2Y69p7chjYq6faAz/0CglIG
	 r9OiaJEJFZXWTpECJyQA0720pXRVMKeEzqQau9NKpg6AvOceo65beKmc8BlDS9Pfm4p8T
	 QIe1hpZDN+uri2amWyl8fXT1TFI5gGmguiqRqgTbElcoTR7kvBbZmSPZrCXeh68rbA0Z7
	 DerSzsFvUrUmfhezbkDadLYCSCifpOrMVCylxugwZCB+Qj/Wau/vemOoN7DTGh9s1XEjw
	 o5iOdikfbbnPZp5927DkA0IxW0YRNulBqKIxhAkkswyhrVZE9vKL5swoeDKjFwt1o9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015805;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y7I533NPNHB9qZ40pcvPPPTjo5ValVs2yWJHTLfsC3Y=;
	b=5PY8yCJaLoBcvi/ayugc4SJSm4pUgFEEPu5XZmhcYi2DR6EMO7pRfgRaz7UxEbKTRZxs
	 qylkMT63eGhd69wPQ4ODknx2tf+7pjNHhU2VGXbdVL2L4Kxnjhb5gBeLvsWLi65zNVxnn
	 o8vR9XrvFkvQ47XATSktxp8xvFBgJUudw69fNPZarw8vr4nv4FQc25IVb7DhJ3rkRQQsE
	 SVVZGXzEjPgBLjuG3Bjys3GIlEv9v10+8RUDuVk7qCE1jZKBgrw4pcdVcljdczzirm+ih
	 KT74U48wh28boM8/dWqqux603uddnXOptcNFoNt1FB2/qA4uDK3z+nqe0pwrRPqypTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VukTCD7G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE3C606A32A;
	Wed, 18 Nov 2026 15:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VukTCD7G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35CFC1F000C5;
	Wed, 18 Nov 2026 15:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015805;
	bh=y7I533NPNHB9qZ40pcvPPPTjo5ValVs2yWJHTLfsC3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VukTCD7GihAiRZq/bPoe3A0ulKzVx7iJwz7yrsng3J3CZSiICvGwlaouUGcMPkWjO
	 Z0i56xguhxoFk2e0SGkAysCCeytYWpnMxVULr3RCsWTER0QhXmnmRkBA+fFIv6eB4B
	 Ia0RGx0uKMvmyqPDyizj4vsunWWgQ+VgxoprslS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0305/2651] ASoC: nau8822: keep regcache offline while supplies are off
Date: Wed, 18 Nov 2026 15:25:45 +0100
Message-ID: <20261118150258.878963442@linuxfoundation.org>
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
index b4ae269873c4a..07c9109cca7aa 100644
--- a/sound/soc/codecs/nau8822.c
+++ b/sound/soc/codecs/nau8822.c
@@ -1059,10 +1059,14 @@ static int nau8822_suspend(struct snd_soc_component *component)
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
@@ -1072,7 +1076,9 @@ static int nau8822_resume(struct snd_soc_component *component)
 {
 	struct nau8822 *nau8822 = snd_soc_component_get_drvdata(component);
 	struct snd_soc_dapm_context *dapm = snd_soc_component_to_dapm(component);
-	int ret = regulator_bulk_enable(NAU8822_NUM_SUPPLIES, nau8822->supplies);
+	int ret;
+
+	ret = regulator_bulk_enable(NAU8822_NUM_SUPPLIES, nau8822->supplies);
 
 	if (ret) {
 		dev_err(component->dev,
@@ -1082,7 +1088,10 @@ static int nau8822_resume(struct snd_soc_component *component)
 
 	fsleep(100);
 
-	regcache_sync(nau8822->regmap);
+	regcache_cache_only(nau8822->regmap, false);
+	ret = regcache_sync(nau8822->regmap);
+	if (ret)
+		return ret;
 
 	snd_soc_dapm_force_bias_level(dapm, SND_SOC_BIAS_STANDBY);
 
-- 
2.53.0



