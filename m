Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F401E4B2;
	Wed, 21 Feb 2024 13:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522849; cv=none; b=Zv9Ahmqcy9ETigMVyBog5jtzCiM6hStehs5MUxRArQn/jJrSlq54UO0rHB6cxblQ12U13XOk69qKsf9Z8Ruwo0Y3L79Z2nJSoiRUSLiHh/VFKQ1J+zVH9nQLH8HYjWDN4ijb1v8otq1EcxUyxKEJGWOy1JhjVQgxtVSvxf2SVt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522849; c=relaxed/simple;
	bh=31M57er0I0lZWxWkeqW1wwktzmKbwHa1SYbtX7xYzE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hLRaCI21Ki+GRe+cvPYGRmMiqSIASgBlocJC6ChGuYLDVXkjTeuNbrGAsNSUsHY5PXSc9R24+S3roaAVzbfB/KDYZ2SmrSaS9vVvyBefcPY/YuqzKI+OtaGVIL8hLjMLoYgF379aL0J57KmnwQgBm78E0UItrBjPXVmtBVmE64A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ddKMsroI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ddKMsroI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 196F9C433F1;
	Wed, 21 Feb 2024 13:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522849;
	bh=31M57er0I0lZWxWkeqW1wwktzmKbwHa1SYbtX7xYzE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ddKMsroIzrkcvmfhgxWYvyAeipIuzWCDqKPpOacZLQgBD4FEAraWT6GVONWmrFxgq
	 h4EGMxiL0H1oJMqqnKwCXsoInLyCZ2/Yp7lfGBGkCBZe9Dn93WWFdguqeWTisw03do
	 WMQqYNlxKMU/8Ckz6TB42OHWJa/K9G1ZfJJwF/Is=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Piotr Skajewski <piotrx.skajewski@intel.com>,
	Dave Switzer <david.switzer@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 276/476] ixgbe: Remove non-inclusive language
Date: Wed, 21 Feb 2024 14:05:27 +0100
Message-ID: <20240221130018.168609719@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Piotr Skajewski <piotrx.skajewski@intel.com>

[ Upstream commit 93b067f154b3edfd3d75a272fd9433bf787e2e1d ]

Remove non-inclusive language from the driver.

Additionally correct the duplication "from from"
reported by checkpatch after the changes above.

