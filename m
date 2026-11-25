Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795594328;
	b=eJbRsSOftulZpVxgdcokdtEj4KoOf3fFC9F18JkRn4Ng1Jccp3r0isvOlFw13C+dgBfQ
	 m19V1A6hVq/lscj6jCOIrg3HT+E8Za/4GeUwZJ+x4HRnkLTvipyRBH6rc8CNnK0l+eDKj
	 40JvOqadGbjc7BLpahHgVXbLmy0gvIBvEnLO68q0lZxFfClLr3CQh+70ZmpfWIyYxkSXT
	 y9pgAtjL7yuhgtEggEUYFfb+XVxKumH1aeMzyC0GtCsPnTZuwmH6vjQO21xJzXYI3Z8NV
	 9xFzeDqh2ZpPJHEaVdAh+ycvfKtD2bGfpgFY58NAYMwXizfFch2F0VuCfmHoAZXEZcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795594328;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=YbCmxHPge1v033HBbYUhrVZG7+3rPvU34p4BuHnhXsE=;
	b=5h3f17vs0Zy6TSBP97M4sZx/tUuyWL/I47lD8wncZCehiC88MpeoYIQMcRP4wslJwPjE
	 HTnbnTyp3PrQg0GVd+bHudCtx1HwHNY0iqwVWVXUNACHKm/Q/CbNLkUQoLTpiv7eutTw+
	 eZtdW8qu6sqDbc3aGT6mF70OKOYXGnXDzJEWxqL3J5XqRXcOwFM06d6opei4bTYtvSqB8
	 hRMeHXAfpmqYItwt49huTlVLP3st1iqG5RMirF874l/9Swl8hbAkTzWPU9zZlQOjSHWht
	 RKbsQOgwj0WZ4SbBzCPhDda50kEutGaeqezAsVTGXEQ4rPMY6uv/xuXBKkH7t9kCOjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P1hDBWYJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5E3606A31E;
	Wed, 25 Nov 2026 08:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P1hDBWYJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36BA31F000ED;
	Wed, 25 Nov 2026 08:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795594327;
	bh=YbCmxHPge1v033HBbYUhrVZG7+3rPvU34p4BuHnhXsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P1hDBWYJjzdO/BB3ddceENWCti/bghbH0NFSeYxuoTkkNtXjXA883BMDQ7NBYnjVm
	 QW1zQXTPvo905aaiJ9Feg8IxMuOOI8wCm78cFE8LPLL3mFApl6QqyOzOC688OApKko
	 hMxr16C9jF1dqeuyWosFSRxjR9zmuLZFZl+TAxLAqYnUyDtfjHQ28lEEpzaBKDsaEW
	 cjwlyve0t8JVHEWnoI0paCPoEwe3Y2YAC+mubZ7rTyj/4yXVXXhLQGtAuVm6S2kRYk
	 dKmRngw37u1AxovS2JQSCN5qpYVIPMtcys9b/b+HBDvpjRJTcXq/qdmcl5FR8XeIge
	 KhGV3oJMIz+vg==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Alex Williamson <alex@shazbot.org>,
	Alexey Kardashevskiy <aik@amd.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Joerg Roedel <joro@8bytes.org>,
	Jonathan Cameron <jic23@kernel.org>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Krishna Reddy <vdumpa@nvidia.com>,
	Lukas Wunner <lukas@wunner.de>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Samuel Ortiz <sameo@rivosinc.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Steven Price <steven.price@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Will Deacon <will@kernel.org>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	kvm@vger.kernel.org,
	iommu@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-pci@vger.kernel.org,
	linux-tegra@vger.kernel.org,
	patches@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v10 02/18] virt: coco: tsm: Require PCI operations when registering a TSM
Date: Wed, 25 Nov 2026 13:41:05 +0530
Message-ID: <20261125081121.379481-3-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261125081121.379481-1-aneesh.kumar@kernel.org>
References: <20261125081121.379481-1-aneesh.kumar@kernel.org>
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

Reject a NULL pci_ops argument in tsm_register(). Every registered TSM
now has PCI operations, so registration no longer needs separate paths
for TSMs without them.

Registration guarantees pci_ops is set, so call pci_tsm_unregister()
without testing that pointer again.

Cc: Alexey Kardashevskiy <aik@amd.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Lukas Wunner <lukas@wunner.de>
Cc: linux-coco@lists.linux.dev
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/virt/coco/tsm-core.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/virt/coco/tsm-core.c b/drivers/virt/coco/tsm-core.c
index e784993353d8..3e45b58183e2 100644
--- a/drivers/virt/coco/tsm-core.c
+++ b/drivers/virt/coco/tsm-core.c
@@ -61,9 +61,6 @@ static struct tsm_dev *tsm_register_pci_or_reset(struct tsm_dev *tsm_dev,
 {
 	int rc;
 
-	if (!pci_ops)
-		return tsm_dev;
-
 	tsm_dev->pci_ops = pci_ops;
 	rc = pci_tsm_register(tsm_dev);
 	if (rc) {
@@ -84,6 +81,9 @@ struct tsm_dev *tsm_register(struct device *parent, struct pci_tsm_ops *pci_ops)
 	struct device *dev;
 	int rc;
 
+	if (!pci_ops)
+		return ERR_PTR(-EINVAL);
+
 	if (IS_ERR(tsm_dev))
 		return tsm_dev;
 
@@ -102,8 +102,7 @@ EXPORT_SYMBOL_GPL(tsm_register);
 
 void tsm_unregister(struct tsm_dev *tsm_dev)
 {
-	if (tsm_dev->pci_ops)
-		pci_tsm_unregister(tsm_dev);
+	pci_tsm_unregister(tsm_dev);
 	device_unregister(&tsm_dev->dev);
 }
 EXPORT_SYMBOL_GPL(tsm_unregister);
-- 
2.43.0

