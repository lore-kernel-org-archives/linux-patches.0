Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773823;
	b=l0SazmTbWw9EgNiSVr/lTWxaED9Mak2T3UlWM1mel3v/XJHicZCoqRYdF3yWZxLha6Za
	 f1Zv4UXBiak4sE2xVgEFaLySp5PIvY+4uee6h47eOBNBqCWSinciWx6gpPUvhLEEimOdb
	 CI/Ake3/2HkU/2EgIXOK7yA2bWqksG41euArTxhsZSmBkW0acMFz4JMA0BrFqg1drnINC
	 KMPbXNVpY1kD2eFxoTP3MfmbBgnGfVy0gYHUphIs/al16dLo8TylJryt5cUpTGht8QPqY
	 i1oXl90XhczWVmT0Tl4HYX+wNcrmTmb9Wlpkb6MB90qMSxAubXap1Zyk0o2XiVpjvJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773823;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NevlfS5xc7Ru/qZTjSPW5kFEWfsflRH9hrGIXfWSVws=;
	b=OAtUAL/8ZBYYTVr47eQ2OFm/ZO4TRm6Xv3dMr5j3AHTd73cpfjpKvqSnlCzQoguVkn+6
	 oZ7M0o8R+Uao8ogAyKuO15YvMqQdMxbscle7xF20C2Zks1JLf5fJTGWbmFacm2HgxWzBn
	 owXHzK2/VbyztaJjy75obeWNrjLPce9VNKJsplt0GCF3E8euEg1HX/dGMFOxu4u7sRNQG
	 6WgvyS5f/gFLVYunbCT5zdVhrjorRfl6KTN++9P1J4DcTfQGM+nKJdEF6WJ59arRxYfgx
	 E1scBfaDrBIxYSdSQen4yPHuAM9vVciXdlQQV/kMy8Ywd9sm3+gsvmqPdHfHpIM9KUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1MfEfixy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 319F3606A320;
	Fri, 23 Oct 2026 16:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1MfEfixy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C5001F01825;
	Fri, 23 Oct 2026 16:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773822;
	bh=NevlfS5xc7Ru/qZTjSPW5kFEWfsflRH9hrGIXfWSVws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1MfEfixymTHbwzUbtnHZH5kH9jI2d9VLk/TfEwjlWjvcDFGLSEtp8CZvVDRpAJOjg
	 PeAYKcO7JHfxSDR2AoIirGvc7omH9Ny8akA5uKAZ5hlZExlVDdoC86+woKBIBmCDHi
	 Xme0GooHNkHqcQoFLfrSVDRxQOKVvRHJ5RMDivAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Michal Luczaj <mhal@rbox.co>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 028/193] vsock: treat TCP_CLOSING as once-established
Date: Fri, 23 Oct 2026 18:35:05 +0200
Message-ID: <20261023163714.866835941@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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
index a540b3d29f9b5..b02433aae57cb 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1678,23 +1678,22 @@ static int vsock_connect(struct socket *sock, struct sockaddr *addr,
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



