Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036777;
	b=vP4NJ5L+PA/f2Q7upkFh2dtf0sVAYa2FObmLT/0fyRDzgGnao0vq04NbvlxJdxyOpdOi
	 vwp/bHmZFJhp8xrZarUZxTiD7NbA4nzkqihhIoH1WNi+PQpLyzcdQD1HlwvIqHNLWRp2c
	 h1JBhcIURiA4bCBuGBCCiPFbpDikIiBP/XoppDuspXllLlGc6x9W3aS+P++wShsUocNPl
	 uS9N/iZ/DMK49ZKIT9KxdjQvsSw3UzOlBfwTkRjvNfz8P9rkw+Zc9ujHo8gq60Hrr1hL6
	 h1znJozYmrESo3K2qr0opEjoHHEHhISvkYPmoftm9lqZpcjp4Jw7qRrGnXVs9IFBp5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036777;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5P1ID2EDAsRcqveULf5iBWbpe6wT+7N64HDVrOYwHtw=;
	b=zZu2s9GrmKFE8QcJxGwoqcjs743lKyweYIAnHvJghFYfGJFjG24zWP14J+VsrqZ6NKfb
	 ObmJEddVbgb1CDjrXii372fIw7pZ9QUbTDJ+wjGlLbTowc/V0usTIXCu5eeyiWOkGL+pY
	 i44dK7RCIPc9kUEW+cP5aW3dezKHsL0Ej23lE9rcxc1o5V9FQcgI1zdbo3XeVaTFe3NJm
	 UWIyplUSGrgkNDPQ0S8xvqaEBuB8XjanVtPiPioM8ZV92/nAp7AMcJtLV2NGm1Nf7P3oS
	 HU9GT4TH0WHuqh/ualzXZZWG3ek6mWCGAV70/sLBn31GHKipzmHXRFsr6pN0ABGykCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="IQ1LcN/N";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684D4606A32A;
	Wed, 18 Nov 2026 21:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IQ1LcN/N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B62F01F000C4;
	Wed, 18 Nov 2026 21:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036777;
	bh=5P1ID2EDAsRcqveULf5iBWbpe6wT+7N64HDVrOYwHtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IQ1LcN/NrLE+w98uMZQtvD6PDz8ZpviLLWMlyqitT75pjbw7NGhnGcyHft4OqYVnS
	 hZUVzEMxEErdc7YSE5TdWRCz7KlnIq8eFfAmEK6uPqfMljri9kA8uPx1d6FPHkafhW
	 A8gyASJK2MrOqNyNnNq+qtWNvWIHfsTdm6R/icCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c3741bb338b5c6d6a4aa@syzkaller.appspotmail.com,
	Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1180/3318] net/rds: ib: dont enable IRQs in rds_ib_conn_free()
Date: Wed, 18 Nov 2026 15:30:02 +0100
Message-ID: <20261118150355.542723632@linuxfoundation.org>
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

From: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>

[ Upstream commit f6fa1d60ec3ceb7e6c26aa91eadfef34f94014e1 ]

__rds_conn_create() calls trans->conn_free() with rds_conn_lock held
and IRQs disabled when it loses the race to insert a connection.
rds_ib_conn_free() takes the device list lock with spin_lock_irq() and
releases it with spin_unlock_irq(), so IRQs are turned on while
rds_conn_lock is still held:

  raw_local_irq_restore() called with IRQs enabled
  WARNING: kernel/locking/irqflag-debug.c:10 at warn_bogus_irq_restore+0xc/0x20
   _raw_spin_unlock_irqrestore+0x67/0x80
   __rds_conn_create+0x1de5/0x2290
   rds_conn_create_outgoing+0x43/0x60
   rds_sendmsg+0xfca/0x20e0
   __sys_sendto+0x408/0x5a0

It needs an RDS socket bound to an address on an RDMA device (e.g. rxe)
and two concurrent sendto() calls to the same new destination.

The TCP and loopback ->conn_free() callbacks already use irqsave, so
do the same here.

Fixes: 745cbccac3fe ("RDS: Rewrite connection cleanup, fixing oops on rmmod")
Reported-by: syzbot+c3741bb338b5c6d6a4aa@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c3741bb338b5c6d6a4aa
Cc: stable@vger.kernel.org
Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/ib_cm.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
index 1c6e3b3f39d00..c8771aa7df53a 100644
--- a/net/rds/ib_cm.c
+++ b/net/rds/ib_cm.c
@@ -1271,6 +1271,7 @@ void rds_ib_conn_free(void *arg)
 {
 	struct rds_ib_connection *ic = arg;
 	spinlock_t	*lock_ptr;
+	unsigned long flags;
 
 	rdsdebug("ic %p\n", ic);
 
@@ -1281,9 +1282,10 @@ void rds_ib_conn_free(void *arg)
 	 */
 	lock_ptr = ic->rds_ibdev ? &ic->rds_ibdev->spinlock : &ib_nodev_conns_lock;
 
-	spin_lock_irq(lock_ptr);
+	/* May be called with IRQs already disabled (see __rds_conn_create()) */
+	spin_lock_irqsave(lock_ptr, flags);
 	list_del(&ic->ib_node);
-	spin_unlock_irq(lock_ptr);
+	spin_unlock_irqrestore(lock_ptr, flags);
 
 	rds_ib_recv_free_caches(ic);
 
-- 
2.53.0



