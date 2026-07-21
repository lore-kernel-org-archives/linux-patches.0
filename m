Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D887470435;
	Tue, 21 Jul 2026 19:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662873; cv=none; b=gkUn+T0tx1jBylgIF4d8pAbvZKgG07/CWQ14AUqkPjEGN489l4iVEujVpUXSN0D98QwApeySN9nQk5NWpITUMb+NFdMRoWqaZJR8lJIXOId6frBS+QQgBc1xx/KYoXwnUdhZIXDK1Zw0VPdyw78r1+rzpDAfiStLO4Y/EXTbfs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662873; c=relaxed/simple;
	bh=cSPHHdmqJ00Dt+0SWkEv81IZ3syS0mgl5lfBIq6ytF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cuH5HVDY6mFvv7njc214DjzYIYQ1m1WQoRZmnP9K1Vsyya/RDUxXqsAyPPcoZ2dvfuLXri3wgm0bFanHrieoz12ZxyUYBpF3AqQTgj86distI1+RayODQX0FTuWqxLC0AYYi6AIa+DfiQHK3FrZH081i6jJrgxIxq6Ad07owfMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mQ0F7ug0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mQ0F7ug0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C32311F00A3A;
	Tue, 21 Jul 2026 19:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662872;
	bh=1/YA+bYZd1A2RM3y2WfZv2zKij79AV8WzxKeQNUbnwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mQ0F7ug0T2YgoQZOzG1eke0zQWwZXljQSVxtJFipaLWLnN4K2qKmrbmUm2SVmSPLR
	 rNhMLS6M71NPNrRw6NGOog+hqloznjhxxyi/O/ZzE8/qoiv3eIPTRcIm31qzEWvug8
	 fJulTKeCH+yaBAD95BhV5Ghg/hjqHsoWmQFIxBG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geetha sowjanya <gakula@marvell.com>,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0610/1276] octeontx2-af: mcs: Fix unsupported secy stats read
Date: Tue, 21 Jul 2026 17:17:33 +0200
Message-ID: <20260721152459.761031393@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e24accfecb3fb4..53c2a9d6250a7d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -505,10 +505,11 @@ static int rvu_dbg_mcs_rx_secy_stats_display(struct seq_file *filp, void *unused
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



