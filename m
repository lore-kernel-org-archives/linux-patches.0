Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC7942E621;
	Fri, 24 Nov 2023 18:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lv5uITew"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4725C433C7;
	Fri, 24 Nov 2023 18:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850761;
	bh=zZQGcCiwGrmHPQ7zEtJykBdsl9hdg3oozB8/TR5Hxkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lv5uITewnYMIKWf6ToG9I8lhPRaEeN4kKGckuIu/k2J8MrwaugkKUpBVd16XUM8XQ
	 maOW0Gz46Gp5/JpROd9BhjVkL1aNImvHBw42CNbNTASUp/X0D+ICRsWAydoZFpd+C/
	 rW9OSXGvFLNb2aHvp544tw4ybMVBoc3JEIR8lDCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Shen <shenjian15@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 179/491] net: hns3: fix incorrect capability bit display for copper port
Date: Fri, 24 Nov 2023 17:46:55 +0000
Message-ID: <20231124172029.855003714@linuxfoundation.org>
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

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit 75b247b57d8b71bcb679e4cb37d0db104848806c ]

Currently, the FEC capability bit is default set for device version V2.
It's incorrect for the copper port. Eventhough it doesn't make the nic
work abnormal, but the capability information display in debugfs may
confuse user. So clear it when driver get the port type inforamtion.

Fixes: 433ccce83504 ("net: hns3: use FEC capability queried from firmware")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 71154c0976aff..dd2baa05adba0 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -11664,6 +11664,7 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 		goto err_msi_irq_uninit;
 
 	if (hdev->hw.mac.media_type == HNAE3_MEDIA_TYPE_COPPER) {
+		clear_bit(HNAE3_DEV_SUPPORT_FEC_B, ae_dev->caps);
 		if (hnae3_dev_phy_imp_supported(hdev))
 			ret = hclge_update_tp_port_info(hdev);
 		else
-- 
2.42.0



