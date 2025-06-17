Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A84CA4B;
	Tue, 17 Jun 2025 16:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179313; cv=none; b=BenPfg065vzLY45UGqm55rzRKbjtRVjhkmOQicrQikS7p0jlMrxaHfW0pKi5ap9t99oZe97Dr3X2JuTCU+iknd54w3f9XnmWU5F2Ut74MtQszqzT7mek+p0GVJ7HwUacJXGmV9gcjgYSPqz0SO12tVd7ywmdqigIHnGhYw9nfu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179313; c=relaxed/simple;
	bh=jiIVU2OdoLQFTb6Yx8aadgjgbfLufocnExb9WHI0XTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZcaOfeW/gVztn1E3mrgtNDnVW40j1rkLqPoziPsN3SWK2u81crcSBFJGIm/QF6po3JkevC6p2feV8sojiYi36NQD+YFDID52zwxRoUU1ArnHb+rmMDngVQEPok4O+s96wMrGJuy+3OHAPACJJDqK2XfHhegmHT2Z+noiwPfxMQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xFjASmhs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xFjASmhs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 683A6C4CEE3;
	Tue, 17 Jun 2025 16:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179312;
	bh=jiIVU2OdoLQFTb6Yx8aadgjgbfLufocnExb9WHI0XTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xFjASmhsHw5Ac5OVK1zFpBUMJTRvqyLbX1A0l9+S+BKN+eGJqXGVPdjr4qysTxvgq
	 EGSyJZrOSE2P89Nb6XcRYCVUuBcut4oS8Ar+N3vwIDaqUaj125I3kt7f0m9xAvX6vV
	 FspPgdFUbQFMbwtEDGg48Am/UFQEG9NErxfJuk9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Parth Pancholi <parth.pancholi@toradex.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 678/780] wifi: ath12k: fix GCC_GCC_PCIE_HOT_RST definition for WCN7850
Date: Tue, 17 Jun 2025 17:26:26 +0200
Message-ID: <20250617152519.078644614@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baochen Qiang <quic_bqiang@quicinc.com>

[ Upstream commit 7588a893cde5385ad308400ff167d29a29913b3a ]

GCC_GCC_PCIE_HOT_RST is wrongly defined for WCN7850, causing kernel crash
on some specific platforms.

Since this register is divergent for WCN7850 and QCN9274, move it to
register table to allow different definitions. Then correct the register
address for WCN7850 to fix this issue.

Note IPQ5332 is not affected as it is not PCIe based device.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3

Signed-off-by: Baochen Qiang <quic_bqiang@quicinc.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Reported-by: Parth Pancholi <parth.pancholi@toradex.com>
Closes: https://lore.kernel.org/all/86899b2235a59c9134603beebe08f2bb0b244ea0.camel@gmail.com
Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Tested-by: Parth Pancholi <parth.pancholi@toradex.com>
Link: https://patch.msgid.link/20250523-ath12k-wrong-global-reset-addr-v1-1-3b06eb556196@quicinc.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/hw.c  | 6 ++++++
 drivers/net/wireless/ath/ath12k/hw.h  | 2 ++
 drivers/net/wireless/ath/ath12k/pci.c | 6 +++---
 drivers/net/wireless/ath/ath12k/pci.h | 4 +++-
 4 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/hw.c b/drivers/net/wireless/ath/ath12k/hw.c
