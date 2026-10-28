Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213326;
	b=tzFHi+hsSUBYdgS8RxDi7xt9RNZTi7D4lM7pFOwrvkYnQIpnCgRR9JN2iASA22cBSxLi
	 FqbllLs1YmM+Brd4WW1ReC5FMukn+t0T6XYf6ScLdhbXbiXgHqpoWDQxGLcfKC/Wa23DN
	 MjlbTinv5vAB7Ay9lpLJTmMtZqOo87XDoa++knhLR5FEaJxN3QrqEFIEbU/YoZwV71B8a
	 wPrqDOOYDTdShMXlm5pTlscSKGcDcEVdY80uOpwAn/I3UilCaGwnzJch5sp/r8vuAFwRy
	 0rja0vrfe6v+OK6p3ZHYnuqodq0ZrTvZr9gMqQrYjlGkf+6E7x8T2q5eCFgm43OZsIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213326;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ICh9hf4VhsCwwpuhI/NTBPyIioCesS0LEebvz76+9K8=;
	b=5EOEVOBrHZVhH4FYbGO6yUvfHUfTEmdD6wSqusTlDKKzEQUwhQAGIWr3iSPphUhSTnST
	 IAYlEtRB575pJ6vjsb887kyKxo9A5ENqBp6zhOMdzyyeub6i7QjYNK2qTWZAa7OyKPrg9
	 pOPzJWKoMWGKPUJM5yIIo03vlUxUW5nsmAjjAQ03bsZ5naMwdU9GmHzFfmgA99NePisz4
	 8wkb9EIzXST7E0DJM+mjqo4WGr3s63T5uLRcAwHmdZTgrd9vWSrCBoZK5H7roAGr1rTzl
	 Q9hJNzvPzfcoSuX1zwdFfMPmnmed2a7lKJKa0FSNzwDFMh9h/3q4uFi1e7u/Cq31cJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W07QRqRG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF792606A31C;
	Wed, 28 Oct 2026 18:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W07QRqRG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E6421F01825;
	Wed, 28 Oct 2026 18:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213325;
	bh=ICh9hf4VhsCwwpuhI/NTBPyIioCesS0LEebvz76+9K8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W07QRqRGF/6a79mF5zylqxZ1hCLNA7/W6YbMKA392ZnXmlGO3zdAslGy2OJ8eB1ic
	 H/kmiP/gQjqh0Co2F4/OiKq29fASXPZiNbaKGLLRiV9IxhEj++0Orh0EZsC5lXZ/6T
	 Td13DenW8/1h1Ag3t5ghWn4Y7T5X7UdNpuP14InY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fredrik Nyberg <fredrik.nyberg@volvocars.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 0465/1887] net: usb: ax88179_178a: fix rx frame length for non-last packets
Date: Wed, 28 Oct 2026 17:42:41 +0100
Message-ID: <20261028170509.815552038@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fredrik Nyberg <fredrik.nyberg@volvocars.com>

commit 9b6c20f788472d2042717a3c2f1bc60b2b77083e upstream.

Commit 4ce62d5b2f7a ("net: usb: ax88179_178a: stop lying about
skb->truesize") replaced skb_clone() with a copy into a new skb for
every packet of a bulk-in transfer except the last one. The copy skips
the 2-byte IP alignment pseudo header but still copies pkt_len bytes,
and pkt_len includes that header. Each of these frames is therefore
delivered with two extra trailing bytes: the 0xeeee pseudo header of
the next slot when the frame ends on an 8-byte boundary, or slot
padding otherwise. The last packet is still trimmed to pkt_len - 2.

IPv4 and IPv6 trim the extra bytes, so most traffic is unaffected.
Anything that relies on the frame length is not. MACsec takes the ICV
from the last 16 bytes and drops every such frame as InPktsNotValid. In
our setup that was 0.2-1.2% of received MACsec frames, depending on how
many frames shared a transfer, including service discovery multicast.

Allocate and copy pkt_len - 2 bytes, like the last-packet path.

Fixes: 4ce62d5b2f7a ("net: usb: ax88179_178a: stop lying about skb->truesize")
Cc: stable@vger.kernel.org
Signed-off-by: Fredrik Nyberg <fredrik.nyberg@volvocars.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20261002-ax88179-rx-len-v1-1-f01a2a295079@volvocars.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/ax88179_178a.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1461,11 +1461,11 @@ static int ax88179_rx_fixup(struct usbne
 			return 1;
 		}
 
-		ax_skb = netdev_alloc_skb_ip_align(dev->net, pkt_len);
+		ax_skb = netdev_alloc_skb_ip_align(dev->net, pkt_len - 2);
 		if (!ax_skb)
 			return 0;
-		skb_put(ax_skb, pkt_len);
-		memcpy(ax_skb->data, skb->data + 2, pkt_len);
+		skb_put(ax_skb, pkt_len - 2);
+		memcpy(ax_skb->data, skb->data + 2, pkt_len - 2);
 
 		ax88179_rx_checksum(ax_skb, pkt_hdr);
 		usbnet_skb_return(dev, ax_skb);


