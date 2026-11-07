Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065262;
	b=rRD49/373+8kpSFr93+TmEm/pZY0XYd4TOx7ahIUxgXN6T0n4vf4a6JW4/XBdcihh1R5
	 8Mt3VV2NwyrCCrsqp9I5OUxug+n1d/FWhnypXVNodmE3fc5HZeB9oT65X4NrwVwSbDaDG
	 CK2ulrMJZ4rMxYezNTI/fxS0JyoX2/guUEs3X5uU9fIGAWPsYB3h7dz8ijEGJRR80mE4T
	 jn7u6OS5JYQ3AexEZxwCneIzrLfGR60MsjF1G0SXV+DsK8gekvUXlIF/AWlabEhqYFd/O
	 96vc4VPkIHx/7rH83V9TEer/NRC66JRrgsfJkD3uPizJMDZDkQChQObYB9yWYTH5xsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065262;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LvTlZHIvwwrUAYnkDC2fw9iixvlZfUMvDLho5Dl+QJg=;
	b=dz9V+c7gkftLixvKvfT43ZskFrasSHKkI66l0u/fpl++nyZL//vaLpuWS0LpsGnxp3ji
	 +9bOmD+5eeBM0OVz57nFgpECnxbdtagX+sbZ93eWGYy1WQlgObYVppSCwudKzMYIzXJtF
	 S36XoqiCyvymBpydwEht/v6reUMOZq/fuG+ZfaUKwiKA7oAr49bVc/iR+JxQ0isj8n5li
	 cyXu18Gsv/SxXbVklozwk80XtuRDPSchLfPxpkrttrr0icuiYAWKzfhiomBjjK/eL4a4/
	 OPlPmyr/oI0tnwl9VrQPyRcTNiUQSBc0TZ9RqaDJ1hnIBq7tF27d4IKEAMEj62mv/AA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xeOvV8Ki;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2342606A32C;
	Sat,  7 Nov 2026 15:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xeOvV8Ki
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55E221F008A1;
	Sat,  7 Nov 2026 15:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065261;
	bh=LvTlZHIvwwrUAYnkDC2fw9iixvlZfUMvDLho5Dl+QJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xeOvV8KiuMmButNcoX3MHzCieqmDDtnW975fDjrFNPZLmRxxuRjhBPbqN1mBTxs67
	 Ti/k9QO0oy4l+DqJ/YL/wUCH0nSuFG2fddJwmLuuwnueB0w/XtkSa1t4buPHDJyvns
	 pFipAuPl718hkzU/yqkLeCcS1qWAiNWEFXOppd20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c3741bb338b5c6d6a4aa@syzkaller.appspotmail.com,
	Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0980/1257] net/rds: ib: dont enable IRQs in rds_ib_conn_free()
Date: Sat,  7 Nov 2026 08:54:36 -0500
Message-ID: <20261107135006.426574314@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index 6e3110a04ae6b..5c717120eab56 100644
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



