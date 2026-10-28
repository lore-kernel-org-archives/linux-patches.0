Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214244;
	b=sRTOz6Z+cnrD/d6r6SwQBy/pkVztmVxAH0iV2X3oOP9ZLBLKsc4oo+mwWYQD3dNViSQE
	 qXndtYn1ukZ6cNHt4kLgvjePFj9GOlHjbyisSn5tZ81pdr4GybuTYFysUjwL2iuyIf3dB
	 Ktm3gQXhM1W3Fz0VBY3Re/P4I0dNv4uTNJEX0L751svz2h895zN9waVQwSNgKLJxuJeoy
	 7t7SyCLygHD008y80SigKYMmJnwTHdb3OA8wexnBDnq/3GJiQ4jgoq+NYoyucXuuGEmzc
	 79GlpjUEKRK0RirqKFSzzew9KtMGK9b2Am27nM7uQdNOLPifmv1A6Nbjxq+Fgt3tP7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214244;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Qf3xBflMxV0t1bQfMfsjSpLiQuZymbet7qNNh4j20uE=;
	b=Mx4c3TcEho/MezbRRO3Zw+Zhmo7lZxiDYd28RvUKiCfDorBHHQV0xvuvth7qx3Un1WcJ
	 vd04RUjjyKKRcVk8nA9yEo7JfRU0bT2MJeDT8LG650274L1osIKtVB6fsRv6vMGvnObdo
	 Yri+9ba2Y1WECz+J9Zo4TtDsSswbzip2qaNO/Fq3qSVIjTVd8bYsziqM2YVnsKhXI6ylt
	 y6Tdi5gDSVAPE77TXkC+7rFQJ4lk2rh+WpOrfFnGCX4jLfagMqDYd33S+GrPuD8dgwxqJ
	 +F/wxFkiUk/6VTNDdZTJC0KLGsamxWfeiIdi+62BKexvISemcNcGuf3jqp2RZFqLorw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yn2Juc39;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E984860A380E;
	Wed, 28 Oct 2026 19:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yn2Juc39
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E8591F031E2;
	Wed, 28 Oct 2026 19:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214243;
	bh=Qf3xBflMxV0t1bQfMfsjSpLiQuZymbet7qNNh4j20uE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yn2Juc39n+JMVQYR9+zM/1lrMg8gub5ZiWDXuIdmZ47ZCB2IKOquzYZLJIXs5qAJG
	 /wdHZnSjmc9aRl9MFY3MGJUODz/i3AIjR0R4cK5uFWwa4wDfFYwr8JqApRX+hDTsxX
	 m6H+r2T3+UgOyNdB6TRNDhJWqC4EJTHuLOFC0ukE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Auger <eauger@redhat.com>,
	Hongyu Ning <hongyu.ning@linux.intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0790/1887] virtio: break and reset virtio devices on device_shutdown()
Date: Wed, 28 Oct 2026 17:48:06 +0100
Message-ID: <20261028170517.411226577@linuxfoundation.org>
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

From: Michael S. Tsirkin <mst@redhat.com>

[ Upstream commit 8bd2fa086a04886798b505f28db4002525895203 ]

Hongyu reported a hang on kexec in a VM. QEMU reported invalid memory
accesses during the hang.

	Invalid read at addr 0x102877002, size 2, region '(null)', reason: rejected
	Invalid write at addr 0x102877A44, size 2, region '(null)', reason: rejected
	...

It was traced down to virtio-console. Kexec works fine if virtio-console
is not in use.

The issue is that virtio-console continues to write to the MMIO even after
underlying virtio-pci device is reset.

Additionally, Eric noticed that IOMMUs are reset before devices, if
devices are not reset on shutdown they continue to poke at guest memory
and get errors from the IOMMU. Some devices get wedged then.

The problem can be solved by breaking all virtio devices on virtio
bus shutdown, then resetting them.

Reported-by: Eric Auger <eauger@redhat.com>
Reported-by: Hongyu Ning <hongyu.ning@linux.intel.com>
Message-ID: <c1dbc7dbad9b445245d3348f19e6742b0be07347.1740094946.git.mst@redhat.com>
Tested-by: Eric Auger <eric.auger@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
index 1ef094427f299..0d3481250fb98 100644
--- a/drivers/virtio/virtio.c
+++ b/drivers/virtio/virtio.c
@@ -340,6 +340,34 @@ static void virtio_dev_remove(struct device *_d)
 	of_node_put(dev->dev.of_node);
 }
 
+static void virtio_dev_shutdown(struct device *_d)
+{
+	struct virtio_device *dev = dev_to_virtio(_d);
+	struct virtio_driver *drv = drv_to_virtio(dev->dev.driver);
+
+	/*
+	 * Stop accesses to or from the device.
+	 * We only need to do it if there's a driver - no accesses otherwise.
+	 */
+	if (!drv)
+		return;
+
+	/*
+	 * Some devices get wedged if you kick them after they are
+	 * reset. Mark all vqs as broken to make sure we don't.
+	 */
+	virtio_break_device(dev);
+	/*
+	 * Guarantee that any callback will see vq->broken as true.
+	 */
+	virtio_synchronize_cbs(dev);
+	/*
+	 * As IOMMUs are reset on shutdown, this will block device access to memory.
+	 * Some devices get wedged if this happens, so reset to make sure it does not.
+	 */
+	dev->config->reset(dev);
+}
+
 static struct bus_type virtio_bus = {
 	.name  = "virtio",
 	.match = virtio_dev_match,
@@ -347,6 +375,7 @@ static struct bus_type virtio_bus = {
 	.uevent = virtio_uevent,
 	.probe = virtio_dev_probe,
 	.remove = virtio_dev_remove,
+	.shutdown = virtio_dev_shutdown,
 };
 
 int register_virtio_driver(struct virtio_driver *driver)
-- 
2.53.0



