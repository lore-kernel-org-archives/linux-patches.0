Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4581581F4;
	Tue, 23 Jul 2024 18:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721760205; cv=none; b=S6GieM7H8/BZRopnNQq+b54sDEuxpGNi/uxUNqxpwv0WA36EzREU5KRii6sWsiPBGq1QpOvmlzQwoaRjgd5i1MXAb5pmaCf6hrllTLkihXDdLczlwpG9xrMG3o41FdD6vzUwLk2TtO6RPrZ0RAFSyIIw+4arqgaLsUqz3JcF7YU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721760205; c=relaxed/simple;
	bh=cOIkqL0SAKEwAJ0JRvXYmB86Y+XJwOUmLpO4V9cwpgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aS1XWqn0eSmU/X9eaJInJBLXUSuQ+BWTnS2+THe0HM583vIGpoEhNpvH4jGPsHtCSru1iGbgu2xWZr02ILYVKxodJkZ2H8yhxOpohy4CZS7TfaC2AR7D3g4+X7xe1xurpd8PhuxH/d8ndN+vJk2Ky4/mHalQV9zlOLX/Nk18RO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=odBAbNFJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="odBAbNFJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74390C4AF09;
	Tue, 23 Jul 2024 18:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721760204;
	bh=cOIkqL0SAKEwAJ0JRvXYmB86Y+XJwOUmLpO4V9cwpgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=odBAbNFJ2OvPEcpiHhQsn6R8sJw6rakmTCJnv5+BBg7rvAmNTlSjXpBm/44tIYRT7
	 xo47DGmYdIa9Xap6E4+SxDvDTFqd8XfcCK+5Sun6v7+XpF26I2JdwRpRzxDT7NnvF5
	 GXVWmCjQ7Fr10fklEPdubcHH8QKLGiiGlO9oknk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Suman Ghosh <sumang@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 107/163] octeontx2-pf: Fix coverity and klockwork issues in octeon PF driver
Date: Tue, 23 Jul 2024 20:23:56 +0200
Message-ID: <20240723180147.608530389@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ratheesh Kannoth <rkannoth@marvell.com>

[ Upstream commit 02ea312055da84e08e3e5bce2539c1ff11c8b5f2 ]

