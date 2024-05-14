Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 577195CDFA;
	Tue, 14 May 2024 10:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683206; cv=none; b=pdYOoSGnhVGZ2pRQK6ujFXemaocvD/Fz4m0fMucoH3dfR2M0Pqtt/T7eoqXGaS5oju0qFBcTjQ7dMOGWJOWYrfq1gI+vqIMkrjPbOUSVb5w6SvFZDra+EeOeOwQj/kjUUlInztJt73PDkOdrYiLKHaBXMsWaPFIwtdG0EjUlwdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683206; c=relaxed/simple;
	bh=+gre0mXV16wwAwIifd79U20py2TSZ3p0cdAEUNizfAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n1HAZfbUhczIjvhRmq0GNTAaGX8nZ/tgeKEBB/oVOnqTDC3Z+AAuKfmAVh8UASa48boq5y4SmIBduH6njuIDCdHGI7b/UVXhgBXt3iASsml3Bc1tRbdEFEZLx8mPSaYp/iTZo81+ZLkgTYbeu8P1fjwY4KtQXLS+0lVyfzglLG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DXx8cGLF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DXx8cGLF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35FA4C2BD10;
	Tue, 14 May 2024 10:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683205;
	bh=+gre0mXV16wwAwIifd79U20py2TSZ3p0cdAEUNizfAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DXx8cGLFd8YG2lmaG4bd5yzkDggy+A5PozvgdN91mVfiwqdX3p9fTX0yQtTSBW25p
	 itTMWsahn6qxO0Txz+DV90oxt8XYKWFytydYLBlSMKkgb10V8q0u5R1gmHvMds7Q/8
	 mJIDenFdgYYcYADgydJb3aXvqh2Xp73UhW+QfRgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 176/336] iommu: mtk: fix module autoloading
Date: Tue, 14 May 2024 12:16:20 +0200
Message-ID: <20240514101045.247119224@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit 7537e31df80cb58c27f3b6fef702534ea87a5957 ]

Add MODULE_DEVICE_TABLE(), so modules could be properly autoloaded
based on the alias from of_device_id table.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Link: https://lore.kernel.org/r/20240410164109.233308-1-krzk@kernel.org
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/mtk_iommu.c    | 1 +
 drivers/iommu/mtk_iommu_v1.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/iommu/mtk_iommu.c b/drivers/iommu/mtk_iommu.c
index 7abe9e85a5706..51d0eba8cbdf3 100644
--- a/drivers/iommu/mtk_iommu.c
+++ b/drivers/iommu/mtk_iommu.c
@@ -1789,6 +1789,7 @@ static const struct of_device_id mtk_iommu_of_ids[] = {
 	{ .compatible = "mediatek,mt8365-m4u", .data = &mt8365_data},
 	{}
 };
+MODULE_DEVICE_TABLE(of, mtk_iommu_of_ids);
 
 static struct platform_driver mtk_iommu_driver = {
 	.probe	= mtk_iommu_probe,
diff --git a/drivers/iommu/mtk_iommu_v1.c b/drivers/iommu/mtk_iommu_v1.c
index 25b41222abaec..32cc8341d3726 100644
--- a/drivers/iommu/mtk_iommu_v1.c
+++ b/drivers/iommu/mtk_iommu_v1.c
@@ -599,6 +599,7 @@ static const struct of_device_id mtk_iommu_v1_of_ids[] = {
 	{ .compatible = "mediatek,mt2701-m4u", },
 	{}
 };
+MODULE_DEVICE_TABLE(of, mtk_iommu_v1_of_ids);
 
 static const struct component_master_ops mtk_iommu_v1_com_ops = {
 	.bind		= mtk_iommu_v1_bind,
-- 
2.43.0



