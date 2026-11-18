Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040559;
	b=f59nN5v/LwI9k6GXSRg/L3+7Mjv45uthwhQXEjNgWf9xKi4u1rjsbZDwbIGvPWJceflK
	 ApduuivwvA/H8XJRT6r7/3T0kBFIr8JK+RyQWhfayjskMXAGBhI0+mR0zaCBijdj5nV1R
	 vbKtBNQZ6CzXTOIJoUnMDEo9ehyew1fMtfOh/A5IX3ysPLniGqGKmuXC9ISm3Ap0Gue2D
	 qsVWL9m6CTBNc6Q9WGbXZStOBHDtjk+S8mXlDQUBSHdcYId0wpruQ1bZjpqfodmwujY1F
	 YumJY8RbQw+gXyA9m9zfI8F/sD2SX7RKkWj85bE67Hzh82VC0wuU8h9bCMNiNZGNIOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040559;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GZWXehk5T1pfvekDxYxNDn8QmShK7ESGyoDujtxf1+Q=;
	b=kZ2aPG62fySF+Zbx1Urx+HXFVE56uoMvr21105iNDYVpAOhXnX4sy2x06Z6looGhPk3X
	 faM6eXfAIou+iLOAsDblsFVN75YGiXlo3PE/zTZXCKtO9DEARhZudxjypOPQ97dE6IheS
	 kRZg0dXiXi5cgFuTqA3YC47vsSQZF9Z9+vknuDMZbdyOnjxeRHvh8HhW2BM5wXbTZITNu
	 M7nVaMJwWwqhAXGTc1UF8XMEli9bWsQzWTVj+IkVTVk2s35em5r5woQrJ89VIiHUwF7Kg
	 0Qnk34VwsDXmph92NdncijNCv+R43V6plcK5u+LZMw1pAbFE+Q+O+vVvH75mvgT5nwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YDu0oSX6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815F2606A336;
	Wed, 18 Nov 2026 22:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YDu0oSX6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A64831F000C7;
	Wed, 18 Nov 2026 22:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040559;
	bh=GZWXehk5T1pfvekDxYxNDn8QmShK7ESGyoDujtxf1+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YDu0oSX6kGS2HL4jEBnkZVQWm0o5B7JUdjEXsB3GnhNmbDat7CuFPUWxBlOmJw80T
	 0G5YDR3Q3+/8o60RjZ3BWwOUMudUy0DHObDWSQ1QOhTl3Ib9mbbqcg/QdAhwk02bzg
	 vA0/W19AVm2CCZ+cLGoosER0RzNCPO4ysYyaqMqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2493/3318] ipv6: sr: restruct ifdefines
Date: Wed, 18 Nov 2026 15:51:55 +0100
Message-ID: <20261118150436.179026966@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit a79d8fe2ff8e78e549dc86cc853a61b029404871 ]

