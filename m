Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046200;
	b=GwfUXpCXjfxxLwQclsWO8T8bfENqRD3Z5O3sHmkb/fm64UZfPoGfpU4gpsz3l+fgcRE6
	 okj9ScN/t2udSBzBx9Z43nZsIFHYpe/y90zBHG16KbvEzKXmgGb1SZPPnQ1nIYRDLDut/
	 nuXEclYUvU46G7K+bBMjq2cTtMBRMxC9owcS3vsy/xT6MDL172Wi0sv4Gq86dncRzL10a
	 BsWCQnIxaIvJwgwxzCb50Q+jhLFLISYhrMwNog05Y+5IhYjMqc8aMq+RvJ4vG5JUQPJ+Q
	 /UfSGLCkix/zQU2+S0HD/OhRIaWktrLnskj5+WOfPvohFVxnexTPJXi9w/h3OdHdj8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046200;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Yf5s/qdfN0uGZ/nZfZEF5OUm89Pho2tu6EDt9jo2e1c=;
	b=XnSAeauLgT0iVJmtm2NL0L91wt8H1FXtToW9hqjKu5epqcsI4AllXnOSULQfalC5H323
	 dKKRDcs7OjCgxPX7/1BNJZbnkc41JeaZtBDAav2Kmz5jWY16OfGNvMS1D7a84ZGXU19GU
	 ylsUYbB7gtrgyMcElLiEB6WWo4CfcfRBUaZ29k++UoikfBqTOFpN4dt09zXbBkaDsrAlF
	 ezswrdy9BKXlTQdi+vLbuQyxMSjpUv0c56BwTTPtEKvG83OiNyeUAVAPOoF2XZ0u2EPW3
	 y+A+E6ku1t4vIvGlYWtF5/eUIa0ea9DX8w8YY5GQ62/CPdHuQzvVUcefNHsSeRzBaNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0KCFoXoS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8382606A31C;
	Wed, 18 Nov 2026 23:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0KCFoXoS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E1C91F000C4;
	Wed, 18 Nov 2026 23:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046200;
	bh=Yf5s/qdfN0uGZ/nZfZEF5OUm89Pho2tu6EDt9jo2e1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0KCFoXoSiHAPrmZ6EegIvOdXDiLJgCkSiz8+qQMWnUT5mafJhII7MNbw+N7wK9w+f
	 TZ4F/k91bGBvuGDR9RHJqYdlszERI+ZH61/O5XTUyLesgr4YpQ0BicfncASO9+s44B
	 RXFbspH4BliIJiyEzXTVHLuwssPS083fvIRDnZdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Peihan Liu <ronbogo@outlook.com>,
	Yilin Zhu <zylzyl2333@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Eulgyu Kim <eulgyukim@snu.ac.kr>,
	Jaeyoung Chung <jjy600901@snu.ac.kr>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1195/2857] xfrm: espintcp: reorder operations within espintcp_init_sk
Date: Wed, 18 Nov 2026 15:37:09 +0100
Message-ID: <20261118150244.643828470@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit f9a11716c8445b496e9fafeec7e8412d384d02e2 ]

When enabled on a socket, espintcp sets the socket callbacks to its
own before it has finished setting up its context and published it as
icsk_ulp_data. Any one of those callbacks that gets called before will
dereference a NULL icsk_ulp_data.

Fix this by reording the operations, and add memory barriers to ensure
callers will have a struct espintcp_ctx available. Add a few
WRITE_ONCE/READ_ONCE too while we're there.

Fixes: e27cca96cd68 ("xfrm: add espintcp (RFC 8229)")
Cc: stable@vger.kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Reported-by: Peihan Liu <ronbogo@outlook.com>
Reported-by: Yilin Zhu <zylzyl2333@gmail.com>
Reported-by: Ren Wei <n05ec@lzu.edu.cn>
Reported-by: Eulgyu Kim <eulgyukim@snu.ac.kr>
Reported-by: Jaeyoung Chung <jjy600901@snu.ac.kr>
Link: https://lore.kernel.org/all/c30b645074a1b379e0f7fe297f917c66137d9964.1778464688.git.zylzyl2333@gmail.com/
Link: https://lore.kernel.org/all/20260819155349.3555804-1-jjy600901@snu.ac.kr
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/espintcp.h |  5 +++--
 net/xfrm/espintcp.c    | 43 +++++++++++++++++++++++++-----------------
 2 files changed, 29 insertions(+), 19 deletions(-)

