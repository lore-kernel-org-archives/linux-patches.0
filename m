Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99CAC3A8F2
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I6xPHX8I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34C9BC433C9;
	Wed, 15 Nov 2023 19:50:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077833;
	bh=/tWlHeJ/HyPXEsAQuc8WOP2eotZmWI6BmE8W45/D628=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I6xPHX8Iuaw0QbQLgdNq70djvHmxYyjlxaw88H6OG9WdzA+hxNsrF/a6QdmlY5xeW
	 BL0WA2Ed7tgS1rpScCRm76/LyuOktv2TSzLmyw3d1pZ8ubxcp+xh1vE+PZFj5BVO0m
	 teprBEw0Jc1HLQUCjbobJum+UGlEKy/yvAetjOiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 548/603] octeontx2-pf: Fix holes in error code
Date: Wed, 15 Nov 2023 14:18:13 -0500
Message-ID: <20231115191649.662443320@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ratheesh Kannoth <rkannoth@marvell.com>

[ Upstream commit 7aeeb2cb7a2570bb69a87ad14018b03e06ce5be5 ]

Error code strings are not getting printed properly
due to holes. Print error code as well.

Fixes: 51afe9026d0c ("octeontx2-pf: NIX TX overwrites SQ_CTX_HW_S[SQ_INT]")
Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
Link: https://lore.kernel.org/r/20231027021953.1819959-2-rkannoth@marvell.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  | 80 +++++++++++--------
 1 file changed, 46 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 6daf4d58c25d6..125fe231702a4 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1193,31 +1193,32 @@ static char *nix_mnqerr_e_str[NIX_MNQERR_MAX] = {
 };
 
 static char *nix_snd_status_e_str[NIX_SND_STATUS_MAX] =  {
-	"NIX_SND_STATUS_GOOD",
-	"NIX_SND_STATUS_SQ_CTX_FAULT",
-	"NIX_SND_STATUS_SQ_CTX_POISON",
-	"NIX_SND_STATUS_SQB_FAULT",
-	"NIX_SND_STATUS_SQB_POISON",
-	"NIX_SND_STATUS_HDR_ERR",
-	"NIX_SND_STATUS_EXT_ERR",
-	"NIX_SND_STATUS_JUMP_FAULT",
-	"NIX_SND_STATUS_JUMP_POISON",
-	"NIX_SND_STATUS_CRC_ERR",
-	"NIX_SND_STATUS_IMM_ERR",
-	"NIX_SND_STATUS_SG_ERR",
-	"NIX_SND_STATUS_MEM_ERR",
-	"NIX_SND_STATUS_INVALID_SUBDC",
-	"NIX_SND_STATUS_SUBDC_ORDER_ERR",
-	"NIX_SND_STATUS_DATA_FAULT",
-	"NIX_SND_STATUS_DATA_POISON",
-	"NIX_SND_STATUS_NPC_DROP_ACTION",
-	"NIX_SND_STATUS_LOCK_VIOL",
-	"NIX_SND_STATUS_NPC_UCAST_CHAN_ERR",
-	"NIX_SND_STATUS_NPC_MCAST_CHAN_ERR",
-	"NIX_SND_STATUS_NPC_MCAST_ABORT",
-	"NIX_SND_STATUS_NPC_VTAG_PTR_ERR",
-	"NIX_SND_STATUS_NPC_VTAG_SIZE_ERR",
-	"NIX_SND_STATUS_SEND_STATS_ERR",
+	[NIX_SND_STATUS_GOOD] = "NIX_SND_STATUS_GOOD",
+	[NIX_SND_STATUS_SQ_CTX_FAULT] = "NIX_SND_STATUS_SQ_CTX_FAULT",
+	[NIX_SND_STATUS_SQ_CTX_POISON] = "NIX_SND_STATUS_SQ_CTX_POISON",
+	[NIX_SND_STATUS_SQB_FAULT] = "NIX_SND_STATUS_SQB_FAULT",
+	[NIX_SND_STATUS_SQB_POISON] = "NIX_SND_STATUS_SQB_POISON",
+	[NIX_SND_STATUS_HDR_ERR] = "NIX_SND_STATUS_HDR_ERR",
+	[NIX_SND_STATUS_EXT_ERR] = "NIX_SND_STATUS_EXT_ERR",
+	[NIX_SND_STATUS_JUMP_FAULT] = "NIX_SND_STATUS_JUMP_FAULT",
+	[NIX_SND_STATUS_JUMP_POISON] = "NIX_SND_STATUS_JUMP_POISON",
+	[NIX_SND_STATUS_CRC_ERR] = "NIX_SND_STATUS_CRC_ERR",
+	[NIX_SND_STATUS_IMM_ERR] = "NIX_SND_STATUS_IMM_ERR",
+	[NIX_SND_STATUS_SG_ERR] = "NIX_SND_STATUS_SG_ERR",
+	[NIX_SND_STATUS_MEM_ERR] = "NIX_SND_STATUS_MEM_ERR",
+	[NIX_SND_STATUS_INVALID_SUBDC] = "NIX_SND_STATUS_INVALID_SUBDC",
+	[NIX_SND_STATUS_SUBDC_ORDER_ERR] = "NIX_SND_STATUS_SUBDC_ORDER_ERR",
+	[NIX_SND_STATUS_DATA_FAULT] = "NIX_SND_STATUS_DATA_FAULT",
+	[NIX_SND_STATUS_DATA_POISON] = "NIX_SND_STATUS_DATA_POISON",
+	[NIX_SND_STATUS_NPC_DROP_ACTION] = "NIX_SND_STATUS_NPC_DROP_ACTION",
+	[NIX_SND_STATUS_LOCK_VIOL] = "NIX_SND_STATUS_LOCK_VIOL",
+	[NIX_SND_STATUS_NPC_UCAST_CHAN_ERR] = "NIX_SND_STAT_NPC_UCAST_CHAN_ERR",
+	[NIX_SND_STATUS_NPC_MCAST_CHAN_ERR] = "NIX_SND_STAT_NPC_MCAST_CHAN_ERR",
+	[NIX_SND_STATUS_NPC_MCAST_ABORT] = "NIX_SND_STATUS_NPC_MCAST_ABORT",
+	[NIX_SND_STATUS_NPC_VTAG_PTR_ERR] = "NIX_SND_STATUS_NPC_VTAG_PTR_ERR",
+	[NIX_SND_STATUS_NPC_VTAG_SIZE_ERR] = "NIX_SND_STATUS_NPC_VTAG_SIZE_ERR",
+	[NIX_SND_STATUS_SEND_MEM_FAULT] = "NIX_SND_STATUS_SEND_MEM_FAULT",
+	[NIX_SND_STATUS_SEND_STATS_ERR] = "NIX_SND_STATUS_SEND_STATS_ERR",
 };
 
 static irqreturn_t otx2_q_intr_handler(int irq, void *data)
