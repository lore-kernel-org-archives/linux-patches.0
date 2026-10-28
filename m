Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216960;
	b=PQJb7AKLn+zDhsOSurBMO5UHdnhrdsU4e/LTSyyXCD7glQccEHmzXCgtpAJf5dyrxoHC
	 WdIdr+UleTgMY9wA/jEcT7r+q9+FqzyJ0VYt7EC4nYu5WqV92glSZldLilEUqwRKaMc7U
	 dWp/3xj5UG6emkp2oMnTKqBE837owHCmGNHTQyRiuZiaEsHca2flEJ6vAKI6G4ON/3Cip
	 /5+vOB57C55V+A5UAnTZE9sgRBWME0Sf31tq+ICLFom96UL0FoQ8gFiD/Enhld13JmCgu
	 PjtMWv9UhJyXEH2A3F3qNHpP7ughi0TT5okuWCqEbgwkbS6XhnBIfiLyzwPerTCnJUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216960;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=o0+QEtSLQbuvW65SrNnNzd5Js/6ASD356qfLKxtd25k=;
	b=e5KEtjUwC7XzdnAXWypqkUOdeeiKieQeeodd/E8l/GOFthcCjYJ5J9suE8To45eZ/O2b
	 J5j3U9KLLidPRfcLfyv3SUiD7HRwsbNMlcsUt77xYFUOR1gVeveeP0xpTRUMaZMqEksQw
	 4XFQ2b5FQcP4FXmX3QjugAG+Ed/53q/qPCBGBt+ZRfcAAbLpzQb5vHG23Nkbq2zCZ4llz
	 K58R1uybjFsmOss4+aIOExFRZCuvPiGNy47xtd/P1hTWfNfXgHuMs+MMh8mi3b6+IeykE
	 JMPfMsWthIsh69R8D7wbcogtYSbxUd48J7rs52jyUUjyCHRvMWDgmM7+Hd+B7y1JAHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wZTI6ud7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEA16606A31C;
	Wed, 28 Oct 2026 19:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wZTI6ud7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A0041F01825;
	Wed, 28 Oct 2026 19:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216959;
	bh=o0+QEtSLQbuvW65SrNnNzd5Js/6ASD356qfLKxtd25k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wZTI6ud7nmGMZAv20ysszVLQsLZw4F4B+LbLz/SNCPYmkGQkfdlwFxYqF4uA59VJG
	 ejyjjwojIOgPUQk97Cv0HySW3w2ud6AALRp29wDuhCy+I226CVKzz7TrCJAueQ9hwZ
	 uWcYAumVkum75aAOgWIC8QntSkuabyiZjMdbDqmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Ido Schimmel <idosch@nvidia.com>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1695/1887] ipv6: flowlabel: cap duplicate leases per socket
Date: Wed, 28 Oct 2026 18:03:11 +0100
Message-ID: <20261028170538.026658478@linuxfoundation.org>
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

From: Zhiling Zou <zhilinz@nebusec.ai>

[ Upstream commit 8d6cd188508513503805c156165de38e4e4a8615 ]

ipv6_flowlabel_get() allocates an ipv6_fl_socklist entry for every
successful GET. The recheck path for a compatible existing flowlabel
links another lease without applying any lease admission check. Repeated
GET requests for one shareable label can therefore grow a socket's lease
list without bound.

Reject a new unprivileged lease once the socket already holds
FL_MAX_PER_SOCK leases. Check this on the shared recheck path so reuse
of a globally interned label, including the fl_intern() collision path,
is covered as well. New-label admission remains under the existing
mem_check() policy.

Use capable(CAP_NET_ADMIN) rather than ns_capable(), matching
mem_check(). An unprivileged user must not bypass the cap by creating a
user namespace and a netns where they have CAP_NET_ADMIN, which would
still consume host memory.

Check the capability only when the socket reaches the limit, so
successful unprivileged GET requests below the cap do not generate a
capability audit. Do the admission check before updating linger and
expires so a rejected GET does not refresh the shared label, matching
the existing socket-list allocation failure path.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Suggested-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/83f8535972ff6e3741548476a1d50dec24c758be.1788415194.git.zhilinz@nebusec.ai
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_flowlabel.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/net/ipv6/ip6_flowlabel.c b/net/ipv6/ip6_flowlabel.c
index eb0d517aa6cb3..ce441f7970a91 100644
--- a/net/ipv6/ip6_flowlabel.c
+++ b/net/ipv6/ip6_flowlabel.c
@@ -460,6 +460,22 @@ fl_create(struct net *net, struct sock *sk, struct in6_flowlabel_req *freq,
 	return NULL;
 }
 
+static bool fl_sock_at_lease_limit(const struct sock *sk)
+{
+	const struct ipv6_pinfo *np = inet6_sk(sk);
+	const struct ipv6_fl_socklist *sfl;
+	int count = 0;
+
+	rcu_read_lock_bh();
+	for_each_sk_fl_rcu(np, sfl) {
+		if (++count >= FL_MAX_PER_SOCK)
+			break;
+	}
+	rcu_read_unlock_bh();
+
+	return count >= FL_MAX_PER_SOCK;
+}
+
 static int mem_check(struct sock *sk)
 {
 	struct ipv6_pinfo *np = inet6_sk(sk);
@@ -670,6 +686,10 @@ static int ipv6_flowlabel_get(struct sock *sk, struct in6_flowlabel_req *freq,
 			err = -ENOMEM;
 			if (!sfl1)
 				goto release;
+			err = -ENOBUFS;
+			if (fl_sock_at_lease_limit(sk) &&
+			    !capable(CAP_NET_ADMIN))
+				goto release;
 			if (fl->linger > fl1->linger)
 				fl1->linger = fl->linger;
 			if ((long)(fl->expires - fl1->expires) > 0)
-- 
2.53.0



