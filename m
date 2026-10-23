Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774401;
	b=bJNflvc973uSTqXaW3SZ7fl1ye8ZUmjhM0QuqQ12ew5H1RAp02E2JWY6i7/P7J9wtCUW
	 6AcaGdj7rTCOQQblpTn/FjgPBdYEg3QIWNkmv+Zo+zdMEBTs72HCWJ885pbXzUDduTTNB
	 NUF7aGU0Memf1vSfnkdGSUlBYrW/x/IcqVHuBL8JT36rNlXeW7Yivp+ZyXjFpxsdSygbf
	 M7GuvZo0bNfM15KBMHkZe8NC7lVrAe+s/liNirma1fvnbtsCm0oSO63rncjSGLQg55SSc
	 yMHc1D6VlZPhB0ElTpzO5VdcSnnxsUFAPkBknFdsZxekc7O5bSZVw1f1yWAZQkmk+OQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774401;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=slYivxUbP3TpetyLDHUzK20wUmmKNQhRNO2EfGN5FcE=;
	b=wrPkqH1of6LeFeRjOqOHjvUsxvEMBmQTucCWTsvKsjlFBTHcZfG8Y6jjie66Kv4q1nmW
	 WCeC4+VvvxHJWOsmhAk1cUFc5fn/ax+mKcluOZlHWGTWQXAxafxCpBy+Deq6JuSgzuVqG
	 9lL35NjbX5DNbI1xVO10Nx1cE0aSbSksCQvLBymgR52024ayAvLVGAxc8PdPIXYeNcn2Y
	 3sxF0wkDLOFbzkOFMfAdFhBgp23OwKRxPoU5rfZPDyoKmII/3mwHqmY02w26DLMLN2CKX
	 tvvEeDcV7tIUz2bLxy1/W97R8UMZsH38ypgNlK8TEtobHZ43TMjTMXLcxbhz+tUjZ2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Csu6eFsj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51394606A31E;
	Fri, 23 Oct 2026 16:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Csu6eFsj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92DD31F01825;
	Fri, 23 Oct 2026 16:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774401;
	bh=slYivxUbP3TpetyLDHUzK20wUmmKNQhRNO2EfGN5FcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Csu6eFsj+zBqbhnxiSi7fGe5TWNO20CVuvqwGXJjufy/8gd6mETDckjTlBzJ+MupF
	 6DOTnKPf/DY2u+CpqqO5Omor9qwLMKm+qNdgPaguxGE/nYMLKdif8+CFSY+3yR39VU
	 2VHFZE2Kk0PwnoJN2KlIB4aafgmhzeYyB2kYFyts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Michal Luczaj <mhal@rbox.co>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 028/242] vsock: treat TCP_CLOSING as once-established
Date: Fri, 23 Oct 2026 18:37:50 +0200
Message-ID: <20261023163714.449072083@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Luczaj <mhal@rbox.co>

[ Upstream commit 4f6ac74fa594a918d41255c941256e1d51592d3b ]

Handle the TCP_ESTABLISHED -> TCP_CLOSING transition on OP_RST, which can
race with the connect loop. Immediately break and return 0 on
ESTABLISHED/CLOSING. The return value of connect() should reflect what
happened up to the point the connection was established or failed. Events
that occur afterwards must not affect it. E.g. even if OP_RW has already
set sk_err, connect() should still return 0, not ENOBUFS because of it.
Adapt the inaccurate comment above signal_pending().

Resetting a socket that is still present in connected_table can lead to
memory corruption. The reporter noted lost transports for in-flight skbs,
and I have reproduced crashes caused by re-insertion into connected_table.

  list_add double add: new=, prev=, next=.
  kernel BUG at lib/list_debug.c:35!
  Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
  Workqueue: vsock-loopback vsock_loopback_work
  RIP: 0010:__list_add_valid_or_report+0x11f/0x130
  Call Trace:
   vsock_insert_connected.cold+0xe/0x13
   virtio_transport_recv_pkt+0x10e9/0x1460
   vsock_loopback_work+0x305/0x480
   process_one_work+0xe4c/0x1560
   worker_thread+0x4f1/0xd60
   kthread+0x36e/0x470
   ret_from_fork+0x47b/0x6b0
   ret_from_fork_asm+0x1a/0x30

This fix is supplementary to commit 002541ef650b ("vsock: Ignore
signal/timeout on connect() if already established"). Details under Link.

Fixes: d021c344051a ("VSOCK: Introduce VM Sockets")
Reported-by: Hyunwoo Kim <imv4bel@gmail.com>
Link: https://lore.kernel.org/netdev/anzT1fREOSyHT99k@v4bel/
Signed-off-by: Michal Luczaj <mhal@rbox.co>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://patch.msgid.link/20261005-vsock-connect-reset-closing-v4-1-15d41cfda3ed@rbox.co
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/af_vsock.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index f271a095996c9..db62ee41f1061 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1809,23 +1809,22 @@ static int vsock_connect(struct socket *sock, struct sockaddr_unsized *addr,
 		timeout = schedule_timeout(timeout);
 		lock_sock(sk);
 
-		/* Connection established. Whatever happens to socket once we
-		 * release it, that's not connect()'s concern. No need to go
+		/* Connection was established. Whatever happens to socket once
+		 * we release it, that's not connect()'s concern. No need to go
 		 * into signal and timeout handling. Call it a day.
 		 *
 		 * Note that allowing to "reset" an already established socket
 		 * here is racy and insecure.
 		 */
-		if (sk->sk_state == TCP_ESTABLISHED)
-			break;
+		if (sk->sk_state == TCP_ESTABLISHED ||
+		    sk->sk_state == TCP_CLOSING) {
+			err = 0;
+			goto out_wait;
+		}
 
 		/* If connection was _not_ established and a signal/timeout came
 		 * to be, we want the socket's state reset. User space may want
-		 * to retry.
-		 *
-		 * sk_state != TCP_ESTABLISHED implies that socket is not on
-		 * vsock_connected_table. We keep the binding and the transport
-		 * assigned.
+		 * to retry, so we keep the binding and the transport assigned.
 		 */
 		if (signal_pending(current) || timeout == 0) {
 			err = timeout == 0 ? -ETIMEDOUT : sock_intr_errno(timeout);
-- 
2.53.0



