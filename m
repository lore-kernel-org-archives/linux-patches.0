Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EB242D0C99;
	Tue,  6 Jan 2026 17:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720750; cv=none; b=OvcHPUxfLQKmCLGPBoVmtJUHdP0YBoSvk6ocz3X9Irn08K3hLteYkAeI/TzR5MgtFyvjio0+BSfQ/2ny4XbfCmdpaP1BP0zdPuSAzstwfIVBXoycbL7LhrpONHHFstIN2UWsRcNgOXQgBiwhSdGekg+xj6h31w9cNUP7eC5VnHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720750; c=relaxed/simple;
	bh=u00CNoqZ9sl2QtEqisvW6Y2o5bS5WAYXLfpZZmQLTx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gXjz/fyMtoFVl+aArvCrP3b8bhcFQpLm35TdT1h/mJmlOxgsUjm+/3EgEpEQMRAtI2AgN7e7Bmz650tv6LovhvXwJjr8pSXjqsVMqWhyBO2SdHpR1UaHM5h/dG7nfmQDJOo69h6AzTTjbjhE0kFHfy7zV7NYrIWWGQg4ujPwbk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YArUdhJY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YArUdhJY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2EC7C116C6;
	Tue,  6 Jan 2026 17:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720750;
	bh=u00CNoqZ9sl2QtEqisvW6Y2o5bS5WAYXLfpZZmQLTx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YArUdhJYTX4WN/FxwNre+iBksdOtUSZkXQ9Wob44eIXdjpLltygJqX/BgAd/dxJpE
	 xCQE1KDzlpUzFxSnGOzYzjeniRNOZRlo/4g9CbhXj69p+BYGUjLJy5G0NfHmNPLvMS
	 yPlDEZ01wAEUMlmJvIeRey8q4XZ3PwKLk9izLojo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Sela <tomsela@amazon.com>,
	Yonatan Nachum <ynachum@amazon.com>,
	Michael Margolin <mrgolin@amazon.com>,
	Gal Pressman <gal.pressman@linux.dev>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 331/567] RDMA/efa: Remove possible negative shift
Date: Tue,  6 Jan 2026 18:01:53 +0100
Message-ID: <20260106170503.577103022@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Margolin <mrgolin@amazon.com>

[ Upstream commit 85463eb6a46caf2f1e0e1a6d0731f2f3bab17780 ]

The page size used for device might in some cases be smaller than
PAGE_SIZE what results in a negative shift when calculating the number of
host pages in PAGE_SIZE for a debug log. Remove the debug line together
with the calculation.

Fixes: 40909f664d27 ("RDMA/efa: Add EFA verbs implementation")
Link: https://patch.msgid.link/r/20251210173656.8180-1-mrgolin@amazon.com
Reviewed-by: Tom Sela <tomsela@amazon.com>
Reviewed-by: Yonatan Nachum <ynachum@amazon.com>
Signed-off-by: Michael Margolin <mrgolin@amazon.com>
Reviewed-by: Gal Pressman <gal.pressman@linux.dev>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/efa/efa_verbs.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/infiniband/hw/efa/efa_verbs.c b/drivers/infiniband/hw/efa/efa_verbs.c
index cc13415ff7e7..46eddef7a1cc 100644
--- a/drivers/infiniband/hw/efa/efa_verbs.c
+++ b/drivers/infiniband/hw/efa/efa_verbs.c
@@ -1241,13 +1241,9 @@ static int umem_to_page_list(struct efa_dev *dev,
 			     u32 hp_cnt,
 			     u8 hp_shift)
 {
-	u32 pages_in_hp = BIT(hp_shift - PAGE_SHIFT);
 	struct ib_block_iter biter;
 	unsigned int hp_idx = 0;
 
-	ibdev_dbg(&dev->ibdev, "hp_cnt[%u], pages_in_hp[%u]\n",
-		  hp_cnt, pages_in_hp);
-
 	rdma_umem_for_each_dma_block(umem, &biter, BIT(hp_shift))
 		page_list[hp_idx++] = rdma_block_iter_dma_address(&biter);
 
-- 
2.51.0