@@ -1238,14 +1239,16 @@ static irqreturn_t otx2_q_intr_handler(int irq, void *data)
 			continue;
 
 		if (val & BIT_ULL(42)) {
-			netdev_err(pf->netdev, "CQ%lld: error reading NIX_LF_CQ_OP_INT, NIX_LF_ERR_INT 0x%llx\n",
+			netdev_err(pf->netdev,
+				   "CQ%lld: error reading NIX_LF_CQ_OP_INT, NIX_LF_ERR_INT 0x%llx\n",
 				   qidx, otx2_read64(pf, NIX_LF_ERR_INT));
 		} else {
 			if (val & BIT_ULL(NIX_CQERRINT_DOOR_ERR))
 				netdev_err(pf->netdev, "CQ%lld: Doorbell error",
 					   qidx);
 			if (val & BIT_ULL(NIX_CQERRINT_CQE_FAULT))
-				netdev_err(pf->netdev, "CQ%lld: Memory fault on CQE write to LLC/DRAM",
+				netdev_err(pf->netdev,
+					   "CQ%lld: Memory fault on CQE write to LLC/DRAM",
 					   qidx);
 		}
 
@@ -1272,7 +1275,8 @@ static irqreturn_t otx2_q_intr_handler(int irq, void *data)
 			     (val & NIX_SQINT_BITS));
 
 		if (val & BIT_ULL(42)) {
-			netdev_err(pf->netdev, "SQ%lld: error reading NIX_LF_SQ_OP_INT, NIX_LF_ERR_INT 0x%llx\n",
+			netdev_err(pf->netdev,
+				   "SQ%lld: error reading NIX_LF_SQ_OP_INT, NIX_LF_ERR_INT 0x%llx\n",
 				   qidx, otx2_read64(pf, NIX_LF_ERR_INT));
 			goto done;
 		}
@@ -1282,8 +1286,11 @@ static irqreturn_t otx2_q_intr_handler(int irq, void *data)
 			goto chk_mnq_err_dbg;
 
 		sq_op_err_code = FIELD_GET(GENMASK(7, 0), sq_op_err_dbg);
-		netdev_err(pf->netdev, "SQ%lld: NIX_LF_SQ_OP_ERR_DBG(%llx)  err=%s\n",
-			   qidx, sq_op_err_dbg, nix_sqoperr_e_str[sq_op_err_code]);
+		netdev_err(pf->netdev,
+			   "SQ%lld: NIX_LF_SQ_OP_ERR_DBG(0x%llx)  err=%s(%#x)\n",
+			   qidx, sq_op_err_dbg,
+			   nix_sqoperr_e_str[sq_op_err_code],
+			   sq_op_err_code);
 
 		otx2_write64(pf, NIX_LF_SQ_OP_ERR_DBG, BIT_ULL(44));
 
@@ -1300,16 +1307,21 @@ static irqreturn_t otx2_q_intr_handler(int irq, void *data)
 			goto chk_snd_err_dbg;
 
 		mnq_err_code = FIELD_GET(GENMASK(7, 0), mnq_err_dbg);
-		netdev_err(pf->netdev, "SQ%lld: NIX_LF_MNQ_ERR_DBG(%llx)  err=%s\n",
-			   qidx, mnq_err_dbg,  nix_mnqerr_e_str[mnq_err_code]);
+		netdev_err(pf->netdev,
+			   "SQ%lld: NIX_LF_MNQ_ERR_DBG(0x%llx)  err=%s(%#x)\n",
+			   qidx, mnq_err_dbg,  nix_mnqerr_e_str[mnq_err_code],
+			   mnq_err_code);
 		otx2_write64(pf, NIX_LF_MNQ_ERR_DBG, BIT_ULL(44));
 
 chk_snd_err_dbg:
 		snd_err_dbg = otx2_read64(pf, NIX_LF_SEND_ERR_DBG);
 		if (snd_err_dbg & BIT(44)) {
 			snd_err_code = FIELD_GET(GENMASK(7, 0), snd_err_dbg);
-			netdev_err(pf->netdev, "SQ%lld: NIX_LF_SND_ERR_DBG:0x%llx err=%s\n",
-				   qidx, snd_err_dbg, nix_snd_status_e_str[snd_err_code]);
+			netdev_err(pf->netdev,
+				   "SQ%lld: NIX_LF_SND_ERR_DBG:0x%llx err=%s(%#x)\n",
+				   qidx, snd_err_dbg,
+				   nix_snd_status_e_str[snd_err_code],
+				   snd_err_code);
 			otx2_write64(pf, NIX_LF_SEND_ERR_DBG, BIT_ULL(44));
 		}
 
-- 
2.42.0



