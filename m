Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5607C359F8C;
	Fri,  9 Jan 2026 12:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960822; cv=none; b=jC6kV1S3P6a0SjTcVuqnnUOC8p0HcWL5XuIDp+sd3Hd0tMIJ39lSgupvfDZUIm9hSRjXFrQ+UIbUgVSE9Vl3tFzisxF5JYFJjhs2gLOK4EHOhvLg7ZyqTCpyNbUzpZ9DUX0RPxdjnstdCnF4npp5mFrPQcpLpRDTrgFOg1yloAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960822; c=relaxed/simple;
	bh=JeZdNnFZJMFj6fMz+VpYR4TyuSMpyFPjoeWl8qzi2jo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pE8By3TK9GsG0Mi0W6HYcZDqcDgjgKzFYTwSfbYdy05OtU0hJdyzYvNE/Mw3AEanFFKDZKJ8US86HJkqsE25mO0dVhvttHyn3AjqftAUxSLkdtU3GMqhhbuH1UkTaGabnz+X68/YGVwBSkyBAtGxW1xbiZioxuRTlmacDem5vaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=otIE8mxg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="otIE8mxg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D53C7C4CEF1;
	Fri,  9 Jan 2026 12:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960822;
	bh=JeZdNnFZJMFj6fMz+VpYR4TyuSMpyFPjoeWl8qzi2jo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=otIE8mxgHr9fHwy+6qjm86qFxWWDfPaMH6BSMCzyvlSDvjYGXdpJfkNRGFCvoXxa1
	 WNEFoBTHT9+4ycwbMCFpbhx5rWf8eDtwpOjn9e7tNM2pEjoOzifQ3hUne8673mH2wS
	 i8kqmBHyB4MMEieOehd1KopcV9fmTAySjvigdfcc=
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
Subject: [PATCH 6.6 530/737] RDMA/efa: Remove possible negative shift
Date: Fri,  9 Jan 2026 12:41:09 +0100
Message-ID: <20260109112153.934093727@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0f8ca99d0827..2a5b93ef4b33 100644
--- a/drivers/infiniband/hw/efa/efa_verbs.c
+++ b/drivers/infiniband/hw/efa/efa_verbs.c
@@ -1224,13 +1224,9 @@ static int umem_to_page_list(struct efa_dev *dev,
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



