Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE4CA6FC9
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:41:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F46EC433CA;
	Sun, 17 Sep 2023 19:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694979707;
	bh=/aFflsaOzerGOL+qZC2G7QOVElX7NvEPu+9RZbpU04Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pNzpbez4opqbJj/dKiLJOZs5ktSwAwlNZ7xuMLRQ+nBH/gDMaBmKfPJbtvcjqslNH
	 g3hJA0bWJYK2enYt9WCN9icag7ocfR/2sP/UARRlVoN66IXgdRkOV9aVjOuwjtJzd7
	 WKI3c+hR4Av028j1Y1zLbqg6Xq1PXNWnrkH4I7aQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yisen Zhuang <yisen.zhuang@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 366/406] net: hns3: fix the port information display when sfp is absent
Date: Sun, 17 Sep 2023 21:13:40 +0200
Message-ID: <20230917191110.932701006@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191101.035638219@linuxfoundation.org>
References: <20230917191101.035638219@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yisen Zhuang <yisen.zhuang@huawei.com>

[ Upstream commit 674d9591a32d01df75d6b5fffed4ef942a294376 ]

When sfp is absent or unidentified, the port type should be
displayed as PORT_OTHERS, rather than PORT_FIBRE.

Fixes: 88d10bd6f730 ("net: hns3: add support for multiple media type")
Signed-off-by: Yisen Zhuang <yisen.zhuang@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index cd0d7a546957a..d35f4b2b480e6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -704,7 +704,9 @@ static int hns3_get_link_ksettings(struct net_device *netdev,
 		hns3_get_ksettings(h, cmd);
 		break;
 	case HNAE3_MEDIA_TYPE_FIBER:
-		if (module_type == HNAE3_MODULE_TYPE_CR)
+		if (module_type == HNAE3_MODULE_TYPE_UNKNOWN)
+			cmd->base.port = PORT_OTHER;
+		else if (module_type == HNAE3_MODULE_TYPE_CR)
 			cmd->base.port = PORT_DA;
 		else
 			cmd->base.port = PORT_FIBRE;
-- 
2.40.1



