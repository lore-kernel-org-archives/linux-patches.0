Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619188;
	b=sMs8OZuwj2Hn2JwWb/p9zMJMrkpM4yYlJN3Ak4rv/b454VHOf7QPeJRgi79PB/IzA4vX
	 gvOTF8YBngHRWStHaYwsV76QJfpfK/yGB/fmZpBDLXb2tq0S1g7+VcPDCq1Q9pk3R3UMJ
	 ZzvCmlAZ2lNPEr9VXsJQDv4+tRKIMzaGbx0lPSkanW48y7rH2x/IWRXh1JCamCABwe9vk
	 R+tokLDva69b+8HOAG0FCUTjzK7leNJB322L/IL1nQCsU0Irl4DTyuXzEZhaXC2k6lAJ+
	 nBYLFTkqcourdCZa+1RaHU0pnljIJ8RRO+LLChVMY5DNKKdYop6Lqs2nEkPHdVFexbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619188;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SpY6boO6vsl5BtDxZbsL5rNEMAl02yzRn9HtJW84aNs=;
	b=qSZYxAGwrjn3UZzoxeTwD3XMvo+zYjFkFlyLeI0JIixx++Fo5d35WwgorJUQF/e3A090
	 Lb4xy85OyHbJJNMK67NsU7OocE/AY/Ho2idp9Kd8ep2C0cSLkDQFzcAAorBxrec4i913A
	 xR1OpR/8LP8KMPMh3NWh+IClHJQpfaLckBTttSU4xnCPHSwGgqxvcC/NGuAYXkmZQrBKP
	 3XvnZdzAu/Tn/mQAmlW89uoQY9jiJCUId/FAzJ6gd/35jlkBAIKGpd+VBwRLCA4w/foXX
	 pN4CSgPvDEx9Z+M5czyzJA11YhK7N3eDGRbkzC2fbjOhUUxcYdwf2JgUhUWVjN87qLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yJZB90V+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6C9606A31E;
	Wed, 25 Nov 2026 15:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yJZB90V+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0C781F000C0;
	Wed, 25 Nov 2026 15:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619188;
	bh=SpY6boO6vsl5BtDxZbsL5rNEMAl02yzRn9HtJW84aNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yJZB90V+/M0s/dKHes2Q4qKMpxHwheIURFzmJgHZSrzG/qwqehDMjyOwtKQpIJk+9
	 aaf/lnrjvbxwejiZ9OGzGYCgp24b1vnOmyMupe4l46LJlqLClg8CwjBm08dGvUsKSs
	 1TtGGyG33Ea/jO7cpfYK3ZT5QN0Y8uFTPfi+ilP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0519/1005] tcp: Clear DEFER_CONNECT before tcp_connect() and in tcp_abort().
Date: Wed, 25 Nov 2026 15:30:57 +0100
Message-ID: <20261125143833.904115279@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 93723db43e5185404e7d637357d07ffbb38e8b65 ]

When TFO is enabled, tcp_v[46]_connect() sets sk->sk_state to
TCP_SYN_SENT and puts the socket into ehash without calling
tcp_connect().

Then, tcp_fastopen_defer_connect() sets DEFER_CONNECT, and
the first write()/sendmsg() will call tcp_connect() and send
SYN with data if possible.

If tcp_abort() kills a socket before the first write()/sendmsg(),
the unhashed socket can still call it and send SYN in TCP_CLOSE.

Also, DEFER_CONNECT is cleared after __inet_stream_connect().

So, blocking write()/sendmsg() can release lock_sock() in
inet_wait_for_connect() while DEFER_CONNECT is set, and
tcp_poll() could set EPOLLOUT even after SYN is sent.

Let's clear DEFER_CONNECT in tcp_abort() and right before
tcp_connect() in tcp_sendmsg_fastopen().

Note that the last argument of __inet_stream_connect() is
changed from is_sendmsg to defer_connect as DEFER_CONNECT
is already cleared when __inet_stream_connect() is called.

This change is also needed for the next patch.

Fixes: 19f6d3f3c842 ("net/tcp-fastopen: Add new API support")
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Acked-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20261107235720.3129212-2-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/inet_common.h |  2 +-
 net/ipv4/af_inet.c        | 10 ++++++----
 net/ipv4/tcp.c            |  9 +++++++--
 net/mptcp/protocol.c      |  5 +++--
 4 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/include/net/inet_common.h b/include/net/inet_common.h
