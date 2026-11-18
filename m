Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018785;
	b=0N0YtOyA7Y9FOKr86uIhXBkK1NC/g8NjLoNSA/W2MlgtrE/vSkhgpnRuF5GEEOlcwcgP
	 blwEDveJ1zVnpm130dTnX9KwOeVbyRPLwdEd0uczw5BHZtkcAkMQynxTErbknOehBl5cj
	 OCkDAovnZ/NXhyJabTL3mTeNZ0G4lBdOsfGr/p/DcShs8P4zRfX4o4k7Uv+bxc/ANGpel
	 ZyTjW5H34Nq5wo2NU6o2VmlQS6FrmcWXAYvniXv4SjZRKVYGrgCdMx+QpLlIcOROLP944
	 2x36u9Svits6Y2GA5dqtajEYv3sDQVjIwgJjU0lhooOJINp7JBu0dQw8P1hNa/WwoKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018785;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=piPkga23M1YWSY20plXcHKafZtq35x6DUNn+hpTIWaM=;
	b=VnK4gerSARj0qs5+8G3pYCT2k+gS5qdeKcwkPZF/1uTnNrsZG4UQh04C5l9IBZ+dXauW
	 6KEh/7HcP6YbYiwUS/QpnfYc++by+ZZmCoV3f8fQmZHgkbAEh7/hvUgt1iEBaVAu8UToE
	 0prKVe7FAuuT25BVUAp9/jpE9NonJgFHgusjL30OfjIOlHS8mY5TJAqxEaj0wG7XmQceM
	 nkDaEp4E+LIfRDmzAiHSz7CXcMoZFEsffvRYEjzF7lzOLJyJzWmthg5+el/sLj9GdPFx4
	 ppsSfCnQ+yR3ttmR4axYngMlG0ai2dRD+pc6cZ4CI0BEgNFBIjCKBXlbDJvuZ9Vh0wQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jCfyIrwx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F1C606A339;
	Wed, 18 Nov 2026 16:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jCfyIrwx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BF7B1F000C4;
	Wed, 18 Nov 2026 16:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018784;
	bh=piPkga23M1YWSY20plXcHKafZtq35x6DUNn+hpTIWaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jCfyIrwxvtBFFcLkoOKXODgc/5y2gDg9JxB4xSnWdqwsWwS9FH+55GtlfnSJ1IfYM
	 ri+czkbVexR8UxRIENB9jFvB6XwskQiVHxkZLmbyyvHl8qCu7XbkFwQv2vx954zyW6
	 2p3I5Agfkks1jORQDQ93lL2/vjmKZUXdKQxdxSNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Zahka <daniel.zahka@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1364/2651] net: psp: require an established connection for association setup
Date: Wed, 18 Nov 2026 15:43:24 +0100
Message-ID: <20261118150337.134358352@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Daniel Zahka <daniel.zahka@gmail.com>

[ Upstream commit 86a19284425fb0c420e1702f8d0de891279df6b7 ]

Check sk_state under the socket lock in both the rx-assoc and tx-assoc
handlers, and only allow association setup on sockets in
TCP_ESTABLISHED. Also, fail connect() when PSP assoc state is already
present, and remove the dead PSP MSS adjustment from
tcp_v[46]_connect().

The net effect of this commit is:
1. PSP assoc state can never exist on a listen socket.
2. The upgrade to PSP must be done while the socket is in
   TCP_ESTABLISHED.

This change defeatures behavior that was previously allowed under the
PSP uapi. My justification is:

Nothing useful can be done after association setup on closed or listen
sockets today. Listen sockets could accept a PSP-encrypted TCP SYN, but
the child socket will not inherit any PSP state. On the other side,
establishing PSP state prior to connect() will result in a PSP-encrypted
TCP SYN sent to a listening peer, which in turn has the aforementioned
limitations. That implies that there cannot be any users of this
feature, so it should be safe to remove it from the PSP uapi.

In theory, the check in the tx-assoc path is more restrictive than
necessary. FIN_WAIT1/2, CLOSING, LAST_ACK and CLOSE_WAIT could be
allowed, and the peer would accept PSP-encrypted ACKs in the
post-FIN-sent states, or data in the half-close case, but it is simpler
to disallow those states because they don't fit the upgrade model.

