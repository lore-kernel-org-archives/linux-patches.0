Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033130;
	b=LRf1p0gaXrXhHoGhsdsLHwazKIG5KrIp3HF+066WSHpSlcIFeWoqlIWsxBSdOOF7k0ES
	 kVU4yCF76qW3GTLu5CqE2R9lJOF9DoKZ69NAx/p/ciQkaHXx+P5zxRM7tHG+Y1kqdZ8o0
	 f5YjHUzi+nmEJbmNXc1PbH7xSKv9UZ8XMcBYNok9q8qVsHmshuSCp9jMIwBdpGpKWsLhL
	 +IPqNo0lB4RPLnVj9j6PLmhLAkbBG3alcYnWk46S8P39ax+lLa7+zkUm0rjdDkLdnKaX4
	 Db0g0/q2D0iDSyrs09P1Lr9LbEBlcSl3ATLCVwCacXxJm43ly4HhTFrinFlbgN0UPrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033130;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PF0KL/fhpBxkv59SARITlaAFuqbMAmVqrsXRZlf+994=;
	b=bJj8DTtWBSd1vcjjCVZbO+6U8rcM3EkDz8cQA3AhuUb/zZgKj8Z9+g3skPJVe4+aQfah
	 L9cP2UaCcUQAUSY9XpLn68/6U4CalFikmfiS3QEnE0/puz7gbU5O0DGFQG7qh9WQn99dd
	 /zdlYqUyo4qAzzgufCg0VkhBVrVuFP5Gwa3/TYfcujKiGUFU8sVckrtkg9RaOZHRbPJjC
	 j1C9gOJLUst/VvXDNxNPNVj8I26WlIVL7yunayQZKx8XPCglv+dFzHPu3udObH04Uwi8Y
	 ZO1GT//gx3R994DUBbbpI6q2Oo2aoch25XWZ0WC9PNc3khC1RND6lkKeIzsQV92k+cQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=engcTeDG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36955606A32A;
	Wed, 18 Nov 2026 20:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=engcTeDG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CAD41F000C5;
	Wed, 18 Nov 2026 20:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033130;
	bh=PF0KL/fhpBxkv59SARITlaAFuqbMAmVqrsXRZlf+994=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=engcTeDGDepSx89W5/a8p+DYtBaDNZ3s9H5Jy1+lzgSu9Rkm4QLjxnewUT1iDod5X
	 4iugfETAGDwMfXJ3IZegYmI/wiz7T3q9FESJyPjiZbgBBD4gAlGQ2UeSDIHFL+9Rbv
	 nTAhbNvt6WZ3n1dl60TcLGe2oR75lTSyP5/wDPpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkui Xiao <xiaolinkui@kylinos.cn>,
	Eric Dumazet <edumazet@kernel.org>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1659/1756] net: bridge: netlink: do not clear the vlan info dump error
Date: Wed, 18 Nov 2026 16:03:06 +0100
Message-ID: <20261118150115.760359773@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Linkui Xiao <xiaolinkui@kylinos.cn>

[ Upstream commit fcc00b15cb21a6de76826e5012b2c758505f5e65 ]

br_fill_ifinfo() assigns the result of br_fill_vlan_tunnel_info() over
the result of br_fill_ifvlaninfo() or br_fill_ifvlaninfo_compressed()
instead of only running the second helper when the first one succeeded.

When the vlan information no longer fits in the skb but the port has no
vlan mapped to a tunnel dst, br_fill_vlan_tunnel_info() walks the vlan
list and returns 0 without touching the skb. The -EMSGSIZE is lost,
br_fill_ifinfo() completes a message whose IFLA_AF_SPEC is truncated,
and the dump carries on to the next interface instead of stopping, so
userspace silently sees an incomplete vlan list.

Only fill the tunnel information when the vlan information was filled
successfully.

This was flagged as a pre-existing issue in the Sashiko review of the
net-next series, which noted that the VLAN fill result is overwritten
before it is tested (see the Link tag below). Not triggered or tested.

Fixes: efa5356b0d97 ("bridge: per vlan dst_metadata netlink support")
Link: https://lore.kernel.org/bridge/ed1de95e-e112-4076-93f0-6f7668e657ad@blackwall.org/T/#u#5
Signed-off-by: Linkui Xiao <xiaolinkui@kylinos.cn>
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/20261027085200.1501599-1-xiaolinkui@126.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index deba331537fbe..b8fcad8e64f30 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -534,7 +534,7 @@ static int br_fill_ifinfo(struct sk_buff *skb,
 		else
 			err = br_fill_ifvlaninfo(skb, vg);
 
-		if (port && test_bit(BR_VLAN_TUNNEL_BIT, &port->flags))
+		if (!err && port && test_bit(BR_VLAN_TUNNEL_BIT, &port->flags))
 			err = br_fill_vlan_tunnel_info(skb, vg);
 		rcu_read_unlock();
 		if (err)
-- 
2.53.0



