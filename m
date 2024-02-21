Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38E18779F8;
	Wed, 21 Feb 2024 13:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522167; cv=none; b=q0SSz81BmSHQ1a/71AktR9bm89PNo7d+s6uuKauPLQF97i/rOKublp/kMR80Qg+Cta0hlUEiJPARRGE5Bh+rIJJPm73dH76RZrwyfSruQzgUqOr5jurcH7X6xZOJKZhsOptOg8DZn4uFQ8j8cyLjQ2JbRLtnY8FrB9gFWFcT1P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522167; c=relaxed/simple;
	bh=83Dpx9a7M1rOfQR9WpdYvoaT8EExWrpPWbMxpOPpUjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C5ZWvQ2QcKxi0KKndSNYM7N4/wBe5eBLj2tuE9kfFkas9XNDx69cjcJXs86Fkg92NN+23CW944ov2l8rOZ0DZ1AjWlbVpFNhX3JAEtF3mMVb+wIfV6KRq5oKdblEcsG4PZwaKDBGBWiInvVkErKEb/Kl71zKltG8HvdadbI62Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X0f77CBO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X0f77CBO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94A82C433F1;
	Wed, 21 Feb 2024 13:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522167;
	bh=83Dpx9a7M1rOfQR9WpdYvoaT8EExWrpPWbMxpOPpUjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X0f77CBOMJRDJtoJDxKz/bnemf+IXHAWGg0SFJAZv8WOckTZfnIIznM91gcmwSV4Y
	 tW+SrjTDHF82Lhcq+kQYduWLr0obTgqdLyV+6rgn9k+0SzkDyi2ZF+UsSIBbbg884O
	 v6suBeVGSoECxFxwyU3DPt2LYbm/rzNZBKcnLBcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Elder <elder@linaro.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 097/476] bus: mhi: host: Rename "struct mhi_tre" to "struct mhi_ring_element"
Date: Wed, 21 Feb 2024 14:02:28 +0100
Message-ID: <20240221130011.569740588@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit 84f5f31f110e5e8cd5581e8efdbf8c369e962eb9 ]

Structure "struct mhi_tre" is representing a generic MHI ring element and
not specifically a Transfer Ring Element (TRE). Fix the naming.

Reviewed-by: Alex Elder <elder@linaro.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20220301160308.107452-9-manivannan.sadhasivam@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: eff9704f5332 ("bus: mhi: host: Add alignment check for event ring read pointer")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/mhi/host/init.c     |  6 +++---
 drivers/bus/mhi/host/internal.h |  2 +-
 drivers/bus/mhi/host/main.c     | 20 ++++++++++----------
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/bus/mhi/host/init.c b/drivers/bus/mhi/host/init.c
index 829d4fca7ddc..7ccc5cd27fd0 100644
--- a/drivers/bus/mhi/host/init.c
+++ b/drivers/bus/mhi/host/init.c
@@ -338,7 +338,7 @@ int mhi_init_dev_ctxt(struct mhi_controller *mhi_cntrl)
 		er_ctxt->msivec = cpu_to_le32(mhi_event->irq);
 		mhi_event->db_cfg.db_mode = true;
 
-		ring->el_size = sizeof(struct mhi_tre);
+		ring->el_size = sizeof(struct mhi_ring_element);
 		ring->len = ring->el_size * ring->elements;
 		ret = mhi_alloc_aligned_ring(mhi_cntrl, ring, ring->len);
 		if (ret)
