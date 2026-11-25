Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618074;
	b=OhGwE89a6j3tp0O/dry1Gzr4t1ZtcqdT0Fmc+LOFfM8mGebl8qEjq2arMpCjlaSWhXtq
	 V1KGmDgHs9Ag2lxj6GHODkYI6qAkAQp81rRDL2qF9mhBpzoeqD7hwZQNuOydarSo5oWKE
	 DYzc6FgCpzFnTsMvFYjnYJ+E2YPbZS8373UgklZBCnGbYZB7JkRNCMSaDWSnx7Xy7KTtI
	 g43Q0gfGf5Zt/PyYC1U/WMI+LSjP0CkqgKGgO8CF7Edk18PPElZSenaEQ2wF6j1MKbq8Z
	 gkn4tF4sklUpMVL+XUeCBh3TgO4dBY967fza3bhP42AtlhMtuV95HrhPNjm1j31NOyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618074;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=k6qUtk6rKFqgKMXf75fveybB7Osji4Oti0vNfSrEKos=;
	b=zR7ZCtc91Ylxa0Y8UuUGQCGzYkLLVeqTZbdQeHpQCAfeHC1hFRjv+lzNcv71PxQ9qbw9
	 jQpOyMIv80HFFMu+0Tr20UtlKm35K9bMBi6RUozL/4seVQKJrBQTYmhOrf0joVkhI2EWN
	 prjRer8xGq3faqxDAJJ7YKqAqWFIKcgiQa7tQejt/GAAbfTcS0T18d7o+TTqouy63csGo
	 i+1732Kt8lCCfoQ+wteTDb2t/YNKODY9FE32NsSSp6m0CCoxstf3HyjStkkZcptLRiAL3
	 OVGbFHrG9vHzi5kr+Jnh+muzcLN1jWA2maKR7KwIIa0QNhiMfQA0fJCu6dTqiPIUodA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ns+DPJzb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BF87606A323;
	Wed, 25 Nov 2026 14:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ns+DPJzb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 655961F000CF;
	Wed, 25 Nov 2026 14:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618073;
	bh=k6qUtk6rKFqgKMXf75fveybB7Osji4Oti0vNfSrEKos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ns+DPJzb+n9Dr/j95zDXOEktZdQRLRWYFg9iEVr9aysis1nTXSeu5OzbRL48evCpX
	 xPGMVvrd45c8cy3SoL8a5ZQoiyNBA/cZZ4YXyGmXv1yWcD6GIIpnlW3DF1mq9Tzo/m
	 0qFhVMjCdLSEDH/akNvQING9kAWFG/pDKSmZFdkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stjepan Poljak <stjepan.poljak@gmail.com>,
	Sergii Ushakov <sergiiushakov@google.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0162/1005] virtio-blk: clamp max_segments to virtqueue ring size
Date: Wed, 25 Nov 2026 15:25:00 +0100
Message-ID: <20261125143825.536229534@linuxfoundation.org>
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

From: Sergii Ushakov <sergiiushakov@google.com>

[ Upstream commit 434d2bc41bd0c0ac576d4d259bd9f2ab49071174 ]

In virtblk_add_req(), each request consumes 2 extra descriptors (out_hdr
and in_hdr) in addition to the data scatter-gather segments.

When a hypervisor (e.g. QNX Hypervisor) advertises VIRTIO_BLK_F_SEG_MAX
with seg_max = 1024 alongside a 1024-entry split ring (vring.num = 1024)
and VIRTIO_RING_F_INDIRECT_DESC disabled, lim->max_segments is set to
1024. When the block layer submits requests with 1023 or 1024 data
segments, total_sg reaches 1025 or 1026. This exceeds vring.num (1024),
causing virtqueue_add_split() to return -ENOSPC and permanently wedge
the blk-mq queue.

Furthermore, the Virtio specification (2.7.5.3.1) requires that a
descriptor chain never exceed the Queue Size, and virtqueue_add_split()
falls back to direct descriptors if indirect table allocation fails.

