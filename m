Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A19A4FD290;
	Tue, 13 Oct 2026 12:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893220; cv=none; b=WuJ7WZ4+kPsvy0sT6CSkphOiwlKR9Xm95UANqHJihGqzBI9knlc2DfK7i0Fp7x73ErVuYAEwQBAKZFuCYRJSHfzvBoEDIwfxX4dfpEB3GDFL2oLZgpvRVMmDGHsSkgN6IdUz09NJ/Q7Kw7eWg8jck8TjVB6RZCrjX0e2RIK1cHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893220; c=relaxed/simple;
	bh=q/FPKU3yy4kMsMxF74urb3n0h6TSSOHz8DbDE+97Ods=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DIyrdAlCjJKKTlKeFoOYhbjDhvBRWC/xbpsdUVcTCYit1caYwPTd/lZDTFhmNTY/otF9rxW8wEpeBZ+1RdIif+12+ZH4G45mR1s2Jmw09LjM/75FdVa7V5cbJ9PgjmBF0cvDEryIOqacT8rSQ5LjafwBmMFJC/jKu1PRg8OeT4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RG0I14lR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RG0I14lR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B21471F00893;
	Tue, 13 Oct 2026 12:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893219;
	bh=NTZhKfO6/RT1mqqMAo9iMhsAnsjsOkLSCelfF71+n00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RG0I14lRLVFA8+WJV/BTIe7oCexA1nE5TxhQaG1GUC0SW6PekMjFbA1G7Yb17A8Jb
	 5rav6le3wZHxHE2DzI+p79lcP5hQ5z9Or32UFhtDjo0W+L67kHJa8syRlI7T1F10rz
	 k8UsdEuy4N1QeXBQpkxFcE9Uw3Gaq4CyVeWXRmts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 151/621] accel/amdxdna: Add hardware specific attributes
Date: Tue, 13 Oct 2026 13:32:26 +0200
Message-ID: <20261013112924.437410497@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit c48f1f459e4227abbb88271e2717235de575b22e ]

