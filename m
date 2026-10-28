Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216803;
	b=C3gPRiF8lsNr5idkTNelYbFmfntNtZt//OcaAcRvG5IGsDaJd8XXqPhaQ5RYTiHwe9/y
	 l/GYQ8DAmrHnGNrTg4bhjmusSr+yXuQymWdqnJtaZPMrOWpi2m3g6Snq41KnYwOBwmSDV
	 FVz+NN4rNSQQHGwy4seGzbV6fXzXL41Vmsq/CD87p8c4hOjrsOArJ3SXliKTjiWsEvQGZ
	 iWYFB2vwoBICXOxQ4+Nh+LD9krpy3N4WibtuEQOt/41R7lVaPFfrNiAxtU1ngJlv4j4xd
	 Uk1WZcJFW9W1/13zV15qMtOUCdhQUWNd1ntevJe1BKC/IoFDjprJPTKrllcUjEl+HoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216803;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U/tbWPAJei/3yUH5qRpKDM21sOlsFTGAyQv9ZFv00lE=;
	b=xMlLPeW4Lh7D5WV28MIDwKcmtp4M87voK1UEn1hrErHB12sCTzTmYufhAMuiwur1e8vs
	 /gMdeD1zht8VQCywAK3/QMugqicyNHgVAW47Rxf+lGbFllWOzw4eJqsBQxxD85kzREzZq
	 gPbPBcdvsmTx4fL0iUXILVLsnOgZwXruip42jh2MhkdE7IZD4XsmH+ce0U82lIz0nvK7g
	 iQ1EzOP2IiXSy5OsEydBcLpz4WV1f54mXEvuqULD6FtTPfnj6Qq7wxmElBABEPcs4HXgT
	 /XJ8R1JAbXDhPpDgvS8MKiVeiwG6mo3Iok72SZQ7UoaTbSDmvd+7hlpNAYC6dFC/cCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eblNsiKZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3605606A31A;
	Wed, 28 Oct 2026 19:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eblNsiKZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04F9C1F01825;
	Wed, 28 Oct 2026 19:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216802;
	bh=U/tbWPAJei/3yUH5qRpKDM21sOlsFTGAyQv9ZFv00lE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eblNsiKZneukdwK9p41+usznZKkOLaTSgS/49EsLQ0VL38mNlkZGyElojE13hC+cN
	 xoVi/MsZoFtBiHZPlSMNSRG8VPkFp3arzGnVZnzKcVinUzfe+auvx2cupaC6qvZVVo
	 r2Z90vkFvwKub6BkuqEBpqFPCwFXe9205uQ/0CuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1647/1887] iommu/arm-smmu-v3: Manage teardown with devm
Date: Wed, 28 Oct 2026 18:02:23 +0100
Message-ID: <20261028170536.944003365@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shameer Kolothum <skolothumtho@nvidia.com>

[ Upstream commit 2bd22a0d40503a65d243b011de146603c8ce1cbc ]

arm_smmu_device_remove() manually frees the IOPF queue, destroys the
vmid_map and disables the device, while the IRQs and queues are devm
managed. devm unwinds only after remove() returns, so the cleanup runs
in the wrong order. The IOPF queue is freed before the event-queue IRQ
whose handler uses it.

Manage all of it with devm so the unwind order is correct. Free the IOPF
queue and vmid_map via devm actions, and disable the device from one
registered after arm_smmu_device_reset().

This is also a prerequisite for fixing a Tegra241 CMDQV CMD_SYNC
use-after-free in the subsequent patch.

Cc: stable@vger.kernel.org
Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Shameer Kolothum <skolothumtho@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 45 ++++++++++++++-------
 1 file changed, 31 insertions(+), 14 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index a4e4849c1c8e5..79d907c57b6b6 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2968,6 +2968,13 @@ static int arm_smmu_cmdq_init(struct arm_smmu_device *smmu)
 	return 0;
 }
 
+static void arm_smmu_free_iopf_action(void *data)
+{
+	struct iopf_queue *queue = data;
+
+	iopf_queue_free(queue);
+}
+
 static int arm_smmu_init_queues(struct arm_smmu_device *smmu)
 {
 	int ret;
@@ -2995,6 +3002,11 @@ static int arm_smmu_init_queues(struct arm_smmu_device *smmu)
 		smmu->evtq.iopf = iopf_queue_alloc(dev_name(smmu->dev));
 		if (!smmu->evtq.iopf)
 			return -ENOMEM;
+		ret = devm_add_action_or_reset(smmu->dev,
+					       arm_smmu_free_iopf_action,
+					       smmu->evtq.iopf);
+		if (ret)
+			return ret;
 	}
 
 	/* priq */
@@ -3317,6 +3329,13 @@ static int arm_smmu_device_disable(struct arm_smmu_device *smmu)
 	return ret;
 }
 
+static void arm_smmu_disable_action(void *data)
+{
+	struct arm_smmu_device *smmu = data;
+
+	arm_smmu_device_disable(smmu);
+}
+
 static int arm_smmu_device_reset(struct arm_smmu_device *smmu, bool bypass)
 {
 	int ret;
@@ -3898,7 +3917,7 @@ static int arm_smmu_device_probe(struct platform_device *pdev)
 	/* Initialise in-memory data structures */
 	ret = arm_smmu_init_structures(smmu);
 	if (ret)
-		goto err_free_iopf;
+		return ret;
 
 	/* Record our private device structure */
 	platform_set_drvdata(pdev, smmu);
@@ -3908,30 +3927,30 @@ static int arm_smmu_device_probe(struct platform_device *pdev)
 
 	/* Reset the device */
 	ret = arm_smmu_device_reset(smmu, bypass);
+	if (ret) {
+		arm_smmu_device_disable(smmu);
+		return ret;
+	}
+
+	/* Register last so it unwinds first, while the CMDQ is still up. */
+	ret = devm_add_action_or_reset(smmu->dev, arm_smmu_disable_action, smmu);
 	if (ret)
-		goto err_disable;
+		return ret;
 
 	/* And we're up. Go go go! */
 	ret = iommu_device_sysfs_add(&smmu->iommu, dev, NULL,
 				     "smmu3.%pa", &ioaddr);
 	if (ret)
-		goto err_disable;
+		return ret;
 
 	ret = iommu_device_register(&smmu->iommu, &arm_smmu_ops, dev);
 	if (ret) {
 		dev_err(dev, "Failed to register iommu\n");
-		goto err_free_sysfs;
+		iommu_device_sysfs_remove(&smmu->iommu);
+		return ret;
 	}
 
 	return 0;
-
-err_free_sysfs:
-	iommu_device_sysfs_remove(&smmu->iommu);
-err_disable:
-	arm_smmu_device_disable(smmu);
-err_free_iopf:
-	iopf_queue_free(smmu->evtq.iopf);
-	return ret;
 }
 
 static int arm_smmu_device_remove(struct platform_device *pdev)
@@ -3940,8 +3959,6 @@ static int arm_smmu_device_remove(struct platform_device *pdev)
 
 	iommu_device_unregister(&smmu->iommu);
 	iommu_device_sysfs_remove(&smmu->iommu);
-	arm_smmu_device_disable(smmu);
-	iopf_queue_free(smmu->evtq.iopf);
 
 	return 0;
 }
-- 
2.53.0



