Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 428931875
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:07:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBE7AC433D2;
	Wed, 28 Dec 2022 16:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243667;
	bh=ZE63KM8eZHI2fpqlluTeUIYCMZKQwL3KrBXj+DhsKhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ovmifkzEVxBLuh2jytUrIImqgoOpviTCSPJGWvIVUdG6rqcZYOd+UR3Hs180ipuZO
	 r/toNB9xQ3YmQhs8YEUY+gD4Her6qoMNFcy5K8APnTG1TNsr3njZuM+5/8cDX49ekN
	 DlnzkqfGvG6VCkuzS+ViG7451TlfGJgVA+nxpTYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0566/1073] RDMA/core: Fix order of nldev_exit call
Date: Wed, 28 Dec 2022 15:35:54 +0100
Message-Id: <20221228144343.429555400@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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
index 4053a09b8d33..267d6e7fb18e 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -2851,8 +2851,8 @@ static int __init ib_core_init(void)
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



