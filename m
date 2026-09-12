Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D832B41E6DB;
	Sat, 12 Sep 2026 10:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207984; cv=none; b=S3JFyAR5kudOlub4xW2jAHgRp7m3XG925Ryu/gU4f7SMuXI5OSrFQcwkKJ6pQGvpDLW6h9XvNQ5C1Ngie7JtLU3daFuBnRz9kCM7i0eNJSJggROVXp/OxP5d7Mw0sJRG4PMmiwZf0i/PnIWJ8UMp9YvPcGOPcBg0acY42c8TDLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207984; c=relaxed/simple;
	bh=Tl23Y8mnV/5oSnj9atrsrmP7RvL9SiJUgQCMdiM+DVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hsF1as5s/b/SJ+Sp450TnSco6IiFrPpKEWYWsc05kdCRJxaKz7M7TutWMW+SwdzUmGiGMUgl5Fw8kM3GmCW/xveVkoA4VElldn2H8zphz5DBqZqwVNhrp781+5BnxOjb5RQLuNQQ/w3pXTjvXZsZWREZ1r18NfC1e8nNP5rWyq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hZjA2IYV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hZjA2IYV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 545641F000FF;
	Sat, 12 Sep 2026 10:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207980;
	bh=vC3OZxL/2mf0EdcGhsk39KLbkJyscqpjvf4KUgTcqo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hZjA2IYVGl4Ub62MSnSVsZByS/+nbqHkHQUKEYNGFrMZOcr1CwiOPEohKgXoJcqhh
	 uxSx+5Tdaxw7CM0Emh+Qfgniem+vUgs+Wpcx0LPAIAkD9ovDznmH35/Zo05DVzT3PP
	 5vpA7uNkv+hcXa+5r+R0zzbx4roIsCQARzjmT+CQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0524/1518] iommu/qcom: Remove sysfs device on probe failure path
Date: Sat, 12 Sep 2026 08:44:53 +0200
Message-ID: <20260912065635.300609089@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 9c1166a3af6c9..0a1255cacdb06 100644
--- a/drivers/iommu/arm/arm-smmu/qcom_iommu.c
+++ b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
@@ -858,7 +858,7 @@ static int qcom_iommu_device_probe(struct platform_device *pdev)
 	ret = iommu_device_register(&qcom_iommu->iommu, &qcom_iommu_ops, dev);
 	if (ret) {
 		dev_err(dev, "Failed to register iommu\n");
-		goto err_pm_disable;
+		goto err_sysfs_remove;
 	}
 
 	if (qcom_iommu->local_base) {
@@ -869,6 +869,8 @@ static int qcom_iommu_device_probe(struct platform_device *pdev)
 
 	return 0;
 
+err_sysfs_remove:
+	iommu_device_sysfs_remove(&qcom_iommu->iommu);
 err_pm_disable:
 	pm_runtime_disable(dev);
 	return ret;
-- 
2.53.0



