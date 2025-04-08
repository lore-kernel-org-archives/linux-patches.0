Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A7C225FA13;
	Tue,  8 Apr 2025 11:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112592; cv=none; b=WewUDbfMZS7erjvTnnPqwnqw6p47wdRHB1VgYgZpEGpP09qqWpvkQeu8V9QiVO2b/4pFC8fmiR4etc//OATG81Cr8XZBP2XGB9E/4OO5RN5k3p95Gs6GY9lzKsLinmczl+KCTRN05qv311EO5ZjIkSedqJO4QO7chapfJR0uYIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112592; c=relaxed/simple;
	bh=f7XDZzG6Oz1w2XRGPVBh1eyOSB6jbsZrdQXKLvWLzQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uf1uJTZ9oFhxkhD3z5lsOVpyAL4mgl9vxpGw/JXVXhTKsqJsHmNRH2TuzaahFinKsoW/w44Hj5elVQfg5adGcxhiZ19twwPYE6mU635husfu/5ORwImqfnW7uaANvR58DPsXvGNgcAQLaEYhtYBLHg0jv6mj0rbYD7hAbQF0ZdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P1EMg/oA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P1EMg/oA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B030C4CEE7;
	Tue,  8 Apr 2025 11:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112591;
	bh=f7XDZzG6Oz1w2XRGPVBh1eyOSB6jbsZrdQXKLvWLzQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P1EMg/oAgF9bPMpF5tYMtK88IN/Gkj40YCYRVzEh5vVIE5IUp22zvfPH1uDSbwIdq
	 Q7b8RNqVYULZxkVS26kkEkU/CkMk2yQB9YaQZYlwQeLv+h7FnKD9Dj2FSgZBNMxirA
	 kp8UquVWrzYPfQup45DFiApkkGoqWj4iLjJ5lUdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Yunsheng Lin <linyunsheng@huawei.com>,
	Haoyue Xu <xuhaoyue1@hisilicon.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 085/279] RDMA/hns: Remove redundant phy_addr in hns_roce_hem_list_find_mtt()
Date: Tue,  8 Apr 2025 12:47:48 +0200
Message-ID: <20250408104828.636915875@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

From: Chengchang Tang <tangchengchang@huawei.com>

[ Upstream commit 5f652387c5423a82453c5cb446a88834bf41a94b ]

This parameter has never been used. Remove it to simplify the function.

Link: https://lore.kernel.org/r/20220922123315.3732205-8-xuhaoyue1@hisilicon.com
Signed-off-by: Chengchang Tang <tangchengchang@huawei.com>
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Haoyue Xu <xuhaoyue1@hisilicon.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Stable-dep-of: 25655580136d ("RDMA/hns: Fix soft lockup during bt pages loop")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hem.c | 7 +------
 drivers/infiniband/hw/hns/hns_roce_hem.h | 2 +-
 drivers/infiniband/hw/hns/hns_roce_mr.c  | 4 ++--
 3 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hem.c b/drivers/infiniband/hw/hns/hns_roce_hem.c
index 99708a7bcda78..57b84f5dc0f16 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hem.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hem.c
@@ -1487,19 +1487,17 @@ void hns_roce_hem_list_init(struct hns_roce_hem_list *hem_list)
 
 void *hns_roce_hem_list_find_mtt(struct hns_roce_dev *hr_dev,
 				 struct hns_roce_hem_list *hem_list,
-				 int offset, int *mtt_cnt, u64 *phy_addr)
+				 int offset, int *mtt_cnt)
 {
 	struct list_head *head = &hem_list->btm_bt;
 	struct hns_roce_hem_item *hem, *temp_hem;
 	void *cpu_base = NULL;
-	u64 phy_base = 0;
 	int nr = 0;
 
 	list_for_each_entry_safe(hem, temp_hem, head, sibling) {
 		if (hem_list_page_is_in_range(hem, offset)) {
 			nr = offset - hem->start;
 			cpu_base = hem->addr + nr * BA_BYTE_LEN;
-			phy_base = hem->dma_addr + nr * BA_BYTE_LEN;
 			nr = hem->end + 1 - offset;
 			break;
 		}
@@ -1508,8 +1506,5 @@ void *hns_roce_hem_list_find_mtt(struct hns_roce_dev *hr_dev,
 	if (mtt_cnt)
 		*mtt_cnt = nr;
 
-	if (phy_addr)
-		*phy_addr = phy_base;
-
 	return cpu_base;
 }
diff --git a/drivers/infiniband/hw/hns/hns_roce_hem.h b/drivers/infiniband/hw/hns/hns_roce_hem.h
index fa84ce33076ac..150922b22eaa6 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hem.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hem.h
@@ -132,7 +132,7 @@ void hns_roce_hem_list_release(struct hns_roce_dev *hr_dev,
 			       struct hns_roce_hem_list *hem_list);
 void *hns_roce_hem_list_find_mtt(struct hns_roce_dev *hr_dev,
 				 struct hns_roce_hem_list *hem_list,
-				 int offset, int *mtt_cnt, u64 *phy_addr);
+				 int offset, int *mtt_cnt);
 
 static inline void hns_roce_hem_first(struct hns_roce_hem *hem,
 				      struct hns_roce_hem_iter *iter)
diff --git a/drivers/infiniband/hw/hns/hns_roce_mr.c b/drivers/infiniband/hw/hns/hns_roce_mr.c
index 604dd38b5c8fd..791a45802d6b2 100644
--- a/drivers/infiniband/hw/hns/hns_roce_mr.c
+++ b/drivers/infiniband/hw/hns/hns_roce_mr.c
@@ -614,7 +614,7 @@ static int mtr_map_region(struct hns_roce_dev *hr_dev, struct hns_roce_mtr *mtr,
 	while (offset < end && npage < max_count) {
 		count = 0;
 		mtts = hns_roce_hem_list_find_mtt(hr_dev, &mtr->hem_list,
-						  offset, &count, NULL);
+						  offset, &count);
 		if (!mtts)
 			return -ENOBUFS;
 
@@ -864,7 +864,7 @@ int hns_roce_mtr_find(struct hns_roce_dev *hr_dev, struct hns_roce_mtr *mtr,
 		mtt_count = 0;
 		mtts = hns_roce_hem_list_find_mtt(hr_dev, &mtr->hem_list,
 						  start_index + total,
-						  &mtt_count, NULL);
+						  &mtt_count);
 		if (!mtts || !mtt_count)
 			goto done;
 
-- 
2.39.5



