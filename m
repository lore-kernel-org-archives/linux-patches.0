Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69DE2137C53;
	Tue, 23 Jan 2024 00:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969441; cv=none; b=fNaxUQWDyjEX7Rd0A8eMctq7KyoOT5CEbm6uKMQd9VJ26tA1TF5qYOdbQuKI2X4JiTU6zg0/F5HvrPGjhV0bpcJMg/VRwOTDk2LoZf8bVg1gg9TyeFXhiLO53goQzo2NPr/ZkEXIp4p661MPdxFU0w6c+85LaTpYYLBT7bSUjqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969441; c=relaxed/simple;
	bh=AONIZ6D8iB523CKL4qzd6cIgdNxzsCTyogf9ZnZj0/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oAsXkYpv6WK/48VVmVIcxrJEfixwLBzADDepocjnBjaVy3HmqKYj46QD4U0YB1fi0sjScM3yE90RKjnmN7iUR/iOdd/wzFoef/llsB5nF20f/MAUbsx/1OI77gP+OvlTKL3WeZCydCmL878p9fD9yJVqfSEteTE1Bqhq6WNEN6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U0wI0h5w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U0wI0h5w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22E84C433F1;
	Tue, 23 Jan 2024 00:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969441;
	bh=AONIZ6D8iB523CKL4qzd6cIgdNxzsCTyogf9ZnZj0/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U0wI0h5w8hZE+OQek0WsIC1oAi5is2Pvp7KrvOtlNh8Syd+K9wGUxKqtSx/ai4wrT
	 fv5CftUYpfVOGwVnge0IytiG2TgT5noSIB4y8g6g7/kcK/LXfK3zpF46dO6qlRXv3h
	 OiGeNvWMuKcUMUPWk5a5cNWQMT0jLKga0wR/jVHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 248/641] RDMA/hns: Fix inappropriate err code for unsupported operations
Date: Mon, 22 Jan 2024 15:52:32 -0800
Message-ID: <20240122235825.679435863@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junxian Huang <huangjunxian6@hisilicon.com>

[ Upstream commit f45b83ad39f8033e717b1eee57e81811113d5a84 ]

EOPNOTSUPP is more situable than EINVAL for allocating XRCD while XRC
is not supported and unsupported resizing SRQ.

Fixes: 32548870d438 ("RDMA/hns: Add support for XRC on HIP09")
Fixes: 221109e64316 ("RDMA/hns: Add interception for resizing SRQs")
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://lore.kernel.org/r/20231114123449.1106162-2-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 2 +-
 drivers/infiniband/hw/hns/hns_roce_pd.c    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 2bca9560f32d..e4753c802942 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -5671,7 +5671,7 @@ static int hns_roce_v2_modify_srq(struct ib_srq *ibsrq,
 
 	/* Resizing SRQs is not supported yet */
 	if (srq_attr_mask & IB_SRQ_MAX_WR)
-		return -EINVAL;
+		return -EOPNOTSUPP;
 
 	if (srq_attr_mask & IB_SRQ_LIMIT) {
 		if (srq_attr->srq_limit > srq->wqe_cnt)
diff --git a/drivers/infiniband/hw/hns/hns_roce_pd.c b/drivers/infiniband/hw/hns/hns_roce_pd.c
index 783e71852c50..bd1fe89ca205 100644
--- a/drivers/infiniband/hw/hns/hns_roce_pd.c
+++ b/drivers/infiniband/hw/hns/hns_roce_pd.c
@@ -150,7 +150,7 @@ int hns_roce_alloc_xrcd(struct ib_xrcd *ib_xrcd, struct ib_udata *udata)
 	int ret;
 
 	if (!(hr_dev->caps.flags & HNS_ROCE_CAP_FLAG_XRC))
-		return -EINVAL;
+		return -EOPNOTSUPP;
 
 	ret = hns_roce_xrcd_alloc(hr_dev, &xrcd->xrcdn);
 	if (ret)
-- 
2.43.0



