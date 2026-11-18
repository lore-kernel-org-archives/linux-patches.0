Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056280;
	b=A/5wfYPBf1oLMHVW4D5UpPgdUaVbVgyn5BsZyhvCaP7q2kqxKyDBX4xCvOxH55pfYz9z
	 QzMWRcyGWpJmYIOYvN6VP6jfFLjK/hfpy2esE7MEnIaw5+VsDb/NxAHxaHkU6c9XF9SiC
	 VFgr+z9xN2N6bhbs0TgmPTUEVEoJDxvH5ia3iHkdEXujxKvKG+g8SNMiQH1cvXhlHyf0C
	 6rj8ap4rPpMrky755mdIc4th3js2JvRJC9atSBXGe/7OUDayprAQjSCebE67369eNFJKR
	 aeZvJbOo77Yg/yvpXprKspH2PflXtX4RCTd4QNh2PFjyAmyc6vwtqUM0m6C9tpUQSHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056280;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p5afLHM2mMrGwNdDRaoLeoeBE0qRyru+DhQuSl1mgSo=;
	b=19ZzFtNn0Pv9JhvGX+0N6ToPMRNxamKU0GcudSMohwwqzLetOvu58SzfdC6GOwrh5r7M
	 ck5XK6KBUwqmVNOslaR52oqPKLDmTzAwfN7RZQLh8hsXN4Uim7F5jwUy81B+bAw6Qbnau
	 lO/T474PGtZ2t3MJ614rJdAYQTzkBQzmiVMFlfXedrBZ4HWXP0fFaWgdZapSTQDEr7LdT
	 J/4DIRYVd6RFyUT16pCc8ImUzMF/IJqzMGsRMEMk/GplWmgvndWEZ04yN4wS29FPCWiXa
	 BV0CijIRH5X4qTBVfRUZBd9SBOgv/HwmUwL7OQcn5MBjBTxC81S5j5sPrOQuRs9RBvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hyKyKT8F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D509606A31C;
	Thu, 19 Nov 2026 02:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hyKyKT8F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E8551F000C4;
	Thu, 19 Nov 2026 02:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056280;
	bh=p5afLHM2mMrGwNdDRaoLeoeBE0qRyru+DhQuSl1mgSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hyKyKT8FFjP0ZbS/KGOed+yvpZX3sF+BR2pl3NAcwJLWaI7yFf2EMuK8JTE1Pckg7
	 QU+/lOw4a6Ck4/HG4XjfvlHne06lfH4ay0Ta6diaBp87NdPGlpy3k2+YcXT2HNq8PU
	 6wpJDHW42C5gkqYfAoGZLZJDTjAY6BsKYjctyIcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrick Oppenlander <patrick.oppenlander@gmail.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1930/2214] rpmsg: virtio: EPOLLOUT support
Date: Wed, 18 Nov 2026 16:00:06 +0100
Message-ID: <20261118150128.220469709@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrick Oppenlander <patrick.oppenlander@gmail.com>

[ Upstream commit c38d8b66c82c585199e2ad67282295f21cfa489f ]

Previously, polling an rpmsg endpoint (e.g. /dev/ttyRPMSGx) would
generate EPOLLIN events but no EPOLLOUT events.

Unfortunately, poll support means that we can no longer disable
tx-complete interrupts as there is no way to know whether a poller is
waiting in sendq, so we always need notifications.

Signed-off-by: Patrick Oppenlander <patrick.oppenlander@gmail.com>
Link: https://lore.kernel.org/r/20251022032817.320378-1-patrick.oppenlander@gmail.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Stable-dep-of: 7dd4cffdf4c2 ("rpmsg: virtio: fix error handling in TX buffer wait")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rpmsg/virtio_rpmsg_bus.c | 101 ++++++++++---------------------
 1 file changed, 32 insertions(+), 69 deletions(-)

