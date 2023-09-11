Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ECF911710
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:21:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F8EDC433C8;
	Mon, 11 Sep 2023 15:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694445699;
	bh=PvvSPQPEMuSLN/cNRsK/Xf+tViP9mPd6Jn8ihFGywno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cRLlrHkzHmDI6IblxygyzqexEXtzthyG5BxMuWaiuavw+n6fxKgCXPQi523QgJbtS
	 8H3ekr1N2bcerkta0vcgLQ1ZVro+HczpjVmNigdlc70HUV+s4vNvse2qYmSyHqspom
	 Q3hALgIxvbyl2/sRTbx3a0K4G6RSdLicHQY79z44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yong Wu <yong.wu@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 441/600] iommu/mediatek: Remove unused "mapping" member from mtk_iommu_data
Date: Mon, 11 Sep 2023 15:47:54 +0200
Message-ID: <20230911134646.665830968@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yong Wu <yong.wu@mediatek.com>

[ Upstream commit 9ff894edd542618dad2fef538f8272c620a501db ]

Just remove a unused variable that only is for mtk_iommu_v1.

Signed-off-by: Yong Wu <yong.wu@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Matthias Brugger <matthias.bgg@gmail.com>
Link: https://lore.kernel.org/r/20221018024258.19073-7-yong.wu@mediatek.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Stable-dep-of: cf69ef46dbd9 ("iommu/mediatek: Fix two IOMMU share pagetable issue")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/mtk_iommu.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/iommu/mtk_iommu.c b/drivers/iommu/mtk_iommu.c
index 2ae5a6058a34a..5ff8982712e0f 100644
--- a/drivers/iommu/mtk_iommu.c
+++ b/drivers/iommu/mtk_iommu.c
@@ -223,10 +223,7 @@ struct mtk_iommu_data {
 	struct device			*smicomm_dev;
 
 	struct mtk_iommu_bank_data	*bank;
-
-	struct dma_iommu_mapping	*mapping; /* For mtk_iommu_v1.c */
 	struct regmap			*pericfg;
-
 	struct mutex			mutex; /* Protect m4u_group/m4u_dom above */
 
 	/*
-- 
2.40.1



