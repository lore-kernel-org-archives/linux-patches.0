Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 472D53451C8;
	Sat, 12 Sep 2026 19:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242701; cv=none; b=tUrGRYcpExAa79/nWhLQm/DYw/0N29ccAhw4oVKr1S6tIAE71ipMd/EQ7kpG3D9XHdzq30GaVAO66n5epo5Lh6xPb0UGzlzgx0KGRHapHXZ1qzmBs+LkBZV5P91x4tQSYS295ddgdx+3VsKE/mei4gihO98FP+Qw/6T/1h6jGvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242701; c=relaxed/simple;
	bh=BZK6J2ZiqdLS3QtYCRB2gPTRw0aio+QksMOuOh2h0Bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=spOhdBPKlDF+I68KeWPDYXzp0LIVF1bQPmVhlCbkeZxrvdA8LcZlBktvbcExDqQeqj3EOVu+/hGxQJoJyLSDyKCQ2BybXtlbnca4Pr+WbJLgMSdhwICUmMN0GspTo/bGB7pjKwCWL/pI8dvTvyqfZtYR0PFIOWsyG8e3d7A9QSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TlSPPzGM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TlSPPzGM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FD131F000FF;
	Sat, 12 Sep 2026 19:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242700;
	bh=VXkG1SXt3+hmn7TyukIEKcKI/jGpuyXsrim/eKimObo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TlSPPzGMYjdI0g5/XHYluzIhwkPgvhq2JbV6izaqVLD6b73meSLUWXR2mZm6ohUrl
	 LOCIuP8PhUXimKQsaQKazGMAv+Nv+jh9y1Ectpc4Jjc6mp63Jp53xR4OVo1oai7lij
	 XrgRybfwfLvxaX2H5eEnvG3iZrFaLhuqQPQT5aIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 496/798] iommu/qcom: Remove sysfs device on probe failure path
Date: Sat, 12 Sep 2026 09:02:04 +0200
Message-ID: <20260912065528.504938341@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 6f782f8342561..4154a85fcf07d 100644
--- a/drivers/iommu/arm/arm-smmu/qcom_iommu.c
+++ b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
@@ -869,7 +869,7 @@ static int qcom_iommu_device_probe(struct platform_device *pdev)
 	ret = iommu_device_register(&qcom_iommu->iommu);
 	if (ret) {
 		dev_err(dev, "Failed to register iommu\n");
-		goto err_pm_disable;
+		goto err_sysfs_remove;
 	}
 
 	bus_set_iommu(&platform_bus_type, &qcom_iommu_ops);
@@ -882,6 +882,8 @@ static int qcom_iommu_device_probe(struct platform_device *pdev)
 
 	return 0;
 
+err_sysfs_remove:
+	iommu_device_sysfs_remove(&qcom_iommu->iommu);
 err_pm_disable:
 	pm_runtime_disable(dev);
 	return ret;
-- 
2.53.0



