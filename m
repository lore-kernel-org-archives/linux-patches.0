Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7E444C97;
	Tue, 11 Nov 2025 00:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822287; cv=none; b=Ovye43g03lJ6FWpD8OabHXX37AHwsEaRnld887pihf3bbEtrwowGhgaDTjNQ2EjUPsFrRFeV0cBBWn+XHaMoVZfslVVB4J63VPO+GMP5ouEKidtJsyyl9eBaZPz78VmCdWfC1fBzMYRLapiPrJe3lK+dD2oYWSmrjc9moA3Rhm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822287; c=relaxed/simple;
	bh=EeiKAvEjenZNL2+mZoEsuldhIFjrY7GnI640fQQ6FKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ElMR89Gv5BF9Yfsq1mRO3HRkd7nc1wQuuZ+OmSsuJH2jyeKcK2MhNHnYhQS7WMiMBMS1YnkKUXiRR6VwlasOdNrBLCFBFAmxFXze2024VCkXlVaUY+MHFBhJTPi+BaaStTVlTAcgluSTsenOeHFY/hDfItyp7g5xpMK4VH/mbXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l+Riqvk7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l+Riqvk7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5855DC4CEF5;
	Tue, 11 Nov 2025 00:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822287;
	bh=EeiKAvEjenZNL2+mZoEsuldhIFjrY7GnI640fQQ6FKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l+Riqvk7/TY1zjEtTtOpNutrQnnbRGOclfb0hi3cpg5L7byVIeuq+xt2SrAGo+Sa9
	 Una0sZDQ3R+RbOYMqirZGWkIj0G+tx8AXTI3eXRSGy3bpU1MbJKy/E0UxW7xUl5XeC
	 FaZ0rKJQ1zO1Lfh/MUPBS2H+3rl0wIArCThAFm4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jijie Shao <shaojijie@huawei.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 073/849] net: hns3: return error code when function fails
Date: Tue, 11 Nov 2025 09:34:03 +0900
Message-ID: <20251111004538.188805826@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jijie Shao <shaojijie@huawei.com>

[ Upstream commit 03ca7c8c42be913529eb9f188278114430c6abbd ]

Currently, in hclge_mii_ioctl(), the operation to
read the PHY register (SIOCGMIIREG) always returns 0.

This patch changes the return type of hclge_read_phy_reg(),
returning an error code when the function fails.

Fixes: 024712f51e57 ("net: hns3: add ioctl support for imp-controlled PHYs")
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Link: https://patch.msgid.link/20251023131338.2642520-2-shaojijie@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 3 +--
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c | 9 ++++++---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.h | 2 +-
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index f209a05e2033b..d3d17f9e5457b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -9429,8 +9429,7 @@ static int hclge_mii_ioctl(struct hclge_dev *hdev, struct ifreq *ifr, int cmd)
 		/* this command reads phy id and register at the same time */
 		fallthrough;
 	case SIOCGMIIREG:
-		data->val_out = hclge_read_phy_reg(hdev, data->reg_num);
-		return 0;
+		return hclge_read_phy_reg(hdev, data->reg_num, &data->val_out);
 
 	case SIOCSMIIREG:
 		return hclge_write_phy_reg(hdev, data->reg_num, data->val_in);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c
index 96553109f44c9..cf881108fa570 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c
@@ -274,7 +274,7 @@ void hclge_mac_stop_phy(struct hclge_dev *hdev)
 	phy_stop(phydev);
 }
 
-u16 hclge_read_phy_reg(struct hclge_dev *hdev, u16 reg_addr)
+int hclge_read_phy_reg(struct hclge_dev *hdev, u16 reg_addr, u16 *val)
 {
 	struct hclge_phy_reg_cmd *req;
 	struct hclge_desc desc;
@@ -286,11 +286,14 @@ u16 hclge_read_phy_reg(struct hclge_dev *hdev, u16 reg_addr)
 	req->reg_addr = cpu_to_le16(reg_addr);
 
 	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
-	if (ret)
+	if (ret) {
 		dev_err(&hdev->pdev->dev,
 			"failed to read phy reg, ret = %d.\n", ret);
+		return ret;
+	}
 
-	return le16_to_cpu(req->reg_val);
+	*val = le16_to_cpu(req->reg_val);
+	return 0;
 }
 
 int hclge_write_phy_reg(struct hclge_dev *hdev, u16 reg_addr, u16 val)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.h
index 4200d0b6d9317..21d434c82475b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.h
@@ -13,7 +13,7 @@ int hclge_mac_connect_phy(struct hnae3_handle *handle);
 void hclge_mac_disconnect_phy(struct hnae3_handle *handle);
 void hclge_mac_start_phy(struct hclge_dev *hdev);
 void hclge_mac_stop_phy(struct hclge_dev *hdev);
-u16 hclge_read_phy_reg(struct hclge_dev *hdev, u16 reg_addr);
+int hclge_read_phy_reg(struct hclge_dev *hdev, u16 reg_addr, u16 *val);
 int hclge_write_phy_reg(struct hclge_dev *hdev, u16 reg_addr, u16 val);
 
 #endif
-- 
2.51.0



