Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622154;
	b=KPIK5ex+esO+MsiVTIN6GYR6vm3jOdTTx7mInKt4eSP2FHh/RNuk60ykBT5RicoOFjjo
	 v9aAsC2pMcFYHFcLq+L4U3ArCqgYlU41XBcljYJE31JeGkYplu59PoSsRUJUB8AGiVn7c
	 78/xC4lb4see6rEOogDUVdQbSFmwsDy2AwcoMbEKradv0CgSScacQFHjLZ7K2WSpNirEJ
	 tnU5GKchymNGWOv4STLR8NPqNHRRBQ2HL65wujplDl6wZp6zNYAga7RFATwbZrimz0CA8
	 /vXUjSaZzQSHunmHqxxw+pTnH0AKL11hVu6hsITnmKiBX01ra1SWuE3m0HfymMPCSyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622154;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BJIpJxO5Cgk9CTMmFrPczHsNLoN437HM+k9pTPm+lPs=;
	b=i6u0Xa7ZvCj3RyLgWwpHU9/t6korwJ6RwCASUHGvqzsyYbxMt1Il4z/9w/0iOXfrzc+D
	 J6gWsbOQmQn1iBjMl8X1L476pbdynHJ7Nms6ARzW+lx23YEhtUdgZ3uVFPiytL99V0OnV
	 XGHzW5e+Was0xe2d+R0Nj8V0SU3DoW+z4hOukQQtYnPRmOKjqdbvHyy+CxyGbcghAeViM
	 +t33ikzOL9aTrD5qsJLcPsZVYMM0F1DdGgL/NdDNjtpPmLHiiDKPkh52p7rAZNYR8SeSp
	 YM9WMq+E4jXDsdN95pxWp/IF66YFxLLD2KmO6aS278Tk7MAsHyS0y2ZSJOuebHD0NPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CBtrNWCy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C5C606A337;
	Wed, 25 Nov 2026 15:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CBtrNWCy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E6861F000E1;
	Wed, 25 Nov 2026 15:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622153;
	bh=BJIpJxO5Cgk9CTMmFrPczHsNLoN437HM+k9pTPm+lPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CBtrNWCyjfAIqV5fth+0ussb94YTlkhge4Ajvdkr79s9X7GkftHHjXZ4POKzJeADh
	 ZYqqHGS0tyur3k/1pm4D8kFrSwu6nSkJmAUeQ9dqLBeVEo1TS4mMbG+bp/OfRcUVpM
	 mT4ZZ6tKYfsqwFHTnlozg9Zcs6cLq/l9CVq/tEg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Michal Luczaj <mhal@rbox.co>,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 439/990] tcp: Do not allow buggy transitions between ehash and lhash2.
Date: Wed, 25 Nov 2026 15:30:06 +0100
Message-ID: <20261125143832.377195919@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 8cc3aef0cb198049805ecc061a2cc7b79b0ae43e ]

The following state transitions have long been a playground for
syzbot, and recently AI joined in, reporting a lot more bugs.

  * listen() + shutdown() + connect()
  * connect() + connect(AF_UNSPEC) + listen()

All the fix attempts would add more code to the fast path, which
is not worth it.

Instead of playing whack-a-mole with these edge-case bugs,
let's disallow these transitions.

Note that unhashed_state is placed in the 4-byte hole after
icsk_pmtu_cookie.

  $ pahole -C inet_connection_sock vmlinux
  struct inet_connection_sock {
  ...
	__u32                      icsk_pmtu_cookie;     /*  1208     4 */
	unsigned char              unhashed_state;       /*  1212     1 */

	/* XXX 3 bytes hole, try to pack */

Reported-by: Kyle Zeng <kylebot@openai.com>
Closes: https://lore.kernel.org/netdev/20260731140512.566464-1-david.lee@trailofbits.com/
Reported-by: Michal Luczaj <mhal@rbox.co>
Closes: https://lore.kernel.org/netdev/20260803-sockmap-lookup-tcp-leak-v2-0-306e025bfe66@rbox.co/
Reported-by: Hyunwoo Kim <imv4bel@gmail.com>
Closes: https://lore.kernel.org/netdev/20260824033331.1084971-1-imv4bel@gmail.com/
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260904033543.2635540-2-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 8c011697f76a ("tcp: do not resurrect a former listener with SO_ATTACH_REUSEPORT_[CE]BPF")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/inet_connection_sock.h |  1 +
 net/ipv4/inet_connection_sock.c    |  1 +
 net/ipv4/inet_hashtables.c         | 11 +++++++++++
 3 files changed, 13 insertions(+)

diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index 39ccb785dd4c1..24e0b62143f59 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -95,6 +95,7 @@ struct inet_connection_sock {
 	u32			  icsk_rto_max;
 	__u32                     icsk_delack_max;
 	__u32			  icsk_pmtu_cookie;
+	unsigned char		  unhashed_state;
 	const struct tcp_congestion_ops *icsk_ca_ops;
 	const struct inet_connection_sock_af_ops *icsk_af_ops;
 	const struct tcp_ulp_ops  *icsk_ulp_ops;
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 2db9ceda0456a..58aff248278dd 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -1284,6 +1284,7 @@ struct sock *inet_csk_clone_lock(const struct sock *sk,
 	memset(&newicsk->icsk_accept_queue, 0,
 	       sizeof(newicsk->icsk_accept_queue));
 
+	newicsk->unhashed_state = 0;
 	inet_sk_set_state(newsk, TCP_SYN_RECV);
 
 	inet_clone_ulp(req, newsk, priority);
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index c0accacdc3eb1..030276cde581a 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -791,6 +791,11 @@ int inet_hash(struct sock *sk)
 		return 0;
 	}
 	WARN_ON(!sk_unhashed(sk));
+
+	if (unlikely(inet_csk(sk)->unhashed_state &&
+		     inet_csk(sk)->unhashed_state != TCP_LISTEN))
+		return -EINVAL;
+
 	ilb2 = inet_lhash2_bucket_sk(hashinfo, sk);
 
 	spin_lock(&ilb2->lock);
@@ -821,6 +826,9 @@ void inet_unhash(struct sock *sk)
 		return;
 
 	sock_rps_delete_flow(sk);
+
+	inet_csk(sk)->unhashed_state = sk->sk_state;
+
 	if (sk->sk_state == TCP_LISTEN) {
 		struct inet_listen_hashbucket *ilb2;
 
@@ -1050,6 +1058,9 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 	int step, l3mdev;
 	u32 index;
 
+	if (unlikely(inet_csk(sk)->unhashed_state == TCP_LISTEN))
+		return -EINVAL;
+
 	if (port) {
 		local_bh_disable();
 		ret = check_established(death_row, sk, port, NULL, false,
-- 
2.53.0



