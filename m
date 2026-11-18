Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021522;
	b=1u9/nIue2+f65r7RbgKvOlKJ4MsHTaiX5Hwzv83jaGfFeT9qXNFCS5ysoBFOFQBM2L/E
	 S17QY+zGRqG6xS9NWVzFoFD/bJBX8utJPo4MbziTPbRAhjNKNxoIZ3i9Dce8idMt4XiWq
	 SR+lMlzWpGl2A7/3JEUrJxkhgtO4Cyv4gi/L9S/17wVN3FcQopyhEtqI2KC8mCqPJtXox
	 RBYwmqkUgeu1NsIYuV0Mmg8rl4SDmJ0IetMFUJFlbh7GIwYO1Eth63mL1DNGMy6XhPTV9
	 57JnTu1iMKDTUYQ0BdnDM/5bF7yLVOuHiV0fJJMfZSEoClsiQHKgCxEJMEoI3DJb5ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021522;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=91GagwmoqcimFIFFSEArkubj9o8ccDXFCU0aNWxf08g=;
	b=hkkO3wFJlnB9gQ6lJP7yZtxh+tjki81B/chpGGQKhGZr2b4kwJvRY0QVV9TMvj0XVuyQ
	 Jz8NvzhzE4QgsSiFwQ/JAT3G1SxzOnSsSxzTwd0lq1TqHH4/F+q9DhTdTtvByoS1t1PTP
	 U2gY7zQtu6iA/uGFfqt6xsA4MySInhmOrBoDgDdp7I4DwUyQUs31o6VOaw6vw31y7HMT4
	 /TXl3HdTDIODzorUnkUwM/6nZBolnkaE8jfzCKgDJiUfjplBqQ0crgxbKDjbgqiA8JzcG
	 QvUpsI9LkAwqGidVW/DgOxHVsZ1jdPM23d11bknBxjqmYFBP0M5eNZSBwwYu6bQ7Q5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="s+A/1KiW";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A58C6606A32C;
	Wed, 18 Nov 2026 17:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s+A/1KiW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 034DB1F000C4;
	Wed, 18 Nov 2026 17:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021522;
	bh=91GagwmoqcimFIFFSEArkubj9o8ccDXFCU0aNWxf08g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s+A/1KiWps822MO5hiXNdrVqCpr4ZvXpBLYlqxKnMzgiV7uar8kkinysfnRIAfwUo
	 S44HoBlxDnZ+2xfMqiCqJPKU8x5SYnPLU1mq44RjLmjSsq8YtohbR15EVV8zkCGEpX
	 Kex6WPs0iQ+8RfuKsbvA8hmGaJy71/zLYEJetrTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jijie Shao <shaojijie@huawei.com>,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2337/2651] net: hibmcge: set netdev_ops before hbg_init() to fix NULL pointer dereference
Date: Wed, 18 Nov 2026 15:59:37 +0100
Message-ID: <20261118150409.243069124@linuxfoundation.org>
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

From: Jijie Shao <shaojijie@huawei.com>

[ Upstream commit 9b8ae9aaa1b8e2b6c1cbf5613d3a37923cf53bc5 ]

The driver assigns netdev_ops after hbg_init(), but hbg_init() calls
hbg_mdio_init() -> hbg_phy_connect() -> phy_connect_direct() ->
phy_attach_direct() -> phy_link_topo_add_phy(), which invokes
netdev_need_ops_lock(). With CONFIG_NET_SHAPER enabled, this function
dereferences dev->netdev_ops->net_shaper_ops. Since netdev_ops is still
NULL at this point, a NULL pointer dereference occurs.

Move the netdev_ops assignment before hbg_init() so that
netdev_need_ops_lock() can safely access netdev_ops during PHY
attachment.

The issue was hit and verified on an evaluation board.

Fixes: ff4edac6e9bd ("net: hibmcge: Implement some .ndo functions")
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
Link: https://patch.msgid.link/20261016110421.2288670-1-shaojijie@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hibmcge/hbg_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hibmcge/hbg_main.c b/drivers/net/ethernet/hisilicon/hibmcge/hbg_main.c
index 66792e2b0fadc..a518dc66d9ef8 100644
--- a/drivers/net/ethernet/hisilicon/hibmcge/hbg_main.c
+++ b/drivers/net/ethernet/hisilicon/hibmcge/hbg_main.c
@@ -448,6 +448,7 @@ static int hbg_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (ret)
 		return ret;
 
+	netdev->netdev_ops = &hbg_netdev_ops;
 	ret = hbg_init(priv);
 	if (ret)
 		return ret;
@@ -460,7 +461,6 @@ static int hbg_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev->pcpu_stat_type = NETDEV_PCPU_STAT_TSTATS;
 	netdev->max_mtu = priv->dev_specs.max_mtu;
 	netdev->min_mtu = priv->dev_specs.min_mtu;
-	netdev->netdev_ops = &hbg_netdev_ops;
 	netdev->watchdog_timeo = 5 * HZ;
 
 	hbg_hw_set_mtu(priv, ETH_DATA_LEN);
-- 
2.53.0



