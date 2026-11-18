Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059791;
	b=uqELT8y/AHxFOk1qPKjwzVBbdQBBAzGUxQtm/iYFhr3742C7mqXpfQF1aJITaboz55Mp
	 1vShYj+ha41f+w63deN9VrXC2uIkjUmvCKkYjHVrhmPcooAC+KrAUdHGLc0sLGvf4bxFZ
	 Jgd+0oXv1CEEMX50MKRVZ6e+o8fajvXp4rTWgGgm624G0lld0lq1Im62xzwWYIt2i/l3u
	 BUVZ6hYTd1qS7HhecyuAANWbUoLreAMbJW4s/ui9dQhYB0hG6GHbp69IO7uRJoI+OgL+S
	 2ObKz+K8UuWiercqKojcovsfOsWUJ+VqoH61p+FB8/0LUqCCZCV9OElzsR9hThQC2iA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059791;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=l2drl3phV/B+J1GfL43k7LWubQD9LssEDNPSZS7pFBQ=;
	b=zCpmMGIL55ylmidMlOX/CvhYGBqkMN0LbvRnyySw9+C23vrkq1f9hl8+slwZlYk+/5iO
	 A4KWFYyiOkewvHI8IAsJiLcowR0tNT6yFTiQhzaI5IYoW05HZxQ0BPUHcY6Q9upnZxmZ4
	 fOXEnMqbScg8QjKYwu5fmGi+olWFFdbSBDKocrMIGL0vZR0o5zIipR2irBYDuDdzQT9yc
	 WO8hT0rjb9FYVrPy0hI6CEQ//sReI65uBDkpw3KO/jY0GdsfU4QCbSKNQF4AK+fN/VkkP
	 y7kMzlk1JRMKoUkeGvw3BgqLUQpkx0UKhadfmck3QgquAe4ILL5dn0xyYwz12+LU2Dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BQ3R4KGH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 309A2606A32A;
	Thu, 19 Nov 2026 03:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BQ3R4KGH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 839481F000C4;
	Thu, 19 Nov 2026 03:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059791;
	bh=l2drl3phV/B+J1GfL43k7LWubQD9LssEDNPSZS7pFBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BQ3R4KGHPf4yAIAYkEB0gIMbpBiy7a8uXeoRUDumULEKpo7U2NPVW1y2XYbfUNgdp
	 WUs87vkqmQdz1Pt6Vxm2MncPGXrdMHnxMR/qyWY4HgShI8V25Nm8cdFFHaT6FYUb+a
	 /M9k/Kg7UPKCOiPI6DEdVycdbdCvUw7xy2gzrJpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0967/1848] ipv6/addrconf: allocate a per netns hash table
Date: Wed, 18 Nov 2026 15:50:05 +0100
Message-ID: <20261118145957.438430599@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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
index f179996c61844..4703f8229433c 100644
--- a/include/net/netns/ipv6.h
+++ b/include/net/netns/ipv6.h
@@ -97,6 +97,10 @@ struct netns_ipv6 {
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
index 8daa9f564eec7..8429bd481706f 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -7116,6 +7116,13 @@ static int __net_init addrconf_init_net(struct net *net)
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
@@ -7176,11 +7183,15 @@ static int __net_init addrconf_init_net(struct net *net)
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
@@ -7191,6 +7202,15 @@ static void __net_exit addrconf_exit_net(struct net *net)
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



