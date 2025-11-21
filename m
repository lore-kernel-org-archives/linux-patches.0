Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4509F23183B;
	Fri, 21 Nov 2025 13:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763730939; cv=none; b=U4kbKI7Fjz2JwibQ6oAaR4JPb3ImITaaUsxCR4Q04Nk324qTRGlggXUCXc0y9xM99mzVCRQb/OsG6ZYblAGszRashrM2MZQBH75SLFmWopyzWA2Zju5MFoDWiaqG8Ru7pbrRcBFdNjaeKBjp1Ii9rNYu/LK792TiJ2CC8VwhKqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763730939; c=relaxed/simple;
	bh=nhw1rnV6iPkarIDWN/8aBB5nR78wpYJq6FtcAA532Qc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pb0c++W1fO6/4jdabpdQjxVLhlt/Ol0MtAUhDGATWThuCO651i3mubKS343Q7gTVcE7xb953NHNjE5JO1idVt9BLo5urMEEdFkF0uE9AN5F3Gn05d8BP/kHfCCnybeG0ecMKRA9IGWh6TbcmgPJ5QiPDZ2m3GsdVwwnmC118urE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ENtrFn/O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ENtrFn/O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAF3EC4CEF1;
	Fri, 21 Nov 2025 13:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763730939;
	bh=nhw1rnV6iPkarIDWN/8aBB5nR78wpYJq6FtcAA532Qc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ENtrFn/Ozrcm6h2UQpNQsHLnroblljiPVHcgmJGbaay1J7u7OLq8p16aGkDovp8KB
	 lDqPA6fRwE4uKA2+PXPtKfiXGrKwLLUN1cSrr/3TzPc5yEIxl/g4blvRITFi3BLmf9
	 WKLhqRXe/c/Ga+1ZrOA00pPEZIe32P7S5yxdaTBE=
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
Subject: [PATCH 6.17 034/247] ixgbe: handle IXGBE_VF_GET_PF_LINK_STATE mailbox operation
Date: Fri, 21 Nov 2025 14:09:41 +0100
Message-ID: <20251121130155.828422497@linuxfoundation.org>
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

[ Upstream commit f7f97cbc03a470ce405d48dedb7f135713caa0fa ]

Update supported API version and provide handler for
IXGBE_VF_GET_PF_LINK_STATE cmd.
Simply put stored values of link speed and link_up from adapter context.

Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Link: https://lore.kernel.org/stable/20250828095227.1857066-3-jedrzej.jagielski%40intel.com
Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20251009-jk-iwl-net-2025-10-01-v3-3-ef32a425b92a@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_mbx.h  |  5 +++
 .../net/ethernet/intel/ixgbe/ixgbe_sriov.c    | 42 +++++++++++++++++++
 2 files changed, 47 insertions(+)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_mbx.h b/drivers/net/ethernet/intel/ixgbe/ixgbe_mbx.h
index 4af149b63a39f..f7256a339c99b 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_mbx.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_mbx.h
@@ -50,6 +50,8 @@ enum ixgbe_pfvf_api_rev {
 	ixgbe_mbox_api_12,	/* API version 1.2, linux/freebsd VF driver */
 	ixgbe_mbox_api_13,	/* API version 1.3, linux/freebsd VF driver */
 	ixgbe_mbox_api_14,	/* API version 1.4, linux/freebsd VF driver */
+	ixgbe_mbox_api_15,	/* API version 1.5, linux/freebsd VF driver */
+	ixgbe_mbox_api_16,	/* API version 1.6, linux/freebsd VF driver */
 	/* This value should always be last */
 	ixgbe_mbox_api_unknown,	/* indicates that API version is not known */
 };
