Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8D292FC4E;
	Fri, 24 Nov 2023 18:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nTy5DhyO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DC09C433C7;
	Fri, 24 Nov 2023 18:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850768;
	bh=QgP5+tLrOczJdto5+CIodlHsUrZVaiXfpAGLxYfdZKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nTy5DhyOO7MWRMAqnNQgZi/OBsBDzt3NAwiX401irD0SVsxBmV5NUhmGHZGTl9eDe
	 i9Yq0DY6ZhQ0c8l4r/dOwFYnFEiIMCa2Nk24RJ4V53yRIU4eSzCTZkr8EWnqnkyvzu
	 nHew9SR7hwjDjQ4FCwC4PEwl74gHxcVL0LGdJpuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonglong Liu <liuyonglong@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 181/491] net: hns3: fix variable may not initialized problem in hns3_init_mac_addr()
Date: Fri, 24 Nov 2023 17:46:57 +0000
Message-ID: <20231124172029.915844634@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yonglong Liu <liuyonglong@huawei.com>

[ Upstream commit dbd2f3b20c6ae425665b6975d766e3653d453e73 ]

When a VF is calling hns3_init_mac_addr(), get_mac_addr() may
return fail, then the value of mac_addr_temp is not initialized.

Fixes: 76ad4f0ee747 ("net: hns3: Add support of HNS3 Ethernet Driver for hip08 SoC")
Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 71a2ec03f2b38..f644210afb70a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -5139,7 +5139,7 @@ static int hns3_init_mac_addr(struct net_device *netdev)
 	struct hns3_nic_priv *priv = netdev_priv(netdev);
 	char format_mac_addr[HNAE3_FORMAT_MAC_ADDR_LEN];
 	struct hnae3_handle *h = priv->ae_handle;
-	u8 mac_addr_temp[ETH_ALEN];
+	u8 mac_addr_temp[ETH_ALEN] = {0};
 	int ret = 0;
 
 	if (h->ae_algo->ops->get_mac_addr)
-- 
2.42.0



