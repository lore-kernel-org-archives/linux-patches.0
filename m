Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8AAD470126;
	Tue, 21 Jul 2026 19:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663069; cv=none; b=F+ca5Rtk89GKKesuYhPxlcfHEUrlOY8fZzjka/WsqIltDMWIqeW646ZcozqaI8CBYNJ4HNQE7GhMuncXrn3/UaTd5dPfRDa53j3519OAy4RluQse2YOJWGwxC6VwBjLbDuXNqttHTa6TfeGE4uI8JbSTlTSyN5HpDCn5JSRtKUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663069; c=relaxed/simple;
	bh=JprdJEaOttFIU7oh9Ezg7Mp8VVJp3CMFiMkgOtn08zU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IKm4GMZLMWtBdp5Qqs8m46B7YugIb7i2P9w2GdjTuZlrIdDo2FINhVbPNH1RmJ4R35KiEZ+iZWAGBwRBQNKK4/A8JmXRp/s3YHxBYCtG55j67SA3iXdTdaB404w5ztAK3qn8zZE8xO1aeaJ1qHmSYXtyzfdYDdqkawkHxLTX4GU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PiKuyHg2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PiKuyHg2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A7A51F00A3A;
	Tue, 21 Jul 2026 19:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663067;
	bh=0piWEGGmyVmcss4i9W6/fkIq37mBlaOvpNdoeQw5WVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PiKuyHg2ML4WWj2FDBrlEPqBOrZKQG832niESUmm/VD7eJ592CuXG5NreO9bLGJnm
	 lxohqddRZgN0KR67y2+W39TogN7eQFkqlGPYsRAlcC8GbtOwVonQKFJcsIyud1fScj
	 5CjNPlO0JOrBg4WETqx329f3ILT86wQuY0+wtavc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Shen <shenjian15@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0682/1276] net: hns3: use string choices helper
Date: Tue, 21 Jul 2026 17:18:45 +0200
Message-ID: <20260721152501.358514226@linuxfoundation.org>
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

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit 9e3285040514cafee035e1be24502097d3d0b75f ]

Use string choices helper for better readability.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250307113733.819448-1-shaojijie@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: c711f6d1cee9 ("net: hns3: fix permanent link down deadlock after reset")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/hisilicon/hns3/hns3_debugfs.c    | 24 ++++---
 .../ethernet/hisilicon/hns3/hns3_ethtool.c    |  3 +-
 .../hisilicon/hns3/hns3pf/hclge_debugfs.c     | 63 +++++++++----------
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 10 +--
 .../hisilicon/hns3/hns3pf/hclge_ptp.c         |  3 +-
 5 files changed, 54 insertions(+), 49 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index 3d70c97a0bedf6..4e5d8bc39a1bf3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -3,6 +3,7 @@
 
 #include <linux/debugfs.h>
 #include <linux/device.h>
+#include <linux/string_choices.h>
 
 #include "hnae3.h"
 #include "hns3_debugfs.h"
@@ -661,12 +662,14 @@ static void hns3_dump_rx_queue_info(struct hns3_enet_ring *ring,
 		HNS3_RING_RX_RING_PKTNUM_RECORD_REG));
 	sprintf(result[j++], "%u", ring->rx_copybreak);
 
-	sprintf(result[j++], "%s", readl_relaxed(ring->tqp->io_base +
-		HNS3_RING_EN_REG) ? "on" : "off");
+	sprintf(result[j++], "%s",
+		str_on_off(readl_relaxed(ring->tqp->io_base +
+					 HNS3_RING_EN_REG)));
 
 	if (hnae3_ae_dev_tqp_txrx_indep_supported(ae_dev))
-		sprintf(result[j++], "%s", readl_relaxed(ring->tqp->io_base +
-			HNS3_RING_RX_EN_REG) ? "on" : "off");
+		sprintf(result[j++], "%s",
+			str_on_off(readl_relaxed(ring->tqp->io_base +
+						 HNS3_RING_RX_EN_REG)));
 	else
 		sprintf(result[j++], "%s", "NA");
 
