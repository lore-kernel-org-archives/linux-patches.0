Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704436;
	b=Kq5NQN7h2AZwMRzj77EMP2xdkf/iZQKh3/M7KqjBb/l6WsHvNkvdlaX12m3SyqG+p+7q
	 dH4cvhn5n9zOHcgrf5WsRNUo+0GqUWr+NzW7jVX9D7AbsN7w9oGm/8Cao2JNcnLLaYs3w
	 3N5Y2VvM0bEZoPg7ZcohMP9M3boqBLkSFcfmTP0I6RKXnpKdUEH1qfynaGZ1r6Cb7nJ42
	 T6qzDsrvG0I/bZPPVtHL/0PNHrQcZQ0z4O0BFX1X4AG2p3MLVL1yQgnuKJoTDDDgc+5wV
	 9HR2EK2hgL76j3HAG3UzdFJ/hQnyKVkztr17vxZ4syxgWCdKrghqotWp2ERSptCsi8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704436;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C868S1iW/8DgJ+0jRuVmsz3Qy4+n/DCIdVXHqgB8vtk=;
	b=uDjVsVWkVYD92918A18hIVxZSxx5X/3u70l2peICh+JJwBvV0sSV7xBkic0HgtN7s7GZ
	 YOoRwEVeIG2bqsIByFhqu/mKvNgVUVl+UUwF++poBXpfehEGq3eot3BmHPRYe+rAw/qI1
	 jrhBwo8x1rBdlvFRyj+6nVKhhBXUh+Vu7U7fjf5LfNvRx+jAI6BMZF7OFcPUqpfp1qX68
	 bakiGIFmAF75MubNmcbiLF/IDeDlc9R+67dvLASOpFlE8uI8CN5ef92yLIMEaVbIgrKQF
	 CkV0oWQlZB175Jv9pDuAU3xK6H+B3JqaQeGIya1+mH53WE33/6qBf0Fa9k+QmwFSLew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C6ohzqjY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A572A606A31C;
	Thu, 26 Nov 2026 14:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C6ohzqjY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 134821F000C4;
	Thu, 26 Nov 2026 14:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704436;
	bh=C868S1iW/8DgJ+0jRuVmsz3Qy4+n/DCIdVXHqgB8vtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C6ohzqjYSX13BvmjLvbJ+xD9NO4jag2XzOU/vrgCUDeJo/AeuqFyJhJjhLXOtYsjK
	 DmwfgdAHl8+6VrX3CxHcU1keGr31ipwfXmcNITDxvEgTzDKDaXWN1H2zTD21cRd09J
	 RUN9q/he+gylAU5oKNDrCzgB2BcT5YrmNkz2+w6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 124/265] net: require a full socket in sock_confirm_neigh()
Date: Thu, 26 Nov 2026 15:37:34 +0100
Message-ID: <20261126143613.698045233@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 0598dcd65f2ca..3c58b28570c41 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2125,6 +2125,14 @@ struct dst_entry *__sk_dst_check(struct sock *sk, u32 cookie);
 
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
@@ -2136,7 +2144,8 @@ static inline void sock_confirm_neigh(struct sk_buff *skb, struct neighbour *n)
 	if (skb_get_dst_pending_confirm(skb)) {
 		struct sock *sk = skb->sk;
 
-		if (sk && READ_ONCE(sk->sk_dst_pending_confirm))
+		if (sk && sk_fullsock(sk) &&
+		    READ_ONCE(sk->sk_dst_pending_confirm))
 			WRITE_ONCE(sk->sk_dst_pending_confirm, 0);
 		neigh_confirm(n);
 	}
@@ -2710,14 +2719,6 @@ skb_sk_is_prefetched(struct sk_buff *skb)
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



