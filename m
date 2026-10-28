Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216458;
	b=QV2wQB7BdRfAess9GkoIeh/pmbiY5EjcZKH3lMp9AdcDDScjuoKUUWBFdSTo812hmJdH
	 DEeB+SPzZJ7yvLgsxjVpLcPQoJyyFs+MZmXwgaqCIyp4hOx/i21ZpjTMefqazlOgaVjtQ
	 fIQ+PHrSV7Bgp31gPwyKBrZbXC/vOL7w41cOVsfrpTY36kcc4VMjbM2EMLUR5PYBKKLXY
	 e83mb8Zs5HjtV7rlcy8/oGGj+/RkgiJqwzmwDeKUMH9N1nbt3YYgvKGgf7XLdupHCI9Ad
	 6pWrwJRabMIQnE6/19D2QEzna/RpogZGFGG297QI+MSwsXKhBXj0y+hkasPEU2SHEsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216458;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cdjfjpiDCq5KOJXIzd8HZ8wO54GdSYN7btLaiIssGJs=;
	b=UZ6GyMijiajW+SDIsBBXhXbkvdxG8CWN9rU2p2SHhm3hGC5EWQ9cLl6eO7eY+R7jG1cQ
	 Ryjd8KMfNDHMen47g5lGICE1/2znoZzeF/MMwxyNZl74NgdnRItQm2SB3/W0MaYbWxKdn
	 iX4D/Qy7f99p2pmATlkMYS1NthtYL6ATVpcqBM7tGgfQKQpjAg+qdpdRG3Rz8NQhZODRj
	 EkNpfe/jh9hXYoOYHYOTbxiGZUgCU2KhtezmUy5BrK4vF/De7dwZvouwy3idMWIpNORg4
	 Kbufi26AR5oVsDXmZVProsrvd+4KhAlC4IpU3qTVXJgP0KzGyJOg5JnPYpahniad+RQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1UavAc3Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B5060A2630;
	Wed, 28 Oct 2026 19:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1UavAc3Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 519661F031E3;
	Wed, 28 Oct 2026 19:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216457;
	bh=cdjfjpiDCq5KOJXIzd8HZ8wO54GdSYN7btLaiIssGJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1UavAc3ZNep+i8BUM/Ga8L1V/LySbw+t5mtLvEuY62+wwz8bpzJATmWsJlnAVyFHi
	 iL02ZC8JXiiM2lDUxRHYhXgqIfq0mqVeCfuN8WxuRQiswQtKr0gVmEkiAk2DlKtA86
	 PlzlKfsJ8oa23s5mkPOUGrReBz0UHvOwrrw9EL60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1564/1887] sunrpc: xprtsock: annotate shared socket callbacks with READ_ONCE/WRITE_ONCE
Date: Wed, 28 Oct 2026 18:01:00 +0100
Message-ID: <20261028170535.054987568@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit 33930840b5f0a79f826e7c69dc6cd78f72a67481 ]

xprtsock replaces and restores sk->sk_data_ready and
sk->sk_write_space on live sockets with plain stores, and
xs_udp_do_set_buffer_size() invokes sk->sk_write_space via a plain
load. These callback pointers are shared with generic socket and
protocol paths that may read or invoke them concurrently, so xprtsock
needs the same READ_ONCE()/WRITE_ONCE() callback visibility contract
that the validated 4022 family applied elsewhere.

When SUNRPC takes over an AF_LOCAL, UDP, or TCP socket and later
restores the lower-socket callbacks during teardown, another CPU may
still hold an earlier callback snapshot. The plain replace/restore
pattern leaves the same visibility hole as the validated 4022 family,
so a stale snapshot can still invoke xs_data_ready() or
xs_udp_write_space() after the live callback fields have already been
restored to the lower-socket handlers.

