Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213459;
	b=Nnd/askjVXkepm1HmilCCD1uMIWvMsAl1FEoVZXfte3DnBFFsrtG4jnMNaNcatzXqQ1I
	 39ndq3u2JkVM/qTZIcRLqwRDtqsEGbW8CrfTiQ9x5ZFbYi4jbXvxyx6EKrGxquwmJjFE+
	 rz4OG8VJOTeQXVgBxCiY15KuWkkcVSmQFvQ4SEBifiNuY5pI8leXKLqhwpTu+EJ7F9a7T
	 VLbJugSjrneMcARjQycnOtCKkQQDixRthlXKFrlfLC+8pd5VOo9C2lo5J536ot1QnfJI6
	 iKSbjTiqEqwSednJD/kztgiifgQ/iGz12G0LsISwAtnAVSBjGTXZo8mxTd21ItqsBZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213459;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+RRT+3TbJxMBVrKOzyu/24XFJzG6RiNhyq3XRiXgYJ4=;
	b=lLc3HGPzw5DaUrUszPvy70aEzBSedkfWWTIjjkl5QtlREw2ntLbcStp7iYVXRSo4c79n
	 bIk3E47Y3mAZRgPzzD1CSlTOG9cKgFxu+tss8hrw884/J2SIm2s5X6vnvc2RyH7F7RMNU
	 hh6GmI14I8oHev4VvO54cMxonKbU/E1Cni0/LHK4Lu0cwcwVnj+u68LOjg8sLcrcrlAc1
	 Ne1BKCEkdSw5wvaLz9/icYcPkR3KH+8DZohY6TYa/MC/UCk9QKKAMGhqmqNB4eootoN7q
	 HO16idY0nMlNhABM/0bmbhuOv/6IT8XM/2LpY2NNyiSYkpTW0ibSpr3kc6ODBsU1zgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tqGBVAff;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3586A606A31C;
	Wed, 28 Oct 2026 18:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tqGBVAff
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 875201F01828;
	Wed, 28 Oct 2026 18:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213459;
	bh=+RRT+3TbJxMBVrKOzyu/24XFJzG6RiNhyq3XRiXgYJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tqGBVAffEwZI2i6ltb9scdTrPfpVl3UBdgrRhyoxLb4nq5TqYZAP+eujsEZReuDi2
	 nhQkgQ8M/GGMhOkWeBdRezy5MhGfl84mbfRsR1POZTHSzoK7PZXPu7TM4vR0G4ycrm
	 XmzAJdDextshUyhxa3yAQur2Q09PhdS7OmbMody4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Daehyeon Ko <4ncienth@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0512/1887] ip6_gre: remove obsolete ERSPAN PMTU update
Date: Wed, 28 Oct 2026 17:43:28 +0100
Message-ID: <20261028170510.965608686@linuxfoundation.org>
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
[ sashal: Adapted the removal to the PMTU check using dst->dev->mtu directly. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_gre.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/ipv6/ip6_gre.c b/net/ipv6/ip6_gre.c
index 950d5e74b094e..73ec4641f2201 100644
--- a/net/ipv6/ip6_gre.c
+++ b/net/ipv6/ip6_gre.c
@@ -962,7 +962,6 @@ static netdev_tx_t ip6erspan_tunnel_xmit(struct sk_buff *skb,
 {
 	struct ip_tunnel_info *tun_info = NULL;
 	struct ip6_tnl *t = netdev_priv(dev);
-	struct dst_entry *dst = skb_dst(skb);
 	bool truncate = false;
 	int encap_limit = -1;
 	__u8 dsfield = false;
@@ -1094,10 +1093,6 @@ static netdev_tx_t ip6erspan_tunnel_xmit(struct sk_buff *skb,
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



