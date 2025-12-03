Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EFF93446B0;
	Wed,  3 Dec 2025 15:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777487; cv=none; b=PeX1HF0Vvi21Xl1pqXvhSmN0/RkpRwd6O/iYC5zHsZ5VOIPidos2g4hBxurev+eFobdsueYMHQ2/W0ZBeZ5Yos/JVF73PBgDqxXagp4UhQHkH0IM5dQLU+i+MCpthLtQwC6GL1YmtAlnHnbF/aeTa4sKWE5/DTGKQOAkB/Ht3lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777487; c=relaxed/simple;
	bh=x6Q15zudK345hSFLFmWentRVZ6/H5GBQqbRrkvLYyQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UP8PkOJ85ZfDKelbbiBEK44xhfNpXRJ9+2O1jWYoVS1KnoCEAJpFss5HqDn0ROzIdM2hqaiPEACF4525ekfVRY5jjizmquNTYhd7ZkyfBmqomEmtNZBUNu+I/PIUlRJy6pesD8dNe3lBRBnVLPSO/RV803TcJfNBodL/4sz0sis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G88Q+cjx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G88Q+cjx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02603C4CEF5;
	Wed,  3 Dec 2025 15:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777487;
	bh=x6Q15zudK345hSFLFmWentRVZ6/H5GBQqbRrkvLYyQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G88Q+cjx0S4Hs5ERKIWdDW3S3cUiYG6xU90xyuSEAjlOIasBeY9ubexCjPWnp+i/q
	 N8nmrviSXONxV0lzFtgjohjs6dNpZENAHz/6bAyFLelrTjewJkK7wto9Uaa1tbonfe
	 t4IICU2GGmi1sgK1qp5XhVnUQAiEsZT2pIln2DnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jijie Shao <shaojijie@huawei.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 026/392] net: hns3: return error code when function fails
Date: Wed,  3 Dec 2025 16:22:56 +0100
Message-ID: <20251203152415.064076314@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d228e37f8b3d9..492a754f84a94 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -9562,8 +9562,7 @@ static int hclge_mii_ioctl(struct hclge_dev *hdev, struct ifreq *ifr, int cmd)
 		/* this command reads phy id and register at the same time */
 		fallthrough;
 	case SIOCGMIIREG:
-		data->val_out = hclge_read_phy_reg(hdev, data->reg_num);
-		return 0;
+		return hclge_read_phy_reg(hdev, data->reg_num, &data->val_out);
 
 	case SIOCSMIIREG:
 		return hclge_write_phy_reg(hdev, data->reg_num, data->val_in);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c
index 63d2be4349e3e..87a196256864f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.c
@@ -271,7 +271,7 @@ void hclge_mac_stop_phy(struct hclge_dev *hdev)
 	phy_stop(phydev);
 }
 
-u16 hclge_read_phy_reg(struct hclge_dev *hdev, u16 reg_addr)
+int hclge_read_phy_reg(struct hclge_dev *hdev, u16 reg_addr, u16 *val)
 {
 	struct hclge_phy_reg_cmd *req;
 	struct hclge_desc desc;
@@ -283,11 +283,14 @@ u16 hclge_read_phy_reg(struct hclge_dev *hdev, u16 reg_addr)
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
index fd0e20190b90f..baeee805a9510 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.h
@@ -9,7 +9,7 @@ int hclge_mac_connect_phy(struct hnae3_handle *handle);
 void hclge_mac_disconnect_phy(struct hnae3_handle *handle);
 void hclge_mac_start_phy(struct hclge_dev *hdev);
 void hclge_mac_stop_phy(struct hclge_dev *hdev);
-u16 hclge_read_phy_reg(struct hclge_dev *hdev, u16 reg_addr);
+int hclge_read_phy_reg(struct hclge_dev *hdev, u16 reg_addr, u16 *val);
 int hclge_write_phy_reg(struct hclge_dev *hdev, u16 reg_addr, u16 val);
 
 #endif
-- 
2.51.0



