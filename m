Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059459;
	b=fIkpJz34AOZhywk3uAFm9i7dsCczLx0gyiD/Ry3gSEdgYEtDh9C5p2+Iy7rqKIe2rZ4h
	 cootAzCaFHljR3RIwpNWYkGa7xvepPu6q01qvd+U/xQwlUw6ifX4oEdHM44NkvUur4+kz
	 fPC2YOCTHGuOzp/CDBiWufZONTjmZMJmZ8otM9vCgrrHLasn4WFv8mGvN/bKbOq/7bo61
	 9jIHriWLUBHHMBuIUioIsetGuV8clvjBIyaYntvJqIiPA4lYH5DGGuKZhk7izSY/FWeCU
	 dxwrlOKcGIk8P+ZcYtOIhNco3A3OOH3oiMPk4w/LD77zAEGfPNzVewveFjpoPy6pbIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059459;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Aebjq3mR9nLzoI3XVmBRdfyrxaKsvxApCvYKYlnIuLY=;
	b=Fr+XpiOly6HO4flR9p6CNgu3ASNK0/XJWrT4vIZITCVYw2SfMjM6bC4+YG1w4G4X9KVU
	 uFlQAE00A6zDkoq5X9DSnMEaq0bNasQF2sFHBDbr7U/mqzTGGfoMza9C8zUOXoOTEgY47
	 fqoTR77/h/4ytOvM5ZuplEOah2HebwNNy4kfDC+2ilSJ5/34MHuad+E31swRgVwGpvWhX
	 6AYQvRCs1MnjoTLk7741Nqw+rZIqxlhNSCjk2TuowkG2OqI7VRyb6WBh86kp800jsyaiB
	 VvqeVa3dfAq8zyGzLoTXcANxXCV5jLUbQU1CYiOL9NOo7z5E5uzWbGicPzpphhDCmMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FslHDYuB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07639606A31C;
	Thu, 19 Nov 2026 03:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FslHDYuB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F1B21F000C4;
	Thu, 19 Nov 2026 03:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059458;
	bh=Aebjq3mR9nLzoI3XVmBRdfyrxaKsvxApCvYKYlnIuLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FslHDYuB1ZX+CCXD6oEuby3Gv+n8tM8gtMoDaGjLwRZJvVRX683QdCTjHzGsqqX2Z
	 mJa5w9VEzRq7IAuDja8Ge4eJUokX3b7W7HYGRes/eCNuCkFVzKdgCo+cGMN3a9dCtl
	 2GLeIlzFnV25TI3n5ksZ0QU7gd+6RCuGUjTXNnTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+fd80bc5967eb22c3@bugs.sh,
	Michal Pecio <michal.pecio@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0842/1848] usb: xhci: Fix bounce buffer overflow
Date: Wed, 18 Nov 2026 15:48:00 +0100
Message-ID: <20261118145951.880013829@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Pecio <michal.pecio@gmail.com>

[ Upstream commit 68c5cb7574c567e83ba95258cb146db95e069a87 ]

High-speed devices with out of spec 1024 byte bulk endpoints exist and
are allowed by USB core, but xhci-hcd always sets packet size to 512.
The exact nature of these devices isn't documented, commit fb5ee84ea72c
("USB: Accept bulk endpoints with 1024-byte maxpacket") only states
that they "don't work with xHCI host controllers", whatever it means.

But somebody (or a malicious device) can try, and then the driver will
allocate a 512 byte bounce buffer for this endpoint and may write up to
1024 bytes into it if particular scatter-gather URBs are used, because
xhci_align_td() obtains packet size from the descriptor. Fix this.

As a side effect, TRBs will be aligned to the packet size chosen by the
driver on all endpoints of all speeds. Alignment serves the xHC, not
device, so this is fine. Only out of spec devices are affected anyway.

Reported-by: co+fd80bc5967eb22c3@bugs.sh
Link: https://lore.kernel.org/linux-usb/D4tcSGerkYkIV1DmaUo1t8TaR5qQElDLkidn@bugs.sh/
Fixes: f9c589e142d0 ("xhci: TD-fragment, align the unsplittable case with a bounce buffer")
Cc: stable@vger.kernel.org
Signed-off-by: Michal Pecio <michal.pecio@gmail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://patch.msgid.link/20261009151624.618967-11-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ sashal: adjusted context for usb_endpoint_maxp() in place of xhci_usb_endpoint_maxp() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-ring.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 0e0045a81f92e..51b614c0c9357 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -3389,15 +3389,13 @@ static u32 xhci_td_remainder(struct xhci_hcd *xhci, int transferred,
 
 
 static int xhci_align_td(struct xhci_hcd *xhci, struct urb *urb, u32 enqd_len,
-			 u32 *trb_buff_len, struct xhci_segment *seg)
+			 u32 *trb_buff_len, struct xhci_segment *seg, u32 max_pkt)
 {
 	struct device *dev = xhci_to_hcd(xhci)->self.sysdev;
 	unsigned int unalign;
-	unsigned int max_pkt;
 	u32 new_buff_len;
 	size_t len;
 
-	max_pkt = usb_endpoint_maxp(&urb->ep->desc);
 	unalign = (enqd_len + *trb_buff_len) % max_pkt;
 
 	/* we got lucky, last normal TRB data on segment is packet aligned */
@@ -3542,9 +3540,8 @@ int xhci_queue_bulk_tx(struct xhci_hcd *xhci, gfp_t mem_flags,
 		if (enqd_len + trb_buff_len < full_len) {
 			field |= TRB_CHAIN;
 			if (trb_is_link(ring->enqueue + 1)) {
-				if (xhci_align_td(xhci, urb, enqd_len,
-						  &trb_buff_len,
-						  ring->enq_seg)) {
+				if (xhci_align_td(xhci, urb, enqd_len, &trb_buff_len,
+						ring->enq_seg, ring->bounce_buf_len)) {
 					send_addr = ring->enq_seg->bounce_dma;
 					/* TD bounced at least, and last on this seg */
 					td->bounce_seg = ring->enq_seg;
-- 
2.53.0