@@ -764,12 +767,14 @@ static void hns3_dump_tx_queue_info(struct hns3_enet_ring *ring,
 	sprintf(result[j++], "%u", readl_relaxed(ring->tqp->io_base +
 		HNS3_RING_TX_RING_PKTNUM_RECORD_REG));
 
-	sprintf(result[j++], "%s", readl_relaxed(ring->tqp->io_base +
-		HNS3_RING_EN_REG) ? "on" : "off");
+	sprintf(result[j++], "%s",
+		str_on_off(readl_relaxed(ring->tqp->io_base +
+					 HNS3_RING_EN_REG)));
 
 	if (hnae3_ae_dev_tqp_txrx_indep_supported(ae_dev))
-		sprintf(result[j++], "%s", readl_relaxed(ring->tqp->io_base +
-			HNS3_RING_TX_EN_REG) ? "on" : "off");
+		sprintf(result[j++], "%s",
+			str_on_off(readl_relaxed(ring->tqp->io_base +
+						 HNS3_RING_TX_EN_REG)));
 	else
 		sprintf(result[j++], "%s", "NA");
 
@@ -1030,7 +1035,6 @@ static void
 hns3_dbg_dev_caps(struct hnae3_handle *h, char *buf, int len, int *pos)
 {
 	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(h->pdev);
-	const char * const str[] = {"no", "yes"};
 	unsigned long *caps = ae_dev->caps;
 	u32 i, state;
 
@@ -1039,7 +1043,7 @@ hns3_dbg_dev_caps(struct hnae3_handle *h, char *buf, int len, int *pos)
 	for (i = 0; i < ARRAY_SIZE(hns3_dbg_cap); i++) {
 		state = test_bit(hns3_dbg_cap[i].cap_bit, caps);
 		*pos += scnprintf(buf + *pos, len - *pos, "%s: %s\n",
-				  hns3_dbg_cap[i].name, str[state]);
+				  hns3_dbg_cap[i].name, str_yes_no(state));
 	}
 
 	*pos += scnprintf(buf + *pos, len - *pos, "\n");
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index b771a2daba4360..6715222aeb661e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -3,6 +3,7 @@
 
 #include <linux/etherdevice.h>
 #include <linux/string.h>
+#include <linux/string_choices.h>
 #include <linux/phy.h>
 #include <linux/sfp.h>
 
@@ -1198,7 +1199,7 @@ static int hns3_set_tx_push(struct net_device *netdev, u32 tx_push)
 		return 0;
 
 	netdev_dbg(netdev, "Changing tx push from %s to %s\n",
-		   old_state ? "on" : "off", tx_push ? "on" : "off");
+		   str_on_off(old_state), str_on_off(tx_push));
 
 	if (tx_push)
 		set_bit(HNS3_NIC_STATE_TX_PUSH_ENABLE, &priv->state);
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index debf143e994014..c4649069359465 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -3,6 +3,7 @@
 
 #include <linux/device.h>
 #include <linux/sched/clock.h>
+#include <linux/string_choices.h>
 
 #include "hclge_debugfs.h"
 #include "hclge_err.h"
@@ -11,7 +12,6 @@
 #include "hclge_tm.h"
 #include "hnae3.h"
 
-static const char * const state_str[] = { "off", "on" };
 static const char * const hclge_mac_state_str[] = {
 	"TO_ADD", "TO_DEL", "ACTIVE"
 };
@@ -2573,7 +2573,7 @@ static int hclge_dbg_dump_loopback(struct hclge_dev *hdev, char *buf, int len)
 	loopback_en = hnae3_get_bit(le32_to_cpu(req_app->txrx_pad_fcs_loop_en),
 				    HCLGE_MAC_APP_LP_B);
 	pos += scnprintf(buf + pos, len - pos, "app loopback: %s\n",
-			 state_str[loopback_en]);
+			 str_on_off(loopback_en));
 
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_COMMON_LOOPBACK, true);
 	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
@@ -2586,22 +2586,22 @@ static int hclge_dbg_dump_loopback(struct hclge_dev *hdev, char *buf, int len)
 
 	loopback_en = req_common->enable & HCLGE_CMD_SERDES_SERIAL_INNER_LOOP_B;
 	pos += scnprintf(buf + pos, len - pos, "serdes serial loopback: %s\n",
-			 state_str[loopback_en]);
+			 str_on_off(loopback_en));
 
 	loopback_en = req_common->enable &
 			HCLGE_CMD_SERDES_PARALLEL_INNER_LOOP_B ? 1 : 0;
 	pos += scnprintf(buf + pos, len - pos, "serdes parallel loopback: %s\n",
-			 state_str[loopback_en]);
+			 str_on_off(loopback_en));
 
 	if (phydev) {
 		loopback_en = phydev->loopback_enabled;
 		pos += scnprintf(buf + pos, len - pos, "phy loopback: %s\n",
-				 state_str[loopback_en]);
+				 str_on_off(loopback_en));
 	} else if (hnae3_dev_phy_imp_supported(hdev)) {
 		loopback_en = req_common->enable &
 			      HCLGE_CMD_GE_PHY_INNER_LOOP_B;
 		pos += scnprintf(buf + pos, len - pos, "phy loopback: %s\n",
-				 state_str[loopback_en]);
+				 str_on_off(loopback_en));
 	}
 
 	return 0;
