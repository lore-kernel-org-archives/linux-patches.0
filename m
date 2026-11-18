Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022168;
	b=12CMUMRn70QakY3inJDSbQFOwZta+HYW69smc/X7XmsvqotCgPHZhMb2pLFoUilkpmgg
	 6zJKIpkKC5nUzB5ggXf5vE7LDZ9H+rILEFySJvBXT/RODyOlMDoupmPbnEPVH+OGDELcV
	 hIAL967jD6r5YOAUik8Wiy+XHzoJcHHKTzyevdX4SUf5/kn+7xzDTS07Vu+FdoWyAGnrT
	 o65tS4p5KQrYw0a8Tbyos8FHs/yNv9pjDB3cqALGA5YsuNB6q44RLY/sTZ1QHXuEPkIy7
	 +1UtCvjSpiwK8Pc/HbGyjkD/VBtX3sSXJLM97k46ZeiDdgYAXUPrYGIwCCxKksd9EJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022168;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7WYSvHIO1QnSbdhimy5caDeIsryfAf8tJ1hsM4BeY+g=;
	b=fgYcVVcMq7jIUxltNMDsOapm/1srd8T4DILB7eL8uN3sC+oo0zegRAXPTGqqI/cPYP8b
	 XeYRSy1s6dfLUN4mcz51sel94veIPZxuZU2gHZQ+lS2XxEiC24PnDpEag7PqkJEAUdBzn
	 uuAjLYO5Oa8d79s3jvwzJjscm/tCcmt+Gax0raHh2IaN/lLUtApPP6oQ8q3v4Y4M7sBhJ
	 LDcLqFn052sxVwhKttzw4/aOWJIgbOxPNL1H+f+7CLIJL/XZ5q6Q4gFSGGKe5TouYC3H+
	 UFm/vB4uw8zu6++YfEx3+gcs+pqKqR6XTqUnVD+KelAuluYr6athmh7cb/3uCgae9cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kerc0VRE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43CAC606A31C;
	Wed, 18 Nov 2026 17:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kerc0VRE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 834E01F000C4;
	Wed, 18 Nov 2026 17:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022168;
	bh=7WYSvHIO1QnSbdhimy5caDeIsryfAf8tJ1hsM4BeY+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kerc0VRE5b+yiDgQjJZZMBthXu3+qw9Z1kdi3Z1q4PQrzFEBMiiQtMe93tCMofvp6
	 2CuOIVNz5IpX8gQHxD7othlOsOYf+qMK5h1W7iZJo6BMtrgRIbsonU9gfVIJ/RDjTR
	 2YX5JvtPvry3kh38XSUliVaEofrA25kiwjtYcN6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkui Xiao <xiaolinkui@kylinos.cn>,
	Eric Dumazet <edumazet@kernel.org>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2565/2651] net: bridge: netlink: do not clear the vlan info dump error
Date: Wed, 18 Nov 2026 16:03:25 +0100
Message-ID: <20261118150416.761945793@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index b2cd4e39326d0..8ed86bf71a006 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -540,7 +540,7 @@ static int br_fill_ifinfo(struct sk_buff *skb,
 		else
 			err = br_fill_ifvlaninfo(skb, vg);
 
-		if (port && test_bit(BR_VLAN_TUNNEL_BIT, &port->flags))
+		if (!err && port && test_bit(BR_VLAN_TUNNEL_BIT, &port->flags))
 			err = br_fill_vlan_tunnel_info(skb, vg);
 		rcu_read_unlock();
 		if (err)
-- 
2.53.0



