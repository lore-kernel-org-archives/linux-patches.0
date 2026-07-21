Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C90BF33A9FC;
	Tue, 21 Jul 2026 20:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666626; cv=none; b=awYW9UJMC3Tj7jrJOgcJK9loaw7hsZs5GUxm+8M8xziZqogv0jWRqwjApAIeUcaLnMlWajr4fkiHsx4FavjYQjAIKzIOiktnwJG1AnVU0sL9ZVLBbPG550EAhNilcqvY4Dgy8Q4RcpDlPSXTMJ+EOP5Eaeowh3Vtyk49QgKWbLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666626; c=relaxed/simple;
	bh=E5xMU3xF7tfBLXFvLMtvah9/llEDjEv5Cc3S9+4wVoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=keI9KMlFBr9xLHv+M0OSRMjQ7aEci/ME7H8S4JvIXf+IOpmHd8eAn4m8Ef1qBvVsNZxBKIWR5TaCdA0G4xagdLxpegnPn7aJLuHxtEWoPskfJFEIJnIGKkYdBivOSwdRbCOxJxv2h/wA+LmfUSy5eTuEUQ1Vo1p0Wh2J44x3qUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ru/8/3U1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ru/8/3U1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B3061F000E9;
	Tue, 21 Jul 2026 20:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666625;
	bh=48O7RoB/uDMZTCkxMq9Z3e+vi8nFWLQUymmanJotbGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ru/8/3U185ze1DwrOm0EFUbzqBzA1RpmYlwGrEO4ZobvwFsOxS3yzBRLZvvE0IVhE
	 hNBWi0K6xxn4l9S/t04pftQVliV1fi9RANI1OkACAiTmkkHlMqVOB+7uw1vB2cVoN9
	 qPLNVof9W5dtr/f562jPvt8+09b4TnhQ/FLS6Z/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geetha sowjanya <gakula@marvell.com>,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0754/1266] octeontx2-af: mcs: Fix unsupported secy stats read
Date: Tue, 21 Jul 2026 17:19:51 +0200
Message-ID: <20260721152458.742195134@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
index 56dab11833b533..285ae29396342a 100644
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



