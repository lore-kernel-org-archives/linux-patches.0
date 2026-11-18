Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039072;
	b=4IzuWYGQp9dUH5oy52aBeJLEGB6WaIKpAK+rdm+a0RWfpnLbOkN9OAFo4WqEAB3faqAT
	 qX1T8Y/OkRFsgB4eT2uRwjcGndZJ7IiAWrI0HGxI3DSL6QCZBrHfK3dkflNX93A4wtib0
	 D2eNV8r3ZQJOzst4wAuacCqAHQObLs+QjJiR2is+O+GOIVOf2yweHNlhTj5IcdFTOFA3l
	 zcZb2zTnMqea45CPQDF7b20+SSvkfVhpsRUF1tYhzySmyE6UIWVB9k0y4pY6gvOgk5BGq
	 Xc6okZ6Q3Eyeu0SDkyy0LPoFTVWE6byc7/Ehg7CNHp0DlcKeJ3HVkFHYkhOjgA3SvLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039072;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v/DoxAX2hKIrcbvczFy3GSwAi/YYFYwSRiOdTkWCQ8c=;
	b=lxDLbLyK0gcBOBC0nEvaZ6PoRAMXJ809ZvZsWc4DFluZty+yI3ozF2qTzMCOveBMRqGG
	 rnikVUS9IuH6sukNIPF7NmywmTYhZ+8SrJGfomCjy9/pW20P2sYIgz5WSiWGNPoxY4eMp
	 FLNxpjKMvZiCo1FiEncbTSVZoI/g1laQG9XBBkpMxpGnukUYgdw0WR6wBejwez4S4HMOD
	 7rmjmhL9TlEHwiXwomkedO08NXPQDHmbGs3vSzi8vkiUs/d7+R57OU/1VnH1gpx7mDKSy
	 jPrF9ULG2rQOHe3X92lqTdhcq8Xl2ePnOa0zgO5Qb+UadpcxSuc4rVcD2QZlKJCUGNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wAVhMZrz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A087D606A33B;
	Wed, 18 Nov 2026 21:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wAVhMZrz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9FDF1F000C7;
	Wed, 18 Nov 2026 21:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039072;
	bh=v/DoxAX2hKIrcbvczFy3GSwAi/YYFYwSRiOdTkWCQ8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wAVhMZrzo7ifdCzz0xguwmY1EBonq+tO/LFPKB2J0pp2zBb0oOoiQbLWj8nWN7Uwg
	 iVpNWSZEDH1cmOOHyeYVR4yAUouENx15loeZaCuQN94cTWhrT1KZf6Ug4Bm807Tylm
	 PjjWkznWZjGmq1LQ9F0JK8T+xPpN4VuL0fE/uiJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Will Deacon <will@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1970/3318] vsock/virtio: Move length check to callers of virtio_vsock_skb_rx_put()
Date: Wed, 18 Nov 2026 15:43:12 +0100
Message-ID: <20261118150421.181461501@linuxfoundation.org>
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
index c3fceb7892988..a5bbbb5d0273e 100644
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
index 5148b035a8f38..3e91cde041037 100644
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
index 6c7221a032ee5..fb7acdf4ad2b3 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -530,7 +530,9 @@ static void virtio_transport_rx_work(struct work_struct *work)
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



