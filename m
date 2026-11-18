Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051733;
	b=eirdc4Wq27M+qR1kgbcqJzya9Jq5peYkVivTWE0oxwy59RX6hz8ioWb9T3X1Kvgf9nAA
	 rd4JtGTyIcfq3zkF5PQl7pmHF2fYvNKEVhWp0uJOppf8iJZhQynHQMGfe3i8n0pWtYh84
	 XPiq3+cIkYaTa2PgOWuLn9T34IJRQhtnNFIagJZCs0XQpXh8VVKHlzL0q2Jzdgn+Q/vF1
	 GbAUZwGFUdpWkGG4VO+i3GAp4jUwO7TddG+2+z+gLwZZ5sUhHznAgjii3htKKMlukgBeG
	 CGb3Nj8iq4xgIiVN7D7YfVEq+mY5Zw7NhvQ26ASphFmJUs6VfCGhKJRf8Lvx8bhV4KA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051733;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bvY6pklqHe10vTQqZYFoUj76VZc5E9CB3OqAwY1bxus=;
	b=Lm/4gayMDzL7HGOgyrsE63aDF7jvSyzUpGfrUNxMGK44rkV2fzFk1SDrqtpB3hReAjDF
	 lfRVnj9xGNsjRx285nBKqkgIItXgLAuKGlhlOcc2QfvTE2w1pfA7aQQXPDeodwjJZaBL0
	 E1wsx1spu3DVr55uMJpYiToO0uHgbZ5P/w6XsKrTgg8cv5vNhaUuvmWZLFMxXYWpWlbNM
	 roMvMsfRiS9NaVWO8NhW5mnuOxnq6eK5sGN7u+4POxCCoLpmHOKPQoxzlyty8E7/1DcDv
	 SWrtb8NPaG6EGTS38hVK7hLMJI7tSV5wImtHnNTMNRlAayDxnw79CvDrSJ0RZFAayuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qL4z5xmV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE488606A325;
	Thu, 19 Nov 2026 01:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qL4z5xmV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C7441F000C4;
	Thu, 19 Nov 2026 01:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051733;
	bh=bvY6pklqHe10vTQqZYFoUj76VZc5E9CB3OqAwY1bxus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qL4z5xmVfqsYF1dFq0VYH9fUgqmjwVQ7scKKiRyrTsh47yjBwNj2pSKyNzRK6TP0f
	 /L79iUEBx1p/ELJqhuSgnkTgnUX7QBUSKVhjDBUrUohzf1IPjj7FGOl1IpAypTWT/J
	 hf6VTKdh6t4NLGh5nP02rzGqqHTBcxoXZpBYmZVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Jie Law <law.wei.jie@gt.tech.gov.sg>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 0264/2214] net: usb: pegasus: do not advance rx_skb->data on dropped frames
Date: Wed, 18 Nov 2026 15:32:20 +0100
Message-ID: <20261118150020.658101369@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Jie Law <law.wei.jie@gt.tech.gov.sg>

commit bfa09dccf98cf78dd9282259b2140bd1472f5ae9 upstream.

For the 0x8513 chip, read_bulk_callback() skips the 2-byte receive
header by advancing pegasus->rx_skb->data in place. This is done before
the pkt_len > PEGASUS_MTU check, and when that check drops the frame
the good path resubmits the same skb with the advanced rx_skb->data as
the transfer buffer, still PEGASUS_MTU bytes long.

Every frame with an oversized length field therefore moves the receive
buffer two more bytes towards the end of the skb data area. A device
that keeps sending such frames makes the host controller write received
data over skb_shared_info and past the end of the allocation, and the
corrupted skb_shared_info is used when the skb is eventually freed.
With an emulated device sending frames filled with 0x5a on a KASAN
kernel:

  BUG: KASAN: slab-out-of-bounds in dummy_timer+0xade/0x3f00 [dummy_hcd]
  Write of size 1536 at addr ffff888105821202 by task swapper/1/0
  ...
  Oops: general protection fault, probably for non-canonical address 0xeb4b474b4b4b4b4c: 0000 [#1] PREEMPT SMP KASAN NOPTI
  KASAN: maybe wild-memory-access in range [0x5a5a5a5a5a5a5a60-0x5a5a5a5a5a5a5a67]
  RIP: 0010:skb_release_data+0x36f/0x800

Only skip the header with skb_reserve() once the frame is going to be
passed up, so the receive buffer always starts at the beginning of the
skb data area. Unlike the old pointer adjustment, skb_reserve() also
moves skb->tail, so the two header bytes now count against the buffer
size: lower the length limit for the 0x8513 accordingly, otherwise a
pkt_len of PEGASUS_MTU - 1 or PEGASUS_MTU would trip skb_over_panic().

Found by code review with LLM assistance and reproduced with an
emulated USB device (raw-gadget + dummy_hcd).

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Wei Jie Law <law.wei.jie@gt.tech.gov.sg>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20261021020310.34045-2-law.wei.jie@gt.tech.gov.sg
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/pegasus.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/usb/pegasus.c
+++ b/drivers/net/usb/pegasus.c
@@ -472,6 +472,7 @@ static void read_bulk_callback(struct ur
 	u8 *buf = urb->transfer_buffer;
 	int rx_status, count = urb->actual_length;
 	int status = urb->status;
+	int rx_offset = 0;
 	__u16 pkt_len;
 
 	if (!pegasus)
@@ -521,7 +522,7 @@ static void read_bulk_callback(struct ur
 	if (pegasus->chip == 0x8513) {
 		pkt_len = le32_to_cpu(*(__le32 *)urb->transfer_buffer);
 		pkt_len &= 0x0fff;
-		pegasus->rx_skb->data += 2;
+		rx_offset = 2;
 	} else {
 		pkt_len = buf[count - 3] << 8;
 		pkt_len += buf[count - 4];
@@ -533,13 +534,14 @@ static void read_bulk_callback(struct ur
 	 * If the packet is unreasonably long, quietly drop it rather than
 	 * kernel panicing by calling skb_put.
 	 */
-	if (pkt_len > PEGASUS_MTU)
+	if (pkt_len > PEGASUS_MTU - rx_offset)
 		goto goon;
 
 	/*
 	 * at this point we are sure pegasus->rx_skb != NULL
 	 * so we go ahead and pass up the packet.
 	 */
+	skb_reserve(pegasus->rx_skb, rx_offset);
 	skb_put(pegasus->rx_skb, pkt_len);
 	pegasus->rx_skb->protocol = eth_type_trans(pegasus->rx_skb, net);
 	netif_rx(pegasus->rx_skb);


