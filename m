Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348DE43846B
	for <patches@lists.linux.dev>; Wed, 16 Sep 2026 19:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789587329; cv=none; b=fqeeZYXl2WWLtLfO8MQcjLJQ4BkvG0jA6QEhu45egZ7lu7C+foOalR/qanfTraJOO6XeflBuzUIGEMwUnU56aYGBZrIgrVDm1YpWWqeeDX88im8RO26uz/c+oz5sC3fcZ3ot0/kaR0J6cK1+0AyGhGQ6vuL+s1HztX+3TDb+L6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789587329; c=relaxed/simple;
	bh=37mrbgiKj2yMEYJvYaqXJn4UZXI1sNe0ef9mvGAtKg4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lhyoYL/0h8ry5mTHnuC69flBEIeZDeNJZfa3HXdxSZRGg6i7tPzrV37x3p+gQwdnvBzJ7ps1dzMOg8RjS8CNliqhju/BTBl6kvp+GUH3ruZCeeLNQwrtfu6CD6+lEOSvL0wQYWaAVd/ydzfw2K3Ln3j2X69AYUKH6Z6gN9QMGP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QNtVV5Td; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QNtVV5Td"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49d097b4939so494525e9.0
        for <patches@lists.linux.dev>; Wed, 16 Sep 2026 12:35:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789587312; x=1790192112; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=713Rnd8tXfX5v2C5/tcwaMUXoXj1OqEgNCWH9P2bUyg=;
        b=QNtVV5TdY9L4ipnAlO0ur2V5XZYgIOcZ+qizeuyav5aJwEX+M9x4puxyspowKL3oGg
         IfncaWIlITplKj/wuE1VmQAgHeMT2E7hjkcxTIZyd7C2Zg0VOcTQ3MrIYtQYFT91ZUmF
         +iVzicn7AA8e6wJAzXE5AlE+Z3DogtFpAp7Hghx1cniEs1AEYuQue/BNM+3bN+KJ+5ut
         8ONMURGrXFCUKH0XS9kTljmliQzWqvvVFYiuuzG//G9sIYSxBfw8qD6lKUKIvOVQ1mRu
         yglM22NgaauGpclj+4bpXyktryxTu3dars6U0SDkZf/FXYLsbZ/5mCm6hijOXzV8IzBb
         xvQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789587312; x=1790192112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=713Rnd8tXfX5v2C5/tcwaMUXoXj1OqEgNCWH9P2bUyg=;
        b=dxVvzenaZBaKAHoSrWyRbM5HSCE5MA6NMAhgkvHEVJzgajwTTLeeVx4MUxIMkSQbU9
         q410zubIc1MiVKlrFgignDTYPUPGFAtgqgqFZC+kGd44CZJ2lm14cAoOzTAH6dOl9VZ5
         qdl9zLgaBucOiQu3/n6jsQBiQMd5u8cs2zjQUvjMaiQLqgU0hM4IgzituGHWhSQN7gFF
         FLdACyi+4DGN5frz8KNKrH97yl06I7yPu+0z52K+9NQJZ0CddDHgdGaSB5K/RFQQ9uPf
         stcvE5XFVs4dfPjKOgCyY0AwD8KS4zimg3Wylq6UFVkR05K9yhoFfO7F/GtH8ugi3R65
         cMag==
X-Forwarded-Encrypted: i=1; AKwUvBxzJ+JyovY2cUApnJ19i0fGUp6oxngXREipRelswAw/E3uDM1nzAaR28dsJOvjinH/Z7eNs3W3C@lists.linux.dev
X-Gm-Message-State: AFuF++nnJCnnviIdtDFdcvCVe0ajLLBcPU0BsxTTxJwlxWuVW0J2AYiE
	1z4UWx+NUcZU79kuqoqO3Kf071RBHYCexiJnOxxo0FUgJEyUZ458yjo7
