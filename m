Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621439;
	b=uoIP71sZ81vMLbX0wmGbMf1ShD63OZ1OfIxqfexwLzZ8Ab1iHTPkoX+l4hK9v3LFYri3
	 Ma3F5TtCyYn5Nu1BxW0zJaHDevOVf/Or0Q8MXVyxWNPCLRad4SE/VAjUpema+Gh90YuVe
	 1l00GbQuPdIzIatxjBpL8K8VfZ1R3L1n4RgsIl76oZVzP1Kg62VB2q+PMNwT1sDKNi605
	 lHjuK0Che7+d6dF/A2bf13N9uly4eMHF/HMJUrGktVIw3w3OXQu7u0OXdIr/lZxesNakO
	 ZVX8nV1Q9qZ3jYZv32j7OgqdTLr8CxQPdvDimalgD7TcFveSZGG93lrXNKWRoWQuJMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621439;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r9ZqF6eAkQfO7hiVUOSkLwBJHkCH3VNtLgbJlsDPmSY=;
	b=IvJT91w+qYnaehCJ5l6WppF9cG1Ga117B3TCtCamLSZH9JY/fMBUOPv+PECoOinLxMkk
	 VFSt6CZb7AxYzri9RPr8FHNaNUVwphNS05SNgjIjrvRNuAne3Ao/5Dgh+9IanCcETTcGy
	 aJFiMW1e5mVAFTTxbX5ivRq7iyZEZG3iMr9fQCbIDL/K7p129PfAvyrt9X0IiAOWD1i3Q
	 jiggkd8hKTlCt/De/TmNblT3qFO9jM6misbEaYuFmwsd1Jdwvk3H3a76i9ueuy+50SIDb
	 wMJhe4I/lYAgfmEQDWHeEsEa5d/ZkZxLixlLbfmdwse1d7LWLE5QIMLcZuLsmYu9zjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LZizzDiM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48827606A32D;
	Wed, 25 Nov 2026 15:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LZizzDiM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5109B1F000C4;
	Wed, 25 Nov 2026 15:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621438;
	bh=r9ZqF6eAkQfO7hiVUOSkLwBJHkCH3VNtLgbJlsDPmSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LZizzDiMa4iXSqxFHb7cn5dSPuOC7IsfzoTwUrb7UO4IW3/iLKcbYgBLc7qtEqaf2
	 qS08JjTeiC5teAZZXrJW54KiZ2zxBfiLxgH9FjolX07P9Mxuw4hZpPETzZtivIyM82
	 hlrtkgWp1EEbjLaB5m8g86Ro4JY6wpfSYCDutfLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+13df72e0dc4be5c62215@syzkaller.appspotmail.com,
	Mingbing Zhai <zhaimingbing@cmss.chinamobile.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 208/990] virtio_balloon: initialize wakeup_lock before virtqueues are set up
Date: Wed, 25 Nov 2026 15:26:15 +0100
Message-ID: <20261125143826.963654375@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mingbing Zhai <zhaimingbing@cmss.chinamobile.com>

[ Upstream commit 161aa708b02cc997a51701c342f3cebade0b5164 ]

Since c578123e63da ("virtio_balloon: Treat stats requests as wakeup
events") the stats_request() virtqueue callback takes vb->wakeup_lock
via start_wakeup_event().  init_vqs() registers that callback and even
primes and kicks the stats queue, so the lock is reachable from irq
context as soon as init_vqs() returns, long before the driver sets
DRIVER_OK: vring_interrupt() dispatches to the callback without any
DRIVER_OK check unless CONFIG_VIRTIO_HARDEN_NOTIFICATION is set, and
that option depends on BROKEN.  syzbot hit it from a threaded irq:

  INFO: trying to register non-static key in stats_request
  ...
  assign_lock_key
  register_lock_class
  lock_acquire
  rt_spin_lock
  start_wakeup_event drivers/virtio/virtio_balloon.c:150 [inline]
  stats_request drivers/virtio/virtio_balloon.c:435

The lock is only initialized near the end of virtballoon_probe(),
after init_vqs() and several steps that can still fail and unwind
through del_vqs(), where a racing interrupt still finds the callback
registered.  Until then it is whatever kzalloc() left in vb: lockdep
complains about the unregistered lock class, and wakeup_signal_mask
and processing_wakeup_event get updated from irq context while probe
is still running.

The rt_spin_lock() in the report is just spin_lock() on PREEMPT_RT;
any PROVE_LOCKING build takes the same path.

stop_update_lock(), which the same callback also acquires, is already
initialized before init_vqs(); do the same for wakeup_lock.

Fixes: c578123e63da ("virtio_balloon: Treat stats requests as wakeup events")
Reported-by: syzbot+13df72e0dc4be5c62215@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=13df72e0dc4be5c62215
Signed-off-by: Mingbing Zhai <zhaimingbing@cmss.chinamobile.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20261016025429.901-1-zhaimingbing@cmss.chinamobile.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_balloon.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 0386e7b459bb1..cf53c1cf674b3 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -963,6 +963,7 @@ static int virtballoon_probe(struct virtio_device *vdev)
 	INIT_WORK(&vb->update_balloon_stats_work, update_balloon_stats_func);
 	INIT_WORK(&vb->update_balloon_size_work, update_balloon_size_func);
 	spin_lock_init(&vb->stop_update_lock);
+	spin_lock_init(&vb->wakeup_lock);
 	mutex_init(&vb->balloon_lock);
 	init_waitqueue_head(&vb->acked);
 	vb->vdev = vdev;
@@ -1068,8 +1069,6 @@ static int virtballoon_probe(struct virtio_device *vdev)
 			goto out_unregister_oom;
 	}
 
-	spin_lock_init(&vb->wakeup_lock);
-
 	/*
 	 * The virtio balloon itself can't wake up the device, but it is
 	 * responsible for processing wakeup events passed up from the transport
-- 
2.53.0



