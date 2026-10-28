Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211570;
	b=IP1q90lBmzjFykgWqqFa8H8X8SBEM79CXrk6CIuK4sFSwUZlfXt6JfSDvtZvw5tNY4/6
	 s6WxxQcg3btvrHbk/eB0DwS2qvtAf1rIt8nEUIQ7unVey9rOT0I7yi5gOfzeZLrDNFfFA
	 xRm7MMJuDgipZRKIExZgB2WhxdQyJEPbDSlHWwBmizBjI4VWay5wbYCHUYRnTvji6X7PP
	 PfZfCVIbs+wxVzFY1rtYJhao9FAcHSOQUHz9hZhqD30SwcpaNByMACXiVMJ1nxNOr3Sm0
	 7044ezbrOomUIpCxR2VFLNJDLZRaRZ2XDG5gpvy/G5VIctGgWQyNAmT4JMO+l/8QUsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211570;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TsoV1HosN7gKFlnjEHDGLUrA6bHb5voq2p1iGH50vmk=;
	b=0QD3d27vyNRFqk5qlaBWE8pWNbOR3IYbueDMs6I8BpSh3LqePPIQXiqzkUbbuZ+ImwTp
	 JlztGJNBbWeYwUL9x2DrnVgmh3PNmL4niJEPXg9aIUVTnh1o1BuNhTATYKdlPGbOH64ND
	 GtkOw45dbFbqeCXdRkG65vlUG/vXW2/I9gAkWg2TKdHPLf/RQOi7du5b4U48WwxAEwM8p
	 weR8CSgbrXcmCLW+tgO482sqqQbUEH1cJg+R9hLHWPyRnJ63mQIOuBAGGpoycXqxFS7cJ
	 PlzTZ2qqbYaiRHA916WMH/I3qtsG4SEkPxHXOPL2FcsSNSFVzwjL+1hvMc3kKpF0RkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1uHCxyJD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F4C606A31F;
	Wed, 28 Oct 2026 18:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1uHCxyJD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 775611F01825;
	Wed, 28 Oct 2026 18:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211570;
	bh=TsoV1HosN7gKFlnjEHDGLUrA6bHb5voq2p1iGH50vmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1uHCxyJDhhCgTUzNCo1LwRwG0Sh/xRw9sL2BJIA+ZmDHrYidtCYYvMkAC4Rlzc+9w
	 A3Ea/sF0xeAhlNfXjKrzg+Jh3DHmf1S1OhWRjuGZmJ95cPSO5B406bnHXHH+/nDuXT
	 Hv8y3rC8am7aGpyn1UwcMTWR7pb7XwGFo3ptsjuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Daehyeon Ko <4ncienth@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 425/571] ip6_gre: remove obsolete ERSPAN PMTU update
Date: Wed, 28 Oct 2026 17:59:32 +0100
Message-ID: <20261028170018.101317597@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

From: Daehyeon Ko <4ncienth@gmail.com>

[ Upstream commit 8bc60db48e8cba35488bbd6e1f94aa990afa275a ]

A tc tunnel_key action can attach a METADATA_IP_TUNNEL dst to an skb,
and mirred can redirect it to a native ip6erspan device. The legacy PMTU
update in ip6erspan_tunnel_xmit() treats that metadata dst as a route.
Since it has no output device, dst_dev(dst)->mtu dereferences NULL.

On v7.2 with KASAN, an initial UID/GID 65534 process with CapEff 0 used
self-created user and network namespaces to trigger:

  KASAN: null-ptr-deref
  RIP: ip6erspan_tunnel_xmit+0x10fc/0x2cc0
  Kernel panic - not syncing: Fatal exception in interrupt

The update is obsolete. Commit fe1a4ca0a2b7 ("ip6_gre: process toobig
in a better way") changed IPv6 GRE Too Big handling to update the
underlay route and removed the equivalent block from __gre6_xmit().
ip6_tnl_xmit() then propagates the underlay PMTU to the overlay route.

Remove the stale ERSPAN copy and its now-unused dst variable. This
eliminates the metadata-dst dereference and keeps ERSPAN aligned with
IPv6 GRE PMTU handling.

Fixes: 5a963eb61b7c ("ip6_gre: Add ERSPAN native tunnel support")
Cc: stable@vger.kernel.org
Suggested-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20261002033058.358137-1-4ncienth@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ sashal: Adjusted PMTU block context for direct dst->dev->mtu access instead of READ_ONCE(dst_dev(dst)->mtu). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_gre.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index fb766066bcb0d..fc1b27cd75541 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -917,7 +917,6 @@ static netdev_tx_t ip6erspan_tunnel_xmit(struct sk_buff *skb,
 {
 	struct ip_tunnel_info *tun_info = NULL;
 	struct ip6_tnl *t = netdev_priv(dev);
-	struct dst_entry *dst = skb_dst(skb);
 	struct net_device_stats *stats;
 	bool truncate = false;
 	int encap_limit = -1;
@@ -1050,10 +1049,6 @@ static netdev_tx_t ip6erspan_tunnel_xmit(struct sk_buff *skb,
 	/* Push GRE header. */
 	gre_build_header(skb, 8, TUNNEL_SEQ, proto, 0, htonl(atomic_fetch_inc(&t->o_seqno)));
 
-	/* TooBig packet may have updated dst->dev's mtu */
-	if (!t->parms.collect_md && dst && dst_mtu(dst) > dst->dev->mtu)
-		dst->ops->update_pmtu(dst, NULL, skb, dst->dev->mtu, false);
-
 	err = ip6_tnl_xmit(skb, dev, dsfield, &fl6, encap_limit, &mtu,
 			   NEXTHDR_GRE);
 	if (err != 0) {
-- 
2.53.0



