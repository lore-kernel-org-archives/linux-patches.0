Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3861BBA3E
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:34:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E6FC433D2;
	Tue,  7 Mar 2023 17:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678210498;
	bh=AUV1hywf+L5SsE974anpYKB/3OkmUURxYL7s/ddJRb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dKcvT4Sod7qZl4Qg2Cr+bcuDM7nOY/EyUm1dVniDRmzIHtsflQ36aVCMEmrpfORJB
	 uHkbynd+qluFBUYZv0mDtoewluq/FAgTq4GEbbh/ZiViXlHaydssTEZhS1uyyY7MaB
	 9Y5dpLL3j2lDVr+C+icV/+zeQWQg+KfMw0SzDi0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Liu <yi.l.liu@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0530/1001] iommufd: Add three missing structures in ucmd_buffer
Date: Tue,  7 Mar 2023 17:55:02 +0100
Message-Id: <20230307170044.466290316@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yi Liu <yi.l.liu@intel.com>

[ Upstream commit 84798f2849942bb5e8817417adfdfa6241df2835 ]

struct iommu_ioas_copy, struct iommu_option and struct iommu_vfio_ioas are
missed in ucmd_buffer. Although they are smaller than the size of
ucmd_buffer, it is safer to list them in ucmd_buffer explicitly.

Fixes: aad37e71d5c4 ("iommufd: IOCTLs for the io_pagetable")
Fixes: d624d6652a65 ("iommufd: vfio container FD ioctl compatibility")
Link: https://lore.kernel.org/r/20230120122040.280219-1-yi.l.liu@intel.com
Signed-off-by: Yi Liu <yi.l.liu@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommufd/main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
index 083e6fcbe10ad..3fbe636c3d8a6 100644
--- a/drivers/iommu/iommufd/main.c
+++ b/drivers/iommu/iommufd/main.c
@@ -252,9 +252,12 @@ union ucmd_buffer {
 	struct iommu_destroy destroy;
 	struct iommu_ioas_alloc alloc;
 	struct iommu_ioas_allow_iovas allow_iovas;
+	struct iommu_ioas_copy ioas_copy;
 	struct iommu_ioas_iova_ranges iova_ranges;
 	struct iommu_ioas_map map;
 	struct iommu_ioas_unmap unmap;
+	struct iommu_option option;
+	struct iommu_vfio_ioas vfio_ioas;
 #ifdef CONFIG_IOMMUFD_TEST
 	struct iommu_test_cmd test;
 #endif
-- 
2.39.2



