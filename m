Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621350;
	b=4/Thdg0u1xIaLqo0JxP2jTm69tV2yyzwlSui5TLj7v7tQa+nRBmqT+GflOAb7Cv2XXn2
	 jEICugKoF8cU3FNlV3V926+3Zf3+wHkXvhS2Rc7wAyzg8mia6hHgraTpDq1I3SZCGj/++
	 Kt8w+GjOPGN0oZd8JNZd4VT9FI/kT/3335uC0ccYVJEBjbroBLlROPnfs/WHgXgEjEubA
	 OfWD6kNDaxjVUN3hduwCkDlAeKLAW58sfpuOzRzkopAvacPtGSOqj1gHLwvdBT8UGK2M/
	 N8huYa3GsXfJxNec7kDVGy74RcIllbb9qCtyqpBRDGvotzCgdbdaQJg1szCs9cStdug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621350;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y3ERGgpbE/6FSKVfN4LsRWtA3TrCLmLb8IjqC9069y8=;
	b=Ryu9Rq1yxy4wx89vTGYRi1D2+ua/D91sxEy/lCXDZutFe0SuDtKbODBEbc3rvgijsjZh
	 q5LTtRtFZzQ1vAWAcDX2yWLB6JKpuyWZLT23FG15HxX3RMjvunffAWSVvWDZRZ9/gG1sx
	 g4HQVzK6Ub8bsKLDPQq7qSRfjE/VlbCsfUWGvQzT5vpwcrnC3OqAxRuyL2EP3uuFs+jEg
	 e/cbmMuNfPpnOIguzdkC1tSLKWXg7bIRLHtKlyQQaWx6Qx/JiNyKiVhkI+fiVFuD7ZIl0
	 50M5WZeTaQbvQxFaTvwVvWR87rfxxdHCbrn4V60m+E+R7Ydb9sS1kbCOtCAgGmB73yw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PHBNyQI7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0337E606A69A;
	Wed, 25 Nov 2026 15:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PHBNyQI7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E75AA1F000CA;
	Wed, 25 Nov 2026 15:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621349;
	bh=Y3ERGgpbE/6FSKVfN4LsRWtA3TrCLmLb8IjqC9069y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PHBNyQI7hlMXY2Iv55OEqvj5tGRXMJPyzzUMiZLTun8EEo9Qi67vXHXf2o8p0EtiL
	 ZopDm3tD6FBGvdisjVJlzoZ9Xz7TKkDUL8KXc1yo/mrpg7HvYh3ekOFXssD5eThv3j
	 Ae+iLUaaM7ML0b6bvSmePADXbUGDZl02IFM35R4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 197/990] soreuseport: annotate data-races around reuse->socks[] and num_socks
Date: Wed, 25 Nov 2026 15:26:04 +0100
Message-ID: <20261125143826.709655643@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit 213d491308b99d026514c93980cf8dd572226b1b ]

reuseport_select_sock() and reuseport_migrate_sock() read
reuse->num_socks and reuse->socks[] locklessly under RCU, while
writers holding reuseport_lock can change them.

Readers snapshot num_socks once, then index socks[] with it.
Meanwhile, writers can perform several operations, storing into
slots below the reader's stale count:

- __reuseport_detach_sock() moves the last socket into slot i.
- __reuseport_add_sock() then writes the new socket at the
  (now smaller) num_socks index.
- reuseport_stop_listen_sock() calls __reuseport_detach_sock()
  then __reuseport_add_closed_sock(), which writes slot
  max_socks - num_closed_socks - 1. This can be the slot a reader
  still considers part of the listener region when the array is full.
- __reuseport_detach_closed_sock() can then rewrite that slot.

All pointers stored in socks[] remain valid for the RCU grace period,
but without annotations the compiler is allowed to tear or reload
these accesses. For instance, reuseport_select_sock_by_hash() could
reload reuse->socks[i] between the sk_state/sk_incoming_cpu checks
and the return, returning a socket that did not pass them.

