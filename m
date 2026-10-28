Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212453;
	b=YZnAZ5QRkZULlYUrHGmTqLd683HQhakJFQkMJtBK0ph6k8Ur1/shW2V+wb1Izk5W6mOc
	 VTvCk1lcOP/BWpFByVbwtBx+CdUvlbkg6j3c+b2kTNQJ2N7IVehhDjsht216QEpT1EcxU
	 YgzNHVa2gFOzMWxO9jXApBSeNbxiT0ofLUT7OCE+ReQljAT5ztfFedHOhOrv3twNOoI0H
	 gLGn7eYzOGvAEZG9ln1tfdPKMnZdo2rfK5OAicvXHW4qd1+ObXr9Sf4firhpvI4R9gydc
	 7F6wFeub4VVioiKeM4nvguamSWrHvKz92+Y8W5jwOEoh51lXa/E/Pf1NbvUwJNdmzvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212453;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sDKQ/objE5k8Trfn5Eajk5WlUrEFP9VIjpiAs6qWL1A=;
	b=iHTi9tMwnkwFPwu/pcZ6ybh0ksmrQl0DoEx9HSPMdPxOCZXFhgvlHiLOVNSBa2Enhpil
	 jGca48DCwvugM0cXOjdhiPDoo0jS+6StDeheF0FgRqnMa37ivAyBoGnF+w3E93XZ/qtyS
	 4IcdvzUIJ7pOyvzYuzij5JXuroyYptgpyzRHC105nJKjv5ageRXN26vRVoMVxODmUSefQ
	 5oc8JbzkD11XThqCamIOg2w6LlF6d4EoNjE+8e/zklY0Is75ZxBclrYT8wGF8pB0OADNs
	 zbeRZpXHQ2AoN1m/4c3he0HbLidtCDupOyDxKW4XH9KY8banrGks+aScISHXSzRFGAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oYonuhEf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23CE8606A326;
	Wed, 28 Oct 2026 18:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oYonuhEf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 712ED1F01828;
	Wed, 28 Oct 2026 18:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212453;
	bh=sDKQ/objE5k8Trfn5Eajk5WlUrEFP9VIjpiAs6qWL1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oYonuhEfRL2WK8xU8E1y31VANWSmO/WMaIwY22T+kpNa/MWzStiwYeI49vcdrY8F+
	 UJgyarvQ/r29jtcjtCH18n/9r5Ss/lrhsfY2fGESkuO8gh+63PAuFFIDJduWYLQiL9
	 XcVvA/x6fU/L8maGtUm3BpRzK2tGYEIjgM+98/qM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zihan Xi <zihanx@nebusec.ai>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0116/1887] ipmr: account multicast table and route memory
Date: Wed, 28 Oct 2026 17:36:52 +0100
Message-ID: <20261028170501.877217498@linuxfoundation.org>
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
index 8d4f556fced2c..efc31dcbf4d26 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -3145,7 +3145,8 @@ int __init ip_mr_init(void)
 
 	mrt_cachep = kmem_cache_create("ip_mrt_cache",
 				       sizeof(struct mfc_cache),
-				       0, SLAB_HWCACHE_ALIGN | SLAB_PANIC,
+				       0, SLAB_HWCACHE_ALIGN | SLAB_PANIC |
+				       SLAB_ACCOUNT,
 				       NULL);
 
 	err = register_pernet_subsys(&ipmr_net_ops);
diff --git a/net/ipv4/ipmr_base.c b/net/ipv4/ipmr_base.c
index de98ce66d38f3..ae5a685daeeac 100644
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
index 3c60a63c9f31f..944097e9d9873 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -1389,7 +1389,7 @@ int __init ip6_mr_init(void)
 
 	mrt_cachep = kmem_cache_create("ip6_mrt_cache",
 				       sizeof(struct mfc6_cache),
-				       0, SLAB_HWCACHE_ALIGN,
+				       0, SLAB_HWCACHE_ALIGN | SLAB_ACCOUNT,
 				       NULL);
 	if (!mrt_cachep)
 		return -ENOMEM;
-- 
2.53.0



