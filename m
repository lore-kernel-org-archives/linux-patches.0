Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774935;
	b=CX+q4H7S/ZBraIL2SIkSwEYEPlgBc8Y+D9mw29rHhkNnN4utuzpfmmHKXGzPgdNqnXHj
	 Uhtcg6GavUUCDAO8hO+Gz6zJ4hDHsmpkU6FjWXvMCT+VaicQ3czGHMgELwPRAvbEjvg3g
	 9dOkZheo5e2zSoV6u1b0T1JvdXC82m43TTFvTg+sbpngeBZjz9DW/qwTgjF171W6SUmGl
	 zZlril6Nn+OEsbFWH9G5zVCn0Nxc55pZwtFXqSpeEb+h8kffj0kv7AKIe4gXIjj4Xo4Yd
	 bU3QPyDMlSX2EbAiDdqtOYVetEx7lqggsv0eG6xiOUMfa+pLufYAZ4Jfpm4R3Bnq4Jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774935;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w9CiSOlImS/NZJ24npl460+ftgl3xeG2oER57fXn0Jc=;
	b=nI1tX5LYROu/LJ4cQqs8HsXUJUVEKNpR++POMZdpCaD/DSJTVZo3kZo9l+6/J8cjeeTh
	 EmpPK12I++eD/76tyaHuuqNCn19e+YVtQK3IPDY6nvwQqBuiHg5JmfeVYb9gqJUym7ITE
	 lmBg32Lhouj+s5Zf4MaR9BBfuiEFLFxbNV+jppBSS+1VXjCARlv6VKwP5DNKFN02YpCwS
	 ijKPpIpivrFY1eumCRTxRJ1S2B1fbrV/eVsCn5ojD+9EDx7WYTcagmmK13IKLYQlzFrFr
	 wkJLcOzqTKgcmG7mLTcq9BGLgz94Wc014ikfdcCe0xbGXTpO4GzD45jiYWu9p7YVjtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NNfCSOf3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ABC2606A31B;
	Fri, 23 Oct 2026 17:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NNfCSOf3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87BED1F01825;
	Fri, 23 Oct 2026 17:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774935;
	bh=w9CiSOlImS/NZJ24npl460+ftgl3xeG2oER57fXn0Jc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NNfCSOf3+FEVZaX9gjrWoFJHytMDc4HQw8kRvvbTLYLmVATnRNc9WhsXwzocLMWOS
	 IUs/7p6NdCLb7zIMnDqQ3i62dNm/Da3PAwtbjnfsbtyIHN0fsbOsr5rzLd+x6xq+kp
	 aFU1M5umIY4CZC9gZNsM0nS5mJlY9DM8MN9OyIeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Daehyeon Ko <4ncienth@gmail.com>,
	Vishnu Dasa <vishnu.dasa@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 206/242] vsock/vmci: validate packet source for connected sockets
Date: Fri, 23 Oct 2026 18:40:48 +0200
Message-ID: <20261023163718.666095808@linuxfoundation.org>
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

From: Daehyeon Ko <4ncienth@gmail.com>

commit ad9a7da3fa39c2d616ec0dd3cf6e30531d032fe7 upstream.

vmci_transport_recv_stream_cb() looks up sockets first by the full source
and destination tuple, then by destination only in the bound table. The
fallback can select a non-listening socket without checking whether the
packet came from its stored peer.

This was reproduced with two VMCI contexts. A RST from the context not
stored in a TCP_SYN_SENT socket reset that socket after it was selected by
the destination-only lookup.

VMCI can process notification packets in bottom-half context when the
socket is not owned by user context, or defer packets to a workqueue. Use
vsock_check_source() after taking the socket lock in the bottom-half path,
and recheck after lock_sock() in the workqueue path. Listening sockets
continue to accept packets from any source.

