Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062494;
	b=NDgK1/lIVumiRs8TNKffysxgpCBSPZgtCemC9pN5UwZ2GlgwSlz+l0cryCYXRsHT6u0G
	 J/SrLaPlU11C9Vc+HF+tc3I/aKKNvnD5mEyyxv48sBQwKT3qiFhu8N77gG5UGdPP4YXEa
	 wiG3/L2tUuXlOwZ1+VBgyzaj5vmUG36+sKi+al5V6VvMQC0QlaneJVXlQ//7THfcIUCut
	 yUJanpsomud3en+4RYbBqU9ChEuFNswaI3iXqJuClweNu0UOrbywPdBlK+zyIwVXqv59l
	 K8pJlSSNASTQIy4zpiTBSyzXPYu9ImH1PN6iAafH/BZfAEM9dVXiES/+mMO/Dr53M/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062494;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c0mYtsDZ/XygnW0yVKettjN2thx2QPpS7mr+qivktPk=;
	b=GL7oBB2Cdl9qe4TATAsYD2x0hwa69y+LXlxzNcUTIt0WkIpmTJ1yYk1iiVD2U2qZE/ZC
	 MtFfNgboC5/gatMuSb2XHRYceYzTc3zbXugTRU2G7k2wm+dNauXhSjl6aaQNGInCO/9Ou
	 ktJGKmZlxUMpLVgho3mARa9+1ka1OeC2GLQweDkxwIb3tZy8RLksHb9+8f9tWoxfyO409
	 20DVKLt8bczRYfcfQeqceeT/TNS2aTtZ/fxVf4caIUE2FGG+GqaHZdgzz8dB+arRU+lLF
	 7EX+MkP2byRsaz9Jmv6KxkUqOFE7tXu+LEDfO/US6C4ep5+lIrZslMU5xrV6xt4jg2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=132AaiB8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D7C606A33E;
	Sat,  7 Nov 2026 14:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=132AaiB8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93AA71F0089F;
	Sat,  7 Nov 2026 14:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062493;
	bh=c0mYtsDZ/XygnW0yVKettjN2thx2QPpS7mr+qivktPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=132AaiB8LTMgred/ytjptCTEz0WnRly3nq5I4FyT4/TdOWs0bUPwEogXqZLqyO04Y
	 lmiqXaRoZotLSep/kQ/mjLPdAN5sZXAjyKpIHfwI9+ZJgs8Y9etWTYN0XAMtUHX/gH
	 gkQ/hxWSYVADfqz9oHS2WBy3mQBqhnfhxHe/jqQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c3741bb338b5c6d6a4aa@syzkaller.appspotmail.com,
	Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1392/1536] net/rds: ib: dont enable IRQs in rds_ib_conn_free()
Date: Sat,  7 Nov 2026 08:56:48 -0500
Message-ID: <20261107135036.923535669@linuxfoundation.org>
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



