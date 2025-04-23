Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C4F27FD5B;
	Wed, 23 Apr 2025 14:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419729; cv=none; b=g3TSLDICaeChDhPLPO7WbVdknOC3ClKJYqUfuIGuOZoFLqQ+Fl52A7lUScf3K2eZiEJGiuLkckHkCtFCnThkuDUiLTKuVyLtFHQLhs80ZPDf0AyX/J+ZwKhEnn17ObMfwOvaNnnoXVC/egX4nON16b+s/0nTcQymwirSqMvLq/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419729; c=relaxed/simple;
	bh=mHVgr6uPtwCV57zu6StomSpIbHky9K2Ul6J1BR6b+ws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SLAqCSysyMUD+GKssl3lnl39AyHhbMLxwUYw3WMKZ1hkKYIqhTUnudovj5W7kYU2vNToyJM4im3LM37AQpcruAQNPT3FBaqjBz+PjgZBitvqHP9Js6cV2dwYv+auYbcUEv15QyQZHwisgNi/agApl1SFIITVOa7bfJz9bazO+HM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jpFX8uz4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jpFX8uz4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E7DCC4CEE8;
	Wed, 23 Apr 2025 14:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419728;
	bh=mHVgr6uPtwCV57zu6StomSpIbHky9K2Ul6J1BR6b+ws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jpFX8uz4x8evqJNLoFANvTNrGclpRxcwyDYBcFaiwU/Kv/aBAEIhyDVXFtkNCw4/u
	 3lahPaeN9l59Im+3FdjImpeEV/g4lWL1zPSazuJkXE/9dmH/RL/jpTcHwZckLyZEJK
	 zyoYjuE+WjS3P2P5puXQ6ewgjqDsTM6d0TjfchvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 017/241] RDMA/hns: Fix wrong maximum DMA segment size
Date: Wed, 23 Apr 2025 16:41:21 +0200
Message-ID: <20250423142621.221794247@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengchang Tang <tangchengchang@huawei.com>

[ Upstream commit 9beb2c91fb86e0be70a5833c6730441fa3c9efa8 ]

Set maximum DMA segment size to 2G instead of UINT_MAX due to HW limit.

Fixes: e0477b34d9d1 ("RDMA: Explicitly pass in the dma_device to ib_register_device")
Link: https://patch.msgid.link/r/20250327114724.3454268-3-huangjunxian6@hisilicon.com
Signed-off-by: Chengchang Tang <tangchengchang@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index cf89a8db4f64c..8d0b63d4b50a6 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -763,7 +763,7 @@ static int hns_roce_register_device(struct hns_roce_dev *hr_dev)
 		if (ret)
 			return ret;
 	}
-	dma_set_max_seg_size(dev, UINT_MAX);
+	dma_set_max_seg_size(dev, SZ_2G);
 	ret = ib_register_device(ib_dev, "hns_%d", dev);
 	if (ret) {
 		dev_err(dev, "ib_register_device failed!\n");
-- 
2.39.5



