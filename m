Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622209;
	b=juq4CJCB2uv+xjsIiI3O4b88Dn+0uQwYcej2FGGmJGcQHoZkwxdueUj/xCdcpOx/KGxl
	 TYbA76eFQfHnxYCUy7AVgbjPhFdi1tBBHYtBU7M/9zxpWmnvjmwztxboxNPd0zDBKoycz
	 4VTy/18puRC333ycFm5NXtYNB1iiZhE+jCsVX/GTodHjD5Bg0cRQJ6mh3bNIO4C8KO531
	 +wY95XJhLUZQNEmUocjZnNdxlw3z5pmkbGPDCOnqMpkrPJx79Xd5k1+Czx05LlPfJ+7sb
	 Zwh1LkJ6Z7ic5Xd9dlFWPuHN581X4CkpO6ZGWlGCVIjSNlPsc96cGQtkWIV5iSPoalw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622209;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2eTNU15hPXL7SCldHi1absY262dFiyrp6p0wx4wU+W4=;
	b=LMYKdQuBP0rSX6M8LYYoxumHxV1vjZKsOX9QFOJ+JHZC2p4T3XR6P0Ft2aw58cRrkYRL
	 si4F82VryF1hhJ+6+y07BOsKvC5Hg9eWmqrLMDugUZKaeeT2tuzfp8T5EOXRdz9mAL+9C
	 fiRLkNh94YLlMgiw3FbIL7n1l8l3gqsBlUFXd5bmCNYBYTFCQXaD5QsL28iVNyHM2DDv/
	 uX1v9Msu1RSuzPr+O2kmbn7SSx1aYhidWuvFGTbWOB1Z668F6jg81sAuJOeoVB/4xzbZn
	 PDfW/VMlg4CGtwoxzIizjEvmJvc5kfjxz8r2xvPHuOqJGqr+amuoXKzukNjQZ1HhDvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0Vc+4kS7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC5CA606A31E;
	Wed, 25 Nov 2026 15:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0Vc+4kS7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 041EC1F000C4;
	Wed, 25 Nov 2026 15:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622208;
	bh=2eTNU15hPXL7SCldHi1absY262dFiyrp6p0wx4wU+W4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Vc+4kS7vExrzMTivH5PFcqToJoUT30zFn7viCL8u1KmrMUZfBayD9TFwWgw0xAw0
	 Z97QGLzrhzokAbJhwxCtpf3wxif9gg6OnvgIVGwOJ1jub1FpiD02b5cqfTdV2pkAhL
	 SUu0nExCyuqJlp+1y3aPMKfy8XAcVxLSG1MzfuGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antonio Quartulli <antonio@mandelbit.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 465/990] udp_tunnel: dont treat IPv4 sockets bound to an address as wildcard
Date: Wed, 25 Nov 2026 15:30:32 +0100
Message-ID: <20261125143832.990228643@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Antonio Quartulli <antonio@mandelbit.com>

[ Upstream commit 612b8376e8112a6f9caaedc25fa48ac42e02826d ]

With IPv6 enabled, sk_saddr_any() checks sk_v6_rcv_saddr also for
AF_INET sockets, where it is always zero. An IPv4 tunnel socket bound to
a specific address (e.g. fou or geneve with "local") ends up in the GRO
lookup fast path, although another socket may bind the same port on a
different address: GRO then hands that socket's packets to the tunnel's
gro_receive.

Check the IPv6 address only for AF_INET6 sockets.

Fixes: a36283e2b683 ("udp_tunnel: create a fastpath GRO lookup.")
Signed-off-by: Antonio Quartulli <antonio@mandelbit.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20261110113306.3698438-1-antonio@mandelbit.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/udp_tunnel_core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/udp_tunnel_core.c b/net/ipv4/udp_tunnel_core.c
index 54386e06a8136..4f7e7d24594aa 100644
--- a/net/ipv4/udp_tunnel_core.c
+++ b/net/ipv4/udp_tunnel_core.c
@@ -62,10 +62,10 @@ EXPORT_SYMBOL(udp_sock_create4);
 static bool sk_saddr_any(struct sock *sk)
 {
 #if IS_ENABLED(CONFIG_IPV6)
-	return ipv6_addr_any(&sk->sk_v6_rcv_saddr);
-#else
-	return !sk->sk_rcv_saddr;
+	if (sk->sk_family == AF_INET6)
+		return ipv6_addr_any(&sk->sk_v6_rcv_saddr);
 #endif
+	return !sk->sk_rcv_saddr;
 }
 
 void setup_udp_tunnel_sock(struct net *net, struct socket *sock,
-- 
2.53.0



