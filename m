Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047652;
	b=vUoqGRU7GbC0qcu7Gv0YiC84nJnd6WwNbHdevC0JnApYyTHYHtcG7/nN3YuhJtt1gR3o
	 z87SrOgaXKs5wgVpsDfcjN+a49+zmbYLUvuNK4FY0/CptWk9rqcz4P6HesRwub0OiTeI0
	 3/sU7r5k0ev4RY1hvZIJjDwzQnvnLgs2G8eWqPOM5YiSKaOID8xoZRNGVaFOpsPYw0cDw
	 oBGRsjYHQ7osUFp6atyNdgHrUL2qudRoG3uJ1U+bcp/IzXXbCNwzarFgIPF2ZCO5FWSGu
	 omEm6ihoy6PK1IG306opE72dKKQkXqivI3LizUBoXfOPbigHOwjwAXGtmv/0FcMAo/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047652;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SIfleQg5V1zZWLx0oA8Kzb/PNKsSczO+EZ1BI59OvYI=;
	b=K2zTBOwMBtb61XqtcaCy1uX4OPuQiRlwKHtcgHMFsefeKRjpxNwCTsaQkaLBq5tMMkam
	 rtb7osvaQqe9xrTV85aIgc+tCWE4URNmgeVVDG4wwBKf0T0ktXRwd4/3IMXJHKD59WO2k
	 osMwKA86hQ5Co8X0DbmSXV9LVBnyK7k5sqoLVNpgzZOKta7YKv+NoycY9O9QuNeP6yf4G
	 3H8mlZ1DRa2v4cuPfGuNiH4MmE8jznMTOttYcYlWgg8NCY4BKRoB2EuJdmHDKTLZDiliU
	 swdefWDzHlI00YthL8sUc7yaSIjl5QdoRPD+bCdWtE5T5rSD2bTXSYvqbvpHDXBu4/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lkM8MJy0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD5BE606A325;
	Thu, 19 Nov 2026 00:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lkM8MJy0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32D0C1F000CD;
	Thu, 19 Nov 2026 00:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047652;
	bh=SIfleQg5V1zZWLx0oA8Kzb/PNKsSczO+EZ1BI59OvYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lkM8MJy0u3WBBVnX/vtW+c30e9eodAUPrRQnbJngLeoYOwSlFfT5szrpC/pg3DJc6
	 bUeF8pieqhECM9IeASijDpBkBESK5SkGBVlI7GMVkF1WV4Mx+mL0iwmkvFes8fOFpT
	 +ghBVmjVDBib3+0myOWTIOpjzvwtXYb8Yu1iKRGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Will Deacon <will@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1714/2857] vsock/virtio: Move length check to callers of virtio_vsock_skb_rx_put()
Date: Wed, 18 Nov 2026 15:45:48 +0100
Message-ID: <20261118150303.043664727@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Will Deacon <will@kernel.org>

[ Upstream commit 87dbae5e36613a6020f3d64a2eaeac0a1e0e6dc6 ]

virtio_vsock_skb_rx_put() only calls skb_put() if the length in the
packet header is not zero even though skb_put() handles this case
gracefully.

Remove the functionally redundant check from virtio_vsock_skb_rx_put()
and, on the assumption that this is a worthwhile optimisation for
handling credit messages, augment the existing length checks in
virtio_transport_rx_work() to elide the call for zero-length payloads.
Since the callers all have the length, extend virtio_vsock_skb_rx_put()
to take it as an additional parameter rather than fish it back out of
the packet header.

Note that the vhost code already has similar logic in
vhost_vsock_alloc_skb().

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Will Deacon <will@kernel.org>
Message-Id: <20250717090116.11987-4-will@kernel.org>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Stable-dep-of: d5e912448cd9 ("vhost/vsock: size receive SKBs from declared payload")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vsock.c            | 2 +-
 include/linux/virtio_vsock.h     | 9 ++-------
 net/vmw_vsock/virtio_transport.c | 4 +++-
 3 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 48002df5ef736..c08eb6774c427 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -372,7 +372,7 @@ vhost_vsock_alloc_skb(struct vhost_virtqueue *vq,
 		return NULL;
 	}
 
-	virtio_vsock_skb_rx_put(skb);
+	virtio_vsock_skb_rx_put(skb, payload_len);
 
 	nbytes = copy_from_iter(skb->data, payload_len, &iov_iter);
 	if (nbytes != payload_len) {
diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index 689e9fc50e1b8..3b97af88edbca 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -46,14 +46,9 @@ static inline void virtio_vsock_skb_clear_tap_delivered(struct sk_buff *skb)
 	VIRTIO_VSOCK_SKB_CB(skb)->tap_delivered = false;
 }
 
-static inline void virtio_vsock_skb_rx_put(struct sk_buff *skb)
+static inline void virtio_vsock_skb_rx_put(struct sk_buff *skb, u32 len)
 {
-	u32 len;
-
-	len = le32_to_cpu(virtio_vsock_hdr(skb)->len);
-
-	if (len > 0)
-		skb_put(skb, len);
+	skb_put(skb, len);
 }
 
 static inline struct sk_buff *virtio_vsock_alloc_skb(unsigned int size, gfp_t mask)
diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 2f3e89cd4ebc2..feda96522b4f6 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -527,7 +527,9 @@ static void virtio_transport_rx_work(struct work_struct *work)
 				continue;
 			}
 
-			virtio_vsock_skb_rx_put(skb);
+			if (payload_len)
+				virtio_vsock_skb_rx_put(skb, payload_len);
+
 			virtio_transport_deliver_tap_pkt(skb);
 			virtio_transport_recv_pkt(&virtio_transport, skb);
 		}
-- 
2.53.0



