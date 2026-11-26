Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705074;
	b=kwmk3ijPprGx3toRWUh6dutwZmN4KY4xoTVJR3PAkQWuyID2lXEWVd68XpE1b96YFZGZ
	 ho02UmiBBkl2wL4O3QJ3u/VeVQMQUYvRhUXhNYXdxSAZSF7RJVgXI3mDXzFOi8OMPz9v2
	 8S8ea6PfljKEshrfIdyN3iwmvWXRD6uNQGw3HJHBK4tVrwfAsepQidl+n/rU3iKCHbNu5
	 XZ4ow4tvnBdD22DHyRxAtnRQ61Hb9o73guchzFrFG5p1cFu4PZJDP2JeJfxb20rYHa+PQ
	 e6NZhOpMgZdskqO5bZOoUQGovseoYrBemJ5oa8skltbn3Zsdfbi7M1KnLDWV1b8HUGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705074;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oulr2+mE5fgcIiEjFZ/MqhC6wi8apxMp+l1sQrL/wyE=;
	b=G01WEEmH8+MhHdU+n9cD/19b1FCoVTvWlGYHfbV5GWNwjTZmxPhsQqDEcGb2sWKN+rJ0
	 Ev1uHdlkiPcu7zf8CgwovXSvZiNTOIoiRfRi/4zZKV5e6mxHn/S3h7RUp94el36rymfPx
	 GqHQJJLlWCGcao0pB7ZAPpIrSGdN3nnujjVzttFk4VkhlzXQp6K0Tkzh2BII7L8F0qzqt
	 h5ACyRWjSbzPgHzxuKDQmkaNc3bEkxDeL35mFwkay9pVvjyIKooBmO2j2pmqi6PKaSe3w
	 3FTHdDF5y4G4TebtV5ee1onbPldgw3iJLuxEwwSMXlsIbwbQKYES29j/ayrB7oMNkJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="KnzXn/6k";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C40DC60A381A;
	Thu, 26 Nov 2026 14:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KnzXn/6k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C00061F00A19;
	Thu, 26 Nov 2026 14:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705074;
	bh=oulr2+mE5fgcIiEjFZ/MqhC6wi8apxMp+l1sQrL/wyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KnzXn/6k2Yzz0x9IoVuvdNHzfiZur1BWHWbCkBAME4K6iw3M5p9yDU7VTinitPEjW
	 vV+OJrSfOKomFid4uoxc75x8GotnXyH35eW/m/XmmhklLH0OjnFWCTl9DX1S5jEvB+
	 6np8OsUVb/17+410x475Q1nU7lslnSpwt4ZwlzHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 072/319] soreuseport: annotate data-races around reuse->socks[] and num_socks
Date: Thu, 26 Nov 2026 15:37:20 +0100
Message-ID: <20261126144008.364365144@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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
index 5a165286e4d8e..e7685956b09d7 100644
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
@@ -522,7 +523,7 @@ static struct sock *run_bpf_filter(struct sock_reuseport *reuse, u16 socks,
 	if (index >= socks)
 		return NULL;
 
-	return reuse->socks[index];
+	return READ_ONCE(reuse->socks[index]);
 }
 
 static struct sock *reuseport_select_sock_by_hash(struct sock_reuseport *reuse,
@@ -533,7 +534,7 @@ static struct sock *reuseport_select_sock_by_hash(struct sock_reuseport *reuse,
 
 	i = j = reciprocal_scale(hash, num_socks);
 	do {
-		struct sock *sk = reuse->socks[i];
+		struct sock *sk = READ_ONCE(reuse->socks[i]);
 
 		if (sk->sk_state != TCP_ESTABLISHED) {
 			/* Paired with WRITE_ONCE() in __reuseport_(get|put)_incoming_cpu(). */
-- 
2.53.0



