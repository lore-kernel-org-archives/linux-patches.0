Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC79D18C028;
	Thu, 14 Nov 2024 17:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731606165; cv=none; b=HAQpB+il5OPSTo7St/M/GPW/LG9vJxvXKlHjaZEm4dTnHPBbybkpHl14JBvgLSWF9GBH/1Xktd8JJjgitWvrXXIBWD2Wgusk08PBZuSjiQguIucXmn1ocMQAbEg9vBhgOvjGt+GKkUqmMV7/PbBzlUSCmvMV/wqpn3X1eYTBE7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731606165; c=relaxed/simple;
	bh=9i/rD6KyjgnD4YtBXzh1hFhiRin+Kv8Syn9HvXmZ8+4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=QX7HJVTNdPvt1Wx7tsBXLoQpNvYSUjiEnwuKZPZ6UZRL5B2OlKb9bNeW7kQYUhJNa8aHUe/9ckNGkkHDMStIDNbsbqerd9s+oLU2D3G6mZSsY563JldWEN8AtIaj3F3jYzG1XCTbVniRBGM/71z6gDap199zkpxDphhHKFpe18U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F0IKid9b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F0IKid9b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3C09C4CECD;
	Thu, 14 Nov 2024 17:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731606165;
	bh=9i/rD6KyjgnD4YtBXzh1hFhiRin+Kv8Syn9HvXmZ8+4=;
	h=From:Date:Subject:To:Cc:From;
	b=F0IKid9b0r9yq0gsNzwJStnDQPVpLDz0ENj+poqsJpDsAv6m/YQR0WTR85gNRHj2V
	 jBRzJKznpg7+BmvJffWpwlSFqpYAzjb++/V6fzjOBO7/W6/OHPsKqxtcm4gjM5xte6
	 wyuAVF206wWhLzbjNrKbReYntMRXBNiwiYbTOzKpQVWa9AxkMpf6Q6NXcus3QSuZ+A
	 XhZTXCgTHiiMX2zKc0u5iddepUKaPAqnrsq0t7Qt1G6419A1OIT+gUPLD+Bw6UYPSm
	 jGsDIlnvMlaBbhZdS7fdRQu+7z1/TCIWGUpvAJ8zXqRLmMbcoMRRDlmatP31S8gcbg
	 ZrLtOQ98RciOg==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 14 Nov 2024 10:42:29 -0700
Subject: [PATCH] iommu/arm-smmu-v3: Import IOMMUFD module namespace
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241114-arm-smmu-v3-import-iommufd-module-ns-v1-1-c551e7b972e9@kernel.org>
X-B4-Tracking: v=1; b=H4sIAIQ2NmcC/x3NQQrCQAxA0auUrA2YcVTwKuKiNBkNmJmS2CKU3
 t3B5dv8v0GIqwTchg1cVg1ttYMOA0yvsT4FlbshHVMmooyjG4bZgusJ1ebmH9TWXRit8fIWrIG
 ZUyrMVK6XM/TU7FL0+9/cH/v+A6POpjl2AAAA
X-Change-ID: 20241114-arm-smmu-v3-import-iommufd-module-ns-4d22fdd1f765
To: Jason Gunthorpe <jgg@ziepe.ca>, Will Deacon <will@kernel.org>, 
 Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>
Cc: Nicolin Chen <nicolinc@nvidia.com>, 
 linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1564; i=nathan@kernel.org;
 h=from:subject:message-id; bh=9i/rD6KyjgnD4YtBXzh1hFhiRin+Kv8Syn9HvXmZ8+4=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDOlmZlOS6joeGd06s72Dp2xWnejDWSK7mGN6tttc6Fe9l
 pjfsuBhRykLgxgXg6yYIkv1Y9XjhoZzzjLeODUJZg4rE8gQBi5OAZhI9D2Gf4q86sq5GRWLrouU
 B558esvJWPH/kTbz+49U/23SWeuYls3wz9hRLbNtQz+z0qprfCcsGA6d1pm/e9/CZ9V/z7Z96z4
 mzAoA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Commit 69d9b312f38a ("iommu/arm-smmu-v3: Support IOMMU_VIOMMU_ALLOC")
started using _iommufd_object_alloc() without importing the IOMMUFD
module namespace, resulting in a modpost warning:

  WARNING: modpost: module arm_smmu_v3 uses symbol _iommufd_object_alloc from namespace IOMMUFD, but does not import it.

Commit d68beb276ba2 ("iommu/arm-smmu-v3: Support IOMMU_HWPT_INVALIDATE
using a VIOMMU object") added another warning by using
iommufd_viommu_find_dev():

  WARNING: modpost: module arm_smmu_v3 uses symbol iommufd_viommu_find_dev from namespace IOMMUFD, but does not import it.

Import the IOMMUFD module namespace to resolve the warnings.

Fixes: 69d9b312f38a ("iommu/arm-smmu-v3: Support IOMMU_VIOMMU_ALLOC")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
index c96cab6521a468d49a4c25566d08ea756211d545..6cc14d82399fa2666bd5374bb7d565171f6ce7ac 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
@@ -397,3 +397,5 @@ struct iommufd_viommu *arm_vsmmu_alloc(struct device *dev,
 
 	return &vsmmu->core;
 }
+
+MODULE_IMPORT_NS(IOMMUFD);

---
base-commit: d68beb276ba26cec47350a6d468e967673ee0c56
change-id: 20241114-arm-smmu-v3-import-iommufd-module-ns-4d22fdd1f765

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

