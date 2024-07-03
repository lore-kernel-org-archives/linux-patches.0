Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A56217BB11;
	Wed,  3 Jul 2024 10:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003896; cv=none; b=b9l4MwYG7armn+K8QTHh7YRg4DvFMCTtDK2EbhdTPAU0fLlGKr6La6xm7YVLVU5sYPM7mkqIN3saOGsddNaGZ14mnId1rYtHbSeByd41krWPDiR670x4OaxBM4c5htlNLvBBhM1e054KFjon8g+6ycI/X/JixKAl4SaLmPVSQIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003896; c=relaxed/simple;
	bh=i7m8ZTUTZM8wYDv7ban4Q8zUWw9l/OrUlunLY6p7r3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B84N5qWeJl8veKQkxezea+owf0YEfVUewaAJ++Y2PxVYykxM5tZDf1WceXSwH6WoUT7wNfYOIQQuNI0Tjk+vWIzv36+3gZPjOSk3GvfDuDgHiSbgT8cfcmburDKERN45FoImiCyLduXBCHFUo2tREGPOTdpCh14Oiv/EP95zg7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=onMl2KNv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="onMl2KNv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3596C2BD10;
	Wed,  3 Jul 2024 10:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003896;
	bh=i7m8ZTUTZM8wYDv7ban4Q8zUWw9l/OrUlunLY6p7r3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=onMl2KNvYUDCD3QPKP9eu4BqphyxriWvZoIAU2Wb/6DUO94BZd1utykPHmcaedk4i
	 8NkoMSmiz2gc9Mc4+b3SU2ojxGMZYU/+aVlm8Cem8fYmyqolD0jIxs4cqs/uddfAQk
	 1qJu+lC//OtIZKpLvw35CU0vYAlg2XI+Ct5Xh0iA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Qilong <zhangqilong3@huawei.com>,
	Peter Ujfalusi <peter.ujfalusi@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 025/189] ASoC: ti: davinci-mcasp: remove always zero of davinci_mcasp_get_dt_params
Date: Wed,  3 Jul 2024 12:38:06 +0200
Message-ID: <20240703102842.457261703@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit 19f6e424d6150b5eede2277dbc6dfd3bf42e994f ]

davinci_mcasp_get_dt_params alway return zero, and its return value
could be ignored by the caller. So make it 'void' type to avoid the
check its return value.

Fixes: 764958f2b5239 ("ASoC: ti: davinci-mcasp: Support for auxclk-fs-ratio")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Link: https://lore.kernel.org/r/20201102103428.32678-1-zhangqilong3@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: d18ca8635db2 ("ASoC: ti: davinci-mcasp: Fix race condition during probe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/ti/davinci-mcasp.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/sound/soc/ti/davinci-mcasp.c b/sound/soc/ti/davinci-mcasp.c
index 76267fd4a9d88..b08948ffc61d0 100644
--- a/sound/soc/ti/davinci-mcasp.c
+++ b/sound/soc/ti/davinci-mcasp.c
@@ -2082,20 +2082,18 @@ static inline int davinci_mcasp_init_gpiochip(struct davinci_mcasp *mcasp)
 }
 #endif /* CONFIG_GPIOLIB */
 
-static int davinci_mcasp_get_dt_params(struct davinci_mcasp *mcasp)
+static void davinci_mcasp_get_dt_params(struct davinci_mcasp *mcasp)
 {
 	struct device_node *np = mcasp->dev->of_node;
 	int ret;
 	u32 val;
 
 	if (!np)
-		return 0;
+		return;
 
 	ret = of_property_read_u32(np, "auxclk-fs-ratio", &val);
 	if (ret >= 0)
 		mcasp->auxclk_fs_ratio = val;
-
-	return 0;
 }
 
 static int davinci_mcasp_probe(struct platform_device *pdev)
@@ -2331,9 +2329,7 @@ static int davinci_mcasp_probe(struct platform_device *pdev)
 	if (ret)
 		goto err;
 
-	ret = davinci_mcasp_get_dt_params(mcasp);
-	if (ret)
-		return -EINVAL;
+	davinci_mcasp_get_dt_params(mcasp);
 
 	ret = devm_snd_soc_register_component(&pdev->dev,
 					&davinci_mcasp_component,
-- 
2.43.0



