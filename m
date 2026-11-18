Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057098;
	b=jVGiP5loQ0h1Xfo309+M1rUg2brMeYAEPd7RoI51jycLwKOjMkKVTwtTwjG09dh4S7PX
	 +hqSgGqcgAl744zDVy/vHLePSWroUAFK56NRcR3jHIUqgMxkB/PyJS0ArWbuE8FVaNDLR
	 88LDgRJ60W97Egl0jMsvP28jmuviMhDJOnIBeHz0735Szl2Lk1EnbEysy0+5Kug/pAH1P
	 IeHGC0TbieLQGi0oSpd9C4eNM6D+JVNQAdLDJeyBs9mLS1mgWNE9zYRjix2x08TEi80u1
	 nNt8gXoKGfCTTw0tgey4ZacNJRVsaQN+N370JgrthD1vGikgoffTdAkXLgZVURESIjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057098;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f6RqrT0FQ70dLFC+EFqz8GoRIdAxIhdurRYtcj3Rdcw=;
	b=MG4wajCY1ImfbLL2FBQ8OI6l5lyvITCaCwvLLSCgQ2/p1eKGiI4Ae70czOfasXOlAnpk
	 en4fzKAWSZQunX8+wXqKu8ozOg9boPxMnYM/NpSWZn4SVZMRlmNpzMFDZQ/HMfCO0HcSw
	 JYm1GY8mS+RIcUVYd3q0gF2S6n+5/DBCb3KI1LxpV73RuWrYJX3MG+d4TxWustD7FN7TT
	 6HNEEHl4FXhsA6qb3S1RJE2nkLXt4pb1Yi3aLXpDgdwEUHruTHobEMj07PJRwT8LFuCUD
	 t+YPXNImGrznyvUC64FaqSEZFeBkLt4C6lEenDPI3UpBuabXiIkYxAKIQDiXVXu+PfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vwZV0oud;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B28C606A320;
	Thu, 19 Nov 2026 02:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vwZV0oud
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D077D1F000C4;
	Thu, 19 Nov 2026 02:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057098;
	bh=f6RqrT0FQ70dLFC+EFqz8GoRIdAxIhdurRYtcj3Rdcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vwZV0oudkzvrrp/scnpq/7agH4TlBh5mzXGNNmbd8IvWrae9yqkc0dlw9gj3EtHFQ
	 IjgXwQ815qJwRq6IvLocDrJAIA+cc0py9XihItDtyoYv85906zzhHu/e6VB2dY6w72
	 Mf1OEHN3lr1SfYRK3VrZn3FtWNqZKyAopEn8SfDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aswin Karuvally <aswin@linux.ibm.com>,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Alexandra Winter <wintera@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0003/1848] net/iucv: fix the recvmsg window update
Date: Wed, 18 Nov 2026 15:34:01 +0100
Message-ID: <20261118145911.390912025@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryam Vargas <hexlabsecurity@proton.me>

commit fa5acd038ea657ad5033713d6916214cbd349151 upstream.

iucv_sock_recvmsg() sends the HiperSockets-only AF_IUCV_FLAG_WIN without
testing the transport, so on a classic z/VM socket iucv_send_ctrl() sizes
the skb through a NULL iucv->hs_dev. SO_MSGLIMIT accepts 1, so msglimit / 2
is zero and one recvmsg() on its own socket is enough for an unprivileged
process to take a spurious disconnect.

It also calls iucv_send_ctrl() under spin_lock_bh(&message_q.lock), which
allocates GFP_KERNEL inside a section the code treats as atomic. Sending
outside that lock lets two recvmsg() reach afiucv_hs_send() at once, where
msg_recv is sampled for the advertised window and subtracted after
dev_queue_xmit() -- and sendmsg reaches that counter under lock_sock()
while recvmsg holds no socket lock, so both can subtract the same value,
the counter goes negative and the credit reaches the peer twice.

Test the transport, claim the credit with atomic_xchg() after the last
error exit and hand it back if the transmit fails, and send once the lock
is dropped.

Fixes: 3881ac441f64 ("af_iucv: add HiperSockets transport")
Fixes: 238965b71b96 ("net/af_iucv: build proper skbs for HiperTransport")
Cc: stable@vger.kernel.org
Tested-by: Aswin Karuvally <aswin@linux.ibm.com>
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Link: https://patch.msgid.link/20260828-b4-disp-33fac0ed-v3-1-e6d061880ee0@proton.me
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/iucv/af_iucv.c | 41 ++++++++++++++++++++++++-----------------
 1 file changed, 24 insertions(+), 17 deletions(-)

