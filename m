Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC19C35DA75;
	Tue, 16 Jun 2026 15:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624937; cv=none; b=dg1N8wd6z+vb2K2rm2Kzy9+1GBzDQal1CPqPde/5a5NrqSos/WrhI+rOP2LKzO4hL+s+e80N8q2AIBv9FglAFVSY6viVt8OnCwWPFSfGGp64xKcZLzLZJNwaqcmh1MCG0Z5VUoaUJhRu0dFasJj12ePeLtZ2Mx1ZoZ2m3rRS96E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624937; c=relaxed/simple;
	bh=tzFVCqKq+40BoxrHVhn57pqh6nlVcQ/W2jNffhbU9NU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qf9N0bKZqNIG8qgT+HuiJPEktvRLoU2qY670rRTb8utAp9iaL2yPIqEt5npYQqZr8+gX+Lr6S2z+rDEHSvn6bLx9aulmt+t76cGLuL722JrUV9//2AG1mR0Tf3TmBvxWWT7h5up+bV6BEIR0etXMzBrd7vV5cQ1MR3rKPW/p1Bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OGyQuxm6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OGyQuxm6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CE021F000E9;
	Tue, 16 Jun 2026 15:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624936;
	bh=BhG4GAw7vL2UJiHOf88IzgyF4EsnsObu4y/AAKa+T3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OGyQuxm6wUlqZ5sMNduQr5FnKpw9/MGPrjv/rG23pRlF5PWhbTwYnaMpe2mn1jR3X
	 A+MM8bGyVGNEEV2JIDmXXDKZxiVSvjPaWDRiiZMtM4yp7bC0AgQARuYaczgAMnLj5G
	 s/Jhv6bS0rFLRkpC26LK9rqyHc2zkijwi9bNRKxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suman Ghosh <sumang@marvell.com>,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 054/325] octeontx2-af: Fix initialization of mcams entry2target_pffunc field
Date: Tue, 16 Jun 2026 20:27:30 +0530
Message-ID: <20260616145100.389181154@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

From: Suman Ghosh <sumang@marvell.com>

[ Upstream commit 9a85ec3dc28b6df246801c19e4d9bae6297a25b0 ]

NPC mcam entry stores a mapping between mcam entry and target pcifunc.
During initialization of this field, API kmalloc_array has been used which
caused some junk values to array. Whereas, the array is expected to be
initialized by 0. This patch fixes the same by using kcalloc instead of
kmalloc_array.

Fixes: 55307fcb9258 ("octeontx2-af: Add mbox messages to install and delete MCAM rules")
Signed-off-by: Suman Ghosh <sumang@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/1780054625-17090-1-git-send-email-sbhatta@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index e28675fe189071..a0d2ed56186d8d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -1932,8 +1932,8 @@ int npc_mcam_rsrcs_init(struct rvu *rvu, int blkaddr)
 		goto free_entry_cntr_map;
 
 	/* Alloc memory for saving target device of mcam rule */
-	mcam->entry2target_pffunc = kmalloc_array(mcam->total_entries,
-						  sizeof(u16), GFP_KERNEL);
+	mcam->entry2target_pffunc = kcalloc(mcam->total_entries,
+					    sizeof(u16), GFP_KERNEL);
 	if (!mcam->entry2target_pffunc)
 		goto free_cntr_refcnt;
 
-- 
2.53.0



