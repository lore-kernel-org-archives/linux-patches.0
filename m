Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57F203D1CA9;
	Thu, 15 Jan 2026 17:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499622; cv=none; b=DyLuz5ciUJ1ngSMOC0//sn+tKTgOoAwNAUfvcuJrplKvYJ4cVXqURT9D6mCp+jalsQQ9GSV4/WoEGBASLx+J3BJ7cCAeb9FrCXe9IVeT9ynEWebErha7YxN5xhOKAD5VAYKJtJZIPgmSvm5Pkg/FHFLFfshK3IgM67bd9fivX/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499622; c=relaxed/simple;
	bh=FGuS+zxAcxkBDycBcjFb5jaMW5CcmSDDRP4ZFshPQ80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hPeBWD4kgfaaazwkP1vrLOounOxa7Bi1K9P8ZngVcHB23aRuU5LYZLJNQU1mvKcE9WOIpLdPlS6BS1JQyii+YbqNWeu9WPeKYBhabwdISaZa+n+60yxoqz5sqN6KqAHdellZDLfrl9pnvwwuJ70MGITHZOVDlAlxw2tWfajKatw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uNWWjL3u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uNWWjL3u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2BD6C116D0;
	Thu, 15 Jan 2026 17:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499622;
	bh=FGuS+zxAcxkBDycBcjFb5jaMW5CcmSDDRP4ZFshPQ80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uNWWjL3uupAsm69kY1kCd6F4AYA7IqbsPkENeCZ5ZO1yeAmv8Rue6sp45etWyQKDC
	 BooQG5bXf8xOLO9/6THrGqL0rlDgFAWQHu9oycITDh3yjt2kUok8GKhesPY5xj9DH2
	 pUBJwYogEGAIFBNdQfneUNNY/b7WPNMAqS+sHlSI=
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
Subject: [PATCH 5.10 291/451] RDMA/efa: Remove possible negative shift
Date: Thu, 15 Jan 2026 17:48:12 +0100
Message-ID: <20260115164241.408944320@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 9cf051818725..d7fccffeeb58 100644
--- a/drivers/infiniband/hw/efa/efa_verbs.c
+++ b/drivers/infiniband/hw/efa/efa_verbs.c
@@ -1145,13 +1145,9 @@ static int umem_to_page_list(struct efa_dev *dev,
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



