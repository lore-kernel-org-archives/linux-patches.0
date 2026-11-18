Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057374;
	b=OsEIzpME0aj+fktVYif1Ud2VWx/0zDvUCWlwWyaR7mcPPhrQxqKrwVms54tI7nSg0jAR
	 gpSZWC3cqDJaE3mbKWPIrwPhRjVL7qW20CVl1fx0nsIwUJ9gcyRNII8PNXVjMOCvO+nQc
	 hliMSQx9wn2azOo0ToltDM++MUvnUZxUWg/MehS2i29Bhk3Qxi9xfDhXR9Su4LDAl7QTg
	 ZbZF3HdyfsGYMBYs1XIM64ZYUmQ18TjFMhX3CbmGlDXqPCMZ9A9pcGGe9xrL+tyBdGiUJ
	 fS0eQWr8Y+G544wjpacBQwkB594xeSciQEiJVTTuTqi8RiXl7vp7JA3oRr6CsLkZuJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057374;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hF4h8urGYHyhdoRyL2VI/iC/udu8jKhvkfG3J7XvhKk=;
	b=sDNUAuGyHdUkglHI7Ph+vwVBXWZoB+W3cbwg3LUmItYQrjnSASMrr+GK19XOOroTz/Wn
	 dxrrKHNtQw4x/69ipKTjDzPcpW4n6adXVGwIESaszti4Zd3D9fXyuzClQiHZHEy9VNkUj
	 gY9oT6kEyUlr5fxn+tT1wV8Pn15lYT+HEQg+QyJ/5h8EoulmNsSpMvfSWMEtyjznmHulo
	 2F+W0Sz94I2iYuJ9qpr27gPxeS751B8gj36J2EizZUjtO1kEu5vZ/8p+SJivhdg85ko4K
	 6H+VRjruIDNf9W8ZJUg5y6IX7Aw92g7LK/BLqCvhNu/Ay7CdOlXu6QGXPA7IX8RJPzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lFroV04p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D969F606A33D;
	Thu, 19 Nov 2026 03:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lFroV04p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E612D1F000C4;
	Thu, 19 Nov 2026 03:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057374;
	bh=hF4h8urGYHyhdoRyL2VI/iC/udu8jKhvkfG3J7XvhKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lFroV04pVq3xR4Mg1/SeTDI1hlZsBf1mdQ14amjJbXAXj9rkAfY3Ou8gM6rIbmaQo
	 CranXwkoTA+2i/1o8/0l6BnWry3KxeGIIrGdp7Ail9WKer17pXAg/eZkHGMl5bmu8e
	 Jvs4kKLSihCCDAUzkR8Qj4IDlQKOGqLVS2SBLOaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0109/1848] iommu/qcom: Check pm_runtime_resume_and_get() return in probe
Date: Wed, 18 Nov 2026 15:35:47 +0100
Message-ID: <20261118145915.594140615@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f59b53805dd03..cfcebc87a978e 100644
--- a/drivers/iommu/arm/arm-smmu/qcom_iommu.c
+++ b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
@@ -875,13 +875,17 @@ static int qcom_iommu_device_probe(struct platform_device *pdev)
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



