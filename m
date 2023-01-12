Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D98DB749D
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:16:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E8C2C433D2;
	Thu, 12 Jan 2023 14:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533019;
	bh=VD7ugWSrmawl/ONvNzl6HMD20kVsST2ZKwJ3ViXNhpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u7m7IXetQrc2A7yhhUR2t2TUuxtnXOiMyO/pnxTbImJ17gmY+F6izag4iywrCfLo7
	 GBxcHmtXmVd0VM/6by9z1UJ0bQ4omvM32cJhGHYCA2JBL41R3NMNbQ1XnhH7yJfrWX
	 iTDV75Wq36DvjCPbLa03RjW1g6fiqfbrO/uxAP5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Haoyue Xu <xuhaoyue1@hisilicon.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 336/783] RDMA/hns: Fix page size cap from firmware
Date: Thu, 12 Jan 2023 14:50:52 +0100
Message-Id: <20230112135539.877245482@linuxfoundation.org>
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

From: Chengchang Tang <tangchengchang@huawei.com>

[ Upstream commit 99dc5a0712883d5d13b620d25b3759d429577bc8 ]

Add verification to make sure the roce page size cap is supported by the
system page size.

Fixes: ba6bb7e97421 ("RDMA/hns: Add interfaces to get pf capabilities from firmware")
Link: https://lore.kernel.org/r/20221126102911.2921820-5-xuhaoyue1@hisilicon.com
Signed-off-by: Chengchang Tang <tangchengchang@huawei.com>
Signed-off-by: Haoyue Xu <xuhaoyue1@hisilicon.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 0f4ef4516868..76ed547b76ea 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -2166,6 +2166,9 @@ static int hns_roce_query_pf_caps(struct hns_roce_dev *hr_dev)
 	calc_pg_sz(caps->num_idx_segs, caps->idx_entry_sz, caps->idx_hop_num,
 		   1, &caps->idx_buf_pg_sz, &caps->idx_ba_pg_sz, HEM_TYPE_IDX);
 
+	if (!(caps->page_size_cap & PAGE_SIZE))
+		caps->page_size_cap = HNS_ROCE_V2_PAGE_SIZE_SUPPORTED;
+
 	return 0;
 }
 
-- 
2.35.1



