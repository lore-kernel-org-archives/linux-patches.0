Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D1F8746F
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:28:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8888EC433CD;
	Sun, 17 Sep 2023 20:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982496;
	bh=XmtaK/8NskPU8b1bf32Pp+XHP5R0z2yWPY48lIoDXhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g2aPLbIKDrvevhxm1oMBfn63Vz+EdQQV8S96SCi/YB4CPOxr60SrSjWbGeRCN6Hub
	 qHhFTZpfsIMHqP8fwn6oHfnsGW9MxgZ9UsS39OC+fXfSWobPhA8kriVb2qeAZRJCzp
	 IDOMY2BJfQnat9REBIqMVtEw7nh5DQ8+TErAYyks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Chunyan Zhang <zhang.lyra@gmail.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 267/511] iommu/sprd: Add missing force_aperture
Date: Sun, 17 Sep 2023 21:11:34 +0200
Message-ID: <20230917191120.288416369@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit d48a51286c698f7fe8efc688f23a532f4fe9a904 ]

force_aperture was intended to false only by GART drivers that have an
identity translation outside the aperture. This does not describe sprd, so
add the missing 'force_aperture = true'.

Fixes: b23e4fc4e3fa ("iommu: add Unisoc IOMMU basic driver")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: Chunyan Zhang <zhang.lyra@gmail.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/sprd-iommu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iommu/sprd-iommu.c b/drivers/iommu/sprd-iommu.c
index 723940e841612..6b11770e3d75a 100644
--- a/drivers/iommu/sprd-iommu.c
+++ b/drivers/iommu/sprd-iommu.c
@@ -147,6 +147,7 @@ static struct iommu_domain *sprd_iommu_domain_alloc(unsigned int domain_type)
 
 	dom->domain.geometry.aperture_start = 0;
 	dom->domain.geometry.aperture_end = SZ_256M - 1;
+	dom->domain.geometry.force_aperture = true;
 
 	return &dom->domain;
 }
-- 
2.40.1



