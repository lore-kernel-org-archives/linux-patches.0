Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C594229C6;
	Tue, 21 Jul 2026 19:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663077; cv=none; b=gjWlvcR+Fzs672DBhf+3pP9eRTu+He/14B0jesijTxipFlbWgU/UDm0fkxIrI82VI3yDvZ7MRbqSmUlUI8oPgELU6tBmgrDc9cVeHNM3KU6hikKMHMsaPvXMU6/DpQpGTZwdlLB5mvlexZrtXFvXyHT4SnSJqIPyxmyxmbZpQdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663077; c=relaxed/simple;
	bh=0Q67AE/4ktLZgstVr5K+g/eh9qZ6LvLiVmc6xkIfS/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NSSwPCB+Q1X+LoJ2J7hbgKjSpPmlYCqZxBPouT7W9qxbFnlrB8QMFpHATi+1KzJEpH541kMKAKcOqzLn7gT2WcjIJZa4d2TBxRGXF2RZZ99L+PuFw70gaTOfzW5BEvVZdtbJL6+og3eGpiFVW1XsPcSmmIgeF6af/gEg83QUTeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iK+oPab6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iK+oPab6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C5D01F000E9;
	Tue, 21 Jul 2026 19:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663075;
	bh=LmJwiosgLE72ZwgBsJUzOUmJI60S28SKiEqz2+exbCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iK+oPab6kkiF9CnSGPfNyLCApCV0Kn+IrUHmr7iQOkEciqw0aZENeeim/Sv7AqhLc
	 RslZ+eHfsnHSry+uTeaST6Jx55vjgZ3Uyk6Lf4TK9GC4hIEDZZvSQCRs14iOVTabbl
	 1Zg4gVsj+CLzH4LK3Dx4vj+Jmw5w9bXNVzm8peT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jijie Shao <shaojijie@huawei.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0684/1276] net: hns3: use hns3_get_ops() helper to reduce the unnecessary middle layer conversion
Date: Tue, 21 Jul 2026 17:18:47 +0200
Message-ID: <20260721152501.403165021@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

[ Upstream commit 5306c10396866b8050d1bb8ca9dddaab607409e5 ]

There are too many indirection layers in the HNS3 driver code,
This issue was previously discussed with the maintainer,
who suggested adding a helper function to fix the issue.
In fact, the hns3_get_ops() helper is already defined
and can fix this issue.

This patch uses hns3_get_ops() helper to reduce the unnecessary
middle layer conversion. Apply it to the whole HNS3 driver.
The former discusstion can be checked from the link.

