Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A511EE02F;
	Tue, 30 Sep 2025 15:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244573; cv=none; b=nkaPYO64nCXpHT8PRrTYnZ0mWcdXWbF6wZVT1172+W582iJhFrQHcYXrlZYo6+3WYvsmgXafYNW/o5UkzEuOdqVDXzEDv98mpGV/AyxMAhoyOZVhFqaT/M48qWRpM6/q29iqbnHqqF2u55v/bS3yCLRzrzEp7yzWrET34xwIMos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244573; c=relaxed/simple;
	bh=paS5Rvj02XN/MXAHTrH7eKZFoDcotofx0pG1hQhmTxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cPcJEJM7+vvlx/zkxXI+4MkRty7u6FcZuqdESElnChTFadwugKP5qu8SNckHXUr4/dQ6eKTu4deNlWI7rrYL90FQDgW6ik5RDRmy0Cb+lD63NdHUkAE3iBSW6gOaOzZQTeQBrTrFDXr1SjEnC/HGkCyRFgwx0tsEehRNVTrply4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PQ+Rl+la; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PQ+Rl+la"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E754C4CEF0;
	Tue, 30 Sep 2025 15:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244573;
	bh=paS5Rvj02XN/MXAHTrH7eKZFoDcotofx0pG1hQhmTxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PQ+Rl+laurt7SogcheksFQz3FfVO33aP19H4j/5BUxKBT9JT30HrektFIuC7bxPG/
	 65J9E7itnxvbff8YfoZkvQIil1dyFM73BVisc/qntwb+qocmtz0X/Bac2fab5FcpPz
	 bKqaEWDDFrrQCoXCEYhONoKN9zxcBMCgEye2Xm7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>,
	Steven Price <steven.price@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 021/143] drm/panfrost: Drop duplicated Mediatek supplies arrays
Date: Tue, 30 Sep 2025 16:45:45 +0200
Message-ID: <20250930143832.087483745@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>

[ Upstream commit 6905b0d9813176087fc0f28bc5e4ee2b86e6ce13 ]

In the panfrost driver, the platform data of several Mediatek SoC
declares and uses custom supplies array definitions
(mediatek_mt8192_supplies, mediatek_mt8183_b_supplies), that are the
same as default_supplies (used by default platform data).

So drop these duplicated definitions and use default_supplies instead.
Also, rename mediatek_mt8183_supplies to a more generic name too
(legacy_supplies).

Signed-off-by: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Link: https://lore.kernel.org/r/20250509-mt8370-enable-gpu-v6-2-2833888cb1d3@collabora.com
Stable-dep-of: 81645377c231 ("drm/panfrost: Add support for Mali on the MT8370 SoC")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panfrost/panfrost_drv.c | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/panfrost/panfrost_drv.c b/drivers/gpu/drm/panfrost/panfrost_drv.c
index f1ec3b02f15a0..7b899a9b2120c 100644
--- a/drivers/gpu/drm/panfrost/panfrost_drv.c
+++ b/drivers/gpu/drm/panfrost/panfrost_drv.c
@@ -797,19 +797,18 @@ static const struct panfrost_compatible amlogic_data = {
  * On new devicetrees please use the _b variant with a single and
  * coupled regulators instead.
  */
-static const char * const mediatek_mt8183_supplies[] = { "mali", "sram", NULL };
+static const char * const legacy_supplies[] = { "mali", "sram", NULL };
 static const char * const mediatek_mt8183_pm_domains[] = { "core0", "core1", "core2" };
 static const struct panfrost_compatible mediatek_mt8183_data = {
-	.num_supplies = ARRAY_SIZE(mediatek_mt8183_supplies) - 1,
-	.supply_names = mediatek_mt8183_supplies,
+	.num_supplies = ARRAY_SIZE(legacy_supplies) - 1,
+	.supply_names = legacy_supplies,
 	.num_pm_domains = ARRAY_SIZE(mediatek_mt8183_pm_domains),
 	.pm_domain_names = mediatek_mt8183_pm_domains,
 };
 
-static const char * const mediatek_mt8183_b_supplies[] = { "mali", NULL };
 static const struct panfrost_compatible mediatek_mt8183_b_data = {
-	.num_supplies = ARRAY_SIZE(mediatek_mt8183_b_supplies) - 1,
-	.supply_names = mediatek_mt8183_b_supplies,
+	.num_supplies = ARRAY_SIZE(default_supplies) - 1,
+	.supply_names = default_supplies,
 	.num_pm_domains = ARRAY_SIZE(mediatek_mt8183_pm_domains),
 	.pm_domain_names = mediatek_mt8183_pm_domains,
 	.pm_features = BIT(GPU_PM_CLK_DIS) | BIT(GPU_PM_VREG_OFF),
@@ -817,8 +816,8 @@ static const struct panfrost_compatible mediatek_mt8183_b_data = {
 
 static const char * const mediatek_mt8186_pm_domains[] = { "core0", "core1" };
 static const struct panfrost_compatible mediatek_mt8186_data = {
-	.num_supplies = ARRAY_SIZE(mediatek_mt8183_b_supplies) - 1,
-	.supply_names = mediatek_mt8183_b_supplies,
+	.num_supplies = ARRAY_SIZE(default_supplies) - 1,
+	.supply_names = default_supplies,
 	.num_pm_domains = ARRAY_SIZE(mediatek_mt8186_pm_domains),
 	.pm_domain_names = mediatek_mt8186_pm_domains,
 	.pm_features = BIT(GPU_PM_CLK_DIS) | BIT(GPU_PM_VREG_OFF),
@@ -826,20 +825,19 @@ static const struct panfrost_compatible mediatek_mt8186_data = {
 
 /* MT8188 uses the same power domains and power supplies as MT8183 */
 static const struct panfrost_compatible mediatek_mt8188_data = {
-	.num_supplies = ARRAY_SIZE(mediatek_mt8183_b_supplies) - 1,
-	.supply_names = mediatek_mt8183_b_supplies,
+	.num_supplies = ARRAY_SIZE(default_supplies) - 1,
+	.supply_names = default_supplies,
 	.num_pm_domains = ARRAY_SIZE(mediatek_mt8183_pm_domains),
 	.pm_domain_names = mediatek_mt8183_pm_domains,
 	.pm_features = BIT(GPU_PM_CLK_DIS) | BIT(GPU_PM_VREG_OFF),
 	.gpu_quirks = BIT(GPU_QUIRK_FORCE_AARCH64_PGTABLE),
 };
 
-static const char * const mediatek_mt8192_supplies[] = { "mali", NULL };
 static const char * const mediatek_mt8192_pm_domains[] = { "core0", "core1", "core2",
 							   "core3", "core4" };
 static const struct panfrost_compatible mediatek_mt8192_data = {
-	.num_supplies = ARRAY_SIZE(mediatek_mt8192_supplies) - 1,
-	.supply_names = mediatek_mt8192_supplies,
+	.num_supplies = ARRAY_SIZE(default_supplies) - 1,
+	.supply_names = default_supplies,
 	.num_pm_domains = ARRAY_SIZE(mediatek_mt8192_pm_domains),
 	.pm_domain_names = mediatek_mt8192_pm_domains,
 	.pm_features = BIT(GPU_PM_CLK_DIS) | BIT(GPU_PM_VREG_OFF),
-- 
2.51.0



