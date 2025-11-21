Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 193E3346A14;
	Fri, 21 Nov 2025 13:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763730991; cv=none; b=H3juws8m7o2066zGdscp60s3Sk/xW2VPg6Bh9XZGIBfx5JJKXNEVPKrNvDM3t1NT4dGec56fVV/nn6HYPhzvC8dr+pmCrEIBINOpXRCY3/TKYekJh/am+UrbVLgF56zQn9/aHbfDwZFpZ0Cp+CPRd4gAJU36cqm2g3pjVRL0Nm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763730991; c=relaxed/simple;
	bh=4GcHp5bW5MTr3vT1NnGH2nG1yOjMwqNMFI6NjQep7W8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RlLtrWM8VgaboD8sgI6wpZn77XwCNUqyWCncev4HB6ZYg948mr/648Si7J79g7bFEs/ML+maQ/+La+PcYj5rn6lyiUYFpMqsCjJO9M2qUboofymDfBP1UyqlTDvg6MNdNX2kiI1wrw6rrRZHIvZG6WmW1tBIHVdjI5zfjOTvwu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=antM4rnE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="antM4rnE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EB06C4CEF1;
	Fri, 21 Nov 2025 13:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763730991;
	bh=4GcHp5bW5MTr3vT1NnGH2nG1yOjMwqNMFI6NjQep7W8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=antM4rnE9leCm1XTxe0/iAKhSvwHzU7SHBFUiinjGCsSMzzlfKr3CrF60rstVcSj1
	 LmzVzRe8n4yT49yEY2j+eF8P+mzHylbMUIMHwbZeUHQIL/p8fg9KloZbWVfP2tjZW9
	 4AVHzOWoEUOiXA5WPB0SXs96LJ+79ehMQoOEaxxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 045/247] ixgbe: handle IXGBE_VF_FEATURES_NEGOTIATE mbox cmd
Date: Fri, 21 Nov 2025 14:09:52 +0100
Message-ID: <20251121130156.219962575@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

From: Jedrzej Jagielski <jedrzej.jagielski@intel.com>

[ Upstream commit 823be089f9c8ab136ba382b516aedd3f7ac854bd ]

Send to VF information about features supported by the PF driver.

Increase API version to 1.7.

Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20251009-jk-iwl-net-2025-10-01-v3-5-ef32a425b92a@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_mbx.h  | 10 +++++
 .../net/ethernet/intel/ixgbe/ixgbe_sriov.c    | 37 +++++++++++++++++++
 2 files changed, 47 insertions(+)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_mbx.h b/drivers/net/ethernet/intel/ixgbe/ixgbe_mbx.h
index f7256a339c99b..0334ed4b8fa39 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_mbx.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_mbx.h
@@ -52,6 +52,7 @@ enum ixgbe_pfvf_api_rev {
 	ixgbe_mbox_api_14,	/* API version 1.4, linux/freebsd VF driver */
 	ixgbe_mbox_api_15,	/* API version 1.5, linux/freebsd VF driver */
 	ixgbe_mbox_api_16,	/* API version 1.6, linux/freebsd VF driver */
+	ixgbe_mbox_api_17,	/* API version 1.7, linux/freebsd VF driver */
 	/* This value should always be last */
 	ixgbe_mbox_api_unknown,	/* indicates that API version is not known */
 };
