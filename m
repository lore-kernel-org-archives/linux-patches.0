Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214561;
	b=V+g3mvShyKau2A9yonGKBsPBbOmordB3Uoan0QElGDZiPSiKpQRTPzO+H59skfIBQVTo
	 3r7KvxAxwyVTmPoIywgKy/Y4isfeZkvJ8xx9RVKhoqUYy+oi89Y6+qyxf0Xe+Ka9ZXR/+
	 YUU6zOE3Mj+8+Xry/3MrdxOOBloZVEOJL+dCLIH2cqZyBC0zaDvRCAhQlk9/6Q9Wj3SYz
	 YFI4g9ocX92sLKirfH0l7jJxJAPqzCrdimI0387/7WPqCS29tddmznRPCm1vw13URCwRW
	 glhRuRQniC3hVlIRX/+GEkz74pSHY0jyRGkps1LPmeqI6ExqDOnrYPPgb7eFQxHwU7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214561;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Wtp/HWjZpexOUzUooCm47HLkXT2XlpAty60NQFt5ZGo=;
	b=yf3Bjw+9sRrJ2uNYWHrQAlpZZYqDTLgZqBttn+efRAbM4zRlJakpq4kirfSL4wOeJl4R
	 snj5I2cXMAIC4sWgyrvlX8sGXyEvDWr3RRPu3wHsXtoktP5KjMlF+aHV6DzrdatJkIYaU
	 lUZtuSXuXAUoVnotKdw0m7L7wg4zucS5gFoj/+ppjGW6iCSIm2Mzw3Zr0i9K+DeqK+tC8
	 WF6oydDPpC5gLuvohijqf1C6hc6GpPVgy+IxA0Z6wlE17zl+59y7A84yvZoTyJ/JnoVBE
	 Yt0Hmn5ytMx98nRbRh8IRxvc9X9SjtjvWWwDcYeUWMxXiV1zy1qo11v0dY8feQJxUnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mOEbz9Xn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38945606A31C;
	Wed, 28 Oct 2026 19:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mOEbz9Xn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 849CA1F01828;
	Wed, 28 Oct 2026 19:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214561;
	bh=Wtp/HWjZpexOUzUooCm47HLkXT2XlpAty60NQFt5ZGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mOEbz9XnwYEK538CJi9t6OCZvi9e8IiJGHBdGjjQbVaU9eLYQM9c/PeXKbQ44bMqk
	 QU95x0ZOvsxKj2wILSTO0DXFvhsve1YG3C2NJxqFJl3ssxYDv27NylrUgmWgqpG9Dn
	 ctLk3MKxy00/0YMNAl7/IYZgW17HfN0fBY25J36A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0859/1887] tcp_metrics: use dst_dev_net_rcu()
Date: Wed, 28 Oct 2026 17:49:15 +0100
Message-ID: <20261028170518.969065673@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 50c127a69cd6285300931853b352a1918cfa180f ]

Replace three dst_dev() with a lockdep enabled helper.

Fixes: 4a6ce2b6f2ec ("net: introduce a new function dst_dev_put()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20250828195823.3958522-7-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_metrics.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_metrics.c b/net/ipv4/tcp_metrics.c
index 8bf1118e04c66..d3559a9cb2330 100644
--- a/net/ipv4/tcp_metrics.c
+++ b/net/ipv4/tcp_metrics.c
@@ -170,7 +170,7 @@ static struct tcp_metrics_block *tcpm_new(struct dst_entry *dst,
 	struct net *net;
 
 	spin_lock_bh(&tcp_metrics_lock);
-	net = dev_net(dst_dev(dst));
+	net = dst_dev_net_rcu(dst);
 
 	/* While waiting for the spin-lock the cache might have been populated
 	 * with this entry and so we have to check again.
@@ -273,7 +273,7 @@ static struct tcp_metrics_block *__tcp_get_metrics_req(struct request_sock *req,
 		return NULL;
 	}
 
-	net = dev_net(dst_dev(dst));
+	net = dst_dev_net_rcu(dst);
 	hash ^= net_hash_mix(net);
 	hash = hash_32(hash, tcp_metrics_hash_log);
 
@@ -318,7 +318,7 @@ static struct tcp_metrics_block *tcp_get_metrics(struct sock *sk,
 	else
 		return NULL;
 
-	net = dev_net(dst_dev(dst));
+	net = dst_dev_net_rcu(dst);
 	hash ^= net_hash_mix(net);
 	hash = hash_32(hash, tcp_metrics_hash_log);
 
-- 
2.53.0



