Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D9342DA53;
	Tue, 21 Jul 2026 19:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662529; cv=none; b=jSOsDDfm/UjCB+E6VrDGtZ3jIHf67YLj8F4UxQbyS1U6f8FjEzEAkliydav0apZXdnM58Npfsze3kc8ThpmA8TuiSKjl9PkwYsccSr4cYWoh+KqPCqGwQ6ALgj3n7EvtVdnKQFKzvFpHdQRkzTkIUFN6ZQqznVhzcKDkKwZrmog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662529; c=relaxed/simple;
	bh=BOuIxSy/5PQq/eWXuLJHzFAOuM+Bv/UAiIpmXnV/m6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H1mUORndBLWkhBC8kwj7xZKM9HNptic+T2ogZRMH6aBioZkDXtLzYhmzhmDJzdwKbT31452yezhavCzQ5c9AEIrb9NvD3w9BGkc8Ya86TMHwUDtH7bEiJVlGNtNNyL2ek/I7YDa9/+oBKcxvC4yDWGxB6L76cRoO/b2xQZj1V+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ICUftEpS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ICUftEpS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7C431F000E9;
	Tue, 21 Jul 2026 19:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662528;
	bh=SLhwGgLjhcNX5KDUQNKGqbaa+TLQKvcDMIkwK4B3ziA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ICUftEpSnztNKcCphyaCGraa5SHYHzir/8DpKLin5mpNsKYaOHW86gmGs59xO4yZH
	 aIqZAztCvE1YL5wEnkCGid9rs8sUo1B8rUrV0YwxiJsDfaIwK/w+rl4QEgNq1H81yg
	 tcq4VsG8QbtY3zyBuONsJBuoAWa/hntTyn7Bv4b0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0479/1276] dmaengine: dma-axi-dmac: Properly free struct axi_dmac_desc
Date: Tue, 21 Jul 2026 17:15:22 +0200
Message-ID: <20260721152456.823107532@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuno Sá <nuno.sa@analog.com>

[ Upstream commit 4910ce1b3b35687bb2a5e742c4bfbea3c647c980 ]

Use axi_dmac_free_desc() to free fully the descriptor at fail path when
call axi_dmac_alloc_desc() in axi_dmac_prep_peripheral_dma_vec().

Fixes: 74609e568670 ("dmaengine: dma-axi-dmac: Implement device_prep_peripheral_dma_vec")
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260424-dma-dmac-handle-vunmap-v4-2-90f43412fdc0@analog.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dma-axi-dmac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/dma-axi-dmac.c b/drivers/dma/dma-axi-dmac.c
index 47d95d2d743b1b..9daa1c69ae917f 100644
--- a/drivers/dma/dma-axi-dmac.c
+++ b/drivers/dma/dma-axi-dmac.c
@@ -643,7 +643,7 @@ axi_dmac_prep_peripheral_dma_vec(struct dma_chan *c, const struct dma_vec *vecs,
 	for (i = 0; i < nb; i++) {
 		if (!axi_dmac_check_addr(chan, vecs[i].addr) ||
 		    !axi_dmac_check_len(chan, vecs[i].len)) {
-			kfree(desc);
+			axi_dmac_free_desc(desc);
 			return NULL;
 		}
 
-- 
2.53.0



