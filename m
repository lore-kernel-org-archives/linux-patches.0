Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063557;
	b=NdYGQoKwQaU1KS6QVbiXDfWptmb2uA4/qvvDaG0pX5pE9gB64O1vqQzjQWvjgdKC3T4L
	 21Hpr6/VbT23PMDBMYOaD3POR6H8CRYrmyq1BqwR/VMn/GyIKqt7MONTF9w2rG66EV0hf
	 /Xesbi8lwTTKABGxFK20zUCrCdTaAlbfH9ggc4NWf076VyfYt705yLsgygPXWkClwYIfe
	 uVBtGYzbfKHG/cIoNiC45b3o4/otXb5r23Ap57qUzXhfnNCkfIiFHQlujieQcf0UssN5w
	 EB4HKMLKI+Z60I0noXV4fvBs5V7um85Oj2u1iBU8/jUlq4mpuCJeCtT/xPjHLnv2ZUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063557;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=26QNzd1Dl6RFQVBENm9F9lsWS44LLt/BKAcLv63vVE4=;
	b=rCp/zMA5Dq0Pu8EbS/vvEr7jSB/FK9SWhMTrx+JgZUa8f3QlGaUd7zRPPs0sBuRku0Re
	 1+zvzZoZxbJ7LUOqjifhx9TMPfZYx2tR+iaE4uiUKGSFYDZ8Mc0VC3RV+QxfygSrctmUH
	 87n6tRd3pcvvTcuacJXpSkURjoEqXNa+wO5f3MKa4cnsh04Ek79ouleBV/Jb95M7uME3p
	 unzcKgHfqzsiS4+42tXUKqT6nyQxk0kH1l8tV6hTguQmJYdXrSLGm3Q6zPW4p2U46fkZM
	 KQZjUQGZKKCtgKj2YYgIIweGcCtTKR8oOuIngVet66bqFAe3IzRbmotPdl4pjUYmoMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gi3R8qdV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C470C606EE8A;
	Sat,  7 Nov 2026 14:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gi3R8qdV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72ADD1F0089F;
	Sat,  7 Nov 2026 14:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063556;
	bh=26QNzd1Dl6RFQVBENm9F9lsWS44LLt/BKAcLv63vVE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gi3R8qdV2C+X/zVqkV8pUFgxcxSgVa9vcDR9bCUissrBvjyAPtTWxFj4EmoPyLHGQ
	 LzbaJYf6HYUSHzzU3g6FkZX6MIV0FKwrFPpsJ6BnvlLroPbVdOuKknrGnHynVAeEwV
	 a9jlnBPa/zs4w/X4Xtlkr1Ax1GZW34G8xzTKx7aM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c3741bb338b5c6d6a4aa@syzkaller.appspotmail.com,
	Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 691/869] net/rds: ib: dont enable IRQs in rds_ib_conn_free()
Date: Sat,  7 Nov 2026 08:56:13 -0500
Message-ID: <20261107134916.438737852@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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



