Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B594749D
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:16:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93BB0C433EF;
	Thu, 12 Jan 2023 14:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673532962;
	bh=7tjrtexhbe0WKUQ7WD6KNAke2CrM65Lr6tOpaswbjn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vkdDFwmytF7immBm0pnx2Z3odmSWZY+SQ815vBSKjPA1X06s6+ag9jK09JZpxQEHn
	 PU1MGdWb71MJCQdtYInL3HqgqnEuqW2cFGbrGVpXnt/CiRlIlx2ha05cff6B4NQVlE
	 k9uWt0MGjuMQrIf442JVJJGbuqbQRYlp9MgYxuUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 326/783] RDMA/nldev: Add checks for nla_nest_start() in fill_stat_counter_qps()
Date: Thu, 12 Jan 2023 14:50:42 +0100
Message-Id: <20230112135539.431041161@linuxfoundation.org>
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
index f7689bc10d14..78534340d282 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -754,6 +754,8 @@ static int fill_stat_counter_qps(struct sk_buff *msg,
 	int ret = 0;
 
 	table_attr = nla_nest_start(msg, RDMA_NLDEV_ATTR_RES_QP);
+	if (!table_attr)
+		return -EMSGSIZE;
 
 	rt = &counter->device->res[RDMA_RESTRACK_QP];
 	xa_lock(&rt->xa);
-- 
2.35.1



