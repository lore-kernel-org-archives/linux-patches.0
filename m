Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624510;
	b=mvUvvQmZYKaywVU6TEfRVCNyXpJIdKVHyq5rrmr3XUl7xvulvsMJm8vL8FDuBHKkdc98
	 GXyoNFDdbJvv1AJLxg0mq7ZvSHfHLXV4RqvfTIp8uxlrdjqHCkm4j4i/QNftC75GsuK6v
	 VzEd+K9yMeD5Eqa0Yl9I3JDUhjsGd8SARUFSNj8oHNVAxW+FT5YfAcNU+6u2TxpkEV5tX
	 CuxlMPj99feMhG0qI/v1YfgTE1mD+uwiPZMNnTRLJk2F90sYbSBc0+CNc08IrBjpzih0s
	 kWc8MInFJ+gtYlG2L+seys8nOd9PQ0l3B3HPRjPx4RA9EEi9HfToLsBXCeKjH02DU0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624510;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lP7zCq9ETyCJ9AhrGmmSR0O/NyWBb+s13MduHVVNKL4=;
	b=nB9e+96YMPFgf6CGfrDipHoIf+iFtUjlh5QGpzRSfe/50bPtasxp1j5Zo/07k09Qb7tU
	 6p0wEMcsvhvgtzD+LrlbMLxSR8TNVWVOnSjWFiiA9Ag7EGpU3GOdo8bsSSu3U7P3Cfztr
	 LS/3IiCUj4MHbYBu3kPK3PW7jrjQz+dm3BHcW34bB7Tje1YpUQ1YlXXLZi2bDlklj/6im
	 meeEzWWlcGWKEEPWXCf/bTqPKpMNh+WCNbaTOggsWl3KpGnkQaCERrKnyJuwIk2murGpu
	 +exBlfVkJAweQdBlBawFIKiAr5cuZR67snURj6MEpS3MOQYkLHBW2gPYIEfhGDqUY7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O7x7dHNY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC78606A330;
	Wed, 25 Nov 2026 16:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O7x7dHNY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BD4B1F000C4;
	Wed, 25 Nov 2026 16:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624509;
	bh=lP7zCq9ETyCJ9AhrGmmSR0O/NyWBb+s13MduHVVNKL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O7x7dHNYswgBhXdmJJ8wMEhmxS6ZDNOn5w93ze9ygBqGquRvE0edIQFDk1N0e19fa
	 iC+5ARPp3KaNTo6c2J8ZP2nPTKq+N1/0AH4gDmhoNsjaFYyLoysNouC++ySk9woJS7
	 KfNL5lI7HqVxYp2wS0VjvY10dRW4PjR0V7n4gjI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+13df72e0dc4be5c62215@syzkaller.appspotmail.com,
	Mingbing Zhai <zhaimingbing@cmss.chinamobile.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 179/816] virtio_balloon: initialize wakeup_lock before virtqueues are set up
Date: Wed, 25 Nov 2026 15:28:47 +0100
Message-ID: <20261125143853.334666941@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
index c67b29e5f7999..5a093d8786b7f 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -965,6 +965,7 @@ static int virtballoon_probe(struct virtio_device *vdev)
 	INIT_WORK(&vb->update_balloon_stats_work, update_balloon_stats_func);
 	INIT_WORK(&vb->update_balloon_size_work, update_balloon_size_func);
 	spin_lock_init(&vb->stop_update_lock);
+	spin_lock_init(&vb->wakeup_lock);
 	mutex_init(&vb->balloon_lock);
 	init_waitqueue_head(&vb->acked);
 	vb->vdev = vdev;
@@ -1070,8 +1071,6 @@ static int virtballoon_probe(struct virtio_device *vdev)
 			goto out_unregister_oom;
 	}
 
-	spin_lock_init(&vb->wakeup_lock);
-
 	/*
 	 * The virtio balloon itself can't wake up the device, but it is
 	 * responsible for processing wakeup events passed up from the transport
-- 
2.53.0



