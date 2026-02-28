Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A81C1347FFB
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302574; cv=none; b=HYn3hm8xxLLf9UNhEczo6M/H+LwGFOLR6lgYQYPC0iCwMvojyeON3RqyolEtrm7vCO7KtGo8GZn1qfSYN6EdISFchyxAUWDrpP+U95ly/67KkRQEeu0IimRbRXFGiNgpOAApbwwXNgyLvwB//uutjLRCY+LmdTDbs5B5BnFbSS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302574; c=relaxed/simple;
	bh=olxrGeuxQcvnLjJx7JK65w4OEN8gxbmnVWse1W39ua8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZljdhidHBPjOHx4vaVc/lDBxwPndjMJddGA/zaCtEqmWWnJ62t02gGKBA8lcRKYh2FzRiAy/fDm1wQ/grCfGrYzqS4ABkMAFwOAOevAkszVQKUh5FYfTpyRi2R+Ro58SYdB+59AdrzkMM7R5o0WpPLkUyte0FMkbyhvbfDQYYv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cZqGk0jV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cZqGk0jV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 029D2C116D0;
	Sat, 28 Feb 2026 18:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302574;
	bh=olxrGeuxQcvnLjJx7JK65w4OEN8gxbmnVWse1W39ua8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cZqGk0jVb0A7Lb9gwPVNrn+Z/hvsccYo/8lvqf1RqjbQBLNiLRPdPRJI60+iSQH6Z
	 3/nH3Ca0YNdiPjSv2QJiYLVzFAFrtbRCJARnurBa6g1Dvz8glVJenFyRJmWgbfGaju
	 Wex9Ce5Kw9FyoYY2ZhEWGaeZ156EKwNQOAfc2V4SMggYVmRStwHbH5niWznD2i1kIQ
	 t+BEgH31nWpnZDmyLy2YPIbIfVBfk+e0cXob46IYJMOqsZkBE6POxZgdOcCSWS9KEx
	 upk0hY9EoCmOwJmCPMo3Md4sqBVvbgT6STcfjaMNtL0H6OMpGQHWkLP3UGSUfLBVup
	 njySVWGKzO4cA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Hao Chen <chenhao288@hisilicon.com>,
	Guangbin Huang <huangguangbin2@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 082/164] net: hns3: remove the way to set tx spare buf via module parameter
Date: Sat, 28 Feb 2026 13:13:41 -0500
Message-ID: <20260228181505.1600663-82-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Hao Chen <chenhao288@hisilicon.com>

[ Upstream commit e175eb5fb05462398452e31df5019d780badf45d ]

The way to set tx spare buf via module parameter is not such
convenient as the way to set it via ethtool.

So,remove the way to set tx spare buf via module parameter.

Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 6d2f142b1e4b ("net: hns3: fix double free issue for tx spare buffer")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 84c724df2e405..5d410eacce081 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -53,10 +53,6 @@ static int debug = -1;
 module_param(debug, int, 0);
 MODULE_PARM_DESC(debug, " Network interface message level setting");
 
-static unsigned int tx_spare_buf_size;
-module_param(tx_spare_buf_size, uint, 0400);
-MODULE_PARM_DESC(tx_spare_buf_size, "Size used to allocate tx spare buffer");
-
 static unsigned int tx_sgl = 1;
 module_param(tx_sgl, uint, 0600);
 MODULE_PARM_DESC(tx_sgl, "Minimum number of frags when using dma_map_sg() to optimize the IOMMU mapping");
@@ -1044,8 +1040,7 @@ static void hns3_init_tx_spare_buffer(struct hns3_enet_ring *ring)
 	dma_addr_t dma;
 	int order;
 
-	alloc_size = tx_spare_buf_size ? tx_spare_buf_size :
-		     ring->tqp->handle->kinfo.tx_spare_buf_size;
+	alloc_size = ring->tqp->handle->kinfo.tx_spare_buf_size;
 	if (!alloc_size)
 		return;
 
-- 
2.51.0

