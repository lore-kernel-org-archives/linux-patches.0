Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC28D4C97;
	Tue, 11 Nov 2025 00:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822437; cv=none; b=XpC1oOmRBaJ8ax3aS+pEk4DDWDxmaSLq+nclodT2ZIoTtYTIDITntgMOKghKFOv1hFCLCw9TWo6AdK3b4/1my0uRbfDy3b9f7c1QCNZRxaSaBiYrIkPcjbVJcSwDtG+Y4gqvnyHywztPt+23SmsdQWyiB+xMlDJ6j0Du2wOTSFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822437; c=relaxed/simple;
	bh=k11MW00LU03t4lnrZQAQljHDKWaaN0bhNzugANuLiQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lk8Hte5F9/vL+NwoynWGVBtlpjhwqQRXxWaP0vbHgZt3nXNSO5FN/LOhAmIDGfxgeNQc57MRSZt0eOmYD4Zt/BUTyicmKMqnRn3VbNqP8ZGXsu0R38PbUgNdK3mgYOAkkDwB9miI6G9u410s9OT6llSj2cTaf67qtyz3pmBhbzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I221ouSI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I221ouSI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4356CC4CEF5;
	Tue, 11 Nov 2025 00:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822437;
	bh=k11MW00LU03t4lnrZQAQljHDKWaaN0bhNzugANuLiQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I221ouSISDJUdoCHHBJdgcYfevNofjtJ5lTcqBrYuBOvKHdxvYF5NumGEkNSBsN0R
	 jF4z1fdEtwC0qMQqv5rXOC4F8r6TyQHkO0mbQU6TnJdQ0ZBLEdoCe+nrk7MHnjexrJ
	 khgs8tizl9hK6G9FH1EoNuHqyiddHtDYAjhXDORk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jijie Shao <shaojijie@huawei.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 050/565] net: hns3: return error code when function fails
Date: Tue, 11 Nov 2025 09:38:26 +0900
Message-ID: <20251111004528.035127300@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 407ad0b985b4f..f5eafd1ded413 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -9439,8 +9439,7 @@ static int hclge_mii_ioctl(struct hclge_dev *hdev, struct ifreq *ifr, int cmd)
 		/* this command reads phy id and register at the same time */
 		fallthrough;
 	case SIOCGMIIREG:
-		data->val_out = hclge_read_phy_reg(hdev, data->reg_num);
-		return 0;
+		return hclge_read_phy_reg(hdev, data->reg_num, &data->val_out);
 
 	case SIOCSMIIREG:
 		return hclge_write_phy_reg(hdev, data->reg_num, data->val_in);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c
index 80079657afebe..b8dbf932caf94 100644
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



