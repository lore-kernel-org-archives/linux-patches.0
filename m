Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212704;
	b=K4QMMQjVG2IHnPYiQVJWGN1z7PPRCV82muWAuzZJBzFJmKhN3pGJW9Utzk771tIM3ogX
	 0yd6siDtK3TY/pySxYrEmI6fephlBm8LwC6iRM3cTsH1TChlDdm12cC/tHb+GrkO5Kxrb
	 CwPo56/siiQwxG1J5s+YthcpX5+6q3ad7Jyqlu2lJqNZWhYnnmPS6/sAW8uSrY+bsO0hF
	 tOuJkoxB/ZoGQxtyDtR1SXOEofHxaJLXzmBujIom1iPFCFD6BvnziNcWv2KfWHeSrk0qm
	 joLomZ3PuGkklHHjK8mABGbkSMJJCIJv34hUKPG0I/XABzyWkcdACLwM3g3DmbS+6iw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212704;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9ujm5nDIyUU2LJ1VQ7zUPiz81kUKLPUMgbw0zmrQltE=;
	b=HtJUei/V6VsUkhowjPJVXLHU8/uSYLNcVaxo8Pv0WQFlZPoTzze9zOwsTEvne5BTlt/Y
	 fGrdcnsVON5kpwYBdVieko0AZMVv7OHvVzp2z8NRiz8tiwt178XSn6BWXlEnfs4skSnTk
	 akftKVfBBrEDhEgSMmXp8qiGSzaqL2SRTm3VQnEW4/AZsixQvg6mf7GTgZEl9Q+byawZe
	 fWT5AiqUubQGwAQRfK35XZwGJHeZSn+0RlG3GJ5GJKbvP+PXgntXhSszIRZm3jrB4Njpg
	 vB+vFOQKow9/5KKNGxyyM4xFWa0dsXmBmnOEi22kXyEultMEJpub6ydL/Rm72vDfFlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="gNl/Qi5z";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A700606A31A;
	Wed, 28 Oct 2026 18:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gNl/Qi5z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 119B81F01825;
	Wed, 28 Oct 2026 18:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212703;
	bh=9ujm5nDIyUU2LJ1VQ7zUPiz81kUKLPUMgbw0zmrQltE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gNl/Qi5zlxkqsGgkGnFteJqntNvcn8PYqFjXGFU/Sqrs2B980VgD5/LnDMX9Kjp8R
	 97YSeH6g+CyJGjB1Wl7GJFz8vWA7wdnvj2fS+WIQ9U0OeC9rBbic7FFJUxy7R6WJ25
	 /zWkb0Pr8hYul+SG9IXNtstpP9M57ZANhF4bGp4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Freimanis <quentin@q-lab.dev>,
	Simon Horman <horms@kernel.org>,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0245/1887] net: sparx5: make ports inherit the switch base mac address type
Date: Wed, 28 Oct 2026 17:39:01 +0100
Message-ID: <20261028170504.806839281@linuxfoundation.org>
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

From: Quentin Freimanis <quentin@q-lab.dev>

[ Upstream commit 5642b1648d5c4561d8ed7a410d0a7017f706604d ]

When the switch uses a random base MAC address it does not mark each
port's address as random:

  $ dmesg | grep "MAC addr"
  sparx5-switch e00c0000.switch: MAC addr was not set, use random MAC
  $ cat /sys/class/net/eth0/addr_assign_type
  0

0 is NET_ADDR_PERM, so userspace thinks this is a stable address.

With a random MAC reported as NET_ADDR_PERM, systemd's
MACAddressPolicy=persistent [1] leaves it unchanged, so a DHCP client
gets a new IP address every boot and a static reservation can't be used.
Reporting it as NET_ADDR_RANDOM makes systemd replace it with a stable
address derived from the interface name and machine-id.

Fixes: f3cad2611a77 ("net: sparx5: add hostmode with phylink support")
Signed-off-by: Quentin Freimanis <quentin@q-lab.dev>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
Link: https://patch.msgid.link/20260928045012.30178-1-quentin@q-lab.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_main.c   | 1 +
 drivers/net/ethernet/microchip/sparx5/sparx5_main.h   | 1 +
 drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c | 1 +
 3 files changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
index 1ed69e77b8958..fbff85b52472c 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
@@ -828,6 +828,7 @@ static int mchp_sparx5_probe(struct platform_device *pdev)
 		dev_info(sparx5->dev, "MAC addr was not set, use random MAC\n");
 		eth_random_addr(sparx5->base_mac);
 		sparx5->base_mac[5] = 0;
+		sparx5->base_mac_assign_type = NET_ADDR_RANDOM;
 	}
 
 	sparx5->fdma_irq = platform_get_irq_byname(sparx5->pdev, "fdma");
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
index cb3173d2b0e8d..6d01585dbedff 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
@@ -255,6 +255,7 @@ struct sparx5 {
 	struct notifier_block switchdev_blocking_nb;
 	/* Switch state */
 	u8 base_mac[ETH_ALEN];
+	u8 base_mac_assign_type;
 	/* Associated bridge device (when bridged) */
 	struct net_device *hw_bridge_dev;
 	/* Bridged interfaces */
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c b/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
index d078156581d54..090aa6c14a0f1 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
@@ -270,6 +270,7 @@ struct net_device *sparx5_create_netdev(struct sparx5 *sparx5, u32 portno)
 	ndev->ethtool_ops = &sparx5_ethtool_ops;
 
 	eth_hw_addr_gen(ndev, sparx5->base_mac, portno + 1);
+	ndev->addr_assign_type = sparx5->base_mac_assign_type;
 
 	return ndev;
 }
-- 
2.53.0