@@ -2894,9 +2894,9 @@ static int hclge_dbg_dump_vlan_filter_config(struct hclge_dev *hdev, char *buf,
 	egress = vlan_fe & HCLGE_FILTER_FE_NIC_EGRESS_B ? 1 : 0;
 
 	*pos += scnprintf(buf, len, "I_PORT_VLAN_FILTER: %s\n",
-			  state_str[ingress]);
+			  str_on_off(ingress));
 	*pos += scnprintf(buf + *pos, len - *pos, "E_PORT_VLAN_FILTER: %s\n",
-			  state_str[egress]);
+			  str_on_off(egress));
 
 	hclge_dbg_fill_content(content, sizeof(content), vlan_filter_items,
 			       NULL, ARRAY_SIZE(vlan_filter_items));
@@ -2915,11 +2915,11 @@ static int hclge_dbg_dump_vlan_filter_config(struct hclge_dev *hdev, char *buf,
 			return ret;
 		j = 0;
 		result[j++] = hclge_dbg_get_func_id_str(str_id, i);
-		result[j++] = state_str[ingress];
-		result[j++] = state_str[egress];
-		result[j++] =
-			test_bit(HNAE3_DEV_SUPPORT_PORT_VLAN_BYPASS_B,
-				 hdev->ae_dev->caps) ? state_str[bypass] : "NA";
+		result[j++] = str_on_off(ingress);
+		result[j++] = str_on_off(egress);
+		result[j++] = test_bit(HNAE3_DEV_SUPPORT_PORT_VLAN_BYPASS_B,
+				       hdev->ae_dev->caps) ?
+			      str_on_off(bypass) : "NA";
 		hclge_dbg_fill_content(content, sizeof(content),
 				       vlan_filter_items, result,
 				       ARRAY_SIZE(vlan_filter_items));
@@ -2958,19 +2958,19 @@ static int hclge_dbg_dump_vlan_offload_config(struct hclge_dev *hdev, char *buf,
 		j = 0;
 		result[j++] = hclge_dbg_get_func_id_str(str_id, i);
 		result[j++] = str_pvid;
-		result[j++] = state_str[vlan_cfg.accept_tag1];
-		result[j++] = state_str[vlan_cfg.accept_tag2];
-		result[j++] = state_str[vlan_cfg.accept_untag1];
-		result[j++] = state_str[vlan_cfg.accept_untag2];
-		result[j++] = state_str[vlan_cfg.insert_tag1];
-		result[j++] = state_str[vlan_cfg.insert_tag2];
-		result[j++] = state_str[vlan_cfg.shift_tag];
-		result[j++] = state_str[vlan_cfg.strip_tag1];
-		result[j++] = state_str[vlan_cfg.strip_tag2];
-		result[j++] = state_str[vlan_cfg.drop_tag1];
-		result[j++] = state_str[vlan_cfg.drop_tag2];
-		result[j++] = state_str[vlan_cfg.pri_only1];
-		result[j++] = state_str[vlan_cfg.pri_only2];
+		result[j++] = str_on_off(vlan_cfg.accept_tag1);
+		result[j++] = str_on_off(vlan_cfg.accept_tag2);
+		result[j++] = str_on_off(vlan_cfg.accept_untag1);
+		result[j++] = str_on_off(vlan_cfg.accept_untag2);
+		result[j++] = str_on_off(vlan_cfg.insert_tag1);
+		result[j++] = str_on_off(vlan_cfg.insert_tag2);
+		result[j++] = str_on_off(vlan_cfg.shift_tag);
+		result[j++] = str_on_off(vlan_cfg.strip_tag1);
+		result[j++] = str_on_off(vlan_cfg.strip_tag2);
+		result[j++] = str_on_off(vlan_cfg.drop_tag1);
+		result[j++] = str_on_off(vlan_cfg.drop_tag2);
+		result[j++] = str_on_off(vlan_cfg.pri_only1);
+		result[j++] = str_on_off(vlan_cfg.pri_only2);
 
 		hclge_dbg_fill_content(content, sizeof(content),
 				       vlan_offload_items, result,
@@ -3007,14 +3007,13 @@ static int hclge_dbg_dump_ptp_info(struct hclge_dev *hdev, char *buf, int len)
 	pos += scnprintf(buf + pos, len - pos, "phc %s's debug info:\n",
 			 ptp->info.name);
 	pos += scnprintf(buf + pos, len - pos, "ptp enable: %s\n",
-			 test_bit(HCLGE_PTP_FLAG_EN, &ptp->flags) ?
-			 "yes" : "no");
+			 str_yes_no(test_bit(HCLGE_PTP_FLAG_EN, &ptp->flags)));
 	pos += scnprintf(buf + pos, len - pos, "ptp tx enable: %s\n",
-			 test_bit(HCLGE_PTP_FLAG_TX_EN, &ptp->flags) ?
-			 "yes" : "no");
+			 str_yes_no(test_bit(HCLGE_PTP_FLAG_TX_EN,
+					     &ptp->flags)));
 	pos += scnprintf(buf + pos, len - pos, "ptp rx enable: %s\n",
-			 test_bit(HCLGE_PTP_FLAG_RX_EN, &ptp->flags) ?
-			 "yes" : "no");
+			 str_yes_no(test_bit(HCLGE_PTP_FLAG_RX_EN,
+					     &ptp->flags)));
 
 	last_rx = jiffies_to_msecs(ptp->last_rx);
 	pos += scnprintf(buf + pos, len - pos, "last rx time: %lu.%lu\n",
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index aca96cf9d9684b..8be2c1c71fc49f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -8002,7 +8002,7 @@ static int hclge_set_loopback(struct hnae3_handle *handle,
 	ret = hclge_tqp_enable(handle, en);
 	if (ret)
 		dev_err(&hdev->pdev->dev, "failed to %s tqp in loopback, ret = %d\n",
-			en ? "enable" : "disable", ret);
+			str_enable_disable(en), ret);
 
 	return ret;
 }
