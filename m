Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028185;
	b=1CHZ+WjqRWggbzETPVpBAEyFgnYYSnJaYik+aYG6IzrqWoNyn7uGYp727aB44QY4Hsgf
	 Mc0nvp7KuuCdFYQZmVWfr2K5hhPawyBUUdBwd8nhcXzxOsu5Fm7dw1JhMP6YW4RuCa9C/
	 yI9W2MmQc9usFG1nBc9IbEWwitkJ+mp86xPobkqRqH3lNXYfiTVJZhQyzXX0EKLxMbs0p
	 /ndmny+5A+2Z90vnuvrFKOM7aSP1JJJBlYYAyML9Kec39aMVnhcMJMhYR57JbVdiUfS0s
	 mnWUwC6hKX59BxMRJZNEhLEeNxzz2VjBcqSoCS22zymBv0hdJWiub/f46Fe7hBzQpSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028185;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ez8bQgTl+1dPql1eUvo0V0h5u2C3dMDS4rOV6JF8Mak=;
	b=xMTZYnB4ifX7EQq0t18TvM9GTncR/uH+CYNPq+hYxj1oQo/xm+FoaEdgWN9H8sw2PEBT
	 aQHraF0+ELWmSwYRdqPVAV3qIZm/Cn7YW1ZfvaExUrWgNNMg/HxF15OImKvudERKXeEsA
	 ZmNWifeuUUhDTQiQcB+BxTN5M+NBcCFLOC1R+VxJLM4F25yMeUHTx7kNG3gRBMdWiKHCp
	 G2v5DNr/0WYwIHLExK+QiHJhj7Vv8KtT2JjprN2FLE7dhIFqBUkQM1eJSdoVt04GQcAnm
	 ORx7Lhkga8PeDMmKXX2c6t7koKuxtPjciq2QVQ5oBC8aGIWNuJFnIZPNpuRHesk8eyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E5amm29g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31269606A31C;
	Wed, 18 Nov 2026 18:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E5amm29g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 824691F000C4;
	Wed, 18 Nov 2026 18:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028185;
	bh=ez8bQgTl+1dPql1eUvo0V0h5u2C3dMDS4rOV6JF8Mak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E5amm29gqLdbjtXI/UuXJzEiTO4Jxh5kD6ISk6PnNjbXcV90EPapwrRpaoQvH91hd
	 fijNQJMhpDZr9AmFT7YhEBrj3PdEg/9p7pdZU+bLkpnQ8xfStwWRNsELXBVNcyhfZG
	 VrIlKj9zE/Yg++iR7Pk3Qk735PyjplDPlbjfK6SA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkui Xiao <xiaolinkui@kylinos.cn>,
	Eric Dumazet <edumazet@kernel.org>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2056/2151] net: bridge: netlink: do not clear the vlan info dump error
Date: Wed, 18 Nov 2026 16:03:11 +0100
Message-ID: <20261118150236.619669121@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 69d6b70b9e5e8..818b588fdf83e 100644
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



