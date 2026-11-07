Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061800;
	b=t6gNP67++fEh/dHDVmq02e37cg92t4nGXLYcsaBq5L74W8IN6N9oi5/La2afsIHkOTtT
	 iA3A371ZxN4maP4MdM5ie+DaeQm9R0rYmM1mva5vVL3S3Sx18JM/VxcInywXQt8qZoyPh
	 sMy4wNG5H2Ty/q50PRsx3RPs6LfHt523z9UvDnmtpkf+0/hlkcOVI540YRmfdXDJwskGT
	 f0+2Wlg+d8EmX4z4GITGrBl6ZIuraTi0ks+gjqwhEdjw7lwHQVMwULTVA6g6fNWIfFfoE
	 MTBhf9Ex/kW38PePG7ABeie4d0IAhg29lK5hqRkn84T8TFcjS8fEXb4JmxwACexJi5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061800;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CGLqxN2HU/Zab3EUs/WgEOZ7ltb4eklq7ACOvxeyIPw=;
	b=nUJSX9skUhQIACpLMEOnTpvCl49EsKXY+UK+ssgg4tH14TgZN+WpctyHoQ8fmSK6xbUE
	 //j7G9P1PU1yg5JwEeFL1HI9+AYyxYI4r8kxv7qlAJE8JwAb/rxS5tgBYpDe8pPR1B2hB
	 axu6K60Y7Tmw2cexgBcskU6HLxdaD/zQY35NznfoNjS7ZN6lEVpjdx26es+rPwL0vVkyq
	 vPPJCjnTSobXW0/03jBFDKcM0lSzKiivYjjqWSh5nDvRHOnVl6fY49ZRJBa8WPJmQdeI9
	 XLpxbWV448qTM+qzHE4HLYZYwFn1fNbRnAEmMe1OSZUPlolxmoNa/I1vOBZDTMhZtxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n+vpcKCX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 141A5606A335;
	Sat,  7 Nov 2026 14:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n+vpcKCX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D181F008A7;
	Sat,  7 Nov 2026 14:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061799;
	bh=CGLqxN2HU/Zab3EUs/WgEOZ7ltb4eklq7ACOvxeyIPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n+vpcKCXM2o1f4gNyfSCgMM9Tc9lWI00m7XHf41mbyjZE88fA+SW2xFg7nS6SJ7MB
	 1O0P1mP58zy1Uk2yj5tuN2mvZsRxjBXVJhAo+57xbY/cFSLmvV/n/7A+DCXqDGoHMX
	 awtODDIeSnRItWiIS3vxXTIOw3qumJoZJSuR8FSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	linux-afs@lists.infradead.org,
	stable@kernel.org
Subject: [PATCH 6.12 0790/1536] rxrpc: Fix double IRQ enablement
Date: Sat,  7 Nov 2026 08:46:46 -0500
Message-ID: <20261107135019.729711194@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

commit 41eb0af096ba8754e584d47e6de42f1e4980ceae upstream.

rxrpc_notify_socket() explicitly disables and then re-enables IRQs, but one
of its call chains (rxrpc_input_queue_data() -> rxrpc_end_rx_phase() ->
rxrpc_call_completed() -> rxrpc_set_call_completion()) has IRQs disabled
around it.

Fix this by making rxrpc_notify_socket() use irqsave spinlocks.

Fixes: a2ea9a907260 ("rxrpc: Use irq-disabling spinlocks between app and I/O thread")
Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260812110129.979970-6-dhowells@redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: Eric Dumazet <edumazet@google.com>
cc: "David S. Miller" <davem@davemloft.net>
cc: Jakub Kicinski <kuba@kernel.org>
cc: Paolo Abeni <pabeni@redhat.com>
cc: Simon Horman <horms@kernel.org>
cc: linux-afs@lists.infradead.org
cc: stable@kernel.org
Link: https://patch.msgid.link/20261006133011.531806-9-dhowells@redhat.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rxrpc/recvmsg.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -24,6 +24,7 @@ void rxrpc_notify_socket(struct rxrpc_ca
 {
 	struct rxrpc_sock *rx;
 	struct sock *sk;
+	unsigned long flags;
 
 	_enter("%d", call->debug_id);
 
@@ -38,16 +39,16 @@ void rxrpc_notify_socket(struct rxrpc_ca
 	sk = &rx->sk;
 	if (rx && sk->sk_state < RXRPC_CLOSE) {
 		if (call->notify_rx) {
-			spin_lock_irq(&call->notify_lock);
+			spin_lock_irqsave(&call->notify_lock, flags);
 			call->notify_rx(sk, call, call->user_call_ID);
-			spin_unlock_irq(&call->notify_lock);
+			spin_unlock_irqrestore(&call->notify_lock, flags);
 		} else {
-			spin_lock_irq(&rx->recvmsg_lock);
+			spin_lock_irqsave(&rx->recvmsg_lock, flags);
 			if (list_empty(&call->recvmsg_link)) {
 				rxrpc_get_call(call, rxrpc_call_get_notify_socket);
 				list_add_tail(&call->recvmsg_link, &rx->recvmsg_q);
 			}
-			spin_unlock_irq(&rx->recvmsg_lock);
+			spin_unlock_irqrestore(&rx->recvmsg_lock, flags);
 
 			if (!sock_flag(sk, SOCK_DEAD)) {
 				_debug("call %ps", sk->sk_data_ready);