Use WRITE_ONCE() for the shared sk_data_ready and sk_write_space
stores in xs_local_finish_connecting(), xs_udp_finish_connecting(),
xs_tcp_finish_connecting(), and xs_restore_old_callbacks(). Use
READ_ONCE() for the direct sk_write_space invocation in
xs_udp_do_set_buffer_size(). This matches the required callback
visibility contract while leaving adjacent sk_state_change and
sk_error_report handling unchanged.

Fixes: a246b0105bbd ("[PATCH] RPC: introduce client-side transport switch")
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtsock.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 5315872f6a9c8..e812396e869b7 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -1115,9 +1115,9 @@ static void xs_save_old_callbacks(struct sock_xprt *transport, struct sock *sk)
 
 static void xs_restore_old_callbacks(struct sock_xprt *transport, struct sock *sk)
 {
-	sk->sk_data_ready = transport->old_data_ready;
+	WRITE_ONCE(sk->sk_data_ready, transport->old_data_ready);
 	sk->sk_state_change = transport->old_state_change;
-	sk->sk_write_space = transport->old_write_space;
+	WRITE_ONCE(sk->sk_write_space, transport->old_write_space);
 	sk->sk_error_report = transport->old_error_report;
 }
 
@@ -1563,6 +1563,7 @@ static void xs_udp_do_set_buffer_size(struct rpc_xprt *xprt)
 {
 	struct sock_xprt *transport = container_of(xprt, struct sock_xprt, xprt);
 	struct sock *sk = transport->inet;
+	void (*write_space)(struct sock *sock);
 
 	if (transport->rcvsize) {
 		sk->sk_userlocks |= SOCK_RCVBUF_LOCK;
@@ -1571,7 +1572,8 @@ static void xs_udp_do_set_buffer_size(struct rpc_xprt *xprt)
 	if (transport->sndsize) {
 		sk->sk_userlocks |= SOCK_SNDBUF_LOCK;
 		sk->sk_sndbuf = transport->sndsize * xprt->max_reqs * 2;
-		sk->sk_write_space(sk);
+		write_space = READ_ONCE(sk->sk_write_space);
+		write_space(sk);
 	}
 }
 
@@ -1885,8 +1887,8 @@ static int xs_local_finish_connecting(struct rpc_xprt *xprt,
 		xs_save_old_callbacks(transport, sk);
 
 		sk->sk_user_data = xprt;
-		sk->sk_data_ready = xs_data_ready;
-		sk->sk_write_space = xs_udp_write_space;
+		WRITE_ONCE(sk->sk_data_ready, xs_data_ready);
+		WRITE_ONCE(sk->sk_write_space, xs_udp_write_space);
 		sk->sk_state_change = xs_local_state_change;
 		sk->sk_error_report = xs_error_report;
 		sk->sk_use_task_frag = false;
@@ -2088,8 +2090,8 @@ static void xs_udp_finish_connecting(struct rpc_xprt *xprt, struct socket *sock)
 		xs_save_old_callbacks(transport, sk);
 
 		sk->sk_user_data = xprt;
-		sk->sk_data_ready = xs_data_ready;
-		sk->sk_write_space = xs_udp_write_space;
+		WRITE_ONCE(sk->sk_data_ready, xs_data_ready);
+		WRITE_ONCE(sk->sk_write_space, xs_udp_write_space);
 		sk->sk_use_task_frag = false;
 
 		xprt_set_connected(xprt);
@@ -2255,9 +2257,9 @@ static int xs_tcp_finish_connecting(struct rpc_xprt *xprt, struct socket *sock)
 		xs_save_old_callbacks(transport, sk);
 
 		sk->sk_user_data = xprt;
-		sk->sk_data_ready = xs_data_ready;
+		WRITE_ONCE(sk->sk_data_ready, xs_data_ready);
 		sk->sk_state_change = xs_tcp_state_change;
-		sk->sk_write_space = xs_tcp_write_space;
+		WRITE_ONCE(sk->sk_write_space, xs_tcp_write_space);
 		sk->sk_error_report = xs_error_report;
 		sk->sk_use_task_frag = false;
 
-- 
2.53.0