@@ -91,6 +92,9 @@ enum ixgbe_pfvf_api_rev {
 /* mailbox API, version 1.6 VF requests */
 #define IXGBE_VF_GET_PF_LINK_STATE	0x11 /* request PF to send link info */
 
+/* mailbox API, version 1.7 VF requests */
+#define IXGBE_VF_FEATURES_NEGOTIATE	0x12 /* get features supported by PF */
+
 /* length of permanent address message returned from PF */
 #define IXGBE_VF_PERMADDR_MSG_LEN 4
 /* word in permanent address message with the current multicast type */
@@ -101,6 +105,12 @@ enum ixgbe_pfvf_api_rev {
 #define IXGBE_VF_MBX_INIT_TIMEOUT 2000 /* number of retries on mailbox */
 #define IXGBE_VF_MBX_INIT_DELAY   500  /* microseconds between retries */
 
+/* features negotiated between PF/VF */
+#define IXGBEVF_PF_SUP_IPSEC		BIT(0)
+#define IXGBEVF_PF_SUP_ESX_MBX		BIT(1)
+
+#define IXGBE_SUPPORTED_FEATURES	IXGBEVF_PF_SUP_IPSEC
+
 struct ixgbe_hw;
 
 int ixgbe_read_mbx(struct ixgbe_hw *, u32 *, u16, u16);
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
index b09271d61a4ef..ee133d6749b37 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
@@ -511,6 +511,7 @@ static int ixgbe_set_vf_lpe(struct ixgbe_adapter *adapter, u32 max_frame, u32 vf
 		case ixgbe_mbox_api_13:
 		case ixgbe_mbox_api_14:
 		case ixgbe_mbox_api_16:
+		case ixgbe_mbox_api_17:
 			/* Version 1.1 supports jumbo frames on VFs if PF has
 			 * jumbo frames enabled which means legacy VFs are
 			 * disabled
@@ -1048,6 +1049,7 @@ static int ixgbe_negotiate_vf_api(struct ixgbe_adapter *adapter,
 	case ixgbe_mbox_api_13:
 	case ixgbe_mbox_api_14:
 	case ixgbe_mbox_api_16:
+	case ixgbe_mbox_api_17:
 		adapter->vfinfo[vf].vf_api = api;
 		return 0;
 	default:
@@ -1075,6 +1077,7 @@ static int ixgbe_get_vf_queues(struct ixgbe_adapter *adapter,
 	case ixgbe_mbox_api_13:
 	case ixgbe_mbox_api_14:
 	case ixgbe_mbox_api_16:
+	case ixgbe_mbox_api_17:
 		break;
 	default:
 		return -1;
@@ -1115,6 +1118,7 @@ static int ixgbe_get_vf_reta(struct ixgbe_adapter *adapter, u32 *msgbuf, u32 vf)
 
 	/* verify the PF is supporting the correct API */
 	switch (adapter->vfinfo[vf].vf_api) {
+	case ixgbe_mbox_api_17:
 	case ixgbe_mbox_api_16:
 	case ixgbe_mbox_api_14:
 	case ixgbe_mbox_api_13:
@@ -1149,6 +1153,7 @@ static int ixgbe_get_vf_rss_key(struct ixgbe_adapter *adapter,
 
 	/* verify the PF is supporting the correct API */
 	switch (adapter->vfinfo[vf].vf_api) {
+	case ixgbe_mbox_api_17:
 	case ixgbe_mbox_api_16:
 	case ixgbe_mbox_api_14:
 	case ixgbe_mbox_api_13:
@@ -1180,6 +1185,7 @@ static int ixgbe_update_vf_xcast_mode(struct ixgbe_adapter *adapter,
 	case ixgbe_mbox_api_13:
 	case ixgbe_mbox_api_14:
 	case ixgbe_mbox_api_16:
+	case ixgbe_mbox_api_17:
 		break;
 	default:
 		return -EOPNOTSUPP;
@@ -1251,6 +1257,7 @@ static int ixgbe_get_vf_link_state(struct ixgbe_adapter *adapter,
 	case ixgbe_mbox_api_13:
 	case ixgbe_mbox_api_14:
 	case ixgbe_mbox_api_16:
+	case ixgbe_mbox_api_17:
 		break;
 	default:
 		return -EOPNOTSUPP;
@@ -1278,6 +1285,7 @@ static int ixgbe_send_vf_link_status(struct ixgbe_adapter *adapter,
 
 	switch (adapter->vfinfo[vf].vf_api) {
 	case ixgbe_mbox_api_16:
+	case ixgbe_mbox_api_17:
 		if (hw->mac.type != ixgbe_mac_e610)
 			return -EOPNOTSUPP;
 		break;
@@ -1293,6 +1301,32 @@ static int ixgbe_send_vf_link_status(struct ixgbe_adapter *adapter,
 	return 0;
 }
 
+/**
+ * ixgbe_negotiate_vf_features -  negotiate supported features with VF driver
+ * @adapter: pointer to adapter struct
+ * @msgbuf: pointer to message buffers
+ * @vf: VF identifier
+ *
+ * Return: 0 on success or -EOPNOTSUPP when operation is not supported.
+ */
+static int ixgbe_negotiate_vf_features(struct ixgbe_adapter *adapter,
+				       u32 *msgbuf, u32 vf)
+{
+	u32 features = msgbuf[1];
+
+	switch (adapter->vfinfo[vf].vf_api) {
+	case ixgbe_mbox_api_17:
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	features &= IXGBE_SUPPORTED_FEATURES;
+	msgbuf[1] = features;
+
+	return 0;
+}
+
 static int ixgbe_rcv_msg_from_vf(struct ixgbe_adapter *adapter, u32 vf)
 {
 	u32 mbx_size = IXGBE_VFMAILBOX_SIZE;
@@ -1370,6 +1404,9 @@ static int ixgbe_rcv_msg_from_vf(struct ixgbe_adapter *adapter, u32 vf)
 	case IXGBE_VF_GET_PF_LINK_STATE:
 		retval = ixgbe_send_vf_link_status(adapter, msgbuf, vf);
 		break;
+	case IXGBE_VF_FEATURES_NEGOTIATE:
+		retval = ixgbe_negotiate_vf_features(adapter, msgbuf, vf);
+		break;
 	default:
 		e_err(drv, "Unhandled Msg %8.8x\n", msgbuf[0]);
 		retval = -EIO;
-- 
2.51.0



