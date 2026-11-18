Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035451;
	b=lHBhAv8em+W9kZPdurYk/IX87R/vjoLVFRE6nU5In1SADrjXl9PjThik04qV6VFyHKEF
	 cT0snnYxD5pzTRinLXgqEK6WARqiMhTIN0DWZWjS018NTLlqk1pzkKgJmNh1sRwD9wkpO
	 VurXX9jkI/7io3zDzyziQ+Q/+eNECdaHgCoL4A5MisdsOz0irjB3Y4BlRhRm9w18EZvl4
	 mBtWkpnucDfxrNdSfKFvaPy9OM67+JfJ4SQf0VM4mwoI63rj7C7diw+9x9t0vmp3dJpNd
	 KfKRm1QN/+i5JblLvLg3B6o5IZq+nhZBwx6QOJQkDdbFlsUsbu9uOIUwdHlx4UAHFmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035451;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mtG9sL5315uLfYSmLPpXq1xRpypE0u2nk6bkkGDoVuA=;
	b=vJTEo8I2PMzgIabMPqPA+vSCxGf2nuCpWszIvKQtkTHrmugPbe0CWn2YEDhNOQZaZpgE
	 fYfg2KvZKBMm4L2QoJ2ANWgwqW7Sc1ITqnnUXS40PzWKgCBTrcHPuR83qLuiXv62rMtML
	 MyN7M/W/ytnuyGfOD9v/XjiVeXL/PnJ0240g9Xq6NisbwWBgWK0DTyQ6fMnKF8vtG/Ntj
	 d996XcZYC8RAICviUOMEsRENeG+Sc5+deXlzw+FWI3UUNUSrSrrp5SIBP4TsRaEZRcGEL
	 2YblEFoxJnNL7jmRSKaOhA2ht4HOIVv1ba9uDDpzfW+EBQOWL265EELbDqVPo7wIbkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zoJAMrnN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98160606A31C;
	Wed, 18 Nov 2026 20:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zoJAMrnN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 029721F000C4;
	Wed, 18 Nov 2026 20:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035451;
	bh=mtG9sL5315uLfYSmLPpXq1xRpypE0u2nk6bkkGDoVuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zoJAMrnNa5PYst2LPWFAJy9mUxhBNvvPE6olBH2oY/1WWApnHOkgf5WX5Z8m67GkM
	 ZMyZNaqe+8LyKde0g8aBUa+aTCH7i49Xc2rIKf+F/Ny9YTHSKlzBHZMUW2X6NoU6y9
	 owfeKUMwpjdvmmR3aEYo26Q/svMWdbAKi4nTBHn0=
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
Subject: [PATCH 6.6 0710/3318] rxrpc: Fix double IRQ enablement
Date: Wed, 18 Nov 2026 15:22:12 +0100
Message-ID: <20261118150339.727641909@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 net/rxrpc/recvmsg.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/rxrpc/recvmsg.c b/net/rxrpc/recvmsg.c
index efcba4b2e74f..56fa324d0962 100644
--- a/net/rxrpc/recvmsg.c
+++ b/net/rxrpc/recvmsg.c
@@ -24,6 +24,7 @@ void rxrpc_notify_socket(struct rxrpc_call *call)
 {
 	struct rxrpc_sock *rx;
 	struct sock *sk;
+	unsigned long flags;
 
 	_enter("%d", call->debug_id);
 
@@ -38,16 +39,16 @@ void rxrpc_notify_socket(struct rxrpc_call *call)
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
-- 
2.56.0



