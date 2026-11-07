Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061045;
	b=oFeLw4DCMegXIervrc5ks9DfFP/iWS4kDTxdXvBEAl4Pu0vbiU2k2Hci9LvvddxpCxaM
	 SYNVjC3yy9e52xfz4o2ewzEefM8lEA90ZSKV9cx0xdvxFtGJ38o4tiBdnVOfEsFfQRgfr
	 gVZoPaZ/SK7mBEdXtALfNTB3ETt1IRlgbqyBpU7o+xfj/x1XE7FKDFw0ECb1GcMsEKyv5
	 xbdA9jF78ojH5JWuiRd21KG8naq+6oB8E2tLNtPOpQh8pxtOnlYxMU9EYC6mpFzLkteZ9
	 N9XdS+ErI0Cwad+LM46ZEC/ziRHliUF4kDY89U1KXfPTtvr5IQvsJlNgZHrQ+AOuWUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061045;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e7tCqhY6FhFCw5NY0OlT/l2nu06fnu1PvzkCFQwq27g=;
	b=1CVZAVRj0UmJ5LMsWxuG9Y/wQJTT6VxDoctBAn07rqITW3FrptkOvOFjx4qa76OSWCvP
	 N3Boc1WMmR1/QyHj13HWPvD7AfeYEo6R5R58pqbbzAAw6leCZdE6Lckce0SPMGfFieFQ1
	 be6Ozj98jPoc/VliAUuFO/jEEHrH8mn+peSt+8iVH8Vkn0GLyOdBA8vg4fF9koJijB2ND
	 7Fv194ERHSlxxGR9MrTBbDnzPdVoE4zbmTEQw31dir8TC2L8P6IrWFywJbW00PZshBCzd
	 rkHzL9w8FHLTaqVjy159jt1RJF2D0aRAAv7z1yVLbbSBtNDMHyqwoM/0TaZRk1GXyRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gMb7ID9b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1CE2606D80B;
	Sat,  7 Nov 2026 14:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gMb7ID9b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CA1A1F0089F;
	Sat,  7 Nov 2026 14:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061044;
	bh=e7tCqhY6FhFCw5NY0OlT/l2nu06fnu1PvzkCFQwq27g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gMb7ID9biY+P/1r3TUfHwIhydXc7A7FI03D3az5EzLrzmg/Tt9FN8JzU2zr6sAmDW
	 RyWUwAUvqG25Iu1folyVR4cM6vv2HLdEasAg0pMW/ZsOTVq9zX6hbn99UCBbBi4JST
	 VqJM98hvJ6iFRXhU9g0LTOJNTUAqesUanOnU7NMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinqian Yang <yangjinqian1@huawei.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0370/1536] virtio_ring: fix infinite loop in virtnet_poll_cleantx when device is broken
Date: Sat,  7 Nov 2026 08:39:46 -0500
Message-ID: <20261107135008.040084697@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinqian Yang <yangjinqian1@huawei.com>

[ Upstream commit 0d0eff39ceb3dcbf7847a6f4517086c207c60081 ]

virtnet_poll_cleantx() contains a do-while loop that cleans up
transmitted TX buffers and calls virtqueue_enable_cb_delayed() to check
whether more buffers need processing. When the virtio backend stops
responding during guest reboot, used->idx is never updated, so
virtqueue_enable_cb_delayed() always returns false and the loop never
terminates. Then it will block reboot process, and the guest will hang.

The problem occurs during guest reboot under network traffic:

  1. kernel_restart() -> device_shutdown() traverses the device list
  2. virtio_dev_shutdown() calls virtio_break_device() which sets
     vq->broken = true
  3. virtio_dev_shutdown() then calls virtio_synchronize_cbs() to wait
     for in-flight callbacks to complete
  4. A virtio interrupt fires, softirq is deferred to ksoftirqd which
     calls net_rx_action() -> virtnet_poll() -> virtnet_poll_cleantx()
  5. virtnet_poll_cleantx() enters the do-while loop and never exits
     because the QEMU backend has stopped updating used->idx, despite
     vq->broken having been set to true in step 2.

Since the loop runs inside ksoftirqd (a SCHED_OTHER kthread), it is
visible to the scheduler and does not trigger a hard lockup. However,
the kthread never leaves the loop, so RCU detects it as a CPU stall
and reports it periodically. Meanwhile, the reboot process remains
blocked in device_shutdown() because virtio_dev_shutdown() cannot
complete its synchronization step, and the guest hangs permanently.

This can be reproduced on a guest with a virtio-net device: run iperf3
traffic in the guest, then trigger reboot. The reboot occasionally hangs
permanently with RCU stall on ksoftirqd.

Observed on ARM64 KVM guest:

  CPU#1 RCU stall (ksoftirqd/1), repeated periodically:
    virtqueue_enable_cb_delayed_split <- virtnet_poll <- __napi_poll <-
    net_rx_action <- handle_softirqs <- run_ksoftirqd <-
    smpboot_thread_fn <- kthread

Fix by adding a vq->broken check in virtqueue_enable_cb_delayed(), so
that the loop exits immediately when the device is broken, allowing
the device shutdown to proceed.

Signed-off-by: Jinqian Yang <yangjinqian1@huawei.com>
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260716115940.394832-1-yangjinqian1@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_ring.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 2dfc815c54f68..92a96d592735c 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -2544,6 +2544,14 @@ bool virtqueue_enable_cb_delayed(struct virtqueue *_vq)
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
 
+	/*
+	 * When the device is broken there is no point in polling used->idx,
+	 * the backend will never update it. Return true to let callers
+	 * exit their cleanup loops instead of spinning forever.
+	 */
+	if (unlikely(vq->broken))
+		return true;
+
 	if (vq->event_triggered)
 		data_race(vq->event_triggered = false);
 
-- 
2.53.0