Signed-off-by: Piotr Skajewski <piotrx.skajewski@intel.com>
Tested-by: Dave Switzer <david.switzer@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Stable-dep-of: bbc404d20d1b ("ixgbe: Fix an error handling path in ixgbe_read_iosf_sb_reg_x550()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/intel/ixgbe/ixgbe_common.c   | 36 +++++++++----------
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  4 +--
 drivers/net/ethernet/intel/ixgbe/ixgbe_type.h | 10 +++---
 3 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
index e90b5047e695..4c26c4b92f07 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
@@ -30,7 +30,7 @@ static s32 ixgbe_write_eeprom_buffer_bit_bang(struct ixgbe_hw *hw, u16 offset,
 					     u16 words, u16 *data);
 static s32 ixgbe_detect_eeprom_page_size_generic(struct ixgbe_hw *hw,
 						 u16 offset);
-static s32 ixgbe_disable_pcie_master(struct ixgbe_hw *hw);
+static s32 ixgbe_disable_pcie_primary(struct ixgbe_hw *hw);
 
 /* Base table for registers values that change by MAC */
 const u32 ixgbe_mvals_8259X[IXGBE_MVALS_IDX_LIMIT] = {
@@ -746,10 +746,10 @@ s32 ixgbe_stop_adapter_generic(struct ixgbe_hw *hw)
 	usleep_range(1000, 2000);
 
 	/*
-	 * Prevent the PCI-E bus from from hanging by disabling PCI-E master
+	 * Prevent the PCI-E bus from hanging by disabling PCI-E primary
 	 * access and verify no pending requests
 	 */
-	return ixgbe_disable_pcie_master(hw);
+	return ixgbe_disable_pcie_primary(hw);
 }
 
 /**
@@ -2506,15 +2506,15 @@ static u32 ixgbe_pcie_timeout_poll(struct ixgbe_hw *hw)
 }
 
 /**
- *  ixgbe_disable_pcie_master - Disable PCI-express master access
+ *  ixgbe_disable_pcie_primary - Disable PCI-express primary access
  *  @hw: pointer to hardware structure
  *
- *  Disables PCI-Express master access and verifies there are no pending
- *  requests. IXGBE_ERR_MASTER_REQUESTS_PENDING is returned if master disable
- *  bit hasn't caused the master requests to be disabled, else 0
- *  is returned signifying master requests disabled.
+ *  Disables PCI-Express primary access and verifies there are no pending
+ *  requests. IXGBE_ERR_PRIMARY_REQUESTS_PENDING is returned if primary disable
+ *  bit hasn't caused the primary requests to be disabled, else 0
+ *  is returned signifying primary requests disabled.
  **/
-static s32 ixgbe_disable_pcie_master(struct ixgbe_hw *hw)
+static s32 ixgbe_disable_pcie_primary(struct ixgbe_hw *hw)
 {
 	u32 i, poll;
 	u16 value;
@@ -2523,23 +2523,23 @@ static s32 ixgbe_disable_pcie_master(struct ixgbe_hw *hw)
 	IXGBE_WRITE_REG(hw, IXGBE_CTRL, IXGBE_CTRL_GIO_DIS);
 
 	/* Poll for bit to read as set */
-	for (i = 0; i < IXGBE_PCI_MASTER_DISABLE_TIMEOUT; i++) {
+	for (i = 0; i < IXGBE_PCI_PRIMARY_DISABLE_TIMEOUT; i++) {
 		if (IXGBE_READ_REG(hw, IXGBE_CTRL) & IXGBE_CTRL_GIO_DIS)
 			break;
 		usleep_range(100, 120);
 	}
-	if (i >= IXGBE_PCI_MASTER_DISABLE_TIMEOUT) {
+	if (i >= IXGBE_PCI_PRIMARY_DISABLE_TIMEOUT) {
 		hw_dbg(hw, "GIO disable did not set - requesting resets\n");
 		goto gio_disable_fail;
 	}
 
-	/* Exit if master requests are blocked */
+	/* Exit if primary requests are blocked */
 	if (!(IXGBE_READ_REG(hw, IXGBE_STATUS) & IXGBE_STATUS_GIO) ||
 	    ixgbe_removed(hw->hw_addr))
 		return 0;
 
-	/* Poll for master request bit to clear */
-	for (i = 0; i < IXGBE_PCI_MASTER_DISABLE_TIMEOUT; i++) {
+	/* Poll for primary request bit to clear */
+	for (i = 0; i < IXGBE_PCI_PRIMARY_DISABLE_TIMEOUT; i++) {
 		udelay(100);
 		if (!(IXGBE_READ_REG(hw, IXGBE_STATUS) & IXGBE_STATUS_GIO))
 			return 0;
@@ -2547,13 +2547,13 @@ static s32 ixgbe_disable_pcie_master(struct ixgbe_hw *hw)
 
 	/*
 	 * Two consecutive resets are required via CTRL.RST per datasheet
-	 * 5.2.5.3.2 Master Disable.  We set a flag to inform the reset routine
-	 * of this need.  The first reset prevents new master requests from
+	 * 5.2.5.3.2 Primary Disable.  We set a flag to inform the reset routine
+	 * of this need.  The first reset prevents new primary requests from
 	 * being issued by our device.  We then must wait 1usec or more for any
 	 * remaining completions from the PCIe bus to trickle in, and then reset
 	 * again to clear out any effects they may have had on our device.
 	 */
-	hw_dbg(hw, "GIO Master Disable bit didn't clear - requesting resets\n");
+	hw_dbg(hw, "GIO Primary Disable bit didn't clear - requesting resets\n");
 gio_disable_fail:
 	hw->mac.flags |= IXGBE_FLAGS_DOUBLE_RESET_REQUIRED;
 
@@ -2575,7 +2575,7 @@ static s32 ixgbe_disable_pcie_master(struct ixgbe_hw *hw)
 	}
 
 	hw_dbg(hw, "PCIe transaction pending bit also did not clear.\n");
-	return IXGBE_ERR_MASTER_REQUESTS_PENDING;
+	return IXGBE_ERR_PRIMARY_REQUESTS_PENDING;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 819169eaebe9..985c58d8b918 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -5943,8 +5943,8 @@ void ixgbe_reset(struct ixgbe_adapter *adapter)
 	case IXGBE_ERR_SFP_NOT_PRESENT:
 	case IXGBE_ERR_SFP_NOT_SUPPORTED:
 		break;
-	case IXGBE_ERR_MASTER_REQUESTS_PENDING:
-		e_dev_err("master disable timed out\n");
+	case IXGBE_ERR_PRIMARY_REQUESTS_PENDING:
+		e_dev_err("primary disable timed out\n");
 		break;
 	case IXGBE_ERR_EEPROM_VERSION:
 		/* We are running on a pre-production device, log a warning */
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h b/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h
index 2647937f7f4d..6da9880d766a 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h
@@ -1247,7 +1247,7 @@ struct ixgbe_nvm_version {
 #define IXGBE_PSRTYPE_RQPL_SHIFT    29
 
 /* CTRL Bit Masks */
-#define IXGBE_CTRL_GIO_DIS      0x00000004 /* Global IO Master Disable bit */
+#define IXGBE_CTRL_GIO_DIS      0x00000004 /* Global IO Primary Disable bit */
 #define IXGBE_CTRL_LNK_RST      0x00000008 /* Link Reset. Resets everything. */
 #define IXGBE_CTRL_RST          0x04000000 /* Reset (SW) */
 #define IXGBE_CTRL_RST_MASK     (IXGBE_CTRL_LNK_RST | IXGBE_CTRL_RST)
@@ -1811,7 +1811,7 @@ enum {
 /* STATUS Bit Masks */
 #define IXGBE_STATUS_LAN_ID         0x0000000C /* LAN ID */
 #define IXGBE_STATUS_LAN_ID_SHIFT   2          /* LAN ID Shift*/
-#define IXGBE_STATUS_GIO            0x00080000 /* GIO Master Enable Status */
+#define IXGBE_STATUS_GIO            0x00080000 /* GIO Primary Enable Status */
 
 #define IXGBE_STATUS_LAN_ID_0   0x00000000 /* LAN ID 0 */
 #define IXGBE_STATUS_LAN_ID_1   0x00000004 /* LAN ID 1 */
@@ -2193,8 +2193,8 @@ enum {
 #define IXGBE_PCIDEVCTRL2_4_8s		0xd
 #define IXGBE_PCIDEVCTRL2_17_34s	0xe
 
-/* Number of 100 microseconds we wait for PCI Express master disable */
-#define IXGBE_PCI_MASTER_DISABLE_TIMEOUT	800
+/* Number of 100 microseconds we wait for PCI Express primary disable */
+#define IXGBE_PCI_PRIMARY_DISABLE_TIMEOUT	800
 
 /* RAH */
 #define IXGBE_RAH_VIND_MASK     0x003C0000
@@ -3671,7 +3671,7 @@ struct ixgbe_info {
 #define IXGBE_ERR_ADAPTER_STOPPED               -9
 #define IXGBE_ERR_INVALID_MAC_ADDR              -10
 #define IXGBE_ERR_DEVICE_NOT_SUPPORTED          -11
-#define IXGBE_ERR_MASTER_REQUESTS_PENDING       -12
+#define IXGBE_ERR_PRIMARY_REQUESTS_PENDING      -12
 #define IXGBE_ERR_INVALID_LINK_SETTINGS         -13
 #define IXGBE_ERR_AUTONEG_NOT_COMPLETE          -14
 #define IXGBE_ERR_RESET_FAILED                  -15
-- 
2.43.0