Reply with a RST addressed from the received packet before dropping a
source that fails validation. This preserves the existing reset behavior
for bound non-listening and concurrently closed sockets without directing
the reset to a connected socket's stored peer.

Fixes: d021c344051a ("VSOCK: Introduce VM Sockets")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/netdev/20260814121255.6B5001F000E9@smtp.kernel.org/
Cc: stable@vger.kernel.org
Suggested-by: Stefano Garzarella <sgarzare@redhat.com>
Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Reviewed-by: Vishnu Dasa <vishnu.dasa@broadcom.com>
Link: https://patch.msgid.link/20260826003929.966160-3-4ncienth@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/vmci_transport.c |   36 +++++++++++++++++++++++++++++-------
 1 file changed, 29 insertions(+), 7 deletions(-)

--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -680,11 +680,13 @@ static int vmci_transport_recv_stream_cb
 	struct vmci_transport_packet *pkt;
 	struct vsock_sock *vsk;
 	bool bh_process_pkt;
+	bool drop_pkt;
 	int err;
 
 	sk = NULL;
 	err = VMCI_SUCCESS;
 	bh_process_pkt = false;
+	drop_pkt = false;
 
 	/* Ignore incoming packets from resources that aren't vsock
 	 * implementations.
@@ -765,17 +767,29 @@ static int vmci_transport_recv_stream_cb
 	bh_lock_sock(sk);
 
 	if (!sock_owned_by_user(sk)) {
-		/* The local context ID may be out of date, update it. */
-		vsk->local_addr.svm_cid = dst.svm_cid;
-
-		if (sk->sk_state == TCP_ESTABLISHED)
-			vmci_trans(vsk)->notify_ops->handle_notify_pkt(
-					sk, pkt, true, &dst, &src,
-					&bh_process_pkt);
+		if (sk->sk_state != TCP_LISTEN &&
+		    !vsock_check_source(vsk, &vmci_transport, &src)) {
+			drop_pkt = true;
+			err = VMCI_ERROR_NO_ACCESS;
+		} else {
+			/* The local context ID may be out of date, update it. */
+			vsk->local_addr.svm_cid = dst.svm_cid;
+
+			if (sk->sk_state == TCP_ESTABLISHED)
+				vmci_trans(vsk)->notify_ops->handle_notify_pkt(sk, pkt, true,
+									       &dst, &src,
+									       &bh_process_pkt);
+		}
 	}
 
 	bh_unlock_sock(sk);
 
+	if (drop_pkt) {
+		if (vmci_transport_send_reset_bh(&dst, &src, pkt) < 0)
+			pr_err("unable to send reset\n");
+		goto out;
+	}
+
 	if (!bh_process_pkt) {
 		struct vmci_transport_recv_pkt_info *recv_pkt_info;
 
@@ -900,6 +914,7 @@ static void vmci_transport_recv_pkt_work
 {
 	struct vmci_transport_recv_pkt_info *recv_pkt_info;
 	struct vmci_transport_packet *pkt;
+	struct sockaddr_vm src;
 	struct sock *sk;
 
 	recv_pkt_info =
@@ -908,6 +923,12 @@ static void vmci_transport_recv_pkt_work
 	pkt = &recv_pkt_info->pkt;
 
 	lock_sock(sk);
+	vsock_addr_init(&src, pkt->dg.src.context, pkt->src_port);
+	if (sk->sk_state != TCP_LISTEN &&
+	    !vsock_check_source(vsock_sk(sk), &vmci_transport, &src)) {
+		vmci_transport_reply_reset(pkt);
+		goto out;
+	}
 
 	/* The local context ID may be out of date. */
 	vsock_sk(sk)->local_addr.svm_cid = pkt->dg.dst.context;
@@ -937,6 +958,7 @@ static void vmci_transport_recv_pkt_work
 		break;
 	}
 
+out:
 	release_sock(sk);
 	kfree(recv_pkt_info);
 	/* Release reference obtained in the stream callback when we fetched


