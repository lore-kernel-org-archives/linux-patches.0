Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060785;
	b=39hT2jnou2ZAspsBrrnLZu4A4bJGBMVJTsyyeYT6+LZ5uxQkFnWXBT/hbj0DvclUhMN1
	 xYo3s1lkWZOPZ29O+gZxj7kFO5zAA6yXuz9YCgK8qk6rx+gRNQMgPP9jJdw63h8DCucRp
	 nq4/zoyy8yuh++TC8xiGkZzxnsVROtYBrDKgwp4MdhlJJIKGmP7PWTufn/lV2F2taRsdw
	 mq7D0S6JXj/QcW10BTlrBUoCb9IADoSsmO4e6hIQhheWgxOOareNbQ8AQmRiwR26X87g3
	 6uiML63z4YrD529/n9HJiRnI93gRamOepjuGrA1g30mjsa+6PG8QC6/YoDCLHM7JcHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060785;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LawUtFBm1nLfTy9YZkC1icCHTnamaVHIGWRnmvrrjv4=;
	b=EuyLm3tPOW4GXdvD943bG6HhSv1/4jjxhy+GD8Ln0csKRpHQMO6XYomOK2bwtwFMDNmi
	 awOOdVU4TOB55tzirrnav04aE5NFchOeQYwSNYhbPjXBrWxraztobEwe14jdjNBNMU/ma
	 asK1SPk6pg5OjI8oPyu1+J8kKUgpwu87WkPXjM1cyxZDgNzcctP3XS/Ud71KJKbkVUtz5
	 nEu03/5F6idt/ILjj8adnz27qvYwuWipVY8mjTUM3IEZ0VkHv/C8jgnKWZSl2pmcYLkc+
	 sz3MBiKjyVtxGPE9PcldACXtmg4X4QxIiM1wgWnmAE/qAVQNGw7JMkU1GONz9KjWcrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Le71tc8I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB347606A326;
	Sat,  7 Nov 2026 14:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Le71tc8I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81A8A1F0089F;
	Sat,  7 Nov 2026 14:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060784;
	bh=LawUtFBm1nLfTy9YZkC1icCHTnamaVHIGWRnmvrrjv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Le71tc8IdDOdC6//ohxtxkTJWj9M9wWB2jtCR+GkCf72AW8vhMziE8Guixxfu8q8W
	 mBotKQLu2+9939EkEnXdX3XUJeWckyvaC5acPa5jtIfNwdXpkSOQltJipwFYkcacl5
	 GMHXVqfeNc5ulm+V6r8sxZNBTXPpwixWr+Bb2Jqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0190/1536] iommu/qcom: Enable clocks before hardware access in qcom_iommu_ctx_probe()
Date: Sat,  7 Nov 2026 08:36:46 -0500
Message-ID: <20261107135002.997519502@linuxfoundation.org>
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
index 45bfb0f1b4b6a..fff2771958363 100644
--- a/drivers/iommu/arm/arm-smmu/qcom_iommu.c
+++ b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
@@ -705,8 +705,13 @@ static int qcom_iommu_ctx_probe(struct platform_device *pdev)
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



