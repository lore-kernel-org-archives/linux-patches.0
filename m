Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3348A43DA3C;
	Tue, 16 Jun 2026 15:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781622933; cv=none; b=BZYIZ2sBj99loMNMSmZiGjdB9EHQQDbZ9EwKZEIPNzWK6xUaHkasNRVo+M3W4RB3XmtgZFLESztSJmMUiaCNHIg+ja5vLIe7Jy02hartiPhSqZA1y6SHnKvx1qGxUdHNicqoqIkwCu/tESLBxOSdSJH6QS6E5+nglAS2WjCzDaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781622933; c=relaxed/simple;
	bh=cVTHkPT9oZhRMjvbOsRl+9CTBM/kbJ7HVtUZpgZw0x4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mv9e1SkhZBui0LPaexAPzY7OzDrO66Ibzs/135+OFa0gkQUVxipW8z6SlYlX+NieYc3aV/BFra8wohv50EsIB2mBD33Be39rAAH3lFCEGloIOhSapuTr+fQ1MkIbREER91Lm8erfxiL2ZrwSpIhSCz1JEEmLUadrjpDV0ypOOpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hkvb67Sp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hkvb67Sp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9A231F000E9;
	Tue, 16 Jun 2026 15:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781622931;
	bh=T7jgZVU8zaVXCzfZ76fDicieGUIfMc+19aqWzcwaEG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hkvb67SpXKOsh7hBM+tUMy6+nCC5xqqa+5a7/wVoY0kaBwFs0ooetMOV/1aNcBN8j
	 waXJiw4hJdlp/iD8GSrctE7z3QimDohlCFrcqN+M8QAlgJ0Fg0zX5zEJJpdP39qqa6
	 0CcU5D9M+wkmaS7rIEVremuu2JSWrziC6Y4pSMI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suman Ghosh <sumang@marvell.com>,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 056/378] octeontx2-af: Fix initialization of mcams entry2target_pffunc field
Date: Tue, 16 Jun 2026 20:24:47 +0530
Message-ID: <20260616145112.919258439@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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



