Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033957;
	b=ijbQO/49Qhk9LKhiuHUVeMR1p9v8nZbf0r3xeY2hav1jEHAlfpmanborBeCZI4kT4gUj
	 u4ySfXPQ9D5FPC53mdj8cADtRxjXTJ03iK82LSl5y0ibHV8uK5e2VOuH+MqGsJtIzWRmO
	 H4mlUi5YQ65bLvd2EJJcrjpq4Q0ZLlMiYrJmPo+Y+/GVjoUXJqn0jIIYIqMQZUfwwAWiO
	 u/1z9YclnBGI6853t6HeviAM7h9C0AOHHWPDRsakuM/bhOPF+dERN1nP74hVz/AtVc4eP
	 6PjQz1btCqonGX9WLtr1o1d1E7xzGgfO2ykd6rsRrS5pYVmcHjro+Ci4A76qgg2zXlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033957;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nbHPe7sxZs+f+FSqpVfP1NOQ5uJqcf3Ar84siz5zsTw=;
	b=mtlGLK8+/8+BqcFS+MIbN8ZrXFagKQLTzyWbQMKQf+FCjOdSn3pBynTtRGbtRpdBaqfe
	 0koqOcmrj/yuP+AElmRXidm5kkABbjHPhSwhOvmkshHjj22HzOSgiVmJJMyldfCFgB2L0
	 P7qpx4OlJbMm3QXRzi0Fsg5jgQQo5D22ayOjC7Cj+Or/+8Oct+0gh0WDa0DpRm7ecaDE6
	 CiRqKx4nJ9rkQO1m5isS38CpFLDUPJWo0I1jRTksyr8NryjcO/MwpVzsm1UCYgr5I2UjU
	 HBf4FZvCHf1uqQVahKsIJ6L+G2oc3qW5rWg8fKvuvdrCwzD17tTT56ZyAWRPvnMNGQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0TCf5BJp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FEFD60A2605;
	Wed, 18 Nov 2026 20:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0TCf5BJp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F0C31F000CA;
	Wed, 18 Nov 2026 20:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033957;
	bh=nbHPe7sxZs+f+FSqpVfP1NOQ5uJqcf3Ar84siz5zsTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0TCf5BJpn7NKA3lmkdbQIVgd2f6HCNwWsjTvkpGRv6MgPb0+2s+9qjw1P0AwfhJ8w
	 ndHP3r1b19AVPo+5/XGfzdWBVFXxq//K/Q4xtOehSyMHdDiOCGqRZD2tv1ZvYKHHN9
	 /W149JewsBXKS2Mg/+3qtO+txlJ0YTlsrRFukgu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0162/3318] iommu/qcom: Check pm_runtime_resume_and_get() return in probe
Date: Wed, 18 Nov 2026 15:13:04 +0100
Message-ID: <20261118150319.445374376@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>

[ Upstream commit e910315ae08a23bc953daed10b1c518abac1df49 ]

The SMMU_INTR_SEL_NS register write in qcom_iommu_device_probe() uses
pm_runtime_get_sync() without checking the return value. If runtime
resume fails the subsequent writel_relaxed() would access hardware with
clocks potentially disabled.

Switch to pm_runtime_resume_and_get() which handles the usage-count
cleanup on failure, check the return value, and unwind the already
registered iommu device on error.

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu/qcom_iommu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu/qcom_iommu.c b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
index e134c877c16e2..01a5170d1449b 100644
--- a/drivers/iommu/arm/arm-smmu/qcom_iommu.c
+++ b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
@@ -836,13 +836,17 @@ static int qcom_iommu_device_probe(struct platform_device *pdev)
 	}
 
 	if (qcom_iommu->local_base) {
-		pm_runtime_get_sync(dev);
+		ret = pm_runtime_resume_and_get(dev);
+		if (ret)
+			goto err_iommu_unregister;
 		writel_relaxed(0xffffffff, qcom_iommu->local_base + SMMU_INTR_SEL_NS);
 		pm_runtime_put_sync(dev);
 	}
 
 	return 0;
 
+err_iommu_unregister:
+	iommu_device_unregister(&qcom_iommu->iommu);
 err_sysfs_remove:
 	iommu_device_sysfs_remove(&qcom_iommu->iommu);
 err_pm_disable:
-- 
2.53.0



