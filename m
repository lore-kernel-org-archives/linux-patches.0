Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC5C33E346;
	Sat, 12 Sep 2026 16:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230164; cv=none; b=D3XFsrBzdwJ2TPrlqqd8qFbo0svEm1796q3UtFMO6bjPKmqd6HfScH+RmVxiFtWI9zZwbATSF1DbPM93d7j0T4vw/VuvgqZQSQcxz0jeslvpRoY7khlsbBXu09AVxLZtRb4/2QPNr3Yr8ImIHeLYvWHOqTRtYlPZ1xVf0jZdiQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230164; c=relaxed/simple;
	bh=PVad766ABlJEg1tPCTPHnh0WxiDan86ULPo2hMBV0yg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IuKjRKF4mLxy1MqrpTn4mGUgT4644BjJHqKbLkqPBdyT0+nK5mQbU0KOndqkQW8ISKDLOX8gJvilb/y7Vj2z8RWgQJ7/Ioii+nwr15AJqMQiXhsHxvZrekOGCOx/27WV5r/+1/SydHLFK2O8VgtaU07YI9GutAZ9reMIrN/v6ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zR7/W2AD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zR7/W2AD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 012A91F000FF;
	Sat, 12 Sep 2026 16:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230163;
	bh=IcC2O+CDP+/cKhhNpW1oaxrWJnfAbphps6XEU8zQK4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zR7/W2ADsdiSA0rJlYhEV3qap0vKoExrsT/1knmmbuSIb6AhwJaY2PoTny0K43RN1
	 EcSTlh9EZp0vDqkZTrTLhr0HjfQgPAYqvwaIDRoi55JaMfKGE+Cv66AVP78eDZfMwT
	 inYnipF1lQfoF4j3wEi5L2uJuHk6kKDzp8M7YT14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0695/1191] iommu/qcom: Remove sysfs device on probe failure path
Date: Sat, 12 Sep 2026 08:57:03 +0200
Message-ID: <20260912065603.870392896@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3d4428e688ee5..cf8dcd2371e8f 100644
--- a/drivers/iommu/arm/arm-smmu/qcom_iommu.c
+++ b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
@@ -847,7 +847,7 @@ static int qcom_iommu_device_probe(struct platform_device *pdev)
 	ret = iommu_device_register(&qcom_iommu->iommu, &qcom_iommu_ops, dev);
 	if (ret) {
 		dev_err(dev, "Failed to register iommu\n");
-		goto err_pm_disable;
+		goto err_sysfs_remove;
 	}
 
 	if (qcom_iommu->local_base) {
@@ -858,6 +858,8 @@ static int qcom_iommu_device_probe(struct platform_device *pdev)
 
 	return 0;
 
+err_sysfs_remove:
+	iommu_device_sysfs_remove(&qcom_iommu->iommu);
 err_pm_disable:
 	pm_runtime_disable(dev);
 	return ret;
-- 
2.53.0



