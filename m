Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C715B43E075;
	Tue, 21 Jul 2026 22:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672198; cv=none; b=BM8osFu8WIruug3gqeQM/n1f29PP41DgUiOVp3p6BwrS57OFHbWOe3VUq97ZKirW/2uVyvXmT5ZcIYlaU8nckZCVshsadP/3XLI2oJXxtRvl342/ULdHVqAdR422xJg1qihBFI22o6XmIKN0HLvPM+4mYNDuLnAmxapNivVd+kM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672198; c=relaxed/simple;
	bh=LRcvEPqtNhTCWxHpSVPXk8+GlWbZ8yRWsLQ2mqzZuOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ur5qf1xe7VhHiJ6jf7DyofOYb/eao0/wi5/6aQLdwM1eifXq3+mjEdCJp9oI3EH+PEQcB8zRkKf5a8YL/6oeK6oAs8bSQBJkpzjfTnblnSfUeMrKnDGtQxSFoym5DvMHISqGhXbAow3lg6dFaJC4mqXERFaUj2cn2Ny0WtsZoaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wbEqzHCB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wbEqzHCB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 380F51F000E9;
	Tue, 21 Jul 2026 22:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672197;
	bh=ZovoiwqldwiIiNLoRPblTwBsyHBNKYRuKAyR8bWZLqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wbEqzHCBypoWN61XPIgD6ZtZjHQHoXHh8v3R/sAN9EJBRWIWBXNyZqNLyudFjv9A+
	 fjF0Ewn2yQR8dTacs6EypAE/1VIr/d0YkkiVgxFQPD5g+u1l/Wh6qb5NaV/EO4omTm
	 GDTucUjtgMSOj0Bx/WKiB/CCTRd0ycu8XIeYwlSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rakesh Babu <rsaladi2@marvell.com>,
	Sunil Kovvuri Goutham <sgoutham@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 532/843] octeontx2-af: debugfs: Add channel and channel mask.
Date: Tue, 21 Jul 2026 17:22:47 +0200
Message-ID: <20260721152417.998618419@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rakesh Babu <rsaladi2@marvell.com>

[ Upstream commit 9716a40a0f482b91af485b1130cca19441243177 ]

This patch is to dispaly channel and channel_mask for each RX
interface of NPC MCAM rule.

Signed-off-by: Rakesh Babu <rsaladi2@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 235acadd3105 ("octeontx2-pf: check DMAC extraction support before filtering")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/npc.h         | 4 ++++
 drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c | 2 ++
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c  | 3 +++
 3 files changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc.h b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
index bac083c5c27854..857b8b85f550c1 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
@@ -8,6 +8,8 @@
 #ifndef NPC_H
 #define NPC_H
 
+#define NPC_KEX_CHAN_MASK	0xFFFULL
+
 enum NPC_LID_E {
 	NPC_LID_LA = 0,
 	NPC_LID_LB,
@@ -598,6 +600,8 @@ struct rvu_npc_mcam_rule {
 	u8 default_rule;
 	bool enable;
 	bool vfvlan_cfg;
+	u16 chan;
+	u16 chan_mask;
 };
 
 #endif /* NPC_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index e201827529513c..a3dcb013f22de8 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -2484,6 +2484,8 @@ static int rvu_dbg_npc_mcam_show_rules(struct seq_file *s, void *unused)
 				seq_printf(s, "VF%d", vf);
 			}
 			seq_puts(s, "\n");
+			seq_printf(s, "\tchannel: 0x%x\n", iter->chan);
+			seq_printf(s, "\tchannel_mask: 0x%x\n", iter->chan_mask);
 		}
 
 		rvu_dbg_npc_mcam_show_action(s, iter);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
index 750aaa1676878e..64654bd1188459 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
@@ -1112,6 +1112,9 @@ static int npc_install_flow(struct rvu *rvu, int blkaddr, u16 target,
 	rule->default_rule = req->default_rule;
 	rule->owner = owner;
 	rule->enable = enable;
+	rule->chan_mask = write_req.entry_data.kw_mask[0] & NPC_KEX_CHAN_MASK;
+	rule->chan = write_req.entry_data.kw[0] & NPC_KEX_CHAN_MASK;
+	rule->chan &= rule->chan_mask;
 	if (is_npc_intf_tx(req->intf))
 		rule->intf = pfvf->nix_tx_intf;
 	else
-- 
2.53.0



