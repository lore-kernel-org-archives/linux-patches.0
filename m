Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32977377A82;
	Thu, 20 Aug 2026 16:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243417; cv=none; b=WvWCL68rRswhZSpZycf/cCkhuJT9qOOmWy8srYnjSlmNLurQXBrCxJiNA7vFKYWqYQPHF5V0WkV5RCgj+SNkc/13pG/9VnZK/IAASiFukAT8UXqJRsTsJQcvRtX4NBORv79Unm+boVUzMZ+gfIvxqvCNfmBLerx2RxEUYTeR+D0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243417; c=relaxed/simple;
	bh=ERXtB0IbaofCWLTWsjLmfqxQPv5ArbC4wO3a0yZbkEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LNLmv+lWmat4CLZMIWNO/FV/sHFornSLxUrvjQyoNRvI9mzKl/xnu615V7nE14i/wGxANzJMQw9iltF5MH4qL3r9AfR7wYvuYa0NcILYP+osCBPA53SFUu6Osgbsj0jDdZMEgatM9JUv4CXpUKxgHB8o97lsCtqneq+3GCY3f1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R0ZdKVvg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R0ZdKVvg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8126F1F000E9;
	Thu, 20 Aug 2026 16:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243416;
	bh=mXUd6ENT4mjW/wGNev5AHkUMbhinrzrjd5Imo6rQbCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R0ZdKVvgW9IdjxXaFzFrSKMjA70R1Qb72oAu0R/AewShRzjKTC35P1lVSPI3aIZFu
	 o8O5MuY5RFDSim9bC+cfhIy7nPAyLXgCljsqJf0aZx9a3O2uP2tuuO1zvvht40skBn
	 RYoeTKHWtjR55+FA7Ar++Ox/bFSGal0korntGUV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tang Bin <tangbin@cmss.chinamobile.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 088/272] ASoC: mediatek: mt8192-afe-pcm: Simplify probe() with local dev variable
Date: Thu, 20 Aug 2026 16:54:32 +0200
Message-ID: <20260820145233.914392020@linuxfoundation.org>
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

From: Tang Bin <tangbin@cmss.chinamobile.com>

[ Upstream commit 01981565c764c554cc96e2d30a71c42975171416 ]

Simplify the function mt8192_afe_pcm_dev_probe() by
using local 'dev' instead of '&pdev->dev'.

Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
Link: https://patch.msgid.link/20241025080026.2393-1-tangbin@cmss.chinamobile.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: e24d5dde56a5 ("ASoC: mediatek: mt8192: Check runtime resume during probe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/mediatek/mt8192/mt8192-afe-pcm.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/sound/soc/mediatek/mt8192/mt8192-afe-pcm.c
+++ b/sound/soc/mediatek/mt8192/mt8192-afe-pcm.c
@@ -2178,27 +2178,26 @@ static int mt8192_afe_pcm_dev_probe(stru
 {
 	struct mtk_base_afe *afe;
 	struct mt8192_afe_private *afe_priv;
-	struct device *dev;
+	struct device *dev = &pdev->dev;
 	struct reset_control *rstc;
 	int i, ret, irq_id;
 
-	ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(34));
+	ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(34));
 	if (ret)
 		return ret;
 
-	afe = devm_kzalloc(&pdev->dev, sizeof(*afe), GFP_KERNEL);
+	afe = devm_kzalloc(dev, sizeof(*afe), GFP_KERNEL);
 	if (!afe)
 		return -ENOMEM;
 	platform_set_drvdata(pdev, afe);
 
-	afe->platform_priv = devm_kzalloc(&pdev->dev, sizeof(*afe_priv),
+	afe->platform_priv = devm_kzalloc(dev, sizeof(*afe_priv),
 					  GFP_KERNEL);
 	if (!afe->platform_priv)
 		return -ENOMEM;
 	afe_priv = afe->platform_priv;
 
-	afe->dev = &pdev->dev;
-	dev = afe->dev;
+	afe->dev = dev;
 
 	/* init audio related clock */
 	ret = mt8192_init_clock(afe);
@@ -2216,7 +2215,7 @@ static int mt8192_afe_pcm_dev_probe(stru
 	if (ret)
 		return dev_err_probe(dev, ret, "failed to trigger audio reset\n");
 
-	ret = devm_pm_runtime_enable(&pdev->dev);
+	ret = devm_pm_runtime_enable(dev);
 	if (ret)
 		return ret;
 
@@ -2305,12 +2304,12 @@ static int mt8192_afe_pcm_dev_probe(stru
 	afe->runtime_suspend = mt8192_afe_runtime_suspend;
 
 	/* register platform */
-	ret = devm_snd_soc_register_component(&pdev->dev,
+	ret = devm_snd_soc_register_component(dev,
 					      &mt8192_afe_component, NULL, 0);
 	if (ret)
 		return dev_err_probe(dev, ret, "Couldn't register AFE component\n");
 
-	ret = devm_snd_soc_register_component(&pdev->dev,
+	ret = devm_snd_soc_register_component(dev,
 					      &mt8192_afe_pcm_component,
 					      afe->dai_drivers,
 					      afe->num_dai_drivers);


