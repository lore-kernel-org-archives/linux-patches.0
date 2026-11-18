Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039075;
	b=RYdBmZwRJwg9tcHYEOIKiNAyLQ+gdwNw7qdWbOjXtxFDNki61KEAemrYtEy/z+z6ILjM
	 HE6vOFdtKrxmuoUb+xjwHYyHbKKf7eIIkMcwuwYweNuE6GnWOEvrWKWFn6QLp4546DO9U
	 GE/id9fLib0irCxLTVWXOPrib6jAqXJgw61dK0jmSl/Vkcg1JXJFcfXsJeEbZelXjCoXb
	 kzeGK0OgDM+xu47LPyloyM5RFiG39B6w/7/OIWF3PSCgWN3pgKRscufRd42EPaVJbpeYR
	 r+N1xQ4PlqID//4jPhBbmgx73SER3JrT6Oc/QM2nVF65Cn5mIc7NX3x61q36wwPhQeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039075;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uTx+N//5Uj0xArtB8uDyWfzAjR1fNCIKWPXg1ZAimB4=;
	b=iIDT20PyI3LKCsmbOZReagfFeHbj5sVSSZlgd1R6UT07U/92fsjb/g9iDR0tVkUEdvWD
	 syn9syUqQQUW0eP5IaqRjtUlQ0Q/5jKZ5TH4z8OhKZGScgXG7sj7jNLPeL1/4DhKlH7h7
	 lZszodwHGybjuS+sZeSAepe+yllSxUFI7CO/woVl50nzn7qV233d4rxIldTQzd1/VmdnP
	 ar3xFJTA+tWEduxDi4eHPKEAC3iwWkUbbp5zB7AV7yQtOQuMMYaIdeBLNZfUNxOqQoe3L
	 hxAl3X0oQkjMW9XIy9+CeyaQG9Pu9aNDa8n8UOqulByvdCfn9HyhdH3YhvcccwZDSZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="M4kBp3/X";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58ECD60A260B;
	Wed, 18 Nov 2026 21:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M4kBp3/X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEF6F1F000CB;
	Wed, 18 Nov 2026 21:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039075;
	bh=uTx+N//5Uj0xArtB8uDyWfzAjR1fNCIKWPXg1ZAimB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M4kBp3/XdsJYmBaWyl+yUMQ/G23PxFDBI9b5OuJeae1GHnCH+Di7852ofjFUfFkbK
	 8B8lDUmroyBhmf1A/Ov4SGd/1eg+2uMQACt/ge57gJkfZzTior7MYLiBBY8z8+wn/q
	 If+ud7p4yVHlnUZx8WscZLRyJAq+XUq+FmiBmrUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Will Deacon <will@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1971/3318] vsock/virtio: Rename virtio_vsock_skb_rx_put()
Date: Wed, 18 Nov 2026 15:43:13 +0100
Message-ID: <20261118150421.213197543@linuxfoundation.org>
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
index a5bbbb5d0273e..f197f0c28022e 100644
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
index 3e91cde041037..a8ebcb04d0c80 100644
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
index fb7acdf4ad2b3..1fc8025bfb06d 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -531,7 +531,7 @@ static void virtio_transport_rx_work(struct work_struct *work)
 			}
 
 			if (payload_len)
-				virtio_vsock_skb_rx_put(skb, payload_len);
+				virtio_vsock_skb_put(skb, payload_len);
 
 			virtio_transport_deliver_tap_pkt(skb);
 			virtio_transport_recv_pkt(&virtio_transport, skb);
-- 
2.53.0



