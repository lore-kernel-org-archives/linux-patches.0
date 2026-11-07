Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061431;
	b=bltMCv3TtEkkpyj+Q62gDtzExtiZhyx9BsE9jLMyhyg/+tbx7odYqT2MzqqfRz4D51Ix
	 mvlBIe8fH3G1WWTVTAnvndizPIVI5gS7EvU6xs8UVuKD3/Hq49b+R4EVbn2rTUzkcutBC
	 eSezLnnDUQUkZP5rwC2RecML2vObtAdTs91WSZT/hKuRSz89uiprGVpXfNeDmrNweZED3
	 LocU6W26pftP4vYWr0g9UXIy9iH1iDHqQGVf/qdJRob9X0u+PesDtqhWITxOutUvootHb
	 HQ1JCg+qtM/wNoIDc62n1kg9f8dPaviaTTccujef1zbqcm6TkeElp7euyqxH1X5YV5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061431;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uL4JNLKoj83xRpvlh7Y+TmrXID0ptWQ9zgCGF/n68ek=;
	b=O4qfFD38FV/pFBEnC7EzRZq9rXf9/qSbFrXFgtx5MoLKQGWe8zqB9iIz5yI2FoT17p2B
	 13nLwwasWwSC80KAsA8tI8pIvrqKnlMq4L5Wy3Y03rWaC2O5pgIF4NWGYPASwR30WpX4Y
	 rTtx01EhoUk265JDr2I8imDphuFLscyqEoUPd5YxHCMYdFKXgR+oQ1yG1E5M3vPdYDDAq
	 XbVDxXoRmb7/WHCF6nYu0uxWoxgvwor24umWAexuH9jz8LVtYioZm7miH9VctzRCE+uAD
	 m/aQKdbXrznk/iHRTJYPSX6FV5WQ21lZmxME44YmcpXDCXoz0FbBrPagHoVy0vg9Pxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QEDE4Sz4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C990606A32F;
	Sat,  7 Nov 2026 14:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QEDE4Sz4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A6861F0089F;
	Sat,  7 Nov 2026 14:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061431;
	bh=uL4JNLKoj83xRpvlh7Y+TmrXID0ptWQ9zgCGF/n68ek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QEDE4Sz4M0NFxXdv2AZmAd2nw2oGF0cWpK+y7CrAlChNd+MmhY2IQZcYCnOrH8q7y
	 6SwbdJYa4tZULBg7xKvi1mqIThQDc1fthuWNEnil8BrUDIqAOgzbaOeky4/NwdUFkn
	 veyUfmlczF/f4ctsC3uqnSw1K47zQLcKdRH24PMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0502/1536] ipv6: Fix redirect exception creation for UDP/RAW sockets
Date: Sat,  7 Nov 2026 08:41:58 -0500
Message-ID: <20261107135011.549493243@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit cd51b74bdd0b75aedf255dc67306a16dd057f7ee ]

When an ICMP Redirect Message is matched to a socket, both IPv4 and IPv6
verify that the source IP of the ICMP packet is the current gateway for
the quoted packet. Both also pass the socket's bound device as the
expected nexthop device.

The difference is that IPv4 treats "oif=0" as "any", whereas IPv6 always
requires an exact match (see ip6_redirect_nh_match()), since the gateway
address is usually a link-local address.

Therefore, when an IPv6 UDP/RAW socket is not bound to a device, the
above verification fails and an exception is not created. This also
happens when the socket is bound to a VRF, as l3mdev_update_flow()
resets the oif to 0.

Fix this by passing the ifindex of the ingress device as the expected
nexthop device. This is consistent with the existing callers of
ip6_redirect(). Note that for ICMPv6 Redirect Message packets the VRF
driver does not reset skb->dev to the VRF device, so skb->dev is
correct, even when it is a VRF port.

Fixes: b55b76b22144 ("ipv6:introduce function to find route for redirect")
Cc: stable@vger.kernel.org
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260828192344.2596928-2-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ sashal: Context line adapted to use the sk->sk_uid field directly, since the sk_uid(sk) accessor doesn't exist in this tree. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/route.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 12940295a2789..94fa1b34be5c3 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3244,7 +3244,7 @@ void ip6_redirect_no_header(struct sk_buff *skb, struct net *net, int oif)
 
 void ip6_sk_redirect(struct sk_buff *skb, struct sock *sk)
 {
-	ip6_redirect(skb, sock_net(sk), sk->sk_bound_dev_if,
+	ip6_redirect(skb, sock_net(sk), skb->dev->ifindex,
 		     READ_ONCE(sk->sk_mark), sk->sk_uid);
 }
 EXPORT_SYMBOL_GPL(ip6_sk_redirect);
-- 
2.53.0