The check in the tx-assoc path fixes a bug in commit 6b46ca260e22 ("net:
psp: add socket security association code") where an unsynchronized
write can be performed on an assoc shared with a timewait socket when
the socket is in TCP_CLOSE after shutdown. This commit is not targeted
at net because its premise of preventing listen sockets from holding
assoc state depends on net-next commit 8cc3aef0cb19 ("tcp: Do not allow
buggy transitions between ehash and lhash2.")

Signed-off-by: Daniel Zahka <daniel.zahka@gmail.com>
Fixes: 6b46ca260e22 ("net: psp: add socket security association code")
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260930-psp-defeat-v2-2-f266e7447129@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/networking/psp.rst |  8 ++++++++
 net/ipv4/tcp_ipv4.c              |  7 +++++--
 net/ipv6/tcp_ipv6.c              |  9 ++++++---
 net/psp/psp_sock.c               | 12 ++++++++++++
 4 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/Documentation/networking/psp.rst b/Documentation/networking/psp.rst
index 4ac09e64e95a5..0f9b6b73f2447 100644
--- a/Documentation/networking/psp.rst
+++ b/Documentation/networking/psp.rst
@@ -132,6 +132,14 @@ numbers in a way that deletes a prefix of the PSP protected part of
 the TCP stream. If userspace cares to mitigate this type of attack, a
 special "start of PSP" message should be exchanged after ``tx-assoc``.
 
+Upgrade to PSP must be done on established TCP connections.
+``rx-assoc`` and ``tx-assoc`` will return ``-ENOTCONN`` if
+``sk_state`` is not ``TCP_ESTABLISHED``.
+
+The PSP assoc state of a socket is not reset when the connection is
+torn down. ``connect()`` on a socket that has PSP assoc state will
+return ``-EINVAL``.
+
 Rotation notifications
 ----------------------
 
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index bebc5a8d1ab69..a38cafcc553b6 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -238,6 +238,9 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr_unsized *uaddr, int addr_len
 	if (usin->sin_family != AF_INET)
 		return -EAFNOSUPPORT;
 
+	if (psp_sk_assoc(sk))
+		return -EINVAL;
+
 	nexthop = daddr = usin->sin_addr.s_addr;
 	inet_opt = rcu_dereference_protected(inet->inet_opt,
 					     lockdep_sock_is_held(sk));
@@ -291,9 +294,9 @@ int tcp_v4_connect(struct sock *sk, struct sockaddr_unsized *uaddr, int addr_len
 	inet->inet_dport = usin->sin_port;
 	sk_daddr_set(sk, daddr);
 
-	inet_csk(sk)->icsk_ext_hdr_len = psp_sk_overhead(sk);
+	inet_csk(sk)->icsk_ext_hdr_len = 0;
 	if (inet_opt)
-		inet_csk(sk)->icsk_ext_hdr_len += inet_opt->opt.optlen;
+		inet_csk(sk)->icsk_ext_hdr_len = inet_opt->opt.optlen;
 
 	tp->rx_opt.mss_clamp = TCP_MSS_DEFAULT;
 
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 7fa4ed2fd4f16..be50b2fe12742 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -153,6 +153,9 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr_unsized *uaddr,
 	if (usin->sin6_family != AF_INET6)
 		return -EAFNOSUPPORT;
 
+	if (psp_sk_assoc(sk))
+		return -EINVAL;
+
 	fl6 = &inet_sk(sk)->cork.fl.u.ip6;
 	memset(fl6, 0, sizeof(*fl6));
 
@@ -311,10 +314,10 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr_unsized *uaddr,
 	sk->sk_gso_type = SKB_GSO_TCPV6;
 	ip6_dst_store(sk, dst, false, false);
 
-	icsk->icsk_ext_hdr_len = psp_sk_overhead(sk);
+	icsk->icsk_ext_hdr_len = 0;
 	if (opt)
-		icsk->icsk_ext_hdr_len += opt->opt_flen +
-					  opt->opt_nflen;
+		icsk->icsk_ext_hdr_len = opt->opt_flen +
+					 opt->opt_nflen;
 
 	tp->rx_opt.mss_clamp = IPV6_MIN_MTU - sizeof(struct tcphdr) - sizeof(struct ipv6hdr);
 
diff --git a/net/psp/psp_sock.c b/net/psp/psp_sock.c
index e9b53eedf8dba..70fa137bd8116 100644
--- a/net/psp/psp_sock.c
+++ b/net/psp/psp_sock.c
@@ -139,6 +139,12 @@ int psp_sock_assoc_set_rx(struct sock *sk, struct psp_assoc *pas,
 
 	lock_sock(sk);
 
+	if (sk->sk_state != TCP_ESTABLISHED) {
+		NL_SET_ERR_MSG(extack, "Socket must be in established state");
+		err = -ENOTCONN;
+		goto exit_unlock;
+	}
+
 	if (psp_sk_assoc(sk)) {
 		NL_SET_ERR_MSG(extack, "Socket already has PSP state");
 		err = -EBUSY;
@@ -188,6 +194,12 @@ int psp_sock_assoc_set_tx(struct sock *sk, struct psp_dev *psd,
 
 	lock_sock(sk);
 
+	if (sk->sk_state != TCP_ESTABLISHED) {
+		NL_SET_ERR_MSG(extack, "Socket must be in established state");
+		err = -ENOTCONN;
+		goto exit_unlock;
+	}
+
 	pas = psp_sk_assoc(sk);
 	if (!pas) {
 		NL_SET_ERR_MSG(extack, "Socket has no Rx key");
-- 
2.53.0



