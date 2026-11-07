Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060783;
	b=vrnIlGcazYdaGj9r88B1KlhnPjsvDrnfv0ZulnCRHXHga6Yj2Q6rdyd/Sm8+A51Kl3+T
	 GbvFPuY3S3q0oR42U2LxFsJdMWApBT84pKm8Sb+6s40LIBca7tmCfifCt/FIbtmsrf2c1
	 1ADkRtZ2/FlBKpLC1bBB7uSDGbBtMWlxJ0z9IUvShIPJNDtOuoAlSrx7QtPBxM4SwCkWm
	 NppqXj5p/x7kVxQK6FTLwxkTTVpOxUTrnVHVFlNsY6e/B1t+YLlj3uaLvAgz2kX59xjcD
	 7+OZSu2zS4sLzfzuWCFOudx/xj1FnJgI8RnHxtCJ6tNPK62feyubk1Wb7e3FL3lD2zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060783;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r5dJcr+bytVoYEDiicrx+XxdjN2ELRJZWSxai4+h4DA=;
	b=I39JPEXHLQNEjBGKtyIyiOi1FFui15kDHw3BU5P33VAtjMtVC+GWjo3GHXQhzuv2qYW+
	 NrRLhdEGN5rCVyYMslWkPEbxy5CONCmtQhf7GiSPNXvXEaRlwFWE8/LGa/LHQYE0v68U1
	 x3Xiaxg078JcAwyM3Er1tfQ12WfMidJy73K9wBQqNxLoPmI2EJIoM6x4kk3wkGXK+czu9
	 +5/yHTqf2Sxnfhl+IEwZYSS+1qe98Qv4wxPBLQrnpTO8tNDJFHsL+dvpHMpBdJOsdXSlQ
	 mWjfv72/APDXgWGHiz0mkkmJRgZKgLyrLGGbw/Iqi2lthXa9D2dnTh89/OVymgDm/5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=POGJnyui;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D26B606A326;
	Sat,  7 Nov 2026 14:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=POGJnyui
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A70A1F0089F;
	Sat,  7 Nov 2026 14:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060783;
	bh=r5dJcr+bytVoYEDiicrx+XxdjN2ELRJZWSxai4+h4DA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=POGJnyuixZLJJdu0coMWizXi/5MFaOBgDcjXEs8WT76IgA7eQAmFvt1QKvzraoF+B
	 Vhc6jO00ayKwjyLXTGo62kxy9CPvXPymUi80C/K3bape/ff6IPrj36C64THUQlkBGc
	 tRLxPYPFTdKecYldVH9v2LOsfJH8E33WdlbdNwXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0189/1536] iommu/qcom: Check pm_runtime_resume_and_get() return in probe
Date: Sat,  7 Nov 2026 08:36:45 -0500
Message-ID: <20261107135002.970312373@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 09d847666a68e..45bfb0f1b4b6a 100644
--- a/drivers/iommu/arm/arm-smmu/qcom_iommu.c
+++ b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
@@ -864,13 +864,17 @@ static int qcom_iommu_device_probe(struct platform_device *pdev)
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



