Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618294;
	b=MMii6i/SBMTsBW0GqaMwKSMwSJAM1c071WXfvF/jSD40s9UAe6mBfNYJz/6KFRLdcilz
	 wHM2v0PuuN+KWsNVft7mxFlon/aS66G3I/1YT5PzYQcpz/sQ+JcLx2g9EP0t6miyfZR2U
	 BMHfFEY21n0JWXuZhcZxJ0w/l+NqrItklbkNT6qpR8zrHKDIICLsawNE2Z0CuvJLwPHJc
	 1wOaEKZgAt0HSBmHwU+8Eo7V9L/WJiZuQfo47HHGyQlc5KIK6BbYxVDCvsX98cdsqfUv0
	 nizajUABuFMDyW7illYsETC0FQ1Omimam1eri77LjG8aBhm3xzlC3nPMmWZrouqsxmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618294;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c8Pmhevn0oWPm8voDRpMAqFzzIRflyl2jFWAuTt8hZw=;
	b=NOT2GQRcG1rkTj8WIhmF7cS+/RHXnQSfw99mVRHlkwR0Pkfn8t/trvMmDoGtB4JSbahq
	 1skLrmMxR+LnR3k6vBYZULiQYtFu+Tgu0fM1u707ZyLpTcgLoltgZzBO8RhhfdZQWI2ok
	 pOtB/3O+hvi6OsfoFi6/6hj0D8rSX1DtSFLWa7erleKfT9YtDdk198KOT32x61MaiiJ3H
	 diZDjzQTwsyBzYbmw8lo/w3I+A7OJg1e5IA1AHyn4OQ4AIOjsM/z88ZcfPhQHk+RA/xPm
	 npUxPOH6Jz5uWN5sj/Uh0VS2JqFbK7hniqcc9G+aTVFS77IEFAWf36YhS3opogzXCRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VhL9paVm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CEC6606A31E;
	Wed, 25 Nov 2026 14:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VhL9paVm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E0EB1F000C0;
	Wed, 25 Nov 2026 14:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618293;
	bh=c8Pmhevn0oWPm8voDRpMAqFzzIRflyl2jFWAuTt8hZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VhL9paVmNSK0mV33R/N+HWUUGgtaIx1fWovyXnv+3LIty07F33p011Ll7nysAswrZ
	 JNa8lk3NyxEJ4XqoNciAGIDyRK7lxyEMxBo/RmXsR80rFTk6KLLgLjyKC/aZFUvqsG
	 gzLpaPObfBkKNoHi85LJ+YXtXiaO+apmmCcspPPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+13df72e0dc4be5c62215@syzkaller.appspotmail.com,
	Mingbing Zhai <zhaimingbing@cmss.chinamobile.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0234/1005] virtio_balloon: initialize wakeup_lock before virtqueues are set up
Date: Wed, 25 Nov 2026 15:26:12 +0100
Message-ID: <20261125143827.220102431@linuxfoundation.org>
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
index ab3e3d887e00f..8c1b47ec17a29 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -942,6 +942,7 @@ static int virtballoon_probe(struct virtio_device *vdev)
 	INIT_WORK(&vb->update_balloon_stats_work, update_balloon_stats_func);
 	INIT_WORK(&vb->update_balloon_size_work, update_balloon_size_func);
 	spin_lock_init(&vb->stop_update_lock);
+	spin_lock_init(&vb->wakeup_lock);
 	mutex_init(&vb->balloon_lock);
 	init_waitqueue_head(&vb->acked);
 	vb->vdev = vdev;
@@ -1049,8 +1050,6 @@ static int virtballoon_probe(struct virtio_device *vdev)
 			goto out_unregister_oom;
 	}
 
-	spin_lock_init(&vb->wakeup_lock);
-
 	/*
 	 * The virtio balloon itself can't wake up the device, but it is
 	 * responsible for processing wakeup events passed up from the transport
-- 
2.53.0



