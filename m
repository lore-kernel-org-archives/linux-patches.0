Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626343;
	b=d/2cL8acZXF2KzaLuoTzuwjedn0vc7GfmYUHdFjD4MBAUqsE29hwmeBHgV2XZZkWHWsJ
	 iubvcUHjJ3alnm6rb3GRLfQjkxnDtdG1npc4bpRqB4Ae5hXtukbSm9l8LIT3NMZKl7EYm
	 K70Bgi/Hq2sgv/wviOx02WZ+nj4JBOsJwkJpNT334wnJjPZymF2IcMAN4lxF9TJXgrCTt
	 jdGbyzWCGhyu0QN2g3IetRihAI3FxwnQX6Iomx7ouFwoITJYo/UEerEPG5WNHDxHdKTj3
	 g/718d7of8YDrwGXHZShMFoebQ4ndy7/G0Ro/V6gEf92tmFnP1vsuZiEJbN0YWKQi/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626343;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Lyo5s8tG53jVooZ003Jv+XuduAbpIBvVqgptKIQpWK0=;
	b=sTimjEEuywnjrF8LJj61eL5AERPB1/SSFjYhD6FrCx9pevm/AzcIJI/1XrNALnJbB6VK
	 sWXVLl/Djb7AXgkwNNXdo/QFKmQkCKStdz20qsDzEhhNbHSack7KzRXxcutPIwsLNCEG8
	 k6mCX05rfcPD+To7qTtyyqT/8xCppSV57U9BHGL9yUXlCyTrxrXsbv+rtGmA4q1ndvnlE
	 V+JMEI4fR9Q1WV/qEIyeXvQrDJYx1Gjp5/CvyMBPHEwHGZ6yR5eBdC+MSC9fc79DuWBUT
	 1bbYO+O2H5N/EG7k0vkY4PcTIDv3TUiV3pIajkF6x4WcgW3TGIufPxU7jKlm8ziyD8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Eh+BSqaD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56918606A321;
	Wed, 25 Nov 2026 17:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Eh+BSqaD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A78141F000CA;
	Wed, 25 Nov 2026 17:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626343;
	bh=Lyo5s8tG53jVooZ003Jv+XuduAbpIBvVqgptKIQpWK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Eh+BSqaDrM9+JBYNKfMPoKhM7084JFAmuLkhg4lT/eYzjRGUeBtp4o4lbIJ6/veiZ
	 eJoKoGgKngAxOETmT0RQRpCG59eo5ZHmS3UVx5ehwoSTcGkFXVGRIq5U7S3Ogc78hR
	 aVOYz2Agp1CjSMKNZoa6OJINWKQxqdx/E6gaxblI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Baldin <DBaldin@dspace.de>,
	Pascal Kneuper <PKneuper@dspace.de>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 813/816] net: stmmac: restore NET_IP_ALIGN in the RX DMA offset
Date: Wed, 25 Nov 2026 15:39:21 +0100
Message-ID: <20261125143907.989717262@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pascal Kneuper <PKneuper@dspace.de>

commit 23680bf5f8c69c923546b84a8e6c401bef8b88fe upstream.

Since the RX path was converted to zero-copy, the page pool page is handed
to the stack directly as the skb head, and the offset the DMA engine writes
at is what determines the alignment of the packet headers.

Before the conversion the payload was copied into an skb obtained from
napi_alloc_skb(), which reserves NET_SKB_PAD + NET_IP_ALIGN. The
conversion moved the headroom into stmmac_rx_offset() but did not carry
over NET_IP_ALIGN, so on architectures where NET_IP_ALIGN is 2 the IP
header now lands misaligned:

  64 (NET_SKB_PAD) + 14 (ethernet) + 20 (IP) = 98

Same for the XDP branch:

  256 (XDP_PACKET_HEADROOM) + 14 (ethernet) + 20 (IP) = 290

On ARM32 this is fatal, because ldm and ldrd trap on unaligned addresses
even when CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS is set.

Any received echo request panics the machine, e.g:

  Unhandled fault: alignment exception (0x001) at 0x81873062
  Internal error: : 1 [#1] SMP ARM
  Hardware name: Altera SOCFPGA Arria10
  PC is at icmp_echo+0x38/0xa8
  LR is at icmp_rcv+0x22c/0x370
  Call trace:
   icmp_echo from icmp_rcv+0x22c/0x370
   icmp_rcv from ip_protocol_deliver_rcu+0x2c/0x224
   ip_protocol_deliver_rcu from ip_local_deliver+0xc8/0x1a0
   ip_local_deliver from ip_sublist_rcv_finish+0x3c/0x50
   ip_sublist_rcv_finish from ip_list_rcv_finish+0x110/0x118
   ip_list_rcv_finish from ip_list_rcv+0xc8/0xdc
   ip_list_rcv from __netif_receive_skb_list_core+0x170/0x1c0
   ...
   napi_complete_done from stmmac_napi_poll_rx+0xcb0/0x1030
  Code: e24dd068 e59020a0 e28dc010 e0822001 (e8920003)
  Kernel panic - not syncing: Fatal exception in interrupt

The faulting instruction is the ldm of *icmp_hdr(skb) in icmp_echo().

Fix by adding NET_IP_ALIGN back to the RX offset, which restores the
alignment the stack used to get.

Note that commit a955318fe67e ("stmmac: align RX buffers") made a similar
change in 2021 and was reverted by commit 12d125b4574b ("stmmac: Revert
"stmmac: align RX buffers"") because it caused packet corruption. That
patch raised the offset from 0 without adjusting the buffer size
accounting, so the DMA engine could arguably write past the end of the RX
buffers, though this was never root caused.
Commit df542f669307 ("net: stmmac: Switch to zero-copy in non-XDP RX
path") since derives the page pool allocation from stmmac_rx_offset(), so
the extra bytes are accounted for.

Fixes: df542f669307 ("net: stmmac: Switch to zero-copy in non-XDP RX path")
Cc: Daniel Baldin <DBaldin@dspace.de>
Signed-off-by: Pascal Kneuper <PKneuper@dspace.de>
Link: https://patch.msgid.link/20260824125014.47862-1-PKneuper@dspace.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1327,9 +1327,9 @@ static void stmmac_display_rings(struct
 static unsigned int stmmac_rx_offset(struct stmmac_priv *priv)
 {
 	if (stmmac_xdp_is_enabled(priv))
-		return XDP_PACKET_HEADROOM;
+		return XDP_PACKET_HEADROOM + NET_IP_ALIGN;
 
-	return NET_SKB_PAD;
+	return NET_SKB_PAD + NET_IP_ALIGN;
 }
 
 static int stmmac_set_bfsize(int mtu, int bufsize)


