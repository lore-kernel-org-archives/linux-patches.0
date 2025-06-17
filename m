Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A892FA644;
	Tue, 17 Jun 2025 16:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178046; cv=none; b=MOn1TJp03ohOUOqviSUtVI3nJnaJ5T6Zw4q72JEzBeZw/I5empdwZSyGETAhshDDBzSaIA8PEFnsO64fGoq/SOsk30xEb3tEtlYaS1GtQV+3b4TeoPk7gmR0foIIXF92pAF+VPa0Di1Iat4YbGfiucU5Ytp4ushO6q7rqAoqljo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178046; c=relaxed/simple;
	bh=9Pa3qeumsF47zbyGk1PNT5mKQHtIm54ZZX3z+cf/5eU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S8sd7gqdH6rWBGBxLp53KpiNwH6q/42uJPs56jjJ5sjtZ3k0LBMvwVH6SFuKOcAG81+XVAGsIFisGaVubSxSmb9a6pAW3iJnnk9EY0tEDdRzPfsV+x6/U+qskWoMw6sRDT7vCodekyBpHsb2eSAiWtdMMln0It37hz8w2+NJPBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pAftVlfb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pAftVlfb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E37E7C4CEE7;
	Tue, 17 Jun 2025 16:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178046;
	bh=9Pa3qeumsF47zbyGk1PNT5mKQHtIm54ZZX3z+cf/5eU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pAftVlfbQGQbvRk5xeaoHbbijMHtEIs1sH4QfV+o3xeOord2Z+aV1TnrYa+j3JIhM
	 MBkyu+/mWoj0f8Lh/qNRVTh7DCPwdcrLteCY8WpJ4hjXNJ2HyjKC8OnJ+d3XeU3WQB
	 gmGVqUkW/ANdJWvrAQ5f+8TyZ6H4JWIivVhyOytY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Parth Pancholi <parth.pancholi@toradex.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 436/512] wifi: ath12k: fix GCC_GCC_PCIE_HOT_RST definition for WCN7850
Date: Tue, 17 Jun 2025 17:26:42 +0200
Message-ID: <20250617152437.238305339@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5bffc428f19f5..e3eb22bb9e1cb 100644
--- a/drivers/net/wireless/ath/ath12k/hw.c
+++ b/drivers/net/wireless/ath/ath12k/hw.c
@@ -686,6 +686,8 @@ static const struct ath12k_hw_regs qcn9274_v1_regs = {
 	.hal_umac_ce0_dest_reg_base = 0x01b81000,
 	.hal_umac_ce1_src_reg_base = 0x01b82000,
 	.hal_umac_ce1_dest_reg_base = 0x01b83000,
+
+	.gcc_gcc_pcie_hot_rst = 0x1e38338,
 };
 
 static const struct ath12k_hw_regs qcn9274_v2_regs = {
@@ -775,6 +777,8 @@ static const struct ath12k_hw_regs qcn9274_v2_regs = {
 	.hal_umac_ce0_dest_reg_base = 0x01b81000,
 	.hal_umac_ce1_src_reg_base = 0x01b82000,
 	.hal_umac_ce1_dest_reg_base = 0x01b83000,
+
+	.gcc_gcc_pcie_hot_rst = 0x1e38338,
 };
 
 static const struct ath12k_hw_regs wcn7850_regs = {
@@ -860,6 +864,8 @@ static const struct ath12k_hw_regs wcn7850_regs = {
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
index 1068cc07bc9f6..26f4b440c26d2 100644
--- a/drivers/net/wireless/ath/ath12k/pci.c
+++ b/drivers/net/wireless/ath/ath12k/pci.c
@@ -290,10 +290,10 @@ static void ath12k_pci_enable_ltssm(struct ath12k_base *ab)
 
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