index 4c9d6c42fbb92..1bfb11bae7add 100644
--- a/drivers/net/wireless/ath/ath12k/hw.c
+++ b/drivers/net/wireless/ath/ath12k/hw.c
@@ -690,6 +690,8 @@ static const struct ath12k_hw_regs qcn9274_v1_regs = {
 	.hal_umac_ce0_dest_reg_base = 0x01b81000,
 	.hal_umac_ce1_src_reg_base = 0x01b82000,
 	.hal_umac_ce1_dest_reg_base = 0x01b83000,
+
+	.gcc_gcc_pcie_hot_rst = 0x1e38338,
 };
 
 static const struct ath12k_hw_regs qcn9274_v2_regs = {
@@ -779,6 +781,8 @@ static const struct ath12k_hw_regs qcn9274_v2_regs = {
 	.hal_umac_ce0_dest_reg_base = 0x01b81000,
 	.hal_umac_ce1_src_reg_base = 0x01b82000,
 	.hal_umac_ce1_dest_reg_base = 0x01b83000,
+
+	.gcc_gcc_pcie_hot_rst = 0x1e38338,
 };
 
 static const struct ath12k_hw_regs wcn7850_regs = {
@@ -864,6 +868,8 @@ static const struct ath12k_hw_regs wcn7850_regs = {
 	.hal_umac_ce0_dest_reg_base = 0x01b81000,
 	.hal_umac_ce1_src_reg_base = 0x01b82000,
 	.hal_umac_ce1_dest_reg_base = 0x01b83000,
+
+	.gcc_gcc_pcie_hot_rst = 0x1e40304,
 };
 
 static const struct ath12k_hw_hal_params ath12k_hw_hal_params_qcn9274 = {
diff --git a/drivers/net/wireless/ath/ath12k/hw.h b/drivers/net/wireless/ath/ath12k/hw.h
index acb81b5798ac1..862b11325a902 100644
--- a/drivers/net/wireless/ath/ath12k/hw.h
+++ b/drivers/net/wireless/ath/ath12k/hw.h
@@ -355,6 +355,8 @@ struct ath12k_hw_regs {
 	u32 hal_reo_cmd_ring_base;
 
 	u32 hal_reo_status_ring_base;
+
+	u32 gcc_gcc_pcie_hot_rst;
 };
 
 static inline const char *ath12k_bd_ie_type_str(enum ath12k_bd_ie_type type)
diff --git a/drivers/net/wireless/ath/ath12k/pci.c b/drivers/net/wireless/ath/ath12k/pci.c
index 273f4bc260bfe..2e7d302ace679 100644
--- a/drivers/net/wireless/ath/ath12k/pci.c
+++ b/drivers/net/wireless/ath/ath12k/pci.c
@@ -292,10 +292,10 @@ static void ath12k_pci_enable_ltssm(struct ath12k_base *ab)
 
 	ath12k_dbg(ab, ATH12K_DBG_PCI, "pci ltssm 0x%x\n", val);
 
-	val = ath12k_pci_read32(ab, GCC_GCC_PCIE_HOT_RST);
+	val = ath12k_pci_read32(ab, GCC_GCC_PCIE_HOT_RST(ab));
 	val |= GCC_GCC_PCIE_HOT_RST_VAL;
-	ath12k_pci_write32(ab, GCC_GCC_PCIE_HOT_RST, val);
-	val = ath12k_pci_read32(ab, GCC_GCC_PCIE_HOT_RST);
+	ath12k_pci_write32(ab, GCC_GCC_PCIE_HOT_RST(ab), val);
+	val = ath12k_pci_read32(ab, GCC_GCC_PCIE_HOT_RST(ab));
 
 	ath12k_dbg(ab, ATH12K_DBG_PCI, "pci pcie_hot_rst 0x%x\n", val);
 
diff --git a/drivers/net/wireless/ath/ath12k/pci.h b/drivers/net/wireless/ath/ath12k/pci.h
index 31584a7ad80eb..9321674eef8b8 100644
--- a/drivers/net/wireless/ath/ath12k/pci.h
+++ b/drivers/net/wireless/ath/ath12k/pci.h
@@ -28,7 +28,9 @@
 #define PCIE_PCIE_PARF_LTSSM			0x1e081b0
 #define PARM_LTSSM_VALUE			0x111
 
-#define GCC_GCC_PCIE_HOT_RST			0x1e38338
+#define GCC_GCC_PCIE_HOT_RST(ab) \
+	((ab)->hw_params->regs->gcc_gcc_pcie_hot_rst)
+
 #define GCC_GCC_PCIE_HOT_RST_VAL		0x10
 
 #define PCIE_PCIE_INT_ALL_CLEAR			0x1e08228
-- 
2.39.5



