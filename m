Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B278E1C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:24:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BC1FC433EF;
	Wed, 28 Dec 2022 16:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244673;
	bh=KYln1IfS+PW5NEG6uTXuN86LmKJIubLx/HBmW7ITGIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VIpDYUV7JhRadNqYbShR6yXqHvUvcinEjwApOYIhZ/Iy0TJmZmxM82UuX4lJFkjm0
	 upJWvuW0IWEiQJGrNOuD3I3SdJOPT7D8RYnB4I4oyQ/Y7XSjBZ0ierRQ41gXDZhNbw
	 HVneWyHesymRpYm7jMSrmsfVjRioMAsuFcEfeLxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Haoyue Xu <xuhaoyue1@hisilicon.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0676/1146] RDMA/hns: Fix XRC caps on HIP08
Date: Wed, 28 Dec 2022 15:36:55 +0100
Message-Id: <20221228144348.508400473@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

[ Upstream commit 682c0722addae4b4a1440c9db9d8c86cb8e09ce5 ]

XRC caps has been set by default. But in fact, XRC is not supported in
HIP08.

Fixes: 32548870d438 ("RDMA/hns: Add support for XRC on HIP09")
Link: https://lore.kernel.org/r/20221126102911.2921820-7-xuhaoyue1@hisilicon.com
Signed-off-by: Chengchang Tang <tangchengchang@huawei.com>
Signed-off-by: Haoyue Xu <xuhaoyue1@hisilicon.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index d21c23bcc0de..b2421883993b 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -2047,13 +2047,14 @@ static void set_default_caps(struct hns_roce_dev *hr_dev)
 
 	caps->flags |= HNS_ROCE_CAP_FLAG_ATOMIC | HNS_ROCE_CAP_FLAG_MW |
 		       HNS_ROCE_CAP_FLAG_SRQ | HNS_ROCE_CAP_FLAG_FRMR |
-		       HNS_ROCE_CAP_FLAG_QP_FLOW_CTRL | HNS_ROCE_CAP_FLAG_XRC;
+		       HNS_ROCE_CAP_FLAG_QP_FLOW_CTRL;
 
 	caps->gid_table_len[0] = HNS_ROCE_V2_GID_INDEX_NUM;
 
 	if (hr_dev->pci_dev->revision >= PCI_REVISION_ID_HIP09) {
 		caps->flags |= HNS_ROCE_CAP_FLAG_STASH |
-			       HNS_ROCE_CAP_FLAG_DIRECT_WQE;
+			       HNS_ROCE_CAP_FLAG_DIRECT_WQE |
+			       HNS_ROCE_CAP_FLAG_XRC;
 		caps->max_sq_inline = HNS_ROCE_V3_MAX_SQ_INLINE;
 	} else {
 		caps->max_sq_inline = HNS_ROCE_V2_MAX_SQ_INLINE;
-- 
2.35.1



