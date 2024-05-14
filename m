Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 545A71D54D;
	Tue, 14 May 2024 11:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686413; cv=none; b=Lrtq1dn/lf6pVIn7T1Jn9JszCpy0BtZTD36WI9CDsMdLRjvCiQkOMV8W4N9OJRTL19Us7yqOyokF5/jSAy4Lw4q6DKL2k6jpLz6EoAMVZ8aatLUViP8sZcS+de5mroVRQAqJ7gKKbUcIDTTUb6CyvC1gm3goLhTFg0ROLS5FOLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686413; c=relaxed/simple;
	bh=k7zkh1svK3HRUhG5aaIRomOwxUzMRQc+tEpsmpM8eMw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p/uAA5V7j8JO1x3DF+jNNAyB3uJNSu67ma4VGCj8JMbjegQgLS5/abEksq1/PPD6CzMVzCBv+8GffV1G4Kt1+Byg8zIkoTlnnBQ5NMZ2WpclFNp9m6mZvrc4k02BB68QAuLlMJ9vwigTs1Jpw5LuOj/0GPu5n9akKzBUpz/Q6O8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tackMvK5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tackMvK5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D09DBC2BD10;
	Tue, 14 May 2024 11:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686413;
	bh=k7zkh1svK3HRUhG5aaIRomOwxUzMRQc+tEpsmpM8eMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tackMvK5wkASU143+NmUXVlkUM0MOWaM/yMPc1PE/3IHNgc+qb+y49Ws3krqW4h/L
	 lEq07JkHI1gVgN0KFuiMQZCmefiPf31KN12sQGnQHEQBXVTKJ8JIhFf3cLaqnpEh8r
	 9/I7mgKllw8ZpM5LjDI/t3JXx5YZvQVZvcKsHt6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 130/236] iommu: mtk: fix module autoloading
Date: Tue, 14 May 2024 12:18:12 +0200
Message-ID: <20240514101025.304916808@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0ba2a63a9538a..576163f88a4a5 100644
--- a/drivers/iommu/mtk_iommu.c
+++ b/drivers/iommu/mtk_iommu.c
@@ -1570,6 +1570,7 @@ static const struct of_device_id mtk_iommu_of_ids[] = {
 	{ .compatible = "mediatek,mt8195-iommu-vpp",   .data = &mt8195_data_vpp},
 	{}
 };
+MODULE_DEVICE_TABLE(of, mtk_iommu_of_ids);
 
 static struct platform_driver mtk_iommu_driver = {
 	.probe	= mtk_iommu_probe,
diff --git a/drivers/iommu/mtk_iommu_v1.c b/drivers/iommu/mtk_iommu_v1.c
index a978220eb620e..5dd06bcb507f6 100644
--- a/drivers/iommu/mtk_iommu_v1.c
+++ b/drivers/iommu/mtk_iommu_v1.c
@@ -602,6 +602,7 @@ static const struct of_device_id mtk_iommu_v1_of_ids[] = {
 	{ .compatible = "mediatek,mt2701-m4u", },
 	{}
 };
+MODULE_DEVICE_TABLE(of, mtk_iommu_v1_of_ids);
 
 static const struct component_master_ops mtk_iommu_v1_com_ops = {
 	.bind		= mtk_iommu_v1_bind,
-- 
2.43.0



