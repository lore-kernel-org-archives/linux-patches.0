Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD49333434
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301827; cv=none; b=Oe6xoJ2aItsQVtdE1s2HyvcyAPl7IHI2GMs5P6wvpbteXTBDAEETKCff1G+Ch4rJH7OseIHe40t5789wgIw5wi4XGVDHlhGxpmMF8etqSbIxSoBXveDGEE2rU0CkOAw2uLDbqyWY8SpvSYf2YnzdyE9ptQoqmgEaxN9MkcuX/TU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301827; c=relaxed/simple;
	bh=oVmyyCH95I78mnzDc/o6LzASds7YGZtmSxjcLe06Xec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QgOgum/nLn3N5KlIaoe6i5kcY71LNh51LcT5Gqr4NMojF+iA2MmGXcwzus6wMBGYVGTjNg/NJMAaGSqewZiWRifi+4eAIGwYe4DzNIpxtrPzJZEzUm+kjki7rGHP6P/yBGjRjdWJ6R1/wp1skddhcWVEZvPxjzFlZNK+eALaDpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J0cAnlik; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J0cAnlik"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 497EBC19423;
	Sat, 28 Feb 2026 18:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301826;
	bh=oVmyyCH95I78mnzDc/o6LzASds7YGZtmSxjcLe06Xec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J0cAnlikT4d0S5NqjrLVEHe2AdGNfpTHIETB1vV2MXSC3jDye9A61dNH20u2Sq4cP
	 0/y6wx5tjIqoQjM/b7nv3gMbfe6Yt+sTIc6/7QQosSG/5XVriKB6QG08cosVzUmkRT
	 GDSCeZxHTBEDJwj6a+wATw9YjVkOkoYfMJa90oUHHqDJ/GVMcUBIN3u3AUc95kjD0I
	 VPkGMlBN0LOrEMjeoa4fawHJJiQlvvrLDHwmlVwHIZu17CA9OIIPFGjg/MO0cFOQiG
	 imyU9dbHrGp7taUzVOJhiwJ6kAUaEbEDyzVtNpsWeoXpBUxuGiJtV23ldFKykE/gin
	 Lx+xgnp1xcWrg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Vimlesh Kumar <vimleshk@marvell.com>,
	Sathesh Edara <sedara@marvell.com>,
	Shinas Rasheed <srasheed@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 242/385] octeon_ep_vf: ensure dbell BADDR updation
Date: Sat, 28 Feb 2026 12:57:44 -0500
Message-ID: <20260228180011.1568201-242-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Vimlesh Kumar <vimleshk@marvell.com>

[ Upstream commit 484e834d53cffa91c311631271f83130cf6e9e7c ]

Make sure the OUT DBELL base address reflects the
latest values written to it.

Fix:
Add a wait until the OUT DBELL base address register
is updated with the DMA ring descriptor address,
and modify the setup_oq function to properly
handle failures.

Fixes: 2c0c32c72be29 ("octeon_ep_vf: add hardware configuration APIs")
Signed-off-by: Sathesh Edara <sedara@marvell.com>
Signed-off-by: Shinas Rasheed <srasheed@marvell.com>
Signed-off-by: Vimlesh Kumar <vimleshk@marvell.com>
Link: https://patch.msgid.link/20260206111510.1045092-4-vimleshk@marvell.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../marvell/octeon_ep_vf/octep_vf_cn9k.c      |  3 +-
 .../marvell/octeon_ep_vf/octep_vf_cnxk.c      | 39 +++++++++++++++++--
 .../marvell/octeon_ep_vf/octep_vf_main.h      |  2 +-
 .../marvell/octeon_ep_vf/octep_vf_rx.c        |  8 +++-
 4 files changed, 46 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_cn9k.c b/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_cn9k.c
index 88937fce75f14..4c769b27c2789 100644
--- a/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_cn9k.c
+++ b/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_cn9k.c
@@ -196,7 +196,7 @@ static void octep_vf_setup_iq_regs_cn93(struct octep_vf_device *oct, int iq_no)
 }
 
 /* Setup registers for a hardware Rx Queue  */
-static void octep_vf_setup_oq_regs_cn93(struct octep_vf_device *oct, int oq_no)
+static int octep_vf_setup_oq_regs_cn93(struct octep_vf_device *oct, int oq_no)
 {
 	struct octep_vf_oq *oq = oct->oq[oq_no];
 	u32 time_threshold = 0;
@@ -239,6 +239,7 @@ static void octep_vf_setup_oq_regs_cn93(struct octep_vf_device *oct, int oq_no)
 	time_threshold = CFG_GET_OQ_INTR_TIME(oct->conf);
 	reg_val = ((u64)time_threshold << 32) | CFG_GET_OQ_INTR_PKT(oct->conf);
 	octep_vf_write_csr64(oct, CN93_VF_SDP_R_OUT_INT_LEVELS(oq_no), reg_val);
+	return 0;
 }
 
 /* Setup registers for a VF mailbox */
diff --git a/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_cnxk.c b/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_cnxk.c
index 1f79dfad42c62..a968b93a67943 100644
--- a/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_cnxk.c
+++ b/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_cnxk.c
@@ -199,11 +199,13 @@ static void octep_vf_setup_iq_regs_cnxk(struct octep_vf_device *oct, int iq_no)
 }
 
 /* Setup registers for a hardware Rx Queue  */
