Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352E044CAF9;
	Tue, 16 Jun 2026 15:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625404; cv=none; b=FEllmCJEoFlbo70Z9WRZxQAKEvIPBpxtrxj2SP0qz4s9lLQh2q80oyZR0SCqJrJzDVoniUXID33g7PI+jfcCuNaZr7DneY2yZKdnpaqyKOBvSoSGqgRKxi7XJ6PApbhvaDOisV27noZSEdmNDg7EoA3arpF4gwvxWs6bfLRD1d8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625404; c=relaxed/simple;
	bh=xNA3Z+zdGMiHPDPM273Pepg5rGRu90XEps44VnmaPp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gJHTAmTzB5Ew7SrzKDq/6oJIF6sG1QWVr47fnjDXxr50FZJxl9sMGtbs1mydLm3JP4/bohR+T35fbTTc1xXHtwBNtZjzkUgZv4IzXbfPRgk17lfVGlvMCZ0KJnG9Ik9pBJmXGDsWxO2olfCVRmhQ5IJEexqaIJuRr52TW2jOMM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XKtB9kCy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XKtB9kCy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 354A91F000E9;
	Tue, 16 Jun 2026 15:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625403;
	bh=BRXp+RrKrGTmeVVbzUeqGJza4LC33iAIcuZhPBQfFqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XKtB9kCyDiGr9H7oJNFPDb+GPgIRYRkhfNk/QPMqHhlBaFR9BIaz1cAIwb40wrnLH
	 zm9tv8PZgZ4NCMH4pn5kscVZcS6RR8ofAl6OLbprdHGVcaAE3MGwbkzlSaxYURK167
	 zzdZB0OVF9bGDuachukxNT+8SEoiw0HOy3gDHAzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 135/325] net: txgbe: rename the SFP related
Date: Tue, 16 Jun 2026 20:28:51 +0530
Message-ID: <20260616145104.460785506@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiawen Wu <jiawenwu@trustnetic.com>

[ Upstream commit dbba6b7a47cba914d48890da7233a64c7b9f3ccc ]

QSFP supported will be introduced for AML 40G devices, the code related
to identify various modules should be renamed to more appropriate names.

And struct txgbe_hic_i2c_read used to get module information is renamed
as struct txgbe_hic_get_module_info, because another SW-FW command to
read I2C will be added later.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Link: https://patch.msgid.link/20251118080259.24676-3-jiawenwu@trustnetic.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 0487cfca4651 ("net: txgbe: initialize module info buffer")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/wangxun/libwx/wx_type.h  |  2 +-
 .../net/ethernet/wangxun/txgbe/txgbe_aml.c    | 39 ++++++++++---------
 .../net/ethernet/wangxun/txgbe/txgbe_aml.h    |  2 +-
 .../ethernet/wangxun/txgbe/txgbe_ethtool.c    |  2 +-
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   | 12 +++---
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   | 12 +++---
 6 files changed, 35 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/libwx/wx_type.h b/drivers/net/ethernet/wangxun/libwx/wx_type.h
index d367644debef36..f040b014f2dd74 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_type.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
@@ -1229,7 +1229,7 @@ enum wx_pf_flags {
 	WX_FLAG_RX_HWTSTAMP_IN_REGISTER,
 	WX_FLAG_PTP_PPS_ENABLED,
 	WX_FLAG_NEED_LINK_CONFIG,
-	WX_FLAG_NEED_SFP_RESET,
+	WX_FLAG_NEED_MODULE_RESET,
 	WX_FLAG_NEED_UPDATE_LINK,
 	WX_FLAG_NEED_DO_RESET,
 	WX_PF_FLAGS_NBITS               /* must be last */
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_aml.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_aml.c
index 05f852e31e6e52..0bc59431d43343 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_aml.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_aml.c
@@ -38,7 +38,7 @@ irqreturn_t txgbe_gpio_irq_handler_aml(int irq, void *data)
 	wr32(wx, WX_GPIO_INTMASK, 0xFF);
 	status = rd32(wx, WX_GPIO_INTSTATUS);
 	if (status & TXGBE_GPIOBIT_2) {
-		set_bit(WX_FLAG_NEED_SFP_RESET, wx->flags);
+		set_bit(WX_FLAG_NEED_MODULE_RESET, wx->flags);
 		wr32(wx, WX_GPIO_EOI, TXGBE_GPIOBIT_2);
 		wx_service_event_schedule(wx);
 	}
@@ -63,15 +63,16 @@ int txgbe_test_hostif(struct wx *wx)
 					 WX_HI_COMMAND_TIMEOUT, false);
 }
 
