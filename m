Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C56546B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:19:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B426DC433EF;
	Mon, 16 Jan 2023 16:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673885948;
	bh=Fnqq/PA2aiZJiJX1LIw+ukX78ZfE7SJIfllVVoYNMu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mwUV0fNs1yuxwxiMZXapNKIwUD80aVEcIH+h6dOo5fDJf2T6oVPXkJX/pC9j7vHEa
	 9rcFPJ4rp4/WKdvZBTj0eofC3gYeYSd03R3fZbIKcI3XB48QqvPineJVdESWiwzxL0
	 /ZMo84vju7A1BfGL8swEPEj0DETBuFj/3OP9L418=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 244/658] RDMA/core: Fix order of nldev_exit call
Date: Mon, 16 Jan 2023 16:45:32 +0100
Message-Id: <20230116154920.738984024@linuxfoundation.org>
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

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 4508d32ccced24c972bc4592104513e1ff8439b5 ]

Create symmetrical exit flow by calling to nldev_exit() after
call to rdma_nl_unregister(RDMA_NL_LS).

Fixes: 6c80b41abe22 ("RDMA/netlink: Add nldev initialization flows")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Link: https://lore.kernel.org/r/64e676774a53a406f4cde265d5a4cfd6b8e97df9.1666683334.git.leonro@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 372ca5347d3c..a12ee8ef27a8 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -2796,8 +2796,8 @@ static int __init ib_core_init(void)
 static void __exit ib_core_cleanup(void)
 {
 	roce_gid_mgmt_cleanup();
-	nldev_exit();
 	rdma_nl_unregister(RDMA_NL_LS);
+	nldev_exit();
 	unregister_pernet_device(&rdma_dev_net_ops);
 	unregister_blocking_lsm_notifier(&ibdev_lsm_nb);
 	ib_sa_cleanup();
-- 
2.35.1



