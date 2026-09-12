Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F343E38A728;
	Sat, 12 Sep 2026 07:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199471; cv=none; b=gMkn1FxcGjOz4Ggkybcy942kLmj91Bq/UYVVhHsT/M6yKlT3YwN1EMd/dGF4vqTh0QGO9JjcLtmuyD23HXRoN9YrBiE0JxcA8jJgOEFjms7yTzCrq9YM9Ja59B/LLspa5QgfHmFoR5wfzob7l+9Fp1Zhw7NyjAxLomxqkS3MEgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199471; c=relaxed/simple;
	bh=0BMB9evUjhaRFWUAS4mUx2ucq49ImqpywCGey1ZbSw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mp10ODxKFKdwl/ZxDeKW+6qceOC6yrD5FuJD0GLCf3OO8D6LH23bEdJrdpabrjmjoMrGNin5ZrDk2p4EiB2nLeia2TzTYGuAyvwDwaPyQ/iFnJAbb76B8WiCnDHdNnUKF6/qH/7WMqaX2LVVylNHMa3fhiNMDCdIBtaKR8dWjKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oHtwyBKl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oHtwyBKl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4BFB1F000FF;
	Sat, 12 Sep 2026 07:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199468;
	bh=u4VpJpO6iSxs9GQv7x5qPqMwI3uJKod+xZtCpLqXkDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oHtwyBKlr3VX1sM+ND72O69dqSqjo3O9iuxBsxge5FbvR2wFAw5NeaH8YpfEZJ2gG
	 msV8/GUwygbCgHhntJt8Xpt3DIZezycw2+23Jlath1F7952feXpl9XG1d27+eYay3H
	 BcbzOBf3B4aCIYIOouRXAHpm+PSQCV+wv/trhP+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0589/1815] iommu/qcom: Remove sysfs device on probe failure path
Date: Sat, 12 Sep 2026 08:38:59 +0200
Message-ID: <20260912065702.708929246@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index a1e8cf29f5948..32efef69e72db 100644
--- a/drivers/iommu/arm/arm-smmu/qcom_iommu.c
+++ b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
@@ -855,7 +855,7 @@ static int qcom_iommu_device_probe(struct platform_device *pdev)
 	ret = iommu_device_register(&qcom_iommu->iommu, &qcom_iommu_ops, dev);
 	if (ret) {
 		dev_err(dev, "Failed to register iommu\n");
-		goto err_pm_disable;
+		goto err_sysfs_remove;
 	}
 
 	if (qcom_iommu->local_base) {
@@ -866,6 +866,8 @@ static int qcom_iommu_device_probe(struct platform_device *pdev)
 
 	return 0;
 
+err_sysfs_remove:
+	iommu_device_sysfs_remove(&qcom_iommu->iommu);
 err_pm_disable:
 	pm_runtime_disable(dev);
 	return ret;
-- 
2.53.0



