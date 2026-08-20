Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D05F377A82;
	Thu, 20 Aug 2026 16:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243414; cv=none; b=imy2iRGOq+KT4V+tPfn1oLoXQ2yDv83vpu04N3oYcXtkZf/DKIqWxuP0I/hv4IGdFrOFhkniAFlyUDkMDmojhzSgNtlQqHKRlvoAvBY+cPexrUM/pqu2wzeYzfWEkA7cfpztDC5zOf1PhKkpcHF1oerVedIIHBsUOT3uwM6zvys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243414; c=relaxed/simple;
	bh=3cEK/bnyxb1hHHP+yqsW8tUxpkneUxwSNanvI6m1MBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qT1JheI6YrK+TsxMZNTLb00zf/f5/7fL2shaQbHNbFs4HihIY6GQi20DPdBUrrkgMIZho1inWbeZoXa12htNPgOoY9eULrGTndXmvV0/8f2VqHM9teI4TOYM3Nqtw87H5kacINF4b9innnl1ukwHBp3HgfqFLu126/zgz6HU2wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ag8oyjDM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ag8oyjDM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A995C1F000E9;
	Thu, 20 Aug 2026 16:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243413;
	bh=sJcAX2LkXQN2FS5WANGkyL95T2zXJzcvafuZKEobuQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ag8oyjDM5RbAsswP+rB5TAF4fBVeyyD/U62bihQZOu9wiHTLnMsWwDM4RRFc3iQuU
	 b/ougLpT7bDjmQZNa6MYmg3dtxKrxmfr9fYTWg6Y+17l0X9X/NyUL7n3lXe+fN+w15
	 CTxTwUo/3twP4XiRC0e7ePq6Z5OiXJhVMHNiSoYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Mergnat <amergnat@baylibre.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 087/272] ASoC: mediatek: Use common mtk_afe_pcm_platform with common probe cb
Date: Thu, 20 Aug 2026 16:54:31 +0200
Message-ID: <20260820145233.882915215@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit 1d2a6b3b5189b6c3e51f29e050aa9b2337b774e8 ]

Since the mtk-afe-platform-driver generic mtk_afe_pcm_platform now has
a common .probe() callback, there is no reason to keep duplicating this
function over and over in the SoC specific AFE-PCM drivers: switch over
to register with the common bits instead.

Note that MT8186 was left out of this because it is registering some
extra sinegen controls in the AFE-PCM probe callback and needs extra
cleanups to be able to use the common bits.

Reviewed-by: Alexandre Mergnat <amergnat@baylibre.com>
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20240416071410.75620-13-angelogioacchino.delregno@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: e24d5dde56a5 ("ASoC: mediatek: mt8192: Check runtime resume during probe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/mediatek/mt8192/mt8192-afe-pcm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/soc/mediatek/mt8192/mt8192-afe-pcm.c
+++ b/sound/soc/mediatek/mt8192/mt8192-afe-pcm.c
@@ -2232,13 +2232,13 @@ static int mt8192_afe_pcm_dev_probe(stru
 
 	/* enable clock for regcache get default value from hw */
 	afe_priv->pm_runtime_bypass_reg_ctl = true;
-	pm_runtime_get_sync(&pdev->dev);
+	pm_runtime_get_sync(dev);
 
 	ret = regmap_reinit_cache(afe->regmap, &mt8192_afe_regmap_config);
 	if (ret)
 		return dev_err_probe(dev, ret, "regmap_reinit_cache fail\n");
 
-	pm_runtime_put_sync(&pdev->dev);
+	pm_runtime_put_sync(dev);
 	afe_priv->pm_runtime_bypass_reg_ctl = false;
 
 	regcache_cache_only(afe->regmap, true);