index 3d747896be300..0f088a213c381 100644
--- a/include/net/inet_common.h
+++ b/include/net/inet_common.h
@@ -25,7 +25,7 @@ int inet_release(struct socket *sock);
 int inet_stream_connect(struct socket *sock, struct sockaddr_unsized *uaddr,
 			int addr_len, int flags);
 int __inet_stream_connect(struct socket *sock, struct sockaddr_unsized *uaddr,
-			  int addr_len, int flags, int is_sendmsg);
+			  int addr_len, int flags, bool defer_connect);
 int inet_dgram_connect(struct socket *sock, struct sockaddr_unsized *uaddr,
 		       int addr_len, int flags);
 int inet_accept(struct socket *sock, struct socket *newsock,
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 14ce01092fda6..bc3bbb2366d81 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -629,7 +629,7 @@ static long inet_wait_for_connect(struct sock *sk, long timeo, int writebias)
  *	TCP 'magic' in here.
  */
 int __inet_stream_connect(struct socket *sock, struct sockaddr_unsized *uaddr,
-			  int addr_len, int flags, int is_sendmsg)
+			  int addr_len, int flags, bool defer_connect)
 {
 	struct sock *sk = sock->sk;
 	int err;
@@ -664,8 +664,10 @@ int __inet_stream_connect(struct socket *sock, struct sockaddr_unsized *uaddr,
 		err = -EISCONN;
 		goto out;
 	case SS_CONNECTING:
-		if (inet_test_bit(DEFER_CONNECT, sk))
-			err = is_sendmsg ? -EINPROGRESS : -EISCONN;
+		if (defer_connect)
+			err = -EINPROGRESS;
+		else if (inet_test_bit(DEFER_CONNECT, sk))
+			err = -EISCONN;
 		else
 			err = -EALREADY;
 		/* Fall out of switch with err, set for this state */
@@ -752,7 +754,7 @@ int inet_stream_connect(struct socket *sock, struct sockaddr_unsized *uaddr,
 	int err;
 
 	lock_sock(sock->sk);
-	err = __inet_stream_connect(sock, uaddr, addr_len, flags, 0);
+	err = __inet_stream_connect(sock, uaddr, addr_len, flags, false);
 	release_sock(sock->sk);
 	return err;
 }
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index f88548e10f2a8..be772a67b05d6 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1054,6 +1054,7 @@ int tcp_sendmsg_fastopen(struct sock *sk, struct msghdr *msg, int *copied,
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct inet_sock *inet = inet_sk(sk);
 	struct sockaddr *uaddr = msg->msg_name;
+	bool defer_connect = false;
 	int err, flags;
 
 	if (!(READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_fastopen) &
@@ -1073,6 +1074,9 @@ int tcp_sendmsg_fastopen(struct sock *sk, struct msghdr *msg, int *copied,
 	tp->fastopen_req->uarg = uarg;
 
 	if (inet_test_bit(DEFER_CONNECT, sk)) {
+		inet_clear_bit(DEFER_CONNECT, sk);
+		defer_connect = true;
+
 		err = tcp_connect(sk);
 		/* Same failure procedure as in tcp_v4/6_connect */
 		if (err) {
@@ -1083,14 +1087,13 @@ int tcp_sendmsg_fastopen(struct sock *sk, struct msghdr *msg, int *copied,
 	}
 	flags = (msg->msg_flags & MSG_DONTWAIT) ? O_NONBLOCK : 0;
 	err = __inet_stream_connect(sk->sk_socket, (struct sockaddr_unsized *)uaddr,
-				    msg->msg_namelen, flags, 1);
+				    msg->msg_namelen, flags, defer_connect);
 	/* fastopen_req could already be freed in __inet_stream_connect
 	 * if the connection times out or gets rst
 	 */
 	if (tp->fastopen_req) {
 		*copied = tp->fastopen_req->copied;
 		tcp_free_fastopen_req(tp);
-		inet_clear_bit(DEFER_CONNECT, sk);
 	}
 	return err;
 }
@@ -5151,6 +5154,8 @@ int tcp_abort(struct sock *sk, int err)
 		/* Don't race with userspace socket closes such as tcp_close. */
 		lock_sock(sk);
 
+	inet_clear_bit(DEFER_CONNECT, sk);
+
 	/* Avoid closing the same socket twice. */
 	if (sk->sk_state == TCP_CLOSE) {
 		if (!has_current_bpf_ctx())
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 05c38564e8fdf..8e08feb676f78 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1920,10 +1920,12 @@ static int mptcp_sendmsg_fastopen(struct sock *sk, struct msghdr *msg,
 	msg->msg_flags = saved_flags;
 	release_sock(ssk);
 
+	inet_clear_bit(DEFER_CONNECT, sk);
+
 	/* do the blocking bits of inet_stream_connect outside the ssk socket lock */
 	if (ret == -EINPROGRESS && !(msg->msg_flags & MSG_DONTWAIT)) {
 		ret = __inet_stream_connect(sk->sk_socket, msg->msg_name,
-					    msg->msg_namelen, msg->msg_flags, 1);
+					    msg->msg_namelen, msg->msg_flags, true);
 
 		/* Keep the same behaviour of plain TCP: zero the copied bytes in
 		 * case of any error, except timeout or signal
@@ -1941,7 +1943,6 @@ static int mptcp_sendmsg_fastopen(struct sock *sk, struct msghdr *msg,
 			sk->sk_socket->state = SS_UNCONNECTED;
 		}
 	}
-	inet_clear_bit(DEFER_CONNECT, sk);
 
 	return ret;
 }
-- 
2.53.0



