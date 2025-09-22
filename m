Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FDE23128C4;
	Mon, 22 Sep 2025 19:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570057; cv=none; b=aVkPm+9ZHEMA8SvXwd4Nb0yXpck3PVVtMRmcYjYvq97jqfxJDHyBKPmdf/n0UFEcoiPQ/GcHNYJapVtWpAW0c06NI0os/DeHVx3zT6G43ri/6b7RU1lCcEzR6+x+E6JW/sdtFzMGs9dcBIqFWo1qN2ZJd0dYjtyqgryzxoqB1fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570057; c=relaxed/simple;
	bh=0QUdpxpuebStllIz7ckDFHG3zcxdRcK613MWOzgeP/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YPexSskQ4XR3yOjGHeLaVrm49dEGDTTyabdDEOMbJxx6ph1drGoaZjm2BqLc4QLWM1Y97TAnYdIT7LoYa7Wv8+A5h+BmZ8EuL0+9ZIpbjYfdRWwCTmOuCXtxnSnWVnNxd+AaLf6SDCOxVP0bm96qlp4i3iMwVG/ncgzhioI6Q2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wSJRN2c0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wSJRN2c0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0431C4CEF5;
	Mon, 22 Sep 2025 19:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570057;
	bh=0QUdpxpuebStllIz7ckDFHG3zcxdRcK613MWOzgeP/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wSJRN2c0aKtMvb34zFEYF3XdtDiJnZekpVC6BNKNIMidjvwXZvxPlGj+VhAQIUbzq
	 tOq48gwEfC4/bE6tQhNOaFgrJrgdv4dRzUtg8BdeDRsxSedsZvY/y+Sap1XRKh6VYf
	 I8zhh1zFL2NpR6B4Ja11ekDhmBcKcsgTp7Z8agqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Niklas Neronin <niklas.neronin@linux.intel.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 094/105] usb: xhci: introduce macro for ring segment list iteration
Date: Mon, 22 Sep 2025 21:30:17 +0200
Message-ID: <20250922192411.360465269@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
References: <20250922192408.913556629@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Neronin <niklas.neronin@linux.intel.com>

[ Upstream commit 3f970bd06c5295e742ef4f9cf7808a3cb74a6816 ]

Add macro to streamline and standardize the iteration over ring
segment list.

xhci_for_each_ring_seg(): Iterates over the entire ring segment list.

The xhci_free_segments_for_ring() function's while loop has not been
updated to use the new macro. This function has some underlying issues,
and as a result, it will be handled separately in a future patch.

Suggested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Niklas Neronin <niklas.neronin@linux.intel.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20241106101459.775897-11-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: a5c98e8b1398 ("xhci: dbc: Fix full DbC transfer ring after several reconnects")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-debugfs.c |    5 +----
 drivers/usb/host/xhci-mem.c     |   24 +++++++-----------------
 drivers/usb/host/xhci.c         |   20 ++++++++------------
 drivers/usb/host/xhci.h         |    3 +++
 4 files changed, 19 insertions(+), 33 deletions(-)

--- a/drivers/usb/host/xhci-debugfs.c
+++ b/drivers/usb/host/xhci-debugfs.c
@@ -214,14 +214,11 @@ static void xhci_ring_dump_segment(struc
 
 static int xhci_ring_trb_show(struct seq_file *s, void *unused)
 {
-	int			i;
 	struct xhci_ring	*ring = *(struct xhci_ring **)s->private;
 	struct xhci_segment	*seg = ring->first_seg;
 
-	for (i = 0; i < ring->num_segs; i++) {
+	xhci_for_each_ring_seg(ring->first_seg, seg)
 		xhci_ring_dump_segment(s, seg);
-		seg = seg->next;
-	}
 
 	return 0;
 }
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -224,7 +224,6 @@ static int xhci_update_stream_segment_ma
 		struct radix_tree_root *trb_address_map,
 		struct xhci_ring *ring,
 		struct xhci_segment *first_seg,
-		struct xhci_segment *last_seg,
 		gfp_t mem_flags)
 {
 	struct xhci_segment *seg;
@@ -234,28 +233,22 @@ static int xhci_update_stream_segment_ma
 	if (WARN_ON_ONCE(trb_address_map == NULL))
 		return 0;
 
-	seg = first_seg;
-	do {
+	xhci_for_each_ring_seg(first_seg, seg) {
 		ret = xhci_insert_segment_mapping(trb_address_map,
 				ring, seg, mem_flags);
 		if (ret)
 			goto remove_streams;
-		if (seg == last_seg)
-			return 0;
-		seg = seg->next;
-	} while (seg != first_seg);
+	}
 
 	return 0;
 
 remove_streams:
 	failed_seg = seg;
-	seg = first_seg;
-	do {
+	xhci_for_each_ring_seg(first_seg, seg) {
 		xhci_remove_segment_mapping(trb_address_map, seg);
 		if (seg == failed_seg)
 			return ret;
-		seg = seg->next;
-	} while (seg != first_seg);
+	}
 
 	return ret;
 }
