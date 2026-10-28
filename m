Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208454;
	b=J8snlMoyMlHm1ZLsKJm9XAuiLSyiy8zvhCf5KAu83kFvr9fhc3jhpFUek3V3Cvt6t7Id
	 ACzsAr2AqAJorTCB+k+DFhsLUlgZzuKYhI2CNPnG/qfVgbDBQeSovAM+HUmpyIxP1qZ97
	 hOhOy8hjflFFhxlUrxJGyXcqJDYvr46IGouKTBgxKeDIHgueJ1IdZ1x9oKy/JhX6up/uR
	 Gi7ZQyLSv/WwHQcqEPEAp9sA+sDfqhw+FSXfs3gv4FXdZVHZLYbNlGpPnUIIqrW6j8Zw9
	 MD/q1oflumB/JlKO/aFWOPwayZrUBo/+McRxkyYwtDNVJq5qgMZr2qDHAkSx51/XEOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208454;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ei3vG4u7gEGeyT7oSDXpb3x9UTvxQQ9w7iLvHEvqGcQ=;
	b=LiUTODXTtTojOZFtt02sdTq+pZrjYPpXVtdF+ESKjntR1iCXrXil5Usk41K3BTaiP/Eg
	 OPKtrc4KLcXuOP0iDi7K6fvpkfRMILcG0KQalYJoD5tR3hMZzQp3K/5VHyMDvBwWbuMoi
	 BgpLXzgB15i7K+Dj2C87YZujzhRkSOPpyPxcTqyPT3qWkTCL7oct/c/5yea6BHpZoDjBK
	 1FLo//yskyNk0HaJYIyFcGSYN5gUpFnF5iqT1PEW2A3xC3G+vuYR9Wm+S894m+kqA7LzY
	 KaKwo8ZF31Es9E8uEH38Cg3vO0JKh/ms0UWU+bLR4ZdGf75YAsJcKVwk0mTol5SfdLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sGMIRp+V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E7A606A31D;
	Wed, 28 Oct 2026 17:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sGMIRp+V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A37AC1F01825;
	Wed, 28 Oct 2026 17:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208454;
	bh=Ei3vG4u7gEGeyT7oSDXpb3x9UTvxQQ9w7iLvHEvqGcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sGMIRp+Vf5Nw6qWHv7+w+w3ilz9Bt307FDwwngVi9dBalY/jUUloYGHMP3ues8tCk
	 5qmAq75f8q3bMddtMcac4raG5wgfIrGCthfWDijbYXFH4nKMwnMKGxBiujVczH946c
	 FALjumcnP8t8SYdPjZnUNyAhFNYmcjAduPCHS1Yc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zihan Xi <zihanx@nebusec.ai>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 098/516] ipmr: account multicast table and route memory
Date: Wed, 28 Oct 2026 17:54:10 +0100
Message-ID: <20261028170005.844305083@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

From: Zihan Xi <zihanx@nebusec.ai>

[ Upstream commit b7ee18725f2292ab554aa96a101ae42d45f008bd ]

A netadmin in a user+net namespace can create many IPv4 and IPv6
multicast routing tables with MRT_TABLE and MRT6_TABLE. Each unseen
id allocates an mr_table via the shared mr_table_alloc(), links it
into the per-net list, and leaves it until netns teardown. Those
objects were not charged to memcg, so the host unreclaimable slab
grows with the table count.

Account mr_table allocations with GFP_KERNEL_ACCOUNT and mark the
IPv4/IPv6 MFC caches SLAB_ACCOUNT. This matches the established
handling of IP addresses, routes and alternate interface names.

Unresolved MFC entries are still allocated from softIRQ with
GFP_ATOMIC and are not charged. They expire after 10 seconds and are
bounded by the socket receive queue; see commit 0079ad8e8dc3
("ipmr: remove hard code cache_resolve_queue_len limit").

Fixes: f0ad0860d01e ("ipv4: ipmr: support multiple tables")
Fixes: d1db275dd3f6 ("ipv6: ip6mr: support multiple tables")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/050b58f7fc6b45da0fb12768ebb62d18fa46133d.1788784801.git.zihanx@nebusec.ai
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ adapted upstream allocation helpers to existing kzalloc() and kmem_cache_create() calls. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ipmr.c      | 3 ++-
 net/ipv4/ipmr_base.c | 2 +-
 net/ipv6/ip6mr.c     | 2 +-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 6e4f91e76e2d3..f17b36a978486 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -3130,7 +3130,8 @@ int __init ip_mr_init(void)
 
 	mrt_cachep = kmem_cache_create("ip_mrt_cache",
 				       sizeof(struct mfc_cache),
-				       0, SLAB_HWCACHE_ALIGN | SLAB_PANIC,
+				       0, SLAB_HWCACHE_ALIGN | SLAB_PANIC |
+				       SLAB_ACCOUNT,
 				       NULL);
 
 	err = register_pernet_subsys(&ipmr_net_ops);
diff --git a/net/ipv4/ipmr_base.c b/net/ipv4/ipmr_base.c
index 8b5b6f196cdc4..fb9796e21074f 100644
--- a/net/ipv4/ipmr_base.c
+++ b/net/ipv4/ipmr_base.c
@@ -38,7 +38,7 @@ mr_table_alloc(struct net *net, u32 id,
 	struct mr_table *mrt;
 	int err;
 
-	mrt = kzalloc(sizeof(*mrt), GFP_KERNEL);
+	mrt = kzalloc(sizeof(*mrt), GFP_KERNEL_ACCOUNT);
 	if (!mrt)
 		return ERR_PTR(-ENOMEM);
 	mrt->id = id;
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index c6fc951b01476..43bb75ea93898 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -1357,7 +1357,7 @@ int __init ip6_mr_init(void)
 
 	mrt_cachep = kmem_cache_create("ip6_mrt_cache",
 				       sizeof(struct mfc6_cache),
-				       0, SLAB_HWCACHE_ALIGN,
+				       0, SLAB_HWCACHE_ALIGN | SLAB_ACCOUNT,
 				       NULL);
 	if (!mrt_cachep)
 		return -ENOMEM;
-- 
2.53.0



