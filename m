Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774291;
	b=xVSWBC8hBBds6lHKG5s6kNTGH9qKnc17fiPANqvHwqhbaKIynCKdrCDmMRqK5owoTVdC
	 XNRblrnApTVLpuJlY3mr3/tgSifuSKTHovDHz7URRvJPBtsC5rnUnBlooZ7SODAGDG0Sj
	 U7Le27gDQYaIN71nCu4jGdihFmOfuIxAlG41lDJ8P+YBS/p65rgKMyUUwQB/L0V6kamtl
	 vaM6X0XZqNNeEX5Fz3F0uW4bTwmjZeS1JR4Mvu3c7/cTeXLDCuo/62JAwoxY7Q12l2xnI
	 q6yMRcEdZ82jAeaFrKw3/EN0+G5syGHTHNW0vTR3AeIrEitRdTUpOGKjxQ/Y4TyKVzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774291;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8Mn9pgnUCSbpeP8vW+uWiwuYiXiXSH/JSJCzNxwoSH0=;
	b=DUFZxr3iFMv6l87Gne2KHwsYoPYlQZ4w7RtVwkraCYTrpzS2eW39f2Kl1si/3l+Hy5fg
	 CYVHXc+9vrM0ok87vp0vl3TN87x9QLihyvO5pZhVMt6/yaYuu4pk1mAZtoaXyb6Ou53Y7
	 NtZ1zT2WRJNFkO+HAoE/DbYneG9AryqZvrJWSktF2sryKW/n7rfhrzo4XbKCigD1du+/f
	 sKqbC6jeu5BJZOiOHTIa23K62K1+2rHYfMcZKnRdWfmPhtDoM/3h5gT9f2yeLiRmGX8RK
	 sEwaXz0TKFxj+z8stqQ4h+DsE1yvEhPK4hUMlgLdHudRvj082j2x7+dWB3Ours1Y4nQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JFTowyWH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E430606A31A;
	Fri, 23 Oct 2026 16:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JFTowyWH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88FB31F01825;
	Fri, 23 Oct 2026 16:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774291;
	bh=8Mn9pgnUCSbpeP8vW+uWiwuYiXiXSH/JSJCzNxwoSH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JFTowyWHdfwmWowT1/UkLBaqVczdWaCDrwIZ7HH0pEP7JUloI1stiJxCyJtYFoWWP
	 ywwcU7Raoic7rZF4gqPq1jCJUHAUPXbunOM7z0xIG7e6FuUhB8vj57VgbrQCLFlILS
	 JuWx9v/EvKX4Iv70exmbftPtx88sfu+EQ00TRcdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Daehyeon Ko <4ncienth@gmail.com>,
	Vishnu Dasa <vishnu.dasa@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 186/193] vsock/vmci: validate packet source for connected sockets
Date: Fri, 23 Oct 2026 18:37:43 +0200
Message-ID: <20261023163718.620458319@linuxfoundation.org>
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

From: Daehyeon Ko <4ncienth@gmail.com>

[ Upstream commit ad9a7da3fa39c2d616ec0dd3cf6e30531d032fe7 ]

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
[ sashal: Replaced two calls to the unavailable vsock_check_source() helper with equivalent inline conditions. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
Depends on <20261022162527.1685626-1-sashal@kernel.org>

 net/vmw_vsock/vmci_transport.c |   42 ++++++++++++++++++++++++++++++++++-------
 1 file changed, 35 insertions(+), 7 deletions(-)

--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -676,11 +676,13 @@ static int vmci_transport_recv_stream_cb
 	struct vmci_transport_packet *pkt;
 	struct vsock_sock *vsk;
 	bool bh_process_pkt;
+	bool drop_pkt;
 	int err;
 
 	sk = NULL;
 	err = VMCI_SUCCESS;
 	bh_process_pkt = false;
+	drop_pkt = false;
 
 	/* Ignore incoming packets from contexts without sockets, or resources
 	 * that aren't vsock implementations.
@@ -757,17 +759,32 @@ static int vmci_transport_recv_stream_cb
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
+		    (vsk->transport != &vmci_transport ||
+		     src.svm_port != vsk->remote_addr.svm_port ||
+		     (src.svm_cid != vsk->remote_addr.svm_cid &&
+		      vmci_transport.get_local_cid() != VMADDR_CID_LOCAL))) {
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
 
@@ -892,6 +909,7 @@ static void vmci_transport_recv_pkt_work
 {
 	struct vmci_transport_recv_pkt_info *recv_pkt_info;
 	struct vmci_transport_packet *pkt;
+	struct sockaddr_vm src;
 	struct sock *sk;
 
 	recv_pkt_info =
@@ -900,6 +918,15 @@ static void vmci_transport_recv_pkt_work
 	pkt = &recv_pkt_info->pkt;
 
 	lock_sock(sk);
+	vsock_addr_init(&src, pkt->dg.src.context, pkt->src_port);
+	if (sk->sk_state != TCP_LISTEN &&
+	    (vsock_sk(sk)->transport != &vmci_transport ||
+	     src.svm_port != vsock_sk(sk)->remote_addr.svm_port ||
+	     (src.svm_cid != vsock_sk(sk)->remote_addr.svm_cid &&
+	      vmci_transport.get_local_cid() != VMADDR_CID_LOCAL))) {
+		vmci_transport_reply_reset(pkt);
+		goto out;
+	}
 
 	/* The local context ID may be out of date. */
 	vsock_sk(sk)->local_addr.svm_cid = pkt->dg.dst.context;
@@ -929,6 +956,7 @@ static void vmci_transport_recv_pkt_work
 		break;
 	}
 
+out:
 	release_sock(sk);
 	kfree(recv_pkt_info);
 	/* Release reference obtained in the stream callback when we fetched


