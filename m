Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619151;
	b=3zpPJ5M2rSx3ddNNx5okWhkRcrGnyF0+FQ0zQ63KCnK/NaC2Q02F177XCL1riZxKFvsC
	 AbFwqKifTD9xlumbb1d3TskLQwyFyViiaWAPtS4kxcsavV6l3E7rAUwWYFjl3e9cvHG4H
	 LOUkJDQ2eSGMZj6khR1CAt+epHxUV60Xvh5L/lnvjZsbJJYE28PIccscIm7Fn4UFAWrFl
	 rzW4OPon8mc5z+XlVO1iuld/AEntVfotRWfnK1HRM29Yt8rlSfVamQxCdr7VQZocanH/I
	 S+NpS0J6FpOq5WWdCdknsp6jP0oeSEi6zQt0JA1Hid7Ewdzqfx1a7tlmqv7R+TQneDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619151;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YxV6WgPxkOgKbYES3gHQTbiTJlbqLUh3+dmb35u/iks=;
	b=pk+wXFNDE9FKKd+EEWj3VzhuTEhFVK0e/3YPOKKdOXuOyFbSScfIbYZ/KZW1LxsMf7VB
	 5qsQa8RWQf9oSLgxEZjjA5KdCYD2gd7jNTagRcc91c4f41PtvprcBFVLgXAUXi5e2Jwjz
	 hVciJRuo3/XOTK0tPRRmT6h3uX75YUiS/C6UoLs9B9BDsbRtxt8Fbjc1cXjR0Evkd55Qb
	 E/vc03YjVWj+Ly7KolUYap045c76X8hE8pVTuLd0xl/HWnaddPJvHG2V1fxLQmJSDOmvB
	 kNVtOHQy/1ChIAL+uKHw/m1Om9JTwZuBztxyZbhVbOU/t0DVXQXetuMXAFquH9Uhk2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2uInSMvB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A209606A31E;
	Wed, 25 Nov 2026 15:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2uInSMvB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F12C1F000C4;
	Wed, 25 Nov 2026 15:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619151;
	bh=YxV6WgPxkOgKbYES3gHQTbiTJlbqLUh3+dmb35u/iks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2uInSMvBXm8Wyl2CvGrMQ3DsK2hLTpjar9Ymy9PN94KjRFBMU41mlaVdyGzUr5gtE
	 kI4LR1kZ/OSdecV6WBdj8FgJ5eTabehyISeYPvzpfW07hkrz4+UXxDOU+nST/UaQfq
	 AJK9yOnUtW8IdAYDWrZ5HyxR4VHhqeTjWJ1/WOus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0462/1005] net: require a full socket in sock_confirm_neigh()
Date: Wed, 25 Nov 2026 15:30:00 +0100
Message-ID: <20261125143832.568319480@linuxfoundation.org>
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
index f8038be27f003..145770c9394dd 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2283,6 +2283,14 @@ struct dst_entry *__sk_dst_check(struct sock *sk, u32 cookie);
 
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
@@ -2294,7 +2302,8 @@ static inline void sock_confirm_neigh(struct sk_buff *skb, struct neighbour *n)
 	if (skb_get_dst_pending_confirm(skb)) {
 		struct sock *sk = skb->sk;
 
-		if (sk && READ_ONCE(sk->sk_dst_pending_confirm))
+		if (sk && sk_fullsock(sk) &&
+		    READ_ONCE(sk->sk_dst_pending_confirm))
 			WRITE_ONCE(sk->sk_dst_pending_confirm, 0);
 		neigh_confirm(n);
 	}
@@ -3027,14 +3036,6 @@ skb_sk_is_prefetched(struct sk_buff *skb)
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