X-Gm-Gg: AYBFou3cK/IODOFEDaclNRQpfY8BqhmOlfid9BmH3N8lUTbMs9XTB5g9g2PaJrhSCa8
	/g/ynkuWM9N7gcNwYNgPNTM4LNI6VJXz4arZ/fLIpRJbckBxFlblD0yXnkG7821lscoBozlvxjZ
	s4dxHi+eX8hZQEtlLxHxuppEH65NZcJ0uhIEWFehuNWcIPYhYeUDtxzL4/LXJWNO34yU0VYQkK7
	7RwgqEroNTLFt0ZJUYUvKRDP0Yk3McE2lCjhGTw7skBnUCvtMw2nNQ7ZXBnwjI1LH7/ekMCNHbH
	XEHJCiWQamzHMfqiOARKixICcICJ5uEoKwulHyBaNwRXhtXRg/7SVQ0RDywzwFZsF8Wm0pIeH0J
	aXuy1UpZXlZIg5I+81ovFSL7Qo1ha/djRYjsFusFsigyUV+GopnZIcJNfUERTaz+eOWDPZ8VeMR
	CuAdIFU/5oDfwIwFrOi7yvEtiIwFeK6j1CEtzATeRDjvI3LgyR3Lk//YnlLuHdVE0VP7QeIz0iG
	y1ZFsfCMbjwKxMslVkKI47/4dRCmM76XdPrMuj8+gQvO1/e2DYaEOM6CKNXYfmY4GxXqlqX0KxN
	gmxWrzzx6LRoUxChCQTlKvvJUeFlgFtvfVYP8j3/mSWGJ4uhvLSOYJYJdBO88aUow+lqQmIvoMJ
	13amBk71MP50m6gGv
X-Received: by 2002:a05:600c:46d1:b0:49c:c0d4:53d9 with SMTP id 5b1f17b1804b1-49eb72fbf26mr45934875e9.14.1789587311636;
        Wed, 16 Sep 2026 12:35:11 -0700 (PDT)
Received: from MacBook-Pro-von-Karl.localdomain (dynamic-2a02-3100-adf7-5a01-5cac-d7ee-c105-a566.310.pool.telefonica.de. [2a02:3100:adf7:5a01:5cac:d7ee:c105:a566])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49e847fcbdfsm60879335e9.4.2026.09.16.12.35.09
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 16 Sep 2026 12:35:10 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: stable@vger.kernel.org
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	gregkh@linuxfoundation.org,
	sashal@kernel.org,
	luiz.dentz@gmail.com,
	luiz.von.dentz@intel.com,
	marcel@holtmann.org,
	johan.hedberg@gmail.com,
	eadavis@qq.com,
	davem@davemloft.net,
	kuba@kernel.org,
	linux-bluetooth@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	syzbot+b7f6f8c9303466e16c8a@syzkaller.appspotmail.com
Subject: [PATCH 5.10.y] Bluetooth: L2CAP: Fix deadlock
Date: Wed, 16 Sep 2026 21:34:54 +0200
Message-Id: <20260916193454.9996-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <aqoaFdvSsDiiLb5I@gmail.com>
References: <2026091453-unwary-delete-b272@gregkh> <daily-reply-20260915-0012-re-l2cap-recv-cb-5-10-revert@kernel.org> <aqoaFdvSsDiiLb5I@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit f1a8f402f13f94263cf349216c257b2985100927 ]

This fixes the following deadlock introduced by 39a92a55be13
("bluetooth/l2cap: sync sock recv cb and release")

