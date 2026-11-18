Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051207;
	b=eBfoqVYz4ZaUR8BaPRbb6P0goV4abC1v5+p563R+CEAl0NcyPXkck+W3ZRNgM7sBq883
	 O1Zr35EiHUO9vuhasnN3tNoKV3HnEjx6Q6OyJLaCangEUpztrqT8dRxMCLNnuVJSVZg51
	 uPJrlQe1Af2npr5CrJ3Dqm9Ad86vpe+wLOKcavFYj7MqsCEnxfRDwVrGUQJsrGa3UsDur
	 u/8VNDJAwoetQiTVr/WF0fGoICamCSX7ogN2/+CpP99BnAMVodDcBvSsVzkU5I0QLDSUj
	 jtyCkPTh09TapAODmHJjYSQDU5AGWLYQyz0eesk1I6I4Gll+LBPpp6eXnv2Cq/GIA+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051207;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=URIvgAQ0Iu2xJ2Io3f+cfBqcC8gKz00aKTuj0V/3bs8=;
	b=eJ7jNywKhs870rdUK2Qb3F65NxrA7XXujtFAj82KLMGGmIFUwpsGuYHtDXKXzfYqTZYx
	 kuSyf7M1weauw7grK5ZDcci7T0FP3qjiol1AuYMq5s61wlJKdUHRr3zE0PchfGlTqcelv
	 pDA4jUOPC5dpJ67EEheoeagsQzk1x/E9Fn0s/VAm00w54AZ6VtYPGcPwj2PPd8NWvf+8a
	 ivrN7VkSK/EOPEcFQanFRy4oSfqZ1fCQvizdZaZAMWYbnK7YDFaHtq0URPNmkHAywOVpn
	 zmRbmbY/2PvlJoEjay8Gc32mC9hoSiIyDcZaEyuuFL3IMy/yb8yVmauEM5f421/8eoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PPysM3uF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC456606A33B;
	Thu, 19 Nov 2026 01:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PPysM3uF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19D961F000C4;
	Thu, 19 Nov 2026 01:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051207;
	bh=URIvgAQ0Iu2xJ2Io3f+cfBqcC8gKz00aKTuj0V/3bs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PPysM3uFVAqxjIOnEt4+rCIU1rfUhBAmFgKVgkVRr1SutorwYhUnC0QQkKtd0MuVS
	 /f0nYYPmxvqqUzz1wIorHByC65XClxSB/cmhNtuzi5mMEFYi0g1Ff2whB3m4b14JXl
	 cM1C2Y2bHTg3U9NCtYeTf5L56u7Cl46MpliFOrHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0125/2214] iommu/qcom: Check pm_runtime_resume_and_get() return in probe
Date: Wed, 18 Nov 2026 15:30:01 +0100
Message-ID: <20261118150015.196349642@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index cf1408a1b781e..67844abcff027 100644
--- a/drivers/iommu/arm/arm-smmu/qcom_iommu.c
+++ b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
@@ -854,13 +854,17 @@ static int qcom_iommu_device_probe(struct platform_device *pdev)
 	bus_set_iommu(&platform_bus_type, &qcom_iommu_ops);
 
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



