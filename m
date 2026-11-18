Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056689;
	b=DKVemvkIjcgyMFNjYyXtFDnY9vpkhMLm4vadzpU8R7DuRNvEkFTpnvVZAzZ8lVDJgmKf
	 otP9YtSULvvGPbzmnXFxroySQZugDx7TBOB5++rvwYdgkMAzRexAjwb0sJtMy4d9joaJr
	 2jAcy8xnsZMZCUhGmD4fdo7AEb+0ujGPM1E3E+tRmb5iqBsDhVSEhEvp5RlSKxTo8j48N
	 OkejM9n04tPa01UQUTzlmkEZ1T6IABH1p3kc1sn2GXdUH+ipdFVDKfhjBcCW2DvUQMugf
	 oNoLKe3ejxRamGO0qK02/1obqvH0i+fQiCcUFzyAJxxVqZS8KFWUlmpmr/yr8OkMEaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056689;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GJsCBZc5Jqc+OO5eCC9ghyto9c2siSeDKpJNRid6xO8=;
	b=1K/B4s1DlI9jt4ocFuRKYyu3Z5uC7AwPOmaIPz/dsiy4at82X8bqxOcSypxYhNdH4FCC
	 shhe30JpqLm72eHO7ScjgvsiL85cwwbyrqiL45nNY8dAGX1vGH/L2pQFPGD9nKhgu1WJb
	 NxHUOdb+RMHDGhV5SNSpJUaERMDTH8LIOrDe3PlpwPePsNESnpLoqpasRu94ArM2PuM+r
	 /ZKZYdj6IAiQJkEkeihoW9/KmlNh7YDKwP/eVzV5Jb7M3PkOXwsLDR0fdIBp2BDs8fuai
	 0YQqAoZmLcTTpAp+c9G9YwIXlbZI151zIiRz4FgexVdo0uyL0j5J+E4Ls/Rkj4hI5JQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JIUSp8QO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1196606A320;
	Thu, 19 Nov 2026 02:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JIUSp8QO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47EFF1F000C4;
	Thu, 19 Nov 2026 02:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056688;
	bh=GJsCBZc5Jqc+OO5eCC9ghyto9c2siSeDKpJNRid6xO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JIUSp8QOwo2aekkSa46wXyH1LNZwEIVERwTME+XiD3HUqE99qvFQ+4/ucgbx73mMu
	 ItcyGTXJu1KYXHrFMnvgGka4QpWid8z0n652jZf5+6lDYVYtPWD/uXW8ZHT6TSJbHU
	 UsATrdriV3L2Cyq0Nw4xM5Z6BqDwkxmC2HmedGNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2075/2214] team: reject CAN, IEEE 802.15.4 and 6LoWPAN devices in team_port_add
Date: Wed, 18 Nov 2026 16:02:31 +0100
Message-ID: <20261118150133.630674831@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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
 drivers/net/team/team.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index 8c9b56c40f702..64f8215fc2f16 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -1164,6 +1164,17 @@ static int team_port_add(struct team *team, struct net_device *port_dev,
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



