Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215930;
	b=YRtMpG6EWsfKEYMBYyZTGMGB8Yo8DXN3dVq4TQUJaUC3sggMkDJAmsXFIhjv88AUpE4t
	 tdia/VYB6Bajg1JnrPpmzw4UnoYXLiq7fAVZYpYsBrW/K1zweGNnTBSRPvweiWflaJBim
	 axQIkv51QIotDIraJ73raS8rIlw63XRc8GE7KIMyjVWrCmr1GQ8bn+nhm9DocrtrVLWCe
	 oq7BcOvUnpIzwOJceNWiHbxraGP0XIRFZL+SN1ddYKLdQSRsj/VpHnrSDt7etYivxHhS3
	 tn02ZH8/DkASbv/dqGjUyIBqbAbUzg5WymgiNRsdjYG+57QneoZiP5BdPE/3VIIh/Xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215930;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jps8vIbGiHNeICA3m8eXXZak6QIjcfilsIcWhzJZ04c=;
	b=HRgkt4KAnDRiB1tsCcVUAXRs5GHgXAalhRND22pCmG6Vx6aDr6D06JJ2K9OjzFSuq4UI
	 1Hm7SYeYsXPf9qt0WbwsgSF5iXVM+wCjDjdEC3vBRgT5WiOECFNRctAWriPnxNeB0rfS2
	 9xOjaNf4yTb7xjGVeKjZOhPLcS4HZp5W1waJSxb0cTr9xsDK8qbxy+9Qob2cjz0jD4vdP
	 L5XEnpGXvnGWxZwiNWi9P4kEpBOrf23TlAWP6FEav0CZIZ8XlLwkxIqm2jMLjZCICQbX2
	 HyaIn/3iPvkdJmKc4/EtXiG+MPFLo1bwmnwrCUBavH05MFgz6GPrwWhRUhqXpnN8l2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="yGWnCj/Z";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A269D606A31E;
	Wed, 28 Oct 2026 19:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yGWnCj/Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 000511F01825;
	Wed, 28 Oct 2026 19:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215930;
	bh=jps8vIbGiHNeICA3m8eXXZak6QIjcfilsIcWhzJZ04c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yGWnCj/ZRXaZE6tD0GYMcjSujtSZRzAyncBR6ldkxIlTFo8nVgrxKssKi4E9lueFx
	 pshkBBSbLPpfag0sNJIz5DA/sdeLTGgalpW26aCqVZwLytb4aCQFqUBBSsNt2d3dzA
	 5/EU+n4ZS6awr4peo1EEn1AeQvlqi+HDPZ3ZNnCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Weimin Xiong <xiongwm2026@163.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1383/1887] iommu/msm: Unwind probe state on registration failure
Date: Wed, 28 Oct 2026 17:57:59 +0100
Message-ID: <20261028170530.917792865@linuxfoundation.org>
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

From: Weimin Xiong <xiongwm2026@163.com>

[ Upstream commit 535a200220ca2c83bc8bf54bd2cbe045d6ee70c4 ]

msm_iommu_probe() adds its devm-managed IOMMU object to
qcom_iommu_devices before adding the IOMMU sysfs device and registering
it with the IOMMU core.

If iommu_device_sysfs_add() fails, probe returns with the object still on
qcom_iommu_devices. The driver core then releases the devm allocation,
leaving a dangling list entry that later list walks may dereference.

If iommu_device_register() fails, the same dangling list entry remains
and the sysfs device is left registered as well.

Unwind the sysfs device and global list entry in reverse setup order on
the corresponding failure paths.

Fixes: 42df43b36163 ("iommu/msm: Make use of iommu_device_register interface")
Cc: stable@vger.kernel.org
Reviewed-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Signed-off-by: Weimin Xiong <xiongwm2026@163.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/msm_iommu.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/msm_iommu.c b/drivers/iommu/msm_iommu.c
index 256ac3617d701..3d86c9d2c3d1b 100644
--- a/drivers/iommu/msm_iommu.c
+++ b/drivers/iommu/msm_iommu.c
@@ -783,19 +783,24 @@ static int msm_iommu_probe(struct platform_device *pdev)
 				     "msm-smmu.%pa", &ioaddr);
 	if (ret) {
 		pr_err("Could not add msm-smmu at %pa to sysfs\n", &ioaddr);
-		goto fail;
+		goto err_remove_list;
 	}
 
 	ret = iommu_device_register(&iommu->iommu, &msm_iommu_ops, &pdev->dev);
 	if (ret) {
 		pr_err("Could not register msm-smmu at %pa\n", &ioaddr);
-		goto fail;
+		goto err_remove_sysfs;
 	}
 
 	pr_info("device mapped at %p, irq %d with %d ctx banks\n",
 		iommu->base, iommu->irq, iommu->ncb);
 
 	return ret;
+
+err_remove_sysfs:
+	iommu_device_sysfs_remove(&iommu->iommu);
+err_remove_list:
+	list_del(&iommu->dev_node);
 fail:
 	clk_unprepare(iommu->clk);
 	clk_unprepare(iommu->pclk);
-- 
2.53.0



