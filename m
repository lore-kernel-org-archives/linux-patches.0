Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26BC6251783;
	Tue, 29 Apr 2025 17:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946906; cv=none; b=BTqW5bBqmh7JrdicjiU8o7fAUO5rYR8mX6nPM7JwfcPNWUiZ4HhLpk+6bGOC/MIlzJRprl9jTr2FNVDZbHl9e4XQIfHwwp3bLVDJy6cyuXb8K1n+yLdcGv4prkgltcDfQ1QV7R6b/ZJhWKZI4qZdWs544ZPEESlAg9wG6S7sX+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946906; c=relaxed/simple;
	bh=O5u2oNX6UaQRcmTj2Nx2k3mhJAZgThx7FSVQiT4Pmf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MGW8l7Zju6ki/VTFBNHFPyKo6TrMbp2wwVB7abTSXLP58DvhzXBfqTHHTty7XcCaYPTi++C0U27iX1ZyHYNwrs/en5avrEHV6v6OIjKcfL81uo1qJYHw+AR4uYGSqgtIYrwvncPxJsu5XTNNL/keQzRdddnI7bo6nn5mJO0qxyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rjww0kEH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rjww0kEH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71CDCC4AF0C;
	Tue, 29 Apr 2025 17:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946905;
	bh=O5u2oNX6UaQRcmTj2Nx2k3mhJAZgThx7FSVQiT4Pmf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rjww0kEH++F8/v3r+dOHRQW57pTD/l1fvgdn0NiDpp1hcnqaHUrb3zsMgivmHjW0U
	 Xct1igXT9KEjvVdxZcRjsyH47aeQ/JSNbJg3HE/O+tbRK9Q6H3ELLgqlu3Z92UFgL2
	 z3DtdxP/kaI5Kp2DlqcEROCroToewbwg9kpRM5IM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 108/286] RDMA/hns: Fix wrong maximum DMA segment size
Date: Tue, 29 Apr 2025 18:40:12 +0200
Message-ID: <20250429161112.301108272@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f520e43e4e146..3c79668c6b3b5 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -552,7 +552,7 @@ static int hns_roce_register_device(struct hns_roce_dev *hr_dev)
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



