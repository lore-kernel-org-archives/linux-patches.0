Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AFF439FE3;
	Fri, 24 Nov 2023 18:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hxk6mDe7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E805C433C8;
	Fri, 24 Nov 2023 18:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849521;
	bh=dongECOhnVMWpOFypc4kwRrPp8OfIPUwxSs1NLlIbsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hxk6mDe7vbGlmujRXmPfp92yc/6PEiWj3yT/UL7mWekkWM/sFw+jkKtsji+iuiXZw
	 mtyoiAgiDi/qs4Em4OH8dCKoTmKrbrs91jAiHyihpcPOtp5icO6JGAKh1mPc0lbNma
	 TGjdQVQlS/nkYHUhgmalpH5p5Kd+Argq991AnzaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Shen <shenjian15@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 190/530] net: hns3: fix incorrect capability bit display for copper port
Date: Fri, 24 Nov 2023 17:45:56 +0000
Message-ID: <20231124172033.845714524@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a884e8f7e947b..af8a3e6429a75 100644
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