Link: https://patchwork.kernel.org/project/netdevbpf/patch/20230310081404.947-1-lanhao@huawei.com/
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Link: https://patch.msgid.link/20250623040043.857782-4-shaojijie@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: c711f6d1cee9 ("net: hns3: fix permanent link down deadlock after reset")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/hisilicon/hns3/hns3_debugfs.c    |  2 +-
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |  2 +-
 .../ethernet/hisilicon/hns3/hns3_ethtool.c    | 24 +++++++++----------
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index 4f6ed7c7ee6899..35e57eebcf579b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -1239,7 +1239,7 @@ static const struct hns3_dbg_func hns3_dbg_cmd_func[] = {
 static int hns3_dbg_read_cmd(struct hns3_dbg_data *dbg_data,
 			     enum hnae3_dbg_cmd cmd, char *buf, int len)
 {
-	const struct hnae3_ae_ops *ops = dbg_data->handle->ae_algo->ops;
+	const struct hnae3_ae_ops *ops = hns3_get_ops(dbg_data->handle);
 	const struct hns3_dbg_func *cmd_func;
 	u32 i;
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index ba21e8b2d00be1..d3921af9e8ecd2 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -961,7 +961,7 @@ static void hns3_nic_set_rx_mode(struct net_device *netdev)
 
 void hns3_request_update_promisc_mode(struct hnae3_handle *handle)
 {
-	const struct hnae3_ae_ops *ops = handle->ae_algo->ops;
+	const struct hnae3_ae_ops *ops = hns3_get_ops(handle);
 
 	if (ops->request_update_promisc_mode)
 		ops->request_update_promisc_mode(handle);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index ae220f49df64f8..5e01dd55d66090 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -489,7 +489,7 @@ static const struct hns3_pflag_desc hns3_priv_flags[HNAE3_PFLAG_MAX] = {
 static int hns3_get_sset_count(struct net_device *netdev, int stringset)
 {
 	struct hnae3_handle *h = hns3_get_handle(netdev);
-	const struct hnae3_ae_ops *ops = h->ae_algo->ops;
+	const struct hnae3_ae_ops *ops = hns3_get_ops(h);
 
 	if (!ops->get_sset_count)
 		return -EOPNOTSUPP;
@@ -540,7 +540,7 @@ static void hns3_get_strings_tqps(struct hnae3_handle *handle, u8 **data)
 static void hns3_get_strings(struct net_device *netdev, u32 stringset, u8 *data)
 {
 	struct hnae3_handle *h = hns3_get_handle(netdev);
-	const struct hnae3_ae_ops *ops = h->ae_algo->ops;
+	const struct hnae3_ae_ops *ops = hns3_get_ops(h);
 	int i;
 
 	if (!ops->get_strings)
@@ -725,7 +725,7 @@ static int hns3_set_pauseparam(struct net_device *netdev,
 static void hns3_get_ksettings(struct hnae3_handle *h,
 			       struct ethtool_link_ksettings *cmd)
 {
-	const struct hnae3_ae_ops *ops = h->ae_algo->ops;
+	const struct hnae3_ae_ops *ops = hns3_get_ops(h);
 
 	/* 1.auto_neg & speed & duplex from cmd */
 	if (ops->get_ksettings_an_result)
@@ -814,7 +814,7 @@ static int hns3_check_ksettings_param(const struct net_device *netdev,
 				      const struct ethtool_link_ksettings *cmd)
 {
 	struct hnae3_handle *handle = hns3_get_handle(netdev);
-	const struct hnae3_ae_ops *ops = handle->ae_algo->ops;
+	const struct hnae3_ae_ops *ops = hns3_get_ops(handle);
 	u8 module_type = HNAE3_MODULE_TYPE_UNKNOWN;
 	u8 media_type = HNAE3_MEDIA_TYPE_UNKNOWN;
 	u32 lane_num;
@@ -862,7 +862,7 @@ static int hns3_set_link_ksettings(struct net_device *netdev,
 {
 	struct hnae3_handle *handle = hns3_get_handle(netdev);
 	struct hnae3_ae_dev *ae_dev = hns3_get_ae_dev(handle);
-	const struct hnae3_ae_ops *ops = handle->ae_algo->ops;
+	const struct hnae3_ae_ops *ops = hns3_get_ops(handle);
 	int ret;
 
 	/* Chip don't support this mode. */
@@ -1025,7 +1025,7 @@ static int hns3_set_reset(struct net_device *netdev, u32 *flags)
 	enum hnae3_reset_type rst_type = HNAE3_NONE_RESET;
 	struct hnae3_handle *h = hns3_get_handle(netdev);
 	struct hnae3_ae_dev *ae_dev = hns3_get_ae_dev(h);
-	const struct hnae3_ae_ops *ops = h->ae_algo->ops;
+	const struct hnae3_ae_ops *ops = hns3_get_ops(h);
 	const struct hns3_reset_type_map *rst_type_map;
 	enum ethtool_reset_flags rst_flags;
 	u32 i, size;
@@ -1300,7 +1300,7 @@ static int hns3_set_rxnfc(struct net_device *netdev, struct ethtool_rxnfc *cmd)
 static int hns3_nway_reset(struct net_device *netdev)
 {
 	struct hnae3_handle *handle = hns3_get_handle(netdev);
-	const struct hnae3_ae_ops *ops = handle->ae_algo->ops;
+	const struct hnae3_ae_ops *ops = hns3_get_ops(handle);
 	struct phy_device *phy = netdev->phydev;
 	int autoneg;
 
@@ -1650,7 +1650,7 @@ static void hns3_get_fec_stats(struct net_device *netdev,
 {
 	struct hnae3_handle *handle = hns3_get_handle(netdev);
 	struct hnae3_ae_dev *ae_dev = hns3_get_ae_dev(handle);
-	const struct hnae3_ae_ops *ops = handle->ae_algo->ops;
+	const struct hnae3_ae_ops *ops = hns3_get_ops(handle);
 
 	if (!hnae3_ae_dev_fec_stats_supported(ae_dev) || !ops->get_fec_stats)
 		return;
@@ -1701,7 +1701,7 @@ static int hns3_get_fecparam(struct net_device *netdev,
 {
 	struct hnae3_handle *handle = hns3_get_handle(netdev);
 	struct hnae3_ae_dev *ae_dev = hns3_get_ae_dev(handle);
-	const struct hnae3_ae_ops *ops = handle->ae_algo->ops;
+	const struct hnae3_ae_ops *ops = hns3_get_ops(handle);
 	u8 fec_ability;
 	u8 fec_mode;
 
@@ -1726,7 +1726,7 @@ static int hns3_set_fecparam(struct net_device *netdev,
 {
 	struct hnae3_handle *handle = hns3_get_handle(netdev);
 	struct hnae3_ae_dev *ae_dev = hns3_get_ae_dev(handle);
-	const struct hnae3_ae_ops *ops = handle->ae_algo->ops;
+	const struct hnae3_ae_ops *ops = hns3_get_ops(handle);
 	u32 fec_mode;
 
 	if (!test_bit(HNAE3_DEV_SUPPORT_FEC_B, ae_dev->caps))
@@ -1748,7 +1748,7 @@ static int hns3_get_module_info(struct net_device *netdev,
 
 	struct hnae3_handle *handle = hns3_get_handle(netdev);
 	struct hnae3_ae_dev *ae_dev = hns3_get_ae_dev(handle);
-	const struct hnae3_ae_ops *ops = handle->ae_algo->ops;
+	const struct hnae3_ae_ops *ops = hns3_get_ops(handle);
 	struct hns3_sfp_type sfp_type;
 	int ret;
 
@@ -1798,7 +1798,7 @@ static int hns3_get_module_eeprom(struct net_device *netdev,
 {
 	struct hnae3_handle *handle = hns3_get_handle(netdev);
 	struct hnae3_ae_dev *ae_dev = hns3_get_ae_dev(handle);
-	const struct hnae3_ae_ops *ops = handle->ae_algo->ops;
+	const struct hnae3_ae_ops *ops = hns3_get_ops(handle);
 
 	if (ae_dev->dev_version < HNAE3_DEVICE_VERSION_V2 ||
 	    !ops->get_module_eeprom)
-- 
2.53.0



