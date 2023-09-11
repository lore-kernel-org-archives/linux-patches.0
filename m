Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9110811710
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:21:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD91FC433C8;
	Mon, 11 Sep 2023 15:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694445716;
	bh=ojVLxq0Dbrl6OeP7yrXqqvzPiyYcHj3YYNQ24I3FCUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=poKCY/OqzLa7IO9eo5PzqFQnSTrv40u/xVgummCwFAD5uBTY3d4JbL0Op6gK1h4Ro
	 hhZvulJ0lg1STsvJ7dnE9IkYshi6Ga5dlsnuIMg3YWC7SZj+kdflv9c3D/4oCrbnaZ
	 jF6SL1uCV5e+oJXhGZLzT0sDqc9bOTrWO8BGNLHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 446/600] RDMA/hns: Fix inaccurate error label name in init instance
Date: Mon, 11 Sep 2023 15:47:59 +0200
Message-ID: <20230911134646.810586332@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junxian Huang <huangjunxian6@hisilicon.com>

[ Upstream commit c9c0bd3c177d93d80968f720304087ba83fe8f74 ]

This patch fixes inaccurate error label name in init instance.

Fixes: 70f92521584f ("RDMA/hns: Use the reserved loopback QPs to free MR before destroying MPT")
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://lore.kernel.org/r/20230804012711.808069-4-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index e9a1985f7f17c..33980485ef5ba 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -6865,14 +6865,14 @@ static int __hns_roce_hw_v2_init_instance(struct hnae3_handle *handle)
 	ret = hns_roce_init(hr_dev);
 	if (ret) {
 		dev_err(hr_dev->dev, "RoCE Engine init failed!\n");
-		goto error_failed_cfg;
+		goto error_failed_roce_init;
 	}
 
 	if (hr_dev->pci_dev->revision == PCI_REVISION_ID_HIP08) {
 		ret = free_mr_init(hr_dev);
 		if (ret) {
 			dev_err(hr_dev->dev, "failed to init free mr!\n");
-			goto error_failed_roce_init;
+			goto error_failed_free_mr_init;
 		}
 	}
 
@@ -6880,10 +6880,10 @@ static int __hns_roce_hw_v2_init_instance(struct hnae3_handle *handle)
 
 	return 0;
 
-error_failed_roce_init:
+error_failed_free_mr_init:
 	hns_roce_exit(hr_dev);
 
-error_failed_cfg:
+error_failed_roce_init:
 	kfree(hr_dev->priv);
 
 error_failed_kzalloc:
-- 
2.40.1



