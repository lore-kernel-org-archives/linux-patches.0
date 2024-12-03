Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 040E11AB6C9;
	Tue,  3 Dec 2024 15:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241307; cv=none; b=I3LmH4WydX7w3qNOQbgZ6AEnjQJk81vklkmCQrcwLRzxXFmF9sV+rPT4/Uxptf8m3pNOmHHVabMV6O7aKuMnjCMOYv1gsBgMXNSmCg4vKftDKCbeWlVlPlmzEquNzjEQIkCF5qptFblgfeoNIKeABjgD4SfN2abc1FlNr72pa7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241307; c=relaxed/simple;
	bh=lFGxBcTqaUPVHvqACtJw2HY7i2yNVNyCrGRl3Gy8E6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bnsCgtqwDQ96BAXV2yrA1S5Nrbrz8nO/KcI3wdlJKgSanquT8lJdEF2Kua2I62dvihaWdDNrOUgAtKEcUBC+0hzVNV7KuRnzAxM1xflUQVsJbkk5kjRRGMzaA5Svi4PtL+bQdQHPZY5XuuxG7z6IPVo5a8r3hZlYdSNqkaTVdfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=APBm9CwR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="APBm9CwR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E69AC4CECF;
	Tue,  3 Dec 2024 15:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241306;
	bh=lFGxBcTqaUPVHvqACtJw2HY7i2yNVNyCrGRl3Gy8E6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=APBm9CwRQv/XtHuMW8y9Ysr+wAZmIAMovLxEhZgAMiResqa+TPos3iWIQnnd9Wr0P
	 SqAwCfgormwRQAUACBhbPkPLusIqPmiO1K/Uc1PFO4fRsdaYQkgI5lK7pA+cW2SiAA
	 moLkZ6tSl1i28N+ZXg8aLXsN4slUvhhhOTaASp/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 383/826] iommu/tegra241-cmdqv: Staticize cmdqv_debugfs_dir
Date: Tue,  3 Dec 2024 15:41:50 +0100
Message-ID: <20241203144758.706043384@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolin Chen <nicolinc@nvidia.com>

[ Upstream commit 89edbe88db2857880b08ce363a2695eec657f51b ]

Fix a sparse warning.

Fixes: 918eb5c856f6 ("iommu/arm-smmu-v3: Add in-kernel support for NVIDIA Tegra241 (Grace) CMDQV")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202410172003.bRQEReTc-lkp@intel.com/
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/20241021230847.811218-1-nicolinc@nvidia.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
index fcd13d301fff6..a243c543598ce 100644
--- a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
+++ b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
@@ -800,7 +800,7 @@ static int tegra241_cmdqv_init_structures(struct arm_smmu_device *smmu)
 	return 0;
 }
 
-struct dentry *cmdqv_debugfs_dir;
+static struct dentry *cmdqv_debugfs_dir;
 
 static struct arm_smmu_device *
 __tegra241_cmdqv_probe(struct arm_smmu_device *smmu, struct resource *res,
-- 
2.43.0



