Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054239;
	b=RU24s5EdEet18ymXODro+Msrf+oZ1NL7MnY6/sOHWRa8h+AO7hUvMDinGzmSQSGEFNBo
	 dViEy1PnDdxkhxKTmfx/dV81y9bGIERHj/yxjkPHqQ7GMzxQAoL+OvIFqwRhw82SST5M2
	 JEIEaSSCox2879buuhMnqBywyTBAlkCJQSzmMvU9jPI/qQ+5Shn3vyY0Mw65Fxs+R9oL/
	 DdXgBPDQbgpL+A3HzKL7k4HGXds6tTu6kqzoHTtxM7FcWQqIv8pdtvM5QTE/S3P4KvBkh
	 nSMsLDte+bdymGgpkvqxDFjjhOtHS/wLwd5upaFRrWG8aPP1qyRIsP39pEHLOZOeC2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054239;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xM9ww6qS0EK1Ngeyp86oBmk3K/7bkO0w6QxOCeTG+j0=;
	b=gmrpJC4VKkkqmvCVRCcTv783SDkw/cH4MMlhySP5/lWQwZG0XBuftQMB8SZvbuk3axNw
	 4aKxdcTv+Vzhn+EqD2NxZBaGRRdbdUD5D2e12hhuhbXG4N2P/SsTnpqrHP1unasOOFSXQ
	 HsITBKxhNt+Kd+AQkgtMPA5I37M4mD7s95u1mx2dIuLCds6d9njqJJ4bF7CNU9o3Dm2Bo
	 HegryeBqoFzqLLcxjfTOe9hNm6ee9uezNM5Ci258Wmnh5g2h3TXFiZgTXLUts4p0Nb+VE
	 pRUZAYVoZokU21D9+yuuD8zsDQk6W7zVExcJjd1gx4dwG0FGKS68Qbsd/qVQN0jF+Ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R7Nq+gJe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03F63606A31C;
	Thu, 19 Nov 2026 02:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R7Nq+gJe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 434A11F000C4;
	Thu, 19 Nov 2026 02:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054238;
	bh=xM9ww6qS0EK1Ngeyp86oBmk3K/7bkO0w6QxOCeTG+j0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R7Nq+gJekt4a/K9ZcL+V/qKkoudnRqEb0DHzEh+g9f4VScByfUqDlszi6qjdx7gSB
	 4gHmnY1PKZYbXJ1a6fBt1aeBkfzI2yHvhMRj/XSmX4KuUsd2FqYVrcK8OpVAQ9nayn
	 2wSby8l4usse3sdLWKrub8YLgQHglB3ZMyzFSI6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1162/2214] ipv6/addrconf: allocate a per netns hash table
Date: Wed, 18 Nov 2026 15:47:18 +0100
Message-ID: <20261118150058.519565732@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 21a216a8fc630161e69eaf02cbebdd1816ff1a13 ]

Add a per netns hash table and a dedicated spinlock,
first step to get rid of the global inet6_addr_lst[] one.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 6ace56ed7b13 ("ipv6: remove ifaddr from hash during ifdown list cleanup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netns/ipv6.h |  4 ++++
 net/ipv6/addrconf.c      | 20 ++++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/include/net/netns/ipv6.h b/include/net/netns/ipv6.h
index 181b44f6fb686..d38aa787fc159 100644
--- a/include/net/netns/ipv6.h
+++ b/include/net/netns/ipv6.h
@@ -94,6 +94,10 @@ struct netns_ipv6 {
 	struct sock             *tcp_sk;
 	struct sock             *igmp_sk;
 	struct sock		*mc_autojoin_sk;
+
+	struct hlist_head	*inet6_addr_lst;
+	spinlock_t		addrconf_hash_lock;
+
 #ifdef CONFIG_IPV6_MROUTE
 #ifndef CONFIG_IPV6_MROUTE_MULTIPLE_TABLES
 	struct mr_table		*mrt6;
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 9bfb98add9889..e4f1c67c6c511 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -7206,6 +7206,13 @@ static int __net_init addrconf_init_net(struct net *net)
 	int err = -ENOMEM;
 	struct ipv6_devconf *all, *dflt;
 
+	spin_lock_init(&net->ipv6.addrconf_hash_lock);
+	net->ipv6.inet6_addr_lst = kcalloc(IN6_ADDR_HSIZE,
+					   sizeof(struct hlist_head),
+					   GFP_KERNEL);
+	if (!net->ipv6.inet6_addr_lst)
+		goto err_alloc_addr;
+
 	all = kmemdup(&ipv6_devconf, sizeof(ipv6_devconf), GFP_KERNEL);
 	if (!all)
 		goto err_alloc_all;
@@ -7266,11 +7273,15 @@ static int __net_init addrconf_init_net(struct net *net)
 err_alloc_dflt:
 	kfree(all);
 err_alloc_all:
+	kfree(net->ipv6.inet6_addr_lst);
+err_alloc_addr:
 	return err;
 }
 
 static void __net_exit addrconf_exit_net(struct net *net)
 {
+	int i;
+
 #ifdef CONFIG_SYSCTL
 	__addrconf_sysctl_unregister(net, net->ipv6.devconf_dflt,
 				     NETCONFA_IFINDEX_DEFAULT);
@@ -7281,6 +7292,15 @@ static void __net_exit addrconf_exit_net(struct net *net)
 	net->ipv6.devconf_dflt = NULL;
 	kfree(net->ipv6.devconf_all);
 	net->ipv6.devconf_all = NULL;
+
+	/*
+	 *	Check hash table, then free it.
+	 */
+	for (i = 0; i < IN6_ADDR_HSIZE; i++)
+		WARN_ON_ONCE(!hlist_empty(&net->ipv6.inet6_addr_lst[i]));
+
+	kfree(net->ipv6.inet6_addr_lst);
+	net->ipv6.inet6_addr_lst = NULL;
 }
 
 static struct pernet_operations addrconf_ops = {
-- 
2.53.0



