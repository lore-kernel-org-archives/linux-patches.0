Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214680;
	b=Ux77DtPSBHGSiK83AQZwIViT0VFL9jdYX0/0WRGMVI+4PiLoQNYtieFmfmKI72aLy/8r
	 0GayWeed0jEtIrR8daO2dJ6w8AVXaKfxsT6XlXcERobRzbbTL5/62cR7RrMwXWjVCpfE3
	 n7q5XRYjJiLPoy7oVx+1pGrd0Vl58ItcNtp8L8OsMwbDSIQ2E1jlvh9PPPM4LTTaeXxCn
	 y/7JJkg+m8q76ZzjPtCttcjnmQFOeIu0axOz/2IJvLw5dNqUl+BeFN+bOrMQuXD1U5d85
	 lJ12zbav/G83Mu4dK5Z8B9DpJEoGfEA1yP/p7HcW00Q3/QQYH86e7cCcgeVuv8ZSS1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214680;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F3FNMK0dojaU21ZQuQrd8yqov6EByVyN+tONzg+e6i0=;
	b=znl32gs8y73fJHmj7XSveLL4WDFiSrqXN8VV+pZpmY8GGl9GKHI7kFQ9pf97CTOVOLUR
	 B/Tesf1vFkR4Z7A6VnfUl0IVp7bvyP7xT4i8LzVMg7axwRyCWWOFC8FS0A9dP4SQO8G22
	 YZ4MDLk/w/Hb1gNwxK47VCDH3duDdkfz5ecaXqT00lzSqJn4xBIu6dnOruwdcyA/T4l4L
	 TjBhqeZ1r2NcfQqdBMr8bGnY4yS7/FpzlHTMHg32Ji9UdB3rKwOc6bLiHSHMy+6RFQvFu
	 +VsbcOCe8oDzYidfzXFZ0t81TLDYeGqO5jj+6i8z47klPlURcRIQ2ZeZ3ZB9DE7Ml4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x6yGHofi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F550606B7CF;
	Wed, 28 Oct 2026 19:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x6yGHofi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C13481F01825;
	Wed, 28 Oct 2026 19:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214680;
	bh=F3FNMK0dojaU21ZQuQrd8yqov6EByVyN+tONzg+e6i0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x6yGHofi5laHIhxlZKaQbrh1ATcHUrPGXvirN0WWSHC012xSFqsXyHPbjPJSMnyGt
	 vd2iDDSj7B6p+TzfPtKWTQBPT8E0PpMzQlRbhIpI0GGrIwEmGsKs5x1OTMXZQyksS4
	 PNUErq6+mKREOB+AcyjiATctiubc7Z28qiJJoXEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2e2cf5331207053b8106@syzkaller.appspotmail.com,
	Allison Henderson <achender@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0942/1887] net/rds: Fix circular locking dependency in rds_tcp_tune
Date: Wed, 28 Oct 2026 17:50:38 +0100
Message-ID: <20261028170520.847458590@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Allison Henderson <achender@kernel.org>

[ Upstream commit 6a877ececd6daa002a9a0002cd0fbca6592a9244 ]

syzbot reported a circular locking dependency in rds_tcp_tune() where
sk_net_refcnt_upgrade() is called while holding the socket lock:

======================================================
WARNING: possible circular locking dependency detected
======================================================
kworker/u10:8/15040 is trying to acquire lock:
ffffffff8e9aaf80 (fs_reclaim){+.+.}-{0:0},
at: __kmalloc_cache_noprof+0x4b/0x6f0

but task is already holding lock:
ffff88805a3c1ce0 (k-sk_lock-AF_INET6){+.+.}-{0:0},
at: rds_tcp_tune+0xd7/0x930

The issue occurs because sk_net_refcnt_upgrade() performs memory
allocation (via get_net_track() -> ref_tracker_alloc()) while the
socket lock is held, creating a circular dependency with fs_reclaim.

Fix this by moving sk_net_refcnt_upgrade() outside the socket lock
critical section. This is safe because the fields modified by the
sk_net_refcnt_upgrade() call (sk_net_refcnt, ns_tracker) are not
accessed by any concurrent code path at this point.

v2:
  - Corrected fixes tag
  - check patch line wrap nits
  - ai commentary nits

Reported-by: syzbot+2e2cf5331207053b8106@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=2e2cf5331207053b8106
Fixes: 3a58f13a881e ("net: rds: acquire refcount on TCP sockets")
Signed-off-by: Allison Henderson <achender@kernel.org>
Link: https://patch.msgid.link/20260227202336.167757-1-achender@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/tcp.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/rds/tcp.c b/net/rds/tcp.c
index 020baff6ad514..5b4af800dcdc5 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -569,19 +569,25 @@ bool rds_tcp_tune(struct socket *sock)
 	struct rds_tcp_net *rtn;
 
 	tcp_sock_set_nodelay(sock->sk);
-	lock_sock(sk);
 	/* TCP timer functions might access net namespace even after
 	 * a process which created this net namespace terminated.
 	 */
 	if (!sk->sk_net_refcnt) {
-		if (!maybe_get_net(net)) {
-			release_sock(sk);
+		if (!maybe_get_net(net))
 			return false;
-		}
+		/*
+		 * The sk_net_refcnt upgrade must be done before lock_sock()
+		 * because netns_tracker_alloc() does a GFP_KERNEL allocation,
+		 * which can trigger fs_reclaim and create a circular lock
+		 * dependency with the socket lock.  The fields it modifies
+		 * (sk_net_refcnt, ns_tracker) are not accessed by any
+		 * concurrent code path at this point.
+		 */
 		sk->sk_net_refcnt = 1;
 		netns_tracker_alloc(net, &sk->ns_tracker, GFP_KERNEL);
 		sock_inuse_add(net, 1);
 	}
+	lock_sock(sk);
 	rtn = net_generic(net, rds_tcp_netid);
 	if (rtn->sndbuf_size > 0) {
 		sk->sk_sndbuf = rtn->sndbuf_size;
-- 
2.53.0



