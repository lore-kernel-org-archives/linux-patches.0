Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2520B2E339B;
	Tue, 15 Jul 2025 13:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586179; cv=none; b=mNNNcM3+7TEVUXrq9yvOv2lF/HXKlhas+CJ6eGv4R1aeNQJeJNpZ1NMaWPyi9dbgkRtdEHTSMolJT48/ayNmErOHaKsvobV+KiFN31Hux3Vpjz6Z5DBmTJvfa/quVC8lo1APpzVfURCZY2j72IiFSTsnD6mijYMau/HVn/njvyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586179; c=relaxed/simple;
	bh=VttGYL4QBLjj7feE3SQgIjGGG/HZwbTT2IC/BKcEHh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t7Z3EXc/8Q4Iaq9DP/t4+R89/DpgSHaPd/VoBxtUO53pCSIMcLjn6ZBE/MdNNX0gMS2PC9PFtF+hBNcUnb+wzFPemEtmkE29zwd/mRdGrmYaYG4JTxP/IBtGkqHpA/ClUqs02umCo3DcQhJzhAGQ1Pt2u/dyid38I4emM/jD/2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FyPPeDM+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FyPPeDM+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF9EDC4CEE3;
	Tue, 15 Jul 2025 13:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586179;
	bh=VttGYL4QBLjj7feE3SQgIjGGG/HZwbTT2IC/BKcEHh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FyPPeDM+jvgPHyT+GKm9DmaKwpx5MlM9EiHgCcL8w6jABQczJYKjDYAjALlExOXp8
	 nhFptUot9C+qUyM6fflNmcpD0L9cLY4cUUtTjAZGvVG98eJv7aBv9tCYWyBMSSj0QG
	 3LkPiESYHjwk0TeZKTpBtpL4NRcBaOZBwFoPTPdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawel Laszczak <pawell@cadence.com>,
	Peter Chen <peter.chen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 46/77] usb:cdnsp: remove TRB_FLUSH_ENDPOINT command
Date: Tue, 15 Jul 2025 15:13:45 +0200
Message-ID: <20250715130753.561929393@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130751.668489382@linuxfoundation.org>
References: <20250715130751.668489382@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Pawel Laszczak <pawell@cadence.com>

[ Upstream commit 2998874736bca1031ca84b0a3235a2cd09dfa426 ]

Patch removes TRB_FLUSH_ENDPOINT command from driver.
This command is not supported by controller and
USBSSP returns TRB Error completion code for it.

Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Acked-by: Peter Chen <peter.chen@kernel.org>
Link: https://lore.kernel.org/r/20231026073737.165450-1-pawell@cadence.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 2831a81077f5 ("usb: cdnsp: Fix issue with CV Bad Descriptor test")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/cdns3/cdnsp-debug.h  |  3 ---
 drivers/usb/cdns3/cdnsp-gadget.c |  6 +-----
 drivers/usb/cdns3/cdnsp-gadget.h |  5 -----
 drivers/usb/cdns3/cdnsp-ring.c   | 24 ------------------------
 4 files changed, 1 insertion(+), 37 deletions(-)

diff --git a/drivers/usb/cdns3/cdnsp-debug.h b/drivers/usb/cdns3/cdnsp-debug.h
index f0ca865cce2a0..ad617b7455b9c 100644
--- a/drivers/usb/cdns3/cdnsp-debug.h
+++ b/drivers/usb/cdns3/cdnsp-debug.h
@@ -131,8 +131,6 @@ static inline const char *cdnsp_trb_type_string(u8 type)
 		return "Endpoint Not ready";
 	case TRB_HALT_ENDPOINT:
 		return "Halt Endpoint";
-	case TRB_FLUSH_ENDPOINT:
-		return "FLush Endpoint";
 	default:
 		return "UNKNOWN";
 	}