-static void octep_vf_setup_oq_regs_cnxk(struct octep_vf_device *oct, int oq_no)
+static int octep_vf_setup_oq_regs_cnxk(struct octep_vf_device *oct, int oq_no)
 {
 	struct octep_vf_oq *oq = oct->oq[oq_no];
+	unsigned long t_out_jiffies;
 	u32 time_threshold = 0;
 	u64 oq_ctl = ULL(0);
+	u64 reg_ba_val;
 	u64 reg_val;
 
 	reg_val = octep_vf_read_csr64(oct, CNXK_VF_SDP_R_OUT_CONTROL(oq_no));
@@ -214,6 +216,38 @@ static void octep_vf_setup_oq_regs_cnxk(struct octep_vf_device *oct, int oq_no)
 			reg_val = octep_vf_read_csr64(oct, CNXK_VF_SDP_R_OUT_CONTROL(oq_no));
 		} while (!(reg_val & CNXK_VF_R_OUT_CTL_IDLE));
 	}
+	octep_vf_write_csr64(oct, CNXK_VF_SDP_R_OUT_WMARK(oq_no),
+			     oq->max_count);
+	/* Wait for WMARK to get applied */
+	usleep_range(10, 15);
+
+	octep_vf_write_csr64(oct, CNXK_VF_SDP_R_OUT_SLIST_BADDR(oq_no),
+			     oq->desc_ring_dma);
+	octep_vf_write_csr64(oct, CNXK_VF_SDP_R_OUT_SLIST_RSIZE(oq_no),
+			     oq->max_count);
+	reg_ba_val = octep_vf_read_csr64(oct,
+					 CNXK_VF_SDP_R_OUT_SLIST_BADDR(oq_no));
+	if (reg_ba_val != oq->desc_ring_dma) {
+		t_out_jiffies = jiffies + 10 * HZ;
+		do {
+			if (reg_ba_val == ULLONG_MAX)
+				return -EFAULT;
+			octep_vf_write_csr64(oct,
+					     CNXK_VF_SDP_R_OUT_SLIST_BADDR
+					     (oq_no), oq->desc_ring_dma);
+			octep_vf_write_csr64(oct,
+					     CNXK_VF_SDP_R_OUT_SLIST_RSIZE
+					     (oq_no), oq->max_count);
+			reg_ba_val =
+			octep_vf_read_csr64(oct,
+					    CNXK_VF_SDP_R_OUT_SLIST_BADDR
+					    (oq_no));
+		} while ((reg_ba_val != oq->desc_ring_dma) &&
+			  time_before(jiffies, t_out_jiffies));
+
+		if (reg_ba_val != oq->desc_ring_dma)
+			return -EAGAIN;
+	}
 
 	reg_val &= ~(CNXK_VF_R_OUT_CTL_IMODE);
 	reg_val &= ~(CNXK_VF_R_OUT_CTL_ROR_P);
@@ -227,8 +261,6 @@ static void octep_vf_setup_oq_regs_cnxk(struct octep_vf_device *oct, int oq_no)
 	reg_val |= (CNXK_VF_R_OUT_CTL_ES_P);
 
 	octep_vf_write_csr64(oct, CNXK_VF_SDP_R_OUT_CONTROL(oq_no), reg_val);
-	octep_vf_write_csr64(oct, CNXK_VF_SDP_R_OUT_SLIST_BADDR(oq_no), oq->desc_ring_dma);
-	octep_vf_write_csr64(oct, CNXK_VF_SDP_R_OUT_SLIST_RSIZE(oq_no), oq->max_count);
 
 	oq_ctl = octep_vf_read_csr64(oct, CNXK_VF_SDP_R_OUT_CONTROL(oq_no));
 	/* Clear the ISIZE and BSIZE (22-0) */
@@ -250,6 +282,7 @@ static void octep_vf_setup_oq_regs_cnxk(struct octep_vf_device *oct, int oq_no)
 	reg_val &= ~GENMASK_ULL(31, 0);
 	reg_val |= CFG_GET_OQ_WMARK(oct->conf);
 	octep_vf_write_csr64(oct, CNXK_VF_SDP_R_OUT_WMARK(oq_no), reg_val);
+	return 0;
 }
 
 /* Setup registers for a VF mailbox */
diff --git a/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_main.h b/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_main.h
index 1a352f41f823c..4ee6b4d568ede 100644
--- a/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_main.h
+++ b/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_main.h
@@ -55,7 +55,7 @@ struct octep_vf_mmio {
 
 struct octep_vf_hw_ops {
 	void (*setup_iq_regs)(struct octep_vf_device *oct, int q);
-	void (*setup_oq_regs)(struct octep_vf_device *oct, int q);
+	int (*setup_oq_regs)(struct octep_vf_device *oct, int q);
 	void (*setup_mbox_regs)(struct octep_vf_device *oct, int mbox);
 
 	irqreturn_t (*non_ioq_intr_handler)(void *ioq_vector);
diff --git a/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_rx.c b/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_rx.c
index d70c8be3cfc40..6f865dbbba6c6 100644
--- a/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_rx.c
+++ b/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_rx.c
@@ -12,6 +12,8 @@
 #include "octep_vf_config.h"
 #include "octep_vf_main.h"
 
+static void octep_vf_oq_free_ring_buffers(struct octep_vf_oq *oq);
+
 static void octep_vf_oq_reset_indices(struct octep_vf_oq *oq)
 {
 	oq->host_read_idx = 0;
@@ -171,11 +173,15 @@ static int octep_vf_setup_oq(struct octep_vf_device *oct, int q_no)
 		goto oq_fill_buff_err;
 
 	octep_vf_oq_reset_indices(oq);
-	oct->hw_ops.setup_oq_regs(oct, q_no);
+	if (oct->hw_ops.setup_oq_regs(oct, q_no))
+		goto oq_setup_err;
+
 	oct->num_oqs++;
 
 	return 0;
 
+oq_setup_err:
+	octep_vf_oq_free_ring_buffers(oq);
 oq_fill_buff_err:
 	vfree(oq->buff_info);
 	oq->buff_info = NULL;
-- 
2.51.0

