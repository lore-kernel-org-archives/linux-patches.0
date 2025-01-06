Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D1B38634A;
	Mon,  6 Jan 2025 15:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178883; cv=none; b=RR+tcVdH/VOUsiwZPs2hwCePMtpNSxELND4zwskrTNGvF7K7UDv7/1aUoMx+SkhDOFVZLgwzUbDtzdpEkR8KBG8Z5/dBdKc1k1MOEMwbHV6MsdSpDsuhPJ/lDABKp6GDNTqfe9b2AN3Jn4zXg4f44tQG+RUqorbw8gxM6yVLcAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178883; c=relaxed/simple;
	bh=2y3J9U46AztJw8A3bsNLRxBJda8ONocPQzw8FeOCxBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QHGzVvtqKpe1AInkW20dkneUNAF3LrMhI8n3kgZ1XNMiVk+aNO4ZhTeI98JBShIK/rmuklUhaISshEfN6nNYRGM1BwbmevyTDJ4NDcobdMb2bZ+/WhsPOO0GfpEGbcY25LnGWuR02OJyffY++EmwbHVV+XLFv6KBeu5TAaEw7dU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SgKoystD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SgKoystD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6582C4CED2;
	Mon,  6 Jan 2025 15:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178883;
	bh=2y3J9U46AztJw8A3bsNLRxBJda8ONocPQzw8FeOCxBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SgKoystDqYRGIIDubKM6YdfB55KKrHkMkIK4ssr53zc047qIZFzijrTsBNxnQIfiv
	 KAP2IZMelSoJ7p3tuYV4B496irhstFIqT3M5j+Gnog5iWOGDE6NRp1Bq0WIY/KQHCQ
	 qqe2+91D+2348NADcT6n9+GUZyhomM/AOD2wRu3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunsheng Lin <linyunsheng@huawei.com>,
	Haoyue Xu <xuhaoyue1@hisilicon.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 124/168] RDMA/hns: Remove redundant bt_level for hem_list_alloc_item()
Date: Mon,  6 Jan 2025 16:17:12 +0100
Message-ID: <20250106151143.130262591@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Yunsheng Lin <linyunsheng@huawei.com>

[ Upstream commit be1eeb667eb748391b1c8158678fe4d892187793 ]

The 'bt_level' parameter is not used in hem_list_alloc_item(),
so remove it.

Link: https://lore.kernel.org/r/20220922123315.3732205-6-xuhaoyue1@hisilicon.com
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Haoyue Xu <xuhaoyue1@hisilicon.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Stable-dep-of: 8673a6c2d9e4 ("RDMA/hns: Fix mapping error of zero-hop WQE buffer")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hem.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hem.c b/drivers/infiniband/hw/hns/hns_roce_hem.c
index ce2ace2c850d..09298f38be23 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hem.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hem.c
@@ -988,7 +988,7 @@ struct hns_roce_hem_head {
 
 static struct hns_roce_hem_item *
 hem_list_alloc_item(struct hns_roce_dev *hr_dev, int start, int end, int count,
-		    bool exist_bt, int bt_level)
+		    bool exist_bt)
 {
 	struct hns_roce_hem_item *hem;
 
@@ -1199,7 +1199,7 @@ static int hem_list_alloc_mid_bt(struct hns_roce_dev *hr_dev,
 		start_aligned = (distance / step) * step + r->offset;
 		end = min_t(u64, start_aligned + step - 1, max_ofs);
 		cur = hem_list_alloc_item(hr_dev, start_aligned, end, unit,
-					  true, level);
+					  true);
 		if (!cur) {
 			ret = -ENOMEM;
 			goto err_exit;
@@ -1251,7 +1251,7 @@ alloc_root_hem(struct hns_roce_dev *hr_dev, int unit, int *max_ba_num,
 	/* indicate to last region */
 	r = &regions[region_cnt - 1];
 	hem = hem_list_alloc_item(hr_dev, offset, r->offset + r->count - 1,
-				  ba_num, true, 0);
+				  ba_num, true);
 	if (!hem)
 		return ERR_PTR(-ENOMEM);
 
@@ -1268,7 +1268,7 @@ static int alloc_fake_root_bt(struct hns_roce_dev *hr_dev, void *cpu_base,
 	struct hns_roce_hem_item *hem;
 
 	hem = hem_list_alloc_item(hr_dev, r->offset, r->offset + r->count - 1,
-				  r->count, false, 0);
+				  r->count, false);
 	if (!hem)
 		return -ENOMEM;
 
-- 
2.39.5



