Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0198615CAD
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:00:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47113C433D6;
	Tue,  8 Nov 2022 14:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916041;
	bh=BmsuMqy66LdimLV7UTbtG9/SviH2muAw+AzkYBIVA4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tqXj5iMUT7XX0hMfEfX5jGJ4IrgCCCkwQKMPSdvk/YKaBM6UhYtOYFz7kxUXsGF8G
	 tDp2bZlLuzzWM8bouZJn7VkPtzTyb8/FHELRJTZjTsKRPC0qgVQ+Mye813Vvs5hZQv
	 eeb5H9l809M0JGWVFkgYcNMiJ2gAAcrFhswV6rXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xinhao Liu <liuxinhao5@hisilicon.com>,
	Wenpeng Liang <liangwenpeng@huawei.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 015/144] RDMA/hns: Remove magic number
Date: Tue,  8 Nov 2022 14:38:12 +0100
Message-Id: <20221108133345.966521834@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xinhao Liu <liuxinhao5@hisilicon.com>

[ Upstream commit 9c3631d17054a8766dbdc1abf8d29306260e7c7f ]

Don't use unintelligible constants.

Link: https://lore.kernel.org/r/20211119140208.40416-10-liangwenpeng@huawei.com
Signed-off-by: Xinhao Liu <liuxinhao5@hisilicon.com>
Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Stable-dep-of: 9e272ed69ad6 ("RDMA/hns: Disable local invalidate operation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 1dbad159f379..1782626b54db 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -678,6 +678,7 @@ static void hns_roce_write512(struct hns_roce_dev *hr_dev, u64 *val,
 static void write_dwqe(struct hns_roce_dev *hr_dev, struct hns_roce_qp *qp,
 		       void *wqe)
 {
+#define HNS_ROCE_SL_SHIFT 2
 	struct hns_roce_v2_rc_send_wqe *rc_sq_wqe = wqe;
 
 	/* All kinds of DirectWQE have the same header field layout */
@@ -685,7 +686,8 @@ static void write_dwqe(struct hns_roce_dev *hr_dev, struct hns_roce_qp *qp,
 	roce_set_field(rc_sq_wqe->byte_4, V2_RC_SEND_WQE_BYTE_4_DB_SL_L_M,
 		       V2_RC_SEND_WQE_BYTE_4_DB_SL_L_S, qp->sl);
 	roce_set_field(rc_sq_wqe->byte_4, V2_RC_SEND_WQE_BYTE_4_DB_SL_H_M,
-		       V2_RC_SEND_WQE_BYTE_4_DB_SL_H_S, qp->sl >> 2);
+		       V2_RC_SEND_WQE_BYTE_4_DB_SL_H_S,
+		       qp->sl >> HNS_ROCE_SL_SHIFT);
 	roce_set_field(rc_sq_wqe->byte_4, V2_RC_SEND_WQE_BYTE_4_WQE_INDEX_M,
 		       V2_RC_SEND_WQE_BYTE_4_WQE_INDEX_S, qp->sq.head);
 
-- 
2.35.1



