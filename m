Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6AF79C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:20:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53864C433F1;
	Thu, 12 Jan 2023 14:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533228;
	bh=kIIcrG7nY51ZZE+Ulqak89PsomiAsAQDIohgtdd/gXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VuCxcgeKqAZo3ClD/GOSRePvP6Yocs/AIhP+1eDxaV7VyzxE0P2lVcxhtZWWV/kDH
	 fdRnu76FoI9J5IUizzrpPMPdCTGDkf6WOj4BqJcApXHpI7bu4izDMs0Kg00gXzedBE
	 GkVzuP0pO8BFeluC09pweXFJWvEPAQZHiT8FSsxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 412/783] iommu/sun50i: Fix flush size
Date: Thu, 12 Jan 2023 14:52:08 +0100
Message-Id: <20230112135543.421686491@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jernej Skrabec <jernej.skrabec@gmail.com>

[ Upstream commit 67a8a67f9eceb72e4c73d1d09ed9ab04f4b8e12d ]

Function sun50i_table_flush() takes number of entries as an argument,
not number of bytes. Fix that mistake in sun50i_dte_get_page_table().

Fixes: 4100b8c229b3 ("iommu: Add Allwinner H6 IOMMU driver")
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://lore.kernel.org/r/20221025165415.307591-5-jernej.skrabec@gmail.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/sun50i-iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/sun50i-iommu.c b/drivers/iommu/sun50i-iommu.c
index 68aee56e2231..dc8ad35cbc4e 100644
--- a/drivers/iommu/sun50i-iommu.c
+++ b/drivers/iommu/sun50i-iommu.c
@@ -513,7 +513,7 @@ static u32 *sun50i_dte_get_page_table(struct sun50i_iommu_domain *sun50i_domain,
 		sun50i_iommu_free_page_table(iommu, drop_pt);
 	}
 
-	sun50i_table_flush(sun50i_domain, page_table, PT_SIZE);
+	sun50i_table_flush(sun50i_domain, page_table, NUM_PT_ENTRIES);
 	sun50i_table_flush(sun50i_domain, dte_addr, 1);
 
 	return page_table;
-- 
2.35.1