@@ -328,7 +326,6 @@ static inline const char *cdnsp_decode_trb(char *str, size_t size, u32 field0,
 		break;
 	case TRB_RESET_EP:
 	case TRB_HALT_ENDPOINT:
-	case TRB_FLUSH_ENDPOINT:
 		ret = snprintf(str, size,
 			       "%s: ep%d%s(%d) ctx %08x%08x slot %ld flags %c",
 			       cdnsp_trb_type_string(type),
diff --git a/drivers/usb/cdns3/cdnsp-gadget.c b/drivers/usb/cdns3/cdnsp-gadget.c
index 1e9aee824eb7d..1de82fb9dcb48 100644
--- a/drivers/usb/cdns3/cdnsp-gadget.c
+++ b/drivers/usb/cdns3/cdnsp-gadget.c
@@ -1061,10 +1061,8 @@ static int cdnsp_gadget_ep_disable(struct usb_ep *ep)
 	pep->ep_state |= EP_DIS_IN_RROGRESS;
 
 	/* Endpoint was unconfigured by Reset Device command. */
-	if (!(pep->ep_state & EP_UNCONFIGURED)) {
+	if (!(pep->ep_state & EP_UNCONFIGURED))
 		cdnsp_cmd_stop_ep(pdev, pep);
-		cdnsp_cmd_flush_ep(pdev, pep);
-	}
 
 	/* Remove all queued USB requests. */
 	while (!list_empty(&pep->pending_list)) {
@@ -1464,8 +1462,6 @@ static void cdnsp_stop(struct cdnsp_device *pdev)
 {
 	u32 temp;
 
-	cdnsp_cmd_flush_ep(pdev, &pdev->eps[0]);
-
 	/* Remove internally queued request for ep0. */
 	if (!list_empty(&pdev->eps[0].pending_list)) {
 		struct cdnsp_request *req;
diff --git a/drivers/usb/cdns3/cdnsp-gadget.h b/drivers/usb/cdns3/cdnsp-gadget.h
index 2998548177aba..48336e121ed6f 100644
--- a/drivers/usb/cdns3/cdnsp-gadget.h
+++ b/drivers/usb/cdns3/cdnsp-gadget.h
@@ -1138,8 +1138,6 @@ union cdnsp_trb {
 #define TRB_HALT_ENDPOINT	54
 /* Doorbell Overflow Event. */
 #define TRB_DRB_OVERFLOW	57
-/* Flush Endpoint Command. */
-#define TRB_FLUSH_ENDPOINT	58
 
 #define TRB_TYPE_LINK(x)	(((x) & TRB_TYPE_BITMASK) == TRB_TYPE(TRB_LINK))
 #define TRB_TYPE_LINK_LE32(x)	(((x) & cpu_to_le32(TRB_TYPE_BITMASK)) == \
@@ -1552,8 +1550,6 @@ void cdnsp_queue_configure_endpoint(struct cdnsp_device *pdev,
 void cdnsp_queue_reset_ep(struct cdnsp_device *pdev, unsigned int ep_index);
 void cdnsp_queue_halt_endpoint(struct cdnsp_device *pdev,
 			       unsigned int ep_index);
-void cdnsp_queue_flush_endpoint(struct cdnsp_device *pdev,
-				unsigned int ep_index);
 void cdnsp_force_header_wakeup(struct cdnsp_device *pdev, int intf_num);
 void cdnsp_queue_reset_device(struct cdnsp_device *pdev);
 void cdnsp_queue_new_dequeue_state(struct cdnsp_device *pdev,
@@ -1587,7 +1583,6 @@ void cdnsp_irq_reset(struct cdnsp_device *pdev);
 int cdnsp_halt_endpoint(struct cdnsp_device *pdev,
 			struct cdnsp_ep *pep, int value);
 int cdnsp_cmd_stop_ep(struct cdnsp_device *pdev, struct cdnsp_ep *pep);
-int cdnsp_cmd_flush_ep(struct cdnsp_device *pdev, struct cdnsp_ep *pep);
 void cdnsp_setup_analyze(struct cdnsp_device *pdev);
 int cdnsp_status_stage(struct cdnsp_device *pdev);
 int cdnsp_reset_device(struct cdnsp_device *pdev);
diff --git a/drivers/usb/cdns3/cdnsp-ring.c b/drivers/usb/cdns3/cdnsp-ring.c
index c9ad4280f4ba2..795668435c77e 100644
--- a/drivers/usb/cdns3/cdnsp-ring.c
+++ b/drivers/usb/cdns3/cdnsp-ring.c
@@ -2157,19 +2157,6 @@ int cdnsp_cmd_stop_ep(struct cdnsp_device *pdev, struct cdnsp_ep *pep)
 	return ret;
 }
 
-int cdnsp_cmd_flush_ep(struct cdnsp_device *pdev, struct cdnsp_ep *pep)
-{
-	int ret;
-
-	cdnsp_queue_flush_endpoint(pdev, pep->idx);
-	cdnsp_ring_cmd_db(pdev);
-	ret = cdnsp_wait_for_cmd_compl(pdev);
-
-	trace_cdnsp_handle_cmd_flush_ep(pep->out_ctx);
-
-	return ret;
-}
-
 /*
  * The transfer burst count field of the isochronous TRB defines the number of
  * bursts that are required to move all packets in this TD. Only SuperSpeed
@@ -2491,17 +2478,6 @@ void cdnsp_queue_halt_endpoint(struct cdnsp_device *pdev, unsigned int ep_index)
 			    EP_ID_FOR_TRB(ep_index));
 }
 
-/*
- * Queue a flush endpoint request on the command ring.
- */
-void  cdnsp_queue_flush_endpoint(struct cdnsp_device *pdev,
-				 unsigned int ep_index)
-{
-	cdnsp_queue_command(pdev, 0, 0, 0, TRB_TYPE(TRB_FLUSH_ENDPOINT) |
-			    SLOT_ID_FOR_TRB(pdev->slot_id) |
-			    EP_ID_FOR_TRB(ep_index));
-}
-
 void cdnsp_force_header_wakeup(struct cdnsp_device *pdev, int intf_num)
 {
 	u32 lo, mid;
-- 
2.39.5



