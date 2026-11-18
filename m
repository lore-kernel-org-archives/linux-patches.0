Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042641;
	b=KinPQktKle5qOLbZ55iy/sLbOsa98m45e77HciLx4zLlJmw1JiPk66Nxc8g2W2uiZ54a
	 /3D3qIorPN4HiT2qG/5Qxn/qx34OfCMeTnbqgARenqnT05JUblY1tzWDZorlx9rLj2iyB
	 IRkfu4tghF+84hxzGtZj6V+q93H4jwBgq1pvEHPWmbngZPCINzrJXYQtxLgojrgjXc3qO
	 6Uvr8F182ONWXr/uCDb8EVuxJOBWvrxC5c2nkHQl7K9Wm8ixNDHjtFGbiRydbYJ6J0uTO
	 f8gy24XR+j6HypgSAfuhIvKR9ViaPREvRmsdGEuSy1c4SUdseEBZ+XFsJOEnVSFPWBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042641;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M2WqFEUMV8ZfUdLGTBOnajYLkMjWJIwSQmcrGMxXp5o=;
	b=ry2R05wxZG9o6M/Ip3+Q2qGFy/HTDLlyB7+qKeq8TfH0xUQFl9Eb3zZ6mUI5gdxOYm+o
	 hEexfYHIpgkuRBsKonsbcTFpVHhFHLkX2yddPS4A7YqaAP0nQTGtJwI81IhPttJVtmNlZ
	 adFsOgEx9i0V5FXJBNjE4hLMYQiCMDINEP7h4vjva1J18zpXBPG2p2w3es73wbufdppmG
	 7cB6z19KN9yT3QhPoetG/0hf0dji0Mv86mpdqnQMItw6aEZzNon0iNe5rwrtYTxXyGC6p
	 KDobE47jQOTZRGVqRq7E83Ry27G8d+5HMqsIBa6YiDe/ylP1COWnfArj7xw87gzOzbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xAqMZVdu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E22606A31C;
	Wed, 18 Nov 2026 22:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xAqMZVdu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 421271F000C4;
	Wed, 18 Nov 2026 22:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042640;
	bh=M2WqFEUMV8ZfUdLGTBOnajYLkMjWJIwSQmcrGMxXp5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xAqMZVduRibWpDm50+6U94G8X0QA5UzJxLMIcrOGupc8jkcakRPbsUfQjv9C4/SIL
	 sIRIKQrryRwGwpKq2H4YNZvlxd2FLe6mrCUG0YbUX5KxRUNwaOIXO88sLTxr4j6rVR
	 mV0kV3RfVJwM3V+hFVQ98wszJZZURnV1Tl3z/1lk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkui Xiao <xiaolinkui@kylinos.cn>,
	Eric Dumazet <edumazet@kernel.org>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3241/3318] net: bridge: netlink: do not clear the vlan info dump error
Date: Wed, 18 Nov 2026 16:04:23 +0100
Message-ID: <20261118150456.905873874@linuxfoundation.org>
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
index f2e2ca01fab78..45cfb68a0e54f 100644
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