Fix unintended sign extension and klockwork issues. These are not real
issue but for sanity checks.

Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
Signed-off-by: Suman Ghosh <sumang@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../marvell/octeontx2/nic/otx2_common.c       | 10 ++--
 .../ethernet/marvell/octeontx2/nic/otx2_reg.h | 55 ++++++++++---------
 .../marvell/octeontx2/nic/otx2_txrx.c         |  2 +-
 .../net/ethernet/marvell/octeontx2/nic/qos.c  |  3 +-
 4 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index a85ac039d779b..87d5776e3b88e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -648,14 +648,14 @@ int otx2_txschq_config(struct otx2_nic *pfvf, int lvl, int prio, bool txschq_for
 	} else if (lvl == NIX_TXSCH_LVL_TL4) {
 		parent = schq_list[NIX_TXSCH_LVL_TL3][prio];
 		req->reg[0] = NIX_AF_TL4X_PARENT(schq);
-		req->regval[0] = parent << 16;
+		req->regval[0] = (u64)parent << 16;
 		req->num_regs++;
 		req->reg[1] = NIX_AF_TL4X_SCHEDULE(schq);
 		req->regval[1] = dwrr_val;
 	} else if (lvl == NIX_TXSCH_LVL_TL3) {
 		parent = schq_list[NIX_TXSCH_LVL_TL2][prio];
 		req->reg[0] = NIX_AF_TL3X_PARENT(schq);
-		req->regval[0] = parent << 16;
+		req->regval[0] = (u64)parent << 16;
 		req->num_regs++;
 		req->reg[1] = NIX_AF_TL3X_SCHEDULE(schq);
 		req->regval[1] = dwrr_val;
@@ -670,11 +670,11 @@ int otx2_txschq_config(struct otx2_nic *pfvf, int lvl, int prio, bool txschq_for
 	} else if (lvl == NIX_TXSCH_LVL_TL2) {
 		parent = schq_list[NIX_TXSCH_LVL_TL1][prio];
 		req->reg[0] = NIX_AF_TL2X_PARENT(schq);
-		req->regval[0] = parent << 16;
+		req->regval[0] = (u64)parent << 16;
 
 		req->num_regs++;
 		req->reg[1] = NIX_AF_TL2X_SCHEDULE(schq);
-		req->regval[1] = TXSCH_TL1_DFLT_RR_PRIO << 24 | dwrr_val;
+		req->regval[1] = (u64)hw->txschq_aggr_lvl_rr_prio << 24 | dwrr_val;
 
 		if (lvl == hw->txschq_link_cfg_lvl) {
 			req->num_regs++;
@@ -698,7 +698,7 @@ int otx2_txschq_config(struct otx2_nic *pfvf, int lvl, int prio, bool txschq_for
 
 		req->num_regs++;
 		req->reg[1] = NIX_AF_TL1X_TOPOLOGY(schq);
-		req->regval[1] = (TXSCH_TL1_DFLT_RR_PRIO << 1);
+		req->regval[1] = hw->txschq_aggr_lvl_rr_prio << 1;
 
 		req->num_regs++;
 		req->reg[2] = NIX_AF_TL1X_CIR(schq);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h
index 45a32e4b49d1c..e3aee6e362151 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_reg.h
@@ -139,33 +139,34 @@
 #define	NIX_LF_CINTX_ENA_W1C(a)		(NIX_LFBASE | 0xD50 | (a) << 12)
 
 /* NIX AF transmit scheduler registers */
-#define NIX_AF_SMQX_CFG(a)		(0x700 | (a) << 16)
-#define NIX_AF_TL1X_SCHEDULE(a)		(0xC00 | (a) << 16)
-#define NIX_AF_TL1X_CIR(a)		(0xC20 | (a) << 16)
-#define NIX_AF_TL1X_TOPOLOGY(a)		(0xC80 | (a) << 16)
-#define NIX_AF_TL2X_PARENT(a)		(0xE88 | (a) << 16)
-#define NIX_AF_TL2X_SCHEDULE(a)		(0xE00 | (a) << 16)
-#define NIX_AF_TL2X_TOPOLOGY(a)		(0xE80 | (a) << 16)
-#define NIX_AF_TL2X_CIR(a)              (0xE20 | (a) << 16)
-#define NIX_AF_TL2X_PIR(a)              (0xE30 | (a) << 16)
-#define NIX_AF_TL3X_PARENT(a)		(0x1088 | (a) << 16)
-#define NIX_AF_TL3X_SCHEDULE(a)		(0x1000 | (a) << 16)
-#define NIX_AF_TL3X_SHAPE(a)		(0x1010 | (a) << 16)
-#define NIX_AF_TL3X_CIR(a)		(0x1020 | (a) << 16)
-#define NIX_AF_TL3X_PIR(a)		(0x1030 | (a) << 16)
-#define NIX_AF_TL3X_TOPOLOGY(a)		(0x1080 | (a) << 16)
-#define NIX_AF_TL4X_PARENT(a)		(0x1288 | (a) << 16)
-#define NIX_AF_TL4X_SCHEDULE(a)		(0x1200 | (a) << 16)
-#define NIX_AF_TL4X_SHAPE(a)		(0x1210 | (a) << 16)
-#define NIX_AF_TL4X_CIR(a)		(0x1220 | (a) << 16)
-#define NIX_AF_TL4X_PIR(a)		(0x1230 | (a) << 16)
-#define NIX_AF_TL4X_TOPOLOGY(a)		(0x1280 | (a) << 16)
-#define NIX_AF_MDQX_SCHEDULE(a)		(0x1400 | (a) << 16)
-#define NIX_AF_MDQX_SHAPE(a)		(0x1410 | (a) << 16)
-#define NIX_AF_MDQX_CIR(a)		(0x1420 | (a) << 16)
-#define NIX_AF_MDQX_PIR(a)		(0x1430 | (a) << 16)
-#define NIX_AF_MDQX_PARENT(a)		(0x1480 | (a) << 16)
-#define NIX_AF_TL3_TL2X_LINKX_CFG(a, b)	(0x1700 | (a) << 16 | (b) << 3)
+#define NIX_AF_SMQX_CFG(a)		(0x700 | (u64)(a) << 16)
+#define NIX_AF_TL4X_SDP_LINK_CFG(a)	(0xB10 | (u64)(a) << 16)
+#define NIX_AF_TL1X_SCHEDULE(a)		(0xC00 | (u64)(a) << 16)
+#define NIX_AF_TL1X_CIR(a)		(0xC20 | (u64)(a) << 16)
+#define NIX_AF_TL1X_TOPOLOGY(a)		(0xC80 | (u64)(a) << 16)
+#define NIX_AF_TL2X_PARENT(a)		(0xE88 | (u64)(a) << 16)
+#define NIX_AF_TL2X_SCHEDULE(a)		(0xE00 | (u64)(a) << 16)
+#define NIX_AF_TL2X_TOPOLOGY(a)		(0xE80 | (u64)(a) << 16)
+#define NIX_AF_TL2X_CIR(a)		(0xE20 | (u64)(a) << 16)
+#define NIX_AF_TL2X_PIR(a)		(0xE30 | (u64)(a) << 16)
+#define NIX_AF_TL3X_PARENT(a)		(0x1088 | (u64)(a) << 16)
+#define NIX_AF_TL3X_SCHEDULE(a)		(0x1000 | (u64)(a) << 16)
+#define NIX_AF_TL3X_SHAPE(a)		(0x1010 | (u64)(a) << 16)
+#define NIX_AF_TL3X_CIR(a)		(0x1020 | (u64)(a) << 16)
+#define NIX_AF_TL3X_PIR(a)		(0x1030 | (u64)(a) << 16)
+#define NIX_AF_TL3X_TOPOLOGY(a)		(0x1080 | (u64)(a) << 16)
+#define NIX_AF_TL4X_PARENT(a)		(0x1288 | (u64)(a) << 16)
+#define NIX_AF_TL4X_SCHEDULE(a)		(0x1200 | (u64)(a) << 16)
+#define NIX_AF_TL4X_SHAPE(a)		(0x1210 | (u64)(a) << 16)
+#define NIX_AF_TL4X_CIR(a)		(0x1220 | (u64)(a) << 16)
+#define NIX_AF_TL4X_PIR(a)		(0x1230 | (u64)(a) << 16)
+#define NIX_AF_TL4X_TOPOLOGY(a)		(0x1280 | (u64)(a) << 16)
+#define NIX_AF_MDQX_SCHEDULE(a)		(0x1400 | (u64)(a) << 16)
+#define NIX_AF_MDQX_SHAPE(a)		(0x1410 | (u64)(a) << 16)
+#define NIX_AF_MDQX_CIR(a)		(0x1420 | (u64)(a) << 16)
+#define NIX_AF_MDQX_PIR(a)		(0x1430 | (u64)(a) << 16)
+#define NIX_AF_MDQX_PARENT(a)		(0x1480 | (u64)(a) << 16)
+#define NIX_AF_TL3_TL2X_LINKX_CFG(a, b)	(0x1700 | (u64)(a) << 16 | (b) << 3)
 
 /* LMT LF registers */
 #define LMT_LFBASE			BIT_ULL(RVU_FUNC_BLKADDR_SHIFT)
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
index 04a49b9b545f3..0ca9f2ffd932d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -510,7 +510,7 @@ static int otx2_tx_napi_handler(struct otx2_nic *pfvf,
 
 static void otx2_adjust_adaptive_coalese(struct otx2_nic *pfvf, struct otx2_cq_poll *cq_poll)
 {
-	struct dim_sample dim_sample;
+	struct dim_sample dim_sample = { 0 };
 	u64 rx_frames, rx_bytes;
 	u64 tx_frames, tx_bytes;
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/qos.c b/drivers/net/ethernet/marvell/octeontx2/nic/qos.c
index 6cddb4da85b71..4995a2d54d7d0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/qos.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/qos.c
@@ -153,7 +153,6 @@ static void __otx2_qos_txschq_cfg(struct otx2_nic *pfvf,
 		num_regs++;
 
 		otx2_config_sched_shaping(pfvf, node, cfg, &num_regs);
-
 	} else if (level == NIX_TXSCH_LVL_TL4) {
 		otx2_config_sched_shaping(pfvf, node, cfg, &num_regs);
 	} else if (level == NIX_TXSCH_LVL_TL3) {
@@ -176,7 +175,7 @@ static void __otx2_qos_txschq_cfg(struct otx2_nic *pfvf,
 		/* check if node is root */
 		if (node->qid == OTX2_QOS_QID_INNER && !node->parent) {
 			cfg->reg[num_regs] = NIX_AF_TL2X_SCHEDULE(node->schq);
-			cfg->regval[num_regs] =  TXSCH_TL1_DFLT_RR_PRIO << 24 |
+			cfg->regval[num_regs] =  (u64)hw->txschq_aggr_lvl_rr_prio << 24 |
 						 mtu_to_dwrr_weight(pfvf,
 								    pfvf->tx_max_pktlen);
 			num_regs++;
-- 
2.43.0



