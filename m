Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A23215AD3
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:39:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E382DC433D9;
	Wed, 20 Sep 2023 12:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695213545;
	bh=vmCxuaI8LiZGT+IstG7mdYnv2/UmS7iiVsd1HcXpcKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CETX64mAoxNUhq7/eDKUGvlj5+XmLhD0Q9LdnmLZQmzvgx2p5fGUhyvFCmZ7vjuhs
	 6h/g3d28VP4hKczwJvGTnnkQgYkOuBYTKfT+QnztvuNSvK9s4YLaZqO1hcl0idTDaW
	 Z2Wj2YdwyGKp3sCpeP5Yit8s6Trze1p9YcVPDh6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yisen Zhuang <yisen.zhuang@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 277/367] net: hns3: fix the port information display when sfp is absent
Date: Wed, 20 Sep 2023 13:30:54 +0200
Message-ID: <20230920112905.733378750@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112858.471730572@linuxfoundation.org>
References: <20230920112858.471730572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 34e5448d59f6f..4ea19f546df08 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -676,7 +676,9 @@ static int hns3_get_link_ksettings(struct net_device *netdev,
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



