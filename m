Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70B0646DFFD;
	Tue, 21 Jul 2026 19:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660969; cv=none; b=gKA+WXnDi3bYOgY6OKthY9vrjni8UfIgYslGiPfMc9wCWebGrRd0tBK3ImgcGiIw3W0sMOBwHD2fPjI99EhH1V1p4RJpAFibJ+8bynpvYmzXzuiFb+AqAynrVHu6jAbDqMuHCCdhQl3Czas5hr0NHO5CmHbJ+mgAjnyTICKMO54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660969; c=relaxed/simple;
	bh=iEGyDISxGZMx2MUXoJSnHbm5PRfRwSTTF+adaEr7nz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jxi4+XiiWGskZ0avVKvsGR1o3hv9jfUitfr1mepV9I048HN3mAwjOCTKwPOuJUdbuFcgCtwDQn3mbwmYVPb5vwuSBczJvh9Aew2dHXJ105d+YiECH5z0zpiQ5QlgRDiYM44h8gqo85AtQVMIbJyaoPZCYrUIKPU46saLkY8Na98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EbZqHqXw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EbZqHqXw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D77DC1F000E9;
	Tue, 21 Jul 2026 19:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660968;
	bh=LdIDZ50YKYcgMJC1WS/DUsR4UbZgVUxBtZgI9pESV6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EbZqHqXwVK1Ny3HOxHy7R23webFUzqWficHMxvj+iSEaDgq4OWebKdj57KuN8nnfk
	 G2oACcjM7uqpXQrUUPpFEPLQAjtfKtKMMDXmzYrtbwVlSp7hhzlI/nAVSsp6VCHmqk
	 GolMb4HNaN68tfaDlx2/MSqSd1jznML+4KBRYuKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geetha sowjanya <gakula@marvell.com>,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1180/2077] octeontx2-af: mcs: Fix unsupported secy stats read
Date: Tue, 21 Jul 2026 17:14:13 +0200
Message-ID: <20260721152620.651251248@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geetha sowjanya <gakula@marvell.com>

[ Upstream commit d4b7440f7316e76f013f57d8b6da069a1b9c34e7 ]

Secy control stats counter doesn't exist for CNF10KB platform.
Skip reading this respective register for CNF10KB silicon while
fetching secy stats.

Fixes: 9312150af8da ("octeontx2-af: cn10k: mcs: Support for stats collection")
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Link: https://patch.msgid.link/1781636420-19816-1-git-send-email-sbhatta@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/mcs.c         | 6 +++---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c | 3 ++-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mcs.c b/drivers/net/ethernet/marvell/octeontx2/af/mcs.c
index c1775bd01c2b48..a07e0b3d8d0006 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mcs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mcs.c
@@ -120,13 +120,13 @@ void mcs_get_rx_secy_stats(struct mcs *mcs, struct mcs_secy_stats *stats, int id
 	reg = MCSX_CSE_RX_MEM_SLAVE_INPKTSSECYUNTAGGEDX(id);
 	stats->pkt_untaged_cnt = mcs_reg_read(mcs, reg);
 
-	reg = MCSX_CSE_RX_MEM_SLAVE_INPKTSSECYCTLX(id);
-	stats->pkt_ctl_cnt = mcs_reg_read(mcs, reg);
-
 	if (mcs->hw->mcs_blks > 1) {
 		reg = MCSX_CSE_RX_MEM_SLAVE_INPKTSSECYNOTAGX(id);
 		stats->pkt_notag_cnt = mcs_reg_read(mcs, reg);
+		return;
 	}
+	reg = MCSX_CSE_RX_MEM_SLAVE_INPKTSSECYCTLX(id);
+	stats->pkt_ctl_cnt = mcs_reg_read(mcs, reg);
 }
 
 void mcs_get_flowid_stats(struct mcs *mcs, struct mcs_flowid_stats *stats,
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index fa461489acdd65..ca2704b188a5cf 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -482,10 +482,11 @@ static int rvu_dbg_mcs_rx_secy_stats_display(struct seq_file *filp, void *unused
 		seq_printf(filp, "secy%d: Tagged ctrl pkts: %lld\n", secy_id,
 			   stats.pkt_tagged_ctl_cnt);
 		seq_printf(filp, "secy%d: Untaged pkts: %lld\n", secy_id, stats.pkt_untaged_cnt);
-		seq_printf(filp, "secy%d: Ctrl pkts: %lld\n", secy_id, stats.pkt_ctl_cnt);
 		if (mcs->hw->mcs_blks > 1)
 			seq_printf(filp, "secy%d: pkts notag: %lld\n", secy_id,
 				   stats.pkt_notag_cnt);
+		else
+			seq_printf(filp, "secy%d: Ctrl pkts: %lld\n", secy_id, stats.pkt_ctl_cnt);
 	}
 	mutex_unlock(&mcs->stats_lock);
 	return 0;
-- 
2.53.0



