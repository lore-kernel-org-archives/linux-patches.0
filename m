Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBBD2366052;
	Sat, 12 Sep 2026 12:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215966; cv=none; b=eguJnT6R1pbv7OkxUCRHmlXHy81Uyj2d9U/5eZ4ed5mq2j13ghEWRc1RIkkGVCSnfswl2KvOzV8kxOLCELfodVY7h3f+gHKzkuiSkZsca9XSehjbJZQCgfXDYCu+YAP/4qKAy1vg3FtO1RxMeif0kIfmbwn+IqTmaMziY9+/L9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215966; c=relaxed/simple;
	bh=uzsB4s7b3f82TQ4Ta+/90+xNSrZLOlI/OumhHm2wC88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WNr4AxNx0IPK+3GvObGOSTFWyqICT6xcTJ0qgOqA0KYbiKglo/gDBj/TPlzEY/gNgiXzkXFiQD3+k2fpYPhJOS2r89S/SkAGHaib35ZRDggcgtukDwcmmTNpyaWDQqpzx+JygG7fTD0HtsLMxbe1oDhLJbJdGl9jxB3o6iggtIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RPlJsg17; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RPlJsg17"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF41B1F000FF;
	Sat, 12 Sep 2026 12:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215965;
	bh=1WIFQ/ix6P661H0c22y9XJALlvmMzrVZaydqdS8E+6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RPlJsg17XhFkmV94taWSMGISxG0HZN/RZsXHeooA4/zDc+KyPN5DKDii6hQZ7OgOR
	 qIUTCxplbedbpaXLxbQeuYYqm1CpBhvpcZxmznqsU6tqV6HHV1Oeg/SyEXIvIcq6Vt
	 A4G829JGWEoQxyJ7sz/oH+WnQAzxQ4jeoV3djU4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0639/1376] iommu/qcom: Remove sysfs device on probe failure path
Date: Sat, 12 Sep 2026 08:51:05 +0200
Message-ID: <20260912065621.783785658@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8a76b4f46a325..b3cca55c42184 100644
--- a/drivers/iommu/arm/arm-smmu/qcom_iommu.c
+++ b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
@@ -860,7 +860,7 @@ static int qcom_iommu_device_probe(struct platform_device *pdev)
 	ret = iommu_device_register(&qcom_iommu->iommu, &qcom_iommu_ops, dev);
 	if (ret) {
 		dev_err(dev, "Failed to register iommu\n");
-		goto err_pm_disable;
+		goto err_sysfs_remove;
 	}
 
 	if (qcom_iommu->local_base) {
@@ -871,6 +871,8 @@ static int qcom_iommu_device_probe(struct platform_device *pdev)
 
 	return 0;
 
+err_sysfs_remove:
+	iommu_device_sysfs_remove(&qcom_iommu->iommu);
 err_pm_disable:
 	pm_runtime_disable(dev);
 	return ret;
-- 
2.53.0



