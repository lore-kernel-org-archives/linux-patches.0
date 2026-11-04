Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829663;
	b=21oCZc4RTmBS8N7ZZIDcnfEwDn05kVmYuC3H2StVomXhP9nWcOrp3v5+01UbPeS178CC
	 Bz5YqmmXNof8O+C4VV8MtUDw1khI0+FdqSLVXDzDaoezs7i2vXsphuj3Zdy+eM2fDr8Mr
	 OMl1BUxHEAaK6nhd1bVo//nJnzGBrjuHjZSSiNMj+3THFKmDxAfZhWUDXmCmErNTQQNHb
	 56IL8mOPb4XnwIXfLqi1QLClnyUImYwb0kuLuRCmyJQw35pE/EykgQFte/jyI2AZN8Suw
	 oKlxagB6ZFNuDoVxae8T6KL/gCsZxOP4OFa0wxGZOi8OYp1LAPcbY2zy4uYGjLPpSnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829663;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L+zl1eP3WHnEd3gN+/i+kkYsDY1gUnF6IU6M5S7e57I=;
	b=iZ/w3/aTTtQVmLR52mSCOYghaDchsyRerpXAbqV6T06a2YHIEF145dhzgmi86m+5wdbi
	 cnIUpF632mxxSlK7b4FhUyg8pKkhMR1rQVMcS6QNAtu8JPcd8vrfEI+dj0R8l83O2GKr3
	 yI7iNIQoI31Vi9Hes8m894JPFlc297MDZZjXH+0C8XkXpZYrpuMBc0ZanNhhMWBGP/Pp6
	 Rg03L0aWu2jKZXdkJFqcK9YFyu/5Aa7grgD4FN22x+Cj+muAFMp1z7xCTiGc6yy1d+iol
	 pt246C2pLMe13NxeUTv8nVYddZoLi3MlmcpvImVwofmX9QwcDWRAehocIyGg6DNCtOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XrMzyOOZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE13606BA24;
	Wed,  4 Nov 2026 22:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XrMzyOOZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DD541F000C1;
	Wed,  4 Nov 2026 22:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829663;
	bh=L+zl1eP3WHnEd3gN+/i+kkYsDY1gUnF6IU6M5S7e57I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XrMzyOOZNroSUA9T5iObxfseXgTAZrrmIwTHom1UY971bWsyQOPc5dFTwm84JoOb7
	 pwea8FyyNFq41lZ4XwHIeMFVwb98s5BtCgUB1i4Xk5JHSm3yDFqJV+FxZN+VA/iHos
	 KKtQEuL6TymIeTPh3JuJFPajY3REpmr8cWMTGIGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0226/1005] iommu/qcom: Check pm_runtime_resume_and_get() return in probe
Date: Wed,  4 Nov 2026 15:59:19 -0500
Message-ID: <20261104211050.158599011@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 9bee85259c69e..fbe4bd3ec0c42 100644
--- a/drivers/iommu/arm/arm-smmu/qcom_iommu.c
+++ b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
@@ -863,13 +863,17 @@ static int qcom_iommu_device_probe(struct platform_device *pdev)
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



