Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6E104BEE4C;
	Sat, 12 Sep 2026 14:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223737; cv=none; b=AJ6irTKr4rSkOYssL8zPcbvaqUKTBKZ+7ZkgasbqVKZz6bpWqkhlR8/C6nuqHOSoyA1ZxJrWzuPVhsjzftNLMAx/hUrnaglGHSOjVZmMGpxP6FAeVutDJDOMib7nFL5VapWmxgtw4jAbMovQCBnXOjqZXT5lNOGGDctiawaILSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223737; c=relaxed/simple;
	bh=G1VL7F3NwjaHVlDgfyx9RCD+BcZQMMbOl9Co17bd8tE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tO6byMKnMj3OmV+ukHUwRM6bpg2ENcDFFg4lMhP/QV5OFLuLvbIGpPuMOUPUwaTXGK1Gc4XmSli8szGSQJVa/yd0l6+Z3W5Rfj7a7+lj2NFq5m5zMLd76DmZ88H1xu4XuOgV9IV2kImtunUCmDtbTSTzlvdt+BuE59ydP5nOdJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v54zgUHa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v54zgUHa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9FB41F000FF;
	Sat, 12 Sep 2026 14:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223736;
	bh=P04fR6tsCR+ZmUCEABACG7U+jspRxeQ894tv4x1wejY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v54zgUHan9x/yaLGCwxYOYQEtllTy8VnU9ONS8KrygqvRYytUYngHkuaj1sgTD5aD
	 2Pnc+j22hGYkbt8tNhWki4mnaSdtZdxV7+dMz67IGFT9oN5EIBrrHT3w6tj8BVipoj
	 IPW7KdAUklQ/YLiVysHBVcJAMb9NivG9GbZunLTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0849/1424] iommu/qcom: Remove sysfs device on probe failure path
Date: Sat, 12 Sep 2026 08:54:41 +0200
Message-ID: <20260912065626.322266552@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

[ Upstream commit c579f18e79599c16168925cb149e1db3f29eea5f ]

In qcom_iommu_device_probe(), if iommu_device_register()
fails, the sysfs device created by iommu_device_sysfs_add()
is not released. Add a goto label to do the cleanup.

Fixes: 0ae349a0f33f ("iommu/qcom: Add qcom_iommu")
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu/qcom_iommu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu/qcom_iommu.c b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
index 2c76b306ca562..c0dceb06034bc 100644
--- a/drivers/iommu/arm/arm-smmu/qcom_iommu.c
+++ b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
@@ -832,7 +832,7 @@ static int qcom_iommu_device_probe(struct platform_device *pdev)
 	ret = iommu_device_register(&qcom_iommu->iommu, &qcom_iommu_ops, dev);
 	if (ret) {
 		dev_err(dev, "Failed to register iommu\n");
-		goto err_pm_disable;
+		goto err_sysfs_remove;
 	}
 
 	if (qcom_iommu->local_base) {
@@ -843,6 +843,8 @@ static int qcom_iommu_device_probe(struct platform_device *pdev)
 
 	return 0;
 
+err_sysfs_remove:
+	iommu_device_sysfs_remove(&qcom_iommu->iommu);
 err_pm_disable:
 	pm_runtime_disable(dev);
 	return ret;
-- 
2.53.0



