Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034267;
	b=lHa5VHlW+zxcRWzbc3elXnbHGTG3TnOJdDD0yT5+uEJmt0iwoidkqZZ+SmiLIiQjoF4K
	 9Z8ydlt/cndLSYsYZQCqdDnrpe2JoT2frM7MDTxZl8ITcJxelCRexWowOKaoeLV6mSODu
	 aUy3ETuVFqyPo8ElkRVC58D4qL7CJF/8nQGpy+YsCTUip3bOC1y/yvB+uCZ/oDI2MdpPS
	 gNWOzoFGGl1b2WHrZRH1ist/JEebxJJMqFtbZV9goOIoGauv3bLy2QQ7+HqcJLWmksBbT
	 Z6nvnNYIcmF30UrcX4g4Z7UuWDDH57h6TUnp6+QJ7o2WIVtANTiixPlGWy08wlrTHtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034267;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hwv+loXBTcUL8kMoWsaHiI5nceJ8TY2A4JrmIoHi89c=;
	b=Vy+7hq3e928lJgESSr+tsik4YdiDA/O7ZsZnRLI326jKll9tG8uq3Pl3lfs8nKquf2kC
	 GztuMcBcmH7yXzk5TPi7MAM0hjg+ag4Fmy3WLLjIEu9vJSpVrvGEuV6GA2OPfvnH/eYrf
	 H2au5sGrH1TAFH99Dwo01wy08Vcq1FDbXBACbuWO0fn1Ir6Y3HWJpyWjlywjw06sNfT88
	 8+6x70PZt0KMNxXLwLkYQMaUXgLDqDc9+duudgTVMFh4BV8UVTYIYfhAkUYIqXI8TatN2
	 DKJoOq4c9jgS/3YVMR9fQMmjax7h1AUPC/+c+qbmILbUyNoVfRQIq0xGmb/c2ufg/Mg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xFI3tCp7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50949606A320;
	Wed, 18 Nov 2026 20:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xFI3tCp7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5CC61F000C5;
	Wed, 18 Nov 2026 20:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034267;
	bh=hwv+loXBTcUL8kMoWsaHiI5nceJ8TY2A4JrmIoHi89c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xFI3tCp7+zB9nVGDlttpE1p+dC3EO0y8A0hAdYoyyySY/vMEuvFU6NKm9zgkadz3X
	 ntlOozF1qim4BgP+vcS4vTk7rgXDzJybQ/eMgQn5OQncye0szBCScFAuWJhmPQxb89
	 18m6WaIVE2U9C2MHRJRmh3L4k9xwXr9II1DWzEjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinqian Yang <yangjinqian1@huawei.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0309/3318] virtio_ring: fix infinite loop in virtnet_poll_cleantx when device is broken
Date: Wed, 18 Nov 2026 15:15:31 +0100
Message-ID: <20261118150325.061628634@linuxfoundation.org>
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
index a7abe94b5dd81..44a6c4d16d9db 100644
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



