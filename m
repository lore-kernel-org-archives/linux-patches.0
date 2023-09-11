Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E58B1170D
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:15:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B165FC433C7;
	Mon, 11 Sep 2023 14:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441703;
	bh=i5RX4ePo+WdoAhKM3NwlIiyxXSaUc2xIS1XfpVN6UZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m4Z83pa5pUu/Slj/vPofWVZvImE+qpFD0pl6Tofc1VsU2HwXWobb9jDQXs2GJ061l
	 cs/XvXnjST398PZ13nvF8GblGZG4NAqO4NT6EZ7moCK+MsXujcnm74UJG9HS/7JaLR
	 9qwYPYPhuhZUrBn4/KwS1zVvkbdWGo0YaXj4Vhq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Chunyan Zhang <zhang.lyra@gmail.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 507/739] iommu/sprd: Add missing force_aperture
Date: Mon, 11 Sep 2023 15:45:06 +0200
Message-ID: <20230911134705.292990501@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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
index 39e34fdeccda7..eb684d8807cab 100644
--- a/drivers/iommu/sprd-iommu.c
+++ b/drivers/iommu/sprd-iommu.c
@@ -148,6 +148,7 @@ static struct iommu_domain *sprd_iommu_domain_alloc(unsigned int domain_type)
 
 	dom->domain.geometry.aperture_start = 0;
 	dom->domain.geometry.aperture_end = SZ_256M - 1;
+	dom->domain.geometry.force_aperture = true;
 
 	return &dom->domain;
 }
-- 
2.40.1