Add three hardware specific attributes to describe device capabilities:
  hwctx_limit: The maximum number of hardware context supported.
  max_tops: The maximum TOPS supported.
  curr_tops: The TOPS achievable with the current power and frequency
             configuration.

Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20251104062546.833771-1-lizhi.hou@amd.com
Stable-dep-of: 97f27573837e ("accel/amdxdna: Fix potential NULL pointer dereference in context cleanup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/aie2_pci.h  |  3 +++
 drivers/accel/amdxdna/aie2_smu.c  | 11 +++++++++++
 drivers/accel/amdxdna/npu1_regs.c |  1 +
 drivers/accel/amdxdna/npu2_regs.c |  1 +
 drivers/accel/amdxdna/npu4_regs.c |  1 +
 drivers/accel/amdxdna/npu5_regs.c |  1 +
 drivers/accel/amdxdna/npu6_regs.c |  1 +
 7 files changed, 19 insertions(+)

diff --git a/drivers/accel/amdxdna/aie2_pci.h b/drivers/accel/amdxdna/aie2_pci.h
index 289a23ecd5f13..12fec3cf8c8db 100644
--- a/drivers/accel/amdxdna/aie2_pci.h
+++ b/drivers/accel/amdxdna/aie2_pci.h
@@ -182,6 +182,8 @@ struct amdxdna_dev_hdl {
 	u32				clk_gating;
 	u32				npuclk_freq;
 	u32				hclk_freq;
+	u32				max_tops;
+	u32				curr_tops;
 
 	/* Mailbox and the management channel */
 	struct mailbox			*mbox;
@@ -217,6 +219,7 @@ struct amdxdna_dev_priv {
 	u32				mbox_dev_addr;
 	/* If mbox_size is 0, use BAR size. See MBOX_SIZE macro */
 	u32				mbox_size;
+	u32				hwctx_limit;
 	u32				sram_dev_addr;
 	struct aie2_bar_off_pair	sram_offs[SRAM_MAX_INDEX];
 	struct aie2_bar_off_pair	psp_regs_off[PSP_MAX_REGS];
diff --git a/drivers/accel/amdxdna/aie2_smu.c b/drivers/accel/amdxdna/aie2_smu.c
index 7f292a615ed88..11c0e9e7b03aa 100644
--- a/drivers/accel/amdxdna/aie2_smu.c
+++ b/drivers/accel/amdxdna/aie2_smu.c
@@ -23,6 +23,13 @@
 #define AIE2_SMU_SET_SOFT_DPMLEVEL	0x7
 #define AIE2_SMU_SET_HARD_DPMLEVEL	0x8
 
+#define NPU4_DPM_TOPS(ndev, dpm_level) \
+({ \
+	typeof(ndev) _ndev = ndev; \
+	(4096 * (_ndev)->total_col * \
+	 (_ndev)->priv->dpm_clk_tbl[dpm_level].hclk / 1000000); \
+})
+
 static int aie2_smu_exec(struct amdxdna_dev_hdl *ndev, u32 reg_cmd,
 			 u32 reg_arg, u32 *out)
 {
@@ -84,6 +91,8 @@ int npu1_set_dpm(struct amdxdna_dev_hdl *ndev, u32 dpm_level)
 	amdxdna_pm_suspend_put(ndev->xdna);
 	ndev->hclk_freq = freq;
 	ndev->dpm_level = dpm_level;
+	ndev->max_tops = 2 * ndev->total_col;
+	ndev->curr_tops = ndev->max_tops * freq / 1028;
 
 	XDNA_DBG(ndev->xdna, "MP-NPU clock %d, H clock %d\n",
 		 ndev->npuclk_freq, ndev->hclk_freq);
@@ -121,6 +130,8 @@ int npu4_set_dpm(struct amdxdna_dev_hdl *ndev, u32 dpm_level)
 	ndev->npuclk_freq = ndev->priv->dpm_clk_tbl[dpm_level].npuclk;
 	ndev->hclk_freq = ndev->priv->dpm_clk_tbl[dpm_level].hclk;
 	ndev->dpm_level = dpm_level;
+	ndev->max_tops = NPU4_DPM_TOPS(ndev, ndev->max_dpm_level);
+	ndev->curr_tops = NPU4_DPM_TOPS(ndev, dpm_level);
 
 	XDNA_DBG(ndev->xdna, "MP-NPU clock %d, H clock %d\n",
 		 ndev->npuclk_freq, ndev->hclk_freq);
diff --git a/drivers/accel/amdxdna/npu1_regs.c b/drivers/accel/amdxdna/npu1_regs.c
index e4f6dac7d00fd..8edee15076b02 100644
--- a/drivers/accel/amdxdna/npu1_regs.c
+++ b/drivers/accel/amdxdna/npu1_regs.c
@@ -72,6 +72,7 @@ static const struct amdxdna_dev_priv npu1_dev_priv = {
 	.mbox_dev_addr  = NPU1_MBOX_BAR_BASE,
 	.mbox_size      = 0, /* Use BAR size */
 	.sram_dev_addr  = NPU1_SRAM_BAR_BASE,
+	.hwctx_limit    = 6,
 	.sram_offs      = {
 		DEFINE_BAR_OFFSET(MBOX_CHANN_OFF, NPU1_SRAM, MPNPU_SRAM_X2I_MAILBOX_0),
 		DEFINE_BAR_OFFSET(FW_ALIVE_OFF,   NPU1_SRAM, MPNPU_SRAM_I2X_MAILBOX_15),
diff --git a/drivers/accel/amdxdna/npu2_regs.c b/drivers/accel/amdxdna/npu2_regs.c
index a081cac75ee0c..050e2c20dccb4 100644
--- a/drivers/accel/amdxdna/npu2_regs.c
+++ b/drivers/accel/amdxdna/npu2_regs.c
@@ -71,6 +71,7 @@ static const struct amdxdna_dev_priv npu2_dev_priv = {
 	.mbox_dev_addr  = NPU2_MBOX_BAR_BASE,
 	.mbox_size      = 0, /* Use BAR size */
 	.sram_dev_addr  = NPU2_SRAM_BAR_BASE,
+	.hwctx_limit    = 16,
 	.sram_offs      = {
 		DEFINE_BAR_OFFSET(MBOX_CHANN_OFF, NPU2_SRAM, MPNPU_SRAM_X2I_MAILBOX_0),
 		DEFINE_BAR_OFFSET(FW_ALIVE_OFF,   NPU2_SRAM, MPNPU_SRAM_X2I_MAILBOX_15),
diff --git a/drivers/accel/amdxdna/npu4_regs.c b/drivers/accel/amdxdna/npu4_regs.c
index 9f2e33182ec6f..00303c36b3027 100644
--- a/drivers/accel/amdxdna/npu4_regs.c
+++ b/drivers/accel/amdxdna/npu4_regs.c
@@ -92,6 +92,7 @@ static const struct amdxdna_dev_priv npu4_dev_priv = {
 	.mbox_dev_addr  = NPU4_MBOX_BAR_BASE,
 	.mbox_size      = 0, /* Use BAR size */
 	.sram_dev_addr  = NPU4_SRAM_BAR_BASE,
+	.hwctx_limit    = 16,
 	.sram_offs      = {
 		DEFINE_BAR_OFFSET(MBOX_CHANN_OFF, NPU4_SRAM, MPNPU_SRAM_X2I_MAILBOX_0),
 		DEFINE_BAR_OFFSET(FW_ALIVE_OFF,   NPU4_SRAM, MPNPU_SRAM_X2I_MAILBOX_15),
diff --git a/drivers/accel/amdxdna/npu5_regs.c b/drivers/accel/amdxdna/npu5_regs.c
index 5f1cf83461c46..b6999490020e8 100644
--- a/drivers/accel/amdxdna/npu5_regs.c
+++ b/drivers/accel/amdxdna/npu5_regs.c
@@ -71,6 +71,7 @@ static const struct amdxdna_dev_priv npu5_dev_priv = {
 	.mbox_dev_addr  = NPU5_MBOX_BAR_BASE,
 	.mbox_size      = 0, /* Use BAR size */
 	.sram_dev_addr  = NPU5_SRAM_BAR_BASE,
+	.hwctx_limit    = 16,
 	.sram_offs      = {
 		DEFINE_BAR_OFFSET(MBOX_CHANN_OFF, NPU5_SRAM, MPNPU_SRAM_X2I_MAILBOX_0),
 		DEFINE_BAR_OFFSET(FW_ALIVE_OFF,   NPU5_SRAM, MPNPU_SRAM_X2I_MAILBOX_15),
diff --git a/drivers/accel/amdxdna/npu6_regs.c b/drivers/accel/amdxdna/npu6_regs.c
index 94a7005685a7b..27fda4da2f811 100644
--- a/drivers/accel/amdxdna/npu6_regs.c
+++ b/drivers/accel/amdxdna/npu6_regs.c
@@ -71,6 +71,7 @@ static const struct amdxdna_dev_priv npu6_dev_priv = {
 	.mbox_dev_addr  = NPU6_MBOX_BAR_BASE,
 	.mbox_size      = 0, /* Use BAR size */
 	.sram_dev_addr  = NPU6_SRAM_BAR_BASE,
+	.hwctx_limit    = 16,
 	.sram_offs      = {
 		DEFINE_BAR_OFFSET(MBOX_CHANN_OFF, NPU6_SRAM, MPNPU_SRAM_X2I_MAILBOX_0),
 		DEFINE_BAR_OFFSET(FW_ALIVE_OFF,   NPU6_SRAM, MPNPU_SRAM_X2I_MAILBOX_15),
-- 
2.53.0



