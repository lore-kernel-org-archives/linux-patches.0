Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D21A36FB5
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:40:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40AD2C433C7;
	Sun, 17 Sep 2023 20:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694983250;
	bh=q124JuZa/LbmWjJNMz639fT7ZOVoDDS6xFlicZHghlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IO5F7fqXPwVxPkaIeSr9jcn4V9Uw+1GUEmdnrsputwV/WRaIvMq5Q449xtsXVloca
	 VZg894RKBuak5k71F9LToh+6jv9fOInkwsDpu19yE7fiDRPlfZQiIhMfcNwntWeUTY
	 OxuRPyc1nOY8QMmUdC3rtJ7yTQgKhjKWdwHyllCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Wang <wangjie125@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 461/511] net: hns3: remove GSO partial feature bit
Date: Sun, 17 Sep 2023 21:14:48 +0200
Message-ID: <20230917191124.884162526@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jie Wang <wangjie125@huawei.com>

[ Upstream commit 60326634f6c54528778de18bfef1e8a7a93b3771 ]

HNS3 NIC does not support GSO partial packets segmentation. Actually tunnel
packets for example NvGRE packets segment offload and checksum offload is
already supported. There is no need to keep gso partial feature bit. So
this patch removes it.

Fixes: 76ad4f0ee747 ("net: hns3: Add support of HNS3 Ethernet Driver for hip08 SoC")
Signed-off-by: Jie Wang <wangjie125@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 2acf50ed6025a..3693ff55197dd 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -3118,8 +3118,6 @@ static void hns3_set_default_feature(struct net_device *netdev)
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 
-	netdev->gso_partial_features |= NETIF_F_GSO_GRE_CSUM;
-
 	netdev->features |= NETIF_F_HW_VLAN_CTAG_FILTER |
 		NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX |
 		NETIF_F_RXCSUM | NETIF_F_SG | NETIF_F_GSO |
-- 
2.40.1