-static int txgbe_identify_sfp_hostif(struct wx *wx, struct txgbe_hic_i2c_read *buffer)
+static int txgbe_identify_module_hostif(struct wx *wx,
+					struct txgbe_hic_get_module_info *buffer)
 {
-	buffer->hdr.cmd = FW_READ_SFP_INFO_CMD;
-	buffer->hdr.buf_len = sizeof(struct txgbe_hic_i2c_read) -
+	buffer->hdr.cmd = FW_GET_MODULE_INFO_CMD;
+	buffer->hdr.buf_len = sizeof(struct txgbe_hic_get_module_info) -
 			      sizeof(struct wx_hic_hdr);
 	buffer->hdr.cmd_or_resp.cmd_resv = FW_CEM_CMD_RESERVED;
 
 	return wx_host_interface_command(wx, (u32 *)buffer,
-					 sizeof(struct txgbe_hic_i2c_read),
+					 sizeof(struct txgbe_hic_get_module_info),
 					 WX_HI_COMMAND_TIMEOUT, true);
 }
 
@@ -109,9 +110,9 @@ static void txgbe_get_link_capabilities(struct wx *wx, int *speed,
 {
 	struct txgbe *txgbe = wx->priv;
 
-	if (test_bit(PHY_INTERFACE_MODE_25GBASER, txgbe->sfp_interfaces))
+	if (test_bit(PHY_INTERFACE_MODE_25GBASER, txgbe->link_interfaces))
 		*speed = SPEED_25000;
-	else if (test_bit(PHY_INTERFACE_MODE_10GBASER, txgbe->sfp_interfaces))
+	else if (test_bit(PHY_INTERFACE_MODE_10GBASER, txgbe->link_interfaces))
 		*speed = SPEED_10000;
 	else
 		*speed = SPEED_UNKNOWN;
@@ -150,7 +151,7 @@ int txgbe_set_phy_link(struct wx *wx)
 	return 0;
 }
 
-static int txgbe_sfp_to_linkmodes(struct wx *wx, struct txgbe_sfp_id *id)
+static int txgbe_sfp_to_linkmodes(struct wx *wx, struct txgbe_sff_id *id)
 {
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(modes) = { 0, };
 	DECLARE_PHY_INTERFACE_MASK(interfaces);
@@ -204,9 +205,9 @@ static int txgbe_sfp_to_linkmodes(struct wx *wx, struct txgbe_sfp_id *id)
 	phylink_set(modes, Asym_Pause);
 	phylink_set(modes, FIBRE);
 
-	if (!linkmode_equal(txgbe->sfp_support, modes)) {
-		linkmode_copy(txgbe->sfp_support, modes);
-		phy_interface_and(txgbe->sfp_interfaces,
+	if (!linkmode_equal(txgbe->link_support, modes)) {
+		linkmode_copy(txgbe->link_support, modes);
+		phy_interface_and(txgbe->link_interfaces,
 				  wx->phylink_config.supported_interfaces,
 				  interfaces);
 		linkmode_copy(txgbe->advertising, modes);
@@ -217,10 +218,10 @@ static int txgbe_sfp_to_linkmodes(struct wx *wx, struct txgbe_sfp_id *id)
 	return 0;
 }
 
-int txgbe_identify_sfp(struct wx *wx)
+int txgbe_identify_module(struct wx *wx)
 {
-	struct txgbe_hic_i2c_read buffer;
-	struct txgbe_sfp_id *id;
+	struct txgbe_hic_get_module_info buffer;
+	struct txgbe_sff_id *id;
 	int err = 0;
 	u32 gpio;
 
@@ -228,9 +229,9 @@ int txgbe_identify_sfp(struct wx *wx)
 	if (gpio & TXGBE_GPIOBIT_2)
 		return -ENODEV;
 
-	err = txgbe_identify_sfp_hostif(wx, &buffer);
+	err = txgbe_identify_module_hostif(wx, &buffer);
 	if (err) {
-		wx_err(wx, "Failed to identify SFP module\n");
+		wx_err(wx, "Failed to identify module\n");
 		return err;
 	}
 
@@ -247,10 +248,10 @@ void txgbe_setup_link(struct wx *wx)
 {
 	struct txgbe *txgbe = wx->priv;
 
-	phy_interface_zero(txgbe->sfp_interfaces);
-	linkmode_zero(txgbe->sfp_support);
+	phy_interface_zero(txgbe->link_interfaces);
+	linkmode_zero(txgbe->link_support);
 
-	txgbe_identify_sfp(wx);
+	txgbe_identify_module(wx);
 }
 
 static void txgbe_get_link_state(struct phylink_config *config,
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_aml.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_aml.h
index 25d4971ca0d911..7c8fa48e68d378 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_aml.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_aml.h
@@ -8,7 +8,7 @@ void txgbe_gpio_init_aml(struct wx *wx);
 irqreturn_t txgbe_gpio_irq_handler_aml(int irq, void *data);
 int txgbe_test_hostif(struct wx *wx);
 int txgbe_set_phy_link(struct wx *wx);
-int txgbe_identify_sfp(struct wx *wx);
+int txgbe_identify_module(struct wx *wx);
 void txgbe_setup_link(struct wx *wx);
 int txgbe_phylink_init_aml(struct txgbe *txgbe);
 
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_ethtool.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_ethtool.c
index e8dd277a35c7a4..d7f9053594588d 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_ethtool.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_ethtool.c
@@ -32,7 +32,7 @@ int txgbe_get_link_ksettings(struct net_device *netdev,
 	cmd->base.port = txgbe->link_port;
 	cmd->base.autoneg = phylink_test(txgbe->advertising, Autoneg) ?
 			    AUTONEG_ENABLE : AUTONEG_DISABLE;
-	linkmode_copy(cmd->link_modes.supported, txgbe->sfp_support);
+	linkmode_copy(cmd->link_modes.supported, txgbe->link_support);
 	linkmode_copy(cmd->link_modes.advertising, txgbe->advertising);
 
 	return 0;
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index 1377ea90a8c284..4d20b178af236b 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -89,21 +89,21 @@ static int txgbe_enumerate_functions(struct wx *wx)
 	return physfns;
 }
 
-static void txgbe_sfp_detection_subtask(struct wx *wx)
+static void txgbe_module_detection_subtask(struct wx *wx)
 {
 	int err;
 
-	if (!test_bit(WX_FLAG_NEED_SFP_RESET, wx->flags))
+	if (!test_bit(WX_FLAG_NEED_MODULE_RESET, wx->flags))
 		return;
 
-	/* wait for SFP module ready */
+	/* wait for SFF module ready */
 	msleep(200);
 
-	err = txgbe_identify_sfp(wx);
+	err = txgbe_identify_module(wx);
 	if (err)
 		return;
 
-	clear_bit(WX_FLAG_NEED_SFP_RESET, wx->flags);
+	clear_bit(WX_FLAG_NEED_MODULE_RESET, wx->flags);
 }
 
 static void txgbe_link_config_subtask(struct wx *wx)
@@ -128,7 +128,7 @@ static void txgbe_service_task(struct work_struct *work)
 {
 	struct wx *wx = container_of(work, struct wx, service_task);
 
-	txgbe_sfp_detection_subtask(wx);
+	txgbe_module_detection_subtask(wx);
 	txgbe_link_config_subtask(wx);
 
 	wx_service_event_complete(wx);
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index 34920b49d0c09b..4d77da720eba16 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -341,9 +341,9 @@ void txgbe_do_reset(struct net_device *netdev);
 
 #define FW_PHY_GET_LINK_CMD             0xC0
 #define FW_PHY_SET_LINK_CMD             0xC1
-#define FW_READ_SFP_INFO_CMD            0xC5
+#define FW_GET_MODULE_INFO_CMD          0xC5
 
-struct txgbe_sfp_id {
+struct txgbe_sff_id {
 	u8 identifier;		/* A0H 0x00 */
 	u8 com_1g_code;		/* A0H 0x06 */
 	u8 com_10g_code;	/* A0H 0x03 */
@@ -356,9 +356,9 @@ struct txgbe_sfp_id {
 	u8 reserved[3];
 };
 
-struct txgbe_hic_i2c_read {
+struct txgbe_hic_get_module_info {
 	struct wx_hic_hdr hdr;
-	struct txgbe_sfp_id id;
+	struct txgbe_sff_id id;
 };
 
 struct txgbe_hic_ephy_setlink {
@@ -449,8 +449,8 @@ struct txgbe {
 	int fdir_filter_count;
 	spinlock_t fdir_perfect_lock; /* spinlock for FDIR */
 
-	DECLARE_PHY_INTERFACE_MASK(sfp_interfaces);
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(sfp_support);
+	DECLARE_PHY_INTERFACE_MASK(link_interfaces);
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(link_support);
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(advertising);
 	u8 link_port;
 };
-- 
2.53.0



