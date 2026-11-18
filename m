Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023154;
	b=0vA62EwAchnJK13UBk8ckaVTajCddVtV+adGnbdvq1zBPI/fJwQDZSbebAa70T5O8QIQ
	 pSbcyIGuOVYa6xYAdXpbpwe3lQvhZISi566DKTEMhOxifHZh5R+uKiYZ+rSYQNLg7aLe5
	 LhMlgHyLTil9ZtbF0cVXndbLdXVHanmgtcktynXFC94SO+pN8ZbdDdCzKkDgB/tyh/3ur
	 ExpFksn8QUkvNfZ+IpkEgpwP6f2uE1Honoly7GJuLXa45p6Wd33ykkZRiUxHZc9QqftsD
	 MuBry4qsmj4sGAyb2I7jaxvsqKCyM3cmew7LKe712QsfpVzsQTsX6R0f9DlX9xU2myA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023154;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gBY4cWNzYMIYBj+nNvyCJ5GGWKXux8IlITo67m6nKrs=;
	b=rHMIy14sQGv3Zwrg1zh3JR5PH/MJNC5frQcRiIliWk26AEDlSXe0Qxue1P2Ofz5g2oAV
	 J8YNXWp8RFQZC/FgSwzJdnoYW8yrTvzidycgnGN+WyjwFIqIzmnlHywBIgZO4xJAJjjBJ
	 25Xw5DT26vzyq4RHBq2SaPBa/rkrs5KMsCtgREPdBgHT9QTB85wB+0pM3siLUMJBh+R/u
	 lkBW75JqSiJ9J+8/CnRl58RnBHq78o/U2AF4A41WmN09J65RGSGi3PoXt6vKveajEE2g0
	 k/vwpklzycpo7tU9JvpxpD5wxp1HQTZxMctpOmr0OxG+f/JlSo/1RB7V/Z38Of8ev6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TEr0NtRJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57637606A333;
	Wed, 18 Nov 2026 17:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TEr0NtRJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 698AD1F000C5;
	Wed, 18 Nov 2026 17:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023153;
	bh=gBY4cWNzYMIYBj+nNvyCJ5GGWKXux8IlITo67m6nKrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TEr0NtRJY7L/iRd2uLkS4W75XzKDrqoLbywaqszD/enTOJipHoVmzL9piFnV6NdaB
	 2IirmLoorA7xolpBZXsXW8dWt+0RjtBBaM9cEIlx6BzUlyC5eNYEDyIR/4ga9N+r9M
	 578KomT8R5WgqX19I3R6oAZbP1qP1vw65QSx3X9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <hppiscas@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0268/2151] ASoC: es8375: report resume restore errors
Date: Wed, 18 Nov 2026 15:33:23 +0100
Message-ID: <20261118150131.584010799@linuxfoundation.org>
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

From: Pengpeng Hou <hppiscas@163.com>

[ Upstream commit 8f43acfd3addf10fbde8d21dd44b1a61e1936ba7 ]

es8375_resume() ignores the clock-status read, bias restoration and
register-cache replay. A read failure can leave reg uninitialized before
it selects the initialization path, and later resume processing cannot
observe a failed restore.

Return the fallible operation results to the ASoC component wrapper, which
reports callback failures while retaining its best-effort resume contract.

The issue was found by our static-analysis tool and manually reviewed.

Fixes: de2b3119f9f7 ("ASoC: codecs: add support for ES8375")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <hppiscas@163.com>
Link: https://patch.msgid.link/20260906034217.85696-3-hppiscas@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/es8375.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/sound/soc/codecs/es8375.c b/sound/soc/codecs/es8375.c
index 36b0ebdce514d..c235f91929b31 100644
--- a/sound/soc/codecs/es8375.c
+++ b/sound/soc/codecs/es8375.c
@@ -579,20 +579,24 @@ static int es8375_resume(struct snd_soc_component *component)
 {
 	struct es8375_priv *es8375 = snd_soc_component_get_drvdata(component);
 	unsigned int reg;
+	int ret;
 
 	regcache_cache_only(es8375->regmap, false);
 	regcache_cache_bypass(es8375->regmap, true);
-	regmap_read(es8375->regmap, ES8375_CLK_MGR2, &reg);
+	ret = regmap_read(es8375->regmap, ES8375_CLK_MGR2, &reg);
 	regcache_cache_bypass(es8375->regmap, false);
+	if (ret)
+		return ret;
 
-	if (reg == 0x00)
+	if (reg == 0x00) {
 		es8375_init(component);
-	else
-		es8375_set_bias_level(component, SND_SOC_BIAS_ON);
-
-	regcache_sync(es8375->regmap);
+	} else {
+		ret = es8375_set_bias_level(component, SND_SOC_BIAS_ON);
+		if (ret)
+			return ret;
+	}
 
-	return 0;
+	return regcache_sync(es8375->regmap);
 }
 
 static int es8375_codec_probe(struct snd_soc_component *component)
-- 
2.53.0