There are too many ifdef in IPv6 segment routing code that may cause logic
problems. like commit 160e9d275218 ("ipv6: sr: fix invalid unregister error
path"). To avoid this, the init functions are redefined for both cases. The
code could be more clear after all fidefs are removed.

Suggested-by: Simon Horman <horms@kernel.org>
Suggested-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20240529040908.3472952-1-liuhangbin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: f9cb4d296d81 ("seg6: fix HMAC validation when an extension header precedes the SRH")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/seg6.h      |  7 +++++++
 include/net/seg6_hmac.h |  7 +++++++
 net/ipv6/seg6.c         | 33 +++++----------------------------
 3 files changed, 19 insertions(+), 28 deletions(-)

diff --git a/include/net/seg6.h b/include/net/seg6.h
index af668f17b3988..82b3fbbcbb935 100644
--- a/include/net/seg6.h
+++ b/include/net/seg6.h
@@ -52,10 +52,17 @@ static inline struct seg6_pernet_data *seg6_pernet(struct net *net)
 
 extern int seg6_init(void);
 extern void seg6_exit(void);
+#ifdef CONFIG_IPV6_SEG6_LWTUNNEL
 extern int seg6_iptunnel_init(void);
 extern void seg6_iptunnel_exit(void);
 extern int seg6_local_init(void);
 extern void seg6_local_exit(void);
+#else
+static inline int seg6_iptunnel_init(void) { return 0; }
+static inline void seg6_iptunnel_exit(void) {}
+static inline int seg6_local_init(void) { return 0; }
+static inline void seg6_local_exit(void) {}
+#endif
 
 extern bool seg6_validate_srh(struct ipv6_sr_hdr *srh, int len, bool reduced);
 extern struct ipv6_sr_hdr *seg6_get_srh(struct sk_buff *skb, int flags);
diff --git a/include/net/seg6_hmac.h b/include/net/seg6_hmac.h
index 2b5d2ee5613e8..24f733b3e3fe9 100644
--- a/include/net/seg6_hmac.h
+++ b/include/net/seg6_hmac.h
@@ -49,9 +49,16 @@ extern int seg6_hmac_info_del(struct net *net, u32 key);
 extern int seg6_push_hmac(struct net *net, struct in6_addr *saddr,
 			  struct ipv6_sr_hdr *srh);
 extern bool seg6_hmac_validate_skb(struct sk_buff *skb);
+#ifdef CONFIG_IPV6_SEG6_HMAC
 extern int seg6_hmac_init(void);
 extern void seg6_hmac_exit(void);
 extern int seg6_hmac_net_init(struct net *net);
 extern void seg6_hmac_net_exit(struct net *net);
+#else
+static inline int seg6_hmac_init(void) { return 0; }
+static inline void seg6_hmac_exit(void) {}
+static inline int seg6_hmac_net_init(struct net *net) { return 0; }
+static inline void seg6_hmac_net_exit(struct net *net) {}
+#endif
 
 #endif
diff --git a/net/ipv6/seg6.c b/net/ipv6/seg6.c
index 203bff1a6556c..c175d6cb57897 100644
--- a/net/ipv6/seg6.c
+++ b/net/ipv6/seg6.c
@@ -21,9 +21,7 @@
 #include <net/genetlink.h>
 #include <linux/seg6.h>
 #include <linux/seg6_genl.h>
-#ifdef CONFIG_IPV6_SEG6_HMAC
 #include <net/seg6_hmac.h>
-#endif
 
 bool seg6_validate_srh(struct ipv6_sr_hdr *srh, int len, bool reduced)
 {
@@ -440,13 +438,11 @@ static int __net_init seg6_net_init(struct net *net)
 
 	net->ipv6.seg6_data = sdata;
 
-#ifdef CONFIG_IPV6_SEG6_HMAC
 	if (seg6_hmac_net_init(net)) {
 		kfree(rcu_dereference_raw(sdata->tun_src));
 		kfree(sdata);
 		return -ENOMEM;
 	}
-#endif
 
 	return 0;
 }
@@ -455,9 +451,7 @@ static void __net_exit seg6_net_exit(struct net *net)
 {
 	struct seg6_pernet_data *sdata = seg6_pernet(net);
 
-#ifdef CONFIG_IPV6_SEG6_HMAC
 	seg6_hmac_net_exit(net);
-#endif
 
 	kfree(rcu_dereference_raw(sdata->tun_src));
 	kfree(sdata);
@@ -523,41 +517,28 @@ int __init seg6_init(void)
 	if (err)
 		goto out_unregister_pernet;
 
-#ifdef CONFIG_IPV6_SEG6_LWTUNNEL
 	err = seg6_iptunnel_init();
 	if (err)
 		goto out_unregister_genl;
 
 	err = seg6_local_init();
-	if (err) {
-		seg6_iptunnel_exit();
-		goto out_unregister_genl;
-	}
-#endif
+	if (err)
+		goto out_unregister_iptun;
 
-#ifdef CONFIG_IPV6_SEG6_HMAC
 	err = seg6_hmac_init();
 	if (err)
-		goto out_unregister_iptun;
-#endif
+		goto out_unregister_seg6;
 
 	pr_info("Segment Routing with IPv6\n");
 
 out:
 	return err;
-#ifdef CONFIG_IPV6_SEG6_HMAC
-out_unregister_iptun:
-#ifdef CONFIG_IPV6_SEG6_LWTUNNEL
+out_unregister_seg6:
 	seg6_local_exit();
+out_unregister_iptun:
 	seg6_iptunnel_exit();
-#endif
-#endif
-#ifdef CONFIG_IPV6_SEG6_LWTUNNEL
 out_unregister_genl:
-#endif
-#if IS_ENABLED(CONFIG_IPV6_SEG6_LWTUNNEL) || IS_ENABLED(CONFIG_IPV6_SEG6_HMAC)
 	genl_unregister_family(&seg6_genl_family);
-#endif
 out_unregister_pernet:
 	unregister_pernet_subsys(&ip6_segments_ops);
 	goto out;
@@ -565,13 +546,9 @@ int __init seg6_init(void)
 
 void seg6_exit(void)
 {
-#ifdef CONFIG_IPV6_SEG6_HMAC
 	seg6_hmac_exit();
-#endif
-#ifdef CONFIG_IPV6_SEG6_LWTUNNEL
 	seg6_local_exit();
 	seg6_iptunnel_exit();
-#endif
 	genl_unregister_family(&seg6_genl_family);
 	unregister_pernet_subsys(&ip6_segments_ops);
 }
-- 
2.53.0



