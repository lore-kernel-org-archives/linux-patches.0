Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846C437754D;
	Wed, 20 May 2026 17:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297989; cv=none; b=Rhl1O6nClIbg/pyZxhbvzw4YanW30lg23SLnM4OeVZ9w4P9G/Yx0Q8nHYCOGTBTPhT23bnUQx2dWQuTv3cimB/iCN57n5QmpH1wZdj2yZikqIOB4kc4AqQlLS1imvK7VxcDhN8DQZfcvS/mDc4nQxwDZOgpxNm47BJduANOwxSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297989; c=relaxed/simple;
	bh=nBOkaoH6Sr0/HMQ1iztS1PnSx5puUYBzWisrhRg3/tY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R50G/9OreUabg8uzU9efxB58Us9gt88sdfOftNk0pyIjVntTSrsQ8LvIdrlbjiRfatSIjUi3H4Y06iF1vyeSUllqwW6KOQN1OkoS2setvmC2B0iVJ5wvcJR9CrHuF4lySlXXzhHTjNMfy9srH4vNQGQsaBrSjzWwKYrMV+f9A6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zO+TfGR9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zO+TfGR9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8AEF1F000E9;
	Wed, 20 May 2026 17:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297988;
	bh=hT/g/aFk9k61bpkmFDcPDyk0PRfFb+4QC9OyBHMDT2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zO+TfGR9bHVHrr2rpXgyBcBYocWHhtAx9CjlqfaEg3qJgsDQzTRLuowi9Pa4LZkMn
	 k3cpuNur9Z7rtbA9Pkts3Kpgexpi6EfZyCOAZyR0pabTiiEH1wEn73sgHFFsq2UYgk
	 3ktKbGnQCJejej4HiPPhdBZhE9hhgYxlN0DKXMw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 240/957] iommu/tegra241-cmdqv: Update uAPI to clarify HYP_OWN requirement
Date: Wed, 20 May 2026 18:12:03 +0200
Message-ID: <20260520162139.747317625@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolin Chen <nicolinc@nvidia.com>

[ Upstream commit 9dcef98dbee35b8ae784df04c041efffdd42a69c ]

>From hardware implementation perspective, a guest tegra241-cmdqv hardware
is different than the host hardware:
 - Host HW is backed by a VINTF (HYP_OWN=1)
 - Guest HW is backed by a VINTF (HYP_OWN=0)

The kernel driver has an implementation requirement of the HYP_OWN bit in
the VM. So, VMM must follow that to allow the same copy of Linux to work.

Add this requirement to the uAPI, which is currently missing.

Fixes: 4dc0d12474f9 ("iommu/tegra241-cmdqv: Add user-space use support")
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/iommufd.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
index c218c89e0e2eb..bdd20666d1eb1 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -1003,6 +1003,11 @@ struct iommu_fault_alloc {
 enum iommu_viommu_type {
 	IOMMU_VIOMMU_TYPE_DEFAULT = 0,
 	IOMMU_VIOMMU_TYPE_ARM_SMMUV3 = 1,
+	/*
+	 * TEGRA241_CMDQV requirements (otherwise, VCMDQs will not work)
+	 * - Kernel will allocate a VINTF (HYP_OWN=0) to back this VIOMMU. So,
+	 *   VMM must wire the HYP_OWN bit to 0 in guest VINTF_CONFIG register
+	 */
 	IOMMU_VIOMMU_TYPE_TEGRA241_CMDQV = 2,
 };
 
-- 
2.53.0



