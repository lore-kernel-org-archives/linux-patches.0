Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052847;
	b=rjQ50FjEbxdWbTWrqwXNLuIwm3bmr/UHN5c+bXwrkNZGHLIaI5KL2GbgPBoECU892smc
	 iHiwuBHGEwm/xtHqV7dRap9g+/Dg2TlmthRZFFV0qMxMwxFePo9B5uvCdy2S+1+AAWVMf
	 G0WaLUu00B1CJ+0lbQoCurBDAcLX4RJeAQX5ORcZTc9PXQbGod2ov7255yDxjs+qw0+wA
	 e1oq/r9RpC26SwlafmWa8QVxZ4M0lu6+/7SeXTGmdYM6ppAoKvOplgfbJTpGBYqhs/RRk
	 5FSDpL9l6oYz1dEXpJMah3c+/u1DfxJgq9whuVB4egpV1uOGibKSUbJo9Hn/mTUFjEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052847;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A1gSf0afAGM7lJpfrnfGQgzULey8yQzeFwIhjKDaA9A=;
	b=dTVYIUDV8KCMwUTiNJdQHXSYRVAH630Sg1VaGVzInMSOtLb6MTCbu0Z+XfF8NpuW+/Ev
	 VNmVuL738CcXw92t0gxLWm4nDgZ9fJNIGs1q5sjdhqYZwZAhbbwx9h7gQu4g6ma3F8vtc
	 /t22REMGJmbcv4VEYj3+wgb44dTveB0TvVYW26+V8FBsiDapQJ5REhwRAn+xMhBxrrOkI
	 ZHd/g5WrvG+5wVGmafz+hj5wideGF/5tYr4XCm2Dx3wbgxrTBuUhZD3W4+oTNvJbiMhD/
	 Fc4BSZm2zJ9CZxaqi7oJGRWkPv9VJPVc3FghdlvouT4nKcWXdhtwAM4b3g6OoLjST6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jF+yGD9K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BF4E606A331;
	Thu, 19 Nov 2026 01:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jF+yGD9K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFE6B1F000C6;
	Thu, 19 Nov 2026 01:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052847;
	bh=A1gSf0afAGM7lJpfrnfGQgzULey8yQzeFwIhjKDaA9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jF+yGD9KoblZJGA3UCtIHm8GnzG0NMR7kl6Oi/o4mlQ9fwyCklDU6C1osqnjFEutV
	 ODAzigqf9qX45vDfY+I3AshhBo4U2BoJyyq7aQcF9fjD5cHHcM5eoXVLUbcqf4YshE
	 c2QajvMvL+jV3DfmQeVfZBh2bFESqqyiyR6tUtBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c3741bb338b5c6d6a4aa@syzkaller.appspotmail.com,
	Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0682/2214] net/rds: ib: dont enable IRQs in rds_ib_conn_free()
Date: Wed, 18 Nov 2026 15:39:18 +0100
Message-ID: <20261118150039.047635825@linuxfoundation.org>
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



