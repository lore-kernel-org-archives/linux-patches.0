Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A029248BAF;
	Wed, 15 Jan 2025 11:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938858; cv=none; b=rP3NreLYmwxLMgxTXBhDRQXBA6ygV2wTuddf5uekYlVFJACWOPIQNfT21tijaUO1jvGO5ls3hUjCr8Vlf6rK826b2xrrlutP74bYoxEA/OzHY9hqLKOH1whKQ1Y2TjQfLpRNHptAz8yV/NKsIUCHuDhthe7afwHiD77ub9kvV7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938858; c=relaxed/simple;
	bh=iI5MEQ1nwn5z3jEcPMf47bMWnMu5ePM12KKQmLyfpz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iL94w8jNZ4OZun/QwA53L1LX2XHaBu8oszASTVoYCD6b9MYDAYXku19SVciJ1HXkRUYNr8u9tRNjOvfQEQvA9eB4MCTng9y2w3KoZKO8e91Bp2i+bzG5WnO977I+IWLGxslcEdSBWklHVjCKSUjDaME6FfbfqVAeqC/5FZKxvic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g/OV/NEQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g/OV/NEQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9B03C4CEDF;
	Wed, 15 Jan 2025 11:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938858;
	bh=iI5MEQ1nwn5z3jEcPMf47bMWnMu5ePM12KKQmLyfpz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g/OV/NEQD9Y8X7Ngcgs6xO66Gr3jPlIto0L+bS/8jQwF2IpSOi+BIX4MEd8vzyc7z
	 gr7gwzHtbaOiat1DnhYmO3h/BE5hoeDjLONuoKoQeIg7JGXFpfxNkZv04brvP2lVhM
	 NheP/hiosqK8u23+nuPvgnMvgkapPoT6oTiepXmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 119/129] pmdomain: imx: gpcv2: Simplify with scoped for each OF child loop
Date: Wed, 15 Jan 2025 11:38:14 +0100
Message-ID: <20250115103559.100606132@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 13bd778c900537f3fff7cfb671ff2eb0e92feee6 ]

Use scoped for_each_child_of_node_scoped() when iterating over device
nodes to make code a bit simpler.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20240823-cleanup-h-guard-pm-domain-v1-4-8320722eaf39@linaro.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Stable-dep-of: 469c0682e03d ("pmdomain: imx: gpcv2: fix an OF node reference leak in imx_gpcv2_probe()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pmdomain/imx/gpcv2.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/pmdomain/imx/gpcv2.c b/drivers/pmdomain/imx/gpcv2.c
index fbd3d92f8cd8..ec789bf92274 100644
--- a/drivers/pmdomain/imx/gpcv2.c
+++ b/drivers/pmdomain/imx/gpcv2.c
@@ -1449,7 +1449,7 @@ static int imx_gpcv2_probe(struct platform_device *pdev)
 		.max_register   = SZ_4K,
 	};
 	struct device *dev = &pdev->dev;
-	struct device_node *pgc_np, *np;
+	struct device_node *pgc_np;
 	struct regmap *regmap;
 	void __iomem *base;
 	int ret;
@@ -1471,7 +1471,7 @@ static int imx_gpcv2_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	for_each_child_of_node(pgc_np, np) {
+	for_each_child_of_node_scoped(pgc_np, np) {
 		struct platform_device *pd_pdev;
 		struct imx_pgc_domain *domain;
 		u32 domain_index;
@@ -1482,7 +1482,6 @@ static int imx_gpcv2_probe(struct platform_device *pdev)
 		ret = of_property_read_u32(np, "reg", &domain_index);
 		if (ret) {
 			dev_err(dev, "Failed to read 'reg' property\n");
-			of_node_put(np);
 			return ret;
 		}
 
@@ -1497,7 +1496,6 @@ static int imx_gpcv2_probe(struct platform_device *pdev)
 						domain_index);
 		if (!pd_pdev) {
 			dev_err(dev, "Failed to allocate platform device\n");
-			of_node_put(np);
 			return -ENOMEM;
 		}
 
@@ -1506,7 +1504,6 @@ static int imx_gpcv2_probe(struct platform_device *pdev)
 					       sizeof(domain_data->domains[domain_index]));
 		if (ret) {
 			platform_device_put(pd_pdev);
-			of_node_put(np);
 			return ret;
 		}
 
@@ -1523,7 +1520,6 @@ static int imx_gpcv2_probe(struct platform_device *pdev)
 		ret = platform_device_add(pd_pdev);
 		if (ret) {
 			platform_device_put(pd_pdev);
-			of_node_put(np);
 			return ret;
 		}
 	}
-- 
2.39.5



