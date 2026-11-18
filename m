Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027717;
	b=v5tVSfjjqQnLnXn6akzC/cUVMQU2UZbMAwTnH3H1O69RPHQMpyOQLqY0ngScKvpvrEHX
	 vdNhDRvWQRrkghHOy9jBRbXv88idfMHx+7P77p+u11y46JfV9RxlqV6amxeFf1ExzUWbK
	 r6C/YwESuYAtEFgQkuKZ0e4QGamde/0uXNqRlmKnoMvJKWKzVsySEjjTOI0BRF3Mav2ER
	 pSP4tvbyNa4n97xcrI7D79FJwrfiYl4dohMI5UaiBvQOH2NZqT70C6Bo+aGb2NvcG3Gv/
	 WyOXBpRM5Oml6LWNzo+6AfNJVkGIaox61GmkFDrkDd0Gb1LRI/Bd1dJ9AtYMZN4L1Kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027717;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=moS5e9Vu0eE1LYpWhE/dyIQwoA/LZktA9DTo5b3tO5c=;
	b=TBMZpyh402yhP/LMpKTAlzoWoMBCsGYS1bzM1nlZ4QadpOzv5lWRRzDfvtEIX2R6E4iL
	 B+WzrGCEjH6HwDwF54nqABWNE9Q9cSot/z8F3UdMwF6UlHwrzqDO1L5O6BzjpuG2NnvNh
	 H9s8d3ZUgn58b9MB8Q0J/G5cwqaN8MIml/j3zoZSHNIdtlEPgnI2NNf270fPAr7wQ4S3M
	 WiUKXjPHdZzrfVWh0o00eZziMfAffjZCc5pEa8FHpE2mvJmmmR87XLdHKi81lb68sUWSB
	 lCu1jT0QavQc4SegDh2/KVUtMtTYzdnJUdgeFqeGSY6+Xrql1drX+3+HXZU9THNNMvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="lTJfI/YM";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BFA5606A334;
	Wed, 18 Nov 2026 18:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lTJfI/YM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C4FE1F000C5;
	Wed, 18 Nov 2026 18:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027716;
	bh=moS5e9Vu0eE1LYpWhE/dyIQwoA/LZktA9DTo5b3tO5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lTJfI/YMA/Xl2lZfXnYriV3RF/xvihId0ScFWI9/powtwXOCUZFYIZCxjzFvQEHxL
	 qmRK4ps7sYovRiDC9jq4QDeB0XZ+LPQDdfxvZQgPKOC1H9e4SSnPEBcVhsd+si45mf
	 aXenL/Fyk+QjincWwwvAEvsGAbDJYRANoAqHrtjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jijie Shao <shaojijie@huawei.com>,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1888/2151] net: hibmcge: set netdev_ops before hbg_init() to fix NULL pointer dereference
Date: Wed, 18 Nov 2026 16:00:23 +0100
Message-ID: <20261118150230.573113686@linuxfoundation.org>
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
index cf0f14aa014cf..8af876dde8821 100644
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



