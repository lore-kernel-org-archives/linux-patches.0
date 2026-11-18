Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032604;
	b=ZSrJ1PC83BFQiOdbmwo3sJuJ4QClqi9nYKF/tAWZKGLVx9FzXjHdgfoJ4Ma52lEd7UmV
	 NXi9scmVmt8GxF+ZB9muEGwp1jCMfT+uSYdywPyqpWhfKhueZbTOwsuokXzPSUIRKeydx
	 E1C2g3g/BypkmKA6atMnQd6eR9XoJcmZMXqIBz/+jk76OX1oyZS3y3y61pqyLqIVhpZQK
	 bURcGncTNvYwtyOMlGZBogNJapNtuuUt40nTAcms0OdB4hQNXiF6fWLwZcg4Fn/50/pLo
	 NmhTpE1axftu58l1XEOZSFrGPrTUUlVBnxjgiJa9srQnWkOCyfcg8kruIig+gjK/FZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032604;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=36EfvrW7PNtjqc9Kh9ftQWPL+YFXkMFE3xZnhHLJCxk=;
	b=AS2VORypcob1GvURt8MWk3/30K+2ZPO+jFxHgQO/acYb2W5Elkouv6qEv82r3rN+F2NP
	 INho39DsMXAiCi6FbCUVQmNOekEGt8nIM4kURCsXVgRvRq5SwwpD0RTTZYYkldtZa5MNj
	 Yfj+3651WgdUEAL9pZi9B9GfTUUy4etszYWEj1+WKstzEw45FRw+1NcZpBQzHDb8CR9qE
	 knkxPLtfPWtD1GX8eFNKsZHk9bE0k8U3/NJgbRBien2pcGRO7/o+np06RCN4coLeo31wT
	 iZHsI5+wukttOyuXjYeHf8BJTOn1+4s+sACz9xcMsPp5ovqeJ/Ctuyn0xVVnm0K5Rpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="mo/kHs16";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D82A606A333;
	Wed, 18 Nov 2026 20:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mo/kHs16
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C40701F000C4;
	Wed, 18 Nov 2026 20:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032604;
	bh=36EfvrW7PNtjqc9Kh9ftQWPL+YFXkMFE3xZnhHLJCxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mo/kHs16q24YhqjvEihCTIDitUtIozk2l+WzqZFmykGMq33GuA7ScPl1bhU70p4mA
	 MWdWyAV1KYGyWzR0vlsotbeOKurzECpIxx0MfO21/GByxFDnLBxvABGOqMgM65mAsv
	 RPm4oTDQ89DrgPBPbmEiYFQLSfZA47D8WqriUBUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1463/1756] team: reject CAN, IEEE 802.15.4 and 6LoWPAN devices in team_port_add
Date: Wed, 18 Nov 2026 15:59:50 +0100
Message-ID: <20261118150107.297570199@linuxfoundation.org>
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

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit 9043be310c6a4c5e57f7bba4b9870554eac7aa96 ]

When the first port has a non-Ethernet type, team_setup_by_port()
copies port_dev->type to the team device while netdev_priv() of the
team device still holds a struct team. Several L2 stacks identify their
devices by dev->type alone and then access type specific data that the
team driver never sets up:

- CAN protocols rely on the CAN mid-layer private data (ml_priv)
- IEEE 802.15.4 code dereferences ieee802154_ptr and the mlme ops in
  ml_priv
- the 6LoWPAN netdev notifier writes through lowpan_dev(dev) on
  NETDEV_DOWN and reads it on NETDEV_UP/NETDEV_CHANGE

Enslaving such a device (e.g. vxcan, wpan0, lowpan0) therefore leads to
NULL pointer dereferences or to writes into struct team.

This is the same problem that syzbot reported for the bonding driver
with a vxcan device enslaved to a bond master, which crashed in
can_rx_unregister() and was fixed by commit 8ba68464e478 ("bonding:
refuse to enslave CAN devices"). The team driver has the same gap.

Reject ARPHRD_CAN, ARPHRD_IEEE802154, ARPHRD_IEEE802154_MONITOR and
ARPHRD_6LOWPAN devices in team_port_add().

Link: https://lore.kernel.org/all/b58d98e0-8fe3-4e4e-b8a5-c1c7e647ccca@hartkopp.net/
Link: https://syzkaller.appspot.com/bug?extid=8ed98cbd0161632bce95 # bonding splat
Fixes: 1d76efe1577b ("team: add support for non-ethernet devices")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Reviewed-by: Hangbin Liu <liuhangbin@kylinos.cn>
Link: https://patch.msgid.link/20261019155407.61487-1-socketcan@hartkopp.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/team/team_core.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/team/team_core.c b/drivers/net/team/team_core.c
index 1645a7a2e0767..479d5a51152ef 100644
--- a/drivers/net/team/team_core.c
+++ b/drivers/net/team/team_core.c
@@ -1173,6 +1173,17 @@ static int team_port_add(struct team *team, struct net_device *port_dev,
 		return -EINVAL;
 	}
 
+	if (port_dev->type == ARPHRD_CAN ||
+	    port_dev->type == ARPHRD_IEEE802154 ||
+	    port_dev->type == ARPHRD_IEEE802154_MONITOR ||
+	    port_dev->type == ARPHRD_6LOWPAN) {
+		NL_SET_ERR_MSG(extack,
+			       "CAN, IEEE 802.15.4 and 6LoWPAN devices can't be added as a team port");
+		netdev_err(dev, "Device %s is CAN, IEEE 802.15.4 or 6LoWPAN. These device types can't be added as a team port\n",
+			   portname);
+		return -EINVAL;
+	}
+
 	if (netif_is_team_port(port_dev)) {
 		NL_SET_ERR_MSG(extack, "Device is already a port of a team device");
 		netdev_err(dev, "Device %s is already a port "
-- 
2.53.0



