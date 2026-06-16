Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26E633688F;
	Tue, 16 Jun 2026 16:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626678; cv=none; b=uyLnmCZnloP+BtRgodk/7JUyrZuwfPblYrXhXBtswatIigo1eN4Yy7Z9CqgkoxuT217P8tP8BRpcPKs0ebmvzgPrunCnxwncUwgWwTyVl80Vg8mm6F5FvzC5AvHB5F/bUdFlhWdKDca+1bAyKbnbqMRetB/RJe1Nb+GMqHdLPXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626678; c=relaxed/simple;
	bh=aXAZKKLutXuCF5yp1a5qyKuvMFd5ET58nG6z9Bk4ao0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HljyDusY5kg2XhLvxFJZV9noFNMQFO1KhDZuDaQTAFH27tP2MckrW6N/5IWPQLsJhDhYNbgwpEDyvkP3zLNiZ5VEE/DJTcB2qHYyauF1EwKOy4Qo6zH0fXEU0W3ZZuWZ5zjxsmw5PcdQ53hRQzWvOLJhu/Y6vRQb3gAMMY7/WVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=izzpI/Ca; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="izzpI/Ca"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A48441F00A3A;
	Tue, 16 Jun 2026 16:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626677;
	bh=Nb90gMDPD8XTTW5RRmaS2jdjEOzScbEwDstsVc3QU9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=izzpI/CaiC9x8hxJPGYIN+K5nM8lGbw4cO8ibm7+Vdsw4QMhdgUW2JtYhuYi3fzO8
	 j1J1TapM7VJlqNc8nO9LYX03RUtCZY6TFqi/MGs3iBLYL4euJMmd8DbYEaV86Ehvvt
	 DNpPwMyO+FVo8Fr/l/RAJ8x1uzTwpgYXEfYpOr2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suman Ghosh <sumang@marvell.com>,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 048/261] octeontx2-af: Fix initialization of mcams entry2target_pffunc field
Date: Tue, 16 Jun 2026 20:28:06 +0530
Message-ID: <20260616145047.399732077@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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
index e3038a912a5805..3e03f85bf362cb 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -1944,8 +1944,8 @@ int npc_mcam_rsrcs_init(struct rvu *rvu, int blkaddr)
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



