Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829598;
	b=Hku0As/7tXdvDWIL7tUJfuK75KLXDi1xSaPu0kw14THOFdGC0Zvo3Bk45mqUJQg2ohSk
	 7B0Durvzl2VN/QVa5UuMDrtryi3ASqPpm2iDQylIrTSbeB4BKzmnE0S8XQ8zn2y9MLFTc
	 o5vsfmc++CZfHJHTQqAhTlIJ/rJGftH+787fKIjm0LJ4Lm/zPWs8GT8Opb3l6LRk6Mpub
	 rQL42KNoTi1H+pDUk/qjMFHkmr7lJbDPCg7m732+vozDLWdk5kgGAnQb1EV3hHuYhkD2b
	 aUp86++O/Qoj41Sk/ofMsQ1JHVZkK6sqcObCEdRXxI6M7N7waoUUoJW6UPJ9o5jZ1xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829598;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bschZ0puM7J7741sGXGlWSI/28seGSW9I3l970RuAtw=;
	b=rJlOAUX0C7aotFDlIdjvQ3lql/oc/2Lb3bQeG8YvzF/RmTG6wExQvxSMj3teT6zPPKu0
	 bb96PmWBwDn+KMSgBdavdGoppL1Qufob5Pf6+qqDg2k/5MohzI40uYHXmg20CVnkRxTOF
	 1Nfo5Fr91oFgxzgSVR2uansUU+8YVsD8vGwzG7p1zFZP9ARmS8lqsrdlkOVrUxVLkXL4M
	 jsnN5xjJRpNUB3UIER5YxEi836KjApBHqDJgh2iEE/lquB1/8mv2O3uWC008FxUCO8iow
	 IJ6HC6b/PoUSwsRV35BST3urbtoX3cu1CA8Oq6nLaD9Chzh5GITtY3mw5qiv4QKCsrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pogr+b2k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 021E9606B2D2;
	Wed,  4 Nov 2026 21:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pogr+b2k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 904951F00A02;
	Wed,  4 Nov 2026 21:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829597;
	bh=bschZ0puM7J7741sGXGlWSI/28seGSW9I3l970RuAtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pogr+b2kMd9pXPhtxRrB0/chx4oZT/Egw3sPWozLIVzqVqIP2KOU84a0ifOb/9m8t
	 7KKXJIj4B1OGHN+DQPTMU83nZdRVCGSrqm7/8rn6txfP1EB89nn+frjmUjmqaBImB4
	 zlueTLw8hPs10VjiWW2sXiknzXap4eHTZ89oEQgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0227/1005] iommu/qcom: Enable clocks before hardware access in qcom_iommu_ctx_probe()
Date: Wed,  4 Nov 2026 15:59:20 -0500
Message-ID: <20261104211050.191797494@linuxfoundation.org>
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
index fbe4bd3ec0c42..792585321bd11 100644
--- a/drivers/iommu/arm/arm-smmu/qcom_iommu.c
+++ b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
@@ -704,8 +704,13 @@ static int qcom_iommu_ctx_probe(struct platform_device *pdev)
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



