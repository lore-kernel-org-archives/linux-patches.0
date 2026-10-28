Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212456;
	b=bQyuVSBuYWJ/9iPPIZ5jnBbhKFzarbXcGcPy9kWeHLB8CiY1sDLEA2RLMpjpSKf0CB/0
	 QQY8RNqsdI1PUYLOYbR9dJicvIqFKIOIpTXInkxvW3H14lfNBdxCTPa6+SWBrQgUSRY7d
	 RaIMuXM2sHY8HvewJzw4TUY23qm811WU2oCv2nA5fDE9KwSSMr5Q6qYNXDh3u5sdBr/6g
	 iC4RGl9G4qir29MrwjJx0ju+nObtIU9Q70SAqqLrkOuNcWwbuEAoVGvSNSTNIB0Tkxa01
	 XPuNFa4mbgWlg3raaBtZuFTwCu1NfOAH/oSpHsbKSiPcMv2+1RPlelwJluiGHidM4EQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212456;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=psw6ugwCEiZCGBK3ENvPOuMHKlKYuxm9CE+D8oamBQY=;
	b=kuAppSOmxTPhlrjAxD+LOfLLnV/XH8R+ETrO+qZaTh9LfoWnCnWHqSoQoJX+9/rqbCuh
	 BC/9jDCb2/uL3M8xyjDICHHUlqd2h85sZqBOWNAfQXRZDJLlUBg1H41KjKa/67VPz8Vc0
	 LTgeSm9ecdUA9RUVaq2JqXDBcCmWC2H7fwojyQQGErwEipBGvvFMhJF7e+06T8bTAb+Aa
	 Kl6fr1FQoLx2O/FfwrMRQ4OcrJ8yZ863ZqEZePtjJESUIjg1MlxsTvPjU7ybRjDGMZ2AX
	 9cWctXWHxwv1dRN4h+HCHA+dbnFhlsO3DOhdgbMedYt3zDKhMkpTgHHDbn9UyprS5SA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pw8NzTqi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04034606A324;
	Wed, 28 Oct 2026 18:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pw8NzTqi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D77A1F01825;
	Wed, 28 Oct 2026 18:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212455;
	bh=psw6ugwCEiZCGBK3ENvPOuMHKlKYuxm9CE+D8oamBQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pw8NzTqifso9ugcQhomQ4NZIuz2GpQIqx+vzQPVrRzd1bO4xtc6Jk0H/k8MUZvMz8
	 mtzvAfEJqLFtA9fLfF1StxHfeDHu28mIjtEOz3W/07JieI0VqS7TQC8PVGg/O5+w+0
	 SV7h2Ga/Tw6rpJ4NClySMgRTBQh877kCLgMhECGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viresh Kumar <viresh.kumar@linaro.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0117/1887] virtio-mmio: Remove virtqueue list from mmio device
Date: Wed, 28 Oct 2026 17:36:53 +0100
Message-ID: <20261028170501.900954413@linuxfoundation.org>
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

From: Viresh Kumar <viresh.kumar@linaro.org>

[ Upstream commit 564a69ad90d15c782176e1a8c9e1c95661e1aed0 ]

The MMIO transport implementation creates a list of virtqueues for a
virtio device, while the same is already available in the struct
virtio_device.

Don't create a duplicate list, and use the other one instead.

While at it, fix the virtio_device_for_each_vq() macro to accept an
argument like "&vm_dev->vdev" (which currently fails to build).

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Message-Id: <3e56c6f74002987e22f364d883cbad177cd9ad9c.1747827066.git.viresh.kumar@linaro.org>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>

[Backport to 6.1: remove the obsolete queue-info declaration without
introducing the notify function pointer from the newer notification-data
support. Keep vm_notify and the existing find_vqs interface. This leaves
the device layout ready for d14d693adb055e98ca705822ba6daebc18602d9a.]

Stable-dep-of: d14d693adb05 ("virtio_mmio: disable IRQ wake before free_irq")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_mmio.c | 52 +++---------------------------------
 include/linux/virtio.h       |  2 +-
 2 files changed, 4 insertions(+), 50 deletions(-)

diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
index 7651940aafd24..7909d4aec8a6e 100644
--- a/drivers/virtio/virtio_mmio.c
+++ b/drivers/virtio/virtio_mmio.c
@@ -64,7 +64,6 @@
 #include <linux/platform_device.h>
 #include <linux/pm.h>
 #include <linux/slab.h>
-#include <linux/spinlock.h>
 #include <linux/virtio.h>
 #include <linux/virtio_config.h>
 #include <uapi/linux/virtio_mmio.h>
@@ -87,22 +86,8 @@ struct virtio_mmio_device {
 
 	void __iomem *base;
 	unsigned long version;
-
-	/* a list of queues so we can dispatch IRQs */
-	spinlock_t lock;
-	struct list_head virtqueues;
-};
-
-struct virtio_mmio_vq_info {
-	/* the actual virtqueue */
-	struct virtqueue *vq;
-
-	/* the list node for the virtqueues list */
-	struct list_head node;
 };
 
-
-
 /* Configuration interface */
 
 static u64 vm_get_features(struct virtio_device *vdev)
