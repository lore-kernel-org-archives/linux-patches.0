Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028059;
	b=4PSS+tL51P07JvPRJgOUpq87R34OYIYCES+PhkkRtrfqpt0xcf/93U6UxMONpUQMvXiA
	 ycBCKU+r94z5TMqtRmYRop1+1izacwVNCMokjPbTjDUh0NWu7Iiolf1pSLuiSCIhl5Fso
	 NhthoJ7d+QW3QYjnhYkzBk3+axL/h9YndhpqkDqWo2fxbto/+V5BMJnB7tYDa0C2l7PSx
	 VzreOZEBGeghmHZDY+eg3KL5QUohSLMybK34GpHt+ykxIsfjWuu6TOPCHbtROD3JFQCix
	 RsUYNfdKdJPoECfMBQeQwrEAOUOZX0Edm9ztmkqfWYDy22NcpaB1qBLdmsdDQk33Q0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028059;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fAD27VbfWVm1Nm648ne395oSIZy8wC5g3r3WR5v4wfo=;
	b=hzd4+vYYQA/aEtRDe336rYWJsEefSFmFXTjzztGmA5IH/T+lBxH/6LA1M657iyqJEj48
	 +zr6TVeAXkgMEfDNl5TEhXcR0a0zcsDqw2CKBxKh2l7ecis2Ry4hCu7Fx2+/wbRXij+Ga
	 V4/cwjpDPT6aPf9/sjIgoYihBxEVHk0+XZaaE2quPdb6aW9XEGFbZCG2retEK+YXUAJZj
	 xWtRxZb1UolF4aBUwhwZNTj80djWmC64pmA3ksAclkZn8BZvppkZTgEX1J4ZgawBcAK0S
	 zqmNKpHN7K3sUtUVAjGKG7BQecMxPyyt9AXTA4RhXuOWTPK2t+d/qrifx1HLAxqPleA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yYy97t2N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65FA1606A31C;
	Wed, 18 Nov 2026 18:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yYy97t2N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0D5D1F000C5;
	Wed, 18 Nov 2026 18:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028059;
	bh=fAD27VbfWVm1Nm648ne395oSIZy8wC5g3r3WR5v4wfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yYy97t2N8f9nj6QyWeLt6nfnG1qcrBIuxVhaYsc2OY6LjkrBdKojfgSRr/raD1P/+
	 VeQKnrwC+mZf/XPzsbb4Kq6FyBREdWU32OimAQIPRL9X4SQiPStSora+8HGNmeuHAP
	 Pef8ZmKjAiMQHyI/ZK90gA9sFWP6EkgAA2X5smq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Zhewei Yuan <yzwlhm@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2011/2151] tcp: Fix fastreuse cache initialization on first bind
Date: Wed, 18 Nov 2026 16:02:26 +0100
Message-ID: <20261118150234.981632091@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Zhewei Yuan <yzwlhm@gmail.com>

[ Upstream commit 947ccedf683ed6cc53c1f88ac9eb8747e4567ed6 ]

inet_csk_update_fastreuse() initializes the reuse caches only when
tb->bhash2 is empty, but both inet_csk_get_port() and
__inet_inherit_port() link tb2 before calling it, so the first-bind
branch is never taken.

As a result, SO_REUSEADDR binds never get fastreuse=1 and keep
scanning existing owners, and SO_REUSEPORT starts in STRICT instead
of ANY.

Initialize the caches when tb2 is the only entry in tb->bhash2 and has
no owners. Timewait sockets are also linked on tb2->owners, so this is
equivalent to the old hlist_empty(&tb->owners) test.

Found by manual code inspection and confirmed with GDB. Binding 16000
SO_REUSEADDR sockets to one address/port in a KVM guest takes 4.18 s
before and 19.4 ms after this patch. Existing bind/reuse selftests
pass. Analysis and testing were assisted by an AI tool (Codex).

Fixes: 8002d44fe84d ("tcp: Check hlist_empty(&tb->bhash2) instead of hlist_empty(&tb->owners).")
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Signed-off-by: Zhewei Yuan <yzwlhm@gmail.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Jason Xing <kerneljasonxing@gmail.com>
Link: https://patch.msgid.link/20261026095208.58504-1-yzwlhm@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/inet_connection_sock.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 543a6f2d12dfc..2db9ceda0456a 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -447,7 +447,8 @@ void inet_csk_update_fastreuse(const struct sock *sk,
 {
 	bool reuse = sk->sk_reuse && sk->sk_state != TCP_LISTEN;
 
-	if (hlist_empty(&tb->bhash2)) {
+	if (hlist_is_singular_node(&tb2->bhash_node, &tb->bhash2) &&
+	    hlist_empty(&tb2->owners)) {
 		tb->fastreuse = reuse;
 		if (sk->sk_reuseport) {
 			tb->fastreuseport = FASTREUSEPORT_ANY;
-- 
2.53.0



