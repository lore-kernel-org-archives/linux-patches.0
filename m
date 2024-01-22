Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9781B2599;
	Tue, 23 Jan 2024 01:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972164; cv=none; b=MTTH8bQ4I5IDpL7H27Nit7bG5cbzDHZ30NLNPMTlE8iskiIQ09WonXSsKHpFdSi9E+A8cV0lj45PWnAt+rKO44hOSx3CraaLmWhJXG0S/gFkns4ehuMs7wpeIVVoueWZcWBDXlLyW11EogkvRT2UdSknpMaygnKAeW45+0Ra8V8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972164; c=relaxed/simple;
	bh=flY1VMV0hVaG2pRbYPp1xJ+7UBUja+dYvenOkIbRLo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GraBMMoF+p6r+ugg+DeQyr6Wo1rvFGjZR686LEh/hsJGFu0D6ZQgEA6weevGhYfLB0JpE+0K7vnNcBchvN01jhIqpYt+fEJod1mPUolYmlepTkgsi9w0QAzIRx3vOVSEgOX9FJlvyU/CvIjpOXTpw0tnKVlOXO6Qfz+wPNm1ly8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h3E8Z/YL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h3E8Z/YL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54D74C43390;
	Tue, 23 Jan 2024 01:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972164;
	bh=flY1VMV0hVaG2pRbYPp1xJ+7UBUja+dYvenOkIbRLo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h3E8Z/YLgutNg6zGo2hU0tjTYvOcUDtjve4WY42x2t+KT5HQEC4e81r3aGO7OZtgw
	 GPUleqmQEF9fyodcmwnrv3ZxAGaPDiNd1i5uQXjllGjNnGxY5RpvGSB3Scgun89pif
	 cCwCsE8RS8QKcjbyE49hAaP3J2QPOBPK671OGQLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Herring <robh@kernel.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 084/374] cpufreq: Use of_property_present() for testing DT property presence
Date: Mon, 22 Jan 2024 15:55:40 -0800
Message-ID: <20240122235747.538651205@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Herring <robh@kernel.org>

[ Upstream commit b8f3a396a7ee43e6079176cc0fb8de2b95a23681 ]

It is preferred to use typed property access functions (i.e.
of_property_read_<type> functions) rather than low-level
of_get_property/of_find_property functions for reading properties. As
part of this, convert of_get_property/of_find_property calls to the
recently added of_property_present() helper when we just want to test
for presence of a property and nothing more.

Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Stable-dep-of: c4a5118a3ae1 ("cpufreq: scmi: process the result of devm_of_clk_add_hw_provider()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq-dt-platdev.c | 2 +-
 drivers/cpufreq/imx-cpufreq-dt.c     | 2 +-
 drivers/cpufreq/imx6q-cpufreq.c      | 4 ++--
 drivers/cpufreq/scmi-cpufreq.c       | 2 +-
 drivers/cpufreq/tegra20-cpufreq.c    | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/cpufreq/cpufreq-dt-platdev.c b/drivers/cpufreq/cpufreq-dt-platdev.c
index e1b5975c7daa..48ca7189a73b 100644
--- a/drivers/cpufreq/cpufreq-dt-platdev.c
+++ b/drivers/cpufreq/cpufreq-dt-platdev.c
@@ -171,7 +171,7 @@ static bool __init cpu0_node_has_opp_v2_prop(void)
 	struct device_node *np = of_cpu_device_node_get(0);
 	bool ret = false;
 
-	if (of_get_property(np, "operating-points-v2", NULL))
+	if (of_property_present(np, "operating-points-v2"))
 		ret = true;
 
 	of_node_put(np);
diff --git a/drivers/cpufreq/imx-cpufreq-dt.c b/drivers/cpufreq/imx-cpufreq-dt.c
index 3fe9125156b4..0942498b348c 100644
--- a/drivers/cpufreq/imx-cpufreq-dt.c
+++ b/drivers/cpufreq/imx-cpufreq-dt.c
@@ -89,7 +89,7 @@ static int imx_cpufreq_dt_probe(struct platform_device *pdev)
 
 	cpu_dev = get_cpu_device(0);
 
-	if (!of_find_property(cpu_dev->of_node, "cpu-supply", NULL))
+	if (!of_property_present(cpu_dev->of_node, "cpu-supply"))
 		return -ENODEV;
 
 	if (of_machine_is_compatible("fsl,imx7ulp")) {
diff --git a/drivers/cpufreq/imx6q-cpufreq.c b/drivers/cpufreq/imx6q-cpufreq.c
index 67f98a083d22..ae9ef99f7d86 100644
--- a/drivers/cpufreq/imx6q-cpufreq.c
+++ b/drivers/cpufreq/imx6q-cpufreq.c
@@ -230,7 +230,7 @@ static int imx6q_opp_check_speed_grading(struct device *dev)
 	u32 val;
 	int ret;
 
-	if (of_find_property(dev->of_node, "nvmem-cells", NULL)) {
+	if (of_property_present(dev->of_node, "nvmem-cells")) {
 		ret = nvmem_cell_read_u32(dev, "speed_grade", &val);
 		if (ret)
 			return ret;
@@ -285,7 +285,7 @@ static int imx6ul_opp_check_speed_grading(struct device *dev)
 	u32 val;
 	int ret = 0;
 
-	if (of_find_property(dev->of_node, "nvmem-cells", NULL)) {
+	if (of_property_present(dev->of_node, "nvmem-cells")) {
 		ret = nvmem_cell_read_u32(dev, "speed_grade", &val);
 		if (ret)
 			return ret;
diff --git a/drivers/cpufreq/scmi-cpufreq.c b/drivers/cpufreq/scmi-cpufreq.c
index 1e0cd4d165f0..82e588c3c57b 100644
--- a/drivers/cpufreq/scmi-cpufreq.c
+++ b/drivers/cpufreq/scmi-cpufreq.c
@@ -299,7 +299,7 @@ static int scmi_cpufreq_probe(struct scmi_device *sdev)
 
 #ifdef CONFIG_COMMON_CLK
 	/* dummy clock provider as needed by OPP if clocks property is used */
-	if (of_find_property(dev->of_node, "#clock-cells", NULL))
+	if (of_property_present(dev->of_node, "#clock-cells"))
 		devm_of_clk_add_hw_provider(dev, of_clk_hw_simple_get, NULL);
 #endif
 
diff --git a/drivers/cpufreq/tegra20-cpufreq.c b/drivers/cpufreq/tegra20-cpufreq.c
index e8db3d75be25..72b9c2d5f375 100644
--- a/drivers/cpufreq/tegra20-cpufreq.c
+++ b/drivers/cpufreq/tegra20-cpufreq.c
@@ -25,7 +25,7 @@ static bool cpu0_node_has_opp_v2_prop(void)
 	struct device_node *np = of_cpu_device_node_get(0);
 	bool ret = false;
 
-	if (of_get_property(np, "operating-points-v2", NULL))
+	if (of_property_present(np, "operating-points-v2"))
 		ret = true;
 
 	of_node_put(np);
-- 
2.43.0



