Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E2EA2E2DF4;
	Wed, 28 Jan 2026 15:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615387; cv=none; b=AE/knwm1Z4ajyHhOnPC8gLduWHQ0CrbMZdQTULzH4T1vI05tB1pTY4Zkx0TWKPb1uxtHJg9sDNPdtYMIz4j/4de7dNIFDiXHrSPD2tXCYxFk7Wx2g/mXMz9p/yKZBc5jve62WJvUYPF5gdbIZVF2EFhquaJKaw7Xo/wpu7DERTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615387; c=relaxed/simple;
	bh=nRxiH1KHX2rVne2eu3eqt42nboHcfVsp7Qk5O+67pok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H8javzfZFp6ujM8SsGTQ1tLBzv6o4KRWJ4OllUaw7dBV3T3gVf9ihrs+87JYwqaH5ku0elbRG8+1V59eGiV5Tog2VuoFa7hHiRHnY1DiD1qad3vfb36k6j4mHv+7EQhZZLys9sjsCUws9sdc3Nf7tVBfGhl5t5X/7I52J7riC5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eSxXbn4Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eSxXbn4Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E943FC4CEF1;
	Wed, 28 Jan 2026 15:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615387;
	bh=nRxiH1KHX2rVne2eu3eqt42nboHcfVsp7Qk5O+67pok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eSxXbn4QR5EGBA2MOY9QdJOCnL7fHsv85eq3zzRmbpfFk5yCJNoILMm3vsOxH5f0H
	 x3ZCmRcQF3dpuWNtJUvUvEn35GivTVsfs0qTTb1kObI5BRw6b0jdmouLmHJBNRqQlw
	 blfafsQ0IQHgyzH/uoRQqF6dW/UtJgCSWQwHn3UM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"kernel-dev@igalia.com, Heitor Alves de Siqueira" <halves@igalia.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Will Deacon <will@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Heitor Alves de Siqueira <halves@igalia.com>
Subject: [PATCH 6.12 165/169] vsock/virtio: Rename virtio_vsock_skb_rx_put()
Date: Wed, 28 Jan 2026 16:24:08 +0100
Message-ID: <20260128145339.963422213@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Will Deacon <will@kernel.org>

[Upstream commit 8ca76151d2c8219edea82f1925a2a25907ff6a9d]

In preparation for using virtio_vsock_skb_rx_put() when populating SKBs
on the vsock TX path, rename virtio_vsock_skb_rx_put() to
virtio_vsock_skb_put().

No functional change.

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Will Deacon <will@kernel.org>
Message-Id: <20250717090116.11987-9-will@kernel.org>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Heitor Alves de Siqueira <halves@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vhost/vsock.c            |    2 +-
 include/linux/virtio_vsock.h     |    2 +-
 net/vmw_vsock/virtio_transport.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -377,7 +377,7 @@ vhost_vsock_alloc_skb(struct vhost_virtq
 		return NULL;
 	}
 
-	virtio_vsock_skb_rx_put(skb, payload_len);
+	virtio_vsock_skb_put(skb, payload_len);
 
 	nbytes = copy_from_iter(skb->data, payload_len, &iov_iter);
 	if (nbytes != payload_len) {
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -47,7 +47,7 @@ static inline void virtio_vsock_skb_clea
 	VIRTIO_VSOCK_SKB_CB(skb)->tap_delivered = false;
 }
 
-static inline void virtio_vsock_skb_rx_put(struct sk_buff *skb, u32 len)
+static inline void virtio_vsock_skb_put(struct sk_buff *skb, u32 len)
 {
 	skb_put(skb, len);
 }
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -657,7 +657,7 @@ static void virtio_transport_rx_work(str
 			}
 
 			if (payload_len)
-				virtio_vsock_skb_rx_put(skb, payload_len);
+				virtio_vsock_skb_put(skb, payload_len);
 
 			virtio_transport_deliver_tap_pkt(skb);
 			virtio_transport_recv_pkt(&virtio_transport, skb);


