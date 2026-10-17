Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08D2C385D7B;
	Sat, 17 Oct 2026 17:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258188; cv=none; b=HOnKeR4gZnjH7vG9omvVixqCzsIARjj+rDIRR/RaNxX7wuqKttb7Nr4/HKLFzoJ64jdYG/iBEmDFvjkDH5eVo+bnlNl2j+iQ1GI+WKwe8XWuxjz+4e3j22Uuy37Bo6i4Ixi2TO9MoMKIViDiPv7uSdvcjcqWIPxDWSEvQmWkLzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258188; c=relaxed/simple;
	bh=SyRyYNAFKvoWeDCLdGFBgV3UFpc+gmJj5JIg2xHuaak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EcQjnCTuPiD86aaYA7hFW5W3QAdDU4QLimfb46VJQKwHCCTxTQTEp4Np9SuGQ55jR6NOwA+66BbjlsgiOmGM/6AjUWcYjjoHVLbTPPVjS4BIQzL/zNbDt8/2Ec+u5jhp1YRINCVuGK8dyEXzXjfjdtxr/LEl/DK0kQBaV/RYIis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=usKPmP9m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="usKPmP9m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 545401F000C4;
	Sat, 17 Oct 2026 17:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258186;
	bh=fHoVSD/Hc0MvevSOVjHuN629K3lAvrRr6xNOJ4Lb3jw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=usKPmP9m8BNqQ4PcbTsKQyHaSjDSIjY+JCF+ZpHwgek+hCmkrxMF0nK4G2gwfmtTi
	 ddwDlDwOWBSE/4LKN6xJjrBCS/ey6yQqBaShDhBtHxvDTNuRc0B7XsboCCVKvnIf17
	 8tkZUGYdv4/H8V9yD8rGN9r/bc+J1xaoOStLqEu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Parth Pancholi <parth.pancholi@toradex.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0758/1674] wifi: ath12k: fix GCC_GCC_PCIE_HOT_RST definition for WCN7850
Date: Sat, 17 Oct 2026 17:50:30 +0200
Message-ID: <20261017160450.558786935@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 97ed179be2283..bcd799b514ce9 100644
--- a/drivers/net/wireless/ath/ath12k/hw.c
+++ b/drivers/net/wireless/ath/ath12k/hw.c
@@ -673,6 +673,8 @@ static const struct ath12k_hw_regs qcn9274_v1_regs = {
 
 	/* REO status ring address */
 	.hal_reo_status_ring_base = 0x00000a84,
+
+	.gcc_gcc_pcie_hot_rst = 0x1e38338,
 };
 
 static const struct ath12k_hw_regs qcn9274_v2_regs = {
@@ -753,6 +755,8 @@ static const struct ath12k_hw_regs qcn9274_v2_regs = {
 
 	/* REO status ring address */
 	.hal_reo_status_ring_base = 0x00000aa0,
+
+	.gcc_gcc_pcie_hot_rst = 0x1e38338,
 };
 
 static const struct ath12k_hw_regs wcn7850_regs = {
@@ -829,6 +833,8 @@ static const struct ath12k_hw_regs wcn7850_regs = {
 
 	/* REO status ring address */
 	.hal_reo_status_ring_base = 0x00000a84,
+
+	.gcc_gcc_pcie_hot_rst = 0x1e40304,
 };
 
 static const struct ath12k_hw_hal_params ath12k_hw_hal_params_qcn9274 = {
diff --git a/drivers/net/wireless/ath/ath12k/hw.h b/drivers/net/wireless/ath/ath12k/hw.h
index 0b0b2a4f70f28..a56e5e504b9d3 100644
--- a/drivers/net/wireless/ath/ath12k/hw.h
+++ b/drivers/net/wireless/ath/ath12k/hw.h
@@ -307,6 +307,8 @@ struct ath12k_hw_regs {
 	u32 hal_reo_cmd_ring_base;
 
 	u32 hal_reo_status_ring_base;
+
+	u32 gcc_gcc_pcie_hot_rst;
 };
 
 int ath12k_hw_init(struct ath12k_base *ab);
diff --git a/drivers/net/wireless/ath/ath12k/pci.c b/drivers/net/wireless/ath/ath12k/pci.c
index 62be78de33001..8db438988ae22 100644
--- a/drivers/net/wireless/ath/ath12k/pci.c
+++ b/drivers/net/wireless/ath/ath12k/pci.c
@@ -280,10 +280,10 @@ static void ath12k_pci_enable_ltssm(struct ath12k_base *ab)
 
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
index 9a17a7dcdd6a6..74dffd7b75494 100644
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
2.53.0