Fix this by:
1. Rejecting queues with ring_size < 3 at probe, or
   ring_size < (queue_max_segments + 2) during resume/reset recovery in
   init_vq().
2. Unconditionally clamping sg_elems to (ring_size - 2) across all
   virtqueues in virtblk_read_limits().

Reported-by: Stjepan Poljak <stjepan.poljak@gmail.com>
Fixes: 0864b79a1533 ("virtio: block: dynamic maximum segments")
Signed-off-by: Sergii Ushakov <sergiiushakov@google.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260918135120.1261150-1-sergiiushakov@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/virtio_blk.c | 44 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 43 insertions(+), 1 deletion(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 10ba8b0b863b8..cb694afde3e5d 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -1022,6 +1022,30 @@ static int init_vq(struct virtio_blk *vblk)
 		goto out;
 
 	for (i = 0; i < num_vqs; i++) {
+		unsigned int ring_size = virtqueue_get_vring_size(vqs[i]);
+		/*
+		 * Each request consumes 2 extra descriptors (out_hdr and
+		 * in_hdr) in addition to the data segments.
+		 *
+		 * At initial probe (!vblk->disk), each virtqueue must fit at
+		 * least 1 data segment + 2 header descriptors (3).
+		 * On resume/recovery (vblk->disk), each virtqueue must fit the
+		 * existing queue_max_segments() + 2 header descriptors.
+		 */
+		unsigned int min_ring_size = 3;
+
+		if (vblk->disk)
+			min_ring_size = queue_max_segments(vblk->disk->queue) + 2;
+
+		if (ring_size < min_ring_size) {
+			dev_err(&vdev->dev,
+				"virtqueue %u ring size %u is smaller than minimum %u\n",
+				i, ring_size, min_ring_size);
+			vdev->config->del_vqs(vdev);
+			err = -EINVAL;
+			goto out;
+		}
+
 		spin_lock_init(&vblk->vqs[i].lock);
 		vblk->vqs[i].vq = vqs[i];
 	}
@@ -1254,7 +1278,7 @@ static int virtblk_read_limits(struct virtio_blk *vblk,
 	u16 min_io_size;
 	u8 physical_block_exp, alignment_offset;
 	size_t max_dma_size;
-	int err;
+	int err, i;
 
 	/* We need to know how many segments before we allocate. */
 	err = virtio_cread_feature(vdev, VIRTIO_BLK_F_SEG_MAX,
@@ -1268,6 +1292,23 @@ static int virtblk_read_limits(struct virtio_blk *vblk,
 	/* Prevent integer overflows and honor max vq size */
 	sg_elems = min_t(u32, sg_elems, VIRTIO_BLK_MAX_SG_ELEMS - 2);
 
+	/*
+	 * virtblk_add_req() uses separate outgoing and incoming header
+	 * descriptors (out_hdr and in_hdr), consuming 2 extra descriptors
+	 * per request in addition to the data segments.
+	 *
+	 * Per virtio specification (2.7.5.3.1), a driver MUST NOT create a
+	 * descriptor chain longer than the Queue Size of the device.
+	 *
+	 * Clamp max_segments to (ring_size - 2) across all virtqueues so
+	 * that a request never exceeds the ring size of any queue.
+	 */
+	for (i = 0; i < vblk->num_vqs; i++) {
+		u32 ring_size = virtqueue_get_vring_size(vblk->vqs[i].vq);
+
+		sg_elems = min_t(u32, sg_elems, ring_size - 2);
+	}
+
 	/* We can handle whatever the host told us to handle. */
 	lim->max_segments = sg_elems;
 
@@ -1467,6 +1508,7 @@ static int virtblk_probe(struct virtio_device *vdev)
 	mutex_init(&vblk->vdev_mutex);
 
 	vblk->vdev = vdev;
+	vblk->disk = NULL;
 
 	INIT_WORK(&vblk->config_work, virtblk_config_changed_work);
 
-- 
2.53.0



