Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034426;
	b=p44VNI2BCw2pvJy+OuQv+Yad4zvUqFneZFk5iaaMJ9fCExXHbg9kwzWP8+/zRbQx+k38
	 dNwWQI56S+4+b2tTt++eRZDiab0vYFJJdV2axki36ki2l0afC2VGccdU9oN+gMdgot4hV
	 ytlar0gClpi0C0Zf4NunHaQVE4WiA8xqNQFUBRg5LRjEhykHQm89S2JGUyhUqOzp+wL4v
	 f3BGH43XtfgkTs0lrXu0sK+5LUWWWd9p8xUxAlVPjnXOGhHRESxf6F/q8ERYnspzy4NCM
	 gR8IG0E9mYr4ec+6b/VF2+WSeyHe/nh11MjiuLFM1JApTRBT8A4RGzMkLxq0nanddjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034426;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EkWsGc3uay0ExQqZbSzp5tuUmEjD46lrESdN9jM4JJQ=;
	b=S97puQI73masL3ALXXVxTHmTCXW3zXizsEM/djgDNs8uPzWOx65/0JuplOrYVWMu6Aeb
	 bUD/bVA9GtMh/mEKVs/ejKhSh7uAMz7aQV+H0A2oBUiufExDob40X2AmYS5J1sGN+xH6f
	 Qbe/J/hxH8lvBxHpSv04jupu2SdztN83qYhQ+166nB8Wt29W19F3SjGeaQ989aDTAYhOg
	 eyBwTdaDggX+bNG2BJWp+7aswFg2vg3zpK240hjovfxfT/vU7M5R021lHtJe/wWtzVRSD
	 0dzL3e6tb5tghzLRJI1zT7Ol1GqtI7/19Gv+p6FFAVum8vgZ4VySJFvR0i4nGXbb1rQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lmSzFhKh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74CA1606A31C;
	Wed, 18 Nov 2026 20:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lmSzFhKh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF2521F000C7;
	Wed, 18 Nov 2026 20:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034426;
	bh=EkWsGc3uay0ExQqZbSzp5tuUmEjD46lrESdN9jM4JJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lmSzFhKhjE88tn3y2rEfNJtQnTO/zjAVBim/f/6ah7HQ3Otmpp38G7XZ1VkHEDA9g
	 pB+J7JWlLek/th9oTGryl+acQguBmkjUFwE+RMyDb6L/z/UMoeP8QoM+xqY7RGpCET
	 ninmZNcInxhcyPS6MpfTWXZiE7ZxL6yWpwOtGkPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Jie Law <law.wei.jie@gt.tech.gov.sg>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 0364/3318] net: usb: pegasus: do not advance rx_skb->data on dropped frames
Date: Wed, 18 Nov 2026 15:16:26 +0100
Message-ID: <20261118150327.079779067@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -464,6 +464,7 @@ static void read_bulk_callback(struct ur
 	u8 *buf = urb->transfer_buffer;
 	int rx_status, count = urb->actual_length;
 	int status = urb->status;
+	int rx_offset = 0;
 	__u16 pkt_len;
 
 	if (!pegasus)
@@ -513,7 +514,7 @@ static void read_bulk_callback(struct ur
 	if (pegasus->chip == 0x8513) {
 		pkt_len = le32_to_cpu(*(__le32 *)urb->transfer_buffer);
 		pkt_len &= 0x0fff;
-		pegasus->rx_skb->data += 2;
+		rx_offset = 2;
 	} else {
 		pkt_len = buf[count - 3] << 8;
 		pkt_len += buf[count - 4];
@@ -525,13 +526,14 @@ static void read_bulk_callback(struct ur
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