diff --git a/include/net/espintcp.h b/include/net/espintcp.h
index 0335bbd76552a..d8fb608ec6ea1 100644
--- a/include/net/espintcp.h
+++ b/include/net/espintcp.h
@@ -34,7 +34,8 @@ static inline struct espintcp_ctx *espintcp_getctx(const struct sock *sk)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
 
-	/* RCU is only needed for diag */
-	return (__force void *)icsk->icsk_ulp_data;
+	/* pairs with smp_wmb() in espintcp_init_sk() */
+	smp_rmb();
+	return (__force void *)READ_ONCE(icsk->icsk_ulp_data);
 }
 #endif
diff --git a/net/xfrm/espintcp.c b/net/xfrm/espintcp.c
index a35a170c39201..d8c3d3d6be7f6 100644
--- a/net/xfrm/espintcp.c
+++ b/net/xfrm/espintcp.c
@@ -432,7 +432,9 @@ static void espintcp_destruct(struct sock *sk)
 
 bool tcp_is_ulp_esp(struct sock *sk)
 {
-	return sk->sk_prot == &espintcp_prot || sk->sk_prot == &espintcp6_prot;
+	const struct proto *prot = READ_ONCE(sk->sk_prot);
+
+	return prot == &espintcp_prot || prot == &espintcp6_prot;
 }
 EXPORT_SYMBOL_GPL(tcp_is_ulp_esp);
 
@@ -464,34 +466,41 @@ static int espintcp_init_sk(struct sock *sk)
 
 	__sk_dst_reset(sk);
 
-	strp_check_rcv(&ctx->strp);
 	skb_queue_head_init(&ctx->ike_queue);
 	skb_queue_head_init(&ctx->out_queue);
+	INIT_WORK(&ctx->work, espintcp_tx_work);
+
+	ctx->saved_data_ready = sk->sk_data_ready;
+	ctx->saved_write_space = sk->sk_write_space;
+	ctx->saved_destruct = sk->sk_destruct;
+
+	/* avoid using task_frag */
+	sk->sk_allocation = GFP_ATOMIC;
+	sk->sk_use_task_frag = false;
+
+	rcu_assign_pointer(icsk->icsk_ulp_data, ctx);
+
+	/* pairs with smp_rmb() in espintcp_getctx() */
+	smp_wmb();
+
+	WRITE_ONCE(sk->sk_data_ready, espintcp_data_ready);
+	WRITE_ONCE(sk->sk_write_space, espintcp_write_space);
+	sk->sk_destruct = espintcp_destruct;
 
 	if (sk->sk_family == AF_INET) {
-		sk->sk_prot = &espintcp_prot;
-		sk->sk_socket->ops = &espintcp_ops;
+		WRITE_ONCE(sk->sk_prot, &espintcp_prot);
+		WRITE_ONCE(sk->sk_socket->ops, &espintcp_ops);
 	} else {
 		mutex_lock(&tcpv6_prot_mutex);
 		if (!espintcp6_prot.recvmsg)
 			build_protos(&espintcp6_prot, &espintcp6_ops, sk->sk_prot, sk->sk_socket->ops);
 		mutex_unlock(&tcpv6_prot_mutex);
 
-		sk->sk_prot = &espintcp6_prot;
-		sk->sk_socket->ops = &espintcp6_ops;
+		WRITE_ONCE(sk->sk_prot, &espintcp6_prot);
+		WRITE_ONCE(sk->sk_socket->ops, &espintcp6_ops);
 	}
-	ctx->saved_data_ready = sk->sk_data_ready;
-	ctx->saved_write_space = sk->sk_write_space;
-	ctx->saved_destruct = sk->sk_destruct;
-	sk->sk_data_ready = espintcp_data_ready;
-	sk->sk_write_space = espintcp_write_space;
-	sk->sk_destruct = espintcp_destruct;
-	rcu_assign_pointer(icsk->icsk_ulp_data, ctx);
-	INIT_WORK(&ctx->work, espintcp_tx_work);
 
-	/* avoid using task_frag */
-	sk->sk_allocation = GFP_ATOMIC;
-	sk->sk_use_task_frag = false;
+	strp_check_rcv(&ctx->strp);
 
 	return 0;
 
-- 
2.53.0



