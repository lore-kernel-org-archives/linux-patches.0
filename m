Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042191;
	b=iIS1pLZ79zVxa5RbjrQQQ6jqoINpHAm7gIWqQDcxPZ9fTxN03dtfzLQxTKx357QXvUiX
	 pwRw5ZDRp24Wnz/9MelelG/IwhR7E+4CWZewjp81qpyKizI0aVgSOYERwSjs0zahbgJEj
	 T9vP5f5IwPBRA3kcEjZ6vKnvqjPvY6f3sGY0JPdsw8HaevcRRk+jneHqC2/YrZcCXmaNI
	 g2TQK5XfrinZswS7yOQlgMwwSXVsIRZePCEjGeb95ldpGiCOzfU61bN3ukPNW7DqFq5Ij
	 ajTfIOIHTmqiEgCFUO0MwjSAQ/EPY4xkgM6gCu/q8UjDRotsKcamN2ic1W6FNy/78nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042191;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mnV9aLyZfk96Soz6PmhtAS2T2+OQKUBrIsKtkrZsqeg=;
	b=w6zSiW+U4gfw8Kozj10ajq+LEkl0yqcxjDACZXH3uFpILw+SEaRQz3142ll0M9qPQQH3
	 LKZgWXwwjp7GFqsoYNbkAuFy9LgSjSs7f2goZayutRpNmpLzSZ+b9GohbUlOZV5Y1hmY0
	 AZRSZzh/wqXOtyKpzTi65ngo+I5QKVLyRQn92ERyNpM+X+fh1xZn6NRXsnViI98hwINz0
	 /hPbeNIzgIn74nlQq6WMZ2kaBB7kkeKE8kbUKbWg5FFozlha6tjb6xTNvESU/8dIo16ju
	 astnZpg50OKGGULldQSj52Y8Z7cFNEidxP5jhP9rqD+7zAklZN4zxQ6XgfRL5kouCJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AhOCbw44;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918E5606A31C;
	Wed, 18 Nov 2026 22:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AhOCbw44
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E9791F000C4;
	Wed, 18 Nov 2026 22:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042191;
	bh=mnV9aLyZfk96Soz6PmhtAS2T2+OQKUBrIsKtkrZsqeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AhOCbw44bQmRosG4bNsCbSs2RLsLT15Eu5O+TgSq4kYhn8F9jwFAfAsKeeuoVP8S6
	 7rXhs8/B/Rf02QpmCT87wcziziRC+7UJn3wCiVekB1mdk6nXfeNJId4C4jpXOyDT9D
	 0JNeJGuPKeXEFlBU3kERHLovznkeKpLCoBhuJRDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3083/3318] team: reject CAN, IEEE 802.15.4 and 6LoWPAN devices in team_port_add
Date: Wed, 18 Nov 2026 16:01:45 +0100
Message-ID: <20261118150452.552254689@linuxfoundation.org>
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
index 91abda19a3be0..e9bce9cabf7ae 100644
--- a/drivers/net/team/team_core.c
+++ b/drivers/net/team/team_core.c
@@ -1167,6 +1167,17 @@ static int team_port_add(struct team *team, struct net_device *port_dev,
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