@@ -86,6 +88,9 @@ enum ixgbe_pfvf_api_rev {
 
 #define IXGBE_VF_GET_LINK_STATE 0x10 /* get vf link state */
 
+/* mailbox API, version 1.6 VF requests */
+#define IXGBE_VF_GET_PF_LINK_STATE	0x11 /* request PF to send link info */
+
 /* length of permanent address message returned from PF */
 #define IXGBE_VF_PERMADDR_MSG_LEN 4
 /* word in permanent address message with the current multicast type */
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
index 32ac1e020d915..b09271d61a4ef 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
@@ -510,6 +510,7 @@ static int ixgbe_set_vf_lpe(struct ixgbe_adapter *adapter, u32 max_frame, u32 vf
 		case ixgbe_mbox_api_12:
 		case ixgbe_mbox_api_13:
 		case ixgbe_mbox_api_14:
+		case ixgbe_mbox_api_16:
 			/* Version 1.1 supports jumbo frames on VFs if PF has
 			 * jumbo frames enabled which means legacy VFs are
 			 * disabled
@@ -1046,6 +1047,7 @@ static int ixgbe_negotiate_vf_api(struct ixgbe_adapter *adapter,
 	case ixgbe_mbox_api_12:
 	case ixgbe_mbox_api_13:
 	case ixgbe_mbox_api_14:
+	case ixgbe_mbox_api_16:
 		adapter->vfinfo[vf].vf_api = api;
 		return 0;
 	default:
@@ -1072,6 +1074,7 @@ static int ixgbe_get_vf_queues(struct ixgbe_adapter *adapter,
 	case ixgbe_mbox_api_12:
 	case ixgbe_mbox_api_13:
 	case ixgbe_mbox_api_14:
+	case ixgbe_mbox_api_16:
 		break;
 	default:
 		return -1;
@@ -1112,6 +1115,7 @@ static int ixgbe_get_vf_reta(struct ixgbe_adapter *adapter, u32 *msgbuf, u32 vf)
 
 	/* verify the PF is supporting the correct API */
 	switch (adapter->vfinfo[vf].vf_api) {
+	case ixgbe_mbox_api_16:
 	case ixgbe_mbox_api_14:
 	case ixgbe_mbox_api_13:
 	case ixgbe_mbox_api_12:
@@ -1145,6 +1149,7 @@ static int ixgbe_get_vf_rss_key(struct ixgbe_adapter *adapter,
 
 	/* verify the PF is supporting the correct API */
 	switch (adapter->vfinfo[vf].vf_api) {
+	case ixgbe_mbox_api_16:
 	case ixgbe_mbox_api_14:
 	case ixgbe_mbox_api_13:
 	case ixgbe_mbox_api_12:
@@ -1174,6 +1179,7 @@ static int ixgbe_update_vf_xcast_mode(struct ixgbe_adapter *adapter,
 		fallthrough;
 	case ixgbe_mbox_api_13:
 	case ixgbe_mbox_api_14:
+	case ixgbe_mbox_api_16:
 		break;
 	default:
 		return -EOPNOTSUPP;
@@ -1244,6 +1250,7 @@ static int ixgbe_get_vf_link_state(struct ixgbe_adapter *adapter,
 	case ixgbe_mbox_api_12:
 	case ixgbe_mbox_api_13:
 	case ixgbe_mbox_api_14:
+	case ixgbe_mbox_api_16:
 		break;
 	default:
 		return -EOPNOTSUPP;
@@ -1254,6 +1261,38 @@ static int ixgbe_get_vf_link_state(struct ixgbe_adapter *adapter,
 	return 0;
 }
 
+/**
+ * ixgbe_send_vf_link_status - send link status data to VF
+ * @adapter: pointer to adapter struct
+ * @msgbuf: pointer to message buffers
+ * @vf: VF identifier
+ *
+ * Reply for IXGBE_VF_GET_PF_LINK_STATE mbox command sending link status data.
+ *
+ * Return: 0 on success or -EOPNOTSUPP when operation is not supported.
+ */
+static int ixgbe_send_vf_link_status(struct ixgbe_adapter *adapter,
+				     u32 *msgbuf, u32 vf)
+{
+	struct ixgbe_hw *hw = &adapter->hw;
+
+	switch (adapter->vfinfo[vf].vf_api) {
+	case ixgbe_mbox_api_16:
+		if (hw->mac.type != ixgbe_mac_e610)
+			return -EOPNOTSUPP;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+	/* Simply provide stored values as watchdog & link status events take
+	 * care of its freshness.
+	 */
+	msgbuf[1] = adapter->link_speed;
+	msgbuf[2] = adapter->link_up;
+
+	return 0;
+}
+
 static int ixgbe_rcv_msg_from_vf(struct ixgbe_adapter *adapter, u32 vf)
 {
 	u32 mbx_size = IXGBE_VFMAILBOX_SIZE;
@@ -1328,6 +1367,9 @@ static int ixgbe_rcv_msg_from_vf(struct ixgbe_adapter *adapter, u32 vf)
 	case IXGBE_VF_IPSEC_DEL:
 		retval = ixgbe_ipsec_vf_del_sa(adapter, msgbuf, vf);
 		break;
+	case IXGBE_VF_GET_PF_LINK_STATE:
+		retval = ixgbe_send_vf_link_status(adapter, msgbuf, vf);
+		break;
 	default:
 		e_err(drv, "Unhandled Msg %8.8x\n", msgbuf[0]);
 		retval = -EIO;
-- 
2.51.0



