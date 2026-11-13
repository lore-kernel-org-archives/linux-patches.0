Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591016;
	b=pfRnLWDkIwdwqjqvozmc1JFe6dWXQs3xDgVW6zK2W70DnNPn6Uc5s9eQnZSlhwSanu03
	 Ijje6LJG+11LdY6r/LSbYPVKkkdbQDGIv4vcOVKSIOIY8aMiDP5B7L9HVW5geFnFXyPY/
	 FMAOzhtiS/gStLGqTrW66I6Ti1aQvIhhIAIlTHJKKVZeGS7XXjVeX8z/yCNUy/NgKnrzO
	 N3F2vac05zjlrgWKLCtnot/W/oiBqrC/w41Tm6+HdBT25fF93gnJFYvhoy8yyWvPVN+bI
	 GSaliRCn55h1/ibw8ZB/DAvD6dDIfGWsZcjsx7EIia1iiXytCLPZvlC38SE18qNumfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591016;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=my9aJgIetOEI8PLJj/5ASu98MCqNhRLvd4nQBA+V8Ic=;
	b=TSnR1yrYqD6Ogf6hxbvnvvROXeZifi0IUf+X4Dlei8Vm7YK/9vsk7JBuwvNJWN9mqQ72
	 L0S6WxHRCT/htUNyUasoxfkDLyWF8wHmuf1cVqaQhnvFh266oxvW1RvwBJg7EndecJmGb
	 RXMjMnlWJRVcBjM4Xb+hY6lq+sHdbyrwX+FvPrEvB56zB6M6oYpK5KDUjYqSX5KAS1t1M
	 HvBMMduZiXr9f0QpQuQT8cMqYsQ/j0wH6eqoHwS8jfsfQXyIl1saTprSmU/ljz3/F7hFD
	 JAVwsTutA5teHAL4glq3F2Fa0O9ktSacb7ypQAEJ/ugpY1xniTuRmKZ5OFoMlDFV78A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gYdNgJx4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE1E60703F3;
	Fri, 13 Nov 2026 17:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gYdNgJx4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E82191F000C4;
	Fri, 13 Nov 2026 17:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591016;
	bh=my9aJgIetOEI8PLJj/5ASu98MCqNhRLvd4nQBA+V8Ic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gYdNgJx4Hs6e2DuSvCHL9fMQBelh4mHPcOc9BbKTSeqAWw/9fNXPR1oDpt/Fo2JCF
	 Qu5M7gd5u+TQqh122Cyfe4SzalCcH/qtKJD4v53P4ugMCaEMysp1huqtvTN4AQJ2Oa
	 +xPelWxMwLz3ff7KRXJW/E+Af7oXvvuid/u75qCg=
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
Subject: [PATCH 6.12 183/670] xfrm: espintcp: reorder operations within espintcp_init_sk
Date: Fri, 13 Nov 2026 10:45:47 -0500
Message-ID: <20261113153818.228143109@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
index c70efd704b6d5..7cad3c6822df9 100644
--- a/include/net/espintcp.h
+++ b/include/net/espintcp.h
@@ -34,7 +34,8 @@ static inline struct espintcp_ctx *espintcp_getctx(const struct sock *sk)
 {
 	const struct inet_connection_sock *icsk = inet_csk(sk);
 
-	/* RCU is only needed for diag */
-	return (__force void *)icsk->icsk_ulp_data;
+	/* pairs with smp_wmb() in espintcp_init_sk() */
+	smp_rmb();
+	return (__force void *)READ_ONCE(icsk->icsk_ulp_data);
 }
 #endif
diff --git a/net/xfrm/espintcp.c b/net/xfrm/espintcp.c
index c4291ea86d1db..67254678180e8 100644
--- a/net/xfrm/espintcp.c
+++ b/net/xfrm/espintcp.c
@@ -437,7 +437,9 @@ static void espintcp_destruct(struct sock *sk)
 
 bool tcp_is_ulp_esp(struct sock *sk)
 {
-	return sk->sk_prot == &espintcp_prot || sk->sk_prot == &espintcp6_prot;
+	const struct proto *prot = READ_ONCE(sk->sk_prot);
+
+	return prot == &espintcp_prot || prot == &espintcp6_prot;
 }
 EXPORT_SYMBOL_GPL(tcp_is_ulp_esp);
 
@@ -469,34 +471,41 @@ static int espintcp_init_sk(struct sock *sk)
 
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