@@ -289,9 +274,8 @@ static bool vm_notify(struct virtqueue *vq)
 static irqreturn_t vm_interrupt(int irq, void *opaque)
 {
 	struct virtio_mmio_device *vm_dev = opaque;
-	struct virtio_mmio_vq_info *info;
+	struct virtqueue *vq;
 	unsigned long status;
-	unsigned long flags;
 	irqreturn_t ret = IRQ_NONE;
 
 	/* Read and acknowledge interrupts */
@@ -304,10 +288,8 @@ static irqreturn_t vm_interrupt(int irq, void *opaque)
 	}
 
 	if (likely(status & VIRTIO_MMIO_INT_VRING)) {
-		spin_lock_irqsave(&vm_dev->lock, flags);
-		list_for_each_entry(info, &vm_dev->virtqueues, node)
-			ret |= vring_interrupt(irq, info->vq);
-		spin_unlock_irqrestore(&vm_dev->lock, flags);
+		virtio_device_for_each_vq(&vm_dev->vdev, vq)
+			ret |= vring_interrupt(irq, vq);
 	}
 
 	return ret;
@@ -318,14 +300,8 @@ static irqreturn_t vm_interrupt(int irq, void *opaque)
 static void vm_del_vq(struct virtqueue *vq)
 {
 	struct virtio_mmio_device *vm_dev = to_virtio_mmio_device(vq->vdev);
-	struct virtio_mmio_vq_info *info = vq->priv;
-	unsigned long flags;
 	unsigned int index = vq->index;
 
-	spin_lock_irqsave(&vm_dev->lock, flags);
-	list_del(&info->node);
-	spin_unlock_irqrestore(&vm_dev->lock, flags);
-
 	/* Select and deactivate the queue */
 	writel(index, vm_dev->base + VIRTIO_MMIO_QUEUE_SEL);
 	if (vm_dev->version == 1) {
@@ -336,8 +312,6 @@ static void vm_del_vq(struct virtqueue *vq)
 	}
 
 	vring_del_virtqueue(vq);
-
-	kfree(info);
 }
 
 static void vm_del_vqs(struct virtio_device *vdev)
@@ -363,9 +337,7 @@ static struct virtqueue *vm_setup_vq(struct virtio_device *vdev, unsigned int in
 				  const char *name, bool ctx)
 {
 	struct virtio_mmio_device *vm_dev = to_virtio_mmio_device(vdev);
-	struct virtio_mmio_vq_info *info;
 	struct virtqueue *vq;
-	unsigned long flags;
 	unsigned int num;
 	int err;
 
@@ -382,13 +354,6 @@ static struct virtqueue *vm_setup_vq(struct virtio_device *vdev, unsigned int in
 		goto error_available;
 	}
 
-	/* Allocate and fill out our active queue description */
-	info = kmalloc(sizeof(*info), GFP_KERNEL);
-	if (!info) {
-		err = -ENOMEM;
-		goto error_kmalloc;
-	}
-
 	num = readl(vm_dev->base + VIRTIO_MMIO_QUEUE_NUM_MAX);
 	if (num == 0) {
 		err = -ENOENT;
@@ -446,13 +411,6 @@ static struct virtqueue *vm_setup_vq(struct virtio_device *vdev, unsigned int in
 		writel(1, vm_dev->base + VIRTIO_MMIO_QUEUE_READY);
 	}
 
-	vq->priv = info;
-	info->vq = vq;
-
-	spin_lock_irqsave(&vm_dev->lock, flags);
-	list_add(&info->node, &vm_dev->virtqueues);
-	spin_unlock_irqrestore(&vm_dev->lock, flags);
-
 	return vq;
 
 error_bad_pfn:
@@ -464,8 +422,6 @@ static struct virtqueue *vm_setup_vq(struct virtio_device *vdev, unsigned int in
 		writel(0, vm_dev->base + VIRTIO_MMIO_QUEUE_READY);
 		WARN_ON(readl(vm_dev->base + VIRTIO_MMIO_QUEUE_READY));
 	}
-	kfree(info);
-error_kmalloc:
 error_available:
 	return ERR_PTR(err);
 }
@@ -610,8 +566,6 @@ static int virtio_mmio_probe(struct platform_device *pdev)
 	vm_dev->vdev.dev.release = virtio_mmio_release_dev;
 	vm_dev->vdev.config = &virtio_mmio_config_ops;
 	vm_dev->pdev = pdev;
-	INIT_LIST_HEAD(&vm_dev->virtqueues);
-	spin_lock_init(&vm_dev->lock);
 
 	vm_dev->base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(vm_dev->base)) {
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index 82a29db54e7d1..8982611799e0b 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -156,7 +156,7 @@ void virtio_reset_device(struct virtio_device *dev);
 size_t virtio_max_dma_size(struct virtio_device *vdev);
 
 #define virtio_device_for_each_vq(vdev, vq) \
-	list_for_each_entry(vq, &vdev->vqs, list)
+	list_for_each_entry(vq, &(vdev)->vqs, list)
 
 /**
  * struct virtio_driver - operations for a virtio I/O driver
-- 
2.53.0



