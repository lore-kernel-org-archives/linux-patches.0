Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A3FE46B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:20:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1A9CC433EF;
	Mon, 16 Jan 2023 16:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886001;
	bh=9GGRKnD/CkOSOU9UtpSOD7Q6zwkqYi7MVhHVg1XesHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1XZTrqT2CfchLPUyGvmLlMDataNsXoSDoyfGf8F39xE/NdT/9m5YnDLpwolyAxf7e
	 s5o5mT5Lvr98NjT6On0TEPnTHQl77OUHyxJabssGVSLZlHe3+g8xrcYBPbHgXhdTtu
	 2Bg50DM+hinBrlAlV7cxkFFqoErx1dxph1QQ3x1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 265/658] RDMA/nldev: Add checks for nla_nest_start() in fill_stat_counter_qps()
Date: Mon, 16 Jan 2023 16:45:53 +0100
Message-Id: <20230116154921.712008623@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit ea5ef136e215fdef35f14010bc51fcd6686e6922 ]

As the nla_nest_start() may fail with NULL returned, the return value needs
to be checked.

Fixes: c4ffee7c9bdb ("RDMA/netlink: Implement counter dumpit calback")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Link: https://lore.kernel.org/r/20221126043410.85632-1-yuancan@huawei.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/nldev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 93cc60e92d82..88c68d77e6b1 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -694,6 +694,8 @@ static int fill_stat_counter_qps(struct sk_buff *msg,
 	int ret = 0;
 
 	table_attr = nla_nest_start(msg, RDMA_NLDEV_ATTR_RES_QP);
+	if (!table_attr)
+		return -EMSGSIZE;
 
 	rt = &counter->device->res[RDMA_RESTRACK_QP];
 	xa_lock(&rt->xa);
-- 
2.35.1



