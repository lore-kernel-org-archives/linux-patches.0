Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617971;
	b=YYRTPSCtdszT03WSykbP9i5B7S2RtqCdHRFSJXAyWhzQiIwyCj+CoTM29+6v8AD0XwOS
	 ovvPQhPxOcye40SgJiDZiIVt8H9P/qjxmHdU1CSoOi3PXpfK0d1HI2Uezlheywt44gxYK
	 zu0jjdNGaBAwDRV182tqYuhNFocyMuHArg8YXkU+7FesS0kRXN2rrocTKd4Yui1z3HuVj
	 MjXr8dI2QbW5wXDNYZ/YmIOKbQnRdnsrWqc8B4ed2riWDtTCOuQjE7CMBTE6xOORDJnqB
	 mj9/KEyVzlYp0J+nu5OZSSKLxJtAR2dojiR1NOmHoc8AWiB4CbtkNcscfOgopMoPnvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617971;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fqB4ZECU+idaFQA90+YiHM9JddqdRCnHnfv3cFDiQn8=;
	b=E1HJ4rjducTkMwTlk8mprO8sSpBRZBov99s2BszM9mtnak4tZiGXC8esOobFSSXLFcdn
	 PTdPfdni7VJ4qK6RcBHjCo7ApTn7iIBFYhr/w/Jq9kJSHiD+nUvnJEGhigcR972Cyi4+f
	 RihDVHzr7r2xYI/5K2OzdAO521u7MO6xgNUTgAGm33NJWTPVCXP/TjkBSrFS6UhnG0NIg
	 8S5bI4ENXeDhmS2UgT+jLkWWOBqAnPHPYl7emREr7mIoEy34r51shRHjZsHS5ju2OXU6r
	 4gKXLmn/Gjy6AQcTBmen3XIV2eRx6JVCk3cYGZTIvsOXCqz5+Tm7VFcMQZ/Ch2RYqrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RBxQBvFp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA23D606A31E;
	Wed, 25 Nov 2026 14:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RBxQBvFp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 979161F000CA;
	Wed, 25 Nov 2026 14:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617970;
	bh=fqB4ZECU+idaFQA90+YiHM9JddqdRCnHnfv3cFDiQn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RBxQBvFpibgq1WEIrvtv4V/IaZuqXVelgYm1gZ0W1FYTwgtVK9MjWOT9zAuBa8ktb
	 oTSwljKN4iYa4jPU4IN1TWwjPNxo4uuCyYeyWN9RX5W5+hUo6YkChvMJkufQta8qTG
	 gSnQ/HMsve670MFauTMi7S1Lx97qW5kIuEtxR5sg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Octavian Purdila <tavip@google.com>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0133/1005] tcp: do not let tcp_collapse() drive sk_forward_alloc negative
Date: Wed, 25 Nov 2026 15:24:31 +0100
Message-ID: <20261125143824.854445195@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit 031c403d13e5046750e2abebd4e770631e7c4627 ]

tcp_collapse() charges each newly allocated skb with skb_set_owner_r()
before the skbs it replaces are freed, without scheduling memory first.

Since sk_mem_uncharge() reclaims eagerly, sk->sk_forward_alloc has no
cushion and can become negative. This can be durable when the collapsed
skbs had a high payload/truesize ratio or were partially read, because
the new skbs can have a bigger total truesize than the old ones.

A negative sk_forward_alloc then confuses tcp_wmem_schedule(), which
can return a negative length to tcp_sendmsg_locked(), triggering
a WARN_ON_ONCE(bytes > INT_MAX) in check_copy_size().

Call sk_forced_mem_schedule() before charging nskb.

Fixes: 4890b686f408 ("net: keep sk->sk_forward_alloc as small as possible")
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Signed-off-by: Octavian Purdila <tavip@google.com>
Signed-off-by: Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 3583867487d7f..8efa1cf5a67cd 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5846,6 +5846,10 @@ tcp_collapse(struct sock *sk, struct sk_buff_head *list, struct rb_root *root,
 			__skb_queue_before(list, skb, nskb);
 		else
 			__skb_queue_tail(&tmp, nskb); /* defer rbtree insertion */
+		/* nskb is charged before the skbs it replaces are freed.
+		 * Make sure sk->sk_forward_alloc can not become negative.
+		 */
+		sk_forced_mem_schedule(sk, nskb->truesize);
 		skb_set_owner_r(nskb, sk);
 		mptcp_skb_ext_move(nskb, skb);
 
-- 
2.53.0



