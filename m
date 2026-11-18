Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021726;
	b=mwBcvzicRy3SAbrTUHc+t8oPm9ADXq6jwNsfwvk1o5mdeP7gKSi3MQIJUxyNX9V0gRc9
	 NHMG0SV3d5Ruz34fgESYOnjb6Y9PWWMfYJfaR5pIg/eMUoH4aKXR25TvBnsdt681i/VJn
	 DEM+1cNCUbKpKeDMXsQrkbkvv3zqeng1s0dHYrCuUF9FgjnHnguwfHIQgpkDPC4qYMWzr
	 V/JE0yHllw4nudnZkgnm4HXETIl/RoS4ebzjQE+S1vPQLhi9PUXp37Qjv/GcDySq+eztX
	 PsjGktVYe2KQJRcmZIEKUoYxCi/lGndxgBHW9tL5t4GPRo4Deb77faXwNBMCOuJQbvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021726;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/I1W73RcAqjrMUJnBr0Tp2A1pBoqchxTw+HP/Tm0ppo=;
	b=gwF3bSgQe2jW99NZitjC7m4x30XtTjHFmIAfyypPlbUB7MDFvFGecGSRnIX8rGwLGdlj
	 5GiSs1eeHhEWskfF5NJ9+3EwoKMaIht5C78MOL48W7+55EXnuuCzltFl1sB2qk7PbZ2kg
	 laX4DMf1MPqsXt8alDc2v5r9k+2o11V+uuVU7X6RzsWo6LgGjXUNM8axkm7roOBuKp06q
	 e57eXaOn+ANEFulii0/gkKieCGbPIykvha6UiIO4gBqCab9LYMsxekfdo2QenRjCZ0xm0
	 J9jEIBOFm0RfPAJnPiSzpkyuS3lX7vjrs2NYyOk3ytJvmjpLKj/PBhws+/awBRldXhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yRAdFhS2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BBDD60A261D;
	Wed, 18 Nov 2026 17:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yRAdFhS2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 472E91F000C5;
	Wed, 18 Nov 2026 17:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021725;
	bh=/I1W73RcAqjrMUJnBr0Tp2A1pBoqchxTw+HP/Tm0ppo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yRAdFhS2EbBpYNUwe1vOYhpL2o2vTVfNh6/iAAUH7xK4tol2sITY+aXdXn3gVwtM2
	 icgsDScmYhCOevjqSFub3i5ka9Byk0nJQKVj4r+QqrUe6Nxa8woAOjRcPL0JXEUAbO
	 qxKDpGmkwxKR9hi0K/Awt0ast86FWo6Lz29fWrp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mina Almasry <almasrymina@google.com>,
	Kaifeng Wang <kaifengw@google.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Eric Dumazet <edumazet@kernel.org>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2368/2651] tcp: reject devmem tx with fastopen and repair
Date: Wed, 18 Nov 2026 16:00:08 +0100
Message-ID: <20261118150410.781079055@linuxfoundation.org>
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

From: Kaifeng Wang <kaifengw@google.com>

[ Upstream commit 89b9db72918bc209029fad8cccc42191b498d511 ]

tcp_sendmsg_locked() enforces that devmem TX can only proceed if the
zero-copy path is active and a valid dmabuf binding exists. However,
subsequent branches in tcp_sendmsg_locked() can still intercept the
message before it reaches the devmem zero-copy loop:

1. TCP Fast Open (MSG_FASTOPEN or DEFER_CONNECT):
   If TCP_FASTOPEN_CONNECT is set, the socket may have a valid dst with
   NETIF_F_SG (so zc == MSG_ZEROCOPY and binding is present), but
   tcp_sendmsg_fastopen() -> tcp_send_syn_data() will use
   copy_page_from_iter() to byte-copy from the iterator. Since iov_base
   represents dma-buf offsets rather than user virtual addresses, this
   misinterprets offsets as user pointers and copies the caller's memory
   at those addresses into the SYN packet.

2. TCP repair mode:
   If tp->repair is enabled with TCP_RECV_QUEUE, tcp_send_rcvq() similarly
   calls skb_copy_datagram_from_iter(), byte-copying from the iterator.

Neither path supports or makes sense for devmem transmission. Reject
devmem sends inside the Fast Open and TCP repair branches when a devmem
binding is present. Checking inside the tp->repair branch also covers
the case where repair mode is enabled while sk_stream_wait_connect()
drops the socket lock.

Additionally, drop the !sockc_err gate from the devmem validation check
and return sockc_err if set. Otherwise, if a valid SCM_DEVMEM_DMABUF is
followed by a failing cmsg, sockc.dmabuf_id remains set while binding is
not acquired, allowing the Fast Open and TCP_RECV_QUEUE repair paths to
proceed and return before sockc_err is checked.

This pre-existing issue was identified by Sashiko AI review on commit
125755776bc6 ("tcp: reject non zerocopy devmem tx") and has not been
hit in production.

Fixes: 125755776bc6 ("tcp: reject non zerocopy devmem tx")
Fixes: bd61848900bf ("net: devmem: Implement TX path")
Reviewed-by: Mina Almasry <almasrymina@google.com>
Signed-off-by: Kaifeng Wang <kaifengw@google.com>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://patch.msgid.link/20261019174522.55644-1-kaifengw@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 87ef6d5cbfeba..2792923f07489 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1169,14 +1169,18 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 			zc = MSG_SPLICE_PAGES;
 	}
 
-	if (!sockc_err && sockc.dmabuf_id && (zc != MSG_ZEROCOPY || !binding)) {
-		err = -EINVAL;
+	if (sockc.dmabuf_id && (zc != MSG_ZEROCOPY || !binding)) {
+		err = sockc_err ?: -EINVAL;
 		goto out_err;
 	}
 
 	if (unlikely(flags & MSG_FASTOPEN ||
 		     inet_test_bit(DEFER_CONNECT, sk)) &&
 	    !tp->repair) {
+		if (binding) {
+			err = -EINVAL;
+			goto out_err;
+		}
 		err = tcp_sendmsg_fastopen(sk, msg, &copied_syn, size, uarg);
 		if (err == -EINPROGRESS && copied_syn > 0)
 			goto out;
@@ -1200,6 +1204,10 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 	}
 
 	if (unlikely(tp->repair)) {
+		if (binding) {
+			err = -EINVAL;
+			goto out_err;
+		}
 		if (tp->repair_queue == TCP_RECV_QUEUE) {
 			copied = tcp_send_rcvq(sk, msg, size);
 			goto out_nopush;
-- 
2.53.0



