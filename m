Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 712701F152D;
	Tue, 30 Sep 2025 15:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244592; cv=none; b=RYbo2Dor0/iZJvkb1cf5mqsegkVQsFzjaAKA4Ek02GjUODwni09VygbYpLTN9tJCjepqlf80LKBge7GvmMXQlVG/0mwdpV4rM8gOcycR0MEUAKaUo5hpHp8ffR3CNeat7+fdcHMRWbeznKNBoODXPUO0Dc4LgAl2pFmeOVuNWA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244592; c=relaxed/simple;
	bh=XOEzb3WxbAIVQnGro9bJj/qroOrKwOZAj25YHrY/Uqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mAT68cbQA4KSJvrHmHIRAHJs/yvWhwxvFNpR4VazSf4hnINsyYqAb+ZZyvMbT7CKjVmy5WFb3xNszD0eEOt05dL5arI1+3/Iuqk6DMNYCpqyRrSuiidV0+hyzsfVSVP/ocDRSklN8++89Uls2X9z9jQwcpsaQUBMrnfB6m5iDvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1BKnIGpl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1BKnIGpl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBD6EC4CEF0;
	Tue, 30 Sep 2025 15:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244592;
	bh=XOEzb3WxbAIVQnGro9bJj/qroOrKwOZAj25YHrY/Uqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1BKnIGpl16aP+h9gIaO1fr4i+/BDitCSJ+5GfkdQiyJ/nc4dNFXOuAhzHER1ZAaSx
	 BnP0vvnhqn+mKWNgn5mdWKKaJ9r68mc0ulOpZGY5QaGqB/eSzTB0nokb9WcmUGh4x3
	 7ZnQh5IqD/GyJv0wj4Vf0/851SW6sorqIJT1Xo30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Price <steven.price@arm.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 023/143] drm/panfrost: Add support for Mali on the MT8370 SoC
Date: Tue, 30 Sep 2025 16:45:47 +0200
Message-ID: <20250930143832.166153517@linuxfoundation.org>
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

[ Upstream commit 81645377c231803389ab0f2d09df6622e32dd327 ]

Add a compatible for the MediaTek MT8370 SoC, with an integrated ARM
Mali G57 MC2 GPU (Valhall-JM, dual core), with new platform data for
its support in the panfrost driver.
It uses the same data as MT8186 for the power management features to
describe power supplies, pm_domains and enablement (one regulator, two
power domains) but also sets the FORCE_AARCH64_PGTABLE flag in the GPU
configuration quirks bitfield to enable AARCH64 4K page table format
mode.
As MT8186 and MT8370 SoC have different GPU architecture (Mali G52 2EE
MC2 for MT8186), making them not compatible, and this mode is only
enabled for Mediatek SoC that are Mali G57 based (compatible with
mediatek,mali-mt8188 or mediatek,mali-8192), having specific platform
data allows to set this flag for MT8370 without modifying MT8186
configuration and behaviour.

Reviewed-by: Steven Price <steven.price@arm.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Link: https://lore.kernel.org/r/20250509-mt8370-enable-gpu-v6-4-2833888cb1d3@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panfrost/panfrost_drv.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/gpu/drm/panfrost/panfrost_drv.c b/drivers/gpu/drm/panfrost/panfrost_drv.c
index 21b28bef84015..07cd67baa81bf 100644
--- a/drivers/gpu/drm/panfrost/panfrost_drv.c
+++ b/drivers/gpu/drm/panfrost/panfrost_drv.c
@@ -841,6 +841,15 @@ static const struct panfrost_compatible mediatek_mt8192_data = {
 	.gpu_quirks = BIT(GPU_QUIRK_FORCE_AARCH64_PGTABLE),
 };
 
+static const struct panfrost_compatible mediatek_mt8370_data = {
+	.num_supplies = ARRAY_SIZE(default_supplies) - 1,
+	.supply_names = default_supplies,
+	.num_pm_domains = 2,
+	.pm_domain_names = mediatek_pm_domains,
+	.pm_features = BIT(GPU_PM_CLK_DIS) | BIT(GPU_PM_VREG_OFF),
+	.gpu_quirks = BIT(GPU_QUIRK_FORCE_AARCH64_PGTABLE),
+};
+
 static const struct of_device_id dt_match[] = {
 	/* Set first to probe before the generic compatibles */
 	{ .compatible = "amlogic,meson-gxm-mali",
@@ -863,6 +872,7 @@ static const struct of_device_id dt_match[] = {
 	{ .compatible = "mediatek,mt8186-mali", .data = &mediatek_mt8186_data },
 	{ .compatible = "mediatek,mt8188-mali", .data = &mediatek_mt8188_data },
 	{ .compatible = "mediatek,mt8192-mali", .data = &mediatek_mt8192_data },
+	{ .compatible = "mediatek,mt8370-mali", .data = &mediatek_mt8370_data },
 	{ .compatible = "allwinner,sun50i-h616-mali", .data = &allwinner_h616_data },
 	{}
 };
-- 
2.51.0



