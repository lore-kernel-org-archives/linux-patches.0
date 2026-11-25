Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619569;
	b=B0EEMZ4GCehqzt+uNaGyXD8cYg9pwHTFpBLIhcc432UT38fhIve3FWWLWG2NJwv8fmXg
	 UXA5KyImtSPDyxUWa/IlRQXcl+rOmwP/gr3UZlK4fUjmjeFjhOxkXPaSTIaMwwwzyepyY
	 Ync4X8RTRgxOgI1d9WpN354rncPTisHm0SEm63hUuqlsbajTygDdNRoOd2hLVrjrhl0SG
	 tDLIIjtsgWHANzm5/1Uuugr6+tZSUXzXe6cvhzQMXd9HRplqtCkK+uiphenik1UlSjxy8
	 P3bm7ouMJ3GNVZ+GyBtl4wQeVyjifj3ywPGU+tU0PnX4wXOIKHXxLn3trv9hSA6yTCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619569;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lCp9KAD1ZomMn1f8sijfW8bM9k70dI/qZwM0CfQguQ4=;
	b=XCUciuDJJA+CO2czOFbsPfNJELZQui09SFL87R4eJEHhqKCaL4I/yu62LH4SZ7mLPP9l
	 eZh00VX9fSEh9XIwugc9sx9aH4uc4ubzqlfa5tBmVF03KQwBVkj84kpqXdwmCwrrGB1sh
	 od6PN1JELcNuHPiTEL8Np9Kg+f6ueeie2Fm0Xvmpa1n54yUWGHYf8RRDWBZ5ucDW47JsA
	 ZGmI5nh3t/H9UfXh6m4ADWB3Uwz5sptYY4ZHsUvJ0mLaegvnN6n3k8GhAN5LMBQe2VCX+
	 7bn9TXYTHPF0v3+l8Jog3E8ld7x8KKo9qICkvMwSmLwHhj8fq7jhtwFocfiUIEIBBrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LxAxptx0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60E8606A31E;
	Wed, 25 Nov 2026 15:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LxAxptx0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6CAA1F000C0;
	Wed, 25 Nov 2026 15:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619569;
	bh=lCp9KAD1ZomMn1f8sijfW8bM9k70dI/qZwM0CfQguQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LxAxptx0pquQiOCfHt09yZjOo13rObjkFOWl0f4KZuTDu+g72f4TPD05q5nVI9Lle
	 SrN8fjy42m0OifBVrxmjgFCdZUQj5lWdF0GziWe4vUKzJXC0/SNC/bmsitPKo6oI/Y
	 oWDfKTSjSbLg2OpGNzy2QufDognYKiLn45QAf8CA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerome Mohm <jrmmhm.kernel@eldare.de>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.3 0637/1005] vsock/virtio: clear vqs[] to avoid a UAF on a failed PM restore
Date: Wed, 25 Nov 2026 15:32:55 +0100
Message-ID: <20261125143836.675513786@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Mohm <jrmmhm.kernel@eldare.de>

commit 2a24ba1694f14299fbde3fa107e5d56629f2f8b6 upstream.

virtio_vsock_vqs_del() frees the virtqueues but leaves vsock->vqs[]
pointing at them. If virtio_vsock_restore() then fails, the driver
stays bound with a dangling vqs[], and the next freeze or unbind
passes a freed virtqueue to virtqueue_detach_unused_buf():

  BUG: KASAN: slab-use-after-free in virtqueue_detach_unused_buf
   virtio_vsock_vqs_del (net/vmw_vsock/virtio_transport.c:785)
   virtio_vsock_remove
  Freed by task ...:
   vp_del_vqs
   virtio_vsock_freeze

Clear vqs[] after del_vqs() and when virtio_find_vqs() fails. Return
early from virtio_vsock_vqs_del() when vqs[] is empty: the detach
loops would pass NULL to virtqueue_detach_unused_buf(), and a second
del_vqs() would free virtio-mmio's IRQ again, which only WARNs in
free_irq() ("Trying to free already-free IRQ").

Found with the help of Anthropic's Claude and reproduced on virtio-pci
and virtio-mmio by failing the restore with failslab, without other
kernel changes; the virtio-mmio WARN was found by the netdev Sashiko
review and reproduced with v1 of this patch. With this patch neither
report appears on virtio-pci or virtio-mmio guests, and the vsock
vmtest.sh single-VM tests pass. A find_vqs() failure after some
virtqueues were set up was not exercised.

Fixes: bd50c5dc182b ("vsock/virtio: add support for device suspend/resume")
Cc: stable@vger.kernel.org
Signed-off-by: Jerome Mohm <jrmmhm.kernel@eldare.de>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://patch.msgid.link/20261109-vsock-restore-uaf-send-v4-1-1df8dfb5d5de@eldare.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/virtio_transport.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -714,8 +714,10 @@ static int virtio_vsock_vqs_init(struct
 	atomic_set(&vsock->queued_replies, 0);
 
 	ret = virtio_find_vqs(vdev, VSOCK_VQ_MAX, vsock->vqs, vqs_info, NULL);
-	if (ret < 0)
+	if (ret < 0) {
+		memset(vsock->vqs, 0, sizeof(vsock->vqs));
 		return ret;
+	}
 
 	virtio_vsock_update_guest_cid(vsock);
 
@@ -776,11 +778,19 @@ static void virtio_vsock_vqs_del(struct
 	vsock->event_run = false;
 	mutex_unlock(&vsock->event_lock);
 
+	virtio_vsock_skb_queue_purge(&vsock->send_pkt_queue);
+
 	/* Flush all device writes and interrupts, device will not use any
 	 * more buffers.
 	 */
 	virtio_reset_device(vdev);
 
+	/* After a failed restore no virtqueues are live, and a second
+	 * del_vqs() would free virtio-mmio's IRQ again (a WARN in free_irq()).
+	 */
+	if (!vsock->vqs[VSOCK_VQ_RX])
+		return;
+
 	mutex_lock(&vsock->rx_lock);
 	while ((skb = virtqueue_detach_unused_buf(vsock->vqs[VSOCK_VQ_RX])))
 		kfree_skb(skb);
@@ -791,10 +801,10 @@ static void virtio_vsock_vqs_del(struct
 		kfree_skb(skb);
 	mutex_unlock(&vsock->tx_lock);
 
-	virtio_vsock_skb_queue_purge(&vsock->send_pkt_queue);
-
 	/* Delete virtqueues and flush outstanding callbacks if any */
 	vdev->config->del_vqs(vdev);
+
+	memset(vsock->vqs, 0, sizeof(vsock->vqs));
 }
 
 static int virtio_vsock_probe(struct virtio_device *vdev)


