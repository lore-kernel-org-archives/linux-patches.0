Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD80335FF5F;
	Tue,  6 Jan 2026 17:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721775; cv=none; b=Tbim/ID89ORewlRIqfS5aNcjs6fmbvNUJuQEJCvSFZgPkFEzR/usInXzjoVChDpzg07oNmJsDSq0WQHL3A/6alfensfzmd8+8tc7OXzgZSoEYiH8uqAM0Mizi49JQp6sCfr3s2r+nEXb6fhKGH5xALCVAFUmwe5N1iRP9a8EFPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721775; c=relaxed/simple;
	bh=VwuydnVkqulZp3iC01BkS8tqaZev8/Flz+1QhyKYq8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BLOLgITKx1YZ1wS/PrOc65kpP41vroKrGdMeJZEZjULrDjoy5AIOweclClmYE0hVvxAorFxSJVEVPME/8feeYJCy+NKCwlyGORXYCc0haQ6Q+M0ZMtoQwxs1rdrX+8HrV5ToC+Hl0SNMyTqp8OowoRJXl/lzg/2epwDXgSQhlvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zWf/SOY5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zWf/SOY5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E25AC19423;
	Tue,  6 Jan 2026 17:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721775;
	bh=VwuydnVkqulZp3iC01BkS8tqaZev8/Flz+1QhyKYq8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zWf/SOY51YdJ7Y7CWnDeLvQCU2FAxNrITfP6aV8LQ96gDYBOVS9eOSjD2O5dioUsv
	 +YVLzKIEOW6SjDMz/zoL3cUsi9XA5trhHNK0JsFSI673nTnJIjqhB8PU/vwyT9uPwD
	 /8BCVKkn7RhzU3QaHvS9cT5SGpfn9xH3Uzv8lK+k=
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
Subject: [PATCH 6.18 069/312] RDMA/efa: Remove possible negative shift
Date: Tue,  6 Jan 2026 18:02:23 +0100
Message-ID: <20260106170550.346299482@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 22d3e25c3b9d..755bba8d58bb 100644
--- a/drivers/infiniband/hw/efa/efa_verbs.c
+++ b/drivers/infiniband/hw/efa/efa_verbs.c
@@ -1320,13 +1320,9 @@ static int umem_to_page_list(struct efa_dev *dev,
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