@@ -267,17 +260,14 @@ static void xhci_remove_stream_mapping(s
 	if (WARN_ON_ONCE(ring->trb_address_map == NULL))
 		return;
 
-	seg = ring->first_seg;
-	do {
+	xhci_for_each_ring_seg(ring->first_seg, seg)
 		xhci_remove_segment_mapping(ring->trb_address_map, seg);
-		seg = seg->next;
-	} while (seg != ring->first_seg);
 }
 
 static int xhci_update_stream_mapping(struct xhci_ring *ring, gfp_t mem_flags)
 {
 	return xhci_update_stream_segment_mapping(ring->trb_address_map, ring,
-			ring->first_seg, ring->last_seg, mem_flags);
+			ring->first_seg, mem_flags);
 }
 
 /* XXX: Do we need the hcd structure in all these functions? */
@@ -438,7 +428,7 @@ int xhci_ring_expansion(struct xhci_hcd
 
 	if (ring->type == TYPE_STREAM) {
 		ret = xhci_update_stream_segment_mapping(ring->trb_address_map,
-						ring, first, last, flags);
+						ring, first, flags);
 		if (ret)
 			goto free_segments;
 	}
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -41,15 +41,15 @@ MODULE_PARM_DESC(quirks, "Bit flags for
 
 static bool td_on_ring(struct xhci_td *td, struct xhci_ring *ring)
 {
-	struct xhci_segment *seg = ring->first_seg;
+	struct xhci_segment *seg;
 
 	if (!td || !td->start_seg)
 		return false;
-	do {
+
+	xhci_for_each_ring_seg(ring->first_seg, seg) {
 		if (seg == td->start_seg)
 			return true;
-		seg = seg->next;
-	} while (seg && seg != ring->first_seg);
+	}
 
 	return false;
 }
@@ -764,14 +764,10 @@ static void xhci_clear_command_ring(stru
 	struct xhci_segment *seg;
 
 	ring = xhci->cmd_ring;
-	seg = ring->deq_seg;
-	do {
-		memset(seg->trbs, 0,
-			sizeof(union xhci_trb) * (TRBS_PER_SEGMENT - 1));
-		seg->trbs[TRBS_PER_SEGMENT - 1].link.control &=
-			cpu_to_le32(~TRB_CYCLE);
-		seg = seg->next;
-	} while (seg != ring->deq_seg);
+	xhci_for_each_ring_seg(ring->deq_seg, seg) {
+		memset(seg->trbs, 0, sizeof(union xhci_trb) * (TRBS_PER_SEGMENT - 1));
+		seg->trbs[TRBS_PER_SEGMENT - 1].link.control &= cpu_to_le32(~TRB_CYCLE);
+	}
 
 	xhci_initialize_ring_info(ring, 1);
 	/*
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1263,6 +1263,9 @@ static inline const char *xhci_trb_type_
 #define AVOID_BEI_INTERVAL_MIN	8
 #define AVOID_BEI_INTERVAL_MAX	32
 
+#define xhci_for_each_ring_seg(head, seg) \
+	for (seg = head; seg != NULL; seg = (seg->next != head ? seg->next : NULL))
+
 struct xhci_segment {
 	union xhci_trb		*trbs;
 	/* private to HCD */