@@ -370,7 +370,7 @@ int mhi_init_dev_ctxt(struct mhi_controller *mhi_cntrl)
 	for (i = 0; i < NR_OF_CMD_RINGS; i++, mhi_cmd++, cmd_ctxt++) {
 		struct mhi_ring *ring = &mhi_cmd->ring;
 
-		ring->el_size = sizeof(struct mhi_tre);
+		ring->el_size = sizeof(struct mhi_ring_element);
 		ring->elements = CMD_EL_PER_RING;
 		ring->len = ring->el_size * ring->elements;
 		ret = mhi_alloc_aligned_ring(mhi_cntrl, ring, ring->len);
@@ -613,7 +613,7 @@ int mhi_init_chan_ctxt(struct mhi_controller *mhi_cntrl,
 
 	buf_ring = &mhi_chan->buf_ring;
 	tre_ring = &mhi_chan->tre_ring;
-	tre_ring->el_size = sizeof(struct mhi_tre);
+	tre_ring->el_size = sizeof(struct mhi_ring_element);
 	tre_ring->len = tre_ring->el_size * tre_ring->elements;
 	chan_ctxt = &mhi_cntrl->mhi_ctxt->chan_ctxt[mhi_chan->chan];
 	ret = mhi_alloc_aligned_ring(mhi_cntrl, tre_ring, tre_ring->len);
diff --git a/drivers/bus/mhi/host/internal.h b/drivers/bus/mhi/host/internal.h
index 71f181402be9..df65bb17fdba 100644
--- a/drivers/bus/mhi/host/internal.h
+++ b/drivers/bus/mhi/host/internal.h
@@ -257,7 +257,7 @@ struct mhi_ctxt {
 	dma_addr_t cmd_ctxt_addr;
 };
 
-struct mhi_tre {
+struct mhi_ring_element {
 	__le64 ptr;
 	__le32 dword[2];
 };
diff --git a/drivers/bus/mhi/host/main.c b/drivers/bus/mhi/host/main.c
index 0d35acb2f7c0..23bd1db94558 100644
--- a/drivers/bus/mhi/host/main.c
+++ b/drivers/bus/mhi/host/main.c
@@ -556,7 +556,7 @@ static void mhi_recycle_ev_ring_element(struct mhi_controller *mhi_cntrl,
 }
 
 static int parse_xfer_event(struct mhi_controller *mhi_cntrl,
-			    struct mhi_tre *event,
+			    struct mhi_ring_element *event,
 			    struct mhi_chan *mhi_chan)
 {
 	struct mhi_ring *buf_ring, *tre_ring;
@@ -592,7 +592,7 @@ static int parse_xfer_event(struct mhi_controller *mhi_cntrl,
 	case MHI_EV_CC_EOT:
 	{
 		dma_addr_t ptr = MHI_TRE_GET_EV_PTR(event);
-		struct mhi_tre *local_rp, *ev_tre;
+		struct mhi_ring_element *local_rp, *ev_tre;
 		void *dev_rp;
 		struct mhi_buf_info *buf_info;
 		u16 xfer_len;
@@ -695,7 +695,7 @@ static int parse_xfer_event(struct mhi_controller *mhi_cntrl,
 }
 
 static int parse_rsc_event(struct mhi_controller *mhi_cntrl,
-			   struct mhi_tre *event,
+			   struct mhi_ring_element *event,
 			   struct mhi_chan *mhi_chan)
 {
 	struct mhi_ring *buf_ring, *tre_ring;
@@ -759,12 +759,12 @@ static int parse_rsc_event(struct mhi_controller *mhi_cntrl,
 }
 
 static void mhi_process_cmd_completion(struct mhi_controller *mhi_cntrl,
-				       struct mhi_tre *tre)
+				       struct mhi_ring_element *tre)
 {
 	dma_addr_t ptr = MHI_TRE_GET_EV_PTR(tre);
 	struct mhi_cmd *cmd_ring = &mhi_cntrl->mhi_cmd[PRIMARY_CMD_RING];
 	struct mhi_ring *mhi_ring = &cmd_ring->ring;
-	struct mhi_tre *cmd_pkt;
+	struct mhi_ring_element *cmd_pkt;
 	struct mhi_chan *mhi_chan;
 	u32 chan;
 
@@ -797,7 +797,7 @@ int mhi_process_ctrl_ev_ring(struct mhi_controller *mhi_cntrl,
 			     struct mhi_event *mhi_event,
 			     u32 event_quota)
 {
-	struct mhi_tre *dev_rp, *local_rp;
+	struct mhi_ring_element *dev_rp, *local_rp;
 	struct mhi_ring *ev_ring = &mhi_event->ring;
 	struct mhi_event_ctxt *er_ctxt =
 		&mhi_cntrl->mhi_ctxt->er_ctxt[mhi_event->er_index];
@@ -967,7 +967,7 @@ int mhi_process_data_event_ring(struct mhi_controller *mhi_cntrl,
 				struct mhi_event *mhi_event,
 				u32 event_quota)
 {
-	struct mhi_tre *dev_rp, *local_rp;
+	struct mhi_ring_element *dev_rp, *local_rp;
 	struct mhi_ring *ev_ring = &mhi_event->ring;
 	struct mhi_event_ctxt *er_ctxt =
 		&mhi_cntrl->mhi_ctxt->er_ctxt[mhi_event->er_index];
@@ -1188,7 +1188,7 @@ int mhi_gen_tre(struct mhi_controller *mhi_cntrl, struct mhi_chan *mhi_chan,
 			struct mhi_buf_info *info, enum mhi_flags flags)
 {
 	struct mhi_ring *buf_ring, *tre_ring;
-	struct mhi_tre *mhi_tre;
+	struct mhi_ring_element *mhi_tre;
 	struct mhi_buf_info *buf_info;
 	int eot, eob, chain, bei;
 	int ret;
@@ -1266,7 +1266,7 @@ int mhi_send_cmd(struct mhi_controller *mhi_cntrl,
 		 struct mhi_chan *mhi_chan,
 		 enum mhi_cmd_type cmd)
 {
-	struct mhi_tre *cmd_tre = NULL;
+	struct mhi_ring_element *cmd_tre = NULL;
 	struct mhi_cmd *mhi_cmd = &mhi_cntrl->mhi_cmd[PRIMARY_CMD_RING];
 	struct mhi_ring *ring = &mhi_cmd->ring;
 	struct device *dev = &mhi_cntrl->mhi_dev->dev;
@@ -1524,7 +1524,7 @@ static void mhi_mark_stale_events(struct mhi_controller *mhi_cntrl,
 				  int chan)
 
 {
-	struct mhi_tre *dev_rp, *local_rp;
+	struct mhi_ring_element *dev_rp, *local_rp;
 	struct mhi_ring *ev_ring;
 	struct device *dev = &mhi_cntrl->mhi_dev->dev;
 	unsigned long flags;
-- 
2.43.0