diff --git a/drivers/rpmsg/virtio_rpmsg_bus.c b/drivers/rpmsg/virtio_rpmsg_bus.c
index 50c0747c05aaf..e9bdaf8d6ad8e 100644
--- a/drivers/rpmsg/virtio_rpmsg_bus.c
+++ b/drivers/rpmsg/virtio_rpmsg_bus.c
@@ -42,13 +42,12 @@
  * @buf_size:   size of one rx or tx buffer
  * @last_sbuf:	index of last tx buffer used
  * @bufs_dma:	dma base addr of the buffers
- * @tx_lock:	protects svq, sbufs and sleepers, to allow concurrent senders.
+ * @tx_lock:	protects svq and sbufs, to allow concurrent senders.
  *		sending a message might require waking up a dozing remote
  *		processor, which involves sleeping, hence the mutex.
  * @endpoints:	idr of local endpoints, allows fast retrieval
  * @endpoints_lock: lock of the endpoints set
  * @sendq:	wait queue of sending contexts waiting for a tx buffers
- * @sleepers:	number of senders that are waiting for a tx buffer
  *
  * This structure stores the rpmsg state of a given virtio remote processor
  * device (there might be several virtio proc devices for each physical
@@ -66,7 +65,6 @@ struct virtproc_info {
 	struct idr endpoints;
 	struct mutex endpoints_lock;
 	wait_queue_head_t sendq;
-	atomic_t sleepers;
 };
 
 /* The feature bitmap for virtio rpmsg */
@@ -145,6 +143,8 @@ static int virtio_rpmsg_sendto(struct rpmsg_endpoint *ept, void *data, int len,
 static int virtio_rpmsg_trysend(struct rpmsg_endpoint *ept, void *data, int len);
 static int virtio_rpmsg_trysendto(struct rpmsg_endpoint *ept, void *data,
 				  int len, u32 dst);
+static __poll_t virtio_rpmsg_poll(struct rpmsg_endpoint *ept, struct file *filp,
+				  poll_table *wait);
 static ssize_t virtio_rpmsg_get_mtu(struct rpmsg_endpoint *ept);
 static struct rpmsg_device *__rpmsg_create_channel(struct virtproc_info *vrp,
 						   struct rpmsg_channel_info *chinfo);
@@ -155,6 +155,7 @@ static const struct rpmsg_endpoint_ops virtio_endpoint_ops = {
 	.sendto = virtio_rpmsg_sendto,
 	.trysend = virtio_rpmsg_trysend,
 	.trysendto = virtio_rpmsg_trysendto,
+	.poll = virtio_rpmsg_poll,
 	.get_mtu = virtio_rpmsg_get_mtu,
 };
 
@@ -437,7 +438,6 @@ static void *get_a_tx_buf(struct virtproc_info *vrp)
 	unsigned int len;
 	void *ret;
 
-	/* support multiple concurrent senders */
 	mutex_lock(&vrp->tx_lock);
 
 	/*
@@ -455,62 +455,6 @@ static void *get_a_tx_buf(struct virtproc_info *vrp)
 	return ret;
 }
 
-/**
- * rpmsg_upref_sleepers() - enable "tx-complete" interrupts, if needed
- * @vrp: virtual remote processor state
- *
- * This function is called before a sender is blocked, waiting for
- * a tx buffer to become available.
- *
- * If we already have blocking senders, this function merely increases
- * the "sleepers" reference count, and exits.
- *
- * Otherwise, if this is the first sender to block, we also enable
- * virtio's tx callbacks, so we'd be immediately notified when a tx
- * buffer is consumed (we rely on virtio's tx callback in order
- * to wake up sleeping senders as soon as a tx buffer is used by the
- * remote processor).
- */
-static void rpmsg_upref_sleepers(struct virtproc_info *vrp)
-{
-	/* support multiple concurrent senders */
-	mutex_lock(&vrp->tx_lock);
-
-	/* are we the first sleeping context waiting for tx buffers ? */
-	if (atomic_inc_return(&vrp->sleepers) == 1)
-		/* enable "tx-complete" interrupts before dozing off */
-		virtqueue_enable_cb(vrp->svq);
-
-	mutex_unlock(&vrp->tx_lock);
-}
-
-/**
- * rpmsg_downref_sleepers() - disable "tx-complete" interrupts, if needed
- * @vrp: virtual remote processor state
- *
- * This function is called after a sender, that waited for a tx buffer
- * to become available, is unblocked.
- *
- * If we still have blocking senders, this function merely decreases
- * the "sleepers" reference count, and exits.
- *
- * Otherwise, if there are no more blocking senders, we also disable
- * virtio's tx callbacks, to avoid the overhead incurred with handling
- * those (now redundant) interrupts.
- */
-static void rpmsg_downref_sleepers(struct virtproc_info *vrp)
-{
-	/* support multiple concurrent senders */
-	mutex_lock(&vrp->tx_lock);
-
-	/* are we the last sleeping context waiting for tx buffers ? */
-	if (atomic_dec_and_test(&vrp->sleepers))
-		/* disable "tx-complete" interrupts */
-		virtqueue_disable_cb(vrp->svq);
-
-	mutex_unlock(&vrp->tx_lock);
-}
-
 /**
  * rpmsg_send_offchannel_raw() - send a message across to the remote processor
  * @rpdev: the rpmsg channel
@@ -583,9 +527,6 @@ static int rpmsg_send_offchannel_raw(struct rpmsg_device *rpdev,
 
 	/* no free buffer ? wait for one (but bail after 15 seconds) */
 	while (!msg) {
-		/* enable "tx-complete" interrupts, if not already enabled */
-		rpmsg_upref_sleepers(vrp);
-
 		/*
 		 * sleep until a free buffer is available or 15 secs elapse.
 		 * the timeout period is not configurable because there's
@@ -596,9 +537,6 @@ static int rpmsg_send_offchannel_raw(struct rpmsg_device *rpdev,
 					(msg = get_a_tx_buf(vrp)),
 					msecs_to_jiffies(15000));
 
-		/* disable "tx-complete" interrupts if we're the last sleeper */
-		rpmsg_downref_sleepers(vrp);
-
 		/* timeout ? */
 		if (!err) {
 			dev_err(dev, "timeout waiting for a tx buffer\n");
@@ -677,6 +615,34 @@ static int virtio_rpmsg_trysendto(struct rpmsg_endpoint *ept, void *data,
 	return rpmsg_send_offchannel_raw(rpdev, src, dst, data, len, false);
 }
 
+static __poll_t virtio_rpmsg_poll(struct rpmsg_endpoint *ept, struct file *filp,
+				  poll_table *wait)
+{
+	struct rpmsg_device *rpdev = ept->rpdev;
+	struct virtio_rpmsg_channel *vch = to_virtio_rpmsg_channel(rpdev);
+	struct virtproc_info *vrp = vch->vrp;
+	__poll_t mask = 0;
+
+	poll_wait(filp, &vrp->sendq, wait);
+
+	/* support multiple concurrent senders */
+	mutex_lock(&vrp->tx_lock);
+
+	/*
+	 * check for a free buffer, either:
+	 * - we haven't used all of the available transmit buffers (half of the
+	 *   allocated buffers are used for transmit, hence num_bufs / 2), or,
+	 * - we ask the virtqueue if there's a buffer available
+	 */
+	if (vrp->last_sbuf < vrp->num_bufs / 2 ||
+	    !virtqueue_enable_cb(vrp->svq))
+		mask |= EPOLLOUT;
+
+	mutex_unlock(&vrp->tx_lock);
+
+	return mask;
+}
+
 static ssize_t virtio_rpmsg_get_mtu(struct rpmsg_endpoint *ept)
 {
 	struct rpmsg_device *rpdev = ept->rpdev;
@@ -921,9 +887,6 @@ static int rpmsg_probe(struct virtio_device *vdev)
 		WARN_ON(err); /* sanity check; this can't really happen */
 	}
 
-	/* suppress "tx-complete" interrupts */
-	virtqueue_disable_cb(vrp->svq);
-
 	vdev->priv = vrp;
 
 	rpdev_ctrl = rpmsg_virtio_add_ctrl_dev(vdev);
-- 
2.53.0



