Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622042;
	b=BaxoBEJ2ufoRmZUr6e6RL0ltvxUxnnQnfrNSHb9VA9sFSLRfEkwFOPIAXTrozVbIBR6F
	 cvY7m4X17j/Oukv+lzgCefYXcnqBWhGVkRIXZAHIsWnf5BJztxpu0iv5FIZH/AmZlCOWV
	 sKTE8ySXjsyyztLWXnxwsa9995lR3XYp0o5xEKLTJ6zLFNriT7vQ6Ou7BjRxSuOgamFoc
	 Wj/Ts4Q/LGL7ngyL0ngTtp3/bpRTC4Xfs71MbrwiUk1POXV2P9TPm7/gjHzOARQOvMGZv
	 Zi9wTgQeYvYYwxaegZ7SOt0uq2Wxf8RaK2/YmUls0KzR7suUgr7up1pmPWWGQk8WWKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622042;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vIhxbdbI72Whp3h9h7u7RTb65IbmEtyRvZ5KNH/hsZY=;
	b=dhFR+kd2mnRpj0+CRwpKxC+IbtPtRHF8HjCONXMDzPc4b9j+KDmwIkFCgKwdanNU9KNT
	 3VsGbffbovktMARKObluTPdJT/PPoU62Suj/kq1tZbmRPSgrOysaOuJ//l/Wl4a/bb9Ta
	 y5JJ/97ZRy+i+0eM7C8l1LWdoAsl2+FZptqlYlqo1BQGydwvJQoG5n98ckvglp2+NN+Yd
	 3mzORiy4t9vPWowKldEH6yqgBjRI7J5mqtmoLGcWgCc02/a47j06OSdDWfUJ0pvHTKwJn
	 CvIWrf56yKp8ifwnMmiErdnG2gc2FOzRivCpUOhgovBLs+DrO2c6/Um7vWEfN+6/CsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KLbqNu7h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC201606A321;
	Wed, 25 Nov 2026 15:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KLbqNu7h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1048B1F000C0;
	Wed, 25 Nov 2026 15:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622042;
	bh=vIhxbdbI72Whp3h9h7u7RTb65IbmEtyRvZ5KNH/hsZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KLbqNu7hCBb17SW2NSsxwqkJAfTOvFJPjS227TKfFKasZJU2yBkWfF+wFIgPl2Wqw
	 C2GmrQZRiVUD7BgLHvfygyleZ3+FZvQUCLHMGLFWFWXNkS9fa2gwppvD3XlDvrjFD5
	 6TK0yDKCpkFqkQPJ2fqZJzOVtY1aWpAZWIfGOSBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 413/990] net: require a full socket in sock_confirm_neigh()
Date: Wed, 25 Nov 2026 15:29:40 +0100
Message-ID: <20261125143831.773744337@linuxfoundation.org>
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

From: Kyle Zeng <kylebot@openai.com>

[ Upstream commit c78b47704934e44442f4e48bfdcc99039e3b85a5 ]

An skb can retain dst_pending_confirm after its original output and
socket owner have changed. For example, a raw MSG_CONFIRM packet can
cross veth, have a TCP request socket assigned by TPROXY, and be bridged
into gretap. Neighbor output for the outer packet then calls
sock_confirm_neigh() with the request socket in skb->sk.

The helper unconditionally treats a non-NULL skb->sk as a full socket
when accessing sk_dst_pending_confirm. TCP request and TIME_WAIT sockets
do not contain that field. This produces an out-of-bounds four-byte read
and, if the word is nonzero, an out-of-bounds four-byte zero write. A
KASAN-enabled kernel reports:

  BUG: KASAN: slab-out-of-bounds in ip_finish_output2+0xc9f/0xd60
  Read of size 4 at addr ffff8880bdc3d880 by task tproxy_dst_conf/1771

Require sk_fullsock() before accessing the socket field, moving the
existing helper earlier in the header to make it available here. Keep
neigh_confirm() independent of the socket type so the skb's neighbor
confirmation still works, including for socketless packets. This also
covers the IPv6, VRF, and BPF neighbor-output callers.

Fixes: 4ff0620354f2 ("net: add dst_pending_confirm flag to skbuff")
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20261104132900.1071940-1-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sock.h | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 49d4c25271bee..dd728a89c10f0 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2231,6 +2231,14 @@ struct dst_entry *__sk_dst_check(struct sock *sk, u32 cookie);
 
 struct dst_entry *sk_dst_check(struct sock *sk, u32 cookie);
 
+/* This helper checks if a socket is a full socket,
+ * ie _not_ a timewait or request socket.
+ */
+static inline bool sk_fullsock(const struct sock *sk)
+{
+	return (1 << sk->sk_state) & ~(TCPF_TIME_WAIT | TCPF_NEW_SYN_RECV);
+}
+
 static inline void sk_dst_confirm(struct sock *sk)
 {
 	if (!READ_ONCE(sk->sk_dst_pending_confirm))
@@ -2242,7 +2250,8 @@ static inline void sock_confirm_neigh(struct sk_buff *skb, struct neighbour *n)
 	if (skb_get_dst_pending_confirm(skb)) {
 		struct sock *sk = skb->sk;
 
-		if (sk && READ_ONCE(sk->sk_dst_pending_confirm))
+		if (sk && sk_fullsock(sk) &&
+		    READ_ONCE(sk->sk_dst_pending_confirm))
 			WRITE_ONCE(sk->sk_dst_pending_confirm, 0);
 		neigh_confirm(n);
 	}
@@ -2966,14 +2975,6 @@ skb_sk_is_prefetched(struct sk_buff *skb)
 #endif /* CONFIG_INET */
 }
 
-/* This helper checks if a socket is a full socket,
- * ie _not_ a timewait or request socket.
- */
-static inline bool sk_fullsock(const struct sock *sk)
-{
-	return (1 << sk->sk_state) & ~(TCPF_TIME_WAIT | TCPF_NEW_SYN_RECV);
-}
-
 static inline bool
 sk_is_refcounted(struct sock *sk)
 {
-- 
2.53.0