============================================
WARNING: possible recursive locking detected
6.10.0-rc3-g4029dba6b6f1 #6823 Not tainted
--------------------------------------------
kworker/u5:0/35 is trying to acquire lock:
ffff888002ec2510 (&chan->lock#2/1){+.+.}-{3:3}, at:
l2cap_sock_recv_cb+0x44/0x1e0

but task is already holding lock:
ffff888002ec2510 (&chan->lock#2/1){+.+.}-{3:3}, at:
l2cap_get_chan_by_scid+0xaf/0xd0

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&chan->lock#2/1);
  lock(&chan->lock#2/1);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

3 locks held by kworker/u5:0/35:
 #0: ffff888002b8a940 ((wq_completion)hci0#2){+.+.}-{0:0}, at:
process_one_work+0x750/0x930
 #1: ffff888002c67dd0 ((work_completion)(&hdev->rx_work)){+.+.}-{0:0},
at: process_one_work+0x44e/0x930
 #2: ffff888002ec2510 (&chan->lock#2/1){+.+.}-{3:3}, at:
l2cap_get_chan_by_scid+0xaf/0xd0

To fix the original problem this introduces l2cap_chan_lock at
l2cap_conless_channel to ensure that l2cap_sock_recv_cb is called with
chan->lock held.

Fixes: 89e856e124f9 ("bluetooth/l2cap: sync sock recv cb and release")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
[ Karl Mehltretter: only the l2cap_core.c and l2cap_sock.c hunks apply
  to this tree. hci_sync.c and hci_sync.h do not exist here, and the
  hci_core.c change is an unrelated conversion of hci_dev_cmd() off
  the old hci_request API. The changes to both L2CAP files apply
  unmodified.

  The lock this adds to l2cap_conless_channel() is also the one that
  commit c531e63871c0 ("Bluetooth: l2cap: always unlock channel in
  l2cap_conless_channel()") was backported without, so it additionally
  pairs the l2cap_chan_unlock() that function currently calls on a
  mutex it never acquired. ]
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---

Notes:
    This is intended to replace the queued revert of
    commit 2243127db6ba ("bluetooth/l2cap: sync sock recv cb and release"),
    rather than to be applied on top of it.
    
    The revert fixes the deadlock but removes the NULL guard from
    l2cap_sock_recv_cb(), while l2cap_sock_destruct() still sets chan->data to
    NULL.  Under KASAN, closing receiving sockets while L2CAP data is inbound
    then gives a fatal NULL dereference in hci_rx_work, reproduced 3/3 on
    v5.10.270 with the queued revert applied.  This patch keeps the guard and
    fixes the deadlock in one step, and uses the two applicable upstream
    L2CAP hunks unmodified.
    
    Tested in QEMU with two virtual BR/EDR controllers, PROVE_LOCKING,
    DEBUG_MUTEXES and KASAN:
    
      v5.10.270 as released         recursive chan->lock deadlock
      v5.10.270 + the queued revert fatal NULL deref, 3/3
      v5.10.270 + this patch        clean 3/3, 300 close cycles each
    
    BlueZ's own l2cap-tester also deadlocks hci_rx_work on v5.10.270 and never
    completes.  With this patch all six tester suites run to completion.
    
    Also on a Raspberry Pi 400 (BCM2711, onboard CYW43455) with a second board
    as the L2CAP peer, each test from its own boot so lockdep was armed for
    each:
    
      v5.10.270 as released, connectionless   bad unlock balance
      v5.10.270 as released, connected        possible recursive locking
      v5.10.270 + this patch, connectionless  clean, debug_locks still 1
      v5.10.270 + this patch, connected       clean, debug_locks still 1
    
    The same board with an A2DP speaker shows the user-visible effect.  On
    v5.10.270 as released, connecting to the speaker deadlocks hci_rx_work and
    playback cannot start at all:
    
      bluetoothd: a2dp-source profile connect failed: Device or resource busy
    
      task:kworker/u9:0 state:D
      Workqueue: hci0 hci_rx_work [bluetooth]
        __mutex_lock
        l2cap_sock_recv_cb
        l2cap_recv_frame
        l2cap_recv_acldata
        hci_rx_work
    
    With this patch the same speaker connects and plays the full track with no
    kernel warning and debug_locks still 1.
    
    If the queued revert is kept instead, the same end state is reachable with
    two patches on top of it, which I can send.

 net/bluetooth/l2cap_core.c |  3 +++
 net/bluetooth/l2cap_sock.c | 13 +------------
 2 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 1122566c4b50..7de512843f06 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -8044,6 +8044,8 @@ static void l2cap_conless_channel(struct l2cap_conn *conn, __le16 psm,
 
 	BT_DBG("chan %p, len %d", chan, skb->len);
 
+	l2cap_chan_lock(chan);
+
 	if (chan->state != BT_BOUND && chan->state != BT_CONNECTED)
 		goto drop;
 
@@ -8061,6 +8063,7 @@ static void l2cap_conless_channel(struct l2cap_conn *conn, __le16 psm,
 	}
 
 drop:
+	l2cap_chan_unlock(chan);
 	l2cap_chan_put(chan);
 free_skb:
 	kfree_skb(skb);
diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index 9d834f225462..018b5a0c87ce 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1548,18 +1548,9 @@ static int l2cap_sock_recv_cb(struct l2cap_chan *chan, struct sk_buff *skb)
 	struct l2cap_pinfo *pi;
 	int err;
 
-	/* To avoid race with sock_release, a chan lock needs to be added here
-	 * to synchronize the sock.
-	 */
-	l2cap_chan_hold(chan);
-	l2cap_chan_lock(chan);
 	sk = chan->data;
-
-	if (!sk) {
-		l2cap_chan_unlock(chan);
-		l2cap_chan_put(chan);
+	if (!sk)
 		return -ENXIO;
-	}
 
 	pi = l2cap_pi(sk);
 	lock_sock(sk);
@@ -1611,8 +1602,6 @@ static int l2cap_sock_recv_cb(struct l2cap_chan *chan, struct sk_buff *skb)
 
 done:
 	release_sock(sk);
-	l2cap_chan_unlock(chan);
-	l2cap_chan_put(chan);
 
 	return err;
 }

base-commit: 1797d8bf8d0c2e74defad605d14e3553d43a3caf
-- 
2.53.0

