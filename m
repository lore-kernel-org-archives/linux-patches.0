Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794817199;
	b=WPIvy8KSN+aslo/lZ4lGM/5seXWi+4f5Ws+2/vc6ZyAk/YIdvp/A8uDJydjcunpQbMIU
	 ypdQzHTHZ4tnBW97HV+bkyyvmROp3TfJQK55P1IOr1WLykYdpSu3+8udXjt8lOtqOBaqJ
	 eGb4I74KI/ElAbM3vjYVeCiCCyqEbpseIXS5UvDQ+1fYFOZ/4j+ukPWWV1d4EAktTWMBk
	 GkpUDgKMTqYAEfsbkehsvo7+zsdyDSKl0zDQ0SZzIc1hUDiWKEClU4LmqgA5qPUoLF2Fz
	 w6yW1Nm5qY71S8JFj48BiuUg8JFgMZzg0gM2eywPoL1CK433tvuTV14mynx1HQXifZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794817199;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=+H3fJiooJtrobZUq5IZDuY+VD7wcPaQFZL3FGcl9WNQ=;
	b=biuo3xNjElcSa+qfuB4v9rodYCDQoYN1PVqevtcKTLHS3d6X1JPUNUQLKlFsBTe3DwSQ
	 ZTMDiVosthf5E1oawYfMYD0lyCbdB+OkS7cjnjHDXV+mrdxHn8CYTf298Ms9FBbCVEY05
	 NyH9RCLAujZLj/xwPl1TdhiUbYqHoSc9M/5LriTGbssfqj2PlVOWrMoEKEqrQry6ZuSt1
	 I4PeO435P2CxooICwvX71OfcQJerQ/F2oOozLAjInsAyZX15HmCLaZyk3J/jqNAiiivmJ
	 tlNmrZk0v8JSoHNMr1ZG5mducY8nhYuyyv49vFXSV2NMn27iKzyyWVznl0vLIlCvfJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I6wSP717;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2C09606A31C;
	Mon, 16 Nov 2026 08:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I6wSP717
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 857AA1F000C8;
	Mon, 16 Nov 2026 08:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794817199;
	bh=+H3fJiooJtrobZUq5IZDuY+VD7wcPaQFZL3FGcl9WNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I6wSP717X3bwqEfjDHEj38tLmak34ZyAjweXUkG+7V3JdQM4WvzLG+jdjSD+pP6Vu
	 1JSz5JIFC6n3p+gp5Ix5h6+ajzwP/vcwC+EVsjmUztjcXOq5tD9mfEjAivTRxXiP0H
	 bP6n+Lg1VvhtjaurVz4YgY3IEzjdfjwqTVSwICap3grdw75PWYYN0CAmfblmlU+f7t
	 q4H0FQUl5gRVjLnjKxDKy0x6Lt8iurgyefNTa/y9DHyuuAPn9FV6WRCLBK2ZETuKHx
	 hzYi5mxqAasF5aR6qp7U1XyshSkBdy91qwhBRRyZuBkQVLcRH3gn02qE2u79QU1/Fv
	 l4nF/OuBZG/uQ==
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
	iommu@lists.linux.dev,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-pci@vger.kernel.org,
	linux-tegra@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH v9 01/13] virt: coco: tsm: Require PCI operations when registering a TSM
Date: Mon, 16 Nov 2026 13:49:23 +0530
Message-ID: <20261116081935.85372-2-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261116081935.85372-1-aneesh.kumar@kernel.org>
References: <20261116081935.85372-1-aneesh.kumar@kernel.org>
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
then has PCI operations, so registration no longer needs separate paths
for TSMs without them.

Cc: Alexey Kardashevskiy <aik@amd.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Lukas Wunner <lukas@wunner.de>
Cc: linux-coco@lists.linux.dev
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/virt/coco/tsm-core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/virt/coco/tsm-core.c b/drivers/virt/coco/tsm-core.c
index e784993353d8..03894c5663f1 100644
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
 
-- 
2.43.0

