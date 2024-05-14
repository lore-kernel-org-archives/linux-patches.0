Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC412B9AD;
	Tue, 14 May 2024 11:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687729; cv=none; b=BVrELktD0+WoB+H9ZNLCyjw6316eLwNR+KJESR1QOEUdioOvEtFQYGdv3Db4HrQtomKj6DYwTKxzA8ZIJZv+VTvFBZzckpcPSt7BlJ1o5kn5/T/1Q07yx1OwxZRPdyR41Nl1u5WmZcznX/WJO0pX7A58e2/+1cfB0wnFewcYbSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687729; c=relaxed/simple;
	bh=y//8hQFdYdeylIQv8wyApTR/HiLvDrIr224d0Ydb504=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bdE7cPiqT2tfi+P8DY9BAbg7WCq9Uy2KX8PYiH53EYESh5UffVgq6MO7gWcavyhJZacyLFVI2NT1PqoC8DgyFlfpWDKX3PeeWA33k9Xdd5dW9Jf5at26HXph+PX0kbf1AT2eeSgFcb4Hdtq5Xbs5zMJ3IwMOeZ+b+miwPnVV0j8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wQBDUURH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wQBDUURH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 101DAC2BD10;
	Tue, 14 May 2024 11:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687729;
	bh=y//8hQFdYdeylIQv8wyApTR/HiLvDrIr224d0Ydb504=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wQBDUURHDiw69GtW5m4bOSvqioVHVB4tMid/RArYLVFjkndJNz8U8gVfYxrmM13sy
	 0j0TrwDl8c7wSgCioeHZLEz2T9D4+dBtXqX6ROoOl6i3qSxtvuF0lIYNr/udbZxr0n
	 bY3ynsh9xvCCmwppMVrYeBKNZ2bS4mdGsi1irHMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 085/168] iommu: mtk: fix module autoloading
Date: Tue, 14 May 2024 12:19:43 +0200
Message-ID: <20240514101009.901858901@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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
index 2ae46fa6b3dee..04ac40d11fdff 100644
--- a/drivers/iommu/mtk_iommu.c
+++ b/drivers/iommu/mtk_iommu.c
@@ -1101,6 +1101,7 @@ static const struct of_device_id mtk_iommu_of_ids[] = {
 	{ .compatible = "mediatek,mt8192-m4u", .data = &mt8192_data},
 	{}
 };
+MODULE_DEVICE_TABLE(of, mtk_iommu_of_ids);
 
 static struct platform_driver mtk_iommu_driver = {
 	.probe	= mtk_iommu_probe,
diff --git a/drivers/iommu/mtk_iommu_v1.c b/drivers/iommu/mtk_iommu_v1.c
index fe1c3123a7e77..3a52f6a6ecb32 100644
--- a/drivers/iommu/mtk_iommu_v1.c
+++ b/drivers/iommu/mtk_iommu_v1.c
@@ -576,6 +576,7 @@ static const struct of_device_id mtk_iommu_of_ids[] = {
 	{ .compatible = "mediatek,mt2701-m4u", },
 	{}
 };
+MODULE_DEVICE_TABLE(of, mtk_iommu_v1_of_ids);
 
 static const struct component_master_ops mtk_iommu_com_ops = {
 	.bind		= mtk_iommu_bind,
-- 
2.43.0



