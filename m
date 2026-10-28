Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214765;
	b=NppzLxYqDY/W6kSLZTow/35ctlB4Q5DSOK0xmqU7IE03g/dy6KQoDG8lvFAqrWVso1E4
	 nxCk0uZpxE9qbHiabPly5Og/XB4gqBiirC+Wj9aG+eg7XD2oGp+JdTxmZBFEHcWDeuOA0
	 WP+KJ4l3gpCn3ApdeyTwG2ehukmKZZubQvzlt+K9n7FHyJKeHZnvai0gm23+6Tw0Oe5xn
	 wAIs+S3LDrdo7CQlVcRNEuZeFCmEw1FzHdggZEiVD/YICvcgewH/njAWpo7TIZV8ZD+if
	 XQab9QRi+72cIjsZLtRVaVDN18yV23wgXzQP5yFQmTfU6OcbRn2hvwskHC6lm5YH6Bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214765;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xQ/OvXOKRq2cnIICsuuzh7gIHwT0e9a2h/PBYoFiSF0=;
	b=mLL771BBpi1cNNkSjir1uHVSrkReOPWIzvKb2MNXjcWtr4PasjitFSegjkhp7kgiPNZa
	 c/PJMbSJh2IruuaCYBpgPuWNEMiOwllgtajObZAirscqvCe0bADnrs553hav2ofd7eYRT
	 J7YlP5dPKvmLskPPKpeYhKCajdSTqHVpmRIqPGyXJlKwUrHVGZgpE3JDGBhVqO9OBHqU2
	 xCdMnTU7GesQXY38uuCjs9t5rK9LjYH3cY084UjxctOjgEpNHeVuzmKaGEAczspjf1fE3
	 pRMHUayjOzgzb0A86jmY+5jX9she75w0Pkd570cJ6L2MA11N062HOhBbeqLsc3GnbQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K3bljQgy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B84F606A330;
	Wed, 28 Oct 2026 19:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K3bljQgy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A03391F01825;
	Wed, 28 Oct 2026 19:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214765;
	bh=xQ/OvXOKRq2cnIICsuuzh7gIHwT0e9a2h/PBYoFiSF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K3bljQgyxhAmGutcaqFTn+bl26WCmtezW5lfX3Xwc5ysUDimck4WtHjJGL9D1jsm+
	 sOT64Nx1atMlRVqiP+2U//bF6wSeuZonwd5w/3i8GxxnuJwB3FkrWEWIyxw7lcLGgJ
	 Z/4O00M+3CYEth9p0TQslrX3KBSkeKclt6fnaGRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+1543a7d954d9c6d00407@syzkaller.appspotmail.com,
	Guoyu Su <yss2813483011xxl@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0974/1887] net: use skb_header_pointer() for TCPv4 GSO frag_off check
Date: Wed, 28 Oct 2026 17:51:10 +0100
Message-ID: <20261028170521.575395781@linuxfoundation.org>
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

From: Guoyu Su <yss2813483011xxl@gmail.com>

[ Upstream commit ddc748a391dd8642ba6b2e4fe22e7f2ddf84b7f0 ]

Syzbot reported a KMSAN uninit-value warning in gso_features_check()
called from netif_skb_features() [1].

gso_features_check() reads iph->frag_off to decide whether to clear
mangleid_features. Accessing the IPv4 header via ip_hdr()/inner_ip_hdr()
can rely on skb header offsets that are not always safe for direct
dereference on packets injected from PF_PACKET paths.

Use skb_header_pointer() for the TCPv4 frag_off check so the header read
is robust whether data is already linear or needs copying.

[1] https://syzkaller.appspot.com/bug?extid=1543a7d954d9c6d00407

Link: https://lore.kernel.org/netdev/willemdebruijn.kernel.1a9f35039caab@gmail.com/
Fixes: cbc53e08a793 ("GSO: Add GSO type for fixed IPv4 ID")
Reported-by: syzbot+1543a7d954d9c6d00407@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1543a7d954d9c6d00407
Tested-by: syzbot+1543a7d954d9c6d00407@syzkaller.appspotmail.com
Signed-off-by: Guoyu Su <yss2813483011xxl@gmail.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260327153507.39742-1-yss2813483011xxl@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index e467e81226396..c8d0f98d375e6 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3633,10 +3633,15 @@ static netdev_features_t gso_features_check(const struct sk_buff *skb,
 	 * IPv4 header has the potential to be fragmented.
 	 */
 	if (skb_shinfo(skb)->gso_type & SKB_GSO_TCPV4) {
-		struct iphdr *iph = skb->encapsulation ?
-				    inner_ip_hdr(skb) : ip_hdr(skb);
+		const struct iphdr *iph;
+		struct iphdr _iph;
+		int nhoff = skb->encapsulation ?
+			    skb_inner_network_offset(skb) :
+			    skb_network_offset(skb);
 
-		if (!(iph->frag_off & htons(IP_DF)))
+		iph = skb_header_pointer(skb, nhoff, sizeof(_iph), &_iph);
+
+		if (!iph || !(iph->frag_off & htons(IP_DF)))
 			features &= ~NETIF_F_TSO_MANGLEID;
 	}
 
-- 
2.53.0



