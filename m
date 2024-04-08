Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF0A84D35;
	Mon,  8 Apr 2024 13:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582191; cv=none; b=qSgWxyU9VHkhEGhlbaNl5tVuFTWpDj+CS6GTAkI8GhTPV7K0zWrAY8ELFAsZUkzRYhHth7mm07eBjEfm7Hm6qEW/tW5Nml8AQ96c0XLqzWlZq4PppHn2e/k7Z13vcLqhsnq5CD/oon4h+kLVjVtfExIDKDt8eIkL4sGCwMNTxvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582191; c=relaxed/simple;
	bh=wIYT7nDJiNbgKvNPeCcWisb3qCDZzVqBvBY1AJQkJPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kto3PYxget6jQe4wUrl2cxyyjKNUmELlTUEOmfKcyJOjC/YMXtIe1TYb9BZlvf2PPvSUaFLFzScLuolvzoGLN4Rs6mDfG/PiUsIoRKJaa6h1IGN1h4lyPmu/cl8UTvn+u9LrIRlwLOeE/wbbabgb9q8YCA2aQn5TYpln7AmLGp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wQEKDYuF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wQEKDYuF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 436BFC433C7;
	Mon,  8 Apr 2024 13:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582191;
	bh=wIYT7nDJiNbgKvNPeCcWisb3qCDZzVqBvBY1AJQkJPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wQEKDYuF7aYERYnCPz7b7oDDZEDviGJMi/BpJtmQy34Dz8UEFN363176UzoQkgRBL
	 zRA2dgV2X+/QGrrPeNKjdo8qlF7YLGT8DC7n29dR7HO4BOhPg+zVxHMqlwZVRQafE0
	 5YGl+34MxngfLLZCbf8JbeSc3tL9EYkQlqinxXBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Wang <wangjie125@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Michal Kubiak <michal.kubiak@intel.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 034/273] net: hns3: fix index limit to support all queue stats
Date: Mon,  8 Apr 2024 14:55:09 +0200
Message-ID: <20240408125310.354180660@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jie Wang <wangjie125@huawei.com>

[ Upstream commit 47e39d213e09c6cae0d6b4d95e454ea404013312 ]

Currently, hns hardware supports more than 512 queues and the index limit
in hclge_comm_tqps_update_stats is wrong. So this patch removes it.

Fixes: 287db5c40d15 ("net: hns3: create new set of common tqp stats APIs for PF and VF reuse")
Signed-off-by: Jie Wang <wangjie125@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/hisilicon/hns3/hns3_common/hclge_comm_tqp_stats.c  | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_tqp_stats.c b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_tqp_stats.c
index f3c9395d8351c..618f66d9586b3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_tqp_stats.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_common/hclge_comm_tqp_stats.c
@@ -85,7 +85,7 @@ int hclge_comm_tqps_update_stats(struct hnae3_handle *handle,
 		hclge_comm_cmd_setup_basic_desc(&desc, HCLGE_OPC_QUERY_TX_STATS,
 						true);
 
-		desc.data[0] = cpu_to_le32(tqp->index & 0x1ff);
+		desc.data[0] = cpu_to_le32(tqp->index);
 		ret = hclge_comm_cmd_send(hw, &desc, 1);
 		if (ret) {
 			dev_err(&hw->cmq.csq.pdev->dev,
-- 
2.43.0



