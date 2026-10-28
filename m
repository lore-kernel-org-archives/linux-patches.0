Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216355;
	b=CeN/D7qPSzCet/9ylw0YNoDNTgIU6GLhTUWBhfZagJfiedY0ZxWK9vXVdvGUSjd228w6
	 a5tzFJkDxsbZspZFbZvfRCkOdTyi43ICT2MfTi3w81uBdXXFnU9t+GAGxXJjpvvoh6M6x
	 3tDnks7CbTmPOhLiQTWRTZi2/P0kSlkpJtnNrvotcleqaWa8s11QgAG0XI13HP1JWrNa3
	 KXA+KmcoLKTI3GLAYIHXcHM38eDN1EBjpYKVIUJKhFyaOHBMupiOVarqbIVEJxkNNY8B4
	 CgImVM6LZkIogNHPlWE4fEx8dDq59HgWRMI3kS9NrHGBxENWrTqyEY3BmSl9ot0jApQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216355;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/4G//zZvZS3DedvKaBAUkIDtkEnrEqsm8nhwWo6OI6E=;
	b=xRWYLbqX4eziTClYUwaJvHMS8/z0KRQZeZBtn6tN2OtIEdG69FuOK3Ij6KMNc2IBCh4m
	 3xEeZVlqZqRelpCBkFW7hGJx3OXiO+P1YRZroeshW77xxoF3sTDkZkVXmzY8o0vtUdDLv
	 Lu3nXE/ckngqgDyxi4GZsDlDeaUgdIhycicIiMTMGZKCofkc6xEFzfr2dUgQOnSGKvNM3
	 RtdUdceKaaF1fFuDJrnGeJYGFaL9IVJrqoSCUCt/d2IpNeY/4cUjOJnJctncsVNtbHlOR
	 yqRd11Jx6/6+tHnNNoVDf61aJ0cw9dwv3ORlhNciJKjiuMj9u3yuDgWIDde1YK+6lPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lev+rOLN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F03606A31D;
	Wed, 28 Oct 2026 19:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lev+rOLN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C8861F01825;
	Wed, 28 Oct 2026 19:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216354;
	bh=/4G//zZvZS3DedvKaBAUkIDtkEnrEqsm8nhwWo6OI6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lev+rOLNVG2OBvttkjVKNpsqRl9aOfjVpW1ldHju78pIMBbU7Qeas3zx/noYpCvXR
	 s/aMsYQMQmqvRdCZKLdxD0JMmhrTc4GxbiXiOmwmm5gCykN0zQfiRaF8XmQ+tcFBpb
	 m1jTMPyJyhHLEvVHdpwoq4TFERNiGFWcazw46Lb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1b2c9c4a0f8708082678@syzkaller.appspotmail.com,
	Michal Luczaj <mhal@rbox.co>,
	Nguyen Dinh Phi <phind.uet@gmail.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1529/1887] vsock: dont check the listeners sk_err in vsock_accept()
Date: Wed, 28 Oct 2026 18:00:25 +0100
Message-ID: <20261028170534.258460891@linuxfoundation.org>
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

From: Nguyen Dinh Phi <phind.uet@gmail.com>

[ Upstream commit b8c899cf5e7be29840a172c183dedd8d3e7a0287 ]

Syzbot reported an issue which can be reproduced with these steps:
	r0 = socket(AF_VSOCK, SOCK_STREAM, 0)
	bind(r0, {VMADDR_CID_ANY, PORT})
	connect(r0, {VMADDR_CID_LOCAL, PORT}) -> -1, EPROTO (self-connect)
	listen(r0, backlog)                   -> 0
	r1 = socket(AF_VSOCK, SOCK_STREAM, 0)
	connect(r1, {VMADDR_CID_LOCAL, PORT}) -> 0
	accept(r0)                            -> -1, EPROTO (stale sk_err)

Basically, it creates a socket (r0) and triggers a self-connect after
binding it. This self-connect fails with EPROTO because it loops back
to r0 while the socket is still in the TCP_SYN_SENT state, causing it
to be incorrectly dispatched to the connecting-client path. The
unexpected packet type encountered there sets sk_err to EPROTO.

After that, it invokes a listen() call on the same socket. This
listen() call succeeds because the kernel's listening path never
inspects or clears sk_err. Then, a new socket (r1) is created as a
normal client and connects to r0. However, vsock_accept() rejects this
incoming connection because the listener's sk_err still holds the
EPROTO error from the earlier failed self-connect.

This rejection causes the child socket created for r1's connection to
never be freed on virtio or hyperv transports; only the VMCI transport
implements pending_work to revisit and clean up a rejected socket.

For a non-blocking connect(), vsock_connect() may return -EINPROGRESS
immediately, and vsock_connect_timeout() can later set sk->sk_err
asynchronously.

Since no vsock transport ever sets sk_err on a socket while it is in
TCP_LISTEN state, checking it in vsock_accept() serves no purpose and
only carries forward errors left behind by earlier, unrelated
connection attempts on the same socket. Remove the checks so accept()
no longer rejects valid incoming connections because of a stale
error, which also avoids the resource leak described above.

Fixes: d021c344051a ("VSOCK: Introduce VM Sockets")
Reported-by: syzbot+1b2c9c4a0f8708082678@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1b2c9c4a0f8708082678
Suggested-by: Michal Luczaj <mhal@rbox.co>
Signed-off-by: Nguyen Dinh Phi <phind.uet@gmail.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://patch.msgid.link/20260813173024.2362935-2-phind.uet@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/af_vsock.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 92685d6da9ad1..364a0d5ef9645 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1586,8 +1586,7 @@ static int vsock_accept(struct socket *sock, struct socket *newsock, int flags,
 	timeout = sock_rcvtimeo(listener, flags & O_NONBLOCK);
 	prepare_to_wait(sk_sleep(listener), &wait, TASK_INTERRUPTIBLE);
 
-	while ((connected = vsock_dequeue_accept(listener)) == NULL &&
-	       listener->sk_err == 0) {
+	while ((connected = vsock_dequeue_accept(listener)) == NULL) {
 		release_sock(listener);
 		timeout = schedule_timeout(timeout);
 		finish_wait(sk_sleep(listener), &wait);
@@ -1605,9 +1604,6 @@ static int vsock_accept(struct socket *sock, struct socket *newsock, int flags,
 	}
 	finish_wait(sk_sleep(listener), &wait);
 
-	if (listener->sk_err)
-		err = -listener->sk_err;
-
 	if (connected) {
 		sk_acceptq_removed(listener);
 
-- 
2.53.0



