Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047655;
	b=ASBwzlEG7BAJ6saP/BwmGKKY6040pIe8qFjjvwNRCPRUZRoFvrzTxPv/gTgJ5j33zu+h
	 AG5lKfCDuMERKImmeTpK3kCEr1VzhevOZd/jHFifzp6waiGs8bD+8B0zPVSM1xZ1eFoIL
	 PH+7CG4lHVIKLWdVp+qWAnpxd7Dw4yb4gbVrfUCnsiwtwUhLXGwqM86yErxL2VPZtOUzY
	 2LMlFjZbJtTG8p9rlpB1H7NpDaX0Nq548kuQzx0w0EiEjKH5WLZB+adTPPFU7BLVUsYge
	 u8NzO+mGZj2O7ofeoTAB7WOasvAk73dIcguJ3UMxrgV+yF6pVwgNK2/+oP0LGZJ3lvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047655;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ORSQ++jKxXzRQsPkknqOOwJ4Vtw7IN5J7SixHtj6Bxs=;
	b=N8z2Cwvfo5Xn/cv/LX1EcozEipENv4D2aQvEDUgj5/lRU14XeysMkqMNNZQ2wr033Rth
	 CZG/wFUVNFwgPgljMLP7eDETf7Y7p716AiD7+HrB02uld6eDI8ROuKlWEEn6VIHujKz2+
	 OJMYITqGCgHmNJLMuPeaSWVQszLhw1kU+lJoAon83buqdakzxvqb34h3JCPAYCFcQrRt+
	 4m5EGpHfYtEDKZp3ZCsLZteg71wEw/oCgg9VziaqBm4lLqunP/116jIN2Uk1Dyyomk1rI
	 0k0JfIqZLwDxdqnoTADqCuu65LOZHSV0b70ylZwowxkWJpgRPVD2wd/hGP4uLhCZeGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eQ194LhC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE37606A331;
	Thu, 19 Nov 2026 00:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eQ194LhC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1AEF1F000CC;
	Thu, 19 Nov 2026 00:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047655;
	bh=ORSQ++jKxXzRQsPkknqOOwJ4Vtw7IN5J7SixHtj6Bxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eQ194LhCYPVtywfWdoRo+Jk2o+K8BlT5jFCiwSqVubK7m6zgBMq8TptKGM0TOeT0i
	 j7OpeGH+Ml9FA/xNSgLKvFNpRAvRBZ1lmsP8E0WG9ruBpAoX/qoXhyfS3o97zDsnVb
	 wDR3+jdmC1Xgvm7aal8pitrtltp5J5HXimHwWnBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Will Deacon <will@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1715/2857] vsock/virtio: Rename virtio_vsock_skb_rx_put()
Date: Wed, 18 Nov 2026 15:45:49 +0100
Message-ID: <20261118150303.077624092@linuxfoundation.org>
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

[ Upstream commit 8ca76151d2c8219edea82f1925a2a25907ff6a9d ]

In preparation for using virtio_vsock_skb_rx_put() when populating SKBs
on the vsock TX path, rename virtio_vsock_skb_rx_put() to
virtio_vsock_skb_put().

No functional change.

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Will Deacon <will@kernel.org>
Message-Id: <20250717090116.11987-9-will@kernel.org>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Stable-dep-of: d5e912448cd9 ("vhost/vsock: size receive SKBs from declared payload")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vsock.c            | 2 +-
 include/linux/virtio_vsock.h     | 2 +-
 net/vmw_vsock/virtio_transport.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index c08eb6774c427..1fc03038e5543 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -372,7 +372,7 @@ vhost_vsock_alloc_skb(struct vhost_virtqueue *vq,
 		return NULL;
 	}
 
-	virtio_vsock_skb_rx_put(skb, payload_len);
+	virtio_vsock_skb_put(skb, payload_len);
 
 	nbytes = copy_from_iter(skb->data, payload_len, &iov_iter);
 	if (nbytes != payload_len) {
diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index 3b97af88edbca..f62ec310059b2 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -46,7 +46,7 @@ static inline void virtio_vsock_skb_clear_tap_delivered(struct sk_buff *skb)
 	VIRTIO_VSOCK_SKB_CB(skb)->tap_delivered = false;
 }
 
-static inline void virtio_vsock_skb_rx_put(struct sk_buff *skb, u32 len)
+static inline void virtio_vsock_skb_put(struct sk_buff *skb, u32 len)
 {
 	skb_put(skb, len);
 }
diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index feda96522b4f6..b4b09d0b04325 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -528,7 +528,7 @@ static void virtio_transport_rx_work(struct work_struct *work)
 			}
 
 			if (payload_len)
-				virtio_vsock_skb_rx_put(skb, payload_len);
+				virtio_vsock_skb_put(skb, payload_len);
 
 			virtio_transport_deliver_tap_pkt(skb);
 			virtio_transport_recv_pkt(&virtio_transport, skb);
-- 
2.53.0