diff --git a/net/iucv/af_iucv.c b/net/iucv/af_iucv.c
index d37e8f4ad4727..034c4c79b898d 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -223,12 +223,6 @@ static int afiucv_hs_send(struct iucv_message *imsg, struct sock *sock,
 	phs_hdr->flags = flags;
 	if (flags == AF_IUCV_FLAG_SYN)
 		phs_hdr->window = iucv->msglimit;
-	else if ((flags == AF_IUCV_FLAG_WIN) || !flags) {
-		confirm_recv = atomic_read(&iucv->msg_recv);
-		phs_hdr->window = confirm_recv;
-		if (confirm_recv)
-			phs_hdr->flags = phs_hdr->flags | AF_IUCV_FLAG_WIN;
-	}
 	memcpy(phs_hdr->destUserID, iucv->dst_user_id, 8);
 	memcpy(phs_hdr->destAppName, iucv->dst_name, 8);
 	memcpy(phs_hdr->srcUserID, iucv->src_user_id, 8);
@@ -261,21 +255,29 @@ static int afiucv_hs_send(struct iucv_message *imsg, struct sock *sock,
 	}
 	skb->protocol = cpu_to_be16(ETH_P_AF_IUCV);
 
+	/* Claim the receive credit here, not while building the header:
+	 * to minimize the time the window is zeroed.
+	 */
+	if (flags == AF_IUCV_FLAG_WIN || !flags) {
+		confirm_recv = atomic_xchg(&iucv->msg_recv, 0);
+		phs_hdr->window = confirm_recv;
+		if (confirm_recv)
+			phs_hdr->flags = phs_hdr->flags | AF_IUCV_FLAG_WIN;
+	}
 	__skb_header_release(skb);
 	nskb = skb_clone(skb, GFP_ATOMIC);
 	if (!nskb) {
 		err = -ENOMEM;
+		atomic_add(confirm_recv, &iucv->msg_recv);
 		goto err_free;
 	}
 
 	skb_queue_tail(&iucv->send_skb_q, nskb);
 	err = dev_queue_xmit(skb);
 	if (net_xmit_eval(err)) {
+		atomic_add(confirm_recv, &iucv->msg_recv);
 		skb_unlink(nskb, &iucv->send_skb_q);
 		kfree_skb(nskb);
-	} else {
-		atomic_sub(confirm_recv, &iucv->msg_recv);
-		WARN_ON(atomic_read(&iucv->msg_recv) < 0);
 	}
 	return net_xmit_eval(err);
 
@@ -1258,6 +1260,7 @@ static int iucv_sock_recvmsg(struct socket *sock, struct msghdr *msg,
 	struct iucv_sock *iucv = iucv_sk(sk);
 	unsigned int copied, rlen;
 	struct sk_buff *skb, *rskb, *cskb;
+	bool send_win = false;
 	int err = 0;
 	u32 offset;
 
@@ -1350,16 +1353,20 @@ static int iucv_sock_recvmsg(struct socket *sock, struct msghdr *msg,
 		if (skb_queue_empty(&iucv->backlog_skb_q)) {
 			if (!list_empty(&iucv->message_q.list))
 				iucv_process_message_q(sk);
-			if (atomic_read(&iucv->msg_recv) >=
-							iucv->msglimit / 2) {
-				err = iucv_send_ctrl(sk, AF_IUCV_FLAG_WIN);
-				if (err) {
-					sk->sk_state = IUCV_DISCONN;
-					sk->sk_state_change(sk);
-				}
-			}
+			if (iucv->transport == AF_IUCV_TRANS_HIPER &&
+			    atomic_read(&iucv->msg_recv) >=
+							iucv->msglimit / 2)
+				send_win = true;
 		}
 		spin_unlock_bh(&iucv->message_q.lock);
+
+		if (send_win) {
+			err = iucv_send_ctrl(sk, AF_IUCV_FLAG_WIN);
+			if (err) {
+				sk->sk_state = IUCV_DISCONN;
+				sk->sk_state_change(sk);
+			}
+		}
 	}
 
 done:
-- 
2.53.0



