Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047658;
	b=glJtyLYohm60jzabE7JKGgNVib3jMeUiAp5OzpAFr4RCgo78wXaiM+aBvLCnNPUkxQjv
	 ZU5cqyLgI/qhNqucnlYHxP5IoNLUqaxk/DIpm2GIkMNmea1NAxXjKx2qv5HZULwM4Vll5
	 YNoBE86Db3EY/myUGdRxux7pL9OrPic94tqrUbYlyI2UDAnRq+8tkp4c6zFuZEeiU6USu
	 8SPj9qt1vUC9ic8OipjXz6p9Vk9ZbBwIXIPsYbFw55hHMpiIIBKeBHiu4HJSMi1lOEWTP
	 58mR8IUmFkVzpKpnjXUp2jNDCRdIHtnj/YTv+wIyBnzHmEHBBT7AnsdiSYllOf/GxGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047658;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ecYkNTbipZZR+xyDB42Yod6Jj4YO4JzRbHMZrG6cMAc=;
	b=ijBuFXBAyhKkuU/UC72znTnplYb1WO/AAmMFaXdX+sCpoFth7fb6aHSviGANMEegLAS5
	 yPhfpAQe/C2DHPBkDekuNKkaipwIuH5MRbHTI81Ce/TQ/XIMWV38uSImICQTcV5JNQ1Y6
	 duOqSK/0Z0dd4KeUXaBRuAa8wr/qbT54b40pt0SmiPZuR8fHSzRpSoCLm04rIlqDG6Vew
	 /48ikN0+3hp2uCzOqzQ9DUXjollzbNGPPRmh6w8ddjvTytEn2i8yaGXSKJzWpVY/NRTLe
	 UD2mPu/AyQtDh4VxogyVh7P/EFFailTn2BpoZGcS384iRjciCwdAeBAOKLjQuvqWzxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yMYKmRna;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF9560A2603;
	Thu, 19 Nov 2026 00:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yMYKmRna
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC5801F000CC;
	Thu, 19 Nov 2026 00:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047658;
	bh=ecYkNTbipZZR+xyDB42Yod6Jj4YO4JzRbHMZrG6cMAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yMYKmRnae8YIoD+LrNuI6odoFjGC2dFGq6IIQbBG1u0IMglmWjeqt2sId2wNUEnqW
	 30FaJCDyIaeue7H3+Uj90kQN0BUjqSUMly7YG3fi2whr2py7TZACQ8CduO32xzhteY
	 g7qscRUo+y7MH/mVsEWMfqzpTNbeD92faCCzxKiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1716/2857] vhost/vsock: size receive SKBs from declared payload
Date: Wed, 18 Nov 2026 15:45:50 +0100
Message-ID: <20261118150303.112818068@linuxfoundation.org>
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

From: Daehyeon Ko <4ncienth@gmail.com>

[ Upstream commit d5e912448cd98b261eba8e35ab838f2dc69a79f5 ]

vhost_vsock_alloc_skb() sizes the skb from iov_length(), the total guest
descriptor length.  virtio_transport_inc_rx_pkt() instead adds hdr->len to
rx_bytes and buf_used, and budgets each queued skb as SKB_TRUESIZE(0).  The
guest controls the descriptor length and hdr->len independently.

A guest can therefore provide a 64 KiB descriptor while declaring a zero
payload.  The descriptor-sized skb remains queued, rx_bytes and buf_used
remain unchanged, and only the fixed queue-entry budget limits retention.
This is not a lifetime leak: the skb is freed when dequeued or at socket
teardown.  Repeating this across connections can nevertheless exhaust host
memory.  On Linux v7.2, 455 such descriptors retained 30,255,680 bytes for
a 262,144-byte receive buffer; a full-payload control retained 265,984
bytes.

Vhost previously read hdr->len and allocated pkt->buf from that value.  The
conversion from virtio_vsock_pkt to sk_buff instead allocated receive skbs
from the descriptor length, introducing the allocation-accounting mismatch.

Copy the header into a stack object and validate hdr->len before allocating
the skb.  Size the allocation as sizeof(hdr) + payload_len so descriptor
capacity no longer determines queued memory.  Check payload_len against
len - sizeof(hdr) to avoid addition overflow on 32-bit hosts.

Fixes: 71dc9ec9ac7d ("virtio/vsock: replace virtio_vsock_pkt with sk_buff")
Cc: stable@vger.kernel.org
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Link: https://patch.msgid.link/20261004235101.1464007-1-4ncienth@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vsock.c | 34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 1fc03038e5543..43533ae6ce211 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -327,7 +327,7 @@ static struct sk_buff *
 vhost_vsock_alloc_skb(struct vhost_virtqueue *vq,
 		      unsigned int out, unsigned int in)
 {
-	struct virtio_vsock_hdr *hdr;
+	struct virtio_vsock_hdr hdr;
 	struct iov_iter iov_iter;
 	struct sk_buff *skb;
 	size_t payload_len;
@@ -344,34 +344,32 @@ vhost_vsock_alloc_skb(struct vhost_virtqueue *vq,
 	if (len > VIRTIO_VSOCK_MAX_PKT_BUF_SIZE + VIRTIO_VSOCK_SKB_HEADROOM)
 		return NULL;
 
-	/* len contains both payload and hdr */
-	skb = virtio_vsock_alloc_skb(len, GFP_KERNEL);
-	if (!skb)
-		return NULL;
-
 	iov_iter_init(&iov_iter, ITER_SOURCE, vq->iov, out, len);
 
-	hdr = virtio_vsock_hdr(skb);
-	nbytes = copy_from_iter(hdr, sizeof(*hdr), &iov_iter);
-	if (nbytes != sizeof(*hdr)) {
+	nbytes = copy_from_iter(&hdr, sizeof(hdr), &iov_iter);
+	if (nbytes != sizeof(hdr)) {
 		vq_err(vq, "Expected %zu bytes for pkt->hdr, got %zu bytes\n",
-		       sizeof(*hdr), nbytes);
-		kfree_skb(skb);
+		       sizeof(hdr), nbytes);
 		return NULL;
 	}
 
-	payload_len = le32_to_cpu(hdr->len);
+	payload_len = le32_to_cpu(hdr.len);
+
+	/* The pkt is too big or the length in the header is invalid */
+	if (payload_len > len - sizeof(hdr))
+		return NULL;
+
+	/* Allocate only for the payload declared in the header. */
+	skb = virtio_vsock_alloc_skb(payload_len + sizeof(hdr), GFP_KERNEL);
+	if (!skb)
+		return NULL;
+
+	memcpy(virtio_vsock_hdr(skb), &hdr, sizeof(hdr));
 
 	/* No payload */
 	if (!payload_len)
 		return skb;
 
-	/* The pkt is too big or the length in the header is invalid */
-	if (payload_len + sizeof(*hdr) > len) {
-		kfree_skb(skb);
-		return NULL;
-	}
-
 	virtio_vsock_skb_put(skb, payload_len);
 
 	nbytes = copy_from_iter(skb->data, payload_len, &iov_iter);
-- 
2.53.0