Use WRITE_ONCE() for all socks[] stores done while the array is
visible to readers, and for num_socks updates (readers already use
READ_ONCE()). Use READ_ONCE() in the two lockless readers.

Fixes: ef456144da8e ("soreuseport: define reuseport groups")
Link: https://lore.kernel.org/netdev/20260902071900.395567-1-ruanjinjie@huawei.com/
Cc: Kuniyuki Iwashima <kuniyu@google.com>
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Link: https://patch.msgid.link/20261030120956.3026324-1-edumazet@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock_reuseport.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
index 4211710393a8a..d4b7caf86eee3 100644
--- a/net/core/sock_reuseport.c
+++ b/net/core/sock_reuseport.c
@@ -124,10 +124,10 @@ static int reuseport_sock_index(struct sock *sk,
 static void __reuseport_add_sock(struct sock *sk,
 				 struct sock_reuseport *reuse)
 {
-	reuse->socks[reuse->num_socks] = sk;
+	WRITE_ONCE(reuse->socks[reuse->num_socks], sk);
 	/* paired with smp_rmb() in reuseport_(select|migrate)_sock() */
 	smp_wmb();
-	reuse->num_socks++;
+	WRITE_ONCE(reuse->num_socks, reuse->num_socks + 1);
 	reuseport_get_incoming_cpu(sk, reuse);
 }
 
@@ -139,8 +139,8 @@ static bool __reuseport_detach_sock(struct sock *sk,
 	if (i == -1)
 		return false;
 
-	reuse->socks[i] = reuse->socks[reuse->num_socks - 1];
-	reuse->num_socks--;
+	WRITE_ONCE(reuse->socks[i], reuse->socks[reuse->num_socks - 1]);
+	WRITE_ONCE(reuse->num_socks, reuse->num_socks - 1);
 	reuseport_put_incoming_cpu(sk, reuse);
 
 	return true;
@@ -149,7 +149,7 @@ static bool __reuseport_detach_sock(struct sock *sk,
 static void __reuseport_add_closed_sock(struct sock *sk,
 					struct sock_reuseport *reuse)
 {
-	reuse->socks[reuse->max_socks - reuse->num_closed_socks - 1] = sk;
+	WRITE_ONCE(reuse->socks[reuse->max_socks - reuse->num_closed_socks - 1], sk);
 	/* paired with READ_ONCE() in inet_csk_bind_conflict() */
 	WRITE_ONCE(reuse->num_closed_socks, reuse->num_closed_socks + 1);
 	reuseport_get_incoming_cpu(sk, reuse);
@@ -163,7 +163,8 @@ static bool __reuseport_detach_closed_sock(struct sock *sk,
 	if (i == -1)
 		return false;
 
-	reuse->socks[i] = reuse->socks[reuse->max_socks - reuse->num_closed_socks];
+	WRITE_ONCE(reuse->socks[i],
+		   reuse->socks[reuse->max_socks - reuse->num_closed_socks]);
 	/* paired with READ_ONCE() in inet_csk_bind_conflict() */
 	WRITE_ONCE(reuse->num_closed_socks, reuse->num_closed_socks - 1);
 	reuseport_put_incoming_cpu(sk, reuse);
@@ -521,7 +522,7 @@ static struct sock *run_bpf_filter(struct sock_reuseport *reuse, u16 socks,
 	if (index >= socks)
 		return NULL;
 
-	return reuse->socks[index];
+	return READ_ONCE(reuse->socks[index]);
 }
 
 static struct sock *reuseport_select_sock_by_hash(struct sock_reuseport *reuse,
@@ -532,7 +533,7 @@ static struct sock *reuseport_select_sock_by_hash(struct sock_reuseport *reuse,
 
 	i = j = reciprocal_scale(hash, num_socks);
 	do {
-		struct sock *sk = reuse->socks[i];
+		struct sock *sk = READ_ONCE(reuse->socks[i]);
 
 		if (sk->sk_state != TCP_ESTABLISHED) {
 			/* Paired with WRITE_ONCE() in __reuseport_(get|put)_incoming_cpu(). */
-- 
2.53.0