@@ -11210,9 +11210,9 @@ static void hclge_info_show(struct hclge_dev *hdev)
 	dev_info(dev, "This is %s PF\n",
 		 hdev->flag & HCLGE_FLAG_MAIN ? "main" : "not main");
 	dev_info(dev, "DCB %s\n",
-		 handle->kinfo.tc_info.dcb_ets_active ? "enable" : "disable");
+		 str_enable_disable(handle->kinfo.tc_info.dcb_ets_active));
 	dev_info(dev, "MQPRIO %s\n",
-		 handle->kinfo.tc_info.mqprio_active ? "enable" : "disable");
+		 str_enable_disable(handle->kinfo.tc_info.mqprio_active));
 	dev_info(dev, "Default tx spare buffer size: %u\n",
 		 hdev->tx_spare_buf_size);
 
@@ -11986,7 +11986,7 @@ static int hclge_set_vf_spoofchk_hw(struct hclge_dev *hdev, int vf, bool enable)
 	if (ret) {
 		dev_err(&hdev->pdev->dev,
 			"Set vf %d mac spoof check %s failed, ret=%d\n",
-			vf, enable ? "on" : "off", ret);
+			vf, str_on_off(enable), ret);
 		return ret;
 	}
 
@@ -11994,7 +11994,7 @@ static int hclge_set_vf_spoofchk_hw(struct hclge_dev *hdev, int vf, bool enable)
 	if (ret)
 		dev_err(&hdev->pdev->dev,
 			"Set vf %d vlan spoof check %s failed, ret=%d\n",
-			vf, enable ? "on" : "off", ret);
+			vf, str_on_off(enable), ret);
 
 	return ret;
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c
index 16ef5a584af36b..4bd52eab391452 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_ptp.c
@@ -2,6 +2,7 @@
 // Copyright (c) 2021 Hisilicon Limited.
 
 #include <linux/skbuff.h>
+#include <linux/string_choices.h>
 #include "hclge_main.h"
 #include "hnae3.h"
 
@@ -226,7 +227,7 @@ static int hclge_ptp_int_en(struct hclge_dev *hdev, bool en)
 	if (ret)
 		dev_err(&hdev->pdev->dev,
 			"failed to %s ptp interrupt, ret = %d\n",
-			en ? "enable" : "disable", ret);
+			str_enable_disable(en), ret);
 
 	return ret;
 }
-- 
2.53.0



