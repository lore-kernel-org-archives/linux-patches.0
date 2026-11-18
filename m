Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033970;
	b=DrP/yYrgwhC4VJXQH8lhuVBD2j7XWlHXxziEHJYqq/EBXJ09lP3heexcjiK8dXJBOgcz
	 Lg1ctgkXHjj5aAeDnbLNItTc6HQX1rxIFCXssUeKzEMVUy67cZZmW38neEbak0/JsCQ0+
	 wtysR9lNi7ju116K0i5EHR7mL1KVbXKBG5K5/XmMvKwKA5xU+cECOpdNeMCXZT2Pek+vM
	 dAXVYsDc3Qwn5SNFE3ojMNau/uaABB+PnUk9f5UEZX1oZPfesMSnucRMaiDhcY909xcjK
	 AwEW1ZxW6qU8oRYoj9Lj9bKowxVYfcnL2wy06yUFYAP0RpHEmmsQ6Izp8KBLuzdfrHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033970;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Tc7VGjhYJHfjZNlpx6rvTc2ZEPQ7R1rS1AQAeDgXdW0=;
	b=45Y7WHRIiMVXaprRRecbz38DCMUM3RqJ07Va0yaijLhC0+I7Q307VP7iZkze3ztuibsE
	 4QYNshiM96nB65fIOJ6BvBS5gsoyAOXbW0fCDqfAWBLHN/Mnb2KkNGtsikt/k/ftNs81z
	 L9k1CGEy7znJm27zhB9eaMyFIEBWlZoStANvQLiow0uTCS8kqoqRmAN67eFbfJo1+o7Wx
	 Sm7wVkMZBPULiZEdv13l6dZU4Q6auYzfQlKFC+iHXk5Gmo2iBGN0NohnlXOTYpajvM/bM
	 6jVurtf0QDp5Q/sIaO4sBDhqrfXGa7EBwtsTuoUulc+rrFQ8pzTJXw8GjRZg41VVpIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="yGR6/+6i";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD8A0606A31C;
	Wed, 18 Nov 2026 20:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yGR6/+6i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 210231F000C4;
	Wed, 18 Nov 2026 20:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033970;
	bh=Tc7VGjhYJHfjZNlpx6rvTc2ZEPQ7R1rS1AQAeDgXdW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yGR6/+6i9wzjBhmBmTpPs0W6pzPEqLcJ2LRaQHM/Qz584sQSNSI5KIfymSZwPSvRH
	 a4OWv6HP8EDols2eKeX7Z/I7GsGJM00RjOZG0p6Ztpq4+LHX8rWAKCSIpfEStWC+gl
	 xoiqEkU4eMPEFT3q0a+K437ljdagRJVxLU9DRubg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0163/3318] iommu/qcom: Enable clocks before hardware access in qcom_iommu_ctx_probe()
Date: Wed, 18 Nov 2026 15:13:05 +0100
Message-ID: <20261118150319.482505505@linuxfoundation.org>
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

[ Upstream commit cb776a03a53429aa59e25a8cbc3d1a48bd11afdb ]

qcom_iommu_ctx_probe() reads and writes the CB_FSR register to clear any
stale IRQ left by the bootloader. This happens during
devm_of_platform_populate() which is called from the parent device's
probe before any pm_runtime_get(). The parent's clocks (iface, bus, tbu)
are therefore not guaranteed to be on, making the register access
unreliable on rebind or after a suspend cycle.

Use pm_runtime_resume_and_get() on the parent device to ensure clocks
are enabled before the register access, and release the reference
immediately after.

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu/qcom_iommu.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu/qcom_iommu.c b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
index 01a5170d1449b..3de5a7847978d 100644
--- a/drivers/iommu/arm/arm-smmu/qcom_iommu.c
+++ b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
@@ -677,8 +677,13 @@ static int qcom_iommu_ctx_probe(struct platform_device *pdev)
 	/* clear IRQs before registering fault handler, just in case the
 	 * boot-loader left us a surprise:
 	 */
-	if (!ctx->secured_ctx)
+	if (!ctx->secured_ctx) {
+		ret = pm_runtime_resume_and_get(dev->parent);
+		if (ret)
+			return ret;
 		iommu_writel(ctx, ARM_SMMU_CB_FSR, iommu_readl(ctx, ARM_SMMU_CB_FSR));
+		pm_runtime_put_sync(dev->parent);
+	}
 
 	ret = devm_request_irq(dev, irq,
 			       qcom_iommu_fault,
-- 
2.53.0



