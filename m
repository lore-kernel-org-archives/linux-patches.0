Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD1F326D50;
	Mon, 27 Oct 2025 19:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593172; cv=none; b=j0J3Db/nrUEFd3C/zJLXr2N3rfQUyuftuxV/PRa2Kkua+n/MyiNz/XuuPYEsSET8gHs5rYYflvecL13aNKIGKjI1gKLTbj/wrchpLj7ooWtXYk1IetBc7MLurgK6cBnOmqoLxG+3oqxJ0w6MNsH11SGZX/zcrp71p8BUJrO/grs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593172; c=relaxed/simple;
	bh=/cEb3bfA0eXRFUBzA3L1wJl3ByzIhBF2hPuBowR5DK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o0Xqf6UVS/1PctWnwFoTfhDEZbK2mShY6xkrZvsXEbTnuUU5crJCEAcFBtE62u6nlwXEnq/bxIk/mlakIdYW5OOeSezNppA/V1KHZb2nC9eEX0cxtbGd+yzOYmD/aoWtzG+Qms97IHXZCvT81U+oXvCXBPr8Kl4WbCqlZCblFl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nj8zL54E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nj8zL54E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C234EC4CEF1;
	Mon, 27 Oct 2025 19:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593172;
	bh=/cEb3bfA0eXRFUBzA3L1wJl3ByzIhBF2hPuBowR5DK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nj8zL54EzZQadVtAxJEYpSSBpnAldJKzq933py5MvxD2KEGWeooBvmT1+RcQSY9dQ
	 gk7/0KNt+LaNVzaW5R++Zzwc8a66Pp6oLbybFxF6qN1YM4krCHN3pWjGFqgH4ZvC83
	 4OjdmFkE/tFa1iIMueZbe5CAOqtmnklkNMzDgRgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 041/184] net: phy: realtek: fix rtl8221b-vm-cg name
Date: Mon, 27 Oct 2025 19:35:23 +0100
Message-ID: <20251027183516.015427150@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

From: Aleksander Jan Bajkowski <olek2@wp.pl>

[ Upstream commit ffff5c8fc2af2218a3332b3d5b97654599d50cde ]

When splitting the RTL8221B-VM-CG into C22 and C45 variants, the name was
accidentally changed to RTL8221B-VN-CG. This patch brings back the previous
part number.

Fixes: ad5ce743a6b0 ("net: phy: realtek: Add driver instances for rtl8221b via Clause 45")
Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20251016192325.2306757-1-olek2@wp.pl
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/realtek/realtek_main.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/phy/realtek/realtek_main.c b/drivers/net/phy/realtek/realtek_main.c
index 64af3b96f0288..62ef87ecc5587 100644
--- a/drivers/net/phy/realtek/realtek_main.c
+++ b/drivers/net/phy/realtek/realtek_main.c
@@ -156,7 +156,7 @@
 #define RTL_8211FVD_PHYID			0x001cc878
 #define RTL_8221B				0x001cc840
 #define RTL_8221B_VB_CG				0x001cc849
-#define RTL_8221B_VN_CG				0x001cc84a
+#define RTL_8221B_VM_CG				0x001cc84a
 #define RTL_8251B				0x001cc862
 #define RTL_8261C				0x001cc890
 
@@ -1362,16 +1362,16 @@ static int rtl8221b_vb_cg_c45_match_phy_device(struct phy_device *phydev,
 	return rtlgen_is_c45_match(phydev, RTL_8221B_VB_CG, true);
 }
 
-static int rtl8221b_vn_cg_c22_match_phy_device(struct phy_device *phydev,
+static int rtl8221b_vm_cg_c22_match_phy_device(struct phy_device *phydev,
 					       const struct phy_driver *phydrv)
 {
-	return rtlgen_is_c45_match(phydev, RTL_8221B_VN_CG, false);
+	return rtlgen_is_c45_match(phydev, RTL_8221B_VM_CG, false);
 }
 
-static int rtl8221b_vn_cg_c45_match_phy_device(struct phy_device *phydev,
+static int rtl8221b_vm_cg_c45_match_phy_device(struct phy_device *phydev,
 					       const struct phy_driver *phydrv)
 {
-	return rtlgen_is_c45_match(phydev, RTL_8221B_VN_CG, true);
+	return rtlgen_is_c45_match(phydev, RTL_8221B_VM_CG, true);
 }
 
 static int rtl_internal_nbaset_match_phy_device(struct phy_device *phydev,
@@ -1718,7 +1718,7 @@ static struct phy_driver realtek_drvs[] = {
 		.suspend        = genphy_c45_pma_suspend,
 		.resume         = rtlgen_c45_resume,
 	}, {
-		.match_phy_device = rtl8221b_vn_cg_c22_match_phy_device,
+		.match_phy_device = rtl8221b_vm_cg_c22_match_phy_device,
 		.name           = "RTL8221B-VM-CG 2.5Gbps PHY (C22)",
 		.probe		= rtl822x_probe,
 		.get_features   = rtl822x_get_features,
@@ -1731,8 +1731,8 @@ static struct phy_driver realtek_drvs[] = {
 		.read_page      = rtl821x_read_page,
 		.write_page     = rtl821x_write_page,
 	}, {
-		.match_phy_device = rtl8221b_vn_cg_c45_match_phy_device,
-		.name           = "RTL8221B-VN-CG 2.5Gbps PHY (C45)",
+		.match_phy_device = rtl8221b_vm_cg_c45_match_phy_device,
+		.name           = "RTL8221B-VM-CG 2.5Gbps PHY (C45)",
 		.probe		= rtl822x_probe,
 		.config_init    = rtl822xb_config_init,
 		.get_rate_matching = rtl822xb_get_rate_matching,
-- 
2.51.0



