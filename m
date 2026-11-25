Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618263;
	b=JxoO3PLrfJvkB4qUloMUAMO6crffswiTlJot+TuYURekfp7uiUcg3OmoA5nGgtWLj6FB
	 dBIO1R9t7qoFBSzK80Y75+oz4DMPE7N5irCvxqclZYA/SWOF3IjBD5xpcPOwZ4dr0Zkzm
	 lm6JlXfObV1cryBAGhIiDrNSTg581+Jjg7crQu+rPi77kcDfZG3ACBof5v+T6nefICPvi
	 uBaglHXWmAx7YZ20J2LgV4n9Z4eqH3rJjdAl8usdQ8JXes7itIZ+t5MeHgpq7Sn70zed5
	 2XgQ4NumuAkANxnuYJ7AuUkK82fS2/0Z56HDh3esb4y9F6yLNPxpiQ1WDTd1cMrJDXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618263;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=43JsQeQFvjlLGe6eMNAim+8Yv/yp9/s2Ny1IlIy4kRk=;
	b=WKw6TdPDyVBvtlb3x2YVIJr2ASOYRV/G++YSjmsvgAyEHpfjTMGtX+90kPGuneHC14zi
	 lXTVzDWgVSL72veFGf2B8NaRXWpqumyLMUPAJUFRBA2DwOg0ZZrWk0GJc7iQGx/c+Q5aw
	 VsukqjGsWNLeDCcqqIwTDLLaus3hc92/hSodG6ZVvjm5f2Zj7ODsUkqdvwkTYl8xTXMIJ
	 mNHX7pVO0SS4xhaQoMc9uQkSNC0qQCqCGXzOCjSZZQoJQv+Ivx3rJBbzUmtNp/vyDg+1U
	 BL5cLQuisl5H0LbxsXZ2v4JugYPr7q1PsfP1dttkX2W86/gVawWGzmTdw0UTb5vep/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PNb6WkIP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B940606A321;
	Wed, 25 Nov 2026 14:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PNb6WkIP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AC171F000CF;
	Wed, 25 Nov 2026 14:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618263;
	bh=43JsQeQFvjlLGe6eMNAim+8Yv/yp9/s2Ny1IlIy4kRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PNb6WkIP2TiDZ8D8aLm99IPgv1N8u7wgu0gJYE6wp1xG2uYH6qGxb3qfPliURtD8h
	 IMKye/O1f9a0jz6/PPaKi2VUbm81WzqUnaJ5N7N9LVAgNMJadZFUB4aCLy4s8gqzZU
	 GRUMmhi9F+hbh/VWNckynhXzvFgGpqsb8h3JrI+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0225/1005] soreuseport: annotate data-races around reuse->socks[] and num_socks
Date: Wed, 25 Nov 2026 15:26:03 +0100
Message-ID: <20261125143827.012039261@linuxfoundation.org>
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
index 29948cb44b7d1..fccbdd0430b05 100644
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



